import 'dart:async';
import 'dart:io';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:logger/logger.dart';

import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/features/premium/constants/product_ids.dart';
import 'package:the_accountant/features/premium/services/purchases/purchase_mapping.dart';

export 'package:the_accountant/features/premium/services/purchases/purchase_mapping.dart'
    show PurchaseFlowStatus;

/// Product IDs for premium subscriptions (delegates to TheAccountantProducts)
class PremiumProductIds {
  static String get monthly => TheAccountantProducts.monthly;
  static String get yearly => TheAccountantProducts.yearly;
  static String get lifetime => TheAccountantProducts.lifetime;

  static Set<String> get all => TheAccountantProducts.allProductIds;

  /// The two recurring plans, queried from the store as `subs`.
  static List<String> get subscriptions => [monthly, yearly];

  /// The one-time unlock, queried as `in-app`.
  static List<String> get oneTime => [lifetime];
}

/// In-app purchases, over OpenIAP (`flutter_inapp_purchase`).
///
/// The shape of the flow is fixed by the store, not by us:
///
/// 1. attach both listeners, then open the connection;
/// 2. ask for products — one call for subscriptions, one for one-time items;
/// 3. `requestPurchase` returns nothing useful; the outcome arrives on a
///    listener, possibly minutes later, possibly after a restart;
/// 4. a purchased receipt is verified by our backend, then granted, then
///    finished;
/// 5. on resume and after sign-in, every owned purchase is run through (4)
///    again, because that is the only way a payment that cleared while the app
///    was closed — or a verification that failed while we were offline — ever
///    gets picked up.
///
/// Two rules carry real money. **Never finish a pending purchase**: it has not
/// been paid for. And **do finish one the backend could not vouch for**, since
/// Play refunds anything left unacknowledged for three days and a network blip
/// is not a reason to take somebody's purchase away.
class IAPService {
  final FlutterInappPurchase _iap = FlutterInappPurchase.instance;
  final ApiService _apiService;
  final Logger _logger = Logger();

  StreamSubscription<Purchase>? _purchaseSub;
  StreamSubscription<PurchaseError>? _errorSub;

  final Map<String, ProductCommon> _products = {};

  /// Identities already verified and granted this session. Purposely in memory:
  /// a cold start re-verifies, which is what recovers a grant the backend never
  /// heard about. See [VerifyOutcome.transient].
  final Set<String> _delivered = {};

  /// Identities currently being fulfilled. The billing sheet closing *is* an
  /// app resume, so the stream event and the resume reconcile see the same
  /// fresh purchase within a second of each other; without this they both
  /// verify it.
  final Set<String> _fulfilling = {};

  /// Purchases the store completed that the backend could not check.
  ///
  /// The money has moved and the transaction is acknowledged, so the user owns
  /// this whatever our server thinks. Premium is granted on the strength of
  /// that until verification succeeds (which clears the entry) or the backend
  /// looks at the receipt and says no (which also clears it). Empty is the
  /// normal state.
  final Set<String> _provisional = {};

  /// Whether anything is being honoured ahead of verification.
  bool get hasProvisionalGrant => _provisional.isNotEmpty;

  /// Set while the user is explicitly restoring, so fulfilment can report
  /// [PurchaseFlowStatus.restored] rather than a fresh purchase.
  bool _restoring = false;

  // Callbacks
  void Function(PurchaseFlowStatus status, String? error)? onPurchaseUpdate;
  void Function(bool isPremium, String? tier, DateTime? expiresAt)?
  onSubscriptionUpdate;

  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  /// The account tag sent to the store with a purchase, so Play's server
  /// notifications can be traced back to a user. Set by the provider once the
  /// user is known.
  String? accountId;

  IAPService({required this._apiService});

  /// Open the store connection and load what is for sale.
  Future<void> initialize() async {
    // Both listeners go on before the connection opens. A purchase completed
    // while the app was dead is replayed the moment the connection comes up,
    // and a listener attached afterwards would miss it.
    _purchaseSub = _iap.purchaseUpdatedListener.listen(
      (purchase) => unawaited(_onPurchaseUpdated(purchase)),
      onError: (Object e) => _logger.e('IAP purchase stream error: $e'),
    );
    _errorSub = _iap.purchaseErrorListener.listen(
      _onPurchaseError,
      onError: (Object e) => _logger.e('IAP error stream error: $e'),
    );

    try {
      _isAvailable = await _iap.initConnection().timeout(
        const Duration(seconds: 10),
      );
    } catch (e) {
      // A device with no Play Store, a sideloaded build, a timeout. Not fatal:
      // the rest of the app works, the paywall just says it cannot sell today.
      _isAvailable = false;
      _logger.w('IAP connection unavailable: $e');
      return;
    }

    if (!_isAvailable) {
      _logger.w('IAP is not available on this device');
      return;
    }

    await loadProducts();
    _logger.i('IAP service initialized');
  }

  /// Ask the store about both kinds of product.
  ///
  /// Two calls, not one: OpenIAP queries subscriptions and one-time items
  /// separately, and a single `All` query does not return the subscription
  /// offer details that an Android purchase needs.
  Future<void> loadProducts() async {
    if (!_isAvailable) return;

    try {
      final results = await Future.wait([
        _iap.fetchProducts<ProductSubscription>(
          skus: PremiumProductIds.subscriptions,
          type: ProductQueryType.Subs,
        ),
        _iap.fetchProducts<Product>(
          skus: PremiumProductIds.oneTime,
          type: ProductQueryType.InApp,
        ),
      ]);

      _products
        ..clear()
        ..addEntries(
          results.expand((list) => list).map((p) => MapEntry(p.id, p)),
        );

      final missing = PremiumProductIds.all.difference(_products.keys.toSet());
      if (missing.isNotEmpty) _logger.w('Products not found: $missing');

      _logger.i('Loaded ${_products.length} products');
    } catch (e, stack) {
      _logger.e('Error loading products: $e', error: e, stackTrace: stack);
    }
  }

  List<ProductCommon> get products => _products.values.toList();

  ProductCommon? getProduct(String productId) => _products[productId];

  /// Start the store's purchase flow for [productId].
  ///
  /// Returns whether the sheet was asked for, which is all that can be known
  /// here — whether it was paid for arrives on the listeners.
  Future<bool> purchase(String productId) async {
    if (!_isAvailable) {
      _logger.w('IAP not available');
      onPurchaseUpdate?.call(PurchaseFlowStatus.error, 'IAP not available');
      return false;
    }

    final product = _products[productId];
    if (product == null) {
      _logger.w('Product not found: $productId');
      onPurchaseUpdate?.call(PurchaseFlowStatus.error, 'Product not found');
      return false;
    }

    try {
      final props = product is ProductSubscription
          ? await _subscriptionRequest(product)
          : _oneTimeRequest(productId);
      if (props == null) {
        onPurchaseUpdate?.call(
          PurchaseFlowStatus.error,
          'This plan is not available on your account right now',
        );
        return false;
      }

      await _iap.requestPurchase(props);
      return true;
    } catch (e) {
      _logger.e('Purchase error: $e');
      onPurchaseUpdate?.call(PurchaseFlowStatus.error, e.toString());
      return false;
    }
  }

  RequestPurchaseProps _oneTimeRequest(String productId) =>
      RequestPurchaseProps.inApp((
        apple: RequestPurchaseIosProps(
          sku: productId,
          appAccountToken: isValidAppleAccountToken(accountId)
              ? accountId
              : null,
        ),
        google: RequestPurchaseAndroidProps(
          skus: [productId],
          obfuscatedAccountId: accountId,
        ),
      ));

  /// Build a subscription request, including the plan switch when the user is
  /// already subscribed to the other one.
  Future<RequestPurchaseProps?> _subscriptionRequest(
    ProductSubscription product,
  ) async {
    AndroidSubscriptionOfferInput? offer;
    if (product is ProductSubscriptionAndroid) {
      final picked = pickAndroidOffer(product);
      // Play rejects a subscription request with no offer token. It happens
      // when the user is eligible for nothing — a plan they already hold on
      // another account, say — and is worth saying so rather than throwing.
      if (picked?.offerTokenAndroid == null) return null;
      offer = AndroidSubscriptionOfferInput(
        sku: product.id,
        offerToken: picked!.offerTokenAndroid!,
      );
    }

    // Moving between monthly and yearly is a replacement, not a second
    // subscription; without the old token Play would happily sell both.
    final existing = await _currentSubscriptionOtherThan(product.id);

    return RequestPurchaseProps.subs((
      apple: RequestSubscriptionIosProps(
        sku: product.id,
        appAccountToken: isValidAppleAccountToken(accountId) ? accountId : null,
      ),
      google: RequestSubscriptionAndroidProps(
        skus: [product.id],
        obfuscatedAccountId: accountId,
        subscriptionOffers: offer == null ? null : [offer],
        purchaseToken: existing?.purchaseTokenAndroid,
        subscriptionProductReplacementParams: existing == null
            ? null
            : SubscriptionProductReplacementParamsAndroid(
                oldProductId: existing.productId,
                // The new plan starts now and the unused part of the old one is
                // credited, which is the only option that does not either
                // charge twice or hand out free time.
                replacementMode:
                    SubscriptionReplacementModeAndroid.WithTimeProration,
              ),
      ),
    ));
  }

  Future<ActiveSubscription?> _currentSubscriptionOtherThan(
    String productId,
  ) async {
    try {
      final active = await _iap.getActiveSubscriptions(
        PremiumProductIds.subscriptions,
      );
      return active
          .where((s) => s.isActive && s.productId != productId)
          .firstOrNull;
    } catch (e) {
      // Not knowing about an old subscription is survivable — Play will refuse
      // an outright duplicate. Failing the purchase over it is not.
      _logger.w('Could not read active subscriptions: $e');
      return null;
    }
  }

  /// Re-check everything the store says this user owns.
  ///
  /// This is the app's recovery path, and it does four jobs at once: it picks
  /// up a purchase that completed while the app was closed, a deferred payment
  /// that has since cleared, a grant whose verification failed while offline,
  /// and a restore on a new device.
  Future<void> reconcileStoreState() async {
    if (!_isAvailable) return;

    try {
      final owned = await _iap.getAvailablePurchases();
      for (final purchase in owned) {
        if (purchase.purchaseState == PurchaseState.Purchased) {
          await _fulfil(purchase);
        }
      }
    } catch (e) {
      _logger.w('Could not reconcile store state: $e');
    }
  }

  /// Restore previous purchases, for the button that says so.
  Future<void> restorePurchases() async {
    if (!_isAvailable) {
      _logger.w('IAP not available');
      onPurchaseUpdate?.call(PurchaseFlowStatus.error, 'IAP not available');
      return;
    }

    _restoring = true;
    try {
      // On Android this is a no-op and nothing is re-emitted on the stream;
      // the purchases come back from `getAvailablePurchases` below. On iOS it
      // is `AppStore.sync`, which is what makes a fresh device see them at all.
      await _iap.restorePurchases();
      await reconcileStoreState();
      _logger.i('Restore purchases completed');
    } catch (e) {
      _logger.e('Restore error: $e');
      onPurchaseUpdate?.call(
        PurchaseFlowStatus.error,
        'Failed to restore purchases',
      );
    } finally {
      _restoring = false;
    }
  }

  Future<void> _onPurchaseUpdated(Purchase purchase) async {
    _logger.d(
      'Purchase update: ${purchase.productId} - ${purchase.purchaseState}',
    );

    switch (purchase.purchaseState) {
      case PurchaseState.Pending:
        // Money has not moved. Granting here would hand out a subscription for
        // a payment that may never clear, and finishing it would tell Play the
        // item was delivered. Neither. It comes back on a later reconcile.
        onPurchaseUpdate?.call(PurchaseFlowStatus.pending, null);
      case PurchaseState.Purchased:
        await _fulfil(purchase);
      case PurchaseState.Unknown:
        onPurchaseUpdate?.call(PurchaseFlowStatus.error, 'Purchase failed');
    }
  }

  void _onPurchaseError(PurchaseError error) {
    final status = statusForError(error);
    _logger.w('Purchase error (${error.code}): ${error.message}');
    onPurchaseUpdate?.call(
      status,
      status == PurchaseFlowStatus.canceled ? null : error.message,
    );
  }

  /// Verify, grant, and finish — in that order, which is the order that matters.
  Future<void> _fulfil(Purchase purchase) async {
    if (purchase is PurchaseAndroid && purchase.isSuspendedAndroid == true) {
      // The user's payment method failed and Play is holding the subscription.
      // It is still "purchased", and it still must not unlock anything until
      // they fix it. `getAvailablePurchases` excludes these by default; this
      // covers one arriving on the stream.
      _logger.w(
        'Subscription ${purchase.productId} is suspended; not granting',
      );
      return;
    }

    final identity = purchaseIdentity(purchase);
    if (identity != null && !_fulfilling.add(identity)) return;

    try {
      if (identity != null && _delivered.contains(identity)) {
        await _finish(purchase);
        return;
      }

      final payload = backendPayloadFor(purchase);
      if (payload == null) {
        _logger.w('Purchase ${purchase.productId} carries no token to verify');
        onPurchaseUpdate?.call(PurchaseFlowStatus.error, 'Verification failed');
        return;
      }

      final outcome = await _verify(payload);
      switch (outcome) {
        case VerifyOutcome.rejected:
          _logger.w('Purchase rejected by backend: ${purchase.productId}');
          if (identity != null) _provisional.remove(identity);
          onPurchaseUpdate?.call(
            PurchaseFlowStatus.error,
            'Verification failed',
          );
          // Android: leave it unfinished on purpose. Play refunds it in three
          // days, which is the right outcome for something we would not honour.
          // iOS replays unfinished transactions forever, so finish there.
          if (Platform.isIOS) await _finish(purchase);
          return;

        case VerifyOutcome.pending:
          // The store has it, the money has not moved. Nothing to grant, and
          // nothing to finish: finishing says "delivered" for something unpaid.
          _logger.i('Purchase of ${purchase.productId} is awaiting payment');
          onPurchaseUpdate?.call(PurchaseFlowStatus.pending, null);
          return;

        case VerifyOutcome.transient:
          // Grant and finish, but do not record it as delivered: the next
          // reconcile verifies it again, and keeps doing so until an answer
          // arrives. Until then this grant is ours, not the server's — the
          // server will go on reporting the user as free, and something has to
          // stop that answer taking away a plan they have paid for.
          _logger.w('Verification unavailable; granting ${purchase.productId}');
          if (identity != null) _provisional.add(identity);
          onSubscriptionUpdate?.call(true, purchase.productId, null);
          onPurchaseUpdate?.call(_completionStatus, null);

        case VerifyOutcome.granted:
          if (identity != null) {
            _delivered.add(identity);
            _provisional.remove(identity);
          }
          onPurchaseUpdate?.call(_completionStatus, null);
      }

      await _finish(purchase);
    } finally {
      if (identity != null) _fulfilling.remove(identity);
    }
  }

  PurchaseFlowStatus get _completionStatus =>
      _restoring ? PurchaseFlowStatus.restored : PurchaseFlowStatus.purchased;

  /// Acknowledge or consume, so Play stops counting down to a refund.
  Future<void> _finish(Purchase purchase) async {
    final consumable = isConsumableProduct(purchase.productId);

    // The backend acknowledges Android purchases itself when it verifies them.
    // Asking Play to acknowledge one twice is an error, so skip it when the
    // store already says it is done.
    if (!consumable &&
        purchase is PurchaseAndroid &&
        purchase.isAcknowledgedAndroid == true) {
      return;
    }

    try {
      await _iap.finishTransaction(
        purchase: purchase,
        isConsumable: consumable,
      );
    } catch (e) {
      _logger.e('Could not finish transaction ${purchase.productId}: $e');
    }
  }

  /// Ask our backend whether the store really sold this.
  Future<VerifyOutcome> _verify(Map<String, dynamic> payload) async {
    Map<String, dynamic>? body;
    var threw = false;

    try {
      final response = await _apiService.post('/iap/verify', data: payload);
      final data = response.data;
      body = data is Map ? data.cast<String, dynamic>() : null;
      if (body == null) threw = true;
    } catch (e, stack) {
      threw = true;
      _logger.e('Verification error: $e', error: e, stackTrace: stack);
    }

    final outcome = classifyVerifyResponse(threw: threw, body: body);

    if (outcome == VerifyOutcome.granted) {
      onSubscriptionUpdate?.call(
        true,
        _mapTierToProductId(body?['new_tier']?.toString()),
        body?['expires_at'] != null
            ? DateTime.tryParse(body!['expires_at'].toString())
            : null,
      );
      _logger.i('Purchase verified successfully');
    } else if (outcome == VerifyOutcome.rejected) {
      _logger.w('Purchase verification failed: ${body?['error']}');
    }

    return outcome;
  }

  /// Check current subscription status from backend
  Future<SubscriptionStatus> checkSubscriptionStatus() async {
    try {
      final response = await _apiService.get('/iap/subscription-status');
      final data = response.data;

      // Calculate days remaining if expires_at is present
      int? daysRemaining;
      DateTime? expiresAt;
      if (data['expires_at'] != null) {
        expiresAt = DateTime.parse(data['expires_at']);
        daysRemaining = expiresAt.difference(DateTime.now()).inDays;
        if (daysRemaining < 0) daysRemaining = 0;
      }

      // Parse grace period
      DateTime? gracePeriodEndsAt;
      if (data['grace_period_ends_at'] != null) {
        gracePeriodEndsAt = DateTime.parse(data['grace_period_ends_at']);
      }
      final isInGracePeriod = data['is_in_grace_period'] == true;

      return SubscriptionStatus(
        isPremium: data['is_premium'] == true,
        tier: _mapTierToProductId(data['tier']?.toString()),
        expiresAt: expiresAt,
        daysRemaining: daysRemaining,
        gracePeriodEndsAt: gracePeriodEndsAt,
        isInGracePeriod: isInGracePeriod,
      );
    } catch (e) {
      _logger.e('Error checking subscription status: $e');
      // Unconfirmed: the request failed, so this is a fallback, not a real
      // "you're free" answer. `confirmed: false` tells the sync bridge to keep
      // whatever premium state is already cached instead of downgrading.
      return SubscriptionStatus(isPremium: false, confirmed: false);
    }
  }

  /// Map backend SubscriptionTier enum (serialized as snake_case) to a platform-aware product ID.
  /// Tolerates both snake_case (current) and PascalCase (legacy) for defensive parsing.
  String? _mapTierToProductId(String? backendTier) {
    if (backendTier == null) return null;
    switch (backendTier) {
      case 'premium_monthly':
      case 'PremiumMonthly':
        return PremiumProductIds.monthly;
      case 'premium_yearly':
      case 'PremiumYearly':
        return PremiumProductIds.yearly;
      case 'premium_lifetime':
      case 'PremiumLifetime':
        return PremiumProductIds.lifetime;
      default:
        return null;
    }
  }

  /// Dispose resources
  void dispose() {
    unawaited(_purchaseSub?.cancel());
    unawaited(_errorSub?.cancel());
    unawaited(_iap.endConnection().catchError((Object _) => false));
  }
}

/// Subscription status from backend
class SubscriptionStatus {
  final bool isPremium;
  final String? tier;
  final DateTime? expiresAt;
  final int? daysRemaining;
  final DateTime? gracePeriodEndsAt;
  final bool isInGracePeriod;

  /// True when this status reflects a real answer from the backend. False when
  /// the request failed and the values are just a safe fallback — callers must
  /// NOT downgrade a cached-premium user off an unconfirmed result.
  final bool confirmed;

  SubscriptionStatus({
    required this.isPremium,
    this.tier,
    this.expiresAt,
    this.daysRemaining,
    this.gracePeriodEndsAt,
    this.isInGracePeriod = false,
    this.confirmed = true,
  });

  bool get isLifetime =>
      tier != null && tier!.toLowerCase().contains('lifetime');
  bool get isExpiringSoon => daysRemaining != null && daysRemaining! <= 7;

  String get tierDisplayName {
    if (tier == null) return 'Free';
    return TheAccountantProducts.getTierDisplayName(tier!);
  }
}

/// Product info for display
class PremiumProduct {
  final ProductCommon details;

  PremiumProduct(this.details);

  String get id => details.id;
  String get title => details.title;
  String get description => details.description;

  /// The recurring price, not the trial price. See [displayPriceFor].
  String get price => displayPriceFor(details);

  /// "7 days", when the plan opens with a free trial.
  String? get freeTrial => freeTrialLabelFor(details);

  String get displayTitle {
    final lower = id.toLowerCase();
    if (lower.contains('monthly')) return 'Monthly';
    if (lower.contains('yearly')) return 'Yearly';
    if (lower.contains('lifetime')) return 'Lifetime';
    return title;
  }

  String? get savings => TheAccountantProducts.getSavingsText(id);

  bool get isRecommended => id.toLowerCase().contains('yearly');
}

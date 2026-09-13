import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

/// Pure translation between OpenIAP's types and this app's backend contract.
///
/// Nothing here talks to the store or the network, which is the point: the
/// rules that decide whether somebody keeps their money are the rules worth
/// testing, and a file that needs a billing connection to run cannot be.
/// [IAPService] holds the plumbing and defers every judgement to this file.

/// Where a purchase ended up, from the app's point of view.
///
/// Replaces `PurchaseStatus` from `in_app_purchase`. OpenIAP has no `restored`
/// of its own — restoring is a query (`getAvailablePurchases`), not an event —
/// so the service tags a fulfilment as [restored] when the user asked for one.
enum PurchaseFlowStatus { pending, purchased, restored, error, canceled }

/// What the backend said about a receipt.
enum VerifyOutcome {
  /// The backend verified it with the store. Grant, and remember that we did.
  granted,

  /// The backend could not answer — offline, 5xx, expired token. The purchase
  /// is probably real and Play refunds anything left unacknowledged for three
  /// days, so grant and finish, but do **not** record it as delivered: the next
  /// `getAvailablePurchases()` reconcile will put the same receipt back through
  /// verification. Owned subscriptions and non-consumables come back from that
  /// call forever, which makes it a better retry queue than a file we maintain.
  transient,

  /// The backend verified it and says no. Grant nothing.
  rejected,
}

/// Whether [productId] is consumed on purchase rather than owned.
///
/// Nothing this app sells is: the two subscriptions renew and the lifetime
/// unlock is a one-time non-consumable. It is asked as a question anyway
/// because `finishTransaction` needs the answer, and consuming a subscription
/// by mistake would sell it to the same person twice.
bool isConsumableProduct(String productId) => false;

/// The identity used to remember that a purchase has already been delivered.
///
/// Android's order id is what the old plugin exposed as `purchaseID`, so it is
/// the identity that keeps any previously persisted set meaningful. It is null
/// while a purchase is pending, hence the fall back to the token — `id` on
/// `PurchaseAndroid` is already `orderId ?? purchaseToken`.
String? purchaseIdentity(Purchase purchase) => switch (purchase) {
  PurchaseAndroid() => purchase.id,
  PurchaseIOS() => purchase.transactionId,
};

/// The body for `POST /iap/verify`, or null when the purchase carries nothing
/// the backend could check.
///
/// The wire contract is unchanged from the `in_app_purchase` days. What changed
/// underneath is what `purchaseToken` holds on iOS: StoreKit 2's signed
/// transaction (JWS) rather than the old base64 app receipt.
Map<String, dynamic>? backendPayloadFor(Purchase purchase) {
  final token = purchase.purchaseToken;
  if (token == null || token.isEmpty) return null;

  return {
    'platform': purchase is PurchaseIOS ? 'ios' : 'android',
    'product_id': purchase.productId,
    'purchase_token': token,
    // Play has no order id until the payment clears; the backend keys on the
    // token in that case, so an empty string is the honest value rather than a
    // placeholder that could collide.
    'order_id': switch (purchase) {
      PurchaseAndroid() => purchase.transactionId ?? '',
      PurchaseIOS() => purchase.transactionId,
    },
  };
}

/// Read the verdict out of a `/iap/verify` response body.
///
/// The endpoint answers 200 for both outcomes — `success: false` carries the
/// reason in `error` — so a thrown request (offline, 401, 5xx) is the only
/// transient signal, and callers pass [threw] for it.
VerifyOutcome classifyVerifyResponse({
  required bool threw,
  Map<String, dynamic>? body,
}) {
  if (threw || body == null) return VerifyOutcome.transient;
  return body['success'] == true
      ? VerifyOutcome.granted
      : VerifyOutcome.rejected;
}

/// The offer to buy an Android subscription with.
///
/// `requestPurchase` for a subscription without an offer token is a developer
/// error on the native side, so this must find one. Play only returns offers
/// the user is actually eligible for, which is what makes "prefer the free
/// trial" safe: if they have used it already, it is not in the list.
///
/// Preference order: a free-trial offer, then the base plan, then whatever came
/// first.
SubscriptionOffer? pickAndroidOffer(ProductSubscriptionAndroid product) {
  final offers = product.subscriptionOffers
      .where((o) => o.offerTokenAndroid != null)
      .toList();
  if (offers.isEmpty) return null;

  final trial = offers.where(_hasFreeTrialPhase).firstOrNull;
  if (trial != null) return trial;

  final basePlan = offers
      .where((o) => o.id.isEmpty || o.id == o.basePlanIdAndroid)
      .firstOrNull;
  return basePlan ?? offers.first;
}

/// Whether [offer] opens with a phase that costs nothing and does not recur
/// forever — which is what a free trial looks like in Play's pricing phases.
bool _hasFreeTrialPhase(SubscriptionOffer offer) {
  final phases = offer.pricingPhasesAndroid?.pricingPhaseList ?? const [];
  return phases.any(
    // recurrenceMode 1 is "infinite", i.e. the ongoing price. A zero-priced
    // phase that is *not* infinite is an introductory or trial period.
    (p) => p.priceAmountMicros == '0' && p.recurrenceMode != 1,
  );
}

/// The price to show for [product] on the paywall.
///
/// A subscription's own `displayPrice` reads as free when a trial phase comes
/// first, which would advertise a price nobody is going to be charged. The
/// recurring price is the last phase that costs something.
String displayPriceFor(ProductCommon product) {
  if (product is! ProductSubscriptionAndroid) return product.displayPrice;

  final offer = pickAndroidOffer(product);
  final phases = offer?.pricingPhasesAndroid?.pricingPhaseList ?? const [];
  final paid = phases.where((p) => p.priceAmountMicros != '0').toList();
  if (paid.isEmpty) return product.displayPrice;
  return paid.last.formattedPrice;
}

/// The trial length to advertise for [product], or null when there is none.
String? freeTrialLabelFor(ProductCommon product) {
  if (product is! ProductSubscriptionAndroid) return null;

  final offer = pickAndroidOffer(product);
  final phases = offer?.pricingPhasesAndroid?.pricingPhaseList ?? const [];
  final trial = phases
      .where((p) => p.priceAmountMicros == '0' && p.recurrenceMode != 1)
      .firstOrNull;
  if (trial == null) return null;
  return describeIsoPeriod(trial.billingPeriod);
}

/// Turn an ISO-8601 duration as Play writes it (`P1W`, `P3D`, `P1M`) into
/// something a person reads. Returns null for anything unrecognised rather
/// than showing the raw code.
String? describeIsoPeriod(String period) {
  final match = RegExp(r'^P(\d+)([DWMY])$').firstMatch(period);
  if (match == null) return null;

  final count = int.parse(match.group(1)!);
  final unit = switch (match.group(2)!) {
    'D' => 'day',
    'W' => 'week',
    'M' => 'month',
    _ => 'year',
  };
  return count == 1 ? '1 $unit' : '$count ${unit}s';
}

/// Whether [userId] may be handed to Apple as an `appAccountToken`.
///
/// The OpenIAP Apple module throws on anything that is not a UUID, where Apple
/// itself would have dropped it quietly. Firebase user ids are not UUIDs, so on
/// iOS this app sends nothing — Android's `obfuscatedAccountId` takes any
/// string and still gets one.
bool isValidAppleAccountToken(String? userId) {
  if (userId == null) return false;
  return RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-'
    r'[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  ).hasMatch(userId);
}

/// How a [PurchaseError] from the store should be reported to the user.
///
/// `PurchaseError.code` is nullable, and a cancellation is not a failure — it
/// is the user changing their mind, and it should leave the paywall exactly as
/// it was rather than raising an error.
PurchaseFlowStatus statusForError(PurchaseError error) =>
    error.code == ErrorCode.UserCancelled
    ? PurchaseFlowStatus.canceled
    : PurchaseFlowStatus.error;

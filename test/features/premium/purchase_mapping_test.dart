import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/features/premium/services/purchases/purchase_mapping.dart';

/// The rules that decide whether somebody keeps what they paid for.
///
/// These live in a pure file precisely so they can be run without a billing
/// connection. The service around them is plumbing; everything here is money.
void main() {
  PurchaseAndroid androidPurchase({
    String productId = 'accountant_premium_yearly',
    String? orderId = 'GPA.1234-5678-9012-34567',
    String? token = 'play-token',
    PurchaseState state = PurchaseState.Purchased,
    bool? acknowledged,
  }) => PurchaseAndroid(
    // `id` is orderId ?? purchaseToken, as the plugin builds it.
    id: orderId ?? token ?? '',
    productId: productId,
    transactionId: orderId,
    purchaseToken: token,
    purchaseState: state,
    isAutoRenewing: true,
    isAcknowledgedAndroid: acknowledged,
    quantity: 1,
    store: IapStore.Google,
    transactionDate: 1757000000000,
  );

  PurchaseIOS iosPurchase({String? token = 'jws-blob'}) => PurchaseIOS(
    id: 'ios-1',
    productId: 'accountant_premium_yearly',
    transactionId: '2000000900000001',
    purchaseToken: token,
    purchaseState: PurchaseState.Purchased,
    isAutoRenewing: true,
    quantity: 1,
    store: IapStore.Apple,
    transactionDate: 1757000000000,
  );

  SubscriptionOffer offer({
    required String id,
    String? basePlanId,
    String? token = 'offer-token',
    List<PricingPhaseAndroid> phases = const [],
  }) => SubscriptionOffer(
    id: id,
    basePlanIdAndroid: basePlanId,
    offerTokenAndroid: token,
    displayPrice: '',
    price: 0,
    type: DiscountOfferType.Introductory,
    pricingPhasesAndroid: PricingPhasesAndroid(pricingPhaseList: phases),
  );

  PricingPhaseAndroid phase({
    required String micros,
    required String formatted,
    String period = 'P1Y',
    int recurrence = 1,
  }) => PricingPhaseAndroid(
    billingCycleCount: 0,
    billingPeriod: period,
    formattedPrice: formatted,
    priceAmountMicros: micros,
    priceCurrencyCode: 'USD',
    recurrenceMode: recurrence,
  );

  ProductSubscriptionAndroid subscription(List<SubscriptionOffer> offers) =>
      ProductSubscriptionAndroid(
        id: 'accountant_premium_yearly',
        title: 'Premium Yearly',
        nameAndroid: 'Premium Yearly',
        description: '',
        currency: 'USD',
        displayPrice: 'Free',
        subscriptionOffers: offers,
      );

  group('the receipt we send the backend', () {
    test('android sends the play token and the order id', () {
      final payload = backendPayloadFor(androidPurchase())!;

      expect(payload, {
        'platform': 'android',
        'product_id': 'accountant_premium_yearly',
        'purchase_token': 'play-token',
        'order_id': 'GPA.1234-5678-9012-34567',
      });
    });

    test('a pending android purchase has no order id yet', () {
      // Play does not mint one until the payment clears. The backend keys on
      // the token in that case, so an empty string is the honest value.
      final payload = backendPayloadFor(androidPurchase(orderId: null))!;

      expect(payload['order_id'], '');
      expect(payload['purchase_token'], 'play-token');
    });

    test('ios sends the StoreKit 2 JWS as the token', () {
      final payload = backendPayloadFor(iosPurchase())!;

      expect(payload['platform'], 'ios');
      expect(payload['purchase_token'], 'jws-blob');
      expect(payload['order_id'], '2000000900000001');
    });

    test('a purchase with no token is not worth asking about', () {
      expect(backendPayloadFor(androidPurchase(token: null)), isNull);
      expect(backendPayloadFor(androidPurchase(token: '')), isNull);
    });
  });

  group('what the backend answer means', () {
    test('success is a grant', () {
      expect(
        classifyVerifyResponse(threw: false, body: {'success': true}),
        VerifyOutcome.granted,
      );
    });

    test('an explicit no is a rejection, not a retry', () {
      // The endpoint answers 200 either way; `success: false` is a verdict.
      // Treating it as transient would hand out premium the store denied.
      expect(
        classifyVerifyResponse(
          threw: false,
          body: {'success': false, 'error': 'Invalid product ID'},
        ),
        VerifyOutcome.rejected,
      );
    });

    test('a request that threw is transient', () {
      // Offline, 401, 5xx. The purchase is probably real and Play refunds
      // anything unacknowledged after three days, so this must not be a
      // rejection.
      expect(classifyVerifyResponse(threw: true), VerifyOutcome.transient);
    });

    test('"could not ask the store" is transient, not a rejection', () {
      // The exact case a dev server with no Google credentials produces, and
      // the one that costs money if read as a refusal: an unverified Android
      // purchase is deliberately left unfinished, and Play refunds anything
      // unfinished for three days. A server having a bad minute would quietly
      // refund every sale it took.
      expect(
        classifyVerifyResponse(
          threw: false,
          body: {
            'success': false,
            'error':
                'PURCHASE_VERIFICATION_UNAVAILABLE: '
                'Google Play credentials are not configured',
          },
        ),
        VerifyOutcome.transient,
      );
    });

    test('an unpaid purchase is pending, which grants and finishes nothing', () {
      expect(
        classifyVerifyResponse(
          threw: false,
          body: {
            'success': false,
            'error': 'PURCHASE_PENDING: Payment has not completed',
          },
        ),
        VerifyOutcome.pending,
      );
    });

    test('a real refusal is still a refusal', () {
      // Nothing prefixed, so the backend is answering about the receipt.
      for (final error in [
        'Invalid product ID',
        'Subscription not found',
        'Subscription expired or payment pending',
      ]) {
        expect(
          classifyVerifyResponse(
            threw: false,
            body: {'success': false, 'error': error},
          ),
          VerifyOutcome.rejected,
          reason: error,
        );
      }
    });

    test('a refusal with no error text at all is a refusal', () {
      expect(
        classifyVerifyResponse(threw: false, body: {'success': false}),
        VerifyOutcome.rejected,
      );
    });

    test('a 200 with a body we cannot read is transient', () {
      expect(
        classifyVerifyResponse(threw: false, body: null),
        VerifyOutcome.transient,
      );
    });
  });

  group('which android offer to buy with', () {
    test('prefers a free trial when the user is eligible', () {
      // Play only returns offers the user can actually use, so a trial being
      // in the list is itself the eligibility check.
      final trial = offer(
        id: 'freetrial',
        basePlanId: 'yearly',
        phases: [
          phase(micros: '0', formatted: 'Free', period: 'P1W', recurrence: 2),
          phase(micros: '19990000', formatted: '\$19.99'),
        ],
      );
      final base = offer(id: 'yearly', basePlanId: 'yearly');

      expect(pickAndroidOffer(subscription([base, trial])), same(trial));
    });

    test('falls back to the base plan when there is no trial', () {
      final promo = offer(id: 'promo', basePlanId: 'yearly');
      final base = offer(id: 'yearly', basePlanId: 'yearly');

      expect(pickAndroidOffer(subscription([promo, base])), same(base));
    });

    test('ignores offers with no token, which cannot be bought', () {
      final useless = offer(id: 'yearly', basePlanId: 'yearly', token: null);
      final usable = offer(id: 'promo', basePlanId: 'yearly');

      expect(pickAndroidOffer(subscription([useless, usable])), same(usable));
    });

    test('no offer at all is null, not a crash', () {
      // requestPurchase without a token is a native developer error, so the
      // service has to be able to see this coming.
      expect(pickAndroidOffer(subscription([])), isNull);
      expect(
        pickAndroidOffer(subscription([offer(id: 'x', token: null)])),
        isNull,
      );
    });
  });

  group('the price on the paywall', () {
    test('is the recurring price, not the trial price', () {
      // A subscription whose first phase is free reports `displayPrice: Free`.
      // Advertising that would promise a price nobody is charged.
      final product = subscription([
        offer(
          id: 'freetrial',
          basePlanId: 'yearly',
          phases: [
            phase(micros: '0', formatted: 'Free', period: 'P1W', recurrence: 2),
            phase(micros: '19990000', formatted: '\$19.99'),
          ],
        ),
      ]);

      expect(product.displayPrice, 'Free');
      expect(displayPriceFor(product), '\$19.99');
    });

    test('falls back to the store price when there are no phases', () {
      final product = subscription([offer(id: 'yearly')]);

      expect(displayPriceFor(product), 'Free');
    });
  });

  group('the trial we advertise', () {
    test('reads the length off the free phase', () {
      final product = subscription([
        offer(
          id: 'freetrial',
          phases: [
            phase(micros: '0', formatted: 'Free', period: 'P1W', recurrence: 2),
            phase(micros: '19990000', formatted: '\$19.99'),
          ],
        ),
      ]);

      expect(freeTrialLabelFor(product), '1 week');
    });

    test('is absent when the plan has none', () {
      final product = subscription([
        offer(
          id: 'yearly',
          phases: [phase(micros: '19990000', formatted: '\$19.99')],
        ),
      ]);

      expect(freeTrialLabelFor(product), isNull);
    });

    test('reads play periods', () {
      expect(describeIsoPeriod('P3D'), '3 days');
      expect(describeIsoPeriod('P1W'), '1 week');
      expect(describeIsoPeriod('P1M'), '1 month');
      expect(describeIsoPeriod('P1Y'), '1 year');
      expect(describeIsoPeriod('P1Y6M'), isNull, reason: 'not shown raw');
    });
  });

  group('identity, for not delivering the same purchase twice', () {
    test('android uses the order id, as the old plugin did', () {
      // Keeping the old plugin's `purchaseID` as the identity is what stops an
      // upgrade re-delivering everything the user already owns.
      expect(purchaseIdentity(androidPurchase()), 'GPA.1234-5678-9012-34567');
    });

    test('android falls back to the token before the order id exists', () {
      expect(
        purchaseIdentity(androidPurchase(orderId: null, token: 'play-token')),
        'play-token',
      );
    });

    test('ios uses the transaction id', () {
      expect(purchaseIdentity(iosPurchase()), '2000000900000001');
    });
  });

  group('the account tag', () {
    test('apple only accepts a UUID', () {
      // The OpenIAP Apple module throws on anything else, where Apple itself
      // would have dropped it silently.
      expect(
        isValidAppleAccountToken('f81d4fae-7dec-11d0-a765-00a0c91e6bf6'),
        isTrue,
      );
    });

    test('a firebase uid is not one, so ios sends nothing', () {
      expect(isValidAppleAccountToken('YMH4kL2pQ9XcV7bN1aS8dF3gJ6wR'), isFalse);
      expect(isValidAppleAccountToken(null), isFalse);
      expect(isValidAppleAccountToken(''), isFalse);
    });
  });

  group('errors', () {
    test('backing out of the sheet is a cancellation, not a failure', () {
      final status = statusForError(
        PurchaseError(message: 'cancelled', code: ErrorCode.UserCancelled),
      );

      expect(status, PurchaseFlowStatus.canceled);
    });

    test('anything else is an error', () {
      expect(
        statusForError(
          PurchaseError(message: 'nope', code: ErrorCode.ServiceError),
        ),
        PurchaseFlowStatus.error,
      );
    });

    test('a missing code is an error, not a crash', () {
      // `PurchaseError.code` is nullable.
      expect(
        statusForError(PurchaseError(message: 'who knows')),
        PurchaseFlowStatus.error,
      );
    });
  });

  test('nothing this app sells is consumed on purchase', () {
    // Consuming a subscription would let the store sell it to the same person
    // again; consuming the lifetime unlock would revoke it.
    for (final id in [
      'accountant_premium_monthly',
      'accountant_premium_yearly',
      'accountant_premium_lifetime',
    ]) {
      expect(isConsumableProduct(id), isFalse, reason: id);
    }
  });
}

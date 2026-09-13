import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:the_accountant/features/premium/providers/iap_provider.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/features/premium/providers/premium_sync_provider.dart';

/// A purchase the store completed that the backend could not verify.
///
/// The user pays, Play confirms the subscription, and `/iap/subscription-status`
/// still answers "free" — because the server never managed to process the
/// receipt. That answer is confirmed, so the entitlement bridge used to act on
/// it and lock premium away from somebody who had just been charged.
///
/// It is not a rare shape. A rotated service account key, a Play outage, a
/// deployment missing credentials: every one of them produces exactly this, for
/// every paying user at once.
void main() {
  // `PremiumNotifier` mirrors every entitlement change into secure storage,
  // which is a platform channel. Answer it in memory so these tests are about
  // the entitlement decision and not about the keystore.
  const secureStorage = MethodChannel(
    'plugins.it_nomads.com/flutter_secure_storage',
  );

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    final written = <String, String>{};
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorage, (call) async {
          final args = (call.arguments as Map?)?.cast<String, dynamic>() ?? {};
          return switch (call.method) {
            'write' => written[args['key'] as String] = args['value'] as String,
            'read' => written[args['key'] as String],
            'delete' => written.remove(args['key'] as String),
            'readAll' => written,
            'deleteAll' => written.clear(),
            _ => null,
          };
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorage, null);
  });

  ProviderContainer containerFor(IAPState iapState) {
    final container = ProviderContainer(
      overrides: [
        iapNotifierProvider.overrideWith((ref) => _FixedIap(iapState)),
      ],
    );
    addTearDown(container.dispose);
    // The bridge is a listener; it only runs while something watches it.
    container.listen(premiumIapSyncProvider, (_, _) {});
    return container;
  }

  /// Push a new IAP state through the bridge and read what premium became.
  Future<PremiumState> settle(
    ProviderContainer container,
    IAPState next,
  ) async {
    (container.read(iapNotifierProvider.notifier) as _FixedIap).emit(next);
    await Future<void>.delayed(Duration.zero);
    return container.read(premiumProvider);
  }

  const unverified = IAPState(
    isPremium: true,
    currentTier: 'accountant_premium_monthly',
    backendConfirmed: false,
    provisionalPremium: true,
  );

  test('an unverified purchase still unlocks premium', () async {
    final container = containerFor(const IAPState(isLoading: true));

    final premium = await settle(container, unverified);

    expect(premium.isPremium, isTrue);
    expect(premium.tier, SubscriptionTier.premiumMonthly);
  });

  test('a confirmed "free" does not undo it', () async {
    // The server answering about a receipt it never processed. It is not lying,
    // it just does not know, and it must not cost the buyer what they paid for.
    final container = containerFor(const IAPState(isLoading: true));
    await settle(container, unverified);

    final premium = await settle(
      container,
      unverified.copyWith(backendConfirmed: true),
    );

    expect(premium.isPremium, isTrue);
  });

  test('once verification lands, it becomes an ordinary confirmed grant', () async {
    final container = containerFor(const IAPState(isLoading: true));
    await settle(container, unverified);

    final premium = await settle(
      container,
      const IAPState(
        isPremium: true,
        currentTier: 'accountant_premium_yearly',
        backendConfirmed: true,
      ),
    );

    expect(premium.isPremium, isTrue);
    expect(premium.tier, SubscriptionTier.premiumYearly);
  });

  test('a receipt the backend rejects does downgrade', () async {
    // The flag clears when the backend looks at the receipt and says no, and
    // the next confirmed answer is acted on as usual. Without this the fix
    // above would just be a way of never downgrading anybody.
    final container = containerFor(const IAPState(isLoading: true));
    await settle(container, unverified);

    final premium = await settle(
      container,
      const IAPState(isPremium: false, backendConfirmed: true),
    );

    expect(premium.isPremium, isFalse);
  });

  test('a failed request on its own grants nothing', () async {
    // No purchase, just an unreachable backend. Unconfirmed is not a licence.
    final container = containerFor(const IAPState(isLoading: true));

    final premium = await settle(
      container,
      const IAPState(isPremium: false, backendConfirmed: false),
    );

    expect(premium.isPremium, isFalse);
  });
}

/// An [IAPNotifier] whose state the test drives directly.
class _FixedIap extends StateNotifier<IAPState> implements IAPNotifier {
  _FixedIap(super.state);

  void emit(IAPState next) => state = next;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

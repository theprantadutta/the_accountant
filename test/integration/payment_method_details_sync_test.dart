import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/sync/sync_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/fake_sync_server.dart';
import '../helpers/test_database.dart';

/// Everything the payment-method form asks for, reaching the other device.
///
/// The form has collected a type, the last four digits and the institution
/// since the feature shipped. The push mapper sent the name, the icon and the
/// default flag, and the server entity had nowhere to put the rest — so a
/// second device, or a restore from the cloud, came back with a payment method
/// stripped of everything that said which card it was.
void main() {
  late FakeSyncServer server;
  late AppDatabase deviceA;
  late AppDatabase deviceB;
  const userId = 'cards-user';

  SyncService syncFor(AppDatabase db) => SyncService(
    database: db,
    transport: FakeSyncTransport(server: server, userId: userId),
  );

  Future<String> addCard(
    AppDatabase db, {
    String name = 'Visa',
    String type = 'card',
    String? lastFour = '4242',
    String? institution = 'Barclays',
  }) async {
    const id = 'pm-1';
    await db.addPaymentMethod(
      PaymentMethodsCompanion.insert(
        id: id,
        name: name,
        type: Value(type),
        lastFourDigits: Value(lastFour),
        institution: Value(institution),
        syncStatus: const Value(SyncStatus.pendingCreate),
      ),
    );
    return id;
  }

  Future<PaymentMethod?> cardOn(AppDatabase db, String id) =>
      (db.select(db.paymentMethods)..where((p) => p.id.equals(id)))
          .getSingleOrNull();

  setUp(() async {
    server = FakeSyncServer();
    deviceA = openTestDatabase();
    await deviceA.claimLocalStore(userId: userId);
    deviceB = openTestDatabase();
    await deviceB.claimLocalStore(userId: userId);
  });

  tearDown(() async {
    await deviceA.close();
    await deviceB.close();
  });

  test('the details reach the second device', () async {
    final id = await addCard(deviceA);

    await syncFor(deviceA).syncAll();
    await syncFor(deviceB).syncAll();

    final card = await cardOn(deviceB, id);
    expect(card, isNotNull);
    expect(card!.name, 'Visa');
    expect(
      card.type,
      'card',
      reason: 'the form asks for this and it was never sent',
    );
    expect(card.lastFourDigits, '4242');
    expect(card.institution, 'Barclays');
  });

  test('an edit to the details travels too', () async {
    final id = await addCard(deviceA);
    await syncFor(deviceA).syncAll();
    await syncFor(deviceB).syncAll();

    await (deviceA.update(
      deviceA.paymentMethods,
    )..where((p) => p.id.equals(id))).write(
      PaymentMethodsCompanion(
        institution: const Value('Monzo'),
        lastFourDigits: const Value('1111'),
        syncStatus: const Value(SyncStatus.pendingUpdate),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await syncFor(deviceA).syncAll();
    await syncFor(deviceB).syncAll();

    final card = await cardOn(deviceB, id);
    expect(card!.institution, 'Monzo');
    expect(card.lastFourDigits, '1111');
  });

  test('clearing the digits clears them everywhere', () async {
    final id = await addCard(deviceA);
    await syncFor(deviceA).syncAll();
    await syncFor(deviceB).syncAll();

    await (deviceA.update(
      deviceA.paymentMethods,
    )..where((p) => p.id.equals(id))).write(
      PaymentMethodsCompanion(
        lastFourDigits: const Value(null),
        syncStatus: const Value(SyncStatus.pendingUpdate),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await syncFor(deviceA).syncAll();
    await syncFor(deviceB).syncAll();

    expect(
      (await cardOn(deviceB, id))!.lastFourDigits,
      isNull,
      reason: 'a user removing the digits from a card means it; coalescing '
          'onto the stored value would make that edit impossible to make',
    );
  });

  test('a method with no optional details survives the round trip', () async {
    final id = await addCard(
      deviceA,
      name: 'Cash',
      type: 'cash',
      lastFour: null,
      institution: null,
    );

    await syncFor(deviceA).syncAll();
    await syncFor(deviceB).syncAll();

    final card = await cardOn(deviceB, id);
    expect(card!.type, 'cash');
    expect(card.lastFourDigits, isNull);
    expect(card.institution, isNull);
  });
}

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/financial_calculation_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

import '../helpers/test_database.dart';

/// Net worth is the money the user has. A credit card's balance is a bill or
/// borrowing power, so it stays out unless the user asks for it.
void main() {
  late AppDatabase db;

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  Future<void> makeCard(String id) =>
      (db.update(db.wallets)..where((w) => w.id.equals(id))).write(
        const WalletsCompanion(walletType: Value(WalletType.creditCard)),
      );

  test('a credit card is left out of net worth unless included', () async {
    await seedWallet(db, name: 'Cash', openingBalance: 50000);
    final card = await seedWallet(db, name: 'Card', openingBalance: -20000);
    await makeCard(card);
    final service = FinancialCalculationService(db);

    expect(await service.getTotalBalanceConverted('USD'), 50000);
    expect(
      await service.getTotalBalanceConverted('USD', includeCreditCards: true),
      30000,
    );
  });

  test('archived and excluded accounts stay out either way', () async {
    final card = (await db.findWalletById(
      await seedWallet(db, name: 'Card', openingBalance: 100),
    ))!;
    expect(
      FinancialCalculationService.countsInNetWorth(
        card.copyWith(isArchived: true),
        includeCreditCards: true,
      ),
      isFalse,
    );
    expect(
      FinancialCalculationService.countsInNetWorth(
        card.copyWith(excludeFromTotal: true),
        includeCreditCards: true,
      ),
      isFalse,
    );
  });

  test('an account can be made a credit card after it was created', () async {
    final id = await seedWallet(db, name: 'SCB');
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    await container
        .read(walletProvider.notifier)
        .updateWallet(id: id, walletType: WalletType.creditCard);

    expect((await db.findWalletById(id))!.walletType, WalletType.creditCard);
  });
}

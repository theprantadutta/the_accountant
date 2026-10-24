import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/cards/domain/card_statement.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

/// Every open credit card's bills, worked out from its transactions.
///
/// Re-read when an account or a transaction changes, so paying a bill shows
/// as paid the moment the transfer is saved.
final cardBillsProvider = FutureProvider.autoDispose<List<CardBill>>((
  ref,
) async {
  final cards = ref
      .watch(walletProvider)
      .wallets
      .where((w) => w.walletType == WalletType.creditCard && !w.isArchived)
      .toList();
  ref.watch(transactionProvider.select((s) => s.transactions));
  final db = ref.watch(databaseProvider);
  final today = DateTime.now();
  return [
    for (final card in cards)
      CardBill.of(
        card,
        await db.getTransactionsByWallet(card.id),
        today: today,
      ),
  ];
});

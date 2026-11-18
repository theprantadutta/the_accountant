import 'package:drift/drift.dart' show Value;
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/l10n/app_l10n.dart';
import 'package:uuid/uuid.dart';

/// What an income or expense was in another currency, and what it cost.
///
/// $500 from AdMob wired into a taka account arrives as ৳60,500: the entry's
/// own amount is the taka that landed, and this is the $500 it was. A charge
/// the bank took separately is [fee], an amount in [feeWalletId]'s currency.
/// A cut taken before the money arrived needs no fee: it is already missing
/// from the amount that landed, and shows as a lower rate.
class ForeignAmount {
  const ForeignAmount({
    required this.currency,
    required this.amount,
    this.fee = 0,
    this.feeWalletId,
  });

  /// ISO 4217 code, such as `USD`.
  final String currency;

  /// In [currency]'s minor units.
  final int amount;

  /// In the minor units of the wallet it is charged to; 0 for none.
  final int fee;

  /// Where the fee was charged; the entry's own wallet when null.
  final String? feeWalletId;

  /// The entry's wallet-currency amount per one unit of [currency].
  double rateFor(int walletAmount) => amount <= 0 ? 0 : walletAmount / amount;
}

/// Records an income or expense's foreign amount, and keeps its fee in step.
///
/// Kept apart from the add and edit paths so neither has to know about the
/// fee row: they save the entry as before, then hand it here. The fee is its
/// own expense, linked by `feeForTransactionId` exactly as a transfer's is, so
/// it counts in spending, sits under Fees & Charges, and goes when its entry
/// is deleted.
class ForeignAmountService {
  ForeignAmountService(this._db) : _balances = WalletBalanceService(_db);

  final AppDatabase _db;
  final WalletBalanceService _balances;

  /// Sets [transactionId]'s foreign amount to [foreign], or clears it (and its
  /// fee) when [foreign] is null. Transfers are left alone: theirs is set by
  /// the transfer itself.
  ///
  /// Returns the wallets whose balances moved, for the caller to reload.
  Future<Set<String>> apply(String transactionId, ForeignAmount? foreign) {
    return _db.transaction(() async {
      final row = await _db.getTransactionById(transactionId);
      if (row == null || row.deletedAt != null) return <String>{};
      if (TransactionPolicy.isTransfer(row)) return <String>{};

      final now = DateTime.now();
      final valid = foreign != null && foreign.amount > 0;
      await _db.updateTransaction(
        TransactionsCompanion(
          id: Value(row.id),
          counterAmount: Value(valid ? foreign.amount : null),
          counterCurrency: Value(valid ? foreign.currency : null),
          fxRate: Value(valid ? foreign.rateFor(row.amount) : null),
          updatedAt: Value(now),
          syncStatus: Value(_edited(row.syncStatus)),
        ),
      );

      final touched = <String>{row.walletId};
      final existingFee = await _db.findFeeForTransfer(row.id);
      final fee = valid ? foreign.fee : 0;

      if (fee <= 0) {
        if (existingFee != null) {
          await _db.softDeleteTransaction(existingFee.id);
          touched.add(existingFee.walletId);
        }
      } else {
        final chargedTo = foreign!.feeWalletId ?? row.walletId;
        final title = appL10n.txnFeeTitle(
          row.title.isEmpty ? foreign.currency : row.title,
        );
        if (existingFee == null) {
          final feeCategoryId = await _db.requireSystemCategoryId(
            BuiltInCategoryKeys.feesCharges,
          );
          await _db.addTransaction(
            TransactionsCompanion(
              id: Value(const Uuid().v4()),
              amount: Value(fee),
              isIncome: const Value(false),
              title: Value(title),
              date: Value(row.date),
              categoryId: Value(feeCategoryId),
              walletId: Value(chargedTo),
              transactionType: Value(TransactionPolicy.regularType),
              feeForTransactionId: Value(row.id),
              isPaid: const Value(true),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatus.pendingCreate),
            ),
          );
        } else {
          touched.add(existingFee.walletId);
          await _db.updateTransaction(
            TransactionsCompanion(
              id: Value(existingFee.id),
              amount: Value(fee),
              title: Value(title),
              date: Value(row.date),
              walletId: Value(chargedTo),
              updatedAt: Value(now),
              syncStatus: Value(_edited(existingFee.syncStatus)),
            ),
          );
        }
        touched.add(chargedTo);
      }

      for (final walletId in touched) {
        await _balances.updateWalletBalance(walletId);
      }
      return touched;
    });
  }

  /// The fee charged for [transactionId], if any.
  Future<Transaction?> feeFor(String transactionId) =>
      _db.findFeeForTransfer(transactionId);

  /// An edit to a row the server has not acknowledged yet is still its create.
  static int _edited(int current) => current == SyncStatus.pendingCreate
      ? SyncStatus.pendingCreate
      : SyncStatus.pendingUpdate;
}

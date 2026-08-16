import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/analytics_service.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/core/services/reminder_scheduler_service.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:uuid/uuid.dart';

/// State for credit and debt transactions
class CreditDebtState {
  final List<Transaction> creditTransactions;
  final List<Transaction> debtTransactions;
  final bool isLoading;
  final String? error;

  const CreditDebtState({
    this.creditTransactions = const [],
    this.debtTransactions = const [],
    this.isLoading = false,
    this.error,
  });

  CreditDebtState copyWith({
    List<Transaction>? creditTransactions,
    List<Transaction>? debtTransactions,
    bool? isLoading,
    String? error,
  }) {
    return CreditDebtState(
      creditTransactions: creditTransactions ?? this.creditTransactions,
      debtTransactions: debtTransactions ?? this.debtTransactions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Lifetime credit recorded (money lent out, settled or not) — minor units.
  /// This is a HISTORICAL figure; it is deliberately not the user's exposure.
  int get totalCredit =>
      creditTransactions.fold<int>(0, (sum, t) => sum + t.amount);

  /// Outstanding credit still owed to you — minor units.
  ///
  /// Settlement comes from [TransactionPolicy.isSettled] (`paidAmount >=
  /// amount`), never from the overloaded `isPaid` flag: a fresh loan has
  /// `isPaid == true` (the cash moved) while still being fully outstanding.
  int get unpaidCredit =>
      TransactionPolicy.totalOutstanding(creditTransactions);

  /// Lifetime debt recorded (money borrowed, settled or not) — minor units.
  int get totalDebt =>
      debtTransactions.fold<int>(0, (sum, t) => sum + t.amount);

  /// Outstanding debt you still owe — minor units.
  int get unpaidDebt => TransactionPolicy.totalOutstanding(debtTransactions);

  /// Net OPEN exposure: positive = others owe you more than you owe.
  ///
  /// Derived from outstanding amounts only. Using lifetime totals here meant the
  /// screen kept claiming someone owed money after every loan had been settled.
  int get netBalance => unpaidCredit - unpaidDebt;

  /// Lifetime net position, kept for screens that want the historical figure.
  /// Must always be labelled distinctly from [netBalance].
  int get lifetimeNetBalance => totalCredit - totalDebt;

  /// Get all transactions sorted by date
  List<Transaction> get allTransactions {
    final all = [...creditTransactions, ...debtTransactions];
    all.sort((a, b) => b.date.compareTo(a.date));
    return all;
  }

  /// Not-yet-fully-settled transactions.
  List<Transaction> get unpaidTransactions =>
      allTransactions.where(TransactionPolicy.isOutstanding).toList();

  /// Fully settled transactions.
  List<Transaction> get settledTransactions =>
      allTransactions.where(TransactionPolicy.isSettled).toList();

  /// Get overdue unpaid transactions (past original due date)
  List<Transaction> get overdueTransactions =>
      allTransactions.where((t) => TransactionPolicy.isOverdue(t)).toList();

  /// Count of overdue transactions
  int get overdueCount => overdueTransactions.length;
}

class CreditDebtNotifier extends StateNotifier<CreditDebtState> {
  final AppDatabase _db;
  final WalletBalanceService _balanceService;
  final Ref _ref;

  CreditDebtNotifier(this._db, this._ref)
    : _balanceService = WalletBalanceService(_db),
      super(const CreditDebtState()) {
    loadData();
  }

  /// Load credit and debt transactions
  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final credit = await _db.getCreditTransactions();
      final debt = await _db.getDebtTransactions();

      state = state.copyWith(
        creditTransactions: credit,
        debtTransactions: debt,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load data: ${e.toString()}',
      );
    }
  }

  /// Mark a credit/debt as fully settled.
  ///
  /// Records a repayment transaction for whatever is still outstanding and
  /// brings `paidAmount` up to the full principal. `isPaid` is deliberately left
  /// alone: for a loan it means "the principal already moved", which was true
  /// from the moment the loan was created and stays true afterwards. Settlement
  /// is derived from amounts by [TransactionPolicy.isSettled].
  Future<void> markAsSettled(String transactionId) async {
    try {
      await _db.transaction(() async {
        final transaction = await _db.findTransactionById(transactionId);
        if (transaction == null) return;

        final isCredit = TransactionPolicy.isCredit(transaction);
        final remaining = TransactionPolicy.outstandingAmount(transaction);

        if (remaining > 0) {
          await _recordRepaymentRow(
            parent: transaction,
            amount: remaining,
            isIncome: isCredit,
            label: '${isCredit ? "Received" : "Paid"}: ${transaction.title}',
            note:
                'Settlement for ${isCredit ? "credit" : "debt"}: ${transaction.title}',
          );
        }

        await (_db.update(
          _db.transactions,
        )..where((t) => t.id.equals(transactionId))).write(
          TransactionsCompanion(
            paidAmount: Value(transaction.amount),
            originalDueDate: Value(
              transaction.originalDueDate ?? transaction.date,
            ),
            syncStatus: const Value(SyncStatus.pendingUpdate),
            updatedAt: Value(DateTime.now()),
          ),
        );

        await _balanceService.updateWalletBalance(transaction.walletId);
      });

      await _ref.read(walletProvider.notifier).loadWallets();

      // Cancel any scheduled reminder
      try {
        await ReminderSchedulerService().cancelReminder(transactionId);
      } catch (_) {}

      AnalyticsService().logCreditDebtSettled();
      await loadData();
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to mark as settled: ${e.toString()}',
      );
    }
  }

  /// Record a partial payment on a credit/debt transaction.
  ///
  /// The repayment is a real transaction (so it appears in history and moves the
  /// wallet), and the parent's `paidAmount` advances. Nothing here writes
  /// `isPaid` — that flag records the original cash movement, and overloading it
  /// with settlement is what made a partially-repaid loan look either untouched
  /// or fully settled depending on which screen you looked at.
  Future<void> recordPayment({
    required String transactionId,
    required int paymentAmount, // integer minor units / cents
  }) async {
    if (paymentAmount <= 0) {
      state = state.copyWith(error: 'Payment amount must be positive');
      return;
    }
    try {
      var fullyPaid = false;
      await _db.transaction(() async {
        final transaction = await _db.findTransactionById(transactionId);
        if (transaction == null) return;

        final isCredit = TransactionPolicy.isCredit(transaction);
        // Never let a repayment push paidAmount past the principal: an
        // overpayment would make outstanding negative and silently offset other
        // loans in the exposure total.
        final outstanding = TransactionPolicy.outstandingAmount(transaction);
        final applied = paymentAmount > outstanding
            ? outstanding
            : paymentAmount;
        if (applied <= 0) return;

        final newPaidAmount = transaction.paidAmount + applied;
        fullyPaid = newPaidAmount >= transaction.amount;

        await _recordRepaymentRow(
          parent: transaction,
          amount: applied,
          // Credit repayment = income (money comes back in).
          // Debt repayment = expense (money goes out).
          isIncome: isCredit,
          label: '${isCredit ? "Received" : "Paid"}: ${transaction.title}',
          note:
              'Partial payment for ${isCredit ? "credit" : "debt"}: ${transaction.title}',
        );

        await (_db.update(
          _db.transactions,
        )..where((t) => t.id.equals(transactionId))).write(
          TransactionsCompanion(
            paidAmount: Value(newPaidAmount),
            syncStatus: const Value(SyncStatus.pendingUpdate),
            updatedAt: Value(DateTime.now()),
          ),
        );

        await _balanceService.updateWalletBalance(transaction.walletId);
      });

      await _ref.read(walletProvider.notifier).loadWallets();

      if (fullyPaid) {
        try {
          await ReminderSchedulerService().cancelReminder(transactionId);
        } catch (_) {}
      }

      AnalyticsService().logCreditDebtPayment();
      await loadData();
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to record payment: ${e.toString()}',
      );
    }
  }

  /// Insert the repayment transaction that accompanies a settlement action.
  ///
  /// It carries the parent's category, payment method, and objective so reports
  /// and goal progress follow the repayment, and it is an ordinary realized
  /// transaction (`specialType: none`, `isPaid: true`) so it is never mistaken
  /// for another loan.
  Future<void> _recordRepaymentRow({
    required Transaction parent,
    required int amount,
    required bool isIncome,
    required String label,
    required String note,
  }) async {
    final now = DateTime.now();
    await _db.addTransaction(
      TransactionsCompanion(
        id: Value(const Uuid().v4()),
        amount: Value(amount),
        title: Value(label),
        notes: Value(note),
        date: Value(now),
        isIncome: Value(isIncome),
        walletId: Value(parent.walletId),
        categoryId: Value(parent.categoryId),
        paymentMethodId: Value(parent.paymentMethodId),
        objectiveId: Value(parent.objectiveId),
        specialType: const Value(TransactionSpecialType.none),
        isPaid: const Value(true),
        syncStatus: const Value(SyncStatus.pendingCreate),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  /// Reset a loan back to fully outstanding.
  ///
  /// History is preserved: instead of deleting the repayment rows, a single
  /// compensating transaction cancels their cash effect, then `paidAmount` is
  /// zeroed. The wallet is recomputed from its surviving transactions, so the
  /// balance always matches the ledger.
  Future<void> markAsPending(String transactionId) async {
    try {
      await _db.transaction(() async {
        final transaction = await _db.findTransactionById(transactionId);
        if (transaction == null) return;

        if (transaction.paidAmount > 0) {
          final isCredit = TransactionPolicy.isCredit(transaction);
          await _recordRepaymentRow(
            parent: transaction,
            amount: transaction.paidAmount,
            // Opposite direction to the repayments being undone.
            isIncome: !isCredit,
            label: 'Reversed: ${transaction.title}',
            note: 'Reversal of repayments for: ${transaction.title}',
          );
        }

        await (_db.update(
          _db.transactions,
        )..where((t) => t.id.equals(transactionId))).write(
          TransactionsCompanion(
            paidAmount: const Value(0),
            syncStatus: const Value(SyncStatus.pendingUpdate),
            updatedAt: Value(DateTime.now()),
          ),
        );

        await _balanceService.updateWalletBalance(transaction.walletId);
      });

      await _ref.read(walletProvider.notifier).loadWallets();
      await loadData();
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to mark as pending: ${e.toString()}',
      );
    }
  }

  /// Check if a transaction is overdue (shared policy: unsettled and past due).
  bool isOverdue(Transaction transaction) =>
      TransactionPolicy.isOverdue(transaction);

  /// Check if transaction is credit type
  bool isCredit(Transaction transaction) =>
      TransactionPolicy.isCredit(transaction);

  /// Refresh data
  Future<void> refresh() async {
    await loadData();
  }
}

/// Provider for credit/debt transactions
final creditDebtProvider =
    StateNotifierProvider<CreditDebtNotifier, CreditDebtState>((ref) {
      final db = ref.watch(databaseProvider);
      return CreditDebtNotifier(db, ref);
    });

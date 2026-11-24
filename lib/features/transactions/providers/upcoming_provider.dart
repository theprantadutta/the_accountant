import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/recurring/domain/scheduled_payment.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/l10n/app_l10n.dart';

/// State for upcoming and overdue transactions
class UpcomingState {
  final List<Transaction> upcomingTransactions;
  final List<Transaction> overdueTransactions;

  /// Repeating payments due in the next month that have not been recorded
  /// yet, soonest first.
  final List<ScheduledPayment> scheduled;

  /// Repeating payments whose day has passed but which the scheduler has not
  /// caught up on yet. They are written the next time it runs.
  final List<ScheduledPayment> scheduledOverdue;
  final bool isLoading;
  final String? error;

  const UpcomingState({
    this.upcomingTransactions = const [],
    this.overdueTransactions = const [],
    this.scheduled = const [],
    this.scheduledOverdue = const [],
    this.isLoading = false,
    this.error,
  });

  UpcomingState copyWith({
    List<Transaction>? upcomingTransactions,
    List<Transaction>? overdueTransactions,
    List<ScheduledPayment>? scheduled,
    List<ScheduledPayment>? scheduledOverdue,
    bool? isLoading,
    String? error,
  }) {
    return UpcomingState(
      upcomingTransactions: upcomingTransactions ?? this.upcomingTransactions,
      overdueTransactions: overdueTransactions ?? this.overdueTransactions,
      scheduled: scheduled ?? this.scheduled,
      scheduledOverdue: scheduledOverdue ?? this.scheduledOverdue,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Get total upcoming amount (major-unit dollars; amounts are integer cents)
  double get totalUpcoming =>
      upcomingTransactions.fold(0.0, (sum, t) => sum + t.amount / 100.0);

  /// Get total overdue amount (major-unit dollars; amounts are integer cents)
  double get totalOverdue =>
      overdueTransactions.fold(0.0, (sum, t) => sum + t.amount / 100.0);

  /// Check if there are any pending items
  bool get hasPendingItems =>
      upcomingTransactions.isNotEmpty ||
      overdueTransactions.isNotEmpty ||
      scheduled.isNotEmpty ||
      scheduledOverdue.isNotEmpty;
}

class UpcomingNotifier extends StateNotifier<UpcomingState> {
  final AppDatabase _db;
  final WalletBalanceService _walletBalanceService;
  final Ref _ref;

  UpcomingNotifier(this._db, this._ref)
    : _walletBalanceService = WalletBalanceService(_db),
      super(const UpcomingState()) {
    loadData();
  }

  /// How far ahead a schedule's next payment counts as upcoming.
  static const scheduleHorizon = Duration(days: 31);

  /// Each running schedule's next payment, split into those still ahead (up
  /// to [scheduleHorizon]) and those whose day has passed unrecorded.
  ///
  /// Only the next one per schedule: Upcoming is a list of what to expect,
  /// and the forecast is where a month of every schedule is laid out.
  Future<(List<ScheduledPayment>, List<ScheduledPayment>)>
  _scheduledPayments() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final horizon = today.add(scheduleHorizon);
    final ahead = <ScheduledPayment>[];
    final behind = <ScheduledPayment>[];
    for (final config in await _db.getActiveRecurringConfigs()) {
      final base = await _db.findTransactionById(config.baseTransactionId);
      if (base == null || base.deletedAt != null) continue;
      final date = config.nextOccurrence;
      if (config.endDate != null && date.isAfter(config.endDate!)) continue;
      if (date.isAfter(horizon)) continue;
      final payment = ScheduledPayment(
        configId: config.id,
        baseTransactionId: base.id,
        title: base.title,
        amount: config.amount ?? base.amount,
        walletId: config.walletId ?? base.walletId,
        isIncome: base.isIncome,
        categoryId: base.categoryId,
        date: date,
        frequency: config.reoccurrence,
        periodLength: config.periodLength,
        autoPay: config.autoPay,
      );
      (date.isBefore(today) ? behind : ahead).add(payment);
    }
    ahead.sort((a, b) => a.date.compareTo(b.date));
    behind.sort((a, b) => a.date.compareTo(b.date));
    return (ahead, behind);
  }

  /// Load upcoming and overdue transactions
  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final upcoming = await _db.getUpcomingTransactions();
      final overdue = await _db.getOverdueTransactions();
      final (scheduled, scheduledOverdue) = await _scheduledPayments();

      state = state.copyWith(
        upcomingTransactions: upcoming,
        overdueTransactions: overdue,
        scheduled: scheduled,
        scheduledOverdue: scheduledOverdue,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: appL10n.txnLoadDataFailed(e.toString()),
      );
    }
  }

  /// Mark a transaction as paid, at [amount] when what was charged differs
  /// from what was expected.
  Future<void> markAsPaid(String transactionId, {int? amount}) async {
    try {
      await _db.markTransactionAsPaid(transactionId, amount: amount);

      // Update wallet balance — the transaction is now paid so it should
      // affect the wallet balance
      final transaction = await _db.findTransactionById(transactionId);
      if (transaction != null) {
        await _walletBalanceService.updateWalletBalance(transaction.walletId);
        await _ref.read(walletProvider.notifier).loadWallets();
      }

      await loadData(); // Refresh the list
    } catch (e) {
      state = state.copyWith(error: appL10n.txnMarkPaidFailed(e.toString()));
    }
  }

  /// Mark a transaction as unpaid, putting back [amount] if confirming it
  /// changed what it was for.
  Future<void> markAsUnpaid(String transactionId, {int? amount}) async {
    try {
      // Read the transaction before marking unpaid to get its current state
      final transaction = await _db.findTransactionById(transactionId);

      await _db.markTransactionAsUnpaid(transactionId, amount: amount);

      // Reverse the wallet balance effect — the transaction is no longer paid
      // so its effect on the wallet should be removed
      if (transaction != null && transaction.isPaid) {
        await _walletBalanceService.updateWalletBalance(transaction.walletId);
        await _ref.read(walletProvider.notifier).loadWallets();
      }

      await loadData(); // Refresh the list
    } catch (e) {
      state = state.copyWith(error: appL10n.txnMarkUnpaidFailed(e.toString()));
    }
  }

  /// Skip a transaction (set skipPaid = true).
  ///
  /// Routed through the sync-aware repository method so the skip is flagged
  /// pending and propagates; the previous raw SQL update left `syncStatus`
  /// untouched, so another device kept showing the dismissed reminder.
  Future<void> skipTransaction(String transactionId) async {
    try {
      await _db.skipTransaction(transactionId);
      await loadData();
    } catch (e) {
      state = state.copyWith(error: appL10n.txnSkipFailed(e.toString()));
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    await loadData();
  }
}

/// Provider for upcoming/overdue transactions
final upcomingProvider = StateNotifierProvider<UpcomingNotifier, UpcomingState>(
  (ref) {
    final db = ref.watch(databaseProvider);
    return UpcomingNotifier(db, ref);
  },
);

import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';
import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/core/utils/number_formatter.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/credit_debt/providers/credit_debt_provider.dart';
import 'package:the_accountant/features/split/screens/split_bill_screen.dart';
import 'package:the_accountant/features/transactions/screens/transaction_detail_screen.dart';
import 'package:the_accountant/shared/widgets/sensitive.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';

/// What is lent and borrowed: who owes whom, and what is still open.
class CreditDebtScreen extends ConsumerStatefulWidget {
  const CreditDebtScreen({super.key});

  @override
  ConsumerState<CreditDebtScreen> createState() => _CreditDebtScreenState();
}

/// Which loans the list shows.
enum _Show { all, lent, borrowed }

class _CreditDebtScreenState extends ConsumerState<CreditDebtScreen> {
  _Show _show = _Show.all;
  bool _showOnlyUnpaid = false;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final state = ref.watch(creditDebtProvider);

    final shown = switch (_show) {
      _Show.all => state.allTransactions,
      _Show.lent => state.creditTransactions,
      _Show.borrowed => state.debtTransactions,
    };
    final open = shown.where(TransactionPolicy.isOutstanding).toList()
      ..sort(_byUrgency);
    final settled = _showOnlyUnpaid
        ? const <Transaction>[]
        : (shown.where(TransactionPolicy.isSettled).toList()
            ..sort((a, b) => b.date.compareTo(a.date)));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashCreditDebt),
        actions: [
          // What friends owe from a shared bill lands here, so this is
          // where people come looking to record one.
          IconButton(
            key: const Key('credit_debt_split'),
            icon: const Icon(Symbols.call_split_rounded),
            tooltip: l10n.splitTitle,
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SplitBillScreen())),
          ),
          IconButton(
            icon: Icon(
              _showOnlyUnpaid ? Icons.filter_alt : Icons.filter_alt_outlined,
              color: _showOnlyUnpaid ? context.sunrise.accent : null,
            ),
            onPressed: () => setState(() => _showOnlyUnpaid = !_showOnlyUnpaid),
            tooltip: _showOnlyUnpaid
                ? l10n.creditShowAll
                : l10n.creditShowUnpaid,
          ),
        ],
      ),
      body: CappedBody(
        child: state.isLoading
            ? const SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: ShimmerCard(height: 120),
                    ),
                    ShimmerTransactionList(),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: () =>
                    ref.read(creditDebtProvider.notifier).refresh(),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    SunriseSpace.screenX,
                    8,
                    SunriseSpace.screenX,
                    40,
                  ),
                  children: [
                    _Summary(state: state),
                    const SizedBox(height: 16),
                    SunriseSegmented<_Show>(
                      key: const Key('credit_debt_show'),
                      options: [
                        SegmentOption(_Show.all, l10n.txAll),
                        SegmentOption(
                          _Show.lent,
                          l10n.creditTabCredit(state.creditTransactions.length),
                        ),
                        SegmentOption(
                          _Show.borrowed,
                          l10n.creditTabDebt(state.debtTransactions.length),
                        ),
                      ],
                      value: _show,
                      onChanged: (v) => setState(() => _show = v),
                    ),
                    const SizedBox(height: 16),
                    if (open.isEmpty && settled.isEmpty)
                      _emptyState(context)
                    else ...[
                      for (final t in open) ...[
                        _LoanCard(
                          loan: t,
                          onRecordPayment: () => _showRecordPaymentDialog(
                            t,
                            TransactionPolicy.isCredit(t),
                          ),
                          onSettle: () =>
                              _markAsSettled(t, TransactionPolicy.isCredit(t)),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (settled.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                          child: SectionLabel(l10n.creditSettled),
                        ),
                        for (final t in settled) ...[
                          _LoanCard(loan: t),
                          const SizedBox(height: 12),
                        ],
                      ],
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  /// Late first, then the most recent.
  static int _byUrgency(Transaction a, Transaction b) {
    final aLate = TransactionPolicy.isOverdue(a);
    final bLate = TransactionPolicy.isOverdue(b);
    if (aLate != bLate) return aLate ? -1 : 1;
    return b.date.compareTo(a.date);
  }

  Widget _emptyState(BuildContext context) {
    final l10n = L10n.of(context);
    final (String message, IconData icon) = switch (_show) {
      _Show.all => (l10n.creditEmptyAll, Symbols.handshake_rounded),
      _Show.lent => (l10n.creditEmptyLent, Symbols.north_east_rounded),
      _Show.borrowed => (l10n.creditEmptyBorrowed, Symbols.south_west_rounded),
    };
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: EmptyState(
        icon: icon,
        title: message,
        message: _showOnlyUnpaid
            ? l10n.creditEmptyAllSettled
            : l10n.creditEmptyHint,
      ),
    );
  }

  void _showRecordPaymentDialog(Transaction transaction, bool isCredit) {
    final paymentController = TextEditingController();
    final remaining = TransactionPolicy.outstandingAmount(transaction);
    final walletCurrency = ref.read(
      walletCurrencyProvider(transaction.walletId),
    );
    final symbol = CurrencyInfo.getSymbol(walletCurrency);
    final dateFormat = ref.read(dateFormatSettingProvider);
    // When the money changed hands; today unless the user says otherwise.
    var paidOn = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        (isCredit ? AppColors.success : AppColors.primaryAccent)
                            .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.payments_outlined,
                    color: isCredit
                        ? AppColors.success
                        : AppColors.primaryAccent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  L10n.of(context).creditRecordPayment,
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title.isNotEmpty
                      ? transaction.title
                      : (isCredit
                            ? L10n.of(context).creditMoneyLent
                            : L10n.of(context).creditMoneyBorrowed),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Remaining: $symbol${AppNumberFormatter.get(ref.watch(numberFormatSettingProvider)).format(remaining / 100.0)}',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: paymentController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  autofocus: true,
                  style: TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: L10n.of(context).creditPaymentAmount,
                    prefixText: '$symbol ',
                    prefixStyle: TextStyle(color: AppColors.textSecondary),
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isCredit
                            ? AppColors.success
                            : AppColors.primaryAccent,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.glassWhite,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => paymentController.text =
                        (remaining / 100.0).toStringAsFixed(2),
                    child: Text(L10n.of(context).creditFullAmount),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.event, color: AppColors.textMuted),
                  title: Text(
                    L10n.of(context).creditPaidOn,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  trailing: Text(
                    DateUtils.isSameDay(paidOn, DateTime.now())
                        ? L10n.of(context).dateToday
                        : AppDateFormatter.formatDate(paidOn, dateFormat),
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: paidOn,
                      firstDate: DateUtils.dateOnly(transaction.date),
                      lastDate: DateTime.now(),
                    );
                    if (picked == null) return;
                    final now = DateTime.now();
                    setDialogState(
                      () => paidOn = DateUtils.isSameDay(picked, now)
                          ? now
                          : DateTime(
                              picked.year,
                              picked.month,
                              picked.day,
                              now.hour,
                              now.minute,
                            ),
                    );
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  L10n.of(context).actionCancel,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(paymentController.text);
                  if (amount == null || amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          L10n.of(context).creditPleaseEnterAValidAmount,
                        ),
                        backgroundColor: AppColors.error,
                      ),
                    );
                    return;
                  }
                  if (amount > remaining / 100.0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          L10n.of(context).creditAmountExceedsRemainingBalance,
                        ),
                        backgroundColor: AppColors.error,
                      ),
                    );
                    return;
                  }
                  Navigator.of(context).pop();
                  _recordPayment(transaction, amount, isCredit, paidOn);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCredit
                      ? AppColors.success
                      : AppColors.primaryAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  L10n.of(context).creditRecord,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _recordPayment(
    Transaction transaction,
    double amount,
    bool isCredit,
    DateTime paidOn,
  ) async {
    await ref
        .read(creditDebtProvider.notifier)
        .recordPayment(
          transactionId: transaction.id,
          paymentAmount: (amount * 100).round(), // dollars -> integer cents
          paidOn: paidOn,
        );
    if (mounted) {
      final walletCurrency = ref.read(
        walletCurrencyProvider(transaction.walletId),
      );
      final symbol = CurrencyInfo.getSymbol(walletCurrency);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment of $symbol${AppNumberFormatter.get(ref.watch(numberFormatSettingProvider)).format(amount)} recorded',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _markAsSettled(Transaction transaction, bool isCredit) async {
    await ref.read(creditDebtProvider.notifier).markAsSettled(transaction.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isCredit
                ? 'Marked as collected from "${transaction.title}"'
                : 'Marked "${transaction.title}" as paid',
          ),
          backgroundColor: AppColors.success,
          action: SnackBarAction(
            label: L10n.of(context).txUndo,
            textColor: Colors.white,
            onPressed: () {
              ref
                  .read(creditDebtProvider.notifier)
                  .markAsPending(transaction.id);
            },
          ),
        ),
      );
    }
  }
}

/// Money in either direction, in an account's own currency and number style.
String _money(WidgetRef ref, int cents, String currency) =>
    AppNumberFormatter.currency(
      CurrencyInfo.getSymbol(currency),
      ref.watch(numberFormatSettingProvider),
    ).format(cents / 100.0);

/// Who owes whom, at a glance. Calm colours: the amount in ink, and the two
/// directions in soft tints, rather than a card in alarm red.
class _Summary extends ConsumerWidget {
  const _Summary({required this.state});

  final CreditDebtState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final currency = ref.watch(defaultCurrencyProvider);
    final net = state.netBalance;
    final (String side, Color color, Color tint) = switch (net) {
      0 => (l10n.creditAllSettled, c.muted, c.surface),
      > 0 => (l10n.creditOthersOweYou, c.positive, c.tintGreen),
      _ => (l10n.creditYouOweOthers, c.negative, c.tintRose),
    };

    return SunriseCard(
      key: const Key('credit_debt_summary'),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.creditNetOutstanding,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.body.copyWith(color: c.muted),
                ),
              ),
              if (state.overdueCount > 0)
                Flexible(
                  child: SunrisePill(
                    label: l10n.creditOverdueCount(state.overdueCount),
                    icon: Symbols.schedule_rounded,
                    color: c.negative,
                    background: c.tintRose,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Sensitive(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                _money(ref, net.abs(), currency),
                style: SunriseType.section.copyWith(color: c.ink, fontSize: 30),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SunrisePill(label: side, color: color, background: tint),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _Side(
                  icon: Symbols.north_east_rounded,
                  label: l10n.creditTheyOweYou,
                  amount: _money(ref, state.unpaidCredit, currency),
                  color: c.positive,
                  tint: c.tintGreen,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Side(
                  icon: Symbols.south_west_rounded,
                  label: l10n.creditYouOwe,
                  amount: _money(ref, state.unpaidDebt, currency),
                  color: c.negative,
                  tint: c.tintRose,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// One direction of the summary: what is owed to the user, or by them.
class _Side extends StatelessWidget {
  const _Side({
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
    required this.tint,
  });

  final IconData icon;
  final String label;
  final String amount;
  final Color color;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.caption.copyWith(color: c.muted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Sensitive(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                amount,
                style: SunriseType.label.copyWith(
                  color: c.ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One loan: who, how much is still open, how much is back, and what to do.
///
/// A plain card with the direction in a small coloured tile, so a list of
/// loans reads as a list rather than a wall of green and red. Tapping it
/// opens the loan.
class _LoanCard extends ConsumerWidget {
  const _LoanCard({required this.loan, this.onRecordPayment, this.onSettle});

  final Transaction loan;
  final VoidCallback? onRecordPayment;
  final VoidCallback? onSettle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final df = ref.watch(dateFormatSettingProvider);
    final currency = ref.watch(walletCurrencyProvider(loan.walletId));
    final lent = TransactionPolicy.isCredit(loan);
    final settled = TransactionPolicy.isSettled(loan);
    final overdue = TransactionPolicy.isOverdue(loan);
    final partly = TransactionPolicy.hasPartialPayment(loan);
    final color = lent ? c.positive : c.negative;
    final title = loan.title.isNotEmpty
        ? loan.title
        : (lent ? l10n.creditMoneyLent : l10n.creditMoneyBorrowed);
    final notes = loan.notes?.trim() ?? '';
    final due = loan.originalDueDate;
    final paid = _money(ref, loan.paidAmount, currency);
    final principal = _money(ref, loan.amount, currency);

    final card = SunriseCard(
      key: Key('loan_${loan.id}'),
      padding: const EdgeInsets.all(14),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => TransactionDetailScreen(transactionId: loan.id),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconTile(
                icon: lent
                    ? Symbols.north_east_rounded
                    : Symbols.south_west_rounded,
                color: color,
                size: 40,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: SunriseType.rowTitle.copyWith(
                        color: settled ? c.subtle : c.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [
                        AppDateFormatter.formatDate(loan.date, df),
                        if (notes.isNotEmpty) notes,
                      ].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: SunriseType.caption.copyWith(color: c.subtle),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Capped so a six-figure loan does not squeeze the name.
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width * .36,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Sensitive(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          // What is still open, not the principal: after a
                          // partial repayment that is the number that
                          // matters.
                          _money(
                            ref,
                            settled
                                ? loan.amount
                                : TransactionPolicy.outstandingAmount(loan),
                            currency,
                          ),
                          style: SunriseType.amount.copyWith(
                            color: settled ? c.subtle : c.ink,
                            fontSize: 17,
                            decoration: settled
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      settled
                          ? l10n.creditSettled
                          : (lent ? l10n.creditTheyOweYou : l10n.creditYouOwe),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: SunriseType.caption.copyWith(
                        color: settled ? c.subtle : color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (overdue && due != null) ...[
            const SizedBox(height: 10),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: SunrisePill(
                label:
                    '${l10n.creditOverdue} · '
                    '${AppDateFormatter.formatDate(due, df)}',
                icon: Symbols.schedule_rounded,
                color: c.negative,
                background: c.tintRose,
              ),
            ),
          ],
          if (partly) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: TransactionPolicy.settlementProgress(loan),
                minHeight: 6,
                backgroundColor: c.barIdle,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            SensitiveText(
              l10n.creditPaidOf(paid, principal),
              amounts: [paid, principal],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: SunriseType.caption.copyWith(color: c.muted),
            ),
          ],
          if (!settled && onRecordPayment != null && onSettle != null) ...[
            const SizedBox(height: 12),
            // One line each at any width: the labels shrink to fit rather
            // than wrapping, which turned "Record Payment" into two lines.
            Row(
              children: [
                Expanded(
                  child: _LoanAction(
                    label: l10n.creditRecordPayment,
                    icon: Icons.payments_outlined,
                    color: c.ink,
                    background: c.surface,
                    bordered: true,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onRecordPayment!();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _LoanAction(
                    label: lent ? l10n.creditCollected : l10n.creditSettled,
                    icon: Symbols.check_circle_rounded,
                    color: color,
                    background: lent ? c.tintGreen : c.tintRose,
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      onSettle!();
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
    return settled ? Opacity(opacity: .7, child: card) : card;
  }
}

/// A loan card's action: one line at any width and text size, the label
/// shrinking before it would wrap.
class _LoanAction extends StatelessWidget {
  const _LoanAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.background,
    required this.onTap,
    this.bordered = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color background;
  final bool bordered;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Pressable(
      onTap: onTap,
      semanticLabel: label,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(22),
          border: bordered ? Border.all(color: c.divider) : null,
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                maxLines: 1,
                style: SunriseType.label.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

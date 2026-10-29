import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/cards/domain/card_statement.dart';
import 'package:the_accountant/features/cards/providers/card_bills_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/features/transactions/widgets/transaction_type_header.dart'
    show TransactionTypeSelection;
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/wallets/screens/wallet_management_screen.dart';
import 'package:the_accountant/features/wallets/widgets/add_wallet_form.dart'
    show cardReminderChoices, cardReminderLabel;
import 'package:the_accountant/features/wallets/widgets/edit_wallet_sheet.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sensitive.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Credit card bills: what each card's last statement came to, when it is
/// due, what is left to pay, and a way to pay it.
///
/// The bill is worked out from the card's own transactions, from the
/// statement day and due day set on the card. Reminders for it come from the
/// server, on the days set here, so they arrive even with the app closed.
class CardBillsScreen extends ConsumerWidget {
  const CardBillsScreen({super.key, this.focusWalletId});

  /// A card to show first, when the screen was opened from its reminder.
  final String? focusWalletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final bills = ref.watch(cardBillsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cardBillsTitle)),
      body: CappedBody(
        child: bills.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(l10n.catActionFailed)),
          data: (list) {
            if (list.isEmpty) {
              return ListView(
                padding: const EdgeInsets.only(top: 40),
                children: [
                  EmptyState(
                    icon: Symbols.credit_card_rounded,
                    title: l10n.cardBillsEmptyTitle,
                    message: l10n.cardBillsEmptyBody,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SunriseSpace.screenX * 2,
                      vertical: 16,
                    ),
                    child: SunriseButton(
                      label: l10n.cardBillsAddCard,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const WalletManagementScreen(),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            final ordered = [
              ...list.where((b) => b.card.id == focusWalletId),
              ...list.where((b) => b.card.id != focusWalletId),
            ];
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                SunriseSpace.screenX,
                8,
                SunriseSpace.screenX,
                32,
              ),
              children: [
                for (final bill in ordered) ...[
                  _CardBillCard(bill: bill),
                  const SizedBox(height: SunriseSpace.section),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CardBillCard extends ConsumerWidget {
  const _CardBillCard({required this.bill});

  final CardBill bill;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final card = bill.card;
    final nf = ref.watch(numberFormatSettingProvider);
    final locale = Localizations.localeOf(context).toString();
    String money(int cents) => cents.formatCurrency(
      card.currency,
      useDecimals: card.useDecimals,
      numberFormat: nf,
    );
    String day(DateTime d) => DateFormat('EEE, d MMM', locale).format(d);
    final latest = bill.latest;
    final today = DateTime.now();

    return SunriseCard(
      key: Key('card_bill_${card.id}'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconTile(
                icon: IconRegistry.getIcon(card.iconName),
                color: c.accent,
                size: 40,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  card.name,
                  style: SunriseType.rowTitle.copyWith(color: c.ink),
                ),
              ),
              _StatusPill(bill: bill, today: today),
            ],
          ),
          const SizedBox(height: 14),
          if (bill.status == CardBillStatus.notSetUp) ...[
            Text(
              l10n.cardSetUpBody,
              style: SunriseType.body.copyWith(color: c.muted, fontSize: 14),
            ),
            const SizedBox(height: 14),
            SunriseButton(
              key: const Key('card_set_up'),
              label: l10n.cardSetUp,
              height: 50,
              onPressed: () => showEditWalletSheet(context, ref, card),
            ),
          ] else if (latest != null) ...[
            Text(
              latest.isSettled
                  ? l10n.cardLeftToPay
                  : l10n.cardDueBy(day(latest.dueDate)),
              style: SunriseType.caption.copyWith(color: c.subtle),
            ),
            const SizedBox(height: 2),
            Sensitive(
              child: Text(
                money(latest.remaining),
                key: const Key('card_remaining'),
                style: SunriseType.statValue.copyWith(color: c.ink),
              ),
            ),
            // Part payments are normal: the bar shows how much of the bill
            // is already covered, so paying 5,000 of 15,000 reads as progress
            // rather than as a bill still wholly due.
            if (latest.owed > 0) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  key: const Key('card_paid_progress'),
                  value: (latest.paid / latest.owed).clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: c.barIdle,
                  color: latest.isSettled ? c.positive : c.accent,
                ),
              ),
              const SizedBox(height: 6),
              SensitiveText(
                l10n.cardPaidOf(money(latest.paid), money(latest.owed)),
                amounts: [money(latest.paid), money(latest.owed)],
                style: SunriseType.caption.copyWith(color: c.subtle),
              ),
            ],
            const SizedBox(height: 12),
            _Line.total(
              label: l10n.cardStatementClosed(day(latest.statementDate)),
              value: money(latest.owed),
            ),
            _Line.total(label: l10n.cardPaidSince, value: money(latest.paid)),
            _Line.total(
              label: l10n.cardThisCycle(day(bill.nextStatementDate!)),
              value: money(bill.spentThisCycle),
            ),
            _Line(
              label: l10n.cardRemindTitle,
              value: cardReminderLabel(l10n, card.dueReminderDays),
              onTap: () => _changeReminder(context, ref, card),
            ),
            const SizedBox(height: 14),
            // Stacked: side by side, a five-figure amount did not fit.
            if (!latest.isSettled) ...[
              SunriseButton(
                key: const Key('card_pay'),
                label: l10n.cardPayBill,
                height: 50,
                onPressed: () => _pay(context, card, latest, money),
              ),
              const SizedBox(height: 8),
            ],
            SunriseButton.secondary(
              label: l10n.cardEdit,
              onPressed: () => showEditWalletSheet(context, ref, card),
            ),
            if (bill.history.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                l10n.cardEarlierStatements,
                style: SunriseType.overline.copyWith(color: c.subtle),
              ),
              const SizedBox(height: 6),
              for (final s in bill.history)
                _Line(
                  label: day(s.statementDate),
                  value: s.isSettled
                      ? '${money(s.owed)} · ${l10n.cardPaidShort}'
                      : '${money(s.owed)} · ${l10n.cardUnpaidShort(money(s.remaining))}',
                  amounts: [
                    money(s.owed),
                    if (!s.isSettled) money(s.remaining),
                  ],
                ),
            ],
          ],
        ],
      ),
    );
  }

  /// Pay all of what is left, or any other amount. A part payment counts
  /// toward the bill like any other; the rest stays due.
  Future<void> _pay(
    BuildContext context,
    Wallet card,
    CardStatement bill,
    String Function(int) money,
  ) async {
    final l10n = L10n.of(context);
    final full = await showSunriseSheet<bool>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: l10n.cardPayTitle(card.name),
        subtitle: l10n.cardPayHint,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SheetAction(
              key: const Key('card_pay_full'),
              icon: Symbols.check_circle_rounded,
              label: l10n.cardPayFull(money(bill.remaining)),
              subtitle: l10n.cardPayFullHint,
              onTap: () => Navigator.pop(sheet, true),
            ),
            SheetAction(
              key: const Key('card_pay_other'),
              icon: Symbols.edit_rounded,
              label: l10n.cardPayOther,
              subtitle: l10n.cardPayOtherHint,
              onTap: () => Navigator.pop(sheet, false),
            ),
          ],
        ),
      ),
    );
    if (full == null || !context.mounted) return;
    await showAddTransactionScreen(
      context,
      initialType: TransactionTypeSelection.transfer,
      // Left empty for another amount, so the keypad opens on a blank figure.
      prefillAmount: full ? bill.remaining / 100.0 : null,
      prefillTitle: l10n.cardPaymentTitle(card.name),
      prefillToWalletId: card.id,
    );
  }

  Future<void> _changeReminder(
    BuildContext context,
    WidgetRef ref,
    Wallet card,
  ) async {
    final l10n = L10n.of(context);
    final days = await showSunriseSheet<int>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: l10n.cardRemindTitle,
        subtitle: l10n.cardRemindHint,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final d in cardReminderChoices)
              SheetAction(
                key: Key('remind_$d'),
                icon: d == 0
                    ? Symbols.notifications_off_rounded
                    : Symbols.notifications_active_rounded,
                label: cardReminderLabel(l10n, d),
                selected: d == card.dueReminderDays,
                onTap: () => Navigator.pop(sheet, d),
              ),
          ],
        ),
      ),
    );
    if (days == null) return;
    await ref
        .read(walletProvider.notifier)
        .setCardSchedule(
          id: card.id,
          statementDay: card.billingCycleDay,
          dueDay: card.paymentDueDay,
          reminderDays: days,
        );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.label,
    required this.value,
    this.amounts = const [],
    this.onTap,
  });

  /// A line whose whole value is a figure to hide while amounts are hidden.
  _Line.total({required this.label, required this.value})
    : amounts = [value],
      onTap = null;

  final String label;
  final String value;

  /// The figures in [value], which hide while amounts are hidden.
  final List<String> amounts;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: SunriseType.body.copyWith(color: c.muted, fontSize: 14),
            ),
          ),
          SensitiveText(
            value,
            amounts: amounts,
            style: SunriseType.label.copyWith(
              color: onTap == null ? c.ink : c.accent,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (onTap != null)
            Icon(Symbols.chevron_right_rounded, color: c.chevron, size: 18),
        ],
      ),
    );
    return onTap == null ? row : Pressable(onTap: onTap, child: row);
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.bill, required this.today});

  final CardBill bill;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final days = bill.daysUntilDue(today);
    final (label, fg, bg) = switch (bill.status) {
      CardBillStatus.notSetUp => (l10n.cardStatusNotSetUp, c.muted, c.surface),
      CardBillStatus.nothingDue => (
        l10n.cardStatusNothingDue,
        c.positive,
        c.tintGreen,
      ),
      CardBillStatus.paid => (l10n.cardStatusPaid, c.positive, c.tintGreen),
      CardBillStatus.due => (
        l10n.cardStatusDueIn(days),
        c.accentText,
        c.tintPeach,
      ),
      CardBillStatus.dueSoon => (
        days == 0 ? l10n.cardStatusDueToday : l10n.cardStatusDueIn(days),
        c.accentText,
        c.tintAmber,
      ),
      CardBillStatus.overdue => (
        l10n.cardStatusOverdue,
        c.negative,
        c.tintRose,
      ),
    };
    return SunrisePill(label: label, color: fg, background: bg);
  }
}

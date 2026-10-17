import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/utils/color_utils.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/core/utils/time_formatter.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart' as db;
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/settings/widgets/confirmation_dialog.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/features/transactions/widgets/special_type_selector.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Everything recorded about one transaction, and what can be done to it.
///
/// Tapping a row used to open the edit form, so there was nowhere to simply
/// look at a transaction — to check which account it came out of, or whether it
/// had been paid — without being placed one stray keystroke away from changing
/// it. Duplicate had no home either.
class TransactionDetailScreen extends ConsumerStatefulWidget {
  final String transactionId;

  const TransactionDetailScreen({super.key, required this.transactionId});

  @override
  ConsumerState<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState
    extends ConsumerState<TransactionDetailScreen> {
  db.Transaction? _row;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final row = await ref
        .read(databaseProvider)
        .findTransactionById(widget.transactionId);
    if (!mounted) return;
    setState(() {
      _row = row;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final row = _row;

    if (_loading) {
      return SunrisePushPage(
        title: l10n.entityTransaction,
        body: const Center(child: SunriseLoader()),
      );
    }
    if (row == null || row.deletedAt != null) {
      return SunrisePushPage(
        title: l10n.entityTransaction,
        body: Center(
          child: EmptyState(
            icon: Symbols.receipt_long_rounded,
            title: l10n.txGone,
          ),
        ),
      );
    }

    final c = context.sunrise;
    final currency = ref.watch(defaultCurrencyProvider);
    final useDecimals = ref.watch(defaultDecimalProvider);
    final numberFormat = ref.watch(numberFormatSettingProvider);
    final dateFormat = ref.watch(dateFormatSettingProvider);

    String money(int cents) => cents.formatCurrency(
      currency,
      useDecimals: useDecimals,
      numberFormat: numberFormat,
    );

    final categories = ref.watch(categoryProvider).categories;
    final wallets = ref.watch(walletProvider).wallets;
    final budgets = ref.watch(budgetProvider).budgets;

    final category = categories
        .where((c) => c.id == row.categoryId)
        .firstOrNull;
    final wallet = wallets.where((w) => w.id == row.walletId).firstOrNull;
    final budget = budgets.where((b) => b.id == row.budgetId).firstOrNull;

    final specialType = row.specialType ?? TransactionSpecialType.none;
    final isLoan = TransactionPolicy.isCreditOrDebt(row);
    final outstanding = row.amount - row.paidAmount;
    final isTransfer = row.transactionType == 'transfer';
    final settled = row.isPaid && !row.skipPaid;

    final tint = isTransfer
        ? c.accent
        : ColorUtils.hexToColor(category?.colorCode ?? '#9A7869');
    final categoryIcon = isTransfer
        ? Symbols.sync_alt_rounded
        : IconRegistry.getIcon(category?.iconName);
    final kind = switch (row.transactionType) {
      'transfer' => 'Transfer between accounts',
      'recurring_instance' => 'From a repeating entry',
      _ => row.isIncome ? 'Money in' : 'Money out',
    };
    final state = row.skipPaid
        ? 'Skipped'
        : row.isPaid
        ? 'Paid'
        : 'Not yet paid';
    final amount = isTransfer
        ? money(row.amount)
        : '${row.isIncome ? '+' : '−'}${money(row.amount)}';
    final onGlass = Colors.white.withValues(alpha: .22);
    final categoryEmoji = isTransfer
        ? null
        : IconRegistry.emojiOf(category?.iconName);

    return SunrisePushPage(
      title: l10n.entityTransaction,
      actions: [
        SunriseIconButton(
          icon: Symbols.edit_rounded,
          tooltip: l10n.actionEdit,
          onTap: () async {
            await showAddTransactionScreen(context, existingTransaction: row);
            await _load();
          },
        ),
        SunriseIconButton(
          icon: Symbols.more_horiz_rounded,
          tooltip: MaterialLocalizations.of(context).showMenuTooltip,
          onTap: () => _showActions(row),
        ),
      ],
      children: [
        GradientCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconTile(
                    icon: categoryIcon,
                    emoji: categoryEmoji,
                    color: Colors.white,
                    background: onGlass,
                    size: 48,
                    fill: 1,
                  ),
                  const Spacer(),
                  SunrisePill(
                    label: settled ? kind : state,
                    color: Colors.white,
                    background: onGlass,
                    icon: !settled
                        ? Symbols.schedule_rounded
                        : isTransfer
                        ? Symbols.sync_alt_rounded
                        : row.isIncome
                        ? Symbols.south_west_rounded
                        : Symbols.north_east_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 22),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  amount,
                  style: SunriseType.amountHero.copyWith(color: c.onFill),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                row.title.trim().isNotEmpty
                    ? row.title.trim()
                    : (category?.name ?? l10n.txUncategorized),
                style: SunriseType.heroTitle.copyWith(
                  color: c.onFill,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${AppDateFormatter.formatDate(row.date, dateFormat)}'
                ' · ${AppTimeFormatter.of(context, row.date)}',
                style: SunriseType.body.copyWith(
                  color: c.onFill.withValues(alpha: .85),
                ),
              ),
              if (specialType != TransactionSpecialType.none) ...[
                const SizedBox(height: 14),
                SunrisePill(
                  label: specialType.label,
                  icon: specialType.icon,
                  color: Colors.white,
                  background: onGlass,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: SunriseSpace.section),

        if (isLoan) ...[
          SunriseCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      specialType == TransactionSpecialType.credit
                          ? 'Lent out'
                          : 'Borrowed',
                      style: SunriseType.rowTitle.copyWith(color: c.ink),
                    ),
                    const Spacer(),
                    Text(
                      row.amount <= 0 || outstanding <= 0
                          ? '100%'
                          : '${row.paidAmount * 100 ~/ row.amount}%',
                      style: SunriseType.label.copyWith(color: c.positive),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: row.amount <= 0
                        ? 0
                        : (row.paidAmount / row.amount).clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: c.barIdle,
                    color: c.positive,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  outstanding <= 0
                      ? 'Settled in full.'
                      : '${money(row.paidAmount)} back, '
                            '${money(outstanding)} still owed.',
                  style: SunriseType.body.copyWith(color: c.muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: SunriseSpace.section),
        ],

        SettingsGroup(
          children: [
            SettingsRow(
              icon: categoryIcon,
              emoji: categoryEmoji,
              iconColor: tint,
              title: l10n.entityCategory,
              value: isTransfer
                  ? l10n.txTransfer
                  : (category?.name ?? 'Uncategorised'),
              trailing: SettingsTrailing.none,
            ),
            SettingsRow(
              icon: Symbols.account_balance_wallet_rounded,
              iconColor: wallet == null
                  ? c.accent
                  : ColorUtils.hexToColor(wallet.color),
              title: l10n.entityAccount,
              value: wallet?.name ?? 'Unknown',
              trailing: SettingsTrailing.none,
            ),
            SettingsRow(
              icon: Symbols.swap_horiz_rounded,
              iconColor: c.accent,
              title: l10n.txKind,
              value: kind,
              trailing: SettingsTrailing.none,
            ),
            SettingsRow(
              icon: settled
                  ? Symbols.check_circle_rounded
                  : Symbols.schedule_rounded,
              iconColor: settled ? c.positive : c.muted,
              title: l10n.txState,
              value: state,
              trailing: SettingsTrailing.none,
            ),
            if (row.originalDueDate != null)
              SettingsRow(
                icon: Symbols.event_rounded,
                iconColor: c.accent,
                title: l10n.txWasDue,
                value: AppDateFormatter.formatDate(
                  row.originalDueDate!,
                  dateFormat,
                ),
                trailing: SettingsTrailing.none,
              ),
            if (budget != null)
              SettingsRow(
                icon: Symbols.pie_chart_rounded,
                iconColor: c.accent,
                title: l10n.entityBudget,
                value: budget.name,
                trailing: SettingsTrailing.none,
              ),
          ],
        ),

        if (row.notes?.trim().isNotEmpty ?? false) ...[
          const SizedBox(height: SunriseSpace.section),
          SectionLabel(l10n.txNotes),
          SunriseCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Symbols.notes_rounded, color: c.muted, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    row.notes!.trim(),
                    style: SunriseType.body.copyWith(color: c.body),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _showActions(db.Transaction row) {
    final l10n = L10n.of(context);
    showSunriseSheet<void>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SheetAction(
              icon: Symbols.content_copy_rounded,
              label: l10n.txDuplicate,
              onTap: () {
                Navigator.pop(sheet);
                _onAction('duplicate');
              },
            ),
            if (!row.isPaid)
              SheetAction(
                icon: Symbols.check_circle_rounded,
                label: l10n.txMarkAsPaid,
                onTap: () {
                  Navigator.pop(sheet);
                  _onAction('paid');
                },
              ),
            SheetAction(
              icon: Symbols.delete_rounded,
              label: l10n.actionDelete,
              destructive: true,
              onTap: () {
                Navigator.pop(sheet);
                _onAction('delete');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onAction(String action) async {
    final notifier = ref.read(transactionProvider.notifier);

    switch (action) {
      case 'duplicate':
        final copy = await notifier.duplicateTransaction(widget.transactionId);
        if (!mounted) return;
        showSunriseSnack(
          context,
          copy == null
              // The only rows this refuses are transfer legs, and saying so
              // is better than a copy silently not appearing.
              ? 'A transfer cannot be copied on its own.'
              : 'Copied.',
          tone: copy == null ? SnackTone.info : SnackTone.success,
        );
        if (copy != null && mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => TransactionDetailScreen(transactionId: copy),
            ),
          );
        }

      case 'paid':
        await notifier.markManyPaid([widget.transactionId]);
        await _load();

      case 'delete':
        final confirmed = await showConfirmationDialog(
          context: context,
          title: L10n.of(context).txDeleteOneTitle,
          message:
              'The account balance is recalculated. If this is one leg of a '
              'transfer, the other half goes with it.',
          confirmText: L10n.of(context).actionDelete,
          isDangerous: true,
        );
        if (confirmed != true || !mounted) return;
        await notifier.deleteTransaction(widget.transactionId);
        if (mounted) Navigator.pop(context);
    }
  }
}

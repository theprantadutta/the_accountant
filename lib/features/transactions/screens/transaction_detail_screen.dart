import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
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
import 'package:the_accountant/shared/widgets/glass_card.dart';

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
    final row = _row;

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Transaction')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (row == null || row.deletedAt != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Transaction')),
        body: const Center(child: Text('This transaction no longer exists.')),
      );
    }

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction'),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              await showAddTransactionScreen(context, existingTransaction: row);
              await _load();
            },
          ),
          PopupMenuButton<String>(
            onSelected: _onAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'duplicate',
                child: ListTile(
                  leading: Icon(Icons.copy_outlined),
                  title: Text('Duplicate'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              if (!row.isPaid)
                const PopupMenuItem(
                  value: 'paid',
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outline),
                    title: Text('Mark as paid'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete_outline, color: AppColors.error),
                  title: Text(
                    'Delete',
                    style: TextStyle(color: AppColors.error),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.paddingLg,
        children: [
          GlassCard(
            padding: AppSpacing.paddingLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.isIncome ? '+${money(row.amount)}' : money(row.amount),
                  style: AppTypography.displaySmall.copyWith(
                    color: row.isIncome
                        ? AppColors.success
                        : AppColors.textPrimary,
                  ),
                ),
                if (row.title.isNotEmpty) ...[
                  AppSpacing.gapSm,
                  Text(row.title, style: AppTypography.titleMedium),
                ],
                AppSpacing.gapSm,
                Text(
                  AppDateFormatter.formatDate(row.date, dateFormat),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (specialType != TransactionSpecialType.none) ...[
                  AppSpacing.gapMd,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SpecialTypeIndicator(type: specialType),
                  ),
                ],
              ],
            ),
          ),
          AppSpacing.gapLg,

          if (isLoan) ...[
            GlassCard(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    specialType == TransactionSpecialType.credit
                        ? 'Lent out'
                        : 'Borrowed',
                    style: AppTypography.titleSmall,
                  ),
                  AppSpacing.gapSm,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: row.amount <= 0
                          ? 0
                          : (row.paidAmount / row.amount).clamp(0.0, 1.0),
                      minHeight: 6,
                      backgroundColor: AppColors.divider,
                      color: AppColors.success,
                    ),
                  ),
                  AppSpacing.gapSm,
                  Text(
                    outstanding <= 0
                        ? 'Settled in full.'
                        : '${money(row.paidAmount)} back, '
                              '${money(outstanding)} still owed.',
                    style: AppTypography.bodyMedium,
                  ),
                ],
              ),
            ),
            AppSpacing.gapLg,
          ],

          GlassCard(
            padding: AppSpacing.paddingLg,
            child: Column(
              children: [
                _Field(
                  icon: Icons.category_outlined,
                  label: 'Category',
                  value: category?.name ?? 'Uncategorised',
                ),
                _Field(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Account',
                  value: wallet?.name ?? 'Unknown',
                ),
                _Field(
                  icon: Icons.swap_horiz,
                  label: 'Kind',
                  value: switch (row.transactionType) {
                    'transfer' => 'Transfer between accounts',
                    'recurring_instance' => 'From a repeating entry',
                    _ => row.isIncome ? 'Money in' : 'Money out',
                  },
                ),
                _Field(
                  icon: Icons.check_circle_outline,
                  label: 'State',
                  value: row.skipPaid
                      ? 'Skipped'
                      : row.isPaid
                      ? 'Paid'
                      : 'Not yet paid',
                ),
                if (row.originalDueDate != null)
                  _Field(
                    icon: Icons.event_outlined,
                    label: 'Was due',
                    value: AppDateFormatter.formatDate(
                      row.originalDueDate!,
                      dateFormat,
                    ),
                  ),
                if (budget != null)
                  _Field(
                    icon: Icons.pie_chart_outline,
                    label: 'Budget',
                    value: budget.name,
                  ),
                if (row.notes?.isNotEmpty ?? false)
                  _Field(
                    icon: Icons.notes_outlined,
                    label: 'Notes',
                    value: row.notes!,
                    last: true,
                  ),
              ],
            ),
          ),
          AppSpacing.gapXxl,
        ],
      ),
    );
  }

  Future<void> _onAction(String action) async {
    final notifier = ref.read(transactionProvider.notifier);

    switch (action) {
      case 'duplicate':
        final copy = await notifier.duplicateTransaction(widget.transactionId);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              copy == null
                  // The only rows this refuses are transfer legs, and saying so
                  // is better than a copy silently not appearing.
                  ? 'A transfer cannot be copied on its own.'
                  : 'Copied.',
            ),
          ),
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
          title: 'Delete this transaction?',
          message:
              'The account balance is recalculated. If this is one leg of a '
              'transfer, the other half goes with it.',
          confirmText: 'Delete',
          isDangerous: true,
        );
        if (confirmed != true || !mounted) return;
        await notifier.deleteTransaction(widget.transactionId);
        if (mounted) Navigator.pop(context);
    }
  }
}

class _Field extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool last;

  const _Field({
    required this.icon,
    required this.label,
    required this.value,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                Text(value, style: AppTypography.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

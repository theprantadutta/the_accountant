import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/data/models/budget.dart' show BudgetPeriod;
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/premium/exceptions/premium_limit_exception.dart';
import 'package:the_accountant/features/premium/widgets/upgrade_limit_dialog.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

/// Create or edit a budget.
///
/// Replaces a form that could not work. It offered a hard-coded list of twelve
/// category names rather than the user's own categories, and stored the chosen
/// *name* in the id column, so nothing the budget was supposed to watch ever
/// matched. It wrote a legacy dollars column and never wrote the amount the
/// database requires, so saving threw. And it offered two of the six periods.
class AddBudgetScreen extends ConsumerStatefulWidget {
  /// The budget being edited, or null to create one.
  final BudgetView? budget;

  const AddBudgetScreen({super.key, this.budget});

  bool get isEditing => budget != null;

  @override
  ConsumerState<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends ConsumerState<AddBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final TextEditingController _intervalController;

  late BudgetPeriod _period;
  late Set<String> _categoryIds;
  late Set<String> _walletIds;
  late DateTime _startDate;
  DateTime? _endDate;
  late bool _isIncome;
  late bool _rollover;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final b = widget.budget;
    _nameController = TextEditingController(text: b?.name ?? '');
    _amountController = TextEditingController(
      text: b == null ? '' : (b.amount / 100).toStringAsFixed(2),
    );
    _intervalController = TextEditingController(
      text: (b?.periodLength ?? 1).toString(),
    );
    _period = b?.period ?? BudgetPeriod.monthly;
    _categoryIds = {...?b?.categoryIds};
    _walletIds = {...?b?.walletIds};
    _startDate = b?.startDate ?? _startOfToday();
    _endDate = b?.endDate;
    _isIncome = b?.isIncome ?? false;
    _rollover = b?.rollover ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  static DateTime _startOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(defaultCurrencyProvider);
    final dateFormat = ref.watch(dateFormatSettingProvider);
    final categories = ref.watch(categoryProvider).categories;
    final wallets = ref.watch(walletProvider).wallets;

    // A budget watches one side of the ledger, so only offer categories from
    // that side. Picking "Salary" for a spending budget can only ever read zero.
    final selectable = categories
        .where((c) => (c.type == 'income') == _isIncome)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit budget' : 'New budget'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(L10n.of(context).actionSave),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.paddingLg,
          children: [
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: L10n.of(context).payName,
                hintText: L10n.of(context).budgetGroceries,
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Give the budget a name'
                  : null,
            ),
            AppSpacing.gapLg,

            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: _isIncome ? 'Target' : 'Limit',
                prefixText: '${_currencySymbol(currency)} ',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final cents = (v ?? '').toCentsOrNull();
                if (cents == null) return 'Enter an amount';
                if (cents <= 0) return 'The amount must be more than zero';
                return null;
              },
            ),
            AppSpacing.gapXl,

            _SectionLabel(
              _isIncome ? 'Tracking earnings' : 'Tracking spending',
            ),
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(
                  value: false,
                  label: Text(L10n.of(context).budgetSpending),
                ),
                ButtonSegment(
                  value: true,
                  label: Text(L10n.of(context).budgetEarnings),
                ),
              ],
              selected: {_isIncome},
              onSelectionChanged: (s) => setState(() {
                _isIncome = s.first;
                // The categories on the other side are not valid here.
                _categoryIds = {};
              }),
            ),
            AppSpacing.gapXl,

            const _SectionLabel('Repeats'),
            Wrap(
              spacing: 8,
              children: [
                for (final p in BudgetPeriod.values)
                  ChoiceChip(
                    label: Text(_periodLabel(p)),
                    selected: _period == p,
                    onSelected: (_) => setState(() => _period = p),
                  ),
              ],
            ),
            if (_period != BudgetPeriod.custom) ...[
              AppSpacing.gapMd,
              Row(
                children: [
                  Text(L10n.of(context).budgetEvery),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 72,
                    child: TextFormField(
                      controller: _intervalController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      validator: (v) {
                        final n = int.tryParse(v ?? '');
                        if (n == null || n < 1) return '1+';
                        if (n > 999) return 'Too big';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(_periodUnit(_period)),
                ],
              ),
            ],
            AppSpacing.gapXl,

            const _SectionLabel('Starts'),
            _DateRow(
              label: AppDateFormatter.formatDate(_startDate, dateFormat),
              onTap: () => _pickDate(
                initial: _startDate,
                onPicked: (d) => setState(() => _startDate = d),
              ),
            ),
            AppSpacing.gapMd,
            _SectionLabel(
              _period == BudgetPeriod.custom ? 'Ends' : 'Stops repeating',
            ),
            _DateRow(
              label: _endDate == null
                  ? 'Never'
                  : AppDateFormatter.formatDate(_endDate!, dateFormat),
              onClear: _endDate == null
                  ? null
                  : () => setState(() => _endDate = null),
              onTap: () => _pickDate(
                initial: _endDate ?? _startDate,
                onPicked: (d) => setState(() => _endDate = d),
              ),
            ),
            AppSpacing.gapXl,

            _SectionLabel(
              _categoryIds.isEmpty
                  ? 'Categories: all of them'
                  : 'Categories: ${_categoryIds.length} selected',
            ),
            if (selectable.isEmpty)
              Text(
                'No ${_isIncome ? 'income' : 'expense'} categories yet.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final c in selectable)
                    FilterChip(
                      label: Text(c.name),
                      selected: _categoryIds.contains(c.id),
                      onSelected: (on) => setState(() {
                        if (on) {
                          _categoryIds.add(c.id);
                        } else {
                          _categoryIds.remove(c.id);
                        }
                      }),
                    ),
                ],
              ),
            AppSpacing.gapSm,
            Text(
              'Leave empty to watch every category. Anything filed inside a '
              'chosen category counts toward it too.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            AppSpacing.gapXl,

            _SectionLabel(
              _walletIds.isEmpty
                  ? 'Accounts: all of them'
                  : 'Accounts: ${_walletIds.length} selected',
            ),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final w in wallets)
                  FilterChip(
                    label: Text(w.name),
                    selected: _walletIds.contains(w.id),
                    onSelected: (on) => setState(() {
                      if (on) {
                        _walletIds.add(w.id);
                      } else {
                        _walletIds.remove(w.id);
                      }
                    }),
                  ),
              ],
            ),
            AppSpacing.gapXl,

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _rollover,
              onChanged: (v) => setState(() => _rollover = v),
              title: Text(L10n.of(context).budgetCarryOverWhatIsLeft),
              subtitle: const Text(
                'Anything unspent is added to the next period. Going over does '
                'not carry a debt forward.',
              ),
            ),
            AppSpacing.gapXxl,
          ],
        ),
      ),
    );
  }

  static String _currencySymbol(String code) => code;

  static String _periodLabel(BudgetPeriod p) => switch (p) {
    BudgetPeriod.daily => 'Daily',
    BudgetPeriod.weekly => 'Weekly',
    BudgetPeriod.biweekly => 'Fortnightly',
    BudgetPeriod.monthly => 'Monthly',
    BudgetPeriod.yearly => 'Yearly',
    BudgetPeriod.custom => 'One-off',
  };

  static String _periodUnit(BudgetPeriod p) => switch (p) {
    BudgetPeriod.daily => 'days',
    BudgetPeriod.weekly => 'weeks',
    BudgetPeriod.biweekly => 'fortnights',
    BudgetPeriod.monthly => 'months',
    BudgetPeriod.yearly => 'years',
    BudgetPeriod.custom => '',
  };

  Future<void> _pickDate({
    required DateTime initial,
    required ValueChanged<DateTime> onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (picked != null) onPicked(picked);
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final cents = _amountController.text.toCentsOrNull();
    if (cents == null) return;

    // A one-off budget is a fixed span, so it needs both ends.
    if (_period == BudgetPeriod.custom && _endDate == null) {
      _showMessage('A one-off budget needs an end date.');
      return;
    }
    if (_endDate != null && !_endDate!.isAfter(_startDate)) {
      _showMessage('The end date has to come after the start date.');
      return;
    }

    setState(() => _saving = true);
    final notifier = ref.read(budgetProvider.notifier);
    final interval = int.tryParse(_intervalController.text) ?? 1;

    try {
      if (widget.isEditing) {
        await notifier.updateBudget(
          id: widget.budget!.id,
          name: _nameController.text.trim(),
          amount: cents,
          period: _period,
          periodLength: interval,
          startDate: _startDate,
          endDate: _endDate,
          categoryIds: _categoryIds.toList(),
          walletIds: _walletIds.toList(),
          isIncome: _isIncome,
          rollover: _rollover,
        );
      } else {
        await notifier.addBudget(
          name: _nameController.text.trim(),
          amount: cents,
          period: _period,
          periodLength: interval,
          startDate: _startDate,
          endDate: _endDate,
          categoryIds: _categoryIds.toList(),
          walletIds: _walletIds.toList(),
          isIncome: _isIncome,
          rollover: _rollover,
        );
      }
      if (mounted) Navigator.pop(context);
    } on PremiumLimitException catch (e) {
      if (mounted) await UpgradeLimitDialog.showFromException(context, e);
    } catch (e) {
      if (mounted) _showMessage('Could not save the budget.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary),
    ),
  );
}

class _DateRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _DateRow({required this.label, required this.onTap, this.onClear});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 16),
            const SizedBox(width: 10),
            Expanded(child: Text(label)),
            if (onClear != null)
              IconButton(
                icon: const Icon(Icons.clear, size: 18),
                onPressed: onClear,
                tooltip: L10n.of(context).goalClear,
              ),
          ],
        ),
      ),
    );
  }
}

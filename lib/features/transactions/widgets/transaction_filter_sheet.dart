import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/transactions/domain/transaction_filters.dart';
import 'package:the_accountant/features/transactions/widgets/special_type_selector.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

/// Narrow the transaction list.
///
/// Returns the new filters, or null when dismissed. The sheet edits a copy, so
/// backing out leaves the list exactly as it was rather than half-changed.
Future<TransactionFilters?> showTransactionFilterSheet({
  required BuildContext context,
  required TransactionFilters current,
}) {
  return showModalBottomSheet<TransactionFilters>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.primarySurface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => _FilterSheet(initial: current),
  );
}

class _FilterSheet extends ConsumerStatefulWidget {
  final TransactionFilters initial;

  const _FilterSheet({required this.initial});

  @override
  ConsumerState<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<_FilterSheet> {
  late TransactionFilters _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider).categories;
    final wallets = ref.watch(walletProvider).wallets;
    final currency = ref.watch(defaultCurrencyProvider);
    final dateFormat = ref.watch(dateFormatSettingProvider);
    final useDecimals = ref.watch(defaultDecimalProvider);
    final numberFormat = ref.watch(numberFormatSettingProvider);

    String money(int cents) => cents.formatCurrency(
      currency,
      useDecimals: useDecimals,
      numberFormat: numberFormat,
    );

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (context, controller) => Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textMuted.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text('Filter', style: AppTypography.titleLarge),
                ),
                if (_draft.hasActiveFilters)
                  TextButton(
                    onPressed: () => setState(() => _draft = _draft.cleared()),
                    child: const Text('Clear all'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _label('Direction'),
                SegmentedButton<DirectionFilter>(
                  segments: const [
                    ButtonSegment(
                      value: DirectionFilter.any,
                      label: Text('Any'),
                    ),
                    ButtonSegment(
                      value: DirectionFilter.expense,
                      label: Text('Spent'),
                    ),
                    ButtonSegment(
                      value: DirectionFilter.income,
                      label: Text('Earned'),
                    ),
                  ],
                  selected: {_draft.direction},
                  onSelectionChanged: (s) => setState(
                    () => _draft = _draft.copyWith(direction: s.first),
                  ),
                ),
                AppSpacing.gapXl,

                _label('State'),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final option in PaidFilter.values)
                      ChoiceChip(
                        label: Text(_paidLabel(option)),
                        selected: _draft.paid == option,
                        onSelected: (_) => setState(
                          () => _draft = _draft.copyWith(paid: option),
                        ),
                      ),
                  ],
                ),
                AppSpacing.gapXl,

                _label('Kind'),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final type in TransactionSpecialType.values)
                      FilterChip(
                        label: Text(type.label),
                        selected: _draft.specialTypes.contains(type),
                        onSelected: (on) => setState(() {
                          final next = {..._draft.specialTypes};
                          if (on) {
                            next.add(type);
                          } else {
                            next.remove(type);
                          }
                          _draft = _draft.copyWith(specialTypes: next);
                        }),
                      ),
                  ],
                ),
                AppSpacing.gapXl,

                _label('Transfers'),
                SegmentedButton<TransferFilter>(
                  segments: const [
                    ButtonSegment(
                      value: TransferFilter.hide,
                      label: Text('Hidden'),
                    ),
                    ButtonSegment(
                      value: TransferFilter.show,
                      label: Text('Included'),
                    ),
                    ButtonSegment(
                      value: TransferFilter.only,
                      label: Text('Only'),
                    ),
                  ],
                  selected: {_draft.transfers},
                  onSelectionChanged: (s) => setState(
                    () => _draft = _draft.copyWith(transfers: s.first),
                  ),
                ),
                AppSpacing.gapXl,

                if (wallets.isNotEmpty) ...[
                  _label(
                    _draft.walletIds.isEmpty
                        ? 'Accounts: all'
                        : 'Accounts: ${_draft.walletIds.length} selected',
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for (final w in wallets)
                        FilterChip(
                          label: Text(w.name),
                          selected: _draft.walletIds.contains(w.id),
                          onSelected: (on) => setState(() {
                            final next = {..._draft.walletIds};
                            if (on) {
                              next.add(w.id);
                            } else {
                              next.remove(w.id);
                            }
                            _draft = _draft.copyWith(walletIds: next);
                          }),
                        ),
                    ],
                  ),
                  AppSpacing.gapXl,
                ],

                if (categories.isNotEmpty) ...[
                  _label(
                    _draft.categoryIds.isEmpty
                        ? 'Categories: all'
                        : 'Categories: ${_draft.categoryIds.length} selected',
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for (final c in categories)
                        FilterChip(
                          label: Text(c.name),
                          selected: _draft.categoryIds.contains(c.id),
                          onSelected: (on) => setState(() {
                            final next = {..._draft.categoryIds};
                            if (on) {
                              next.add(c.id);
                            } else {
                              next.remove(c.id);
                            }
                            _draft = _draft.copyWith(categoryIds: next);
                          }),
                        ),
                    ],
                  ),
                  AppSpacing.gapXl,
                ],

                _label('Amount'),
                Row(
                  children: [
                    Expanded(
                      child: _AmountField(
                        label: 'From',
                        initial: _draft.minAmount,
                        currency: currency,
                        onChanged: (cents) => setState(
                          () => _draft = _draft.copyWith(minAmount: cents),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _AmountField(
                        label: 'To',
                        initial: _draft.maxAmount,
                        currency: currency,
                        onChanged: (cents) => setState(
                          () => _draft = _draft.copyWith(maxAmount: cents),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_draft.minAmount != null &&
                    _draft.maxAmount != null &&
                    _draft.minAmount! > _draft.maxAmount!) ...[
                  AppSpacing.gapSm,
                  Text(
                    'The lower bound is above the upper one, so nothing can '
                    'match. ${money(_draft.minAmount!)} to '
                    '${money(_draft.maxAmount!)}.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.warning,
                    ),
                  ),
                ],
                AppSpacing.gapXl,

                _label('Dates'),
                Row(
                  children: [
                    Expanded(
                      child: _DateField(
                        label: 'From',
                        value: _draft.from,
                        format: dateFormat,
                        onChanged: (d) =>
                            setState(() => _draft = _draft.copyWith(from: d)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DateField(
                        label: 'To',
                        value: _draft.to,
                        format: dateFormat,
                        onChanged: (d) =>
                            setState(() => _draft = _draft.copyWith(to: d)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, _draft),
                  child: const Text('Apply'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary),
    ),
  );

  static String _paidLabel(PaidFilter f) => switch (f) {
    PaidFilter.any => 'Any',
    PaidFilter.paid => 'Paid',
    PaidFilter.unpaid => 'Not yet',
    PaidFilter.skipped => 'Skipped',
  };
}

class _AmountField extends StatefulWidget {
  final String label;
  final int? initial;
  final String currency;
  final ValueChanged<int?> onChanged;

  const _AmountField({
    required this.label,
    required this.initial,
    required this.currency,
    required this.onChanged,
  });

  @override
  State<_AmountField> createState() => _AmountFieldState();
}

class _AmountFieldState extends State<_AmountField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initial == null
          ? ''
          : (widget.initial! / 100).toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: widget.label,
        prefixText: '${widget.currency} ',
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      onChanged: (text) =>
          widget.onChanged(text.trim().isEmpty ? null : text.toCentsOrNull()),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final String format;
  final ValueChanged<DateTime?> onChanged;

  const _DateField({
    required this.label,
    required this.value,
    required this.format,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 10),
          lastDate: DateTime(DateTime.now().year + 5),
        );
        if (picked != null) onChanged(picked);
      },
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
          suffixIcon: value == null
              ? const Icon(Icons.calendar_today, size: 16)
              : IconButton(
                  icon: const Icon(Icons.clear, size: 16),
                  onPressed: () => onChanged(null),
                ),
        ),
        child: Text(
          value == null
              ? 'Any'
              : AppDateFormatter.formatShortDate(value!, format),
        ),
      ),
    );
  }
}

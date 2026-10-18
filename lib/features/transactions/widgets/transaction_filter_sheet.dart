import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/utils/color_utils.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/objectives/providers/objectives_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/transactions/domain/transaction_filters.dart';
import 'package:the_accountant/features/transactions/widgets/special_type_selector.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/shared/widgets/registry_icon.dart';

/// Narrow the transaction list.
///
/// Returns the new filters, or null when dismissed. The sheet edits a copy, so
/// backing out leaves the list exactly as it was rather than half-changed.
///
/// [countFor] says how many transactions a set of filters would show, so the
/// button can say what applying will do before it is pressed.
Future<TransactionFilters?> showTransactionFilterSheet({
  required BuildContext context,
  required TransactionFilters current,
  int Function(TransactionFilters filters)? countFor,
}) {
  return showModalBottomSheet<TransactionFilters>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _FilterSheet(initial: current, countFor: countFor),
  );
}

class _FilterSheet extends ConsumerStatefulWidget {
  final TransactionFilters initial;
  final int Function(TransactionFilters filters)? countFor;

  const _FilterSheet({required this.initial, this.countFor});

  @override
  ConsumerState<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<_FilterSheet> {
  late TransactionFilters _draft;

  /// Narrows the category chips; empty shows the top-level ones.
  String _categoryQuery = '';
  bool _allCategories = false;

  /// How many top-level categories show before "Show all".
  static const int _categoryPreview = 12;

  @override
  void initState() {
    super.initState();
    _draft = widget.initial;
  }

  Set<T> _toggled<T>(Set<T> set, T value, bool on) =>
      on ? {...set, value} : ({...set}..remove(value));

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final categories = ref.watch(categoryProvider).categories;
    final wallets = ref.watch(walletProvider).wallets;
    final budgets = ref.watch(budgetProvider).budgets;
    final objectives =
        ref.watch(allObjectivesProvider).asData?.value ?? const [];
    final currency = ref.watch(defaultCurrencyProvider);
    final dateFormat = ref.watch(dateFormatSettingProvider);
    final useDecimals = ref.watch(defaultDecimalProvider);
    final numberFormat = ref.watch(numberFormatSettingProvider);

    String money(int cents) => cents.formatCurrency(
      currency,
      useDecimals: useDecimals,
      numberFormat: numberFormat,
    );

    final count = widget.countFor?.call(_draft);

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
                  child: Text(
                    l10n.filterTitle,
                    style: AppTypography.titleLarge,
                  ),
                ),
                if (_draft.hasActiveFilters)
                  TextButton(
                    onPressed: () => setState(() => _draft = _draft.cleared()),
                    child: Text(l10n.filterClearAll),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                // The two things most searches start from come first.
                if (categories.isNotEmpty) ...[
                  _label(l10n.filterCategories, _draft.categoryIds.length),
                  _categorySection(categories, l10n),
                  AppSpacing.gapXl,
                ],

                if (wallets.isNotEmpty) ...[
                  _label(l10n.filterAccounts, _draft.walletIds.length),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for (final w in wallets)
                        FilterChip(
                          avatar: Icon(
                            IconRegistry.getIcon(w.iconName),
                            size: 18,
                            color: ColorUtils.hexToColor(w.color),
                          ),
                          label: Text(w.name),
                          selected: _draft.walletIds.contains(w.id),
                          onSelected: (on) => setState(
                            () => _draft = _draft.copyWith(
                              walletIds: _toggled(_draft.walletIds, w.id, on),
                            ),
                          ),
                        ),
                    ],
                  ),
                  AppSpacing.gapXl,
                ],

                _label(l10n.filterDirection),
                SegmentedButton<DirectionFilter>(
                  segments: [
                    ButtonSegment(
                      value: DirectionFilter.any,
                      label: Text(l10n.filterAny),
                    ),
                    ButtonSegment(
                      value: DirectionFilter.expense,
                      label: Text(l10n.filterSpent),
                    ),
                    ButtonSegment(
                      value: DirectionFilter.income,
                      label: Text(l10n.filterEarned),
                    ),
                  ],
                  selected: {_draft.direction},
                  onSelectionChanged: (s) => setState(
                    () => _draft = _draft.copyWith(direction: s.first),
                  ),
                ),
                AppSpacing.gapXl,

                _label(l10n.filterDates),
                _datePresets(l10n),
                AppSpacing.gapSm,
                Row(
                  children: [
                    Expanded(
                      child: _DateField(
                        label: l10n.filterFrom,
                        value: _draft.from,
                        format: dateFormat,
                        onChanged: (d) =>
                            setState(() => _draft = _draft.copyWith(from: d)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DateField(
                        label: l10n.filterTo,
                        value: _draft.to,
                        format: dateFormat,
                        onChanged: (d) =>
                            setState(() => _draft = _draft.copyWith(to: d)),
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapXl,

                _label(l10n.filterAmount),
                Row(
                  children: [
                    Expanded(
                      child: _AmountField(
                        label: l10n.filterFrom,
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
                        label: l10n.filterTo,
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

                if (budgets.isNotEmpty) ...[
                  _label(l10n.filterBudget, _draft.budgetIds.length),
                  _assignmentChips(
                    l10n,
                    [for (final b in budgets) (b.id, b.name)],
                    _draft.budgetIds,
                    (next) => _draft = _draft.copyWith(budgetIds: next),
                  ),
                  AppSpacing.gapXl,
                ],

                if (objectives.isNotEmpty) ...[
                  _label(l10n.filterGoal, _draft.objectiveIds.length),
                  _assignmentChips(
                    l10n,
                    [
                      for (final o in objectives)
                        (o.objective.id, o.objective.name),
                    ],
                    _draft.objectiveIds,
                    (next) => _draft = _draft.copyWith(objectiveIds: next),
                  ),
                  AppSpacing.gapXl,
                ],

                _label(l10n.filterKind, _draft.specialTypes.length),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final type in TransactionSpecialType.values)
                      FilterChip(
                        label: Text(type.label),
                        selected: _draft.specialTypes.contains(type),
                        onSelected: (on) => setState(
                          () => _draft = _draft.copyWith(
                            specialTypes: _toggled(
                              _draft.specialTypes,
                              type,
                              on,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                AppSpacing.gapXl,

                _label(l10n.filterState),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final option in PaidFilter.values)
                      ChoiceChip(
                        label: Text(_paidLabel(option, l10n)),
                        selected: _draft.paid == option,
                        onSelected: (_) => setState(
                          () => _draft = _draft.copyWith(paid: option),
                        ),
                      ),
                  ],
                ),
                AppSpacing.gapXl,

                _label(l10n.filterTransfers),
                SegmentedButton<TransferFilter>(
                  segments: [
                    ButtonSegment(
                      value: TransferFilter.hide,
                      label: Text(l10n.filterHidden),
                    ),
                    ButtonSegment(
                      value: TransferFilter.show,
                      label: Text(l10n.filterIncluded),
                    ),
                    ButtonSegment(
                      value: TransferFilter.only,
                      label: Text(l10n.filterOnly),
                    ),
                  ],
                  selected: {_draft.transfers},
                  onSelectionChanged: (s) => setState(
                    () => _draft = _draft.copyWith(transfers: s.first),
                  ),
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
                  onPressed: count == 0
                      ? null
                      : () => Navigator.pop(context, _draft),
                  child: Text(
                    count == null
                        ? l10n.actionApply
                        : l10n.filterShowCount(count),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Categories as their own coloured icons.
  ///
  /// Only top-level ones until a search: choosing one already includes what is
  /// filed inside it, and a wall of every subcategory is unreadable with a
  /// real set of categories. A search reaches the subcategories by name, shown
  /// with their parent. The app's own Transfer category is left out — the
  /// Transfers control below is how those are shown.
  Widget _categorySection(List<Category> categories, L10n l10n) {
    final names = {for (final c in categories) c.id: c.name};
    final usable = categories
        .where((c) => c.defaultKey != SystemCategoryKeys.transfer)
        .where((c) => !c.isArchived || _draft.categoryIds.contains(c.id))
        .toList();
    final query = _categoryQuery.trim().toLowerCase();

    final List<Category> shown;
    if (query.isNotEmpty) {
      shown = usable
          .where((c) => c.name.toLowerCase().contains(query))
          .toList();
    } else {
      final top = usable.where((c) => c.mainCategoryId == null).toList();
      // Anything already chosen stays visible, even past the preview.
      shown = _allCategories || top.length <= _categoryPreview
          ? top
          : [
              ...top.take(_categoryPreview),
              ...top
                  .skip(_categoryPreview)
                  .where((c) => _draft.categoryIds.contains(c.id)),
            ];
      for (final id in _draft.categoryIds) {
        final chosen = usable.where((c) => c.id == id).firstOrNull;
        if (chosen != null && !shown.contains(chosen)) shown.add(chosen);
      }
    }
    final topCount = usable.where((c) => c.mainCategoryId == null).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (usable.length > _categoryPreview) ...[
          TextField(
            decoration: InputDecoration(
              hintText: l10n.catSearch,
              prefixIcon: const Icon(Icons.search, size: 20),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (value) => setState(() => _categoryQuery = value),
          ),
          AppSpacing.gapSm,
        ],
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final c in shown)
              FilterChip(
                avatar: RegistryIcon(
                  c.iconName,
                  size: 18,
                  color: ColorUtils.hexToColor(c.colorCode),
                ),
                label: Text(
                  c.mainCategoryId == null
                      ? c.name
                      : '${names[c.mainCategoryId] ?? ''} › ${c.name}',
                ),
                selected: _draft.categoryIds.contains(c.id),
                onSelected: (on) => setState(
                  () => _draft = _draft.copyWith(
                    categoryIds: _toggled(_draft.categoryIds, c.id, on),
                  ),
                ),
              ),
          ],
        ),
        if (query.isEmpty && topCount > _categoryPreview)
          TextButton(
            onPressed: () => setState(() => _allCategories = !_allCategories),
            child: Text(
              _allCategories
                  ? l10n.filterShowLess
                  : l10n.filterShowAll(topCount),
            ),
          ),
      ],
    );
  }

  /// Budgets or goals, with "None" for rows assigned to neither.
  Widget _assignmentChips(
    L10n l10n,
    List<(String, String)> options,
    Set<String> selected,
    void Function(Set<String> next) write,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final (id, name) in [
          (TransactionFilters.unassigned, l10n.filterNone),
          ...options,
        ])
          FilterChip(
            label: Text(name),
            selected: selected.contains(id),
            onSelected: (on) =>
                setState(() => write(_toggled(selected, id, on))),
          ),
      ],
    );
  }

  /// One tap for the ranges people actually ask about.
  Widget _datePresets(L10n l10n) {
    final now = DateTime.now();
    final presets = <(String, DateTime, DateTime)>[
      (
        l10n.filterThisMonth,
        DateTime(now.year, now.month),
        DateTime(now.year, now.month + 1, 0),
      ),
      (
        l10n.filterLastMonth,
        DateTime(now.year, now.month - 1),
        DateTime(now.year, now.month, 0),
      ),
      (
        l10n.filterLast3Months,
        DateTime(now.year, now.month - 2),
        DateTime(now.year, now.month + 1, 0),
      ),
      (l10n.filterThisYear, DateTime(now.year), DateTime(now.year, 12, 31)),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final (label, from, to) in presets)
          ChoiceChip(
            label: Text(label),
            selected: _draft.from == from && _draft.to == to,
            onSelected: (on) => setState(
              () => _draft = on
                  ? _draft.copyWith(from: from, to: to)
                  : _draft.copyWith(from: null, to: null),
            ),
          ),
      ],
    );
  }

  Widget _label(String text, [int selected = 0]) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      selected == 0 ? text : '$text · $selected',
      style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary),
    ),
  );

  static String _paidLabel(PaidFilter f, L10n l10n) => switch (f) {
    PaidFilter.any => l10n.filterAny,
    PaidFilter.paid => l10n.filterPaid,
    PaidFilter.unpaid => l10n.filterNotYet,
    PaidFilter.skipped => l10n.filterSkipped,
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
              ? L10n.of(context).filterAny
              : AppDateFormatter.formatShortDate(value!, format),
        ),
      ),
    );
  }
}

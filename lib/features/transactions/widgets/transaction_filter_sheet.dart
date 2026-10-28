import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
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
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

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
  return showSunriseSheet<TransactionFilters>(
    context: context,
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

/// Every section is a heading over one line that scrolls sideways.
///
/// The sheet used to wrap every group of chips onto as many lines as it took,
/// so a real set of categories and accounts pushed everything else off the
/// screen, and the three-way controls broke "Included" onto a second line on a
/// narrow phone. One line per section keeps the whole sheet readable at a
/// glance, with what is chosen pulled to the front of its line.
class _FilterSheetState extends ConsumerState<_FilterSheet> {
  late TransactionFilters _draft;

  /// Narrows the category line; empty shows the top-level categories.
  String _categoryQuery = '';

  @override
  void initState() {
    super.initState();
    _draft = widget.initial;
  }

  Set<T> _toggled<T>(Set<T> set, T value, bool on) =>
      on ? {...set, value} : ({...set}..remove(value));

  void _edit(TransactionFilters next) => setState(() => _draft = next);

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
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

    return SunriseBottomSheet(
      padding: const EdgeInsets.only(bottom: 8),
      actions: [
        Row(
          children: [
            // Kept short, so the count beside it is never cut off.
            if (_draft.hasActiveFilters) ...[
              SunriseButton.secondary(
                label: l10n.filterClear,
                height: 54,
                expand: false,
                onPressed: () => _edit(_draft.cleared()),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: SunriseButton(
                height: 54,
                // Short when nothing matches, so it fits beside Clear.
                label: count == null
                    ? l10n.actionApply
                    : count == 0
                    ? l10n.filterNoMatches
                    : l10n.filterShowCount(count),
                onPressed: count == 0
                    ? null
                    : () => Navigator.pop(context, _draft),
              ),
            ),
          ],
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.filterTitle,
                    style: SunriseType.section.copyWith(
                      color: c.ink,
                      fontSize: 22,
                    ),
                  ),
                ),
                if (_draft.activeCount > 0)
                  SunrisePill(
                    label: '${_draft.activeCount}',
                    color: c.accentText,
                    background: c.tintOrange,
                  ),
              ],
            ),
          ),

          // The two things most searches start from come first.
          if (categories.isNotEmpty)
            _Section(
              title: l10n.filterCategories,
              selected: _draft.categoryIds.length,
              trailing: _draft.categoryIds.isEmpty
                  ? null
                  : _clearLink(
                      () => _edit(_draft.copyWith(categoryIds: const {})),
                    ),
              child: _categorySection(categories, l10n),
            ),

          if (wallets.isNotEmpty)
            _Section(
              title: l10n.filterAccounts,
              selected: _draft.walletIds.length,
              child: _ChipLine(
                children: [
                  for (final w in _chosenFirst(
                    wallets,
                    (w) => _draft.walletIds.contains(w.id),
                  ))
                    SunriseChip(
                      icon: IconRegistry.getIcon(w.iconName),
                      label: w.name,
                      selected: _draft.walletIds.contains(w.id),
                      onTap: () => _edit(
                        _draft.copyWith(
                          walletIds: _toggled(
                            _draft.walletIds,
                            w.id,
                            !_draft.walletIds.contains(w.id),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

          _Section(
            title: l10n.filterDirection,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SunriseSegmented<DirectionFilter>(
                value: _draft.direction,
                options: [
                  SegmentOption(DirectionFilter.any, l10n.filterAny),
                  SegmentOption(DirectionFilter.expense, l10n.filterSpent),
                  SegmentOption(DirectionFilter.income, l10n.filterEarned),
                ],
                onChanged: (v) => _edit(_draft.copyWith(direction: v)),
              ),
            ),
          ),

          _Section(
            title: l10n.filterTransfers,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SunriseSegmented<TransferFilter>(
                value: _draft.transfers,
                options: [
                  SegmentOption(TransferFilter.hide, l10n.filterHidden),
                  SegmentOption(TransferFilter.show, l10n.filterIncluded),
                  SegmentOption(TransferFilter.only, l10n.filterOnly),
                ],
                onChanged: (v) => _edit(_draft.copyWith(transfers: v)),
              ),
            ),
          ),

          _Section(
            title: l10n.filterDates,
            trailing: _draft.from == null && _draft.to == null
                ? null
                : _clearLink(
                    () => _edit(_draft.copyWith(from: null, to: null)),
                  ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _datePresets(l10n),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _DateButton(
                          label: l10n.filterFrom,
                          value: _draft.from,
                          format: dateFormat,
                          onChanged: (d) => _edit(_draft.copyWith(from: d)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          Symbols.arrow_forward_rounded,
                          size: 18,
                          color: c.subtle,
                        ),
                      ),
                      Expanded(
                        child: _DateButton(
                          label: l10n.filterTo,
                          value: _draft.to,
                          format: dateFormat,
                          onChanged: (d) => _edit(_draft.copyWith(to: d)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          _Section(
            title: l10n.filterAmount,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _AmountField(
                          hint: l10n.filterFrom,
                          initial: _draft.minAmount,
                          currency: currency,
                          onChanged: (cents) =>
                              _edit(_draft.copyWith(minAmount: cents)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          Symbols.arrow_forward_rounded,
                          size: 18,
                          color: c.subtle,
                        ),
                      ),
                      Expanded(
                        child: _AmountField(
                          hint: l10n.filterTo,
                          initial: _draft.maxAmount,
                          currency: currency,
                          onChanged: (cents) =>
                              _edit(_draft.copyWith(maxAmount: cents)),
                        ),
                      ),
                    ],
                  ),
                  if (_draft.minAmount != null &&
                      _draft.maxAmount != null &&
                      _draft.minAmount! > _draft.maxAmount!) ...[
                    const SizedBox(height: 8),
                    Text(
                      'The lower bound is above the upper one, so nothing can '
                      'match. ${money(_draft.minAmount!)} to '
                      '${money(_draft.maxAmount!)}.',
                      style: SunriseType.caption.copyWith(color: c.negative),
                    ),
                  ],
                ],
              ),
            ),
          ),

          if (budgets.isNotEmpty)
            _Section(
              title: l10n.filterBudget,
              selected: _draft.budgetIds.length,
              child: _assignmentChips(
                l10n,
                [for (final b in budgets) (b.id, b.name)],
                _draft.budgetIds,
                (next) => _draft.copyWith(budgetIds: next),
              ),
            ),

          if (objectives.isNotEmpty)
            _Section(
              title: l10n.filterGoal,
              selected: _draft.objectiveIds.length,
              child: _assignmentChips(
                l10n,
                [
                  for (final o in objectives)
                    (o.objective.id, o.objective.name),
                ],
                _draft.objectiveIds,
                (next) => _draft.copyWith(objectiveIds: next),
              ),
            ),

          _Section(
            title: l10n.filterKind,
            selected: _draft.specialTypes.length,
            child: _ChipLine(
              children: [
                for (final type in TransactionSpecialType.values)
                  SunriseChip(
                    label: type.label,
                    selected: _draft.specialTypes.contains(type),
                    onTap: () => _edit(
                      _draft.copyWith(
                        specialTypes: _toggled(
                          _draft.specialTypes,
                          type,
                          !_draft.specialTypes.contains(type),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          _Section(
            title: l10n.filterState,
            child: _ChipLine(
              children: [
                for (final option in PaidFilter.values)
                  SunriseChip(
                    label: _paidLabel(option, l10n),
                    selected: _draft.paid == option,
                    onTap: () => _edit(_draft.copyWith(paid: option)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// "Clear", beside a section's heading, for just that section.
  Widget _clearLink(VoidCallback onTap) {
    final c = context.sunrise;
    return Pressable(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          L10n.of(context).filterClear,
          style: SunriseType.label.copyWith(
            color: c.accentText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// What is chosen first, then the rest in their usual order, so a choice is
  /// never hidden off the end of its line.
  static List<T> _chosenFirst<T>(List<T> items, bool Function(T) chosen) => [
    ...items.where(chosen),
    ...items.where((i) => !chosen(i)),
  ];

  /// Categories as their own coloured tiles, on one line.
  ///
  /// Only top-level ones until a search: choosing one already includes what is
  /// filed inside it. A search reaches the subcategories by name. The app's own
  /// Transfer category is left out — the Transfers control is how those are
  /// shown.
  Widget _categorySection(List<Category> categories, L10n l10n) {
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
      shown = [
        ...usable.where((c) => c.mainCategoryId == null),
        // A chosen subcategory stays visible without a search.
        ...usable.where(
          (c) => c.mainCategoryId != null && _draft.categoryIds.contains(c.id),
        ),
      ];
    }
    final ordered = _chosenFirst(
      shown,
      (c) => _draft.categoryIds.contains(c.id),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (usable.length > 8) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SunriseSearchField(
              hint: l10n.catSearch,
              onChanged: (value) => setState(() => _categoryQuery = value),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (ordered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              l10n.catNoMatch,
              style: SunriseType.label.copyWith(color: context.sunrise.subtle),
            ),
          )
        else
          _ChipLine(
            spacing: 4,
            children: [
              for (final cat in ordered)
                CategoryTile(
                  icon: cat.iconName != null
                      ? IconRegistry.getIcon(cat.iconName!)
                      : Symbols.category_rounded,
                  emoji: IconRegistry.emojiOf(cat.iconName),
                  label: cat.name,
                  size: 50,
                  width: 72,
                  color: ColorUtils.hexToColor(cat.colorCode),
                  selected: _draft.categoryIds.contains(cat.id),
                  onTap: () => _edit(
                    _draft.copyWith(
                      categoryIds: _toggled(
                        _draft.categoryIds,
                        cat.id,
                        !_draft.categoryIds.contains(cat.id),
                      ),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  /// Budgets or goals, with "None" for rows assigned to neither.
  Widget _assignmentChips(
    L10n l10n,
    List<(String, String)> options,
    Set<String> selected,
    TransactionFilters Function(Set<String> next) write,
  ) {
    final all = [(TransactionFilters.unassigned, l10n.filterNone), ...options];
    return _ChipLine(
      children: [
        for (final (id, name) in _chosenFirst(
          all,
          (o) => selected.contains(o.$1),
        ))
          SunriseChip(
            label: name,
            selected: selected.contains(id),
            onTap: () =>
                _edit(write(_toggled(selected, id, !selected.contains(id)))),
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
    return _ChipLine(
      children: [
        for (final (label, from, to) in presets)
          SunriseChip(
            label: label,
            selected: _draft.from == from && _draft.to == to,
            onTap: () => _edit(
              _draft.from == from && _draft.to == to
                  ? _draft.copyWith(from: null, to: null)
                  : _draft.copyWith(from: from, to: to),
            ),
          ),
      ],
    );
  }

  static String _paidLabel(PaidFilter f, L10n l10n) => switch (f) {
    PaidFilter.any => l10n.filterAny,
    PaidFilter.paid => l10n.filterPaid,
    PaidFilter.unpaid => l10n.filterNotYet,
    PaidFilter.skipped => l10n.filterSkipped,
  };
}

/// A heading, with how many are chosen, over its controls.
class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.selected = 0,
    this.trailing,
  });

  final String title;
  final int selected;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 12, 10),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    title.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: SunriseType.label.copyWith(
                      color: c.muted,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .8,
                    ),
                  ),
                ),
                if (selected > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: c.accent,
                      borderRadius: BorderRadius.circular(SunriseRadius.chip),
                    ),
                    child: Text(
                      '$selected',
                      style: SunriseType.label.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                ?trailing,
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}

/// One line of chips that scrolls sideways, running to the sheet's edges.
class _ChipLine extends StatelessWidget {
  const _ChipLine({required this.children, this.spacing = 8});

  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(width: spacing),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _AmountField extends StatefulWidget {
  final String hint;
  final int? initial;
  final String currency;
  final ValueChanged<int?> onChanged;

  const _AmountField({
    required this.hint,
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
  void didUpdateWidget(covariant _AmountField old) {
    super.didUpdateWidget(old);
    // "Clear all" empties the bound; the field follows.
    if (widget.initial == null && old.initial != null) _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return TextField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: SunriseType.body.copyWith(color: c.ink),
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixText: '${widget.currency} ',
        prefixStyle: SunriseType.body.copyWith(color: c.subtle),
        isDense: true,
      ),
      onChanged: (text) =>
          widget.onChanged(text.trim().isEmpty ? null : text.toCentsOrNull()),
    );
  }
}

/// A day bound, as a tappable pill that opens the calendar.
class _DateButton extends StatelessWidget {
  final String label;
  final DateTime? value;
  final String format;
  final ValueChanged<DateTime?> onChanged;

  const _DateButton({
    required this.label,
    required this.value,
    required this.format,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final set = value != null;
    return Pressable(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? now,
          firstDate: DateTime(2000),
          lastDate: DateTime(now.year + 5, 12, 31),
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: set ? c.tintPeach : c.surface,
          borderRadius: SunriseRadius.inputAll,
          border: Border.all(
            color: set ? c.accent.withValues(alpha: .35) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(Symbols.event_rounded, size: 18, color: c.accent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                set ? AppDateFormatter.formatShortDate(value!, format) : label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: SunriseType.label.copyWith(
                  color: set ? c.ink : c.subtle,
                  fontSize: 14.5,
                  fontWeight: set ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            if (set)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(null),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(Symbols.close_rounded, size: 18, color: c.subtle),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

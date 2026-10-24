import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/domain/default_wallet.dart';
import 'package:the_accountant/core/providers/data_reload.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/investments/screens/investment_trade_screen.dart'
    show askAmount, pickTradeAccount;
import 'package:the_accountant/features/plans/widgets/plan_labels.dart';
import 'package:the_accountant/features/split/providers/split_provider.dart';
import 'package:the_accountant/features/split/services/split_service.dart';
import 'package:the_accountant/features/transactions/widgets/category_picker_sheet.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// A closing sheet hands focus back to the field that had it, which put the
/// keyboard over the form; drop it around every sheet.
void _dropFocus() => FocusManager.instance.primaryFocus?.unfocus();

/// Split a bill between the user and friends.
///
/// Everything the bill needs is on one page, and the shares underneath are
/// worked out again on every change by the same code that records them, so
/// what is shown is exactly what will be written.
class SplitBillScreen extends ConsumerStatefulWidget {
  const SplitBillScreen({
    super.key,
    this.initialTitle,
    this.initialTotal = 0,
    this.initialCategoryId,
    this.initialWalletId,
    this.initialDate,
  });

  final String? initialTitle;

  /// Minor units.
  final int initialTotal;
  final String? initialCategoryId;
  final String? initialWalletId;
  final DateTime? initialDate;

  @override
  ConsumerState<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends ConsumerState<SplitBillScreen> {
  late final TextEditingController _title;
  late int _total;
  late DateTime _date;
  String? _walletId;
  String? _categoryId;
  final List<String> _people = [];
  bool _includeMe = true;
  String? _paidBy;
  SplitMode _mode = SplitMode.equal;
  final Map<String?, int> _amounts = {};
  final Map<String?, double> _percents = {};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.initialTitle ?? '');
    _total = widget.initialTotal;
    _date = widget.initialDate ?? DateTime.now();
    _categoryId = widget.initialCategoryId;
    final wallets = ref.read(selectableWalletsProvider);
    _walletId =
        wallets.where((w) => w.id == widget.initialWalletId).firstOrNull?.id ??
        resolveDefaultWallet(wallets.where((w) => !w.walletType.isManaged))?.id;
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  SplitDraft _draft() => SplitDraft(
    title: _title.text,
    total: _total,
    walletId: _walletId ?? '',
    categoryId: _categoryId ?? '',
    people: _people,
    includeMe: _includeMe,
    paidBy: _paidBy,
    mode: _mode,
    amounts: _amounts,
    percents: _percents,
    date: _date,
  );

  /// The shares as they stand, or why they cannot be worked out yet.
  (List<SplitShare>?, String?) _shares() {
    if (_total <= 0 || _people.isEmpty) return (null, null);
    try {
      return (SplitService.shares(_draft()), null);
    } on ArgumentError catch (e) {
      return (null, '${e.message}');
    }
  }

  Future<void> _save() async {
    final l10n = L10n.of(context);
    if (_walletId == null) {
      showSunriseSnack(context, l10n.planNeedAccount, tone: SnackTone.error);
      return;
    }
    if (_categoryId == null) {
      showSunriseSnack(context, l10n.splitNeedCategory, tone: SnackTone.error);
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(splitServiceProvider).record(_draft());
      reloadAllData(ref);
      if (!mounted) return;
      Navigator.of(context).pop(true);
      showSunriseSnack(context, l10n.splitSaved, tone: SnackTone.success);
    } on ArgumentError catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        showSunriseSnack(context, '${e.message}', tone: SnackTone.error);
      }
    }
  }

  // ------------------------------------------------------------- pickers

  Future<void> _pickDate() async {
    _dropFocus();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    _dropFocus();
    if (picked == null) return;
    final now = DateTime.now();
    setState(
      () => _date = DateUtils.isSameDay(picked, now)
          ? now
          : DateTime(picked.year, picked.month, picked.day, 12),
    );
  }

  Future<void> _pickCategory() async {
    _dropFocus();
    final category = await showCategoryPickerSheet(
      context: context,
      ref: ref,
      selectedCategoryId: _categoryId,
    );
    _dropFocus();
    if (category != null) setState(() => _categoryId = category.id);
  }

  Future<void> _addPerson() async {
    _dropFocus();
    final known = ref.read(splitPeopleProvider).value ?? const [];
    final name = await showSunriseSheet<String>(
      context: context,
      builder: (sheet) => _AddPersonSheet(
        suggestions: [
          for (final k in known)
            if (!_people.any((p) => p.toLowerCase() == k.toLowerCase())) k,
        ],
      ),
    );
    _dropFocus();
    final clean = name?.trim() ?? '';
    if (clean.isEmpty ||
        _people.any((p) => p.toLowerCase() == clean.toLowerCase())) {
      return;
    }
    setState(() => _people.add(clean));
  }

  void _removePerson(String name) {
    HapticFeedback.selectionClick();
    setState(() {
      _people.remove(name);
      _amounts.remove(name);
      _percents.remove(name);
      if (_paidBy == name) _paidBy = null;
    });
  }

  Future<void> _pickPayer() async {
    _dropFocus();
    final l10n = L10n.of(context);
    // A null result is a dismissed sheet, so the user is a value of its own.
    const me = '\u0000me';
    final picked = await showSunriseSheet<String>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: l10n.splitPaidBy,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SheetAction(
              icon: Symbols.person_rounded,
              label: l10n.splitYou,
              selected: _paidBy == null,
              onTap: () => Navigator.pop(sheet, me),
            ),
            for (final p in _people)
              SheetAction(
                icon: Symbols.group_rounded,
                label: p,
                selected: _paidBy == p,
                onTap: () => Navigator.pop(sheet, p),
              ),
          ],
        ),
      ),
    );
    _dropFocus();
    if (picked == null) return;
    setState(() {
      _paidBy = picked == me ? null : picked;
      // Someone else paying for the user only makes sense if they had a
      // share; the toggle comes back on rather than leaving nothing to record.
      if (_paidBy != null) _includeMe = true;
    });
  }

  Future<void> _editShare(String? person, String currency) async {
    if (_mode == SplitMode.exact) {
      final v = await askAmount(
        context,
        initial: _amounts[person] ?? 0,
        currency: currency,
      );
      if (v != null) setState(() => _amounts[person] = v);
    } else if (_mode == SplitMode.percent) {
      _dropFocus();
      final v = await showSunriseSheet<double>(
        context: context,
        builder: (sheet) =>
            _PercentSheet(name: person, initial: _percents[person]),
      );
      _dropFocus();
      if (v != null) setState(() => _percents[person] = v);
    }
  }

  // --------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final f = PlanFormat(ref, context);
    ref.watch(splitPeopleProvider);
    final wallet = ref
        .watch(walletProvider)
        .wallets
        .where((w) => w.id == _walletId)
        .firstOrNull;
    final currency = wallet?.currency ?? '';
    final category = ref
        .watch(categoryProvider)
        .categories
        .where((x) => x.id == _categoryId)
        .firstOrNull;
    final (shares, problem) = _shares();
    String money(int v) => f.money(v, currency);

    String? shareNote(SplitShare s) {
      if (_paidBy == null) {
        return s.isMe ? l10n.splitYourShare : l10n.splitOwesYou;
      }
      if (s.isMe) return l10n.splitYouOwe(_paidBy!);
      if (s.person == _paidBy) return l10n.splitPaidTheBill;
      return l10n.splitSettlesWith(_paidBy!);
    }

    String? summary;
    if (shares != null) {
      final mine = shares.where((s) => s.isMe).firstOrNull?.amount ?? 0;
      summary = _paidBy == null
          ? l10n.splitSummaryIPaid(money(_total), money(_total - mine))
          : l10n.splitSummaryTheyPaid(_paidBy!, money(mine));
    }

    final parts = <String?>[if (_includeMe) null, ..._people];
    final editable = _mode != SplitMode.equal;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.splitTitle)),
      body: CappedBody(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(
            SunriseSpace.screenX,
            8,
            SunriseSpace.screenX,
            40,
          ),
          children: [
            SunriseTextField(
              key: const Key('split_title'),
              controller: _title,
              label: l10n.splitWhatFor,
              textCapitalization: TextCapitalization.sentences,
              maxLength: 200,
            ),
            const SizedBox(height: 4),
            SettingsGroup(
              children: [
                SettingsRow(
                  key: const Key('split_total'),
                  icon: Symbols.payments_rounded,
                  title: l10n.splitTotal,
                  value: _total == 0 ? l10n.cardNotSet : money(_total),
                  onTap: () async {
                    final v = await askAmount(
                      context,
                      initial: _total,
                      currency: currency,
                    );
                    if (v != null) setState(() => _total = v);
                  },
                ),
                SettingsRow(
                  key: const Key('split_account'),
                  icon: Symbols.account_balance_wallet_rounded,
                  title: l10n.aiActionAccount,
                  value: wallet?.name ?? l10n.cardNotSet,
                  onTap: () async {
                    final id = await pickTradeAccount(
                      context,
                      ref,
                      selected: _walletId,
                    );
                    if (id != null) setState(() => _walletId = id);
                  },
                ),
                SettingsRow(
                  key: const Key('split_category'),
                  icon: Symbols.category_rounded,
                  title: l10n.addCategory,
                  value: category?.name ?? l10n.cardNotSet,
                  onTap: _pickCategory,
                ),
                SettingsRow(
                  key: const Key('split_date'),
                  icon: Symbols.event_rounded,
                  title: l10n.aiActionDate,
                  value: f.day(_date),
                  onTap: _pickDate,
                ),
              ],
            ),
            const SizedBox(height: SunriseSpace.section),
            SettingsGroup(
              label: l10n.splitPeople,
              children: [
                SettingsRow.toggle(
                  key: const Key('split_include_me'),
                  icon: Symbols.person_rounded,
                  title: l10n.splitIncludeMe,
                  subtitle: l10n.splitIncludeMeSub,
                  value: _includeMe,
                  // Someone else paying for the user only is their share;
                  // without one there is nothing to record.
                  onChanged: _paidBy != null
                      ? null
                      : (v) => setState(() => _includeMe = v),
                ),
                for (final p in _people)
                  SettingsRow(
                    icon: Symbols.group_rounded,
                    title: p,
                    trailing: SettingsTrailing.none,
                    trailingWidget: IconButton(
                      tooltip: l10n.splitRemove,
                      icon: Icon(Symbols.close_rounded, color: c.subtle),
                      onPressed: () => _removePerson(p),
                    ),
                  ),
                SettingsRow(
                  key: const Key('split_add_person'),
                  icon: Symbols.person_add_rounded,
                  iconColor: c.accent,
                  title: l10n.splitAddPerson,
                  onTap: _addPerson,
                ),
              ],
            ),
            if (_people.isNotEmpty) ...[
              const SizedBox(height: SunriseSpace.section),
              SettingsGroup(
                children: [
                  SettingsRow(
                    key: const Key('split_paid_by'),
                    icon: Symbols.receipt_long_rounded,
                    title: l10n.splitPaidBy,
                    value: _paidBy ?? l10n.splitYou,
                    onTap: _pickPayer,
                  ),
                ],
              ),
              const SizedBox(height: SunriseSpace.section),
              SectionLabel(l10n.splitHow),
              SunriseSegmented<SplitMode>(
                options: [
                  SegmentOption(SplitMode.equal, l10n.splitEqual),
                  SegmentOption(SplitMode.exact, l10n.splitExact),
                  SegmentOption(SplitMode.percent, l10n.splitPercent),
                ],
                value: _mode,
                onChanged: (m) => setState(() => _mode = m),
              ),
              const SizedBox(height: SunriseSpace.section),
              SettingsGroup(
                label: l10n.splitShares,
                children: [
                  for (final (i, p) in parts.indexed)
                    () {
                      final s = shares?[i];
                      final pct = _percents[p];
                      final amount = s == null
                          ? (_mode == SplitMode.exact ? _amounts[p] : null)
                          : s.amount;
                      final shown = amount == null ? '—' : money(amount);
                      return SettingsRow(
                        key: Key('split_share_${p ?? 'me'}'),
                        icon: p == null
                            ? Symbols.person_rounded
                            : Symbols.group_rounded,
                        title: p ?? l10n.splitYou,
                        subtitle: s == null ? null : shareNote(s),
                        value: _mode == SplitMode.percent && pct != null
                            ? '${_trim(pct)}% · $shown'
                            : shown,
                        trailing: editable
                            ? SettingsTrailing.chevron
                            : SettingsTrailing.none,
                        onTap: editable ? () => _editShare(p, currency) : null,
                      );
                    }(),
                ],
              ),
              if (problem != null) ...[
                const SizedBox(height: 10),
                Text(
                  problem,
                  key: const Key('split_problem'),
                  style: SunriseType.caption.copyWith(color: c.negative),
                ),
              ],
              if (summary != null) ...[
                const SizedBox(height: 10),
                Text(
                  summary,
                  key: const Key('split_summary'),
                  style: SunriseType.body.copyWith(color: c.muted),
                ),
              ],
            ],
            const SizedBox(height: 20),
            SunriseButton(
              key: const Key('split_save'),
              label: l10n.splitSave,
              onPressed: _saving || shares == null ? null : _save,
            ),
          ],
        ),
      ),
    );
  }

  static String _trim(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);
}

/// Type a new name, or tap someone already in Lend & borrow.
class _AddPersonSheet extends StatefulWidget {
  const _AddPersonSheet({required this.suggestions});

  final List<String> suggestions;

  @override
  State<_AddPersonSheet> createState() => _AddPersonSheetState();
}

class _AddPersonSheetState extends State<_AddPersonSheet> {
  final _name = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final typed = _name.text.trim().toLowerCase();
    final matches = widget.suggestions
        .where((s) => typed.isEmpty || s.toLowerCase().contains(typed))
        .take(8)
        .toList();
    return SunriseBottomSheet(
      title: l10n.splitAddPerson,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SunriseTextField(
              key: const Key('split_person_name'),
              controller: _name,
              label: l10n.splitPersonName,
              autofocus: true,
              maxLength: 100,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              onSubmitted: (v) => Navigator.pop(context, v),
            ),
            if (matches.isNotEmpty) ...[
              SectionLabel(l10n.splitKnownPeople),
              for (final m in matches)
                SheetAction(
                  icon: Symbols.person_rounded,
                  label: m,
                  onTap: () => Navigator.pop(context, m),
                ),
            ],
            const SizedBox(height: 12),
            SunriseButton(
              key: const Key('split_person_add'),
              label: l10n.actionAdd,
              onPressed: _name.text.trim().isEmpty
                  ? null
                  : () => Navigator.pop(context, _name.text),
            ),
          ],
        ),
      ),
    );
  }
}

/// One person's percentage of the bill.
class _PercentSheet extends StatefulWidget {
  const _PercentSheet({required this.name, this.initial});

  final String? name;
  final double? initial;

  @override
  State<_PercentSheet> createState() => _PercentSheetState();
}

class _PercentSheetState extends State<_PercentSheet> {
  late final TextEditingController _value;

  @override
  void initState() {
    super.initState();
    final v = widget.initial;
    _value = TextEditingController(
      text: v == null
          ? ''
          : (v == v.roundToDouble() ? v.toStringAsFixed(0) : '$v'),
    );
  }

  @override
  void dispose() {
    _value.dispose();
    super.dispose();
  }

  void _done() {
    final v = double.tryParse(_value.text.trim());
    if (v == null || v < 0 || v > 100) return;
    Navigator.pop(context, v);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return SunriseBottomSheet(
      title: widget.name ?? l10n.splitYou,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SunriseTextField(
              key: const Key('split_percent'),
              controller: _value,
              label: l10n.splitPercentLabel,
              autofocus: true,
              suffix: const Text('%'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              onSubmitted: (_) => _done(),
            ),
            const SizedBox(height: 12),
            SunriseButton(label: l10n.actionSave, onPressed: _done),
          ],
        ),
      ),
    );
  }
}

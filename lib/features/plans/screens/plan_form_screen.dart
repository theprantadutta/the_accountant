import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/data_reload.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/data/models/plan.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/investments/providers/investments_provider.dart';
import 'package:the_accountant/features/plans/domain/plan_terms.dart';
import 'package:the_accountant/features/plans/providers/plans_provider.dart';
import 'package:the_accountant/features/plans/services/plan_service.dart';
import 'package:the_accountant/features/plans/widgets/plan_labels.dart';
import 'package:the_accountant/features/transactions/widgets/calculator_bottom_sheet.dart';
import 'package:the_accountant/features/transactions/widgets/category_picker_sheet.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// How often an insurance premium falls due, as a frequency and interval.
const _premiumCycles = [
  (PlanFrequency.monthly, 1),
  (PlanFrequency.monthly, 3),
  (PlanFrequency.monthly, 6),
  (PlanFrequency.yearly, 1),
];

/// Start an EMI, loan, DPS, FDR, insurance policy or bond.
///
/// The figures that follow from others are worked out as they are typed: an
/// installment from the price, rate and term; a maturity from the deposit and
/// rate. Each can be overwritten with the bank's own figure, and then stays as
/// typed.
class PlanFormScreen extends ConsumerStatefulWidget {
  const PlanFormScreen({super.key, required this.kind, this.investmentId});

  final PlanKind kind;

  /// For a SIP started from an investment: the one it buys.
  final String? investmentId;

  @override
  ConsumerState<PlanFormScreen> createState() => _PlanFormScreenState();
}

class _PlanFormScreenState extends ConsumerState<PlanFormScreen> {
  final _name = TextEditingController();
  final _count = TextEditingController();
  final _rate = TextEditingController();
  final _tax = TextEditingController();
  final _provider = TextEditingController();
  final _reference = TextEditingController();

  String? _walletId;
  String? _categoryId;
  String? _categoryName;
  late DateTime _start;
  PlanFrequency _frequency = PlanFrequency.monthly;
  int _interval = 1;
  PlanPayout _payout = PlanPayout.atMaturity;
  int _principal = 0;
  int _installment = 0;
  bool _installmentTyped = false;
  int? _maturity;
  bool _maturityTyped = false;
  bool _autoCollect = true;
  int _remind = 3;
  bool _loanReceived = true;
  bool _saving = false;
  String? _investmentId;
  String? _investmentName;

  PlanKind get _kind => widget.kind;
  bool get _hasRate => _kind != PlanKind.insurance && _kind != PlanKind.sip;
  bool get _isSip => _kind == PlanKind.sip;
  bool get _hasTax => _kind.holdsMoney;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 10);
    // Installments usually start a period after the purchase or the loan; a
    // DPS, deposit, bond or policy starts the day it is opened.
    _start = _kind == PlanKind.emi || _kind == PlanKind.loan
        ? PlanDates.shift(today, PlanFrequency.monthly, 1)
        : today;
    _count.text = switch (_kind) {
      PlanKind.dps => '60',
      PlanKind.bond => '5',
      PlanKind.insurance => '20',
      _ => '12',
    };
    if (_kind == PlanKind.bond) {
      // Savings certificates run for years, pay every three months, and are
      // taxed at source.
      _frequency = PlanFrequency.yearly;
      _payout = PlanPayout.quarterly;
      _tax.text = '10';
    }
    if (_kind == PlanKind.insurance) _frequency = PlanFrequency.yearly;
    _investmentId = widget.investmentId;
    if (_investmentId != null) {
      ref.read(investmentServiceProvider).find(_investmentId!).then((i) {
        if (mounted && i != null) {
          setState(() {
            _investmentName = i.name;
            _name.text = _name.text.isEmpty ? '${i.name} SIP' : _name.text;
          });
        }
      });
    }
    final wallets = ref.read(selectableWalletsProvider);
    // Savings come out of a bank account; a SIP from money already held,
    // never on a card.
    final preferred = wallets.where(
      (w) => _kind.holdsMoney
          ? w.walletType == WalletType.bankAccount
          : _isSip
          ? w.walletType != WalletType.creditCard
          : true,
    );
    _walletId =
        (preferred.isNotEmpty ? preferred.first : wallets.firstOrNull)?.id;
    _count.addListener(_recompute);
    _rate.addListener(_recompute);
    _tax.addListener(_recompute);
  }

  @override
  void dispose() {
    for (final c in [_name, _count, _rate, _tax, _provider, _reference]) {
      c.dispose();
    }
    super.dispose();
  }

  int get _n => int.tryParse(_count.text.trim()) ?? 0;
  double? _percent(TextEditingController c) {
    final v = double.tryParse(c.text.trim());
    return v == null || v <= 0 ? null : v;
  }

  double? get _r => _percent(_rate);
  double? get _t => _percent(_tax);

  int get _fdrMonths => _n * (_frequency == PlanFrequency.yearly ? 12 : 1);

  void _recompute() {
    setState(() {
      if ((_kind == PlanKind.emi || _kind == PlanKind.loan) &&
          !_installmentTyped &&
          _principal > 0 &&
          _n > 0) {
        _installment = PlanMath.installmentFor(
          principal: _principal,
          annualRate: _r,
          count: _n,
          frequency: _frequency,
        );
      }
      if (!_maturityTyped) {
        if (_kind == PlanKind.dps && _installment > 0 && _n > 0) {
          _maturity = PlanMath.dpsMaturity(
            installment: _installment,
            annualRate: _r,
            count: _n,
            frequency: _frequency,
          );
        }
        if (_kind.isFixedDeposit && _principal > 0 && _n > 0) {
          _maturity = PlanMath.fdrMaturity(
            principal: _principal,
            annualRate: _r,
            months: _fdrMonths,
          );
        }
      }
    });
  }

  String get _currency =>
      ref
          .read(walletProvider)
          .wallets
          .where((w) => w.id == _walletId)
          .firstOrNull
          ?.currency ??
      'USD';

  /// A closing sheet hands focus back to the field that had it, which put the
  /// keyboard over the form and sent the next keystrokes into the name.
  void _dropFocus() => FocusManager.instance.primaryFocus?.unfocus();

  Future<int?> _amount(int current) async {
    _dropFocus();
    final v = await showCalculatorBottomSheet(
      context: context,
      initialAmount: current / 100.0,
      isIncome: _kind.holdsMoney,
      currencySymbol: CurrencyInfo.getSymbol(_currency),
    );
    _dropFocus();
    return v == null ? null : (v * 100).round();
  }

  Future<void> _pickWallet() async {
    _dropFocus();
    final l10n = L10n.of(context);
    final wallets = ref.read(selectableWalletsProvider);
    final id = await showSunriseSheet<String>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: l10n.planAccount,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final w in wallets)
              SheetAction(
                icon: Symbols.account_balance_wallet_rounded,
                label: w.name,
                subtitle: w.currency,
                selected: w.id == _walletId,
                onTap: () => Navigator.pop(sheet, w.id),
              ),
          ],
        ),
      ),
    );
    _dropFocus();
    if (id != null) setState(() => _walletId = id);
  }

  Future<void> _pickInvestment() async {
    _dropFocus();
    final l10n = L10n.of(context);
    final holdings = await ref.read(investmentServiceProvider).all();
    if (!mounted) return;
    if (holdings.isEmpty) {
      showSunriseSnack(context, l10n.planSipNoFund, tone: SnackTone.error);
      return;
    }
    final picked = await showSunriseSheet<String>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: l10n.planSipFund,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final i in holdings)
              SheetAction(
                icon: Symbols.trending_up_rounded,
                label: i.name,
                subtitle: i.symbol,
                selected: i.id == _investmentId,
                onTap: () => Navigator.pop(sheet, i.id),
              ),
          ],
        ),
      ),
    );
    _dropFocus();
    if (picked == null) return;
    final i = holdings.firstWhere((x) => x.id == picked);
    setState(() {
      _investmentId = i.id;
      _investmentName = i.name;
    });
  }

  Future<void> _pickStart() async {
    _dropFocus();
    final picked = await showDatePicker(
      context: context,
      initialDate: _start,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 30),
    );
    _dropFocus();
    if (picked != null) {
      setState(
        () => _start = DateTime(picked.year, picked.month, picked.day, 10),
      );
    }
  }

  Future<void> _pickCategory() async {
    _dropFocus();
    final category = await showCategoryPickerSheet(
      context: context,
      ref: ref,
      selectedCategoryId: _categoryId,
    );
    _dropFocus();
    if (category != null) {
      setState(() {
        _categoryId = category.id;
        _categoryName = category.name;
      });
    }
  }

  Future<void> _save() async {
    final l10n = L10n.of(context);
    final walletId = _walletId;
    if (walletId == null) {
      showSunriseSnack(context, l10n.planNeedAccount, tone: SnackTone.error);
      return;
    }
    setState(() => _saving = true);
    final service = ref.read(planServiceProvider);
    try {
      final id = await service.create(
        PlanDraft(
          kind: _kind,
          name: _name.text.trim().isEmpty
              ? _kind.label(l10n)
              : _name.text.trim(),
          walletId: walletId,
          startDate: _start,
          principal: _principal,
          installmentAmount: _installment,
          installmentCount: _n,
          frequency: _frequency,
          interval: _interval,
          interestRate: _hasRate ? _r : null,
          maturityAmount: _kind.holdsMoney || _kind == PlanKind.insurance
              ? _maturity
              : null,
          payout: _payout,
          autoCollect: _autoCollect,
          reminderDaysBefore: _remind,
          categoryId: _categoryId,
          loanReceived: _loanReceived,
          provider: _provider.text,
          reference: _reference.text,
          taxRate: _hasTax ? _t : null,
          investmentId: _isSip ? _investmentId : null,
        ),
      );
      // Whatever already fell due — an EMI started last month, a DPS opened
      // today — is recorded at once, not at the next launch.
      if (_autoCollect) await service.collectDue();
      reloadAllData(ref);
      ref.invalidate(plansProvider);
      if (!mounted) return;
      Navigator.of(context).pop(id);
      showSunriseSnack(context, l10n.planCreated, tone: SnackTone.success);
    } on ArgumentError catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        showSunriseSnack(context, '${e.message}', tone: SnackTone.error);
      }
    }
  }

  String _cycleLabel(L10n l10n, (PlanFrequency, int) cycle) => switch (cycle) {
    (PlanFrequency.monthly, 1) => l10n.planMonthly,
    (PlanFrequency.monthly, 3) => l10n.planQuarterly,
    (PlanFrequency.monthly, 6) => l10n.planHalfYearly,
    _ => l10n.planYearly,
  };

  String? _summary(L10n l10n, String Function(int) money, PlanFormat f) {
    final end = _kind.isFixedDeposit
        ? PlanDates.shift(_start, PlanFrequency.monthly, _fdrMonths)
        : PlanDates.shift(_start, _frequency, _n * _interval);
    switch (_kind) {
      case PlanKind.emi:
      case PlanKind.loan:
        if (_installment <= 0 || _n <= 0) return null;
        return _principal > 0 && _installment * _n > _principal
            ? l10n.planSummaryInstallments(
                _n,
                money(_installment),
                money(_installment * _n),
                money(_installment * _n - _principal),
              )
            : l10n.planSummaryNoInterest(
                _n,
                money(_installment),
                money(_installment * _n),
              );
      case PlanKind.sip:
        if (_installment <= 0 || _n <= 0) return null;
        return l10n.planSummarySip(
          _n,
          money(_installment),
          money(_installment * _n),
          _investmentName ?? '…',
        );
      case PlanKind.insurance:
        if (_installment <= 0 || _n <= 0) return null;
        return (_maturity ?? 0) > 0
            ? l10n.planSummaryInsurancePayout(
                _n,
                money(_installment),
                money(_installment * _n),
                money(_maturity!),
                f.day(end),
              )
            : l10n.planSummaryInsurance(
                _n,
                money(_installment),
                money(_installment * _n),
              );
      case PlanKind.dps:
        if (_installment <= 0 || _n <= 0) return null;
        final deposited = _installment * _n;
        final back =
            deposited +
            PlanMath.afterTax(
              ((_maturity ?? deposited) - deposited).clamp(0, 1 << 62),
              _t,
            );
        return l10n.planSummaryDps(money(deposited), money(back), f.day(end));
      case PlanKind.fdr:
      case PlanKind.bond:
        if (_principal <= 0 || _n <= 0) return null;
        if (_payout == PlanPayout.atMaturity) {
          final back =
              _principal +
              PlanMath.afterTax(
                ((_maturity ?? _principal) - _principal).clamp(0, 1 << 62),
                _t,
              );
          return l10n.planSummaryFdr(
            money(_principal),
            money(back),
            f.day(end),
          );
        }
        final profit = PlanMath.afterTax(
          (_principal *
                  (_r ?? 0) /
                  100 /
                  (_payout == PlanPayout.quarterly ? 4 : 12))
              .round(),
          _t,
        );
        return _payout == PlanPayout.quarterly
            ? l10n.planSummaryQuarterly(
                money(profit),
                money(_principal),
                f.day(end),
              )
            : l10n.planSummaryFdrMonthly(
                money(profit),
                money(_principal),
                f.day(end),
              );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final f = PlanFormat(ref, context);
    String money(int v) => f.money(v, _currency);
    final wallet = ref
        .watch(walletProvider)
        .wallets
        .where((w) => w.id == _walletId)
        .firstOrNull;
    final digits = [FilteringTextInputFormatter.digitsOnly];
    final decimal = [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))];
    final summary = _summary(l10n, money, f);
    final isInsurance = _kind == PlanKind.insurance;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.planNewKind(_kind.label(l10n)))),
      body: CappedBody(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            SunriseSpace.screenX,
            8,
            SunriseSpace.screenX,
            40,
          ),
          children: [
            Text(
              _kind.describe(l10n),
              style: SunriseType.body.copyWith(color: c.muted, fontSize: 14),
            ),
            const SizedBox(height: 14),
            SunriseTextField(
              key: const Key('plan_name'),
              controller: _name,
              label: l10n.planName,
              hint: switch (_kind) {
                PlanKind.emi => l10n.planNameHintEmi,
                PlanKind.loan => l10n.planNameHintLoan,
                PlanKind.dps => l10n.planNameHintDps,
                PlanKind.fdr => l10n.planNameHintFdr,
                PlanKind.insurance => l10n.planNameHintInsurance,
                PlanKind.bond => l10n.planNameHintBond,
                PlanKind.sip => l10n.planNameHintSip,
              },
              textCapitalization: TextCapitalization.sentences,
            ),
            if (_kind != PlanKind.emi && !_isSip) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SunriseTextField(
                      key: const Key('plan_provider'),
                      controller: _provider,
                      label: l10n.planProvider,
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SunriseTextField(
                      key: const Key('plan_reference'),
                      controller: _reference,
                      label: l10n.planReference,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 14),
            SettingsGroup(
              children: [
                SettingsRow(
                  key: const Key('plan_account'),
                  icon: Symbols.account_balance_wallet_rounded,
                  title: switch (_kind) {
                    PlanKind.loan => l10n.planAccountLoan,
                    PlanKind.emi ||
                    PlanKind.insurance ||
                    PlanKind.sip => l10n.planAccountEmi,
                    _ => l10n.planAccountSaving,
                  },
                  value: wallet?.name ?? l10n.cardNotSet,
                  onTap: _pickWallet,
                ),
                if (_isSip)
                  SettingsRow(
                    key: const Key('plan_investment'),
                    icon: Symbols.trending_up_rounded,
                    title: l10n.planSipFund,
                    value: _investmentName ?? l10n.cardNotSet,
                    onTap: _pickInvestment,
                  ),
                if (_kind != PlanKind.dps && !_isSip)
                  SettingsRow(
                    key: const Key('plan_principal'),
                    icon: isInsurance
                        ? Symbols.shield_rounded
                        : Symbols.payments_rounded,
                    title: switch (_kind) {
                      PlanKind.emi => l10n.planPrice,
                      PlanKind.loan => l10n.planBorrowed,
                      PlanKind.insurance => l10n.planSumAssured,
                      _ => l10n.planDeposited,
                    },
                    value: _principal == 0
                        ? l10n.cardNotSet
                        : money(_principal),
                    onTap: () async {
                      final v = await _amount(_principal);
                      if (v != null) {
                        _principal = v;
                        _recompute();
                      }
                    },
                  ),
                if (!_kind.isFixedDeposit)
                  SettingsRow(
                    key: const Key('plan_installment'),
                    icon: Symbols.event_repeat_rounded,
                    title: switch (_kind) {
                      PlanKind.dps => l10n.planDeposit,
                      PlanKind.insurance => l10n.planPremium,
                      PlanKind.sip => l10n.planSipAmount,
                      _ => l10n.planInstallment,
                    },
                    subtitle:
                        (_kind == PlanKind.emi || _kind == PlanKind.loan) &&
                            !_installmentTyped
                        ? l10n.planWorkedOut
                        : null,
                    value: _installment == 0
                        ? l10n.cardNotSet
                        : money(_installment),
                    onTap: () async {
                      final v = await _amount(_installment);
                      if (v != null) {
                        _installment = v;
                        _installmentTyped = true;
                        _recompute();
                      }
                    },
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: SunriseTextField(
                    key: const Key('plan_count'),
                    controller: _count,
                    label: _kind.isFixedDeposit
                        ? l10n.planTerm
                        : isInsurance
                        ? l10n.planPremiums
                        : l10n.planHowMany,
                    keyboardType: TextInputType.number,
                    inputFormatters: digits,
                  ),
                ),
                if (_hasRate) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: SunriseTextField(
                      key: const Key('plan_rate'),
                      controller: _rate,
                      label: l10n.planRateLabel,
                      hint: _kind == PlanKind.emi
                          ? l10n.planRateOptional
                          : null,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: decimal,
                    ),
                  ),
                ],
                if (_hasTax) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: SunriseTextField(
                      key: const Key('plan_tax'),
                      controller: _tax,
                      label: l10n.planTaxLabel,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: decimal,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            if (isInsurance)
              SunriseSegmented<(PlanFrequency, int)>(
                options: [
                  for (final cycle in _premiumCycles)
                    SegmentOption(cycle, _cycleLabel(l10n, cycle)),
                ],
                value: (_frequency, _interval),
                onChanged: (v) {
                  _frequency = v.$1;
                  _interval = v.$2;
                  _recompute();
                },
              )
            else
              SunriseSegmented<PlanFrequency>(
                options: [
                  if (!_kind.isFixedDeposit)
                    SegmentOption(PlanFrequency.weekly, l10n.planWeekly),
                  SegmentOption(
                    PlanFrequency.monthly,
                    _kind.isFixedDeposit ? l10n.planMonths : l10n.planMonthly,
                  ),
                  SegmentOption(
                    PlanFrequency.yearly,
                    _kind.isFixedDeposit ? l10n.planYears : l10n.planYearly,
                  ),
                ],
                value: _frequency,
                onChanged: (v) {
                  _frequency = v;
                  _recompute();
                },
              ),
            if (_kind.isFixedDeposit) ...[
              const SizedBox(height: 12),
              SunriseSegmented<PlanPayout>(
                key: const Key('plan_payout'),
                options: [
                  SegmentOption(PlanPayout.monthly, l10n.planPayoutMonthly),
                  SegmentOption(PlanPayout.quarterly, l10n.planPayoutQuarterly),
                  SegmentOption(
                    PlanPayout.atMaturity,
                    l10n.planPayoutAtMaturity,
                  ),
                ],
                value: _payout,
                onChanged: (v) {
                  _payout = v;
                  _recompute();
                },
              ),
            ],
            const SizedBox(height: 14),
            SettingsGroup(
              children: [
                SettingsRow(
                  key: const Key('plan_start'),
                  icon: Symbols.event_rounded,
                  title: _kind.isFixedDeposit
                      ? l10n.planOpenedOn
                      : isInsurance
                      ? l10n.planFirstPremium
                      : l10n.planFirstDue,
                  value: f.day(_start),
                  onTap: _pickStart,
                ),
                if (isInsurance ||
                    _kind == PlanKind.dps ||
                    (_kind.isFixedDeposit && _payout == PlanPayout.atMaturity))
                  SettingsRow(
                    key: const Key('plan_maturity'),
                    icon: Symbols.trending_up_rounded,
                    title: isInsurance
                        ? l10n.planInsurancePayout
                        : l10n.planMaturity,
                    subtitle: isInsurance || _maturityTyped
                        ? null
                        : l10n.planEstimated,
                    value: _maturity == null || _maturity == 0
                        ? (isInsurance ? l10n.planNone : l10n.cardNotSet)
                        : money(_maturity!),
                    onTap: () async {
                      final v = await _amount(_maturity ?? 0);
                      if (v != null) {
                        setState(() {
                          _maturity = v;
                          _maturityTyped = true;
                        });
                      }
                    },
                  ),
                if (_kind == PlanKind.emi ||
                    _kind == PlanKind.loan ||
                    isInsurance)
                  SettingsRow(
                    icon: Symbols.category_rounded,
                    title: l10n.planCategory,
                    value:
                        _categoryName ??
                        (isInsurance
                            ? l10n.planCategoryInsurance
                            : l10n.planCategoryDefault),
                    onTap: _pickCategory,
                  ),
                if (_kind == PlanKind.loan)
                  SettingsRow(
                    icon: Symbols.input_rounded,
                    title: l10n.planLoanReceived,
                    subtitle: l10n.planLoanReceivedHint,
                    trailing: SettingsTrailing.none,
                    trailingWidget: SunriseToggle(
                      value: _loanReceived,
                      onChanged: (v) => setState(() => _loanReceived = v),
                    ),
                  ),
                SettingsRow(
                  icon: Symbols.bolt_rounded,
                  title: l10n.planAutoCollect,
                  subtitle: l10n.planAutoCollectHint,
                  trailing: SettingsTrailing.none,
                  trailingWidget: SunriseToggle(
                    value: _autoCollect,
                    onChanged: (v) => setState(() => _autoCollect = v),
                  ),
                ),
                SettingsRow(
                  icon: Symbols.notifications_active_rounded,
                  title: l10n.cardRemindTitle,
                  value: _remind == 0
                      ? l10n.cardRemindOff
                      : l10n.cardRemindDaysBefore(_remind),
                  onTap: () => setState(() {
                    const choices = [0, 1, 3, 5, 7];
                    _remind =
                        choices[(choices.indexOf(_remind) + 1) %
                            choices.length];
                  }),
                ),
              ],
            ),
            if (summary != null) ...[
              const SizedBox(height: 14),
              SunriseCard(
                key: const Key('plan_summary'),
                padding: const EdgeInsets.all(14),
                child: Text(
                  summary,
                  style: SunriseType.body.copyWith(color: c.ink, fontSize: 14),
                ),
              ),
            ],
            const SizedBox(height: 18),
            SunriseButton(
              key: const Key('plan_save'),
              label: l10n.planStart,
              onPressed: _saving ? null : _save,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/data_reload.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/data/models/plan.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/plans/domain/plan_terms.dart';
import 'package:the_accountant/features/plans/providers/plans_provider.dart';
import 'package:the_accountant/features/plans/services/plan_service.dart';
import 'package:the_accountant/features/plans/widgets/plan_labels.dart';
import 'package:the_accountant/features/transactions/widgets/calculator_bottom_sheet.dart';
import 'package:the_accountant/features/transactions/widgets/category_picker_sheet.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Start an EMI, loan, DPS or FDR.
///
/// The figures that follow from others are worked out as they are typed: an
/// installment from the price, rate and term; a maturity from the deposit and
/// rate. Each can be overwritten with the bank's own figure, and then stays as
/// typed.
class PlanFormScreen extends ConsumerStatefulWidget {
  const PlanFormScreen({super.key, required this.kind});

  final PlanKind kind;

  @override
  ConsumerState<PlanFormScreen> createState() => _PlanFormScreenState();
}

class _PlanFormScreenState extends ConsumerState<PlanFormScreen> {
  final _name = TextEditingController();
  final _count = TextEditingController();
  final _rate = TextEditingController();

  String? _walletId;
  String? _categoryId;
  String? _categoryName;
  late DateTime _start;
  PlanFrequency _frequency = PlanFrequency.monthly;
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

  PlanKind get _kind => widget.kind;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 10);
    // Installments usually start a period after the purchase or the loan; a
    // DPS and an FDR start the day they are opened.
    _start = _kind == PlanKind.emi || _kind == PlanKind.loan
        ? PlanDates.shift(today, PlanFrequency.monthly, 1)
        : today;
    _count.text = switch (_kind) {
      PlanKind.dps => '60',
      PlanKind.fdr => '12',
      _ => '12',
    };
    final wallets = ref.read(selectableWalletsProvider);
    final preferred = wallets.where(
      (w) => _kind.isSaving ? w.walletType == WalletType.bankAccount : true,
    );
    _walletId =
        (preferred.isNotEmpty ? preferred.first : wallets.firstOrNull)?.id;
    _count.addListener(_recompute);
    _rate.addListener(_recompute);
  }

  @override
  void dispose() {
    _name.dispose();
    _count.dispose();
    _rate.dispose();
    super.dispose();
  }

  int get _n => int.tryParse(_count.text.trim()) ?? 0;
  double? get _r {
    final v = double.tryParse(_rate.text.trim());
    return v == null || v <= 0 ? null : v;
  }

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
        if (_kind == PlanKind.fdr && _principal > 0 && _n > 0) {
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

  Future<int?> _amount(int current) async {
    final v = await showCalculatorBottomSheet(
      context: context,
      initialAmount: current / 100.0,
      isIncome: _kind.isSaving,
      currencySymbol: CurrencyInfo.getSymbol(_currency),
    );
    return v == null ? null : (v * 100).round();
  }

  Future<void> _pickWallet() async {
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
    if (id != null) setState(() => _walletId = id);
  }

  Future<void> _pickStart() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final picked = await showDatePicker(
      context: context,
      initialDate: _start,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 30),
    );
    if (picked != null) {
      setState(
        () => _start = DateTime(picked.year, picked.month, picked.day, 10),
      );
    }
  }

  Future<void> _pickCategory() async {
    final category = await showCategoryPickerSheet(
      context: context,
      ref: ref,
      selectedCategoryId: _categoryId,
    );
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
          interestRate: _r,
          maturityAmount: _kind.isSaving ? _maturity : null,
          payout: _payout,
          autoCollect: _autoCollect,
          reminderDaysBefore: _remind,
          categoryId: _categoryId,
          loanReceived: _loanReceived,
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

    final summary = switch (_kind) {
      PlanKind.emi || PlanKind.loan when _installment > 0 && _n > 0 =>
        l10n.planSummaryInstallments(
          _n,
          money(_installment),
          money(_installment * _n),
          _principal > 0 && _installment * _n > _principal
              ? money(_installment * _n - _principal)
              : money(0),
        ),
      PlanKind.dps when _installment > 0 && _n > 0 => l10n.planSummaryDps(
        money(_installment * _n),
        money(_maturity ?? _installment * _n),
        f.day(PlanDates.shift(_start, _frequency, _n)),
      ),
      PlanKind.fdr when _principal > 0 && _n > 0 =>
        _payout == PlanPayout.monthly
            ? l10n.planSummaryFdrMonthly(
                money(
                  PlanMath.fdrMonthlyProfit(
                    principal: _principal,
                    annualRate: _r,
                  ),
                ),
                money(_principal),
                f.day(
                  PlanDates.shift(_start, PlanFrequency.monthly, _fdrMonths),
                ),
              )
            : l10n.planSummaryFdr(
                money(_principal),
                money(_maturity ?? _principal),
                f.day(
                  PlanDates.shift(_start, PlanFrequency.monthly, _fdrMonths),
                ),
              ),
      _ => null,
    };

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
              },
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 14),
            SettingsGroup(
              children: [
                SettingsRow(
                  key: const Key('plan_account'),
                  icon: Symbols.account_balance_wallet_rounded,
                  title: switch (_kind) {
                    PlanKind.loan => l10n.planAccountLoan,
                    PlanKind.emi => l10n.planAccountEmi,
                    _ => l10n.planAccountSaving,
                  },
                  value: wallet?.name ?? l10n.cardNotSet,
                  onTap: _pickWallet,
                ),
                if (_kind == PlanKind.emi ||
                    _kind == PlanKind.loan ||
                    _kind == PlanKind.fdr)
                  SettingsRow(
                    key: const Key('plan_principal'),
                    icon: Symbols.payments_rounded,
                    title: switch (_kind) {
                      PlanKind.emi => l10n.planPrice,
                      PlanKind.loan => l10n.planBorrowed,
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
                if (_kind != PlanKind.fdr)
                  SettingsRow(
                    key: const Key('plan_installment'),
                    icon: Symbols.event_repeat_rounded,
                    title: _kind == PlanKind.dps
                        ? l10n.planDeposit
                        : l10n.planInstallment,
                    subtitle: _kind == PlanKind.dps || _installmentTyped
                        ? null
                        : l10n.planWorkedOut,
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
                    label: _kind == PlanKind.fdr
                        ? l10n.planTerm
                        : l10n.planHowMany,
                    keyboardType: TextInputType.number,
                    inputFormatters: digits,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SunriseTextField(
                    key: const Key('plan_rate'),
                    controller: _rate,
                    label: l10n.planRateLabel,
                    hint: _kind == PlanKind.emi ? l10n.planRateOptional : null,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: decimal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SunriseSegmented<PlanFrequency>(
              options: [
                if (_kind != PlanKind.fdr)
                  SegmentOption(PlanFrequency.weekly, l10n.planWeekly),
                SegmentOption(
                  PlanFrequency.monthly,
                  _kind == PlanKind.fdr ? l10n.planMonths : l10n.planMonthly,
                ),
                SegmentOption(
                  PlanFrequency.yearly,
                  _kind == PlanKind.fdr ? l10n.planYears : l10n.planYearly,
                ),
              ],
              value: _frequency,
              onChanged: (v) {
                _frequency = v;
                _recompute();
              },
            ),
            const SizedBox(height: 14),
            SettingsGroup(
              children: [
                SettingsRow(
                  key: const Key('plan_start'),
                  icon: Symbols.event_rounded,
                  title: _kind == PlanKind.fdr
                      ? l10n.planOpenedOn
                      : l10n.planFirstDue,
                  value: f.day(_start),
                  onTap: _pickStart,
                ),
                if (_kind == PlanKind.fdr)
                  SettingsRow(
                    icon: Symbols.percent_rounded,
                    title: l10n.planPayout,
                    value: _payout == PlanPayout.monthly
                        ? l10n.planPayoutMonthly
                        : l10n.planPayoutAtMaturity,
                    onTap: () {
                      _payout = _payout == PlanPayout.monthly
                          ? PlanPayout.atMaturity
                          : PlanPayout.monthly;
                      _recompute();
                    },
                  ),
                if (_kind.isSaving &&
                    !(_kind == PlanKind.fdr && _payout == PlanPayout.monthly))
                  SettingsRow(
                    key: const Key('plan_maturity'),
                    icon: Symbols.trending_up_rounded,
                    title: l10n.planMaturity,
                    subtitle: _maturityTyped ? null : l10n.planEstimated,
                    value: _maturity == null
                        ? l10n.cardNotSet
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
                if (_kind == PlanKind.emi || _kind == PlanKind.loan)
                  SettingsRow(
                    icon: Symbols.category_rounded,
                    title: l10n.planCategory,
                    value: _categoryName ?? l10n.planCategoryDefault,
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
                  onTap: () => setState(
                    () => _remind = const [
                      0,
                      1,
                      3,
                      5,
                      7,
                    ][(const [0, 1, 3, 5, 7].indexOf(_remind) + 1) % 5],
                  ),
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

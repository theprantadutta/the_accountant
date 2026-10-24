import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/data_reload.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/investments/providers/investments_provider.dart';
import 'package:the_accountant/features/investments/services/investment_service.dart';
import 'package:the_accountant/features/investments/widgets/investment_labels.dart';
import 'package:the_accountant/features/plans/widgets/plan_labels.dart';
import 'package:the_accountant/features/transactions/widgets/calculator_bottom_sheet.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

enum TradeMode { buy, sell, dividend }

/// A closing sheet hands focus back to the field that had it, which put the
/// keyboard over the form; drop it around every sheet.
void _dropFocus() => FocusManager.instance.primaryFocus?.unfocus();

String formatMoney(WidgetRef ref, BuildContext context, int v, String c) =>
    PlanFormat(ref, context).money(v, c);

/// Ask for a sum on the calculator, in minor units.
Future<int?> askAmount(
  BuildContext context, {
  required int initial,
  required String currency,
  bool isIncome = false,
}) async {
  _dropFocus();
  final v = await showCalculatorBottomSheet(
    context: context,
    initialAmount: initial / 100.0,
    isIncome: isIncome,
    currencySymbol: CurrencyInfo.getSymbol(currency),
  );
  _dropFocus();
  return v == null ? null : (v * 100).round();
}

/// Choose the ordinary account money comes from or goes to.
Future<String?> pickTradeAccount(
  BuildContext context,
  WidgetRef ref, {
  String? selected,
  String? currency,
}) async {
  _dropFocus();
  final l10n = L10n.of(context);
  final wallets = ref
      .read(selectableWalletsProvider)
      .where((w) => currency == null || w.currency == currency)
      .toList();
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
              selected: w.id == selected,
              onTap: () => Navigator.pop(sheet, w.id),
            ),
        ],
      ),
    ),
  );
  _dropFocus();
  return id;
}

/// Buy more, sell, or record a dividend.
class InvestmentTradeScreen extends ConsumerStatefulWidget {
  const InvestmentTradeScreen({
    super.key,
    required this.holding,
    required this.mode,
  });

  final InvestmentHolding holding;
  final TradeMode mode;

  @override
  ConsumerState<InvestmentTradeScreen> createState() =>
      _InvestmentTradeScreenState();
}

class _InvestmentTradeScreenState extends ConsumerState<InvestmentTradeScreen> {
  final _units = TextEditingController();
  String? _walletId;
  int _amount = 0;
  int _fee = 0;
  bool _saving = false;

  InvestmentHolding get _h => widget.holding;
  String get _currency => _h.currency;

  @override
  void initState() {
    super.initState();
    // Same money as the holding, so nothing has to be converted; a bank
    // account or cash before a card, which is where trades settle.
    final same = ref
        .read(selectableWalletsProvider)
        .where((w) => w.currency == _currency)
        .toList();
    _walletId =
        (same.where((w) => w.walletType != WalletType.creditCard).firstOrNull ??
                same.firstOrNull)
            ?.id;
    _units.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _units.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = L10n.of(context);
    final walletId = _walletId;
    if (walletId == null) {
      showSunriseSnack(context, l10n.planNeedAccount, tone: SnackTone.error);
      return;
    }
    final units = double.tryParse(_units.text.trim());
    final service = ref.read(investmentServiceProvider);
    setState(() => _saving = true);
    try {
      switch (widget.mode) {
        case TradeMode.buy:
          await service.buy(
            _h.investment.id,
            fromWalletId: walletId,
            amount: _amount,
            units: units,
            fee: _fee,
          );
        case TradeMode.sell:
          await service.sell(
            _h.investment.id,
            toWalletId: walletId,
            amount: _amount,
            units: units ?? 0,
            fee: _fee,
          );
        case TradeMode.dividend:
          await service.dividend(
            _h.investment.id,
            toWalletId: walletId,
            amount: _amount,
          );
      }
      reloadAllData(ref);
      ref.invalidate(investmentsProvider);
      if (!mounted) return;
      Navigator.of(context).pop(true);
      showSunriseSnack(
        context,
        l10n.investmentRecorded,
        tone: SnackTone.success,
      );
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
    final wallet = ref
        .watch(walletProvider)
        .wallets
        .where((w) => w.id == _walletId)
        .firstOrNull;
    final units = double.tryParse(_units.text.trim());
    final perUnit = _amount > 0 && (units ?? 0) > 0
        ? (_amount / units!).round()
        : null;
    final selling = widget.mode == TradeMode.sell;
    final dividend = widget.mode == TradeMode.dividend;

    return Scaffold(
      appBar: AppBar(
        title: Text(switch (widget.mode) {
          TradeMode.buy => l10n.investmentBuyTitle(_h.investment.name),
          TradeMode.sell => l10n.investmentSellTitle(_h.investment.name),
          TradeMode.dividend => l10n.investmentDividendTitle(
            _h.investment.name,
          ),
        }),
      ),
      body: CappedBody(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            SunriseSpace.screenX,
            8,
            SunriseSpace.screenX,
            40,
          ),
          children: [
            if (selling)
              Text(
                l10n.investmentHeldNow(formatUnits(_h.units)),
                style: SunriseType.body.copyWith(color: c.muted, fontSize: 14),
              ),
            if (selling) const SizedBox(height: 12),
            SettingsGroup(
              children: [
                SettingsRow(
                  key: const Key('trade_account'),
                  icon: Symbols.account_balance_wallet_rounded,
                  title: widget.mode == TradeMode.buy
                      ? l10n.planAccountEmi
                      : l10n.investmentPaidInto,
                  value: wallet?.name ?? l10n.cardNotSet,
                  onTap: () async {
                    final id = await pickTradeAccount(
                      context,
                      ref,
                      selected: _walletId,
                      currency: _currency,
                    );
                    if (id != null) setState(() => _walletId = id);
                  },
                ),
                SettingsRow(
                  key: const Key('trade_amount'),
                  icon: Symbols.payments_rounded,
                  title: switch (widget.mode) {
                    TradeMode.buy => l10n.investmentPaid,
                    TradeMode.sell => l10n.investmentReceived,
                    TradeMode.dividend => l10n.investmentDividend,
                  },
                  value: _amount == 0
                      ? l10n.cardNotSet
                      : formatMoney(ref, context, _amount, _currency),
                  onTap: () async {
                    final v = await askAmount(
                      context,
                      initial: _amount,
                      currency: _currency,
                      isIncome: !widget.mode.isBuy,
                    );
                    if (v != null) setState(() => _amount = v);
                  },
                ),
                if (!dividend)
                  SettingsRow(
                    key: const Key('trade_fee'),
                    icon: Symbols.receipt_rounded,
                    title: l10n.investmentFee,
                    value: _fee == 0
                        ? l10n.planNone
                        : formatMoney(ref, context, _fee, _currency),
                    onTap: () async {
                      final v = await askAmount(
                        context,
                        initial: _fee,
                        currency: _currency,
                      );
                      if (v != null) setState(() => _fee = v);
                    },
                  ),
              ],
            ),
            if (!dividend) ...[
              const SizedBox(height: 12),
              SunriseTextField(
                key: const Key('trade_units'),
                controller: _units,
                label: selling
                    ? l10n.investmentUnitsSold
                    : l10n.investmentUnits,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
              ),
              if (perUnit != null) ...[
                const SizedBox(height: 10),
                Text(
                  l10n.investmentPerUnit(
                    formatMoney(ref, context, perUnit, _currency),
                  ),
                  style: SunriseType.caption.copyWith(color: c.muted),
                ),
              ],
            ],
            const SizedBox(height: 20),
            SunriseButton(
              key: const Key('trade_save'),
              label: switch (widget.mode) {
                TradeMode.buy => l10n.investmentBuy,
                TradeMode.sell => l10n.investmentSell,
                TradeMode.dividend => l10n.investmentRecordDividend,
              },
              onPressed: _saving ? null : _save,
            ),
          ],
        ),
      ),
    );
  }
}

extension on TradeMode {
  bool get isBuy => this == TradeMode.buy;
}

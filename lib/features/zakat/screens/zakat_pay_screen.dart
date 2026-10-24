import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/data_reload.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/investments/screens/investment_trade_screen.dart'
    show askAmount, pickTradeAccount;
import 'package:the_accountant/features/plans/widgets/plan_labels.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/zakat/providers/zakat_provider.dart';
import 'package:the_accountant/features/zakat/services/zakat_service.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Record zakat paid, as an expense under the Zakat category.
class ZakatPayScreen extends ConsumerStatefulWidget {
  const ZakatPayScreen({super.key, required this.report});

  final ZakatReport report;

  @override
  ConsumerState<ZakatPayScreen> createState() => _ZakatPayScreenState();
}

class _ZakatPayScreenState extends ConsumerState<ZakatPayScreen> {
  String? _walletId;
  late int _amount = widget.report.left;
  bool _saving = false;

  String get _currency => widget.report.currency;

  @override
  void initState() {
    super.initState();
    // In the user's own currency, so what is left needs no converting; cash
    // or a bank account before a card.
    final same = ref
        .read(selectableWalletsProvider)
        .where((w) => w.currency == _currency)
        .toList();
    _walletId =
        (same.where((w) => w.walletType != WalletType.creditCard).firstOrNull ??
                same.firstOrNull)
            ?.id;
  }

  Future<void> _save() async {
    final l10n = L10n.of(context);
    final walletId = _walletId;
    if (walletId == null) {
      showSunriseSnack(context, l10n.planNeedAccount, tone: SnackTone.error);
      return;
    }
    setState(() => _saving = true);
    try {
      await ref
          .read(zakatServiceProvider)
          .pay(walletId: walletId, amount: _amount, title: l10n.zakatTitle);
      reloadAllData(ref);
      ref.invalidate(zakatReportProvider);
      if (!mounted) return;
      Navigator.of(context).pop(true);
      showSunriseSnack(context, l10n.zakatPaidSnack, tone: SnackTone.success);
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
    final wallet = ref
        .watch(walletProvider)
        .wallets
        .where((w) => w.id == _walletId)
        .firstOrNull;
    final r = widget.report;
    final leftAfter = r.left > _amount ? r.left - _amount : 0;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.zakatPay)),
      body: CappedBody(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            SunriseSpace.screenX,
            8,
            SunriseSpace.screenX,
            40,
          ),
          children: [
            SettingsGroup(
              footer: l10n.zakatPayNote,
              children: [
                SettingsRow(
                  key: const Key('zakat_pay_account'),
                  icon: Symbols.account_balance_wallet_rounded,
                  title: l10n.planAccountEmi,
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
                  key: const Key('zakat_pay_amount'),
                  icon: Symbols.payments_rounded,
                  title: l10n.aiActionAmount,
                  value: _amount == 0
                      ? l10n.cardNotSet
                      : f.money(_amount, _currency),
                  onTap: () async {
                    final v = await askAmount(
                      context,
                      initial: _amount,
                      currency: _currency,
                    );
                    if (v != null) setState(() => _amount = v);
                  },
                ),
              ],
            ),
            if (r.due > 0) ...[
              const SizedBox(height: 12),
              Text(
                '${l10n.aiActionLeftAfter}: ${f.money(leftAfter, _currency)}',
                style: SunriseType.caption.copyWith(color: c.muted),
              ),
            ],
            const SizedBox(height: 20),
            SunriseButton(
              key: const Key('zakat_pay_save'),
              label: l10n.zakatPayRecord,
              onPressed: _saving || _amount <= 0 ? null : _save,
            ),
          ],
        ),
      ),
    );
  }
}

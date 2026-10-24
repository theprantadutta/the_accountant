import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/providers/data_reload.dart';
import 'package:the_accountant/features/investments/screens/investment_trade_screen.dart';
import 'package:the_accountant/features/networth/providers/net_worth_provider.dart';
import 'package:the_accountant/features/networth/services/asset_service.dart';
import 'package:the_accountant/features/networth/widgets/net_worth_labels.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Add land, a home, a car, gold or anything else owned, at what it is worth.
class AssetFormScreen extends ConsumerStatefulWidget {
  const AssetFormScreen({super.key});

  @override
  ConsumerState<AssetFormScreen> createState() => _AssetFormScreenState();
}

class _AssetFormScreenState extends ConsumerState<AssetFormScreen> {
  final _name = TextEditingController();
  AssetKind _kind = AssetKind.land;
  int _value = 0;

  /// Bought now, with money from one of the user's accounts, rather than
  /// something already owned.
  bool _bought = false;
  String? _walletId;
  int _paid = 0;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _walletId = ref.read(selectableWalletsProvider).firstOrNull?.id;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = L10n.of(context);
    final wallet = ref
        .read(walletProvider)
        .wallets
        .where((w) => w.id == _walletId)
        .firstOrNull;
    if (_bought && wallet == null) {
      showSunriseSnack(context, l10n.planNeedAccount, tone: SnackTone.error);
      return;
    }
    setState(() => _saving = true);
    try {
      await ref
          .read(assetServiceProvider)
          .create(
            name: _name.text,
            kind: _kind,
            // Bought: in the paying account's money, so nothing is converted.
            currency: _bought
                ? wallet!.currency
                : ref.read(defaultCurrencyProvider),
            useDecimals: _bought
                ? wallet!.useDecimals
                : ref.read(defaultDecimalProvider),
            value: _value,
            paidFromWalletId: _bought ? wallet!.id : null,
            paid: _bought && _paid > 0 ? _paid : null,
          );
      reloadAllData(ref);
      ref.invalidate(assetsProvider);
      if (!mounted) return;
      Navigator.of(context).pop(true);
      showSunriseSnack(context, l10n.assetAdded, tone: SnackTone.success);
    } on ArgumentError catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        showSunriseSnack(context, '${e.message}', tone: SnackTone.error);
      }
    }
  }

  Future<void> _pickKind() async {
    final l10n = L10n.of(context);
    final kind = await showSunriseSheet<AssetKind>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: l10n.assetKind,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final k in AssetKind.values)
              SheetAction(
                key: Key('asset_kind_${k.key}'),
                icon: k.icon,
                label: k.label(l10n),
                selected: k == _kind,
                onTap: () => Navigator.pop(sheet, k),
              ),
          ],
        ),
      ),
    );
    if (kind != null) setState(() => _kind = kind);
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
    final currency = _bought && wallet != null
        ? wallet.currency
        : ref.watch(defaultCurrencyProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.assetNew)),
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
              l10n.assetNewHint,
              style: SunriseType.body.copyWith(color: c.muted, fontSize: 14),
            ),
            const SizedBox(height: 14),
            SettingsGroup(
              children: [
                SettingsRow(
                  key: const Key('asset_kind'),
                  icon: _kind.icon,
                  iconColor: _kind.color,
                  title: l10n.assetKind,
                  value: _kind.label(l10n),
                  onTap: _pickKind,
                ),
              ],
            ),
            const SizedBox(height: 12),
            SunriseTextField(
              key: const Key('asset_name'),
              controller: _name,
              label: l10n.planName,
              hint: _kind.nameHint(l10n),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            SettingsGroup(
              children: [
                SettingsRow(
                  key: const Key('asset_value'),
                  icon: Symbols.sell_rounded,
                  title: l10n.assetWorthNow,
                  value: _value == 0
                      ? l10n.cardNotSet
                      : formatMoney(ref, context, _value, currency),
                  onTap: () async {
                    final v = await askAmount(
                      context,
                      initial: _value,
                      currency: currency,
                    );
                    if (v != null) setState(() => _value = v);
                  },
                ),
                SettingsRow.toggle(
                  key: const Key('asset_bought'),
                  icon: Symbols.shopping_bag_rounded,
                  title: l10n.assetBoughtNow,
                  subtitle: l10n.assetBoughtNowHint,
                  value: _bought,
                  onChanged: (v) => setState(() => _bought = v),
                ),
                if (_bought) ...[
                  SettingsRow(
                    key: const Key('asset_account'),
                    icon: Symbols.account_balance_wallet_rounded,
                    title: l10n.planAccountEmi,
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
                    key: const Key('asset_paid'),
                    icon: Symbols.payments_rounded,
                    title: l10n.investmentPaid,
                    value: formatMoney(
                      ref,
                      context,
                      _paid > 0 ? _paid : _value,
                      currency,
                    ),
                    onTap: () async {
                      final v = await askAmount(
                        context,
                        initial: _paid > 0 ? _paid : _value,
                        currency: currency,
                      );
                      if (v != null) setState(() => _paid = v);
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            SunriseButton(
              key: const Key('asset_save'),
              label: l10n.assetSave,
              onPressed: _saving ? null : _save,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/features/wallets/services/wallet_maintenance_service.dart';
import 'package:the_accountant/features/settings/widgets/confirmation_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/utils/color_utils.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart' as db;
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/transactions/screens/transaction_detail_screen.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';
import 'package:the_accountant/features/transactions/widgets/sunrise_transaction_row.dart';
import 'package:the_accountant/shared/widgets/icon_picker.dart';
import 'package:the_accountant/features/wallets/domain/credit_card_position.dart';

/// One account: what is in it, what has moved through it, and what to do next.
///
/// There was no such screen. Accounts could be created, reordered and edited
/// from a list, and nowhere could you ask the obvious question about one of
/// them — how much has gone in and out this month, and where did it go.
class WalletDetailScreen extends ConsumerStatefulWidget {
  final String walletId;

  const WalletDetailScreen({super.key, required this.walletId});

  @override
  ConsumerState<WalletDetailScreen> createState() => _WalletDetailScreenState();
}

class _WalletDetailScreenState extends ConsumerState<WalletDetailScreen> {
  List<db.Transaction>? _rows;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final all = await ref.read(databaseProvider).getAllTransactions();
    if (!mounted) return;
    final mine = all.where((t) => t.walletId == widget.walletId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    setState(() => _rows = mine);
  }

  @override
  Widget build(BuildContext context) {
    final wallet = ref
        .watch(walletProvider)
        .wallets
        .where((w) => w.id == widget.walletId)
        .firstOrNull;

    if (wallet == null) {
      return SunrisePushPage(
        title: L10n.of(context).entityAccount,
        body: Center(
          child: EmptyState(
            icon: Symbols.account_balance_wallet_rounded,
            title: L10n.of(context).walletGone,
          ),
        ),
      );
    }

    final c = context.sunrise;
    final rows = _rows;
    final numberFormat = ref.watch(numberFormatSettingProvider);

    String money(int cents) => cents.formatCurrency(
      wallet.currency,
      useDecimals: wallet.useDecimals,
      numberFormat: numberFormat,
    );

    // This month, so the figures answer "how is this account doing" rather than
    // "what has ever happened to it", which the balance already says.
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month);
    final thisMonth =
        rows?.where((t) => !t.date.isBefore(monthStart)).toList() ?? const [];

    var inCents = 0;
    var outCents = 0;
    for (final t in thisMonth) {
      if (!TransactionPolicy.affectsWalletBalance(t)) continue;
      if (t.isIncome) {
        inCents += t.amount;
      } else {
        outCents += t.amount;
      }
    }

    final tint = ColorUtils.hexToColor(wallet.color);
    final deep = Color.lerp(tint, Colors.black, .28)!;
    final onGlass = context.sunrise.onFill.withValues(alpha: .22);

    return SunrisePushPage(
      title: wallet.name,
      onRefresh: _load,
      actions: [
        SunriseIconButton(
          icon: Symbols.more_horiz_rounded,
          tooltip: MaterialLocalizations.of(context).showMenuTooltip,
          onTap: () => _showActions(wallet),
        ),
      ],
      children: [
        GradientCard(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [tint, deep],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconTile(
                    icon: WalletIcons.getIcon(wallet.iconName),
                    color: context.sunrise.onFill,
                    background: onGlass,
                    size: 48,
                  ),
                  const Spacer(),
                  SunrisePill(
                    label: wallet.currency,
                    color: context.sunrise.onFill,
                    background: onGlass,
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                L10n.of(context).entityAccount.toUpperCase(),
                style: SunriseType.overline.copyWith(
                  color: context.sunrise.onFill.withValues(alpha: .8),
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  wallet.balance < 0
                      ? '−${money(-wallet.balance)}'
                      : money(wallet.balance),
                  style: SunriseType.amountHero.copyWith(
                    color: context.sunrise.onFill,
                  ),
                ),
              ),
              if (wallet.isArchived || wallet.excludeFromTotal) ...[
                const SizedBox(height: 12),
                SunrisePill(
                  icon: wallet.isArchived
                      ? Symbols.archive_rounded
                      : Symbols.functions_rounded,
                  label: wallet.isArchived
                      ? 'Closed. Its history is kept, but it is not offered '
                            'or counted.'
                      : 'Left out of the total across accounts.',
                  color: context.sunrise.onFill,
                  background: onGlass,
                ),
              ],
              if (wallet.walletType == WalletType.creditCard &&
                  wallet.creditLimit != null) ...[
                const SizedBox(height: 16),
                _CreditSummary(
                  balanceCents: wallet.balance,
                  limitCents: wallet.creditLimit!,
                  money: money,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: SunriseStatCard(
                icon: Symbols.south_west_rounded,
                iconColor: c.positive,
                label: L10n.of(context).walletInThisMonth,
                value: money(inCents),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SunriseStatCard(
                icon: Symbols.north_east_rounded,
                iconColor: c.negative,
                label: L10n.of(context).walletOutThisMonth,
                value: money(outCents),
              ),
            ),
          ],
        ),
        const SizedBox(height: SunriseSpace.section),

        SectionTitle(L10n.of(context).walletRecentActivity),
        if (rows == null)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: SunriseLoader()),
          )
        else if (rows.isEmpty)
          EmptyState(
            compact: true,
            icon: Symbols.receipt_long_rounded,
            title: L10n.of(context).walletNothingRecordedAgainstThisAccount,
          )
        else
          ListCard(
            children: [
              for (final t in rows.take(20))
                SunriseTransactionRow(
                  transaction: t,
                  showDate: true,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            TransactionDetailScreen(transactionId: t.id),
                      ),
                    );
                    await _load();
                  },
                ),
            ],
          ),
      ],
    );
  }

  void _showActions(db.Wallet wallet) {
    void run(BuildContext sheet, String action) {
      Navigator.pop(sheet);
      _onAction(action, wallet);
    }

    showSunriseSheet<void>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SheetAction(
              icon: wallet.isArchived
                  ? Symbols.unarchive_rounded
                  : Symbols.archive_rounded,
              label: wallet.isArchived ? 'Reopen' : 'Close account',
              subtitle: wallet.isArchived
                  ? 'Offer it again and count it'
                  : 'Keep its history, stop counting it',
              onTap: () => run(sheet, 'archive'),
            ),
            SheetAction(
              icon: Symbols.rule_rounded,
              label: L10n.of(context).walletCorrectBalance,
              subtitle: L10n.of(context).walletCorrectBalanceSubtitle,
              onTap: () => run(sheet, 'correct'),
            ),
            SheetAction(
              icon: Symbols.merge_rounded,
              label: L10n.of(context).walletMergeInto,
              onTap: () => run(sheet, 'merge'),
            ),
            SheetAction(
              icon: Symbols.functions_rounded,
              label: wallet.excludeFromTotal
                  ? 'Include in the total'
                  : 'Leave out of the total',
              onTap: () => run(sheet, 'exclude'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onAction(String action, db.Wallet wallet) async {
    final notifier = ref.read(walletProvider.notifier);
    switch (action) {
      case 'archive':
        await notifier.setArchived(wallet.id, !wallet.isArchived);
      case 'exclude':
        await notifier.setExcludedFromTotal(
          wallet.id,
          !wallet.excludeFromTotal,
        );
      case 'correct':
        await _correctBalance(wallet);
      case 'merge':
        await _merge(wallet);
    }
  }

  /// Ask what the account really holds, and record the difference.
  Future<void> _correctBalance(db.Wallet wallet) async {
    final entered = await showDialog<int>(
      context: context,
      builder: (context) => _CorrectBalanceDialog(wallet: wallet),
    );
    if (entered == null || !mounted) return;

    final id = await WalletMaintenanceService(
      ref.read(databaseProvider),
    ).correctBalance(walletId: wallet.id, actualBalance: entered);

    await ref.read(walletProvider.notifier).loadWallets();
    await _load();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          id == null
              ? 'That is already the balance.'
              : 'Recorded the difference as a correction.',
        ),
      ),
    );
  }

  /// Fold this account into another, then close it.
  Future<void> _merge(db.Wallet wallet) async {
    final others = ref
        .read(walletProvider)
        .wallets
        .where((w) => w.id != wallet.id && !w.isArchived)
        .toList();

    if (others.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context).walletNoOtherAccount)),
      );
      return;
    }

    final targetId = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(L10n.of(context).walletMergeIntoTitle),
        children: [
          for (final w in others)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, w.id),
              child: Text('${w.name} (${w.currency})'),
            ),
        ],
      ),
    );
    if (targetId == null || !mounted) return;

    final target = others.firstWhere((w) => w.id == targetId);
    final confirmed = await showConfirmationDialog(
      context: context,
      title: L10n.of(context).walletMergeConfirmTitle(wallet.name, target.name),
      message: target.currency == wallet.currency
          ? 'Everything filed against ${wallet.name} moves across, and '
                '${wallet.name} is closed. Nothing is deleted.'
          : 'Amounts are converted from ${wallet.currency} to '
                '${target.currency} as they move. Nothing is deleted, and '
                '${wallet.name} is closed rather than removed.',
      confirmText: L10n.of(context).walletMergeAction,
    );
    if (confirmed != true || !mounted) return;

    try {
      final result = await WalletMaintenanceService(
        ref.read(databaseProvider),
      ).mergeInto(sourceId: wallet.id, destinationId: targetId);

      await ref.read(walletProvider.notifier).loadWallets();
      if (!mounted) return;
      // A transfer between the two accounts being merged has both ends in one
      // place afterwards, so it is removed. Said out loud, because otherwise
      // the rows just disappear and the merge looks like it lost them.
      final l10n = L10n.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.transfersRemoved == 0
                ? l10n.walletMerged(result.moved, target.name)
                : l10n.walletMergedWithTransfersRemoved(
                    result.moved,
                    target.name,
                    result.transfersRemoved,
                  ),
          ),
        ),
      );
      Navigator.pop(context);
    } on ArgumentError catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }
}

/// What is owed on a card and what is left to spend; see
/// [CreditCardPosition].
class _CreditSummary extends StatelessWidget {
  final int balanceCents;
  final int limitCents;
  final String Function(int) money;

  const _CreditSummary({
    required this.balanceCents,
    required this.limitCents,
    required this.money,
  });

  @override
  Widget build(BuildContext context) {
    final position = CreditCardPosition.of(
      balance: balanceCents,
      limit: limitCents,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: position.usage,
            minHeight: 6,
            backgroundColor: context.sunrise.onFill.withValues(alpha: .25),
            color: context.sunrise.onFill,
          ),
        ),
        AppSpacing.gapSm,
        Text(
          position.inCredit > 0
              ? '${money(position.inCredit)} in credit · '
                    '${money(position.available)} available'
              : '${money(position.owed)} owed · '
                    '${money(position.available)} still available',
          style: SunriseType.body.copyWith(
            color: context.sunrise.onFill.withValues(alpha: .9),
          ),
        ),
      ],
    );
  }
}

/// Asks what an account really holds, in its own currency.
class _CorrectBalanceDialog extends ConsumerStatefulWidget {
  final db.Wallet wallet;

  const _CorrectBalanceDialog({required this.wallet});

  @override
  ConsumerState<_CorrectBalanceDialog> createState() =>
      _CorrectBalanceDialogState();
}

class _CorrectBalanceDialogState extends ConsumerState<_CorrectBalanceDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: (widget.wallet.balance / 100).toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(L10n.of(context).walletCorrectBalance),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter what ${widget.wallet.name} really holds. The difference is '
            'recorded as a transaction, so the account still adds up to its '
            'own history.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            decoration: InputDecoration(
              labelText: L10n.of(context).walletRealBalance,
              prefixText: '${widget.wallet.currency} ',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(L10n.of(context).actionCancel),
        ),
        FilledButton(
          onPressed: () {
            final cents = _controller.text.toCentsOrNull();
            if (cents == null) return;
            Navigator.pop(context, cents);
          },
          child: Text(L10n.of(context).walletCorrectAction),
        ),
      ],
    );
  }
}

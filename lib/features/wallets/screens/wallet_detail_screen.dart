import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/utils/color_utils.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart' as db;
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/transactions/screens/transaction_detail_screen.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/shared/widgets/glass_card.dart';
import 'package:the_accountant/shared/widgets/icon_picker.dart';

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
      return Scaffold(
        appBar: AppBar(title: const Text('Account')),
        body: const Center(child: Text('This account no longer exists.')),
      );
    }

    final rows = _rows;
    final numberFormat = ref.watch(numberFormatSettingProvider);
    final dateFormat = ref.watch(dateFormatSettingProvider);

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

    return Scaffold(
      appBar: AppBar(
        title: Text(wallet.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => _onAction(value, wallet),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'archive',
                child: ListTile(
                  leading: Icon(
                    wallet.isArchived
                        ? Icons.unarchive_outlined
                        : Icons.archive_outlined,
                  ),
                  title: Text(wallet.isArchived ? 'Reopen' : 'Close account'),
                  subtitle: Text(
                    wallet.isArchived
                        ? 'Offer it again and count it'
                        : 'Keep its history, stop counting it',
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'exclude',
                child: ListTile(
                  leading: const Icon(Icons.functions),
                  title: Text(
                    wallet.excludeFromTotal
                        ? 'Include in the total'
                        : 'Leave out of the total',
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: AppSpacing.paddingLg,
          children: [
            GlassCard(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: tint.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          WalletIcons.getIcon(wallet.iconName),
                          color: tint,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              money(wallet.balance),
                              style: AppTypography.displaySmall,
                            ),
                            Text(
                              wallet.currency,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (wallet.isArchived || wallet.excludeFromTotal) ...[
                    AppSpacing.gapMd,
                    Text(
                      wallet.isArchived
                          ? 'Closed. Its history is kept, but it is not offered '
                                'or counted.'
                          : 'Left out of the total across accounts.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                  if (wallet.walletType == WalletType.creditCard &&
                      wallet.creditLimit != null) ...[
                    AppSpacing.gapMd,
                    _CreditSummary(
                      balanceCents: wallet.balance,
                      limitCents: wallet.creditLimit!,
                      money: money,
                    ),
                  ],
                ],
              ),
            ),
            AppSpacing.gapLg,

            Row(
              children: [
                Expanded(
                  child: _MonthStat(
                    label: 'In this month',
                    value: money(inCents),
                    tint: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MonthStat(
                    label: 'Out this month',
                    value: money(outCents),
                    tint: AppColors.error,
                  ),
                ),
              ],
            ),
            AppSpacing.gapLg,

            GlassCard(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent activity', style: AppTypography.titleSmall),
                  AppSpacing.gapSm,
                  if (rows == null)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (rows.isEmpty)
                    Text(
                      'Nothing recorded against this account yet.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    )
                  else
                    for (final t in rows.take(20))
                      InkWell(
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      t.title.isEmpty ? 'Transaction' : t.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.bodyMedium,
                                    ),
                                    Text(
                                      AppDateFormatter.formatShortDate(
                                        t.date,
                                        dateFormat,
                                      ),
                                      style: AppTypography.labelSmall.copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                t.isIncome
                                    ? '+${money(t.amount)}'
                                    : money(t.amount),
                                style: AppTypography.bodyMedium.copyWith(
                                  color: t.isIncome
                                      ? AppColors.success
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
              ),
            ),
            AppSpacing.gapXxl,
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
    }
  }
}

class _MonthStat extends StatelessWidget {
  final String label;
  final String value;
  final Color tint;

  const _MonthStat({
    required this.label,
    required this.value,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) => GlassCard(
    padding: AppSpacing.paddingLg,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
        ),
        AppSpacing.gapSm,
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTypography.titleMedium.copyWith(color: tint),
          ),
        ),
      ],
    ),
  );
}

/// What is owed on a card and what is left to spend.
///
/// A credit card's balance runs negative as it is used, so the amount
/// outstanding is its magnitude rather than the figure itself.
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
    final outstanding = balanceCents < 0 ? -balanceCents : 0;
    final available = limitCents - outstanding;
    final used = limitCents <= 0
        ? 0.0
        : (outstanding / limitCents).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: used,
            minHeight: 6,
            backgroundColor: AppColors.divider,
            color: used > 0.8 ? AppColors.error : AppColors.primaryAccent,
          ),
        ),
        AppSpacing.gapSm,
        Text(
          '${money(outstanding)} owed · ${money(available)} still available',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart' as db;
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

/// Transactions deleted in the last month, and a way to put them back.
///
/// The rows are already here: a delete is soft, and the server sweep only
/// removes them for good after thirty days. Nothing surfaced that, so a
/// mis-tap on a delete confirmation meant re-typing the entry from memory.
class RecentlyDeletedScreen extends ConsumerStatefulWidget {
  const RecentlyDeletedScreen({super.key});

  @override
  ConsumerState<RecentlyDeletedScreen> createState() =>
      _RecentlyDeletedScreenState();
}

class _RecentlyDeletedScreenState extends ConsumerState<RecentlyDeletedScreen> {
  List<db.Transaction>? _rows;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final rows = await ref
        .read(databaseProvider)
        .getRecentlyDeletedTransactions();
    if (mounted) setState(() => _rows = rows);
  }

  @override
  Widget build(BuildContext context) {
    final rows = _rows;
    final currency = ref.watch(defaultCurrencyProvider);
    final useDecimals = ref.watch(defaultDecimalProvider);
    final numberFormat = ref.watch(numberFormatSettingProvider);
    final dateFormat = ref.watch(dateFormatSettingProvider);
    final wallets = ref.watch(walletProvider).wallets;

    String money(int cents) => cents.formatCurrency(
      currency,
      useDecimals: useDecimals,
      numberFormat: numberFormat,
    );

    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).trashTitle)),
      body: rows == null
          ? const Center(child: CircularProgressIndicator())
          : rows.isEmpty
          ? _empty()
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: rows.length + 1,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                if (index == rows.length) {
                  return Padding(
                    padding: AppSpacing.paddingLg,
                    child: Text(
                      'Deleted transactions are kept for thirty days, then '
                      'removed for good.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  );
                }

                final row = rows[index];
                final wallet = wallets
                    .where((w) => w.id == row.walletId)
                    .firstOrNull;

                return ListTile(
                  title: Text(
                    row.title.isEmpty ? money(row.amount) : row.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${money(row.amount)} · ${wallet?.name ?? 'Unknown account'}'
                    ' · deleted '
                    '${AppDateFormatter.formatShortDate(row.deletedAt!, dateFormat)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: TextButton(
                    onPressed: () => _restore(row),
                    child: Text(L10n.of(context).trashRestore),
                  ),
                );
              },
            ),
    );
  }

  Widget _empty() => Center(
    child: Padding(
      padding: AppSpacing.paddingXl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.glassWhite,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.restore_from_trash_outlined,
              size: 40,
              color: AppColors.textMuted,
            ),
          ),
          AppSpacing.gapXl,
          Text(
            'Nothing deleted recently',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            'Anything you delete shows up here for thirty days.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    ),
  );

  Future<void> _restore(db.Transaction row) async {
    final database = ref.read(databaseProvider);
    await database.restoreTransaction(row.id);
    // The balance has to be recomputed rather than adjusted: the row may have
    // been deleted long enough ago for other things to have moved since.
    await ref.read(transactionProvider.notifier).loadTransactions(silent: true);
    await ref.read(walletProvider.notifier).loadWallets();
    await _load();

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(L10n.of(context).trashRestored)));
  }
}

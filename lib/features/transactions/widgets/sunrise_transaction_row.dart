import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/utils/color_utils.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/core/utils/time_formatter.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart'
    as cat;
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/transactions/screens/transaction_detail_screen.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// One stored transaction drawn as a Sunrise [TransactionTile]:
/// category tile, title, "Category · 5:43 PM", signed amount.
///
/// Taps open the detail screen unless [onTap] says otherwise.
class SunriseTransactionRow extends ConsumerWidget {
  const SunriseTransactionRow({
    super.key,
    required this.transaction,
    this.onTap,
    this.onLongPress,
    this.showDate = false,
    this.selected = false,
  });

  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Put the date before the time (lists not grouped by day).
  final bool showDate;
  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final t = transaction;
    final categories = ref.watch(cat.categoryProvider).categories;
    cat.Category? category;
    for (final x in categories) {
      if (x.id == t.categoryId) {
        category = x;
        break;
      }
    }

    final isTransfer = t.transactionType == 'transfer';
    final categoryName = isTransfer
        ? l10n.txTransfer
        : (category?.name ?? l10n.txUncategorized);
    final tint = isTransfer
        ? c.accent
        : ColorUtils.hexToColor(category?.colorCode ?? '#9A7869');
    final icon = isTransfer
        ? Symbols.sync_alt_rounded
        : IconRegistry.getIcon(category?.iconName);

    final title = t.title.trim().isNotEmpty
        ? t.title.trim()
        : (t.notes?.trim().isNotEmpty ?? false)
        ? t.notes!.trim()
        : categoryName;

    final time = AppTimeFormatter.of(context, t.date);
    final when = showDate
        ? '${MaterialLocalizations.of(context).formatShortMonthDay(t.date)} · $time'
        : time;

    final currency = ref.watch(walletCurrencyProvider(t.walletId));
    final useDecimals = ref.watch(walletDecimalProvider(t.walletId));
    final nf = ref.watch(numberFormatSettingProvider);
    final amount = isTransfer
        ? t.amount.abs().formatCurrency(
            currency,
            useDecimals: useDecimals,
            numberFormat: nf,
          )
        : t.amount.abs().formatCurrencyWithSign(
            currency,
            isIncome: t.isIncome,
            useDecimals: useDecimals,
            numberFormat: nf,
          );

    return TransactionTile(
      icon: icon,
      emoji: isTransfer ? null : IconRegistry.emojiOf(category?.iconName),
      iconColor: tint,
      title: title,
      subtitle: '$categoryName · $when',
      amount: amount.replaceFirst('-', '−'),
      tone: isTransfer
          ? AmountTone.neutral
          : t.isIncome
          ? AmountTone.income
          : AmountTone.expense,
      dimmed: !t.isPaid,
      leading: selected
          ? Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: c.gradient,
                borderRadius: BorderRadius.circular(SunriseRadius.iconTile),
              ),
              child: const Icon(
                Symbols.check_rounded,
                color: Colors.white,
                weight: 700,
              ),
            )
          : null,
      onLongPress: onLongPress,
      onTap:
          onTap ??
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TransactionDetailScreen(transactionId: t.id),
            ),
          ),
    );
  }
}

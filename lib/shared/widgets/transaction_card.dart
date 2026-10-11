import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/utils/color_utils.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/core/utils/time_formatter.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// One transaction in a list, drawn as a Sunrise [TransactionTile].
///
/// The category colour appears once, on the icon tile; the row itself is
/// plain. Expense amounts are ink and income amounts green, so the two things
/// anyone scanning a ledger looks for (what it was, and how much) stand out.
class TransactionCard extends ConsumerWidget {
  final String id;
  final String title;
  final String category;
  final String categoryColor;
  final String? categoryIcon;

  /// Major units.
  final double amount;
  final String transactionType; // 'expense' or 'income'
  final String? walletId;
  final String? notes;

  /// When set, the time is shown after the category.
  final DateTime? date;

  /// One leg of a transfer: drawn neutral, with a transfer glyph.
  final bool isTransfer;

  /// Not yet paid (upcoming): drawn dimmed.
  final bool isPending;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  /// Whether this row is picked out as part of a multiple selection.
  final bool selected;

  const TransactionCard({
    super.key,
    required this.id,
    required this.title,
    required this.category,
    required this.categoryColor,
    this.categoryIcon,
    required this.amount,
    required this.transactionType,
    this.walletId,
    this.notes,
    this.date,
    this.isTransfer = false,
    this.isPending = false,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.sunrise;
    final currency = ref.watch(walletCurrencyProvider(walletId));
    final useDecimals = ref.watch(walletDecimalProvider(walletId));
    final nf = ref.watch(numberFormatSettingProvider);
    final isExpense = transactionType == 'expense';
    final cents = (amount * 100).round().abs();

    final formatted = isTransfer
        ? cents.formatCurrency(currency, useDecimals: useDecimals, numberFormat: nf)
        : cents
              .formatCurrencyWithSign(
                currency,
                isIncome: !isExpense,
                useDecimals: useDecimals,
                numberFormat: nf,
              )
              .replaceFirst('-', '−');

    final tint = isTransfer ? c.accent : ColorUtils.hexToColor(categoryColor);
    final icon = isTransfer
        ? Symbols.sync_alt_rounded
        : categoryIcon != null
        ? IconRegistry.getIcon(categoryIcon!)
        : (isExpense ? Symbols.north_east_rounded : Symbols.south_west_rounded);
    final subtitle = date == null
        ? category
        : '$category · ${AppTimeFormatter.of(context, date!)}';

    return Semantics(
      selected: selected,
      child: TransactionTile(
        icon: icon,
        iconColor: tint,
        title: title.isNotEmpty ? title : category,
        subtitle: subtitle,
        amount: formatted,
        tone: isTransfer
            ? AmountTone.neutral
            : isExpense
            ? AmountTone.expense
            : AmountTone.income,
        dimmed: isPending,
        leading: selected
            ? Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: c.gradient,
                  borderRadius: BorderRadius.circular(SunriseRadius.iconTile),
                ),
                child: Icon(
                  Symbols.check_rounded,
                  color: c.onFill,
                  weight: 700,
                ),
              )
            : null,
        onTap: onTap,
        // A long press picks the row out when the screen offers that; where it
        // does not, it falls back to the row's own menu.
        onLongPress: onLongPress ?? () => _showOptionsMenu(context, icon, tint),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context, IconData icon, Color tint) {
    final l10n = L10n.of(context);
    final outer = context;
    showSunriseSheet<void>(
      context: context,
      builder: (sheetContext) => SunriseBottomSheet(
        title: title.isNotEmpty ? title : category,
        subtitle: category,
        child: Column(
          children: [
            if (onEdit != null)
              SheetAction(
                icon: Symbols.edit_rounded,
                label: l10n.actionEdit,
                onTap: () {
                  Navigator.pop(sheetContext);
                  onEdit!();
                },
              ),
            if (onDelete != null)
              SheetAction(
                icon: Symbols.delete_rounded,
                label: l10n.actionDelete,
                destructive: true,
                onTap: () {
                  Navigator.pop(sheetContext);
                  _confirmDelete(outer);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = L10n.of(context);
    final ok = await showSunriseConfirm(
      context: context,
      title: l10n.txDeleteOneTitle,
      message: l10n.activityDeleteOneBody,
      confirmLabel: l10n.actionDelete,
      destructive: true,
      icon: Symbols.delete_rounded,
    );
    if (ok) onDelete?.call();
  }
}

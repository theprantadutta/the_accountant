import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/utils/color_utils.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/core/utils/number_formatter.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';

/// One transaction in a list.
///
/// Rebuilt to match the row the dashboard already uses, because the two sat one
/// tap apart and looked like they came from different products.
///
/// The old row spent the category colour on everything it could: a gradient
/// across the whole card, a border, an 80px watermark of the category icon
/// bleeding out of the corner, and the category name again as a filled chip.
/// Stacked into a list that produced a column of saturated blocks — green, red,
/// teal, purple — where the colour carried no more information than the icon
/// already did, and the amounts had to compete with all of it.
///
/// Here the colour appears once, on the icon plate, and the row itself is
/// transparent. That leaves exactly two things emphasised, which are the two
/// things anyone scanning a ledger is looking for: what it was, and how much.
///
/// The amount is set in the mono face for the same reason a bank statement is —
/// in a vertical column, proportional digits do not line up, so you cannot
/// compare two figures without reading both.
class TransactionCard extends ConsumerWidget {
  final String id;
  final String title;
  final String category;
  final String categoryColor;
  final String? categoryIcon;
  final double amount;
  final String transactionType; // 'expense' or 'income'
  final String? walletId;
  final String? notes;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

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
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletCurrency = ref.watch(walletCurrencyProvider(walletId));
    final useDecimals = ref.watch(walletDecimalProvider(walletId));
    final categoryTint = ColorUtils.hexToColor(categoryColor);
    final isExpense = transactionType == 'expense';

    final nf = ref.watch(numberFormatSettingProvider);
    final formattedAmount = AppNumberFormatter.currency(
      CurrencyInfo.getSymbol(walletCurrency),
      nf,
      decimalDigits: useDecimals ? 2 : 0,
    ).format(useDecimals ? amount : amount.round());

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: () => _showOptionsMenu(context),
        borderRadius: AppSpacing.borderRadiusLg,
        child: Padding(
          // The tap target stays full-bleed so the ripple covers the whole
          // row; only the content is inset, to the same margin the search field
          // and month chips above it use.
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              _CategoryGlyph(
                tint: categoryTint,
                iconName: categoryIcon,
                isExpense: isExpense,
              ),
              AppSpacing.gapHMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.isNotEmpty ? title : category,
                      style: AppTypography.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      category,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              AppSpacing.gapHSm,
              // The sign does the work the trend arrow used to, in a character
              // that belongs to the number rather than sitting beside it.
              Text(
                '${isExpense ? '-' : '+'}$formattedAmount',
                style: AppTypography.monoSmall.copyWith(
                  color: isExpense ? AppColors.error : AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    HapticFeedback.selectionClick();
    final outerContext = context;
    final tint = ColorUtils.hexToColor(categoryColor);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.primarySurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXxl),
        ),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: AppSpacing.md),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: AppSpacing.borderRadiusFull,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.sm,
                AppSpacing.xl,
                AppSpacing.lg,
              ),
              child: Row(
                children: [
                  _CategoryGlyph(
                    tint: tint,
                    iconName: categoryIcon,
                    isExpense: transactionType == 'expense',
                  ),
                  AppSpacing.gapHMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.isNotEmpty ? title : category,
                          style: AppTypography.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          category,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: AppColors.divider),
            if (onEdit != null)
              ListTile(
                leading: Icon(
                  Icons.edit_outlined,
                  color: AppColors.textSecondary,
                ),
                title: Text('Edit', style: AppTypography.bodyLarge),
                onTap: () {
                  Navigator.pop(sheetContext);
                  onEdit!();
                },
              ),
            if (onDelete != null)
              ListTile(
                leading: Icon(Icons.delete_outline, color: AppColors.error),
                title: Text(
                  'Delete',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.error,
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _confirmDelete(outerContext);
                },
              ),
            AppSpacing.gapSm,
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.primarySurface,
        title: Text(
          'Delete this transaction?',
          style: AppTypography.titleLarge,
        ),
        content: Text(
          'It will be removed from your records and your balance will be '
          'recalculated.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(dialogContext);
              onDelete?.call();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// The one place a transaction's category colour appears.
class _CategoryGlyph extends StatelessWidget {
  const _CategoryGlyph({
    required this.tint,
    required this.iconName,
    required this.isExpense,
  });

  final Color tint;
  final String? iconName;
  final bool isExpense;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.15),
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Icon(
        iconName != null
            ? IconRegistry.getIcon(iconName!)
            : (isExpense ? Icons.arrow_upward : Icons.arrow_downward),
        color: tint,
        size: AppSpacing.iconSm,
      ),
    );
  }
}

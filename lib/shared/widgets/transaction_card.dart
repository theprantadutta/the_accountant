import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/utils/color_utils.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';

class TransactionCard extends ConsumerWidget {
  final String id;
  final String title;
  final String category;
  final String categoryColor;
  final double amount;
  final DateTime date;
  final String transactionType; // 'expense' or 'income'
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
    required this.amount,
    required this.date,
    required this.transactionType,
    this.notes,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final color = ColorUtils.hexToColor(categoryColor);
    final isExpense = transactionType == 'expense';

    // Format amount with currency
    final formatter = NumberFormat.currency(
      symbol: CurrencyInfo.getSymbol(settings.currency),
      decimalDigits: 2,
    );
    final formattedAmount = formatter.format(amount);

    // Format date AND time
    final formattedDate = _formatDateTime(date);

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showOptionsMenu(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: AppSpacing.paddingMd,
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            // Category icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: Icon(
                isExpense ? Icons.arrow_upward : Icons.arrow_downward,
                color: color,
                size: 24,
              ),
            ),
            AppSpacing.gapHMd,

            // Title, category, and date/time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.isNotEmpty ? title : category,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 13,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Amount and options
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isExpense ? '-$formattedAmount' : '+$formattedAmount',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isExpense ? AppColors.error : AppColors.success,
                  ),
                ),
                const SizedBox(height: 4),
                // More options button
                GestureDetector(
                  onTap: () => _showOptionsMenu(context),
                  child: Icon(
                    Icons.more_horiz,
                    size: 20,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    final timeFormat = DateFormat('h:mm a');
    final timeStr = timeFormat.format(date);

    if (dateOnly == today) {
      return 'Today at $timeStr';
    } else if (dateOnly == yesterday) {
      return 'Yesterday at $timeStr';
    } else if (now.difference(date).inDays < 7) {
      final dayFormat = DateFormat('EEEE');
      return '${dayFormat.format(date)} at $timeStr';
    } else {
      final dateFormat = DateFormat('MMM d, yyyy');
      return '${dateFormat.format(date)} at $timeStr';
    }
  }

  void _showOptionsMenu(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _TransactionOptionsSheet(
        transactionTitle: title.isNotEmpty ? title : category,
        onEdit: () {
          Navigator.pop(context);
          onEdit?.call();
        },
        onDelete: () {
          Navigator.pop(context);
          _confirmDelete(context);
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primarySurface,
        title: Text(
          'Delete Transaction',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete this transaction? This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete?.call();
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

}

/// Bottom sheet for transaction options
class _TransactionOptionsSheet extends StatelessWidget {
  final String transactionTitle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TransactionOptionsSheet({
    required this.transactionTitle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                transactionTitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const Divider(),

            // Edit option
            _OptionTile(
              icon: Icons.edit_outlined,
              label: 'Edit Transaction',
              onTap: onEdit,
            ),

            // Delete option
            _OptionTile(
              icon: Icons.delete_outline,
              label: 'Delete Transaction',
              iconColor: AppColors.error,
              labelColor: AppColors.error,
              onTap: onDelete,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final Color? labelColor;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    this.iconColor,
    this.labelColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.textSecondary,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: labelColor ?? AppColors.textPrimary,
          fontSize: 15,
        ),
      ),
      onTap: onTap,
    );
  }
}

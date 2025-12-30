import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_animations.dart';
import 'package:the_accountant/data/models/transaction.dart';
import 'package:the_accountant/features/transactions/widgets/date_time_picker.dart';
import 'package:the_accountant/features/transactions/widgets/special_type_selector.dart';
import 'package:the_accountant/features/transactions/widgets/wallet_selector.dart';

/// All transaction options in a scrollable list of expandable tiles.
class TransactionOptionsSection extends ConsumerStatefulWidget {
  /// Selected wallet ID
  final String? selectedWalletId;

  /// Callback when wallet changes
  final ValueChanged<String> onWalletChanged;

  /// Selected date and time
  final DateTime selectedDateTime;

  /// Callback when date/time changes
  final ValueChanged<DateTime> onDateTimeChanged;

  /// Selected payment method ID
  final String? selectedPaymentMethodId;

  /// Callback when payment method changes
  final ValueChanged<String?>? onPaymentMethodChanged;

  /// Selected special type
  final TransactionSpecialType specialType;

  /// Callback when special type changes
  final ValueChanged<TransactionSpecialType> onSpecialTypeChanged;

  /// Selected budget ID
  final String? selectedBudgetId;

  /// Callback when budget changes
  final ValueChanged<String?>? onBudgetChanged;

  /// Selected objective ID
  final String? selectedObjectiveId;

  /// Callback when objective changes
  final ValueChanged<String?>? onObjectiveChanged;

  /// Whether this is an income transaction
  final bool isIncome;

  /// Accent color for styling
  final Color? accentColor;

  const TransactionOptionsSection({
    super.key,
    required this.selectedWalletId,
    required this.onWalletChanged,
    required this.selectedDateTime,
    required this.onDateTimeChanged,
    this.selectedPaymentMethodId,
    this.onPaymentMethodChanged,
    required this.specialType,
    required this.onSpecialTypeChanged,
    this.selectedBudgetId,
    this.onBudgetChanged,
    this.selectedObjectiveId,
    this.onObjectiveChanged,
    this.isIncome = false,
    this.accentColor,
  });

  @override
  ConsumerState<TransactionOptionsSection> createState() =>
      _TransactionOptionsSectionState();
}

class _TransactionOptionsSectionState
    extends ConsumerState<TransactionOptionsSection> {
  bool _showSpecialTypeExpanded = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.accentColor ?? AppColors.primaryAccent;

    return Column(
      children: [
        // Wallet/Account Selector
        _buildOptionTile(
          icon: Icons.account_balance_wallet,
          label: 'Account',
          color: color,
          child: WalletSelector(
            selectedWalletId: widget.selectedWalletId,
            onWalletSelected: (wallet) => widget.onWalletChanged(wallet.id),
            showBalance: false,
          ),
        ),
        AppSpacing.gapSm,

        // Date & Time Picker
        _buildOptionTile(
          icon: Icons.event,
          label: 'Date & Time',
          color: color,
          child: DateTimePicker(
            selectedDateTime: widget.selectedDateTime,
            onDateTimeChanged: widget.onDateTimeChanged,
            accentColor: color,
            label: '',
            showTime: true,
          ),
        ),
        AppSpacing.gapSm,

        // Transaction Type (Special)
        _buildExpandableTile(
          icon: Icons.category,
          label: 'Transaction Type',
          value: widget.specialType.label,
          valueColor: widget.specialType.color,
          isExpanded: _showSpecialTypeExpanded,
          onToggle: () {
            HapticFeedback.lightImpact();
            setState(() {
              _showSpecialTypeExpanded = !_showSpecialTypeExpanded;
            });
          },
          expandedChild: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: SpecialTypeSelector(
              selectedType: widget.specialType,
              onTypeChanged: (type) {
                widget.onSpecialTypeChanged(type);
                setState(() {
                  _showSpecialTypeExpanded = false;
                });
              },
              isIncome: widget.isIncome,
              expanded: true,
            ),
          ),
        ),

        // Due Date (for upcoming/credit/debt)
        if (widget.specialType.requiresDueDate) ...[
          AppSpacing.gapSm,
          _buildDueDateOption(color),
        ],
      ],
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    required Color color,
    required Widget child,
  }) {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              AppSpacing.gapHSm,
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          AppSpacing.gapSm,
          child,
        ],
      ),
    );
  }

  Widget _buildExpandableTile({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget expandedChild,
  }) {
    return AnimatedContainer(
      duration: AppAnimations.fast,
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(
          color: isExpanded ? (valueColor ?? AppColors.primaryAccent) : AppColors.divider,
        ),
      ),
      child: Column(
        children: [
          // Header
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Icon(icon, size: 20, color: valueColor ?? AppColors.primaryAccent),
                AppSpacing.gapHSm,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: valueColor ?? AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  duration: AppAnimations.fast,
                  turns: isExpanded ? 0.5 : 0,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          // Expanded content
          AnimatedCrossFade(
            duration: AppAnimations.fast,
            crossFadeState:
                isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: expandedChild,
          ),
        ],
      ),
    );
  }

  Widget _buildDueDateOption(Color color) {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: widget.specialType.color.withValues(alpha: 0.1),
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(
          color: widget.specialType.color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.event_available,
                size: 20,
                color: widget.specialType.color,
              ),
              AppSpacing.gapHSm,
              Expanded(
                child: Text(
                  widget.specialType == TransactionSpecialType.upcoming
                      ? 'This transaction is scheduled for a future date.'
                      : widget.specialType == TransactionSpecialType.credit
                          ? 'When do you expect to be paid back?'
                          : 'When do you need to pay them back?',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.specialType.color,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapSm,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  'Transaction will be marked as unpaid',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact version of transaction options for inline editing.
class TransactionOptionsCompact extends StatelessWidget {
  final String? walletName;
  final DateTime dateTime;
  final TransactionSpecialType specialType;
  final VoidCallback? onTap;

  const TransactionOptionsCompact({
    super.key,
    this.walletName,
    required this.dateTime,
    required this.specialType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.paddingMd,
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            // Wallet
            if (walletName != null) ...[
              Icon(
                Icons.account_balance_wallet,
                size: 16,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                walletName!,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
            ],

            // Date
            Icon(
              Icons.event,
              size: 16,
              color: AppColors.textMuted,
            ),
            const SizedBox(width: 4),
            Text(
              _formatDate(dateTime),
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),

            const Spacer(),

            // Special type indicator
            SpecialTypeIndicator(type: specialType),

            // Chevron
            if (onTap != null) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.textMuted,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else if (dateOnly == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

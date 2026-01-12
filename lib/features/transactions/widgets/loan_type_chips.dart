import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/data/models/transaction.dart';

/// Loan type options displayed as horizontal chips.
/// Options: No Loan, Credit (Lent), Debt (Borrowed)
class LoanTypeChips extends StatelessWidget {
  final TransactionSpecialType selectedType;
  final ValueChanged<TransactionSpecialType> onTypeChanged;
  final Color accentColor;

  const LoanTypeChips({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    required this.accentColor,
  });

  /// Check if the selected type is a loan type
  bool get _isLoanType =>
      selectedType == TransactionSpecialType.credit ||
      selectedType == TransactionSpecialType.debt;

  /// Get the "no loan" equivalent type (preserves subscription/upcoming if set)
  TransactionSpecialType get _noLoanType {
    // If currently a loan type, go back to none
    if (_isLoanType) return TransactionSpecialType.none;
    // Otherwise keep current type (might be subscription, upcoming, etc.)
    return selectedType;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 16,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                'Loan',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Chips row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // No Loan chip
                _LoanChip(
                  label: 'No loan',
                  icon: Icons.money_off_rounded,
                  isSelected: !_isLoanType,
                  color: AppColors.textSecondary,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTypeChanged(_noLoanType);
                  },
                ),
                const SizedBox(width: 8),

                // Credit (Lent money - they owe you)
                _LoanChip(
                  label: 'Lent Money',
                  subtitle: 'They owe you',
                  icon: Icons.arrow_upward_rounded,
                  isSelected: selectedType == TransactionSpecialType.credit,
                  color: AppColors.success,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTypeChanged(TransactionSpecialType.credit);
                  },
                ),
                const SizedBox(width: 8),

                // Debt (Borrowed money - you owe them)
                _LoanChip(
                  label: 'Borrowed',
                  subtitle: 'You owe them',
                  icon: Icons.arrow_downward_rounded,
                  isSelected: selectedType == TransactionSpecialType.debt,
                  color: AppColors.error,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTypeChanged(TransactionSpecialType.debt);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoanChip extends StatelessWidget {
  final String label;
  final String? subtitle;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _LoanChip({
    required this.label,
    this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : AppColors.primarySurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? color : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? color : AppColors.textSecondary,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected
                          ? color.withValues(alpha: 0.8)
                          : AppColors.textMuted,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

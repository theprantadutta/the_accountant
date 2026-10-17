import 'package:flutter/material.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
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
    return Padding(
      padding: EdgeInsets.zero,
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
                L10n.of(context).txLoan,
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
            // On to the screen edge, like the other chip rows.
            clipBehavior: Clip.none,
            child: Row(
              children: [
                // No Loan chip
                _LoanChip(
                  label: L10n.of(context).txNoLoan,
                  icon: Icons.money_off_rounded,
                  isSelected: !_isLoanType,
                  color: AppColors.textSecondary,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTypeChanged(_noLoanType);
                  },
                ),
                const SizedBox(width: 8),

                // Credit (Lent money)
                _LoanChip(
                  label: L10n.of(context).txLentMoney,
                  icon: Icons.arrow_upward_rounded,
                  isSelected: selectedType == TransactionSpecialType.credit,
                  color: AppColors.success,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTypeChanged(TransactionSpecialType.credit);
                  },
                ),
                const SizedBox(width: 8),

                // Debt (Borrowed money)
                _LoanChip(
                  label: L10n.of(context).txBorrowedMoney,
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
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
  }) : subtitle = null;

  @override
  Widget build(BuildContext context) =>
      SunriseChip(label: label, icon: icon, selected: isSelected, onTap: onTap);
}

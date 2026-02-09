import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_animations.dart';
import 'package:the_accountant/data/models/transaction.dart';

/// Extension for special type display properties
extension TransactionSpecialTypeExtension on TransactionSpecialType {
  String get label {
    switch (this) {
      case TransactionSpecialType.none:
        return 'Regular';
      case TransactionSpecialType.upcoming:
        return 'Upcoming';
      case TransactionSpecialType.subscription:
        return 'Subscription';
      case TransactionSpecialType.repetitive:
        return 'Repetitive';
      case TransactionSpecialType.credit:
        return 'Lend';
      case TransactionSpecialType.debt:
        return 'Borrow';
    }
  }

  String get description {
    switch (this) {
      case TransactionSpecialType.none:
        return 'Normal transaction';
      case TransactionSpecialType.upcoming:
        return 'Future payment to track';
      case TransactionSpecialType.subscription:
        return 'Recurring service payment';
      case TransactionSpecialType.repetitive:
        return 'Repeating transaction';
      case TransactionSpecialType.credit:
        return 'Money you lent (they owe you)';
      case TransactionSpecialType.debt:
        return 'Money you borrowed (you owe them)';
    }
  }

  IconData get icon {
    switch (this) {
      case TransactionSpecialType.none:
        return Icons.receipt;
      case TransactionSpecialType.upcoming:
        return Icons.schedule;
      case TransactionSpecialType.subscription:
        return Icons.autorenew;
      case TransactionSpecialType.repetitive:
        return Icons.repeat;
      case TransactionSpecialType.credit:
        return Icons.arrow_forward;
      case TransactionSpecialType.debt:
        return Icons.arrow_back;
    }
  }

  Color get color {
    switch (this) {
      case TransactionSpecialType.none:
        return AppColors.primaryAccent;
      case TransactionSpecialType.upcoming:
        return AppColors.warning;
      case TransactionSpecialType.subscription:
        return AppColors.neonPurple;
      case TransactionSpecialType.repetitive:
        return AppColors.neonBlue;
      case TransactionSpecialType.credit:
        return AppColors.success;
      case TransactionSpecialType.debt:
        return AppColors.error;
    }
  }

  /// Whether this type requires a due date
  bool get requiresDueDate {
    return this == TransactionSpecialType.upcoming ||
        this == TransactionSpecialType.credit ||
        this == TransactionSpecialType.debt;
  }

  /// Whether this type starts as unpaid
  /// Credit/debt do NOT start unpaid - the money movement has already happened
  bool get startsUnpaid {
    return this == TransactionSpecialType.upcoming;
  }

  /// Whether this is a loan type (credit or debt)
  bool get isLoanType {
    return this == TransactionSpecialType.credit ||
        this == TransactionSpecialType.debt;
  }
}

/// Special transaction type selector widget.
/// Allows selecting Regular, Subscription, Upcoming, Lend, or Borrow.
class SpecialTypeSelector extends StatelessWidget {
  /// Currently selected special type
  final TransactionSpecialType selectedType;

  /// Callback when type changes
  final ValueChanged<TransactionSpecialType> onTypeChanged;

  /// Whether this is an income transaction (affects which types are shown)
  final bool isIncome;

  /// Whether to show as expanded radio buttons or compact chips
  final bool expanded;

  const SpecialTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    this.isIncome = false,
    this.expanded = false,
  });

  List<TransactionSpecialType> get _availableTypes {
    // For income, we show credit (they're paying you back)
    // For expense, we show debt (you're paying them back)
    return [
      TransactionSpecialType.none,
      TransactionSpecialType.subscription,
      TransactionSpecialType.upcoming,
      if (isIncome)
        TransactionSpecialType
            .credit // They owe you, paying back
      else
        TransactionSpecialType.debt, // You owe them, paying back
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (expanded) {
      return _buildExpandedView();
    }
    return _buildChipsView();
  }

  Widget _buildChipsView() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _availableTypes.map((type) {
        final isSelected = selectedType == type;
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            onTypeChanged(type);
          },
          child: AnimatedContainer(
            duration: AppAnimations.fast,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? type.color.withValues(alpha: 0.2)
                  : AppColors.primarySurface,
              borderRadius: AppSpacing.borderRadiusFull,
              border: Border.all(
                color: isSelected ? type.color : AppColors.divider,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  type.icon,
                  size: 16,
                  color: isSelected ? type.color : AppColors.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  type.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected ? type.color : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExpandedView() {
    return Column(
      children: _availableTypes.map((type) {
        final isSelected = selectedType == type;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _SpecialTypeRadio(
            type: type,
            isSelected: isSelected,
            onTap: () {
              HapticFeedback.lightImpact();
              onTypeChanged(type);
            },
          ),
        );
      }).toList(),
    );
  }
}

/// Individual radio button for special type.
class _SpecialTypeRadio extends StatelessWidget {
  final TransactionSpecialType type;
  final bool isSelected;
  final VoidCallback onTap;

  const _SpecialTypeRadio({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        padding: AppSpacing.paddingMd,
        decoration: BoxDecoration(
          color: isSelected
              ? type.color.withValues(alpha: 0.1)
              : AppColors.primarySurface,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: isSelected ? type.color : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio indicator
            AnimatedContainer(
              duration: AppAnimations.fast,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? type.color : Colors.transparent,
                border: Border.all(
                  color: isSelected ? type.color : AppColors.textMuted,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 14, color: AppColors.textPrimary)
                  : null,
            ),
            AppSpacing.gapHMd,

            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: type.color.withValues(alpha: 0.2),
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: Icon(type.icon, size: 20, color: type.color),
            ),
            AppSpacing.gapHMd,

            // Label and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected ? type.color : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    type.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact inline display for the currently selected special type.
class SpecialTypeIndicator extends StatelessWidget {
  final TransactionSpecialType type;
  final VoidCallback? onTap;

  const SpecialTypeIndicator({super.key, required this.type, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (type == TransactionSpecialType.none) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: type.color.withValues(alpha: 0.2),
          borderRadius: AppSpacing.borderRadiusFull,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(type.icon, size: 14, color: type.color),
            const SizedBox(width: 4),
            Text(
              type.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: type.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

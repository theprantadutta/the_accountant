import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_animations.dart';

/// Transaction types for the type selector
enum TransactionTypeSelection {
  expense,
  income,
  transfer,
}

/// Extension for transaction type properties
extension TransactionTypeExtension on TransactionTypeSelection {
  String get label {
    switch (this) {
      case TransactionTypeSelection.expense:
        return 'Expense';
      case TransactionTypeSelection.income:
        return 'Income';
      case TransactionTypeSelection.transfer:
        return 'Transfer';
    }
  }

  IconData get icon {
    switch (this) {
      case TransactionTypeSelection.expense:
        return Icons.arrow_downward;
      case TransactionTypeSelection.income:
        return Icons.arrow_upward;
      case TransactionTypeSelection.transfer:
        return Icons.swap_horiz;
    }
  }

  Color get color {
    switch (this) {
      case TransactionTypeSelection.expense:
        return AppColors.error;
      case TransactionTypeSelection.income:
        return AppColors.success;
      case TransactionTypeSelection.transfer:
        return AppColors.neonCyan;
    }
  }

  bool get isIncome => this == TransactionTypeSelection.income;
}

/// Transaction type selector header widget.
/// Displays Expense/Income/Transfer tabs at the top of the transaction screen.
class TransactionTypeHeader extends StatelessWidget {
  /// Currently selected transaction type
  final TransactionTypeSelection selectedType;

  /// Callback when type changes
  final ValueChanged<TransactionTypeSelection> onTypeChanged;

  /// Whether to show the transfer option
  final bool showTransfer;

  const TransactionTypeHeader({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    this.showTransfer = true,
  });

  @override
  Widget build(BuildContext context) {
    final types = showTransfer
        ? TransactionTypeSelection.values
        : [TransactionTypeSelection.expense, TransactionTypeSelection.income];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Row(
        children: types.map((type) {
          final isSelected = selectedType == type;
          return Expanded(
            child: _TypeTab(
              type: type,
              isSelected: isSelected,
              onTap: () {
                HapticFeedback.lightImpact();
                onTypeChanged(type);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Individual type tab button.
class _TypeTab extends StatefulWidget {
  final TransactionTypeSelection type;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeTab({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_TypeTab> createState() => _TypeTabState();
}

class _TypeTabState extends State<_TypeTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.instant,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: AppAnimations.pressedScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppAnimations.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          curve: AppAnimations.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.type.color.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: AppSpacing.borderRadiusSm,
            border: widget.isSelected
                ? Border.all(color: widget.type.color, width: 2)
                : Border.all(color: Colors.transparent, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.type.icon,
                size: 18,
                color: widget.isSelected
                    ? widget.type.color
                    : AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                widget.type.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      widget.isSelected ? FontWeight.bold : FontWeight.normal,
                  color: widget.isSelected
                      ? widget.type.color
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact version of transaction type selector for inline use.
class TransactionTypeChips extends StatelessWidget {
  final TransactionTypeSelection selectedType;
  final ValueChanged<TransactionTypeSelection> onTypeChanged;
  final bool showTransfer;

  const TransactionTypeChips({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    this.showTransfer = true,
  });

  @override
  Widget build(BuildContext context) {
    final types = showTransfer
        ? TransactionTypeSelection.values
        : [TransactionTypeSelection.expense, TransactionTypeSelection.income];

    return Row(
      children: types.map((type) {
        final isSelected = selectedType == type;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onTypeChanged(type);
            },
            child: AnimatedContainer(
              duration: AppAnimations.fast,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  const SizedBox(width: 4),
                  Text(
                    type.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? type.color : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

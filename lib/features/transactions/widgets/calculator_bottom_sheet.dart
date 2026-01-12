import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/features/transactions/widgets/calculator_keypad.dart';

/// Shows a calculator in a bottom sheet for amount input.
/// Returns the entered amount when user taps Done.
Future<double?> showCalculatorBottomSheet({
  required BuildContext context,
  required double initialAmount,
  required bool isIncome,
  required String currencySymbol,
  Color? accentColor,
}) {
  return showModalBottomSheet<double>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.3),
    builder: (context) => _CalculatorBottomSheet(
      initialAmount: initialAmount,
      isIncome: isIncome,
      currencySymbol: currencySymbol,
      accentColor: accentColor,
    ),
  );
}

class _CalculatorBottomSheet extends StatefulWidget {
  final double initialAmount;
  final bool isIncome;
  final String currencySymbol;
  final Color? accentColor;

  const _CalculatorBottomSheet({
    required this.initialAmount,
    required this.isIncome,
    required this.currencySymbol,
    this.accentColor,
  });

  @override
  State<_CalculatorBottomSheet> createState() => _CalculatorBottomSheetState();
}

class _CalculatorBottomSheetState extends State<_CalculatorBottomSheet> {
  late double _amount;

  @override
  void initState() {
    super.initState();
    _amount = widget.initialAmount;
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.accentColor ??
        (widget.isIncome ? AppColors.success : AppColors.error);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.glassGradient,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),

              // Header with Done button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      'Enter Amount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pop(context, _amount);
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: color,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Calculator keypad
              SizedBox(
                height: 500,
                child: CalculatorKeypad(
                  initialAmount: _amount,
                  onAmountChanged: (amount) {
                    setState(() {
                      _amount = amount;
                    });
                  },
                  isIncome: widget.isIncome,
                  currencySymbol: widget.currencySymbol,
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

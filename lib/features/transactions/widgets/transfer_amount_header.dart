import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';

/// Header widget for transfer transactions displaying amount only.
/// Tapping the amount opens calculator.
class TransferAmountHeader extends StatelessWidget {
  final double amount;
  final String currencySymbol;
  final VoidCallback onAmountTap;

  const TransferAmountHeader({
    super.key,
    required this.amount,
    required this.currencySymbol,
    required this.onAmountTap,
  });

  String _formatAmount(double amount) {
    if (amount == 0) return '0';

    final parts = amount.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];

    final buffer = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(intPart[i]);
    }

    if (decPart != '00') {
      buffer.write('.');
      buffer.write(decPart);
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    // Cyan/teal color for transfers
    final color = AppColors.primaryAccent;

    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.5),
            color.withValues(alpha: 0.35),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onAmountTap();
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Transfer icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.swap_horiz_rounded,
                    size: 28,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(width: 16),
                // Amount display
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transfer Amount',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currencySymbol,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              _formatAmount(amount),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -1,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

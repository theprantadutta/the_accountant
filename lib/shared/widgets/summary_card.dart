import 'package:flutter/material.dart';
import 'package:the_accountant/core/utils/number_formatter.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final String currency;
  final IconData icon;
  final Color iconColor;
  final bool isPositive;
  final bool useDecimals;
  final String numberFormat;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.currency,
    required this.icon,
    required this.iconColor,
    this.isPositive = true,
    this.useDecimals = true,
    this.numberFormat = 'comma_dot',
  });

  @override
  Widget build(BuildContext context) {
    final formattedAmount = AppNumberFormatter.currency(
      '$currency ',
      numberFormat,
      decimalDigits: useDecimals ? 2 : 0,
    ).format(useDecimals ? amount : amount.round());

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              formattedAmount,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isPositive ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

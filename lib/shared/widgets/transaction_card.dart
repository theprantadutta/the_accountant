import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/utils/color_utils.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';

class TransactionCard extends ConsumerWidget {
  final String title;
  final String category;
  final String categoryColor;
  final double amount;
  final DateTime date;
  final String transactionType; // 'expense' or 'income'
  final VoidCallback? onTap;

  const TransactionCard({
    super.key,
    required this.title,
    required this.category,
    required this.categoryColor,
    required this.amount,
    required this.date,
    required this.transactionType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final color = ColorUtils.hexToColor(categoryColor);
    final isExpense = transactionType == 'expense';

    // Format amount with currency
    final formatter = NumberFormat.currency(
      symbol: _getCurrencySymbol(settings.currency),
      decimalDigits: 2,
    );
    final formattedAmount = formatter.format(amount);

    final formattedDate = DateFormat('MMM dd, yyyy').format(date);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isExpense ? Icons.arrow_upward : Icons.arrow_downward,
            color: color,
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category),
            Text(
              formattedDate,
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ],
        ),
        trailing: Text(
          isExpense ? '-$formattedAmount' : formattedAmount,
          style: TextStyle(
            color: isExpense ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getCurrencySymbol(String currencyCode) {
    // Map currency codes to symbols
    final Map<String, String> currencySymbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'CAD': 'C\$',
      'AUD': 'A\$',
      'CHF': 'CHF',
      'CNY': '¥',
      'SEK': 'kr',
      'NZD': 'NZ\$',
      'MXN': '\$',
      'SGD': 'S\$',
      'HKD': 'HK\$',
      'NOK': 'kr',
      'KRW': '₩',
      'TRY': '₺',
      'RUB': '₽',
      'INR': '₹',
      'BRL': 'R\$',
      'ZAR': 'R',
    };

    return currencySymbols[currencyCode] ?? currencyCode;
  }
}

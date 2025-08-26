import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';

class BudgetProgress extends ConsumerWidget {
  final String budgetName;
  final String categoryId;
  final double limit;
  final DateTime startDate;
  final DateTime endDate;
  final String currency;

  const BudgetProgress({
    super.key,
    required this.budgetName,
    required this.categoryId,
    required this.limit,
    required this.startDate,
    required this.endDate,
    required this.currency,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionProvider);
    final settings = ref.watch(settingsProvider);
    
    // Calculate spent amount for this budget's category and date range
    final spent = transactionState.transactions
        .where((transaction) => 
            transaction.categoryId == categoryId &&
            transaction.type == 'expense' &&
            transaction.date.isAfter(startDate) &&
            transaction.date.isBefore(endDate))
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
    
    final percentage = limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;
    final remaining = limit - spent;
    
    final formattedLimit = NumberFormat.currency(
      symbol: _getCurrencySymbol(settings.currency),
      decimalDigits: 2,
    ).format(limit);
    
    final formattedSpent = NumberFormat.currency(
      symbol: _getCurrencySymbol(settings.currency),
      decimalDigits: 2,
    ).format(spent);
    
    final formattedRemaining = NumberFormat.currency(
      symbol: _getCurrencySymbol(settings.currency),
      decimalDigits: 2,
    ).format(remaining.abs());
    
    Color getProgressColor() {
      if (percentage < 0.5) return Colors.green;
      if (percentage < 0.8) return Colors.orange;
      return Colors.red;
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  budgetName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '$formattedSpent / $formattedLimit',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[300],
              color: getProgressColor(),
            ),
            const SizedBox(height: 8),
            Text(
              remaining >= 0 
                ? '$formattedRemaining remaining' 
                : '$formattedRemaining over budget',
              style: TextStyle(
                color: remaining >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
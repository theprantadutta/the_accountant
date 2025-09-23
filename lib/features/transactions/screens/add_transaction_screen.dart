import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/features/transactions/widgets/add_transaction_form.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Add Transaction',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: AddTransactionForm(
          onTransactionAdded: () {
            // Show success message and navigate back
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Transaction added successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class AddTransactionScreenWithPreset extends StatelessWidget {
  final String presetType;
  final String presetCategoryName;

  const AddTransactionScreenWithPreset({
    super.key,
    required this.presetType,
    required this.presetCategoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Add ${presetType == 'income' ? 'Income' : 'Expense'}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: AddTransactionFormWithPreset(
          presetType: presetType,
          presetCategoryName: presetCategoryName,
          onTransactionAdded: () {
            // Show success message and navigate back
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Transaction added successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/budgets/screens/add_budget_screen.dart';
import 'package:the_accountant/shared/widgets/budget_progress.dart';

class BudgetListScreen extends ConsumerWidget {
  const BudgetListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetState = ref.watch(budgetProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddBudgetScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: budgetState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : budgetState.budgets.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No budgets yet', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 16),
                  Text(
                    'Create your first budget to start tracking your expenses',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: budgetState.budgets.length,
              itemBuilder: (context, index) {
                final budget = budgetState.budgets[index];
                return BudgetProgress(
                  budgetName: budget.name,
                  categoryId: budget.categoryId,
                  limit: budget.limit,
                  startDate: budget.startDate,
                  endDate: budget.endDate,
                  currency: 'USD', // This will be updated to use settings
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/constants/app_constants.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';

class AddBudgetScreen extends ConsumerStatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  ConsumerState<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends ConsumerState<AddBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _limitController = TextEditingController();

  String _selectedPeriod = AppConstants.budgetPeriodMonthly;
  String _selectedCategory = '';
  String _selectedCategoryId = '';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(
      const Duration(days: 30),
    ); // Default to 30 days for monthly

    // Set default category
    if (AppConstants.defaultCategories.isNotEmpty) {
      _selectedCategory = AppConstants.defaultCategories.first['name'];
      _selectedCategoryId = AppConstants
          .defaultCategories
          .first['name']; // Using name as ID for demo
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        // Update end date based on period
        if (_selectedPeriod == AppConstants.budgetPeriodWeekly) {
          _endDate = picked.add(const Duration(days: 7));
        } else {
          _endDate = picked.add(const Duration(days: 30));
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final limit = double.tryParse(_limitController.text);
      if (limit != null &&
          limit > 0 &&
          _startDate != null &&
          _endDate != null) {
        ref
            .read(budgetProvider.notifier)
            .addBudget(
              name: _nameController.text,
              categoryId: _selectedCategoryId,
              limit: limit,
              period: _selectedPeriod,
              startDate: _startDate!,
              endDate: _endDate!,
            );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final budgetState = ref.watch(budgetProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Budget')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Budget name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Budget Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a budget name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Amount limit
              TextFormField(
                controller: _limitController,
                decoration: const InputDecoration(
                  labelText: 'Amount Limit',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount limit';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Category selector
              const Text(
                'Category',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: AppConstants.defaultCategories
                      .where(
                        (cat) =>
                            cat['type'] == AppConstants.categoryTypeExpense,
                      )
                      .map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(category['name']),
                            selected: _selectedCategory == category['name'],
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = category['name'];
                                _selectedCategoryId = category['name'];
                              });
                            },
                          ),
                        );
                      })
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              // Period selector
              const Text(
                'Period',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Weekly'),
                    selected:
                        _selectedPeriod == AppConstants.budgetPeriodWeekly,
                    onSelected: (selected) {
                      setState(() {
                        _selectedPeriod = AppConstants.budgetPeriodWeekly;
                        // Update end date
                        if (_startDate != null) {
                          _endDate = _startDate!.add(const Duration(days: 7));
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  ChoiceChip(
                    label: const Text('Monthly'),
                    selected:
                        _selectedPeriod == AppConstants.budgetPeriodMonthly,
                    onSelected: (selected) {
                      setState(() {
                        _selectedPeriod = AppConstants.budgetPeriodMonthly;
                        // Update end date
                        if (_startDate != null) {
                          _endDate = _startDate!.add(const Duration(days: 30));
                        }
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Date range
              const Text(
                'Date Range',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      controller: TextEditingController(
                        text: _startDate != null
                            ? '${_startDate!.month}/${_startDate!.day}/${_startDate!.year}'
                            : '',
                      ),
                      onTap: () => _selectStartDate(context),
                      validator: (value) {
                        if (_startDate == null) {
                          return 'Please select a start date';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'End Date',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      controller: TextEditingController(
                        text: _endDate != null
                            ? '${_endDate!.month}/${_endDate!.day}/${_endDate!.year}'
                            : '',
                      ),
                      onTap: () => _selectEndDate(context),
                      validator: (value) {
                        if (_endDate == null) {
                          return 'Please select an end date';
                        }
                        if (_startDate != null &&
                            _endDate!.isBefore(_startDate!)) {
                          return 'End date must be after start date';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Submit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: budgetState.isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: budgetState.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Create Budget'),
                ),
              ),
              if (budgetState.errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    budgetState.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

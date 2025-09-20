import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/shared/widgets/category_chip.dart';
import 'package:the_accountant/core/constants/app_constants.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/transactions/providers/payment_method_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/dashboard/providers/financial_data_provider.dart';
import 'package:the_accountant/features/ai/widgets/category_suggestion_widget.dart';

class RecurrencePattern {
  final String frequency; // daily, weekly, monthly, yearly
  final int interval; // every 1 day, 2 weeks, etc.
  final DateTime? endDate; // optional end date

  RecurrencePattern({
    required this.frequency,
    required this.interval,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'frequency': frequency,
      'interval': interval,
      'endDate': endDate?.toIso8601String(),
    };
  }

  factory RecurrencePattern.fromJson(Map<String, dynamic> json) {
    return RecurrencePattern(
      frequency: json['frequency'],
      interval: json['interval'],
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  static RecurrencePattern? fromString(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return null;
    try {
      final json = jsonDecode(jsonString);
      return RecurrencePattern.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}

class AddTransactionForm extends ConsumerStatefulWidget {
  final VoidCallback onTransactionAdded;
  final String? walletId; // Add walletId parameter

  const AddTransactionForm({
    super.key,
    required this.onTransactionAdded,
    this.walletId, // Add walletId to constructor
  });

  @override
  ConsumerState<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends ConsumerState<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _dateController = TextEditingController();

  String _selectedType = AppConstants.transactionTypeExpense;
  String _selectedCategory = '';
  String _selectedCategoryId = '';
  String _selectedPaymentMethod = 'Cash';
  DateTime? _selectedDate;
  bool _isRecurring = false;
  String _recurrenceFrequency = 'monthly';
  int _recurrenceInterval = 1;
  DateTime? _recurrenceEndDate;

  final List<String> _defaultPaymentMethods = [
    'Cash',
    'Credit Card',
    'Debit Card',
    'Bank Transfer',
    'Other',
  ];

  // Fix: Use map literal instead of constructor
  final List<Map<String, String>> _recurrenceFrequencies = [
    {'value': 'daily', 'label': 'Daily'},
    {'value': 'weekly', 'label': 'Weekly'},
    {'value': 'monthly', 'label': 'Monthly'},
    {'value': 'yearly', 'label': 'Yearly'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _dateController.text = _formatDate(_selectedDate!);

    // Initialize with first available category - will be set properly in build method
    // when categories are loaded from the provider
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _selectRecurrenceEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _recurrenceEndDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _recurrenceEndDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text);
      if (amount != null && amount > 0) {
        String? recurrencePattern;
        if (_isRecurring) {
          final pattern = RecurrencePattern(
            frequency: _recurrenceFrequency,
            interval: _recurrenceInterval,
            endDate: _recurrenceEndDate,
          );
          recurrencePattern = pattern.toString();
        }

        // Get the first available wallet if walletId is not provided
        final walletState = ref.read(walletProvider);
        final selectedWalletId =
            widget.walletId ??
            (walletState.wallets.isNotEmpty
                ? walletState.wallets.first.id
                : '');

        await ref
            .read(transactionProvider.notifier)
            .addTransaction(
              amount: amount,
              type: _selectedType,
              category: _selectedCategory,
              categoryId: _selectedCategoryId,
              walletId: selectedWalletId, // Add walletId to the call
              date: _selectedDate!,
              notes: _notesController.text,
              paymentMethod: _selectedPaymentMethod,
              isRecurring: _isRecurring,
              recurrencePattern: recurrencePattern,
            );

        // Refresh financial data after adding transaction
        await ref.read(financialDataProvider.notifier).refreshData();

        widget.onTransactionAdded();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionProvider);
    final paymentMethodState = ref.watch(paymentMethodProvider);

    // Combine default payment methods with user-defined ones
    final allPaymentMethods = <String>{
      ..._defaultPaymentMethods,
      ...paymentMethodState.paymentMethods.map((pm) => pm.name),
    }.toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction type selector
            const Text(
              'Transaction Type',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('Expense'),
                  selected:
                      _selectedType == AppConstants.transactionTypeExpense,
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = AppConstants.transactionTypeExpense;
                      // Reset category selection when type changes
                      _selectedCategory = '';
                      _selectedCategoryId = '';
                    });
                  },
                ),
                const SizedBox(width: 16),
                ChoiceChip(
                  label: const Text('Income'),
                  selected: _selectedType == AppConstants.transactionTypeIncome,
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = AppConstants.transactionTypeIncome;
                      // Reset category selection when type changes
                      _selectedCategory = '';
                      _selectedCategoryId = '';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Amount field
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
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
            Consumer(
              builder: (context, ref, child) {
                final categoryState = ref.watch(categoryProvider);
                final availableCategories = categoryState.categories
                    .where((cat) => cat.type == _selectedType)
                    .toList();

                // Auto-select first category if none selected
                if (_selectedCategoryId.isEmpty &&
                    availableCategories.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _selectedCategory = availableCategories.first.name;
                      _selectedCategoryId = availableCategories.first.id;
                    });
                  });
                }

                if (availableCategories.isEmpty) {
                  return Container(
                    height: 60,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'No categories available for $_selectedType',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: availableCategories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CategoryChip(
                          categoryName: category.name,
                          colorCode: category.colorCode,
                          isSelected: _selectedCategoryId == category.id,
                          onTap: () {
                            setState(() {
                              _selectedCategory = category.name;
                              _selectedCategoryId = category.id;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // Notes field with AI category suggestions
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            // AI Category Suggestions
            CategorySuggestionWidget(
              notesController: _notesController,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                  _selectedCategoryId = category;
                });
              },
            ),
            const SizedBox(height: 16),
            // Date picker
            TextFormField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a date';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Payment method dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedPaymentMethod,
              decoration: const InputDecoration(
                labelText: 'Payment Method',
                border: OutlineInputBorder(),
              ),
              items: allPaymentMethods
                  .map(
                    (method) =>
                        DropdownMenuItem(value: method, child: Text(method)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            // Recurring transaction toggle
            Row(
              children: [
                const Text(
                  'Recurring Transaction',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                Switch(
                  value: _isRecurring,
                  onChanged: (value) {
                    setState(() {
                      _isRecurring = value;
                    });
                  },
                ),
              ],
            ),
            if (_isRecurring) ...[
              const SizedBox(height: 16),
              // Recurrence frequency
              const Text(
                'Frequency',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _recurrenceFrequencies.map((freq) {
                  return ChoiceChip(
                    label: Text(freq['label']!),
                    selected: _recurrenceFrequency == freq['value'],
                    onSelected: (selected) {
                      setState(() {
                        _recurrenceFrequency = freq['value']!;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Interval selector
              Row(
                children: [
                  const Text('Repeat every:'),
                  const SizedBox(width: 8),
                  DropdownButton<int>(
                    value: _recurrenceInterval,
                    items: List.generate(30, (index) => index + 1)
                        .map(
                          (i) => DropdownMenuItem(value: i, child: Text('$i')),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _recurrenceInterval = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(_recurrenceFrequency),
                ],
              ),
              const SizedBox(height: 16),
              // End date selector
              Row(
                children: [
                  const Text('End date:'),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => _selectRecurrenceEndDate(context),
                    child: Text(
                      _recurrenceEndDate != null
                          ? _formatDate(_recurrenceEndDate!)
                          : 'Never',
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            // Submit button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: transactionState.isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: transactionState.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Add Transaction'),
              ),
            ),
            if (transactionState.errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  transactionState.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

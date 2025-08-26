import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/shared/widgets/transaction_card.dart';

class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _filterType;
  String? _filterCategory;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  List<Transaction> _filterTransactions(List<Transaction> transactions) {
    List<Transaction> filtered = transactions;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((transaction) {
        return transaction.notes.toLowerCase().contains(_searchQuery) ||
            transaction.category.toLowerCase().contains(_searchQuery) ||
            transaction.paymentMethod.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Apply type filter
    if (_filterType != null) {
      filtered = filtered.where((transaction) => transaction.type == _filterType).toList();
    }

    // Apply category filter
    if (_filterCategory != null) {
      filtered = filtered.where((transaction) => transaction.categoryId == _filterCategory).toList();
    }

    return filtered;
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter Transactions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text('Transaction Type'),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: '', label: Text('All')),
                      ButtonSegment(value: 'income', label: Text('Income')),
                      ButtonSegment(value: 'expense', label: Text('Expense')),
                    ],
                    selected: {_filterType ?? ''},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        _filterType = newSelection.first;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Categories'),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: '', label: Text('All Categories')),
                      ButtonSegment(value: '1', label: Text('Food & Dining')),
                      ButtonSegment(value: '2', label: Text('Salary')),
                      ButtonSegment(value: '3', label: Text('Transportation')),
                    ],
                    selected: {_filterCategory ?? ''},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        _filterCategory = newSelection.first;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionProvider);
    final filteredTransactions = _filterTransactions(transactionState.transactions);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterOptions(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search transactions...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          // Transaction list
          Expanded(
            child: transactionState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredTransactions.isEmpty
                    ? const Center(
                        child: Text('No transactions found'),
                      )
                    : ListView.builder(
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = filteredTransactions[index];
                          return TransactionCard(
                            title: transaction.notes.isNotEmpty
                                ? transaction.notes
                                : transaction.category,
                            category: transaction.category,
                            categoryColor: '#4ECDC4', // Default color for demo
                            amount: transaction.amount,
                            date: transaction.date,
                            transactionType: transaction.type,
                            onTap: () {
                              // Handle transaction tap
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
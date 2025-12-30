import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/shared/widgets/transaction_card.dart';

class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() =>
      _TransactionListScreenState();
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
        return transaction.title.toLowerCase().contains(_searchQuery) ||
            transaction.notes.toLowerCase().contains(_searchQuery) ||
            transaction.category.toLowerCase().contains(_searchQuery) ||
            transaction.paymentMethod.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Apply type filter
    if (_filterType != null) {
      filtered = filtered
          .where((transaction) => transaction.type == _filterType)
          .toList();
    }

    // Apply category filter
    if (_filterCategory != null) {
      filtered = filtered
          .where((transaction) => transaction.categoryId == _filterCategory)
          .toList();
    }

    return filtered;
  }

  void _editTransaction(Transaction transaction) {
    // Navigate to edit transaction screen
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return EditTransactionScreen(transaction: transaction);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  Future<void> _deleteTransaction(Transaction transaction) async {
    try {
      await ref.read(transactionProvider.notifier).deleteTransaction(transaction.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Transaction deleted'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting transaction: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showFilterOptions(BuildContext context) {
    final categoryState = ref.read(categoryProvider);
    final categories = categoryState.categories;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primarySurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Transactions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (_filterType != null || _filterCategory != null)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _filterType = null;
                              _filterCategory = null;
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Clear All',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Transaction Type Section
                  Text(
                    'Transaction Type',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildTypeChip(
                        label: 'All',
                        isSelected: _filterType == null || _filterType!.isEmpty,
                        onTap: () {
                          setState(() => _filterType = null);
                          setModalState(() {});
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildTypeChip(
                        label: 'Income',
                        isSelected: _filterType == 'income',
                        color: AppColors.success,
                        onTap: () {
                          setState(() => _filterType = 'income');
                          setModalState(() {});
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildTypeChip(
                        label: 'Expense',
                        isSelected: _filterType == 'expense',
                        color: AppColors.error,
                        onTap: () {
                          setState(() => _filterType = 'expense');
                          setModalState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Categories Section
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Horizontally scrollable category chips
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length + 1, // +1 for "All" option
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // "All" option
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _buildCategoryChip(
                              label: 'All',
                              colorCode: '#6366F1',
                              isSelected: _filterCategory == null || _filterCategory!.isEmpty,
                              onTap: () {
                                setState(() => _filterCategory = null);
                                setModalState(() {});
                              },
                            ),
                          );
                        }

                        final category = categories[index - 1];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildCategoryChip(
                            label: category.name,
                            colorCode: category.colorCode,
                            isSelected: _filterCategory == category.id,
                            onTap: () {
                              setState(() => _filterCategory = category.id);
                              setModalState(() {});
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Apply button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTypeChip({
    required String label,
    required bool isSelected,
    Color? color,
    required VoidCallback onTap,
  }) {
    final chipColor = color ?? AppColors.primaryAccent;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? chipColor.withValues(alpha: 0.2) : AppColors.primaryElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? chipColor : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? chipColor : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required String colorCode,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = _parseColor(colorCode);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : AppColors.primaryElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? color : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Color _parseColor(String colorCode) {
    try {
      if (colorCode.startsWith('#')) {
        return Color(int.parse(colorCode.substring(1), radix: 16) | 0xFF000000);
      }
      return Colors.grey;
    } catch (e) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionProvider);
    final filteredTransactions = _filterTransactions(
      transactionState.transactions,
    );

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
                ? const Center(child: Text('No transactions found'))
                : ListView.builder(
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = filteredTransactions[index];
                      final categoryState = ref.watch(categoryProvider);
                      final category = categoryState.categories.firstWhere(
                        (c) => c.id == transaction.categoryId,
                        orElse: () => categoryState.categories.isNotEmpty
                            ? categoryState.categories.first
                            : Category(
                                id: '',
                                name: 'Other',
                                colorCode: '#4ECDC4',
                                type: 'expense',
                                isDefault: false,
                              ),
                      );
                      // Determine display title: prefer title, then notes, then category
                      final displayTitle = transaction.title.isNotEmpty
                          ? transaction.title
                          : transaction.notes.isNotEmpty
                              ? transaction.notes
                              : transaction.category;
                      return TransactionCard(
                        id: transaction.id,
                        title: displayTitle,
                        category: transaction.category,
                        categoryColor: category.colorCode,
                        amount: transaction.amount,
                        date: transaction.date,
                        transactionType: transaction.type,
                        notes: transaction.notes,
                        onTap: () {
                          _editTransaction(transaction);
                        },
                        onEdit: () {
                          _editTransaction(transaction);
                        },
                        onDelete: () {
                          _deleteTransaction(transaction);
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

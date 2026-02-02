import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/shared/widgets/transaction_card.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';

class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _monthScrollController = ScrollController();
  String _searchQuery = '';
  String? _filterType;
  String? _filterCategory;
  late DateTime _selectedMonth;
  late List<DateTime> _availableMonths;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
    _availableMonths = _generateAvailableMonths();
    // Scroll to current month after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedMonth();
    });
  }

  List<DateTime> _generateAvailableMonths() {
    final now = DateTime.now();
    final months = <DateTime>[];
    // Generate 24 months in the past and 12 months in the future
    for (int i = -24; i <= 12; i++) {
      final month = DateTime(now.year, now.month + i);
      months.add(month);
    }
    return months;
  }

  void _scrollToSelectedMonth() {
    final index = _availableMonths.indexWhere(
      (m) => m.year == _selectedMonth.year && m.month == _selectedMonth.month,
    );
    if (index != -1 && _monthScrollController.hasClients) {
      // Fixed chip width (95) + horizontal padding (4*2) = 103
      const itemWidth = 103.0;
      const listPadding = 12.0;
      final screenWidth = MediaQuery.of(context).size.width;

      // Calculate offset to center the selected item
      final itemStart = listPadding + (index * itemWidth);
      final itemCenter = itemStart + (itemWidth / 2);
      final screenCenter = screenWidth / 2;
      final offset = itemCenter - screenCenter;

      _monthScrollController.animateTo(
        offset.clamp(0.0, _monthScrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _goToNextMonth() {
    final currentIndex = _availableMonths.indexWhere(
      (m) => m.year == _selectedMonth.year && m.month == _selectedMonth.month,
    );
    if (currentIndex < _availableMonths.length - 1) {
      setState(() {
        _selectedMonth = _availableMonths[currentIndex + 1];
      });
      _scrollToSelectedMonth();
    }
  }

  void _goToPreviousMonth() {
    final currentIndex = _availableMonths.indexWhere(
      (m) => m.year == _selectedMonth.year && m.month == _selectedMonth.month,
    );
    if (currentIndex > 0) {
      setState(() {
        _selectedMonth = _availableMonths[currentIndex - 1];
      });
      _scrollToSelectedMonth();
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _monthScrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  List<Transaction> _filterTransactions(List<Transaction> transactions) {
    List<Transaction> filtered = transactions;

    // Apply month filter
    filtered = filtered.where((transaction) {
      return transaction.date.year == _selectedMonth.year &&
          transaction.date.month == _selectedMonth.month;
    }).toList();

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

  Map<DateTime, List<Transaction>> _groupTransactionsByDate(
    List<Transaction> transactions,
  ) {
    final grouped = <DateTime, List<Transaction>>{};
    for (final transaction in transactions) {
      final dateOnly = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );
      grouped.putIfAbsent(dateOnly, () => []).add(transaction);
    }
    // Sort each group by time (newest first)
    for (final list in grouped.values) {
      list.sort((a, b) => b.date.compareTo(a.date));
    }
    return grouped;
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));

    final dateFormat = DateFormat('MMM d');
    final dayFormat = DateFormat('EEEE');

    if (date == today) {
      return 'Today, ${dateFormat.format(date)}';
    } else if (date == yesterday) {
      return 'Yesterday, ${dateFormat.format(date)}';
    } else if (date == tomorrow) {
      return 'Tomorrow, ${dateFormat.format(date)}';
    } else if (date.isAfter(today) && date.difference(today).inDays <= 7) {
      return '${dayFormat.format(date)}, ${dateFormat.format(date)}';
    } else if (date.isBefore(today) && today.difference(date).inDays < 7) {
      return '${dayFormat.format(date)}, ${dateFormat.format(date)}';
    } else {
      return '${dayFormat.format(date)}, ${dateFormat.format(date)}';
    }
  }

  Future<void> _editTransaction(Transaction transaction) async {
    // Get the database transaction for editing
    final dbTransaction = await ref
        .read(transactionProvider.notifier)
        .getDatabaseTransactionById(transaction.id);

    if (dbTransaction != null && mounted) {
      showAddTransactionScreen(
        context,
        existingTransaction: dbTransaction,
      );
    }
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

  Widget _buildMonthSelector() {
    final now = DateTime.now();

    return SizedBox(
      height: 44,
      child: ListView.builder(
        controller: _monthScrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        itemCount: _availableMonths.length,
        itemBuilder: (context, index) {
          final month = _availableMonths[index];
          final isSelected = month.year == _selectedMonth.year &&
              month.month == _selectedMonth.month;
          final isCurrentMonth =
              month.year == now.year && month.month == now.month;
          final isFutureMonth = month.isAfter(DateTime(now.year, now.month));

          final chipColor = isSelected
              ? AppColors.primaryAccent
              : isCurrentMonth
                  ? AppColors.primaryAccent
                  : isFutureMonth
                      ? AppColors.success
                      : AppColors.textSecondary;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMonth = month;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 95,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            AppColors.primaryAccent,
                            AppColors.primaryAccent.withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : AppColors.primaryElevated,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryAccent
                        : isCurrentMonth
                            ? AppColors.primaryAccent
                            : isFutureMonth
                                ? AppColors.success.withValues(alpha: 0.4)
                                : AppColors.divider,
                    width: isSelected || isCurrentMonth ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primaryAccent.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    DateFormat('MMM yyyy').format(month),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? Colors.white : chipColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isFuture = date.isAfter(today);
    final headerColor = isFuture ? AppColors.success : AppColors.primaryAccent;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: headerColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isFuture) ...[
                  Icon(
                    Icons.schedule,
                    size: 14,
                    color: headerColor,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  _formatDateHeader(date),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: headerColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              color: AppColors.divider,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final now = DateTime.now();
    final isFutureMonth = _selectedMonth.isAfter(DateTime(now.year, now.month));
    final isCurrentMonth =
        _selectedMonth.year == now.year && _selectedMonth.month == now.month;

    IconData icon;
    String title;
    String subtitle;

    if (isFutureMonth) {
      icon = Icons.event_available_outlined;
      title = 'No planned transactions';
      subtitle = 'Add future payments for ${DateFormat('MMMM yyyy').format(_selectedMonth)}';
    } else if (isCurrentMonth) {
      icon = Icons.receipt_long_outlined;
      title = 'No transactions yet';
      subtitle = 'Start tracking your expenses this month';
    } else {
      icon = Icons.history_outlined;
      title = 'No transactions found';
      subtitle = 'No records for ${DateFormat('MMMM yyyy').format(_selectedMonth)}';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: (isFutureMonth ? AppColors.success : AppColors.primaryAccent)
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 48,
              color: isFutureMonth ? AppColors.success : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionProvider);
    final filteredTransactions = _filterTransactions(
      transactionState.transactions,
    );
    final groupedTransactions = _groupTransactionsByDate(filteredTransactions);
    final sortedDates = groupedTransactions.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // Newest first

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
          // Month selector
          _buildMonthSelector(),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
          // Transaction list grouped by date
          Expanded(
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                // Swipe right to left = go to next month
                // Swipe left to right = go to previous month
                if (details.primaryVelocity != null) {
                  if (details.primaryVelocity! < -200) {
                    // Swipe left (next month)
                    _goToNextMonth();
                  } else if (details.primaryVelocity! > 200) {
                    // Swipe right (previous month)
                    _goToPreviousMonth();
                  }
                }
              },
              child: transactionState.isLoading
                  ? const SingleChildScrollView(
                      child: ShimmerTransactionList(itemCount: 8),
                    )
                  : filteredTransactions.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                        itemCount: sortedDates.length,
                        itemBuilder: (context, dateIndex) {
                          final date = sortedDates[dateIndex];
                          final dayTransactions = groupedTransactions[date]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Date header
                              _buildDateHeader(date),
                              // Transactions for this date
                              ...dayTransactions.map((transaction) {
                                final categoryState = ref.watch(categoryProvider);
                                final category =
                                    categoryState.categories.firstWhere(
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
                                  categoryIcon: category.iconName,
                                  amount: transaction.amount,
                                  transactionType: transaction.type,
                                  walletId: transaction.walletId,
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
                              }),
                            ],
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

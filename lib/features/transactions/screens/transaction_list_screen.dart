import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/features/transactions/widgets/month_strip.dart';
import 'package:the_accountant/shared/widgets/neo_button.dart';
import 'package:the_accountant/shared/widgets/transaction_card.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';

class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key, this.standalone = false});

  /// Whether this screen is pushed as its own route rather than shown inside
  /// the tab shell.
  ///
  /// The shell already puts the screen's name in the header, so an embedded
  /// copy carries no bar of its own — two bars a few pixels apart both saying
  /// "Transactions" is the sort of thing you stop noticing after a week and
  /// never stop noticing in a screenshot.
  final bool standalone;

  @override
  ConsumerState<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _monthScrollController = ScrollController();
  late PageController _pageController;

  String _searchQuery = '';
  String? _filterType;
  String? _filterCategory;

  late List<DateTime> _availableMonths;
  late int _currentPageIndex;
  bool _isExpandingMonths = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _initializeMonths();
  }

  void _initializeMonths() {
    final now = DateTime.now();
    _availableMonths = _generateInitialMonths();

    // Find the index of the current month
    _currentPageIndex = _availableMonths.indexWhere(
      (m) => m.year == now.year && m.month == now.month,
    );
    if (_currentPageIndex == -1) _currentPageIndex = 0;

    _pageController = PageController(initialPage: _currentPageIndex);

    // Scroll to current month chip after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToMonth(_currentPageIndex);
    });
  }

  List<DateTime> _generateInitialMonths() {
    final now = DateTime.now();
    final months = <DateTime>[];

    // Generate from Jan of previous year to Dec of next year
    final startYear = now.year - 1;
    final endYear = now.year + 1;

    for (int year = startYear; year <= endYear; year++) {
      for (int month = 1; month <= 12; month++) {
        months.add(DateTime(year, month));
      }
    }

    return months;
  }

  void _expandMonthsIfNeeded(int pageIndex) {
    if (_isExpandingMonths) return;

    // Expand backwards if within 3 months of the start
    if (pageIndex <= 2) {
      _expandMonthsBackward();
    }

    // Expand forward if within 3 months of the end
    if (pageIndex >= _availableMonths.length - 3) {
      _expandMonthsForward();
    }
  }

  void _expandMonthsBackward() {
    _isExpandingMonths = true;

    final firstMonth = _availableMonths.first;
    final newMonths = <DateTime>[];

    // Add 12 more months before the first month
    for (int i = 12; i >= 1; i--) {
      final newMonth = DateTime(firstMonth.year, firstMonth.month - i);
      newMonths.add(newMonth);
    }

    setState(() {
      _availableMonths = [...newMonths, ..._availableMonths];
      // Adjust page index to account for new months
      _currentPageIndex += 12;
      // Jump to the adjusted page without animation
      _pageController.jumpToPage(_currentPageIndex);
    });

    _isExpandingMonths = false;
  }

  void _expandMonthsForward() {
    _isExpandingMonths = true;

    final lastMonth = _availableMonths.last;
    final newMonths = <DateTime>[];

    // Add 12 more months after the last month
    for (int i = 1; i <= 12; i++) {
      final newMonth = DateTime(lastMonth.year, lastMonth.month + i);
      newMonths.add(newMonth);
    }

    setState(() {
      _availableMonths = [..._availableMonths, ...newMonths];
    });

    _isExpandingMonths = false;
  }

  void _scrollToMonth(int index) {
    if (!_monthScrollController.hasClients) return;

    final offset = MonthStrip.centeringOffset(
      index,
      MediaQuery.of(context).size.width,
    );

    _monthScrollController.animateTo(
      offset.clamp(0.0, _monthScrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _onPageChanged(int index) {
    if (_isExpandingMonths) return;

    setState(() {
      _currentPageIndex = index;
    });

    _scrollToMonth(index);
    _expandMonthsIfNeeded(index);
    HapticFeedback.selectionClick();
  }

  void _onMonthChipTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _monthScrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  List<Transaction> _filterTransactionsForMonth(
    List<Transaction> transactions,
    DateTime month,
  ) {
    List<Transaction> filtered = transactions;

    // Apply month filter
    filtered = filtered.where((transaction) {
      return transaction.date.year == month.year &&
          transaction.date.month == month.month;
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

    final df = ref.watch(dateFormatSettingProvider);
    final shortDate = AppDateFormatter.formatShortDate(date, df);
    final dayFormat = DateFormat('EEEE');

    if (date == today) {
      return 'Today, $shortDate';
    } else if (date == yesterday) {
      return 'Yesterday, $shortDate';
    } else if (date == tomorrow) {
      return 'Tomorrow, $shortDate';
    } else if (date.isAfter(today) && date.difference(today).inDays <= 7) {
      return '${dayFormat.format(date)}, $shortDate';
    } else if (date.isBefore(today) && today.difference(date).inDays < 7) {
      return '${dayFormat.format(date)}, $shortDate';
    } else {
      return '${dayFormat.format(date)}, $shortDate';
    }
  }

  Future<void> _editTransaction(Transaction transaction) async {
    // Get the database transaction for editing
    final dbTransaction = await ref
        .read(transactionProvider.notifier)
        .getDatabaseTransactionById(transaction.id);

    if (dbTransaction != null && mounted) {
      // Transfers open in the editor's transfer mode and save through the
      // paired update, so both legs change together. No guard is needed here
      // any more: the generic single-row edit path itself now delegates to the
      // paired operation for transfer rows.
      showAddTransactionScreen(context, existingTransaction: dbTransaction);
    }
  }

  Future<void> _deleteTransaction(Transaction transaction) async {
    try {
      await ref
          .read(transactionProvider.notifier)
          .deleteTransaction(transaction.id);
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
                              isSelected:
                                  _filterCategory == null ||
                                  _filterCategory!.isEmpty,
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
          color: isSelected
              ? chipColor.withValues(alpha: 0.2)
              : AppColors.primaryElevated,
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
          color: isSelected
              ? color.withValues(alpha: 0.2)
              : AppColors.primaryElevated,
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

  Widget _buildEmptyState(DateTime month) {
    final now = DateTime.now();
    final isFutureMonth = month.isAfter(DateTime(now.year, now.month));
    final isCurrentMonth = month.year == now.year && month.month == now.month;

    IconData icon;
    String title;
    String subtitle;

    if (isFutureMonth) {
      icon = Icons.event_available_outlined;
      title = 'No planned transactions';
      subtitle =
          'Add future payments for ${DateFormat('MMMM yyyy').format(month)}';
    } else if (isCurrentMonth) {
      icon = Icons.receipt_long_outlined;
      title = 'No transactions yet';
      subtitle = 'Start tracking your expenses this month';
    } else {
      icon = Icons.history_outlined;
      title = 'No transactions found';
      subtitle = 'No records for ${DateFormat('MMMM yyyy').format(month)}';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color:
                  (isFutureMonth ? AppColors.success : AppColors.primaryAccent)
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
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMonthPage(
    DateTime month,
    List<Transaction> allTransactions,
    bool isLoading,
  ) {
    final filteredTransactions = _filterTransactionsForMonth(
      allTransactions,
      month,
    );
    final groupedTransactions = _groupTransactionsByDate(filteredTransactions);
    final sortedDates = groupedTransactions.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // Newest first

    if (isLoading) {
      return const SingleChildScrollView(
        child: ShimmerTransactionList(itemCount: 8),
      );
    }

    if (filteredTransactions.isEmpty) {
      return _buildEmptyState(month);
    }

    return ListView.builder(
      // Room at the bottom for the floating add button, which otherwise sits
      // on top of the last row and hides its amount — the one part of a
      // transaction you cannot guess from the rest of it.
      padding: const EdgeInsets.only(bottom: AppSpacing.huge + AppSpacing.xxl),
      itemCount: sortedDates.length,
      itemBuilder: (context, dateIndex) {
        final date = sortedDates[dateIndex];
        final dayTransactions = groupedTransactions[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            TransactionDateHeader(date: date, label: _formatDateHeader(date)),
            // Transactions for this date
            ...dayTransactions.map((transaction) {
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
                amount:
                    transaction.amount / 100.0, // cents -> major-unit dollars
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionProvider);

    return Scaffold(
      // Transparent, so the app-wide background painted in `MaterialApp.builder`
      // shows through here the same way it does on every other screen.
      backgroundColor: Colors.transparent,
      appBar: widget.standalone
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('Transactions', style: AppTypography.titleLarge),
            )
          : null,
      body: Column(
        children: [
          MonthStrip(
            months: _availableMonths,
            selectedIndex: _currentPageIndex,
            onSelected: _onMonthChipTapped,
            controller: _monthScrollController,
          ),
          _buildSearchRow(),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _availableMonths.length,
              itemBuilder: (context, index) {
                final month = _availableMonths[index];
                return _buildMonthPage(
                  month,
                  transactionState.transactions,
                  transactionState.isLoading,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Search and filtering, side by side.
  ///
  /// Filtering used to live in the app bar this screen no longer has, and it
  /// belongs next to search anyway — both narrow the same list.
  Widget _buildSearchRow() {
    final hasFilters = _filterType != null || _filterCategory != null;

    return TransactionSearchField(
      controller: _searchController,
      query: _searchQuery,
      onCleared: () {
        _searchController.clear();
        setState(() => _searchQuery = '');
      },
      trailing: NeoIconButton(
        icon: Icons.tune,
        tooltip: 'Filter',
        size: AppSpacing.inputHeight,
        onPressed: () => _showFilterOptions(context),
        // Coloured only while something is actually filtered out, so the
        // control says the list is not showing everything.
        iconColor: hasFilters
            ? AppColors.primaryAccent
            : AppColors.textSecondary,
      ),
    );
  }
}

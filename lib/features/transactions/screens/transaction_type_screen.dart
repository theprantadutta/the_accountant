import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/features/transactions/widgets/month_strip.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/core/utils/number_formatter.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/shared/widgets/glass_card.dart';
import 'package:the_accountant/shared/widgets/transaction_card.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';

class TransactionTypeScreen extends ConsumerStatefulWidget {
  final String transactionType; // 'income' or 'expense'

  const TransactionTypeScreen({super.key, required this.transactionType});

  @override
  ConsumerState<TransactionTypeScreen> createState() =>
      _TransactionTypeScreenState();
}

class _TransactionTypeScreenState extends ConsumerState<TransactionTypeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _monthScrollController = ScrollController();
  late PageController _pageController;

  String _searchQuery = '';
  String? _filterCategory;

  late List<DateTime> _availableMonths;
  late int _currentPageIndex;
  bool _isExpandingMonths = false;

  // Type-derived config
  String get _title =>
      widget.transactionType == 'income' ? 'Income' : 'Expenses';

  Color get _accentColor =>
      widget.transactionType == 'income' ? AppColors.success : AppColors.error;

  IconData get _icon => widget.transactionType == 'income'
      ? Icons.trending_up_rounded
      : Icons.trending_down_rounded;

  GlassCardVariant get _glassVariant => widget.transactionType == 'income'
      ? GlassCardVariant.success
      : GlassCardVariant.error;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _initializeMonths();
  }

  void _initializeMonths() {
    final now = DateTime.now();
    _availableMonths = _generateInitialMonths();

    _currentPageIndex = _availableMonths.indexWhere(
      (m) => m.year == now.year && m.month == now.month,
    );
    if (_currentPageIndex == -1) _currentPageIndex = 0;

    _pageController = PageController(initialPage: _currentPageIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToMonth(_currentPageIndex);
    });
  }

  List<DateTime> _generateInitialMonths() {
    final now = DateTime.now();
    final months = <DateTime>[];
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
    if (pageIndex <= 2) _expandMonthsBackward();
    if (pageIndex >= _availableMonths.length - 3) _expandMonthsForward();
  }

  void _expandMonthsBackward() {
    _isExpandingMonths = true;
    final firstMonth = _availableMonths.first;
    final newMonths = <DateTime>[];

    for (int i = 12; i >= 1; i--) {
      newMonths.add(DateTime(firstMonth.year, firstMonth.month - i));
    }

    setState(() {
      _availableMonths = [...newMonths, ..._availableMonths];
      _currentPageIndex += 12;
      _pageController.jumpToPage(_currentPageIndex);
    });
    _isExpandingMonths = false;
  }

  void _expandMonthsForward() {
    _isExpandingMonths = true;
    final lastMonth = _availableMonths.last;
    final newMonths = <DateTime>[];

    for (int i = 1; i <= 12; i++) {
      newMonths.add(DateTime(lastMonth.year, lastMonth.month + i));
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
    // Pre-filter by transaction type
    List<Transaction> filtered = transactions
        .where((t) => t.type == widget.transactionType)
        .toList();

    // Apply month filter
    filtered = filtered.where((t) {
      return t.date.year == month.year && t.date.month == month.month;
    }).toList();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((t) {
        return t.title.toLowerCase().contains(_searchQuery) ||
            t.notes.toLowerCase().contains(_searchQuery) ||
            t.category.toLowerCase().contains(_searchQuery) ||
            t.paymentMethod.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Apply category filter
    if (_filterCategory != null) {
      filtered = filtered
          .where((t) => t.categoryId == _filterCategory)
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
    } else {
      return '${dayFormat.format(date)}, $shortDate';
    }
  }

  Future<void> _editTransaction(Transaction transaction) async {
    final dbTransaction = await ref
        .read(transactionProvider.notifier)
        .getDatabaseTransactionById(transaction.id);

    if (dbTransaction != null && mounted) {
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
    // Only show categories matching this transaction type
    final categories = categoryState.categories
        .where((c) => c.type == widget.transactionType)
        .toList();

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
                        'Filter $_title',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (_filterCategory != null)
                        TextButton(
                          onPressed: () {
                            setState(() {
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

                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _buildCategoryChip(
                              label: 'All',
                              colorCode: '#6366F1',
                              isSelected: _filterCategory == null,
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
                        backgroundColor: _accentColor,
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

  Widget _buildSummaryCard(List<Transaction> allTransactions) {
    final month = _availableMonths[_currentPageIndex];
    final monthTransactions = allTransactions
        .where(
          (t) =>
              t.type == widget.transactionType &&
              t.date.year == month.year &&
              t.date.month == month.month,
        )
        .toList();

    final total = monthTransactions.fold<double>(
      0,
      (sum, t) => sum + t.amount / 100.0,
    );
    final count = monthTransactions.length;
    final average = count > 0 ? total / count : 0.0;

    final displayCurrency = ref.watch(defaultCurrencyProvider);
    final useDecimals = ref.watch(defaultDecimalProvider);
    final currencySymbol = CurrencyInfo.getSymbol(displayCurrency);
    final nf = ref.watch(numberFormatSettingProvider);
    final formatter = AppNumberFormatter.get(nf, useDecimals: useDecimals);

    final typeLabel = widget.transactionType == 'income'
        ? 'Monthly Income'
        : 'Monthly Expenses';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassCard(
        variant: _glassVariant,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_icon, color: _accentColor, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  typeLabel,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '$currencySymbol${formatter.format(useDecimals ? total : total.round())}',
              style: AppTypography.displaySmall.copyWith(
                color: _accentColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatItem(
                  '$count',
                  count == 1 ? 'transaction' : 'transactions',
                ),
                Container(
                  width: 1,
                  height: 24,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  color: AppColors.divider,
                ),
                _buildStatItem(
                  '$currencySymbol${formatter.format(useDecimals ? average : average.round())}',
                  'avg per transaction',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildEmptyState(DateTime month) {
    final now = DateTime.now();
    final isFutureMonth = month.isAfter(DateTime(now.year, now.month));
    final isCurrentMonth = month.year == now.year && month.month == now.month;

    final typeName = widget.transactionType == 'income' ? 'income' : 'expenses';

    IconData icon;
    String title;
    String subtitle;

    if (isFutureMonth) {
      icon = Icons.event_available_outlined;
      title = 'No planned $typeName';
      subtitle =
          'Add future $typeName for ${DateFormat('MMMM yyyy').format(month)}';
    } else if (isCurrentMonth) {
      icon = widget.transactionType == 'income'
          ? Icons.trending_up_rounded
          : Icons.receipt_long_outlined;
      title = 'No $typeName yet this month';
      subtitle = widget.transactionType == 'income'
          ? 'Start tracking your income this month'
          : 'Start tracking your expenses this month';
    } else {
      icon = Icons.history_outlined;
      title = 'No $typeName in ${DateFormat('MMMM').format(month)}';
      subtitle = 'No records for ${DateFormat('MMMM yyyy').format(month)}';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _accentColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: _accentColor),
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
      ..sort((a, b) => b.compareTo(a));

    if (isLoading) {
      return const SingleChildScrollView(
        child: ShimmerTransactionList(itemCount: 8),
      );
    }

    if (filteredTransactions.isEmpty) {
      return _buildEmptyState(month);
    }

    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (context, dateIndex) {
        final date = sortedDates[dateIndex];
        final dayTransactions = groupedTransactions[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TransactionDateHeader(date: date, label: _formatDateHeader(date)),
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
                onTap: () => _editTransaction(transaction),
                onEdit: () => _editTransaction(transaction),
                onDelete: () => _deleteTransaction(transaction),
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

    return Container(
      decoration: const BoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(_title, style: AppTypography.titleMedium),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.filter_list,
                color: _filterCategory != null
                    ? _accentColor
                    : AppColors.textPrimary,
              ),
              onPressed: () => _showFilterOptions(context),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await ref.read(transactionProvider.notifier).loadTransactions();
          },
          color: _accentColor,
          backgroundColor: AppColors.primarySurface,
          child: Column(
            children: [
              // Summary card
              _buildSummaryCard(transactionState.transactions),

              MonthStrip(
                months: _availableMonths,
                selectedIndex: _currentPageIndex,
                onSelected: _onMonthChipTapped,
                controller: _monthScrollController,
              ),

              TransactionSearchField(
                controller: _searchController,
                query: _searchQuery,
                hint: widget.transactionType == 'income'
                    ? 'Search income'
                    : 'Search expenses',
                onCleared: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
              ),

              // Transaction pages
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
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/features/transactions/screens/transaction_detail_screen.dart';
import 'package:the_accountant/features/transactions/widgets/category_picker_sheet.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/settings/widgets/confirmation_dialog.dart';
import 'package:the_accountant/features/transactions/widgets/transaction_filter_sheet.dart';
import 'package:the_accountant/features/transactions/domain/transaction_filters.dart';
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

  /// Everything the list is narrowed by. Replaces a direction and one category,
  /// which was about a tenth of what someone hunting a payment needs.
  TransactionFilters _filters = TransactionFilters.none;

  /// Rows the user has picked out. Empty means not in selection mode at all,
  /// so there is no separate flag to keep in step with it.
  final Set<String> _selected = {};

  bool get _selecting => _selected.isNotEmpty;

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
      _filters = _filters.copyWith(query: _searchQuery);
    });
  }

  List<Transaction> _filterTransactionsForMonth(
    List<Transaction> transactions,
    DateTime month,
  ) {
    final categories = ref.read(categoryProvider).categories;
    // Choosing a parent category means the things filed inside it too, so the
    // filter needs to know which categories sit under which.
    Set<String> familyOf(String id) => {
      id,
      for (final c in categories)
        if (c.mainCategoryId == id) c.id,
    };

    return transactions.where((t) {
      if (t.date.year != month.year || t.date.month != month.month) {
        return false;
      }
      return _filters.matches(t, familyOf: familyOf);
    }).toList();
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

  void _toggleSelected(String id) {
    setState(() {
      if (!_selected.remove(id)) _selected.add(id);
    });
  }

  void _clearSelection() => setState(_selected.clear);

  /// Run a bulk action, then report what actually happened.
  ///
  /// The count comes back from the operation rather than from the selection,
  /// because some rows are deliberately skipped — a transfer leg that must not
  /// change account, a row that was already paid — and claiming to have
  /// changed them would be a lie the user could not see through.
  Future<void> _runBulk(
    Future<int> Function() action,
    String Function(int count) describe,
  ) async {
    final count = await action();
    if (!mounted) return;
    _clearSelection();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(describe(count))));
  }

  Future<void> _bulkDelete() async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: L10n.of(context).txDeleteManyTitle(_selected.length),
      message: L10n.of(context).txDeleteManyBody,
      confirmText: L10n.of(context).actionDelete,
      isDangerous: true,
    );
    if (confirmed != true) return;
    final ids = _selected.toList();
    await _runBulk(
      () => ref.read(transactionProvider.notifier).deleteMany(ids),
      (n) => n == 1 ? '1 transaction deleted' : '$n transactions deleted',
    );
  }

  Future<void> _bulkCategory() async {
    final category = await showCategoryPickerSheet(context: context, ref: ref);
    if (category == null) return;
    final ids = _selected.toList();
    await _runBulk(
      () => ref
          .read(transactionProvider.notifier)
          .setCategoryForMany(ids, category.id),
      (n) => 'Moved $n to ${category.name}',
    );
  }

  Future<void> _bulkWallet() async {
    final wallets = ref.read(walletProvider).wallets;
    if (wallets.isEmpty) return;

    final chosen = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(L10n.of(context).txMoveToAccount),
        children: [
          for (final w in wallets)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, w.id),
              child: Text(w.name),
            ),
        ],
      ),
    );
    if (chosen == null) return;

    final ids = _selected.toList();
    await _runBulk(
      () =>
          ref.read(transactionProvider.notifier).setWalletForMany(ids, chosen),
      (n) => n < ids.length
          ? 'Moved $n; transfers were left where they are'
          : 'Moved $n to another account',
    );
  }

  Future<void> _bulkDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (picked == null) return;
    final ids = _selected.toList();
    await _runBulk(
      () => ref.read(transactionProvider.notifier).setDateForMany(ids, picked),
      (n) => 'Re-dated $n',
    );
  }

  Future<void> _bulkMarkPaid() async {
    final ids = _selected.toList();
    await _runBulk(
      () => ref.read(transactionProvider.notifier).markManyPaid(ids),
      (n) => n == 0 ? 'Nothing was waiting to be paid' : 'Marked $n as paid',
    );
  }

  Future<void> _bulkDuplicate() async {
    final ids = _selected.toList();
    await _runBulk(
      () => ref.read(transactionProvider.notifier).duplicateMany(ids),
      (n) => n < ids.length
          ? 'Copied $n; transfers cannot be copied on their own'
          : 'Copied $n',
    );
  }

  Future<void> _openTransaction(Transaction transaction) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TransactionDetailScreen(transactionId: transaction.id),
      ),
    );
    if (mounted) {
      await ref
          .read(transactionProvider.notifier)
          .loadTransactions(silent: true);
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
            content: Text(L10n.of(context).txDeleted),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(L10n.of(context).txDeleteFailed('$e')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _showFilterOptions(BuildContext context) async {
    final updated = await showTransactionFilterSheet(
      context: context,
      current: _filters,
    );
    if (updated != null) setState(() => _filters = updated);
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
                selected: _selected.contains(transaction.id),
                onTap: () {
                  if (_selecting) {
                    _toggleSelected(transaction.id);
                  } else {
                    // Opens the row rather than the editor: there was nowhere
                    // to simply look at a transaction without being one stray
                    // keystroke away from changing it.
                    _openTransaction(transaction);
                  }
                },
                onLongPress: () => _toggleSelected(transaction.id),
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

    return PopScope(
      // Back should put the selection down before it leaves the screen: losing
      // a dozen deliberately picked rows to a stray gesture is the kind of
      // thing people do not forgive.
      canPop: !_selecting,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _selecting) _clearSelection();
      },
      child: Scaffold(
        // Transparent, so the app-wide background painted in `MaterialApp.builder`
        // shows through here the same way it does on every other screen.
        backgroundColor: Colors.transparent,
        appBar: widget.standalone
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  L10n.of(context).navTransactions,
                  style: AppTypography.titleLarge,
                ),
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
            // While rows are picked out, the actions replace search rather than
            // sitting beside it: narrowing the list mid-selection would quietly
            // change what "all of these" means.
            if (_selecting) _buildSelectionBar() else _buildSearchRow(),
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
    );
  }

  /// What can be done to the rows that are picked out.
  ///
  /// Named by what they do to the selection rather than by icon alone: "move
  /// account" and "re-date" are not guessable from a picture, and a bulk action
  /// applied by mistake is expensive to undo by hand.
  Widget _buildSelectionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: AppColors.primaryAccent.withValues(alpha: 0.12),
      child: Row(
        children: [
          IconButton(
            tooltip: L10n.of(context).actionCancel,
            icon: const Icon(Icons.close),
            onPressed: _clearSelection,
          ),
          Text(
            L10n.of(context).txSelectedCount(_selected.length),
            style: AppTypography.titleSmall,
          ),
          const Spacer(),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz),
            tooltip: L10n.of(context).txActions,
            onSelected: (value) {
              switch (value) {
                case 'category':
                  _bulkCategory();
                case 'wallet':
                  _bulkWallet();
                case 'date':
                  _bulkDate();
                case 'paid':
                  _bulkMarkPaid();
                case 'duplicate':
                  _bulkDuplicate();
                case 'delete':
                  _bulkDelete();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'category',
                child: ListTile(
                  leading: Icon(Icons.category_outlined),
                  title: Text(L10n.of(context).txChangeCategory),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'wallet',
                child: ListTile(
                  leading: Icon(Icons.account_balance_wallet_outlined),
                  title: Text(L10n.of(context).txMoveToAccount),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'date',
                child: ListTile(
                  leading: Icon(Icons.event_outlined),
                  title: Text(L10n.of(context).txChangeDate),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'paid',
                child: ListTile(
                  leading: Icon(Icons.check_circle_outline),
                  title: Text(L10n.of(context).txMarkAsPaid),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'duplicate',
                child: ListTile(
                  leading: Icon(Icons.copy_outlined),
                  title: Text(L10n.of(context).txDuplicate),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete_outline, color: AppColors.error),
                  title: Text(
                    L10n.of(context).actionDelete,
                    style: TextStyle(color: AppColors.error),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
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
    final hasFilters = _filters.hasActiveFilters;

    return TransactionSearchField(
      controller: _searchController,
      query: _searchQuery,
      onCleared: () {
        _searchController.clear();
        setState(() {
          _searchQuery = '';
          _filters = _filters.copyWith(query: '');
        });
      },
      trailing: NeoIconButton(
        icon: Icons.tune,
        tooltip: L10n.of(context).filterTitle,
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/transactions/domain/transaction_filters.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/features/transactions/screens/transaction_detail_screen.dart';
import 'package:the_accountant/features/transactions/widgets/category_picker_sheet.dart';
import 'package:the_accountant/features/transactions/widgets/month_strip.dart';
import 'package:the_accountant/features/transactions/widgets/transaction_filter_sheet.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';
import 'package:the_accountant/shared/widgets/transaction_card.dart';

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

  /// A search looks through every month. Someone looking for one payment
  /// rarely knows which month it fell in, and finding it should not mean
  /// paging back through the year.
  bool get _searching => _searchQuery.trim().isNotEmpty;

  /// The rows shown for [month], or for every month when it is null.
  List<Transaction> _filterTransactionsForMonth(
    List<Transaction> transactions,
    DateTime? month,
  ) {
    final categories = ref.read(categoryProvider).categories;
    // Choosing a parent category means the things filed inside it too, so the
    // filter needs to know which categories sit under which.
    Set<String> familyOf(String id) => {
      id,
      for (final c in categories)
        if (c.mainCategoryId == id) c.id,
    };

    return collapseTransferLegs(
      transactions.where((t) {
        if (month != null &&
            (t.date.year != month.year || t.date.month != month.month)) {
          return false;
        }
        return _filters.matches(t, familyOf: familyOf);
      }).toList(),
    );
  }

  /// "SCB Credit → Cash" for a transfer, read from its two legs.
  ///
  /// The list shows a transfer once, so the row has to say where the money
  /// went as well as where it came from; "Transfer" alone did neither.
  String _transferRoute(Transaction leg) {
    final wallets = ref.watch(walletProvider).wallets;
    String nameOf(String? id) =>
        wallets.where((w) => w.id == id).firstOrNull?.name ?? '?';
    final partner = leg.pairedTransactionId == null
        ? null
        : ref
              .read(transactionProvider)
              .transactions
              .where((t) => t.id == leg.pairedTransactionId)
              .firstOrNull;
    if (partner == null) return L10n.of(context).txTransfer;
    final outgoing = leg.type == 'expense' ? leg : partner;
    final incoming = leg.type == 'expense' ? partner : leg;
    return '${nameOf(outgoing.walletId)} → ${nameOf(incoming.walletId)}';
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

  /// "Today · Tue 11", "Yesterday · Mon 10", "Wed 5". With [withMonth], as
  /// in search results that span months, "Wed 5 Mar" or "Wed 5 Mar 2025".
  String _formatDateHeader(DateTime date, {bool withMonth = false}) {
    final l10n = L10n.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final pattern = !withMonth
        ? 'EEE d'
        : date.year == now.year
        ? 'EEE d MMM'
        : 'EEE d MMM yyyy';
    final day = DateFormat(
      pattern,
      Localizations.localeOf(context).toString(),
    ).format(date);
    final diff = date.difference(today).inDays;
    return switch (diff) {
      0 => '${l10n.activityToday} · $day',
      -1 => '${l10n.activityYesterday} · $day',
      1 => '${l10n.activityTomorrow} · $day',
      _ => day,
    };
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
    showSunriseSnack(context, describe(count), tone: SnackTone.success);
  }

  Future<void> _bulkDelete() async {
    final confirmed = await showSunriseConfirm(
      context: context,
      title: L10n.of(context).txDeleteManyTitle(_selected.length),
      message: L10n.of(context).txDeleteManyBody,
      confirmLabel: L10n.of(context).actionDelete,
      destructive: true,
      icon: Symbols.delete_rounded,
    );
    if (!confirmed || !mounted) return;
    final l10n = L10n.of(context);
    final ids = _selected.toList();
    await _runBulk(
      () => ref.read(transactionProvider.notifier).deleteMany(ids),
      l10n.activityDeletedCount,
    );
  }

  Future<void> _bulkCategory() async {
    final category = await showCategoryPickerSheet(context: context, ref: ref);
    if (category == null || !mounted) return;
    final l10n = L10n.of(context);
    final ids = _selected.toList();
    await _runBulk(
      () => ref
          .read(transactionProvider.notifier)
          .setCategoryForMany(ids, category.id),
      (n) => l10n.activityMovedToCategory(n, category.name),
    );
  }

  Future<void> _bulkWallet() async {
    final ids = _selected.toList();
    // Only accounts in the currency these rows are already held in. An amount
    // is a number of minor units of its account's currency, so offering a taka
    // account for a dollar expense reinterprets the figure rather than
    // converting it.
    final targets = await ref
        .read(transactionProvider.notifier)
        .accountsForMoving(ids);
    if (!mounted) return;

    if (targets.spansCurrencies) {
      showSunriseSnack(
        context,
        L10n.of(context).activityMixedCurrencies,
        tone: SnackTone.error,
      );
      return;
    }
    if (targets.wallets.isEmpty) return;

    final chosen = await showSunriseSheet<String>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: L10n.of(context).txMoveToAccount,
        child: Column(
          children: [
            for (final w in targets.wallets)
              SheetAction(
                icon: Symbols.account_balance_wallet_rounded,
                label: w.name,
                onTap: () => Navigator.pop(sheet, w.id),
              ),
          ],
        ),
      ),
    );
    if (chosen == null || !mounted) return;
    final l10n = L10n.of(context);

    await _runBulk(
      () =>
          ref.read(transactionProvider.notifier).setWalletForMany(ids, chosen),
      (n) =>
          n < ids.length ? l10n.activityMovedPartial(n) : l10n.activityMoved(n),
    );
  }

  Future<void> _bulkDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (picked == null || !mounted) return;
    final l10n = L10n.of(context);
    final ids = _selected.toList();
    await _runBulk(
      () => ref.read(transactionProvider.notifier).setDateForMany(ids, picked),
      l10n.activityRedated,
    );
  }

  Future<void> _bulkMarkPaid() async {
    final l10n = L10n.of(context);
    final ids = _selected.toList();
    await _runBulk(
      () => ref.read(transactionProvider.notifier).markManyPaid(ids),
      (n) => n == 0 ? l10n.activityNothingToPay : l10n.activityMarkedPaid(n),
    );
  }

  Future<void> _bulkDuplicate() async {
    final l10n = L10n.of(context);
    final ids = _selected.toList();
    await _runBulk(
      () => ref.read(transactionProvider.notifier).duplicateMany(ids),
      (n) => n < ids.length
          ? l10n.activityCopiedPartial(n)
          : l10n.activityCopied(n),
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
        showSunriseSnack(
          context,
          L10n.of(context).txDeleted,
          tone: SnackTone.success,
        );
      }
    } catch (e) {
      if (mounted) {
        showSunriseSnack(
          context,
          L10n.of(context).txDeleteFailed('$e'),
          tone: SnackTone.error,
        );
      }
    }
  }

  Future<void> _showFilterOptions(BuildContext context) async {
    final transactions = ref.read(transactionProvider).transactions;
    final categories = ref.read(categoryProvider).categories;
    Set<String> familyOf(String id) => {
      id,
      for (final c in categories)
        if (c.mainCategoryId == id) c.id,
    };
    final updated = await showTransactionFilterSheet(
      context: context,
      current: _filters,
      // Across every month, so the button can say what applying will show.
      countFor: (filters) => collapseTransferLegs(
        transactions
            .where((t) => filters.matches(t, familyOf: familyOf))
            .toList(),
      ).length,
    );
    if (updated != null) setState(() => _filters = updated);
  }

  /// A page's scroll view. Each one takes the outer scroll's controller, so
  /// scrolling any month moves the search and chips out of the way.
  Widget _pageScroll(DateTime? month, List<Widget> slivers) => CustomScrollView(
    key: PageStorageKey<String>(
      month == null ? 'search' : '${month.year}-${month.month}',
    ),
    physics: const AlwaysScrollableScrollPhysics(),
    slivers: slivers,
  );

  Widget _emptyPage(DateTime? month, Widget child) => _pageScroll(month, [
    SliverPadding(
      padding: const EdgeInsets.only(top: 40),
      sliver: SliverToBoxAdapter(child: child),
    ),
  ]);

  Widget _buildEmptyState(DateTime? month) {
    final l10n = L10n.of(context);
    if (month == null) {
      return _emptyPage(
        month,
        EmptyState(
          icon: Symbols.search_off_rounded,
          title: l10n.activitySearchNothingTitle(_searchController.text.trim()),
          message: l10n.activitySearchNothingBody,
        ),
      );
    }
    final now = DateTime.now();
    final isFutureMonth = month.isAfter(DateTime(now.year, now.month));
    final isCurrentMonth = month.year == now.year && month.month == now.month;
    final monthLabel = DateFormat(
      'MMMM yyyy',
      Localizations.localeOf(context).toString(),
    ).format(month);

    final (IconData icon, String title, String body) = isFutureMonth
        ? (
            Symbols.event_available_rounded,
            l10n.activityEmptyFutureTitle,
            l10n.activityEmptyFutureBody(monthLabel),
          )
        : isCurrentMonth
        ? (
            Symbols.receipt_long_rounded,
            l10n.activityEmptyNowTitle,
            l10n.activityEmptyNowBody,
          )
        : (
            Symbols.history_rounded,
            l10n.activityEmptyPastTitle,
            l10n.activityEmptyPastBody(monthLabel),
          );

    return _emptyPage(
      month,
      EmptyState(icon: icon, title: title, message: body),
    );
  }

  /// The selected chip, read back from the filters it sets.
  _TypeChip get _typeChip {
    if (_filters.transfers == TransferFilter.only) return _TypeChip.transfers;
    return switch (_filters.direction) {
      DirectionFilter.expense => _TypeChip.spent,
      DirectionFilter.income => _TypeChip.earned,
      DirectionFilter.any => _TypeChip.all,
    };
  }

  void _setTypeChip(_TypeChip chip) {
    setState(() {
      _filters = switch (chip) {
        _TypeChip.all => _filters.copyWith(
          direction: DirectionFilter.any,
          transfers: TransferFilter.show,
        ),
        _TypeChip.spent => _filters.copyWith(
          direction: DirectionFilter.expense,
          transfers: TransferFilter.hide,
        ),
        _TypeChip.earned => _filters.copyWith(
          direction: DirectionFilter.income,
          transfers: TransferFilter.hide,
        ),
        _TypeChip.transfers => _filters.copyWith(
          direction: DirectionFilter.any,
          transfers: TransferFilter.only,
        ),
      };
    });
  }

  String _money(int cents, {bool sign = false}) {
    final currency = ref.watch(defaultCurrencyProvider);
    final nf = ref.watch(numberFormatSettingProvider);
    final text = sign
        ? cents.formatCurrencyWithSign(
            currency,
            isIncome: cents >= 0,
            useDecimals: false,
            numberFormat: nf,
          )
        : cents.abs().formatCurrency(
            currency,
            useDecimals: false,
            numberFormat: nf,
          );
    return text.replaceFirst('-', '−');
  }

  /// Money in and out over [rows], by the same rule as reports and budgets.
  (int income, int expense) _totals(List<Transaction> rows) {
    var income = 0;
    var expense = 0;
    for (final t in rows) {
      if (!t.countsInAnalytics) continue;
      if (t.type == 'income') {
        income += t.amount.abs();
      } else {
        expense += t.amount.abs();
      }
    }
    return (income, expense);
  }

  /// One month of transactions, or every match for a search when [month] is
  /// null.
  Widget _buildMonthPage(
    DateTime? month,
    List<Transaction> allTransactions,
    bool isLoading,
  ) {
    final l10n = L10n.of(context);
    final c = context.sunrise;

    if (isLoading) {
      return _pageScroll(month, const [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: SunriseSpace.screenX),
          sliver: SliverToBoxAdapter(
            child: ShimmerTransactionList(itemCount: 8),
          ),
        ),
      ]);
    }

    final filteredTransactions = _filterTransactionsForMonth(
      allTransactions,
      month,
    );
    if (filteredTransactions.isEmpty) return _buildEmptyState(month);

    final groupedTransactions = _groupTransactionsByDate(filteredTransactions);
    final sortedDates = groupedTransactions.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // Newest first
    final (monthIn, monthOut) = _totals(filteredTransactions);
    final locale = Localizations.localeOf(context).toString();

    return _pageScroll(month, [
      // The month's totals stay at the top while its days scroll under them.
      PinnedHeaderSliver(
        child: _PinnedSummary(
          child: _MonthSummary(
            label: month == null
                ? l10n.activitySearchFound(filteredTransactions.length)
                : DateUtils.isSameMonth(month, DateTime.now())
                ? l10n.activitySoFar(DateFormat('MMMM', locale).format(month))
                : DateFormat('MMMM yyyy', locale).format(month),
            net: l10n.activityNet(_money(monthIn - monthOut, sign: true)),
            inLabel: l10n.activityIn,
            inValue: _money(monthIn),
            outLabel: l10n.activityOut,
            outValue: _money(monthOut),
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(
          SunriseSpace.screenX,
          SunriseSpace.section - 10,
          SunriseSpace.screenX,
          SunriseSpace.tabBarClearance,
        ),
        sliver: SliverList.builder(
          itemCount: sortedDates.length,
          itemBuilder: (context, index) {
            final date = sortedDates[index];
            final dayTransactions = groupedTransactions[date]!;
            final (dayIn, dayOut) = _totals(dayTransactions);
            final dayNet = dayIn - dayOut;

            return Padding(
              padding: const EdgeInsets.only(bottom: SunriseSpace.section),
              child: DayGroupCard(
                label: _formatDateHeader(date, withMonth: month == null),
                total: dayIn == 0 && dayOut == 0
                    ? null
                    : _money(dayNet, sign: true),
                totalColor: c.subtle,
                children: [
                  for (final transaction in dayTransactions) _row(transaction),
                ],
              ),
            );
          },
        ),
      ),
    ]);
  }

  Widget _row(Transaction transaction) {
    final categoryState = ref.watch(categoryProvider);
    final category = categoryState.categories.firstWhere(
      (c) => c.id == transaction.categoryId,
      orElse: () => categoryState.categories.isNotEmpty
          ? categoryState.categories.first
          : Category(
              id: '',
              name: 'Other',
              colorCode: '#9A7869',
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
      category: transaction.isTransferLeg
          ? _transferRoute(transaction)
          : transaction.category,
      categoryColor: category.colorCode,
      categoryIcon: category.iconName,
      amount: transaction.amount / 100.0, // cents -> major units
      transactionType: transaction.type,
      walletId: transaction.walletId,
      notes: transaction.notes,
      date: transaction.date,
      isTransfer: transaction.isTransferLeg,
      isPending: !transaction.isPaid,
      selected: _selected.contains(transaction.id),
      onTap: () {
        if (_selecting) {
          _toggleSelected(transaction.id);
        } else {
          // Opens the row rather than the editor: there was nowhere to simply
          // look at a transaction without being one stray keystroke away from
          // changing it.
          _openTransaction(transaction);
        }
      },
      onLongPress: () => _toggleSelected(transaction.id),
      onEdit: () => _editTransaction(transaction),
      onDelete: () => _deleteTransaction(transaction),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final transactionState = ref.watch(transactionProvider);
    final canPop = Navigator.of(context).canPop();
    final chip = _typeChip;

    final filterButton = SunriseIconButton(
      icon: Symbols.tune_rounded,
      tooltip: l10n.filterTitle,
      onTap: () => _showFilterOptions(context),
      // Coloured only while something is actually filtered out, so the
      // control says the list is not showing everything.
      foreground: _filters.activeCount > 0 ? c.accent : c.ink,
      badge: _filters.activeCount == 0
          ? null
          : Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: c.accent,
                shape: BoxShape.circle,
                border: Border.all(color: c.base, width: 1.5),
              ),
            ),
    );

    return PopScope(
      // Back should put the selection down before it leaves the screen: losing
      // a dozen deliberately picked rows to a stray gesture is the kind of
      // thing people do not forgive.
      canPop: !_selecting,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _selecting) _clearSelection();
      },
      child: SunriseBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            bottom: false,
            child: SunriseContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      SunriseSpace.screenX,
                      SunriseSpace.screenTop,
                      SunriseSpace.screenX,
                      SunriseSpace.sectionTight,
                    ),
                    child: Row(
                      children: [
                        if (canPop) ...[
                          SunriseIconButton(
                            icon: Symbols.arrow_back_rounded,
                            tooltip: MaterialLocalizations.of(
                              context,
                            ).backButtonTooltip,
                            onTap: () => Navigator.of(context).maybePop(),
                          ),
                          const SizedBox(width: 14),
                        ],
                        Expanded(
                          child: Text(
                            l10n.navTransactions,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: SunriseType.largeTitle.copyWith(
                              color: c.ink,
                            ),
                          ),
                        ),
                        filterButton,
                      ],
                    ),
                  ),
                  // Search, the type chips and the months slide away as the
                  // list scrolls down and come back as soon as it scrolls up,
                  // so the rows get the screen while the month's totals stay
                  // pinned above them.
                  Expanded(
                    child: NestedScrollView(
                      floatHeaderSlivers: true,
                      headerSliverBuilder: (context, _) => [
                        SliverFloatingHeader(
                          child: _buildListHeader(l10n, chip),
                        ),
                      ],
                      body: Stack(
                        children: [
                          Offstage(
                            offstage: _searching,
                            child: PageView.builder(
                              controller: _pageController,
                              onPageChanged: _onPageChanged,
                              itemCount: _availableMonths.length,
                              itemBuilder: (context, index) => _buildMonthPage(
                                _availableMonths[index],
                                transactionState.transactions,
                                transactionState.isLoading,
                              ),
                            ),
                          ),
                          if (_searching)
                            _buildMonthPage(
                              null,
                              transactionState.transactions,
                              transactionState.isLoading,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Search (or the selection actions), the type chips and the month strip.
  Widget _buildListHeader(L10n l10n, _TypeChip chip) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // While rows are picked out, the actions replace search rather than
        // sitting beside it: narrowing the list mid-selection would quietly
        // change what "all of these" means.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: SunriseSpace.screenX),
          child: _selecting
              ? _buildSelectionBar()
              : SunriseSearchField(
                  hint: l10n.activitySearch,
                  controller: _searchController,
                  onClear: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                      _filters = _filters.copyWith(query: '');
                    });
                  },
                ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: SunriseSpace.screenX),
          child: Row(
            children: [
              for (final (value, label) in [
                (_TypeChip.all, l10n.activityAll),
                (_TypeChip.spent, l10n.activitySpent),
                (_TypeChip.earned, l10n.activityEarned),
                (_TypeChip.transfers, l10n.activityTransfers),
              ]) ...[
                SunriseChip(
                  label: label,
                  selected: chip == value,
                  onTap: () => _setTypeChip(value),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        // Kept in the tree while searching, so clearing the search lands back
        // on the month that was open.
        Offstage(
          offstage: _searching,
          child: MonthStrip(
            months: _availableMonths,
            selectedIndex: _currentPageIndex,
            onSelected: _onMonthChipTapped,
            controller: _monthScrollController,
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  /// What can be done to the rows that are picked out.
  ///
  /// Named by what they do to the selection rather than by icon alone: "move
  /// account" and "re-date" are not guessable from a picture, and a bulk action
  /// applied by mistake is expensive to undo by hand.
  Widget _buildSelectionBar() {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: c.chipActiveBg,
        borderRadius: SunriseRadius.inputAll,
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: l10n.actionCancel,
            icon: Icon(Symbols.close_rounded, color: c.chipActiveFg),
            onPressed: _clearSelection,
          ),
          Expanded(
            child: Text(
              l10n.txSelectedCount(_selected.length),
              style: SunriseType.rowTitle.copyWith(color: c.chipActiveFg),
            ),
          ),
          IconButton(
            tooltip: l10n.txActions,
            icon: Icon(Symbols.more_horiz_rounded, color: c.chipActiveFg),
            onPressed: _showBulkActions,
          ),
        ],
      ),
    );
  }

  void _showBulkActions() {
    final l10n = L10n.of(context);
    showSunriseSheet<void>(
      context: context,
      builder: (sheet) {
        void run(Future<void> Function() action) {
          Navigator.pop(sheet);
          action();
        }

        return SunriseBottomSheet(
          title: l10n.txSelectedCount(_selected.length),
          child: Column(
            children: [
              SheetAction(
                icon: Symbols.category_rounded,
                label: l10n.txChangeCategory,
                onTap: () => run(_bulkCategory),
              ),
              SheetAction(
                icon: Symbols.account_balance_wallet_rounded,
                label: l10n.txMoveToAccount,
                onTap: () => run(_bulkWallet),
              ),
              SheetAction(
                icon: Symbols.event_rounded,
                label: l10n.txChangeDate,
                onTap: () => run(_bulkDate),
              ),
              SheetAction(
                icon: Symbols.check_circle_rounded,
                label: l10n.txMarkAsPaid,
                onTap: () => run(_bulkMarkPaid),
              ),
              SheetAction(
                icon: Symbols.content_copy_rounded,
                label: l10n.txDuplicate,
                onTap: () => run(_bulkDuplicate),
              ),
              SheetAction(
                icon: Symbols.delete_rounded,
                label: l10n.actionDelete,
                destructive: true,
                onTap: () => run(_bulkDelete),
              ),
            ],
          ),
        );
      },
    );
  }
}

enum _TypeChip { all, spent, earned, transfers }

/// The pinned band the month summary sits in.
///
/// Clear while the list is at rest, so the screen looks as it always did;
/// frosted once rows scroll under it, so they don't show through the summary.
class _PinnedSummary extends StatefulWidget {
  const _PinnedSummary({required this.child});

  final Widget child;

  @override
  State<_PinnedSummary> createState() => _PinnedSummaryState();
}

class _PinnedSummaryState extends State<_PinnedSummary> {
  ScrollPosition? _position;
  bool _covering = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final position = Scrollable.maybeOf(context)?.position;
    if (position == _position) return;
    _position?.removeListener(_onScroll);
    _position = position?..addListener(_onScroll);
    _onScroll();
  }

  void _onScroll() {
    final covering = (_position?.hasPixels ?? false) && _position!.pixels > 1;
    if (covering != _covering && mounted) {
      setState(() => _covering = covering);
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final content = Padding(
      padding: const EdgeInsets.fromLTRB(
        SunriseSpace.screenX,
        4,
        SunriseSpace.screenX,
        10,
      ),
      child: widget.child,
    );
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: _covering
          ? SunriseGlass(
              key: const ValueKey(true),
              color: c.base.withValues(alpha: .6),
              child: content,
            )
          : KeyedSubtree(key: const ValueKey(false), child: content),
    );
  }
}

/// "October so far: +৳1,850 net", with money in and out.
class _MonthSummary extends StatelessWidget {
  const _MonthSummary({
    required this.label,
    required this.net,
    required this.inLabel,
    required this.inValue,
    required this.outLabel,
    required this.outValue,
  });

  final String label;
  final String net;
  final String inLabel;
  final String inValue;
  final String outLabel;
  final String outValue;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    Widget figure(String l, String v, Color color) => Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(l, style: SunriseType.label.copyWith(color: c.muted)),
        const SizedBox(height: 2),
        Text(v, style: SunriseType.amount.copyWith(color: color, fontSize: 14)),
      ],
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        gradient: c.softStrip,
        borderRadius: SunriseRadius.cardAll,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.label.copyWith(color: c.muted),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    net,
                    style: SunriseType.statValue.copyWith(
                      color: c.ink,
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          figure(inLabel, inValue, c.positive),
          const SizedBox(width: 18),
          figure(outLabel, outValue, c.negative),
        ],
      ),
    );
  }
}

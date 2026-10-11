import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/utils/responsive.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/ai_assistant/screens/ai_assistant_screen.dart'
    show AIAssistantScreenGated;
import 'package:the_accountant/features/authentication/providers/auth_provider.dart';
import 'package:the_accountant/features/budgets/screens/budget_list_screen.dart';
import 'package:the_accountant/features/credit_debt/providers/credit_debt_provider.dart';
import 'package:the_accountant/features/credit_debt/screens/credit_debt_screen.dart';
import 'package:the_accountant/features/dashboard/domain/home_layout.dart';
import 'package:the_accountant/features/dashboard/providers/balance_visibility_provider.dart';
import 'package:the_accountant/features/dashboard/providers/financial_data_provider.dart';
import 'package:the_accountant/features/dashboard/providers/home_layout_provider.dart';
import 'package:the_accountant/features/dashboard/widgets/pinned_goals_section.dart';
import 'package:the_accountant/features/notifications/providers/notification_history_provider.dart';
import 'package:the_accountant/features/notifications/screens/notification_inbox_screen.dart';
import 'package:the_accountant/features/reports/providers/reports_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/subscriptions/providers/subscription_dashboard_provider.dart';
import 'package:the_accountant/features/subscriptions/screens/subscription_dashboard_screen.dart';
import 'package:the_accountant/features/transactions/screens/transaction_list_screen.dart';
import 'package:the_accountant/features/transactions/screens/transaction_type_screen.dart';
import 'package:the_accountant/features/transactions/widgets/sunrise_transaction_row.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/wallets/screens/wallet_management_screen.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Today: greeting, net worth, earned and spent, and today's activity, then
/// the rest of the user's home sections in the order they chose.
class ResponsiveFinancialOverview extends ConsumerStatefulWidget {
  const ResponsiveFinancialOverview({
    super.key,
    this.balanceKey,
    this.notificationKey,
  });

  /// Marks the net-worth card for the first-run walkthrough.
  final Key? balanceKey;

  /// Marks the bell for the walkthrough.
  final Key? notificationKey;

  @override
  ConsumerState<ResponsiveFinancialOverview> createState() =>
      _ResponsiveFinancialOverviewState();
}

class _ResponsiveFinancialOverviewState
    extends ConsumerState<ResponsiveFinancialOverview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    duration: const Duration(milliseconds: 700),
    vsync: this,
  )..forward();

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  void _push(Widget screen) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final financialData = ref.watch(financialDataProvider);
    final l10n = L10n.of(context);

    if (financialData.isLoading) {
      return const SunriseTabPage(child: ShimmerDashboard());
    }

    if (financialData.error != null) {
      return SunriseTabPage(
        child: Center(
          child: EmptyState.error(
            title: l10n.dashErrorLoadingFinancialData,
            message: financialData.error,
            retryLabel: l10n.actionRetry,
            onRetry: () =>
                ref.read(financialDataProvider.notifier).refreshData(),
          ),
        ),
      );
    }

    final sections = ref.watch(homeLayoutProvider).visible;
    final income = financialData.monthlyIncome;
    final expenses = financialData.monthlyExpenses;
    final recent = financialData.recentTransactions;
    final c = context.sunrise;

    final blocks = <Widget>[
      _Header(
        showGreeting: sections.contains(HomeSection.greeting),
        bellKey: widget.notificationKey,
        onBell: () => _push(const NotificationInboxScreen()),
      ),
      for (final s in sections)
        if (s != HomeSection.greeting) ?_section(s, income, expenses, recent),
    ];

    final tablet = isTablet(context);

    return SunriseBackground(
      child: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(financialDataProvider.notifier).refreshData(),
          color: c.accent,
          backgroundColor: c.surface,
          edgeOffset: 0,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(
              SunriseSpace.screenX,
              SunriseSpace.screenTop,
              SunriseSpace.screenX,
              SunriseSpace.tabBarClearance,
            ),
            children: [
              SunriseContentWidth(
                maxWidth: tablet ? 980 : SunriseSpace.maxContentWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < blocks.length; i++)
                      _Staggered(
                        animation: _entrance,
                        index: i,
                        count: blocks.length,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: i == blocks.length - 1
                                ? 0
                                : SunriseSpace.section,
                          ),
                          child: blocks[i],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// One home block by name, or null when it has nothing to show.
  Widget? _section(
    HomeSection section,
    double income,
    double expenses,
    List<Transaction> recent,
  ) => switch (section) {
    HomeSection.greeting => null,
    HomeSection.accounts => _NetWorthCard(
      key: widget.balanceKey,
      monthDelta: income - expenses,
      onTap: () => _push(const WalletManagementScreen()),
    ),
    HomeSection.quickStats => _quickStats(income, expenses),
    HomeSection.quickLinks => _quickLinks(),
    HomeSection.spendingChart => const _SpendingChartCard(),
    HomeSection.recentTransactions => _todayList(recent),
    HomeSection.budgets => const _BudgetsCard(),
    HomeSection.goals => const PinnedGoalsSection(),
  };

  Widget _quickStats(double income, double expenses) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final currency = ref.watch(defaultCurrencyProvider);
    final decimals = ref.watch(defaultDecimalProvider);
    final nf = ref.watch(numberFormatSettingProvider);
    String fmt(double v) => (v * 100).round().formatCurrency(
      currency,
      useDecimals: decimals,
      numberFormat: nf,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: SunriseStatCard(
                icon: Symbols.south_west_rounded,
                iconColor: c.positive,
                label: l10n.todayEarned,
                value: fmt(income),
                onTap: () => _push(
                  const TransactionTypeScreen(transactionType: 'income'),
                ),
              ),
            ),
            const SizedBox(width: SunriseSpace.gap),
            Expanded(
              child: SunriseStatCard(
                icon: Symbols.north_east_rounded,
                iconColor: c.negative,
                label: l10n.todaySpent,
                value: fmt(expenses),
                onTap: () => _push(
                  const TransactionTypeScreen(transactionType: 'expense'),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: SunriseSpace.gap),
        _CoachCard(onTap: () => _push(const _AiRoute())),
      ],
    );
  }

  Widget _quickLinks() {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final currency = ref.watch(defaultCurrencyProvider);
    final nf = ref.watch(numberFormatSettingProvider);
    final net = ref.watch(creditDebtProvider).netBalance;
    final subs = ref.watch(subscriptionDashboardProvider).totalMonthlyCost;

    return Row(
      children: [
        Expanded(
          child: SunriseStatCard(
            icon: Symbols.handshake_rounded,
            iconColor: c.negative,
            label: l10n.dashCreditDebt,
            value: net.formatCurrencyWithSign(
              currency,
              isIncome: net >= 0,
              numberFormat: nf,
            ),
            footer: Text(
              net >= 0 ? l10n.todayNetCredit : l10n.todayNetDebt,
              style: SunriseType.caption.copyWith(color: c.subtle),
            ),
            onTap: () => _push(const CreditDebtScreen()),
          ),
        ),
        const SizedBox(width: SunriseSpace.gap),
        Expanded(
          child: SunriseStatCard(
            icon: Symbols.autorenew_rounded,
            iconColor: c.accent,
            label: l10n.dashSubscriptions,
            value: (subs * 100).round().formatCurrency(
              currency,
              numberFormat: nf,
            ),
            footer: Text(
              l10n.todayMonthly,
              style: SunriseType.caption.copyWith(color: c.subtle),
            ),
            onTap: () => _push(const SubscriptionDashboardScreen()),
          ),
        ),
      ],
    );
  }

  Widget _todayList(List<Transaction> recent) {
    final l10n = L10n.of(context);
    final now = DateTime.now();
    final today = recent
        .where(
          (t) =>
              t.date.year == now.year &&
              t.date.month == now.month &&
              t.date.day == now.day,
        )
        .toList();
    final showingToday = today.isNotEmpty || recent.isEmpty;
    final rows = (showingToday ? today : recent).take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          showingToday ? l10n.todayTitle : l10n.todayRecent,
          actionLabel: l10n.todayAllActivity,
          onAction: () => _push(const TransactionListScreen(standalone: true)),
        ),
        if (rows.isEmpty)
          SunriseCard(
            child: EmptyState(
              compact: true,
              icon: Symbols.receipt_long_rounded,
              title: l10n.todayNothingYet,
              message: l10n.todayNothingYetBody,
            ),
          )
        else
          ListCard(
            children: [
              for (final t in rows)
                SunriseTransactionRow(transaction: t, showDate: !showingToday),
            ],
          ),
      ],
    );
  }
}

/// The AI assistant, gated, as a pushed screen.
class _AiRoute extends StatelessWidget {
  const _AiRoute();

  @override
  Widget build(BuildContext context) => const AIAssistantScreenGated();
}

/// Entrance: each block fades and rises in turn.
class _Staggered extends StatelessWidget {
  const _Staggered({
    required this.animation,
    required this.index,
    required this.count,
    required this.child,
  });

  final Animation<double> animation;
  final int index;
  final int count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final start = (index / (count + 2)).clamp(0.0, .7);
    final curve = CurvedAnimation(
      parent: animation,
      curve: Interval(start, (start + .4).clamp(0, 1), curve: Curves.easeOut),
    );
    return FadeTransition(
      opacity: curve,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, .06),
          end: Offset.zero,
        ).animate(curve),
        child: child,
      ),
    );
  }
}

/// Date line, bell, and "Good evening, Name".
class _Header extends ConsumerWidget {
  const _Header({
    required this.showGreeting,
    required this.onBell,
    this.bellKey,
  });

  final bool showGreeting;
  final VoidCallback onBell;
  final Key? bellKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final unread = ref.watch(unreadNotificationCountProvider);
    final locale = Localizations.localeOf(context).toString();
    final now = DateTime.now();
    final date = DateFormat('EEE, d MMMM', locale).format(now);

    final fullName = ref.watch(authProvider).displayName?.trim() ?? '';
    final first = fullName.isEmpty ? '' : fullName.split(RegExp(r'\s+')).first;
    final hour = now.hour;
    final greeting = first.isEmpty
        ? (hour < 12
              ? l10n.todayGoodMorningPlain
              : hour < 17
              ? l10n.todayGoodAfternoonPlain
              : l10n.todayGoodEveningPlain)
        : (hour < 12
              ? l10n.todayGoodMorning(first)
              : hour < 17
              ? l10n.todayGoodAfternoon(first)
              : l10n.todayGoodEvening(first));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                date,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: SunriseType.label.copyWith(color: c.muted, fontSize: 14),
              ),
            ),
            KeyedSubtree(
              key: bellKey,
              child: SunriseIconButton(
                icon: Symbols.notifications_rounded,
                tooltip: l10n.todayNotifications,
                onTap: onBell,
                badge: unread == 0
                    ? null
                    : Container(
                        constraints: const BoxConstraints(minWidth: 18),
                        height: 18,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: c.negative,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: c.base, width: 1.5),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          unread > 99 ? '99+' : '$unread',
                          style: SunriseType.tabLabel.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
        if (showGreeting) ...[
          const SizedBox(height: 10),
          Semantics(
            header: true,
            child: Text(
              greeting,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: SunriseType.greeting.copyWith(color: c.ink),
            ),
          ),
        ],
      ],
    );
  }
}

/// The frosted net-worth card with the wallet split bar.
class _NetWorthCard extends ConsumerWidget {
  const _NetWorthCard({super.key, required this.monthDelta, this.onTap});

  /// This month's income minus expenses, in major units.
  final double monthDelta;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final currency = ref.watch(defaultCurrencyProvider);
    final decimals = ref.watch(defaultDecimalProvider);
    final nf = ref.watch(numberFormatSettingProvider);
    final total = ref.watch(convertedTotalBalanceProvider).asData?.value ?? 0;
    final walletState = ref.watch(walletProvider);
    final visibility = ref.watch(balanceVisibilityProvider);

    final wallets = walletState.wallets.where((w) => !w.isArchived).toList();
    final balances = walletState.walletBalances;
    int balanceOf(Wallet w) => balances[w.id] ?? w.balance;

    // Split by size; only positive balances take room on the bar.
    final positive = wallets.where((w) => balanceOf(w) > 0).toList()
      ..sort((a, b) => balanceOf(b).compareTo(balanceOf(a)));
    final sum = positive.fold<int>(0, (s, w) => s + balanceOf(w));
    final ramp = _ramp(c, positive.length);

    final deltaCents = (monthDelta * 100).round();
    final deltaText = deltaCents.formatCurrencyWithSign(
      currency,
      isIncome: deltaCents >= 0,
      useDecimals: false,
      numberFormat: nf,
    );

    return SunriseCard(
      glass: true,
      radius: SunriseRadius.heroBig,
      padding: const EdgeInsets.all(SunriseSpace.hero),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.todayNetWorth,
                  style: SunriseType.label.copyWith(
                    color: c.muted,
                    fontSize: 15,
                  ),
                ),
              ),
              Flexible(
                child: SunrisePill(
                  label: l10n.todayThisMonthDelta(
                    deltaText.replaceFirst('-', '−'),
                  ),
                  color: deltaCents >= 0 ? c.accentText : c.negative,
                  background: deltaCents >= 0 ? c.tintPeach : c.tintRose,
                  fontSize: 13,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              '${total < 0 ? '−' : ''}${total.abs().formatCurrency(currency, useDecimals: decimals && total.abs() < 10000000, numberFormat: nf)}',
              maxLines: 1,
              style: SunriseType.balance.copyWith(color: c.ink),
            ),
          ),
          if (positive.isNotEmpty) ...[
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: SizedBox(
                height: 10,
                child: Row(
                  children: [
                    for (var i = 0; i < positive.length; i++) ...[
                      if (i > 0) const SizedBox(width: 3),
                      Expanded(
                        // At least 4% wide, so a small wallet still shows.
                        flex: (balanceOf(positive[i]) * 1000 ~/ sum).clamp(
                          40,
                          1000,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(colors: ramp[i]),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              alignment: WrapAlignment.spaceBetween,
              children: [
                for (var i = 0; i < positive.length && i < 3; i++)
                  _Legend(
                    color: ramp[i].last,
                    label: positive[i].name,
                    value: (visibility[positive[i].id] ?? true)
                        ? balanceOf(positive[i]).formatCurrency(
                            positive[i].currency,
                            useDecimals: false,
                            numberFormat: nf,
                          )
                        : '••••',
                  ),
                if (positive.length > 3)
                  Text(
                    l10n.todayMoreWallets(positive.length - 3),
                    style: SunriseType.label.copyWith(color: c.subtle),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Two-stop gradients walking along the brand gradient, one per wallet.
  static List<List<Color>> _ramp(SunriseColors c, int n) {
    if (n <= 0) return const [];
    final stops = [c.gradientStart, c.gradientMid, c.gradientEnd];
    Color at(double t) {
      final scaled = t * 2;
      final i = scaled.floor().clamp(0, 1);
      return Color.lerp(stops[i], stops[i + 1], scaled - i)!;
    }

    if (n == 1) return [stops.sublist(0, 2)];
    return [
      for (var i = 0; i < n; i++) [at(i / n), at(((i + 1) / n).clamp(0, 1))],
    ];
  }
}

class _Legend extends StatelessWidget {
  const _Legend({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Text(
            '$label $value',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: SunriseType.label.copyWith(color: c.ink, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

/// The entry to the AI assistant on Today.
class _CoachCard extends StatelessWidget {
  const _CoachCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return SunriseCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: c.orbGradient,
              shape: BoxShape.circle,
              boxShadow: c.selectedShadow,
            ),
            child: const Icon(
              Symbols.auto_awesome_rounded,
              color: Colors.white,
              fill: 1,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.todayCoachTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.rowTitle.copyWith(color: c.ink),
                ),
                Text(
                  l10n.todayCoachBody,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.caption.copyWith(color: c.subtle),
                ),
              ],
            ),
          ),
          Icon(Symbols.chevron_right_rounded, color: c.chevron, size: 20),
        ],
      ),
    );
  }
}

/// The spending line for the current period, softly filled.
class _SpendingChartCard extends ConsumerWidget {
  const _SpendingChartCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final reports = ref.watch(reportsProvider);
    final spots = reports.toLineChartSpots();
    final maxY = reports.getMaxY();

    return SunriseCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dashSpendingOverview,
            style: SunriseType.section.copyWith(color: c.ink, fontSize: 16),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 160,
            child: spots.isEmpty
                ? Center(
                    child: Text(
                      l10n.dashNoSpendingDataYet,
                      style: SunriseType.label.copyWith(color: c.subtle),
                    ),
                  )
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: maxY > 0 ? maxY / 4 : 1,
                        getDrawingHorizontalLine: (_) =>
                            FlLine(color: c.divider, strokeWidth: 1),
                      ),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineTouchData: const LineTouchData(enabled: false),
                      minY: 0,
                      maxY: maxY,
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          preventCurveOverShooting: true,
                          gradient: c.gradientShort,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, _, _, index) =>
                                FlDotCirclePainter(
                                  radius: index == spots.length - 1 ? 4.5 : 0,
                                  color: c.gradientEnd,
                                  strokeWidth: 2.5,
                                  strokeColor: c.surface,
                                ),
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                c.gradientMid.withValues(alpha: .25),
                                c.gradientMid.withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    duration: SunriseMotion.chart,
                  ),
          ),
        ],
      ),
    );
  }
}

/// Active budgets with progress bars.
class _BudgetsCard extends ConsumerWidget {
  const _BudgetsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final items = ref.watch(budgetProgressDetailsProvider);
    final currency = ref.watch(defaultCurrencyProvider);
    final nf = ref.watch(numberFormatSettingProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          l10n.dashBudgetProgress,
          actionLabel: l10n.dashManage,
          onAction: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const BudgetListScreen())),
        ),
        SunriseCard(
          child: items.isEmpty
              ? Text(
                  l10n.reportNoActiveBudgets,
                  style: SunriseType.label.copyWith(color: c.subtle),
                )
              : Column(
                  children: [
                    for (var i = 0; i < items.length; i++) ...[
                      if (i > 0) const SizedBox(height: 16),
                      _BudgetBar(
                        name: items[i].budgetName,
                        spent: items[i].spent,
                        limit: items[i].limit,
                        caption: (int spent, int limit) =>
                            '${spent.formatCurrency(currency, useDecimals: false, numberFormat: nf)} / '
                            '${limit.formatCurrency(currency, useDecimals: false, numberFormat: nf)}',
                        withinLabel: l10n.todayWithinBudget,
                        overLabel: l10n.todayOverBudget,
                      ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _BudgetBar extends StatelessWidget {
  const _BudgetBar({
    required this.name,
    required this.spent,
    required this.limit,
    required this.caption,
    required this.withinLabel,
    required this.overLabel,
  });

  final String name;
  final int spent;
  final int limit;
  final String Function(int spent, int limit) caption;
  final String withinLabel;
  final String overLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final pct = limit <= 0 ? 0.0 : spent / limit;
    final over = pct > 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: SunriseType.rowTitle.copyWith(color: c.ink),
              ),
            ),
            Text(
              caption(spent, limit),
              style: SunriseType.label.copyWith(
                color: c.subtle,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            children: [
              Container(height: 8, color: c.toggleOff),
              FractionallySizedBox(
                widthFactor: pct.clamp(0.0, 1.0),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: over ? c.negative : null,
                    gradient: over ? null : c.gradientShort,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(
                over ? overLabel : withinLabel,
                style: SunriseType.caption.copyWith(
                  color: over ? c.negative : c.subtle,
                ),
              ),
            ),
            Text(
              '${(pct * 100).clamp(0, 999).toStringAsFixed(0)}%',
              style: SunriseType.caption.copyWith(
                color: c.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

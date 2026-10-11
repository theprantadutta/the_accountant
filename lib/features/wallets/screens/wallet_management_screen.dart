import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/budgets/screens/budget_list_screen.dart';
import 'package:the_accountant/features/credit_debt/providers/credit_debt_provider.dart';
import 'package:the_accountant/features/credit_debt/screens/credit_debt_screen.dart';
import 'package:the_accountant/features/objectives/providers/objectives_provider.dart';
import 'package:the_accountant/features/objectives/screens/objectives_list_screen.dart';
import 'package:the_accountant/features/premium/exceptions/premium_limit_exception.dart';
import 'package:the_accountant/features/premium/widgets/upgrade_limit_dialog.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/subscriptions/providers/subscription_dashboard_provider.dart';
import 'package:the_accountant/features/subscriptions/screens/subscription_dashboard_screen.dart';
import 'package:the_accountant/features/transactions/providers/upcoming_provider.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/features/transactions/screens/upcoming_transactions_screen.dart';
import 'package:the_accountant/features/transactions/widgets/transaction_type_header.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/wallets/screens/wallet_detail_screen.dart';
import 'package:the_accountant/features/wallets/widgets/add_wallet_form.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/color_picker.dart';
import 'package:the_accountant/shared/widgets/icon_picker.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Wallets: the default account as a gradient card, the others as rows, an
/// add row, and the Planning group (upcoming, lend & borrow, goals, budgets,
/// subscriptions, transfers).
///
/// A tab root in the shell ([asTab]) and still pushable from elsewhere.
class WalletManagementScreen extends ConsumerStatefulWidget {
  const WalletManagementScreen({super.key, this.asTab = false});

  final bool asTab;

  @override
  ConsumerState<WalletManagementScreen> createState() =>
      _WalletManagementScreenState();
}

class _WalletManagementScreenState
    extends ConsumerState<WalletManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------- actions

  void _showAddWalletSheet() {
    HapticFeedback.lightImpact();
    showSunriseSheet<void>(
      context: context,
      builder: (sheetContext) => SunriseBottomSheet(
        child: AddWalletForm(
          formKey: _formKey,
          nameController: _nameController,
          balanceController: _balanceController,
          initialCurrency: ref.read(settingsProvider).currency,
          onSubmit: _submitForm,
          onCancel: () => Navigator.pop(sheetContext),
        ),
      ),
    );
  }

  Future<void> _submitForm({
    required String currency,
    required String icon,
    required String color,
    required bool isDefault,
    required bool useDecimals,
    required WalletType walletType,
    required double? creditLimit,
    required int? billingCycleDay,
  }) async {
    final walletNotifier = ref.read(walletProvider.notifier);
    final l10n = L10n.of(context);

    try {
      await walletNotifier.addWallet(
        name: _nameController.text,
        currency: currency,
        balance: _balanceController.text.toCentsOrNull() ?? 0,
        iconName: icon,
        color: color,
        isDefault: isDefault,
        useDecimals: useDecimals,
        walletType: walletType,
        creditLimit: creditLimit == null ? null : (creditLimit * 100).round(),
        billingCycleDay: billingCycleDay,
      );

      _nameController.clear();
      _balanceController.clear();

      if (!mounted) return;
      Navigator.pop(context);
      showSunriseSnack(
        context,
        l10n.walletWalletCreatedSuccessfully,
        tone: SnackTone.success,
      );
    } on PremiumLimitException catch (e) {
      if (mounted) await UpgradeLimitDialog.showFromException(context, e);
    } catch (_) {
      if (mounted) {
        showSunriseSnack(context, l10n.walletsCreateFailed, tone: SnackTone.error);
      }
    }
  }

  Future<void> _openWallet(Wallet wallet) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WalletDetailScreen(walletId: wallet.id)),
    );
    if (mounted) await ref.read(walletProvider.notifier).loadWallets();
  }

  void _push(Widget screen) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> _confirmDelete(Wallet wallet) async {
    final l10n = L10n.of(context);
    final ok = await showSunriseConfirm(
      context: context,
      title: l10n.settingsDeleteAccount,
      message: l10n.walletsDeleteMessage(wallet.name),
      confirmLabel: l10n.actionDelete,
      destructive: true,
      icon: Symbols.delete_rounded,
    );
    if (!ok || !mounted) return;
    await ref.read(walletProvider.notifier).deleteWallet(wallet.id);
    if (mounted) showSunriseSnack(context, l10n.walletsDeleted(wallet.name));
  }

  void _setAsDefault(Wallet wallet) {
    HapticFeedback.lightImpact();
    ref
        .read(walletProvider.notifier)
        .updateWallet(id: wallet.id, isDefault: true);
    showSunriseSnack(
      context,
      L10n.of(context).walletsSetDefaultDone(wallet.name),
      tone: SnackTone.success,
    );
  }

  void _showEditWalletSheet(Wallet wallet) {
    final editNameController = TextEditingController(text: wallet.name);
    final editBalanceController = TextEditingController(
      text: (wallet.balance / 100.0).toStringAsFixed(2),
    );
    final editFormKey = GlobalKey<FormState>();

    showSunriseSheet<void>(
      context: context,
      builder: (sheetContext) => SunriseBottomSheet(
        child: AddWalletForm(
          formKey: editFormKey,
          nameController: editNameController,
          balanceController: editBalanceController,
          initialCurrency: wallet.currency,
          initialIcon: wallet.iconName,
          initialColor: wallet.color,
          initialIsDefault: wallet.isDefault,
          initialUseDecimals: wallet.useDecimals,
          initialWalletType: wallet.walletType,
          initialCreditLimit: wallet.creditLimit == null
              ? null
              : wallet.creditLimit! / 100.0,
          initialBillingCycleDay: wallet.billingCycleDay,
          isEditing: true,
          onSubmit:
              ({
                required String currency,
                required String icon,
                required String color,
                required bool isDefault,
                required bool useDecimals,
                required WalletType walletType,
                required double? creditLimit,
                required int? billingCycleDay,
              }) {
                ref
                    .read(walletProvider.notifier)
                    .updateWallet(
                      id: wallet.id,
                      name: editNameController.text,
                      currency: currency,
                      balance: editBalanceController.text.toCentsOrNull(),
                      iconName: icon,
                      color: color,
                      isDefault: isDefault,
                      useDecimals: useDecimals,
                      creditLimit: creditLimit == null
                          ? null
                          : (creditLimit * 100).round(),
                      billingCycleDay: billingCycleDay,
                    );
                Navigator.pop(sheetContext);
                showSunriseSnack(
                  context,
                  L10n.of(context).walletAccountUpdatedSuccessfully,
                  tone: SnackTone.success,
                );
              },
          onCancel: () => Navigator.pop(sheetContext),
        ),
      ),
    );
  }

  void _showOptions(Wallet wallet) {
    final l10n = L10n.of(context);
    showSunriseSheet<void>(
      context: context,
      builder: (sheetContext) {
        void close(VoidCallback then) {
          Navigator.pop(sheetContext);
          then();
        }

        return SunriseBottomSheet(
          title: wallet.name,
          subtitle: wallet.currency,
          child: Column(
            children: [
              SheetAction(
                icon: Symbols.edit_rounded,
                label: l10n.walletEditAccount,
                onTap: () => close(() => _showEditWalletSheet(wallet)),
              ),
              if (!wallet.isDefault)
                SheetAction(
                  icon: Symbols.star_rounded,
                  label: l10n.walletSetAsDefault,
                  onTap: () => close(() => _setAsDefault(wallet)),
                ),
              SheetAction(
                icon: Symbols.delete_rounded,
                label: l10n.settingsDeleteAccount,
                destructive: true,
                onTap: () => close(() => _confirmDelete(wallet)),
              ),
            ],
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final walletState = ref.watch(walletProvider);
    final wallets = walletState.wallets;

    Wallet? featured;
    for (final w in wallets) {
      if (w.isDefault && !w.isArchived) featured = w;
    }
    featured ??= wallets.where((w) => !w.isArchived).firstOrNull;
    final others = wallets.where((w) => w.id != featured?.id).toList();

    final newButton = Pressable(
      onTap: _showAddWalletSheet,
      haptic: true,
      semanticLabel: l10n.walletAddAccount,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: c.chipActiveBg,
          borderRadius: BorderRadius.circular(SunriseRadius.chip),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Symbols.add_rounded, color: c.chipActiveFg, size: 20),
            const SizedBox(width: 6),
            Text(
              l10n.walletsNew,
              style: SunriseType.label.copyWith(
                color: c.chipActiveFg,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );

    final content = <Widget>[
      if (walletState.isLoading) ...[
        const ShimmerCard(height: 176),
        const SizedBox(height: 12),
        const ShimmerCard(height: 76),
        const SizedBox(height: 12),
        const ShimmerCard(height: 76),
      ] else if (wallets.isEmpty)
        SunriseCard(
          child: EmptyState(
            icon: Symbols.account_balance_wallet_rounded,
            title: l10n.walletNoAccountsYet,
            message: l10n.walletsEmptyBody,
            actionLabel: l10n.walletCreateAccount,
            onAction: _showAddWalletSheet,
          ),
        )
      else ...[
        if (featured != null)
          _FeaturedWalletCard(
            wallet: featured,
            onTap: () => _openWallet(featured!),
            onLongPress: () => _showOptions(featured!),
          ),
        if (others.isNotEmpty) ...[
          const SizedBox(height: SunriseSpace.gap),
          _ReorderableWallets(
            wallets: others,
            onOpen: _openWallet,
            onOptions: _showOptions,
            onReorder: (ids) {
              // Keep the featured wallet where it was in the stored order.
              final all = wallets.map((w) => w.id).toList();
              final featuredIndex = featured == null
                  ? -1
                  : all.indexOf(featured.id);
              final merged = [...ids];
              if (featuredIndex >= 0) {
                merged.insert(featuredIndex.clamp(0, merged.length), featured!.id);
              }
              ref.read(walletProvider.notifier).reorderWallets(merged);
            },
          ),
        ],
        const SizedBox(height: SunriseSpace.gap),
        _DashedAddRow(label: l10n.walletsAddHint, onTap: _showAddWalletSheet),
      ],
      const SizedBox(height: 26),
      _PlanningGroup(onOpen: _push),
    ];

    if (!widget.asTab) {
      return SunrisePushPage(
        title: l10n.walletsTitle,
        actions: [newButton],
        children: content,
      );
    }

    return SunriseTabPage(
      child: RefreshIndicator(
        color: c.accent,
        backgroundColor: c.surface,
        onRefresh: () => ref.read(walletProvider.notifier).loadWallets(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.only(bottom: SunriseSpace.tabBarClearance),
          children: [
            LargeTitleHeader(title: l10n.walletsTitle, trailing: newButton),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SunriseSpace.screenX,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Formats a wallet's balance in its own currency.
String _walletAmount(WidgetRef ref, Wallet w, int cents, {bool? decimals}) {
  final text = cents.abs().formatCurrency(
    w.currency,
    useDecimals: decimals ?? w.useDecimals,
    numberFormat: ref.watch(numberFormatSettingProvider),
  );
  // The sign goes before the symbol: −$499.12, not $−499.12.
  return cents < 0 ? '−$text' : text;
}

String _typeLabel(L10n l10n, WalletType type) => switch (type) {
  WalletType.bankAccount => l10n.walletsTypeBank,
  WalletType.creditCard => l10n.walletsTypeCard,
  WalletType.cash => l10n.walletsTypeCash,
  _ => l10n.walletsTypeOther,
};

/// The default account on the brand gradient (height 176).
class _FeaturedWalletCard extends ConsumerWidget {
  const _FeaturedWalletCard({
    required this.wallet,
    required this.onTap,
    required this.onLongPress,
  });

  final Wallet wallet;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final balances = ref.watch(walletProvider).walletBalances;
    final cents = balances[wallet.id] ?? wallet.balance;
    final isCard = wallet.walletType == WalletType.creditCard;
    final limit = wallet.creditLimit ?? 0;
    final outstanding = isCard ? cents.abs() : 0;

    return Pressable(
      onTap: onTap,
      onLongPress: onLongPress,
      child: GradientCard(
        height: 176,
        radius: SunriseRadius.hero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(WalletIcons.getIcon(wallet.iconName), size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    wallet.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: SunriseType.section.copyWith(color: Colors.white),
                  ),
                ),
                if (wallet.isDefault)
                  SunrisePill(
                    label: l10n.payDefault,
                    color: Colors.white,
                    background: Colors.white.withValues(alpha: .24),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              isCard ? l10n.walletOutstanding : l10n.walletBalance,
              style: SunriseType.label.copyWith(
                color: Colors.white.withValues(alpha: .85),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                _walletAmount(ref, wallet, isCard ? outstanding : cents),
                maxLines: 1,
                style: SunriseType.balance.copyWith(fontSize: 34),
              ),
            ),
            if (isCard && limit > 0) ...[
              const SizedBox(height: 4),
              Text(
                '${l10n.walletAvailable} ${_walletAmount(ref, wallet, limit - outstanding)} · '
                '${l10n.walletLimit} ${_walletAmount(ref, wallet, limit)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: SunriseType.caption.copyWith(
                  color: context.sunrise.onFill.withValues(alpha: .85),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The non-featured wallets as drag-reorderable rows.
class _ReorderableWallets extends ConsumerWidget {
  const _ReorderableWallets({
    required this.wallets,
    required this.onOpen,
    required this.onOptions,
    required this.onReorder,
  });

  final List<Wallet> wallets;
  final ValueChanged<Wallet> onOpen;
  final ValueChanged<Wallet> onOptions;
  final ValueChanged<List<String>> onReorder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      itemCount: wallets.length,
      proxyDecorator: (child, _, _) =>
          Material(type: MaterialType.transparency, child: child),
      onReorderItem: (oldIndex, newIndex) {
        final ids = wallets.map((w) => w.id).toList();
        final moved = ids.removeAt(oldIndex);
        ids.insert(newIndex, moved);
        HapticFeedback.mediumImpact();
        onReorder(ids);
      },
      itemBuilder: (context, i) => Padding(
        key: ValueKey(wallets[i].id),
        padding: EdgeInsets.only(top: i == 0 ? 0 : SunriseSpace.gap),
        child: ReorderableDelayedDragStartListener(
          index: i,
          child: _WalletRow(
            wallet: wallets[i],
            onTap: () => onOpen(wallets[i]),
            onOptions: () => onOptions(wallets[i]),
          ),
        ),
      ),
    );
  }
}

class _WalletRow extends ConsumerWidget {
  const _WalletRow({
    required this.wallet,
    required this.onTap,
    required this.onOptions,
  });

  final Wallet wallet;
  final VoidCallback onTap;
  final VoidCallback onOptions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final balances = ref.watch(walletProvider).walletBalances;
    final cents = balances[wallet.id] ?? wallet.balance;
    final isCard = wallet.walletType == WalletType.creditCard;
    final color = WalletColors.parseColor(wallet.color);
    final subtitle = [
      wallet.currency,
      if (isCard) _typeLabel(l10n, wallet.walletType),
      if (wallet.isArchived) l10n.walletsArchived,
    ].join(' · ');

    return Opacity(
      opacity: wallet.isArchived ? .55 : 1,
      child: SunriseCard(
        onTap: onTap,
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
        child: Row(
          children: [
            IconTile(
              icon: WalletIcons.getIcon(wallet.iconName),
              color: color,
              size: 44,
              radius: SunriseRadius.iconTileLg,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wallet.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: SunriseType.rowTitle.copyWith(
                      color: c.ink,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: SunriseType.caption.copyWith(color: c.subtle),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  _walletAmount(ref, wallet, isCard ? -cents.abs() : cents),
                  style: SunriseType.amount.copyWith(
                    color: cents < 0 && !isCard ? c.negative : c.ink,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: MaterialLocalizations.of(context).showMenuTooltip,
              onPressed: onOptions,
              icon: Icon(Symbols.more_vert_rounded, color: c.chevron, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

/// The dashed "add another account" row.
class _DashedAddRow extends StatelessWidget {
  const _DashedAddRow({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Pressable(
      onTap: onTap,
      haptic: true,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: c.dashed,
          radius: SunriseRadius.card,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Row(
            children: [
              Icon(Symbols.add_card_rounded, color: c.accentText, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.rowTitle.copyWith(
                    color: c.accentText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ).deflate(.75),
      );
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + 6), paint);
        d += 11;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}

/// Upcoming, lend & borrow, goals, budgets, subscriptions, transfers.
class _PlanningGroup extends ConsumerWidget {
  const _PlanningGroup({required this.onOpen});

  final ValueChanged<Widget> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final currency = ref.watch(defaultCurrencyProvider);
    final nf = ref.watch(numberFormatSettingProvider);
    String money(int cents) => cents.abs().formatCurrency(
      currency,
      useDecimals: false,
      numberFormat: nf,
    );

    final upcoming = ref.watch(upcomingProvider);
    final due = [
      ...upcoming.overdueTransactions,
      ...upcoming.upcomingTransactions,
    ];
    final dueTotal = due.fold<int>(0, (s, t) => s + t.amount.abs());

    final net = ref.watch(creditDebtProvider).netBalance;
    final goals = ref.watch(goalsProvider).asData?.value ?? const [];
    final activeGoals = goals.where((g) => !g.isArchived).length;
    final budgets = ref.watch(budgetProvider).budgets.length;
    final subs = ref.watch(subscriptionDashboardProvider).totalMonthlyCost;

    return SettingsGroup(
      label: l10n.walletsPlanning,
      children: [
        SettingsRow(
          icon: Symbols.event_upcoming_rounded,
          iconColor: const Color(0xFFD97706),
          iconBackground: c.tintAmber,
          title: l10n.walletsUpcoming,
          subtitle: due.isEmpty
              ? l10n.walletsUpcomingNone
              : l10n.walletsUpcomingSub(due.length, money(dueTotal)),
          onTap: () => onOpen(const UpcomingTransactionsScreen()),
        ),
        SettingsRow(
          icon: Symbols.handshake_rounded,
          iconColor: c.negative,
          iconBackground: c.tintRose,
          title: l10n.walletsLendBorrow,
          subtitle: net == 0
              ? l10n.walletsAllSettled
              : net > 0
              ? l10n.walletsOwedToYou(money(net))
              : l10n.walletsYouOwe(money(net)),
          onTap: () => onOpen(const CreditDebtScreen()),
        ),
        SettingsRow(
          icon: Symbols.flag_rounded,
          iconColor: c.positive,
          iconBackground: c.tintGreen,
          title: l10n.walletsGoals,
          subtitle: activeGoals == 0 ? null : l10n.walletsGoalsSub(activeGoals),
          onTap: () => onOpen(const ObjectivesListScreen()),
        ),
        SettingsRow(
          icon: Symbols.donut_large_rounded,
          iconColor: const Color(0xFF0284C7),
          iconBackground: c.tintSky,
          title: l10n.walletsBudgets,
          subtitle: budgets == 0 ? null : l10n.walletsGoalsSub(budgets),
          onTap: () => onOpen(const BudgetListScreen()),
        ),
        SettingsRow(
          icon: Symbols.autorenew_rounded,
          iconColor: const Color(0xFF7C3AED),
          iconBackground: c.tintViolet,
          title: l10n.walletsSubscriptions,
          subtitle: subs <= 0
              ? null
              : '${money((subs * 100).round())} · ${l10n.todayMonthly}',
          onTap: () => onOpen(const SubscriptionDashboardScreen()),
        ),
        SettingsRow(
          icon: Symbols.sync_alt_rounded,
          iconColor: c.accent,
          iconBackground: c.tintOrange,
          title: l10n.walletsTransfer,
          onTap: () => showAddTransactionScreen(
            context,
            initialType: TransactionTypeSelection.transfer,
          ),
        ),
      ],
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/utils/number_formatter.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/wallets/widgets/add_wallet_form.dart';
import 'package:the_accountant/shared/widgets/color_picker.dart';
import 'package:the_accountant/shared/widgets/icon_picker.dart';

class WalletManagementScreen extends ConsumerStatefulWidget {
  const WalletManagementScreen({super.key});

  @override
  ConsumerState<WalletManagementScreen> createState() =>
      _WalletManagementScreenState();
}

class _WalletManagementScreenState extends ConsumerState<WalletManagementScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();

  late AnimationController _headerController;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    );
    _headerController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  void _showAddWalletSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.primarySurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: AppSpacing.paddingLg,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                AddWalletForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  balanceController: _balanceController,
                  initialCurrency: ref.read(settingsProvider).currency,
                  onSubmit: _submitForm,
                  onCancel: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm({
    required String currency,
    required String icon,
    required String color,
    required bool isDefault,
    required bool useDecimals,
    required WalletType walletType,
    required double? creditLimit,
    required int? billingCycleDay,
  }) {
    final walletNotifier = ref.read(walletProvider.notifier);
    walletNotifier.addWallet(
      name: _nameController.text,
      currency: currency,
      balance: double.tryParse(_balanceController.text) ?? 0.0,
      iconName: icon,
      color: color,
      isDefault: isDefault,
      useDecimals: useDecimals,
      walletType: walletType,
      creditLimit: creditLimit,
      billingCycleDay: billingCycleDay,
    );

    _nameController.clear();
    _balanceController.clear();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Wallet created successfully'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletProvider);
    final wallets = walletState.wallets;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with total balance
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(wallets, walletState),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.glassWhite,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryAccent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 20,
                      color: AppColors.primaryAccent,
                    ),
                  ),
                  onPressed: _showAddWalletSheet,
                ),
              ),
            ],
          ),

          // Wallet list grouped by type
          if (walletState.isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryAccent,
                ),
              ),
            )
          else if (wallets.isEmpty)
            SliverFillRemaining(child: _buildEmptyState())
          else
            ..._buildGroupedWalletSlivers(wallets, walletState),
          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: wallets.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _showAddWalletSheet,
              backgroundColor: AppColors.primaryAccent,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Add Account',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  List<Widget> _buildGroupedWalletSlivers(
    List<Wallet> wallets,
    WalletState walletState,
  ) {
    // Group wallets by type
    final grouped = <WalletType, List<Wallet>>{};
    for (final wallet in wallets) {
      grouped.putIfAbsent(wallet.walletType, () => []).add(wallet);
    }

    // Define display order
    const typeOrder = [
      WalletType.cash,
      WalletType.bankAccount,
      WalletType.creditCard,
      WalletType.subscription,
    ];

    final slivers = <Widget>[];
    var globalIndex = 0;

    for (final type in typeOrder) {
      final group = grouped[type];
      if (group == null || group.isEmpty) continue;

      // Section header
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(
                  _walletTypeIcon(type),
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  _walletTypeSectionLabel(type),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Divider(color: AppColors.divider, thickness: 1),
                ),
              ],
            ),
          ),
        ),
      );

      // Wallet cards in this group
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final wallet = group[index];
              final cardIndex = globalIndex + index;
              return _WalletCard(
                wallet: wallet,
                index: cardIndex,
                onEdit: () => _showEditWalletSheet(wallet),
                onDelete: () => _showDeleteConfirmationDialog(wallet),
                onSetDefault: () => _setAsDefault(wallet),
              );
            }, childCount: group.length),
          ),
        ),
      );

      globalIndex += group.length;
    }

    return slivers;
  }

  static IconData _walletTypeIcon(WalletType type) {
    switch (type) {
      case WalletType.cash:
        return Icons.wallet;
      case WalletType.bankAccount:
        return Icons.account_balance;
      case WalletType.creditCard:
        return Icons.credit_card;
      case WalletType.subscription:
        return Icons.subscriptions;
    }
  }

  static String _walletTypeSectionLabel(WalletType type) {
    switch (type) {
      case WalletType.cash:
        return 'CASH';
      case WalletType.bankAccount:
        return 'BANK ACCOUNTS';
      case WalletType.creditCard:
        return 'CREDIT CARDS';
      case WalletType.subscription:
        return 'SUBSCRIPTIONS';
    }
  }

  Widget _buildHeader(List<Wallet> wallets, WalletState walletState) {
    // Calculate total balance (simplified - in real app you'd convert currencies)
    double totalBalance = 0;
    String primaryCurrency = 'USD';

    if (wallets.isNotEmpty) {
      final defaultWallet = wallets.firstWhere(
        (w) => w.isDefault == true,
        orElse: () => wallets.first,
      );
      primaryCurrency = defaultWallet.currency;

      for (final wallet in wallets) {
        final balance = walletState.walletBalances[wallet.id] ?? wallet.balance;
        if (wallet.currency == primaryCurrency) {
          totalBalance += balance;
        } else {
          // For now, just add as-is (proper conversion would need exchange rates)
          totalBalance += balance;
        }
      }
    }

    return AnimatedBuilder(
      animation: _headerAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryAccent.withValues(alpha: 0.3),
                AppColors.primaryDark,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Your Accounts',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        CurrencyInfo.getSymbol(primaryCurrency),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w300,
                          color: AppColors.textPrimary.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppNumberFormatter.get(ref.watch(numberFormatSettingProvider)).format(totalBalance * _headerAnimation.value),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.glassWhite,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${wallets.length} ${wallets.length == 1 ? 'account' : 'accounts'}',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
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
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primaryAccent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                size: 48,
                color: AppColors.primaryAccent,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No accounts yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first account to start\ntracking your finances',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _showAddWalletSheet,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(Wallet wallet) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primarySurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Delete Account',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete "${wallet.name}"? This will also delete all transactions associated with this account.',
            style: TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(walletProvider.notifier).deleteWallet(wallet.id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${wallet.name} deleted'),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _setAsDefault(Wallet wallet) {
    HapticFeedback.lightImpact();
    ref
        .read(walletProvider.notifier)
        .updateWallet(id: wallet.id, isDefault: true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${wallet.name} set as default'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showEditWalletSheet(Wallet wallet) {
    final editNameController = TextEditingController(text: wallet.name);
    final editBalanceController = TextEditingController(
      text: wallet.balance.toString(),
    );
    final editFormKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.primarySurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: AppSpacing.paddingLg,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                AddWalletForm(
                  formKey: editFormKey,
                  nameController: editNameController,
                  balanceController: editBalanceController,
                  initialCurrency: wallet.currency,
                  initialIcon: wallet.iconName,
                  initialColor: wallet.color,
                  initialIsDefault: wallet.isDefault,
                  initialUseDecimals: wallet.useDecimals,
                  initialWalletType: wallet.walletType,
                  initialCreditLimit: wallet.creditLimit,
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
                              balance: double.tryParse(
                                editBalanceController.text,
                              ),
                              iconName: icon,
                              color: color,
                              isDefault: isDefault,
                              useDecimals: useDecimals,
                              creditLimit: creditLimit,
                              billingCycleDay: billingCycleDay,
                            );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Account updated successfully'),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                  onCancel: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Beautiful wallet card with gradient and animations
class _WalletCard extends ConsumerStatefulWidget {
  final Wallet wallet;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _WalletCard({
    required this.wallet,
    required this.index,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  ConsumerState<_WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends ConsumerState<_WalletCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400 + (widget.index * 100)),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 50,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallet = widget.wallet;
    final walletColor = WalletColors.parseColor(wallet.color);
    final walletBalances = ref.watch(walletProvider).walletBalances;
    final balance = walletBalances[wallet.id] ?? wallet.balance;
    final isCreditCard = wallet.walletType == WalletType.creditCard;
    final creditLimit = wallet.creditLimit ?? 0.0;
    final outstanding = isCreditCard ? balance.abs() : 0.0;
    final available = isCreditCard ? (creditLimit - outstanding) : 0.0;
    final usageRatio = isCreditCard && creditLimit > 0
        ? (outstanding / creditLimit).clamp(0.0, 1.0)
        : 0.0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(opacity: _fadeAnimation.value, child: child),
        );
      },
      child: GestureDetector(
        onTap: widget.onEdit,
        onLongPress: () => _showOptionsMenu(context),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                walletColor.withValues(alpha: 0.25),
                walletColor.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: walletColor.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: walletColor.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Background pattern
                Positioned(
                  right: -40,
                  bottom: -40,
                  child: Icon(
                    WalletIcons.getIcon(wallet.iconName),
                    size: 150,
                    color: walletColor.withValues(alpha: 0.08),
                  ),
                ),

                // Shimmer effect on top
                Positioned(
                  top: -50,
                  left: -50,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          walletColor.withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row: Icon + Name + Actions
                      Row(
                        children: [
                          // Icon
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: walletColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              WalletIcons.getIcon(wallet.iconName),
                              color: walletColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Name and currency
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        wallet.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (wallet.isDefault == true) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.warning.withValues(
                                            alpha: 0.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.star_rounded,
                                              size: 12,
                                              color: AppColors.warning,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Default',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.warning,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: walletColor.withValues(
                                          alpha: 0.15,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        wallet.currency,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: walletColor,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    if (wallet.walletType !=
                                        WalletType.cash) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.glassWhite,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          _walletTypeLabel(wallet.walletType),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Options button
                          IconButton(
                            onPressed: () => _showOptionsMenu(context),
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.glassWhite,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.more_vert,
                                color: AppColors.textSecondary,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Credit card specific layout
                      if (isCreditCard && creditLimit > 0) ...[
                        // Outstanding
                        Text(
                          'Outstanding',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              CurrencyInfo.getSymbol(wallet.currency),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              AppNumberFormatter.get(ref.watch(numberFormatSettingProvider), useDecimals: wallet.useDecimals).format(wallet.useDecimals ? outstanding : outstanding.round()),
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Usage progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: usageRatio,
                            backgroundColor: walletColor.withValues(
                              alpha: 0.15,
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              usageRatio > 0.8 ? AppColors.error : walletColor,
                            ),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Available credit + limit
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Available',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                Text(
                                  '${CurrencyInfo.getSymbol(wallet.currency)}${AppNumberFormatter.get(ref.watch(numberFormatSettingProvider), useDecimals: wallet.useDecimals).format(wallet.useDecimals ? available : available.round())}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: available >= 0
                                        ? AppColors.success
                                        : AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Limit',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                Text(
                                  '${CurrencyInfo.getSymbol(wallet.currency)}${AppNumberFormatter.get(ref.watch(numberFormatSettingProvider), useDecimals: wallet.useDecimals).format(wallet.useDecimals ? creditLimit : creditLimit.round())}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Positive balance = overpayment / credit balance
                        if (balance > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'CREDIT BALANCE',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                      ] else ...[
                        // Standard balance display for non-credit-card wallets
                        Text(
                          'Balance',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              CurrencyInfo.getSymbol(wallet.currency),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                                color: balance >= 0
                                    ? AppColors.textPrimary
                                    : AppColors.error,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              AppNumberFormatter.get(ref.watch(numberFormatSettingProvider), useDecimals: wallet.useDecimals).format(wallet.useDecimals ? balance.abs() : balance.abs().round()),
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: balance >= 0
                                    ? AppColors.textPrimary
                                    : AppColors.error,
                                letterSpacing: -0.5,
                              ),
                            ),
                            if (balance < 0)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  bottom: 4,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'OVERDRAWN',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.error,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _walletTypeLabel(WalletType type) {
    switch (type) {
      case WalletType.bankAccount:
        return 'Bank Account';
      case WalletType.creditCard:
        return 'Credit Card';
      case WalletType.subscription:
        return 'Subscription';
      case WalletType.cash:
        return 'Cash';
    }
  }

  void _showOptionsMenu(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Wallet info header
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: WalletColors.parseColor(
                        widget.wallet.color,
                      ).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      WalletIcons.getIcon(widget.wallet.iconName),
                      color: WalletColors.parseColor(widget.wallet.color),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.wallet.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          widget.wallet.currency,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Divider(color: AppColors.divider),
              const SizedBox(height: 10),

              // Options
              _OptionTile(
                icon: Icons.edit_outlined,
                label: 'Edit Account',
                onTap: () {
                  Navigator.pop(context);
                  widget.onEdit();
                },
              ),
              if (widget.wallet.isDefault != true)
                _OptionTile(
                  icon: Icons.star_outline,
                  label: 'Set as Default',
                  onTap: () {
                    Navigator.pop(context);
                    widget.onSetDefault();
                  },
                ),
              _OptionTile(
                icon: Icons.delete_outline,
                label: 'Delete Account',
                isDestructive: true,
                onTap: () {
                  Navigator.pop(context);
                  widget.onDelete();
                },
              ),

              SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : AppColors.textPrimary;

    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    );
  }
}

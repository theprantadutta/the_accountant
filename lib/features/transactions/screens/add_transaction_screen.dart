import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/themes/app_animations.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/shared/widgets/neo_button.dart';
import 'package:the_accountant/shared/widgets/neo_text_field.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart'
    show Wallet, Transaction;
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart'
    hide Transaction;
import 'package:the_accountant/features/transactions/providers/transfer_provider.dart';
import 'package:the_accountant/features/transactions/widgets/calculator_bottom_sheet.dart';
import 'package:the_accountant/features/transactions/widgets/category_picker_sheet.dart';
import 'package:the_accountant/features/transactions/widgets/compact_date_time_picker.dart';
import 'package:the_accountant/features/transactions/widgets/horizontal_chip_selector.dart';
import 'package:the_accountant/features/transactions/widgets/loan_type_chips.dart';
import 'package:the_accountant/features/transactions/widgets/special_type_selector.dart'
    show TransactionSpecialTypeExtension;
import 'package:the_accountant/features/transactions/widgets/transaction_type_header.dart';
import 'package:the_accountant/features/recurring/providers/recurring_provider.dart';
import 'package:the_accountant/features/subscriptions/providers/subscription_dashboard_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

/// Helper function to show the add transaction screen
Future<bool?> showAddTransactionScreen(
  BuildContext context, {
  TransactionTypeSelection initialType = TransactionTypeSelection.expense,
  Transaction? existingTransaction,
  double? prefillAmount,
  String? prefillTitle,
  TransactionSpecialType? initialSpecialType,
}) {
  return Navigator.of(context).push<bool>(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return AddTransactionScreen(
          initialType: initialType,
          existingTransaction: existingTransaction,
          prefillAmount: prefillAmount,
          prefillTitle: prefillTitle,
          initialSpecialType: initialSpecialType,
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    ),
  );
}

/// Single-screen transaction form.
/// All fields visible at once, with inline editing and chip-based selections.
class AddTransactionScreen extends ConsumerStatefulWidget {
  final TransactionTypeSelection initialType;
  final Transaction? existingTransaction;
  final double? prefillAmount;
  final String? prefillTitle;
  final TransactionSpecialType? initialSpecialType;

  const AddTransactionScreen({
    super.key,
    this.initialType = TransactionTypeSelection.expense,
    this.existingTransaction,
    this.prefillAmount,
    this.prefillTitle,
    this.initialSpecialType,
  });

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  // Transaction type
  late TransactionTypeSelection _transactionType;

  // Form fields
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  late FocusNode _titleFocusNode;
  String? _selectedCategoryId;
  Category? _selectedCategory;
  double _amount = 0;
  String? _selectedWalletId;
  DateTime _selectedDateTime = DateTime.now();
  TransactionSpecialType _specialType = TransactionSpecialType.none;
  String? _selectedBudgetId;
  String? _selectedObjectiveId;

  // Subscription config
  String _subscriptionFrequency = 'monthly';
  int _subscriptionPeriodLength = 1;
  DateTime? _subscriptionEndDate;

  // Transfer specific
  String? _fromWalletId;
  String? _toWalletId;

  // UI state
  // final bool _showMoreOptions = false;
  bool _isSaving = false;

  bool get _isEditing => widget.existingTransaction != null;
  bool get _isTransfer => _transactionType == TransactionTypeSelection.transfer;
  bool get _isIncome => _transactionType == TransactionTypeSelection.income;

  Color get _accentColor => _transactionType.color;

  bool get _canSave {
    if (_isTransfer) {
      return _amount > 0 &&
          _fromWalletId != null &&
          _toWalletId != null &&
          _fromWalletId != _toWalletId;
    }
    return _amount > 0 &&
        _selectedCategoryId != null &&
        _selectedWalletId != null;
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _notesController = TextEditingController();
    _titleFocusNode = FocusNode();

    if (_isEditing) {
      _initFromExisting();
    } else {
      _transactionType = widget.initialType;
      _initDefaults();
      // Auto-focus title field only if title is empty
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_titleController.text.isEmpty) {
          _titleFocusNode.requestFocus();
        }
      });
    }
  }

  void _initFromExisting() {
    final t = widget.existingTransaction!;
    // Use isIncome (the authoritative field). `type` is a deprecated column that
    // is always 'regular', so keying off it wrongly forced every edit to Expense.
    _transactionType = t.isIncome
        ? TransactionTypeSelection.income
        : TransactionTypeSelection.expense;
    _titleController.text = t.title;
    _notesController.text = t.notes ?? '';
    _selectedCategoryId = t.categoryId;
    // t.amount is integer cents; the input accumulator works in major-unit dollars.
    _amount = t.amount / 100.0;
    _selectedWalletId = t.walletId;
    _selectedDateTime = t.date;
    // Load category details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategoryDetails();
    });
  }

  void _initDefaults() {
    // Apply prefill values if provided
    if (widget.prefillAmount != null) {
      _amount = widget.prefillAmount!;
    }
    if (widget.prefillTitle != null) {
      _titleController.text = widget.prefillTitle!;
    }
    if (widget.initialSpecialType != null) {
      _specialType = widget.initialSpecialType!;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wallets = ref.read(walletProvider).wallets;
      if (wallets.isNotEmpty) {
        setState(() {
          _selectedWalletId = wallets.first.id;
          _fromWalletId = wallets.first.id;
          if (wallets.length > 1) {
            _toWalletId = wallets[1].id;
          }
        });
      }
    });
  }

  void _loadCategoryDetails() {
    if (_selectedCategoryId != null) {
      final categories = ref.read(categoryProvider).categories;
      final category = categories.firstWhere(
        (c) => c.id == _selectedCategoryId,
        orElse: () => categories.first,
      );
      setState(() {
        _selectedCategory = category;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _onTypeChanged(TransactionTypeSelection type) {
    final wallets = ref.read(walletProvider).wallets;

    if (type == TransactionTypeSelection.transfer && wallets.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'You need at least 2 accounts to make a transfer',
          ),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    HapticFeedback.lightImpact();
    setState(() {
      _transactionType = type;
      _selectedCategoryId = null;
      _selectedCategory = null;
    });
  }

  Future<void> _showCategoryPicker({bool openAmountAfter = false}) async {
    final category = await showCategoryPickerSheet(
      context: context,
      ref: ref,
      isIncome: _isIncome,
      selectedCategoryId: _selectedCategoryId,
      accentColor: _accentColor,
    );

    if (category != null) {
      setState(() {
        _selectedCategoryId = category.id;
        _selectedCategory = category;
      });

      // Auto-open amount input after category selection
      if (openAmountAfter) {
        _showCalculator();
      }
    }
  }

  Future<void> _showCalculator() async {
    final walletId = _isTransfer ? _fromWalletId : _selectedWalletId;
    final wallet = ref
        .read(walletProvider)
        .wallets
        .firstWhere(
          (w) => w.id == walletId,
          orElse: () => ref.read(walletProvider).wallets.first,
        );
    final currencySymbol = CurrencyInfo.getSymbol(wallet.currency);

    final amount = await showCalculatorBottomSheet(
      context: context,
      initialAmount: _amount,
      isIncome: _isIncome,
      currencySymbol: currencySymbol,
      accentColor: _accentColor,
    );

    if (amount != null) {
      setState(() {
        _amount = amount;
      });
    }
  }

  Future<void> _saveTransaction() async {
    if (!_canSave || _isSaving) return;

    setState(() => _isSaving = true);
    HapticFeedback.mediumImpact();

    try {
      if (_isTransfer) {
        await ref
            .read(transferProvider.notifier)
            .createTransfer(
              sourceWalletId: _fromWalletId!,
              destinationWalletId: _toWalletId!,
              amount: (_amount * 100).round(), // dollars -> integer cents
              date: _selectedDateTime,
              title: _titleController.text.isEmpty
                  ? 'Transfer'
                  : _titleController.text,
              notes: _notesController.text.isEmpty
                  ? null
                  : _notesController.text,
            );
      } else if (_isEditing) {
        await ref
            .read(transactionProvider.notifier)
            .updateTransaction(
              id: widget.existingTransaction!.id,
              amount: (_amount * 100).round(), // dollars -> integer cents
              isIncome: _isIncome,
              title: _titleController.text.isEmpty
                  ? null
                  : _titleController.text,
              categoryId: _selectedCategoryId!,
              walletId: _selectedWalletId!,
              date: _selectedDateTime,
              notes: _notesController.text.isEmpty
                  ? null
                  : _notesController.text,
            );
      } else {
        final isPaid = !_specialType.startsUnpaid;

        // Loan types override isIncome for correct balance direction:
        // Credit (lent money) = expense (money going OUT of your wallet)
        // Debt (borrowed money) = income (money coming INTO your wallet)
        final bool effectiveIsIncome;
        if (_specialType == TransactionSpecialType.credit) {
          effectiveIsIncome = false; // Lending = money out
        } else if (_specialType == TransactionSpecialType.debt) {
          effectiveIsIncome = true; // Borrowing = money in
        } else {
          effectiveIsIncome = _isIncome;
        }

        final newTransactionId = await ref
            .read(transactionProvider.notifier)
            .addTransactionFull(
              amount: (_amount * 100).round(), // dollars -> integer cents
              isIncome: effectiveIsIncome,
              categoryId: _selectedCategoryId!,
              walletId: _selectedWalletId!,
              dateTime: _selectedDateTime,
              title: _titleController.text.isEmpty
                  ? null
                  : _titleController.text,
              notes: _notesController.text.isEmpty
                  ? null
                  : _notesController.text,
              specialType: _specialType,
              isPaid: isPaid,
              originalDueDate: _specialType.requiresDueDate
                  ? _selectedDateTime
                  : null,
              budgetId: _selectedBudgetId,
              objectiveId: _selectedObjectiveId,
            );

        // Create RecurringConfig for subscriptions and repetitive transactions
        if ((_specialType == TransactionSpecialType.subscription ||
                _specialType == TransactionSpecialType.repetitive) &&
            newTransactionId != null) {
          final recurringService = ref.read(recurringServiceProvider);
          await recurringService.createRecurringConfig(
            baseTransactionId: newTransactionId,
            reoccurrence: _subscriptionFrequency,
            periodLength: _subscriptionPeriodLength,
            startDate: _selectedDateTime,
            endDate: _subscriptionEndDate,
          );
          ref.read(subscriptionDashboardProvider.notifier).refresh();
        }
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _deleteTransaction() async {
    if (!_isEditing) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primarySurface,
        title: Text(
          'Delete Transaction',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete this transaction?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(transactionProvider.notifier)
          .deleteTransaction(widget.existingTransaction!.id);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallets = ref.watch(walletProvider).wallets;
    final canTransfer = wallets.length >= 2;

    // Get currency symbol for current wallet
    final walletId = _isTransfer ? _fromWalletId : _selectedWalletId;
    String currencySymbol = '\$'; // Default
    if (wallets.isNotEmpty) {
      final currentWallet = wallets.firstWhere(
        (w) => w.id == walletId,
        orElse: () => wallets.first,
      );
      currencySymbol = CurrencyInfo.getSymbol(currentWallet.currency);
    }

    return _buildAmbient(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(_isEditing ? 'Edit Transaction' : 'New Transaction'),
          actions: [
            if (_isEditing)
              IconButton(
                icon: Icon(Icons.delete_outline, color: AppColors.error),
                onPressed: _deleteTransaction,
              ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),

                    // Hero: type toggle + amount + category
                    _buildHero(canTransfer, currencySymbol),
                    const SizedBox(height: 20),

                    // Date/Time picker
                    CompactDateTimePicker(
                      selectedDateTime: _selectedDateTime,
                      onDateTimeChanged: (dateTime) {
                        setState(() => _selectedDateTime = dateTime);
                      },
                      accentColor: _accentColor,
                      dateFormat: ref.watch(dateFormatSettingProvider),
                    ),
                    const SizedBox(height: 16),

                    // Title input
                    _buildTitleInput(),
                    const SizedBox(height: 12),

                    // Notes input
                    _buildNotesInput(),
                    const SizedBox(height: 20),

                    if (_isTransfer) ...[
                      // Transfer: From/To wallet selectors
                      _buildTransferWalletSelectors(wallets),
                    ] else ...[
                      // Regular transaction sections
                      // Special type chips (Default, Upcoming, Subscription)
                      _buildSpecialTypeChips(),
                      if (_specialType == TransactionSpecialType.subscription ||
                          _specialType == TransactionSpecialType.repetitive)
                        _buildSubscriptionConfigSection(),
                      const SizedBox(height: 16),

                      // Wallet chips
                      _buildWalletChips(wallets),
                      const SizedBox(height: 16),

                      // Loan type chips
                      LoanTypeChips(
                        selectedType: _specialType,
                        onTypeChanged: (type) {
                          setState(() => _specialType = type);
                        },
                        accentColor: _accentColor,
                      ),
                    ],
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            // Save button (sticky at bottom)
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  /// Gradient for the current transaction type — drives the save button and the
  /// sliding type-selector pill.
  Gradient get _typeGradient {
    switch (_transactionType) {
      case TransactionTypeSelection.income:
        return AppColors.successGradient;
      case TransactionTypeSelection.expense:
        return AppColors.errorGradient;
      case TransactionTypeSelection.transfer:
        return const LinearGradient(
          colors: [AppColors.neonCyan, AppColors.neonBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  /// The base app gradient with a couple of faint, neutral (indigo/purple) glow
  /// orbs — the same calm ambience as the rest of the app. The transaction's
  /// colour is carried by the amount, the active toggle label and the save
  /// button, not by bathing the whole screen.
  Widget _buildAmbient({required Widget child}) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -100,
            child: _glowOrb(AppColors.primaryGlow, 260, 0.06),
          ),
          Positioned(
            bottom: -150,
            left: -110,
            child: _glowOrb(AppColors.neonPurple, 300, 0.05),
          ),
          child,
        ],
      ),
    );
  }

  Widget _glowOrb(Color color, double size, double alpha) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: alpha),
              color.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }

  /// Hero card: the type toggle, the big amount, and (for non-transfers) the
  /// category selector — all tinted to the current transaction type.
  Widget _buildHero(bool canTransfer, String currencySymbol) {
    return AnimatedContainer(
      duration: AppAnimations.normal,
      curve: AppAnimations.easeOut,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.glassGradient,
        borderRadius: AppSpacing.borderRadiusXl,
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.glassShadow,
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTypeSelector(canTransfer),
          const SizedBox(height: 24),
          _buildAmountDisplay(currencySymbol),
          if (!_isTransfer) ...[
            const SizedBox(height: 18),
            Center(child: _buildCategoryChip()),
          ],
        ],
      ),
    );
  }

  /// Income / Expense / Transfer as three equal chips — same chip language as the
  /// rest of the screen (the selected one is tinted in its own colour, the others
  /// are plain glass), so it reads clearly as a three-way switch.
  Widget _buildTypeSelector(bool canTransfer) {
    final types = (canTransfer && !_isEditing)
        ? TransactionTypeSelection.values
        : [TransactionTypeSelection.expense, TransactionTypeSelection.income];

    return Row(
      children: [
        for (var i = 0; i < types.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(child: _typeChip(types[i])),
        ],
      ],
    );
  }

  Widget _typeChip(TransactionTypeSelection type) {
    final isSelected = type == _transactionType;
    final color = type.color;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onTypeChanged(type),
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        curve: AppAnimations.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : AppColors.glassWhite,
          borderRadius: AppSpacing.borderRadiusFull,
          border: Border.all(
            color: isSelected ? color : AppColors.glassBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type.icon,
              size: 16,
              color: isSelected ? color : AppColors.textMuted,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                type.label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? color : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Big, tappable monospace amount — the screen's hero input.
  Widget _buildAmountDisplay(String currencySymbol) {
    final hasAmount = _amount > 0;
    final sign = _isTransfer ? '' : (_isIncome ? '+' : '−');
    final color = hasAmount ? _accentColor : AppColors.textMuted;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.selectionClick();
        _showCalculator();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$sign$currencySymbol',
                  style: AppTypography.monoMedium.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _formatAmount(_amount),
                  style: AppTypography.monoLarge.copyWith(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasAmount ? 'Tap to edit amount' : 'Tap to enter amount',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Inline category selector pill inside the hero (non-transfer only).
  Widget _buildCategoryChip() {
    final hasCategory = _selectedCategory != null;
    final categoryColor = hasCategory && _selectedCategory!.colorCode.isNotEmpty
        ? _parseHexColor(_selectedCategory!.colorCode)
        : _accentColor;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        _showCategoryPicker();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          borderRadius: AppSpacing.borderRadiusFull,
          border: Border.all(
            color: hasCategory
                ? categoryColor.withValues(alpha: 0.45)
                : AppColors.glassBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                hasCategory && _selectedCategory!.iconName != null
                    ? IconRegistry.getIcon(_selectedCategory!.iconName!)
                    : Icons.category_outlined,
                size: 16,
                color: categoryColor,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              hasCategory ? _selectedCategory!.name : 'Select category',
              style: AppTypography.titleSmall.copyWith(
                color: hasCategory
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.expand_more, size: 18, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  /// Format an amount with thousand separators, hiding a trailing `.00`.
  String _formatAmount(double amount) {
    if (amount == 0) return '0';
    final parts = amount.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];
    final buffer = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) buffer.write(',');
      buffer.write(intPart[i]);
    }
    if (decPart != '00') {
      buffer.write('.');
      buffer.write(decPart);
    }
    return buffer.toString();
  }

  Color _parseHexColor(String code) {
    try {
      if (code.startsWith('#')) {
        return Color(int.parse(code.substring(1), radix: 16) | 0xFF000000);
      }
    } catch (_) {}
    return _accentColor;
  }

  Widget _buildSpecialTypeChips() {
    final types = [
      TransactionSpecialType.none,
      TransactionSpecialType.upcoming,
      TransactionSpecialType.subscription,
      TransactionSpecialType.repetitive,
    ];

    // Don't show if a loan type is selected
    if (_specialType == TransactionSpecialType.credit ||
        _specialType == TransactionSpecialType.debt) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                'Transaction Type',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          HorizontalChipSelector<TransactionSpecialType>(
            items: types,
            selectedItem: _specialType,
            labelBuilder: (type) {
              switch (type) {
                case TransactionSpecialType.none:
                  return 'Default';
                case TransactionSpecialType.upcoming:
                  return 'Upcoming';
                case TransactionSpecialType.subscription:
                  return 'Subscription';
                case TransactionSpecialType.repetitive:
                  return 'Repetitive';
                default:
                  return type.label;
              }
            },
            colorBuilder: (type) => _accentColor,
            onSelected: (type) {
              setState(() => _specialType = type);
            },
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionConfigSection() {
    final isRepetitive = _specialType == TransactionSpecialType.repetitive;
    final sectionColor = isRepetitive
        ? AppColors.neonBlue
        : AppColors.neonPurple;
    final sectionIcon = isRepetitive ? Icons.repeat : Icons.autorenew;
    final sectionTitle = isRepetitive
        ? 'Repeat Settings'
        : 'Subscription Settings';
    final frequencies = ['daily', 'weekly', 'monthly', 'yearly'];

    String frequencyLabel(String freq) {
      switch (freq) {
        case 'daily':
          return 'Daily';
        case 'weekly':
          return 'Weekly';
        case 'monthly':
          return 'Monthly';
        case 'yearly':
          return 'Yearly';
        default:
          return freq;
      }
    }

    String periodUnit(String freq) {
      switch (freq) {
        case 'daily':
          return _subscriptionPeriodLength == 1 ? 'day' : 'days';
        case 'weekly':
          return _subscriptionPeriodLength == 1 ? 'week' : 'weeks';
        case 'monthly':
          return _subscriptionPeriodLength == 1 ? 'month' : 'months';
        case 'yearly':
          return _subscriptionPeriodLength == 1 ? 'year' : 'years';
        default:
          return freq;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(sectionIcon, size: 16, color: sectionColor),
              const SizedBox(width: 6),
              Text(
                sectionTitle,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: sectionColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Frequency chips
          HorizontalChipSelector<String>(
            items: frequencies,
            selectedItem: _subscriptionFrequency,
            labelBuilder: frequencyLabel,
            colorBuilder: (_) => sectionColor,
            onSelected: (freq) {
              setState(() => _subscriptionFrequency = freq);
            },
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 12),
          // Period stepper
          Row(
            children: [
              Text(
                'Every',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _subscriptionPeriodLength > 1
                    ? () => setState(() => _subscriptionPeriodLength--)
                    : null,
                icon: Icon(Icons.remove_circle_outline, size: 22),
                color: AppColors.textSecondary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              Container(
                width: 36,
                alignment: Alignment.center,
                child: Text(
                  '$_subscriptionPeriodLength',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: _subscriptionPeriodLength < 365
                    ? () => setState(() => _subscriptionPeriodLength++)
                    : null,
                icon: Icon(Icons.add_circle_outline, size: 22),
                color: AppColors.textSecondary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              const SizedBox(width: 4),
              Text(
                periodUnit(_subscriptionFrequency),
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // End date
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate:
                    _subscriptionEndDate ??
                    DateTime.now().add(const Duration(days: 365)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 3650)),
              );
              if (date != null) {
                setState(() => _subscriptionEndDate = date);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: sectionColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: sectionColor.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.event, size: 18, color: AppColors.textMuted),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _subscriptionEndDate != null
                          ? 'Ends: ${_subscriptionEndDate!.day}/${_subscriptionEndDate!.month}/${_subscriptionEndDate!.year}'
                          : 'No end date',
                      style: TextStyle(
                        fontSize: 14,
                        color: _subscriptionEndDate != null
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                  if (_subscriptionEndDate != null)
                    GestureDetector(
                      onTap: () => setState(() => _subscriptionEndDate = null),
                      child: Icon(
                        Icons.clear,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletChips(List<Wallet> wallets) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 16,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                'Account',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          HorizontalChipSelector<Wallet>(
            items: wallets,
            selectedItem: wallets.firstWhere(
              (w) => w.id == _selectedWalletId,
              orElse: () => wallets.first,
            ),
            labelBuilder: (wallet) => '${wallet.name} (${wallet.currency})',
            onSelected: (wallet) {
              setState(() => _selectedWalletId = wallet.id);
            },
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildTransferWalletSelectors(List<Wallet> wallets) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // From wallet
          Row(
            children: [
              Icon(Icons.arrow_upward, size: 16, color: AppColors.error),
              const SizedBox(width: 6),
              Text(
                'From Account',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          HorizontalChipSelector<Wallet>(
            items: wallets.where((w) => w.id != _toWalletId).toList(),
            selectedItem: wallets.firstWhere(
              (w) => w.id == _fromWalletId,
              orElse: () => wallets.first,
            ),
            labelBuilder: (wallet) => '${wallet.name} (${wallet.currency})',
            onSelected: (wallet) {
              setState(() => _fromWalletId = wallet.id);
            },
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 12),

          // Arrow indicator
          Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _accentColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_downward, color: _accentColor, size: 20),
            ),
          ),
          const SizedBox(height: 12),

          // To wallet
          Row(
            children: [
              Icon(Icons.arrow_downward, size: 16, color: AppColors.success),
              const SizedBox(width: 6),
              Text(
                'To Account',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          HorizontalChipSelector<Wallet>(
            items: wallets.where((w) => w.id != _fromWalletId).toList(),
            selectedItem: wallets.firstWhere(
              (w) => w.id == _toWalletId,
              orElse: () => wallets.last,
            ),
            labelBuilder: (wallet) => '${wallet.name} (${wallet.currency})',
            onSelected: (wallet) {
              setState(() => _toWalletId = wallet.id);
            },
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildTitleInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: NeoTextField(
        controller: _titleController,
        focusNode: _titleFocusNode,
        label: 'Title',
        hint: _isTransfer ? 'e.g. Move to savings' : 'What was it for?',
        prefixIcon: Icons.edit_outlined,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) {
          // After title is submitted, open category picker (then amount)
          if (!_isTransfer && _selectedCategoryId == null) {
            _showCategoryPicker(openAmountAfter: true);
          } else if (!_isTransfer && _amount == 0) {
            // Category already selected, just open amount
            _showCalculator();
          }
        },
      ),
    );
  }

  Widget _buildNotesInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: NeoTextField(
        controller: _notesController,
        label: 'Notes',
        hint: 'Add a note (optional)',
        prefixIcon: Icons.notes_outlined,
        maxLines: 3,
        minLines: 1,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: SafeArea(
        top: false,
        child: NeoButton(
          label: _isEditing ? 'Update' : (_isTransfer ? 'Transfer' : 'Save'),
          onPressed: _canSave && !_isSaving ? _saveTransaction : null,
          isLoading: _isSaving,
          isExpanded: true,
          size: NeoButtonSize.large,
          gradient: _typeGradient,
          trailingIcon: _isTransfer
              ? Icons.swap_horiz_rounded
              : Icons.check_rounded,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/themes/app_animations.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/features/ai/screens/receipt_scanner_screen.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
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
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/objectives/providers/objectives_provider.dart';
import 'package:the_accountant/features/transactions/providers/payment_method_provider.dart';

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
  String? _selectedPaymentMethodId;

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

  /// The colour of the money: red out, green in, cyan across.
  ///
  /// Reserved for what actually expresses direction — the amount, the type
  /// toggle, the sheets used to enter an amount or pick its category, and the
  /// button that commits it.
  Color get _accentColor => _transactionType.color;

  /// The colour of the form itself.
  ///
  /// This was [_accentColor] too, which meant that on the screen you see by
  /// default — a new expense — the date picker and every chip and selector were
  /// drawn in the app's error red. An empty form looked like one that had
  /// already failed validation. The date a purchase happened is not an expense,
  /// so it is not coloured like one.
  Color get _chromeAccent => AppColors.primaryAccent;

  /// Transfer fee in major units. Zero for almost every transfer, which is why
  /// the controls for it stay folded away until asked for.
  double _feeAmount = 0;

  /// Which wallet the charge came out of. Defaults to the source wallet, but a
  /// provider can bill it somewhere else entirely.
  String? _feeWalletId;

  bool _showFeeFields = false;

  bool get _canSave {
    if (_isTransfer) {
      // No title needed. A transfer already says what it is — the two accounts
      // name it better than any words the user would type, and one falls back
      // to "Transfer" anyway.
      return _amount > 0 &&
          _fromWalletId != null &&
          _toWalletId != null &&
          _fromWalletId != _toWalletId;
    }
    // Income and expenses do need one. A month of rows that all read as their
    // category name is a list you cannot recognise anything in, and the title
    // is the only field that says which coffee, which invoice, which shop.
    return _amount > 0 &&
        _titleController.text.trim().isNotEmpty &&
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

  /// Open the premium receipt scanner and prefill this form from the result.
  /// Free users get a focused upgrade prompt instead.
  Future<void> _scanReceipt() async {
    HapticFeedback.lightImpact();

    if (!ref.read(premiumProvider).isPremium) {
      _showScanUpgradeDialog();
      return;
    }

    final result = await Navigator.of(context).push<ReceiptScanResult>(
      MaterialPageRoute(
        builder: (_) => const ReceiptScannerScreenGated(returnResult: true),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _amount = result.amount;
        if (result.title.trim().isNotEmpty) {
          _titleController.text = result.title.trim();
        }
      });
    }
  }

  void _showScanUpgradeDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.primaryDark,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryAccent.withValues(alpha: 0.4),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.document_scanner_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Scan receipts',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Snap a photo and we'll auto-fill the amount and merchant. "
                "It's a Premium feature.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              _scanUpgradeBullet(Icons.bolt, 'Auto-fills amount & merchant'),
              const SizedBox(height: 10),
              _scanUpgradeBullet(
                Icons.timer_outlined,
                'Log an expense in seconds',
              ),
              const SizedBox(height: 24),
              NeoButton(
                label: 'Go Premium',
                leadingIcon: Icons.workspace_premium,
                isExpanded: true,
                onPressed: () {
                  Navigator.pop(dialogContext);
                  Navigator.pushNamed(context, '/premium');
                },
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  'Not now',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scanUpgradeBullet(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primaryAccent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: AppColors.primaryAccent, size: 17),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13.5),
          ),
        ),
      ],
    );
  }

  void _initFromExisting() {
    final t = widget.existingTransaction!;
    // A transfer is a paired two-leg record: editing it must edit BOTH legs, so
    // the form opens in transfer mode and saves through the paired operation.
    final isTransferRow = TransactionPolicy.isTransfer(t);
    // Use isIncome (the authoritative field). `type` is a deprecated column that
    // is always 'regular', so keying off it wrongly forced every edit to Expense.
    _transactionType = isTransferRow
        ? TransactionTypeSelection.transfer
        : (t.isIncome
              ? TransactionTypeSelection.income
              : TransactionTypeSelection.expense);
    _titleController.text = t.title;
    _notesController.text = t.notes ?? '';
    _selectedCategoryId = t.categoryId;
    // t.amount is integer cents; the input accumulator works in major-unit dollars.
    _amount = t.amount / 100.0;
    _selectedWalletId = t.walletId;
    _selectedDateTime = t.date;
    // Restore the special type and assignment links so edit shows the real state.
    _specialType = t.specialType ?? TransactionSpecialType.none;
    _selectedBudgetId = t.budgetId;
    _selectedObjectiveId = t.objectiveId;
    _selectedPaymentMethodId = t.paymentMethodId;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (isTransferRow) {
        // Resolve both sides of the pair so the wallet pickers show the real
        // source and destination regardless of which leg was tapped.
        final paired = await ref
            .read(transferServiceProvider)
            .getPairedTransaction(t.id);
        if (!mounted) return;
        setState(() {
          if (t.isIncome) {
            _toWalletId = t.walletId;
            _fromWalletId = paired?.walletId;
          } else {
            _fromWalletId = t.walletId;
            _toWalletId = paired?.walletId;
          }
        });
        return;
      }
      _loadCategoryDetails();
      // For subscription/repetitive, restore the recurring schedule from its config.
      if (_specialType == TransactionSpecialType.subscription ||
          _specialType == TransactionSpecialType.repetitive) {
        final config = await ref
            .read(recurringServiceProvider)
            .getRecurringConfigByBaseTransactionId(t.id);
        if (config != null && mounted) {
          setState(() {
            _subscriptionFrequency = config.reoccurrence;
            _subscriptionPeriodLength = config.periodLength;
            _subscriptionEndDate = config.endDate;
          });
        }
      }
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
      if (_isTransfer && _isEditing) {
        // Paired update: both legs change together inside one database
        // transaction, preserving reciprocal ids, equal amounts, and opposite
        // directions.
        await ref
            .read(transactionProvider.notifier)
            .updateTransfer(
              id: widget.existingTransaction!.id,
              amount: (_amount * 100).round(), // dollars -> integer cents
              date: _selectedDateTime,
              title: _titleController.text.isEmpty
                  ? 'Transfer'
                  : _titleController.text,
              notes: _notesController.text.isEmpty
                  ? null
                  : _notesController.text,
              sourceWalletId: _fromWalletId,
              destinationWalletId: _toWalletId,
            );
      } else if (_isTransfer) {
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
              feeAmount: (_feeAmount * 100).round(),
              feeWalletId: _feeWalletId ?? _fromWalletId,
            );
      } else if (_isEditing) {
        final isPaid = !_specialType.startsUnpaid;
        // Loan types override isIncome for correct balance direction (same as add).
        final bool effectiveIsIncome;
        if (_specialType == TransactionSpecialType.credit) {
          effectiveIsIncome = false;
        } else if (_specialType == TransactionSpecialType.debt) {
          effectiveIsIncome = true;
        } else {
          effectiveIsIncome = _isIncome;
        }

        await ref
            .read(transactionProvider.notifier)
            .updateTransaction(
              id: widget.existingTransaction!.id,
              amount: (_amount * 100).round(), // dollars -> integer cents
              isIncome: effectiveIsIncome,
              title: _titleController.text.isEmpty
                  ? null
                  : _titleController.text,
              categoryId: _selectedCategoryId!,
              walletId: _selectedWalletId!,
              date: _selectedDateTime,
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
              paymentMethodId: _selectedPaymentMethodId,
            );

        // Create/update/remove the recurring config to match the new special type.
        await _reconcileRecurringConfig(widget.existingTransaction!.id);
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
              paymentMethodId: _selectedPaymentMethodId,
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

  /// Reconcile the transaction's recurring config after an edit so it matches the
  /// current special type: create when it became subscription/repetitive, update
  /// the schedule when it stays one, and remove it when it no longer is.
  Future<void> _reconcileRecurringConfig(String transactionId) async {
    final recurringService = ref.read(recurringServiceProvider);
    final existingConfig = await recurringService
        .getRecurringConfigByBaseTransactionId(transactionId);
    final isRecurringType =
        _specialType == TransactionSpecialType.subscription ||
        _specialType == TransactionSpecialType.repetitive;

    if (isRecurringType) {
      if (existingConfig != null) {
        await recurringService.updateRecurringConfig(
          configId: existingConfig.id,
          reoccurrence: _subscriptionFrequency,
          periodLength: _subscriptionPeriodLength,
          endDate: _subscriptionEndDate,
        );
      } else {
        await recurringService.createRecurringConfig(
          baseTransactionId: transactionId,
          reoccurrence: _subscriptionFrequency,
          periodLength: _subscriptionPeriodLength,
          startDate: _selectedDateTime,
          endDate: _subscriptionEndDate,
        );
      }
    } else if (existingConfig != null) {
      // No longer recurring — drop the config (also clears isRecurring on the base).
      await recurringService.deleteRecurringConfig(existingConfig.id);
    }
    ref.read(subscriptionDashboardProvider.notifier).refresh();
  }

  IconData _paymentMethodIcon(String type) {
    switch (type) {
      case 'card':
        return Icons.credit_card;
      case 'bank':
        return Icons.account_balance;
      case 'cash':
        return Icons.payments;
      case 'digital_wallet':
        return Icons.account_balance_wallet;
      default:
        return Icons.payment;
    }
  }

  /// A "pick one or None" chip row. Returns nothing when the user has no items.
  Widget _optionalLinkSelector({
    required String label,
    required IconData labelIcon,
    required List<String> ids,
    required String Function(String id) nameOf,
    required String? selectedId,
    required ValueChanged<String?> onSelected,
    IconData? Function(String id)? iconOf,
  }) {
    if (ids.isEmpty) return const SizedBox.shrink();
    final items = <String?>[null, ...ids];
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: LabeledChipSection<String?>(
        label: label,
        labelIcon: labelIcon,
        items: items,
        selectedItem: selectedId,
        labelBuilder: (id) => id == null ? 'None' : nameOf(id),
        iconBuilder: iconOf == null
            ? null
            : (id) => id == null ? Icons.block : iconOf(id),
        colorBuilder: (id) => id == null ? AppColors.textMuted : _chromeAccent,
        onSelected: onSelected,
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    final methods = ref.watch(paymentMethodProvider).paymentMethods;
    return _optionalLinkSelector(
      label: 'Payment Method',
      labelIcon: Icons.credit_card_outlined,
      ids: methods.map((m) => m.id).toList(),
      nameOf: (id) => methods
          .firstWhere((m) => m.id == id, orElse: () => methods.first)
          .name,
      iconOf: (id) => _paymentMethodIcon(
        methods.firstWhere((m) => m.id == id, orElse: () => methods.first).type,
      ),
      selectedId: _selectedPaymentMethodId,
      onSelected: (id) => setState(() => _selectedPaymentMethodId = id),
    );
  }

  Widget _buildBudgetSelector() {
    final budgets = ref.watch(budgetProvider).budgets;
    return _optionalLinkSelector(
      label: 'Budget',
      labelIcon: Icons.pie_chart_outline,
      ids: budgets.map((b) => b.id).toList(),
      nameOf: (id) => budgets
          .firstWhere((b) => b.id == id, orElse: () => budgets.first)
          .name,
      selectedId: _selectedBudgetId,
      onSelected: (id) => setState(() => _selectedBudgetId = id),
    );
  }

  Widget _buildObjectiveSelector() {
    final objectives = ref.watch(activeObjectivesProvider).asData?.value ?? [];
    return _optionalLinkSelector(
      label: 'Objective',
      labelIcon: Icons.flag_outlined,
      ids: objectives.map((o) => o.objective.id).toList(),
      nameOf: (id) => objectives
          .firstWhere(
            (o) => o.objective.id == id,
            orElse: () => objectives.first,
          )
          .name,
      selectedId: _selectedObjectiveId,
      onSelected: (id) => setState(() => _selectedObjectiveId = id),
    );
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

    // The ambient background is painted once for the whole app in
    // `MaterialApp.builder`. This screen used to stack its own copy of the same
    // gradient and orbs on top of it, which is a large part of why it read as a
    // different app from the ones either side of it.
    return Scaffold(
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
          if (!_isEditing)
            Padding(
              padding: EdgeInsets.only(right: AppSpacing.sm),
              child: Center(
                child: TextButton.icon(
                  onPressed: _scanReceipt,
                  icon: const Icon(Icons.document_scanner_outlined, size: 18),
                  label: const Text('Scan'),
                ),
              ),
            ),
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
                  AppSpacing.gapXs,

                  // Hero: type toggle + amount + category
                  _buildHero(canTransfer, currencySymbol),
                  AppSpacing.gapXl,

                  // Date/Time picker
                  CompactDateTimePicker(
                    selectedDateTime: _selectedDateTime,
                    onDateTimeChanged: (dateTime) {
                      setState(() => _selectedDateTime = dateTime);
                    },
                    accentColor: _chromeAccent,
                    dateFormat: ref.watch(dateFormatSettingProvider),
                  ),
                  AppSpacing.gapLg,

                  // Title input
                  _buildTitleInput(),
                  AppSpacing.gapMd,

                  // Notes input
                  _buildNotesInput(),
                  AppSpacing.gapXl,

                  if (_isTransfer) ...[
                    // Transfer: From/To wallet selectors
                    _buildTransferWalletSelectors(wallets, currencySymbol),
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
                      accentColor: _chromeAccent,
                    ),

                    // Optional links (hidden when the user has none)
                    _buildPaymentMethodSelector(),
                    _buildBudgetSelector(),
                    _buildObjectiveSelector(),
                  ],
                  AppSpacing.gapMd,
                ],
              ),
            ),
          ),

          // Save button (sticky at bottom)
          _buildSaveButton(),
        ],
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

  /// Hero card: the type toggle, the big amount, and (for non-transfers) the
  /// category selector — all tinted to the current transaction type.
  Widget _buildHero(bool canTransfer, String currencySymbol) {
    return AnimatedContainer(
      duration: AppAnimations.normal,
      curve: AppAnimations.easeOut,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.xl),
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
          AppSpacing.gapXxl,
          _buildAmountDisplay(currencySymbol),
          if (!_isTransfer) ...[
            AppSpacing.gapLg,
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
          if (i > 0) AppSpacing.gapHSm,
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
        // Horizontal padding as well as vertical: at three across, "Transfer"
        // ran the full width of its chip and read as cramped.
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.md,
        ),
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
              size: AppSpacing.iconXs,
              color: isSelected ? color : AppColors.textMuted,
            ),
            AppSpacing.gapHXs,
            Flexible(
              child: Text(
                type.label,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelMedium.copyWith(
                  letterSpacing: 0.2,
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
          AppSpacing.gapSm,
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
        : _chromeAccent;

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
    return _chromeAccent;
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
            colorBuilder: (type) => _chromeAccent,
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

  /// Where the money leaves from, where it lands, and what the move cost.
  ///
  /// The two account pickers keep their red/green markers because those say
  /// something true — money out, money in. Everything else here is neutral, so
  /// that the only colour on an untouched form belongs to the money.
  Widget _buildTransferWalletSelectors(
    List<Wallet> wallets,
    String currencySymbol,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _transferFieldLabel(
            'From account',
            Icons.arrow_upward,
            AppColors.error,
          ),
          AppSpacing.gapSm,
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
          AppSpacing.gapMd,

          Center(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: _chromeAccent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_downward,
                color: _chromeAccent,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          AppSpacing.gapMd,

          _transferFieldLabel(
            'To account',
            Icons.arrow_downward,
            AppColors.success,
          ),
          AppSpacing.gapSm,
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
          // Only offered when creating. Editing a transfer updates the pair and
          // nothing else, so a fee control here would look like it saved
          // something when it did not.
          if (!_isEditing) ...[
            AppSpacing.gapLg,
            _buildTransferFeeSection(wallets, currencySymbol),
          ],
        ],
      ),
    );
  }

  Widget _transferFieldLabel(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: AppSpacing.iconXs, color: color),
        AppSpacing.gapHSm,
        Text(
          text,
          style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }

  /// What the transfer cost to make, folded away until there is a cost.
  ///
  /// Most transfers are free, so this starts as a single quiet line rather than
  /// a pair of empty fields competing with the two things the screen is for. A
  /// fee is recorded as its own expense on whichever wallet the provider took
  /// it from, never subtracted from the transfer: moving your own money leaves
  /// you no worse off, so the two legs must stay equal, while a charge does
  /// leave you worse off and has to be accounted for somewhere real.
  Widget _buildTransferFeeSection(List<Wallet> wallets, String currencySymbol) {
    if (!_showFeeFields) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => setState(() => _showFeeFields = true),
          icon: const Icon(Icons.add, size: AppSpacing.iconXs),
          label: const Text('Add a transfer fee'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
        ),
      );
    }

    // Where the charge lands. Usually the wallet the money left, but a provider
    // can bill it somewhere else entirely, so it is asked for separately.
    final chargedTo = wallets.firstWhere(
      (w) => w.id == (_feeWalletId ?? _fromWalletId),
      orElse: () => wallets.first,
    );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Transfer fee', style: AppTypography.titleSmall),
              ),
              TextButton(
                onPressed: () => setState(() {
                  _showFeeFields = false;
                  _feeAmount = 0;
                  _feeWalletId = null;
                }),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textMuted,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
                child: const Text('Remove'),
              ),
            ],
          ),
          Text(
            'Charged separately, so the transfer itself stays balanced.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          AppSpacing.gapMd,

          InkWell(
            onTap: () => _showFeeCalculator(currencySymbol),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: AppSpacing.iconSm,
                    color: AppColors.textMuted,
                  ),
                  AppSpacing.gapHMd,
                  Expanded(
                    child: Text(
                      'Amount',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Text(
                    '$currencySymbol${_feeAmount.toStringAsFixed(2)}',
                    style: AppTypography.monoMedium.copyWith(
                      color: _feeAmount > 0
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.gapSm,

          Text(
            'Deducted from',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          AppSpacing.gapSm,
          HorizontalChipSelector<Wallet>(
            items: wallets,
            selectedItem: chargedTo,
            labelBuilder: (wallet) => '${wallet.name} (${wallet.currency})',
            onSelected: (wallet) {
              setState(() => _feeWalletId = wallet.id);
            },
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Future<void> _showFeeCalculator(String currencySymbol) async {
    final amount = await showCalculatorBottomSheet(
      context: context,
      initialAmount: _feeAmount,
      isIncome: false,
      currencySymbol: currencySymbol,
      accentColor: AppColors.warning,
    );

    if (amount != null) {
      setState(() => _feeAmount = amount);
    }
  }

  Widget _buildTitleInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: NeoTextField(
        controller: _titleController,
        focusNode: _titleFocusNode,
        label: 'Title',
        hint: _isTransfer
            ? 'e.g. Move to savings (optional)'
            : 'What was it for?',
        onChanged: (_) => setState(() {}),
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

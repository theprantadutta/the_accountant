import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart'
    show Wallet, Transaction;
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart'
    hide Transaction;
import 'package:the_accountant/features/transactions/providers/transfer_provider.dart';
import 'package:the_accountant/features/transactions/widgets/calculator_bottom_sheet.dart';
import 'package:the_accountant/features/transactions/widgets/category_amount_header.dart';
import 'package:the_accountant/features/transactions/widgets/category_picker_sheet.dart';
import 'package:the_accountant/features/transactions/widgets/compact_date_time_picker.dart';
import 'package:the_accountant/features/transactions/widgets/horizontal_chip_selector.dart';
import 'package:the_accountant/features/transactions/widgets/loan_type_chips.dart';
import 'package:the_accountant/features/transactions/widgets/special_type_selector.dart'
    show TransactionSpecialTypeExtension;
import 'package:the_accountant/features/transactions/widgets/transaction_type_header.dart';
import 'package:the_accountant/features/transactions/widgets/transfer_amount_header.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

/// Helper function to show the Cashew-style transaction screen
Future<bool?> showCashewTransactionScreen(
  BuildContext context, {
  TransactionTypeSelection initialType = TransactionTypeSelection.expense,
  Transaction? existingTransaction,
}) {
  return Navigator.of(context).push<bool>(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return CashewTransactionScreen(
          initialType: initialType,
          existingTransaction: existingTransaction,
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

/// Cashew-style single-screen transaction form.
/// All fields visible at once, with inline editing and chip-based selections.
class CashewTransactionScreen extends ConsumerStatefulWidget {
  final TransactionTypeSelection initialType;
  final Transaction? existingTransaction;

  const CashewTransactionScreen({
    super.key,
    this.initialType = TransactionTypeSelection.expense,
    this.existingTransaction,
  });

  @override
  ConsumerState<CashewTransactionScreen> createState() =>
      _CashewTransactionScreenState();
}

class _CashewTransactionScreenState
    extends ConsumerState<CashewTransactionScreen> {
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
      // Auto-focus title field for new transactions
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _titleFocusNode.requestFocus();
      });
    }
  }

  void _initFromExisting() {
    final t = widget.existingTransaction!;
    _transactionType = t.type == 'income'
        ? TransactionTypeSelection.income
        : TransactionTypeSelection.expense;
    _titleController.text = t.title;
    _notesController.text = t.notes ?? '';
    _selectedCategoryId = t.categoryId;
    _amount = t.amount;
    _selectedWalletId = t.walletId;
    _selectedDateTime = t.date;
    // Load category details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategoryDetails();
    });
  }

  void _initDefaults() {
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

  Future<void> _showCategoryPicker() async {
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
              amount: _amount,
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
              amount: _amount,
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
        await ref
            .read(transactionProvider.notifier)
            .addTransactionFull(
              amount: _amount,
              isIncome: _isIncome,
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

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
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
                  // Transaction type selector
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TransactionTypeHeader(
                      selectedType: _transactionType,
                      onTypeChanged: _onTypeChanged,
                      showTransfer: canTransfer && !_isEditing,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header (Category + Amount OR Transfer Amount)
                  if (_isTransfer)
                    TransferAmountHeader(
                      amount: _amount,
                      currencySymbol: currencySymbol,
                      onAmountTap: _showCalculator,
                    )
                  else
                    CategoryAmountHeader(
                      categoryName: _selectedCategory?.name,
                      categoryIconName: _selectedCategory?.iconName,
                      categoryColor: _selectedCategory?.colorCode,
                      amount: _amount,
                      currencySymbol: currencySymbol,
                      isIncome: _isIncome,
                      onCategoryTap: _showCategoryPicker,
                      onAmountTap: _showCalculator,
                    ),
                  const SizedBox(height: 20),

                  // Date/Time picker
                  CompactDateTimePicker(
                    selectedDateTime: _selectedDateTime,
                    onDateTimeChanged: (dateTime) {
                      setState(() => _selectedDateTime = dateTime);
                    },
                    accentColor: _accentColor,
                  ),
                  const SizedBox(height: 16),

                  if (_isTransfer) ...[
                    // Transfer: From/To wallet selectors
                    _buildTransferWalletSelectors(wallets),
                  ] else ...[
                    // Regular transaction sections
                    // Special type chips (Default, Upcoming, Subscription)
                    _buildSpecialTypeChips(),
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
                  const SizedBox(height: 20),

                  // Title input
                  _buildTitleInput(),
                  const SizedBox(height: 12),

                  // Notes input
                  _buildNotesInput(),
                  const SizedBox(height: 10),

                  // More options (expandable)
                  // if (!_isTransfer) _buildMoreOptions(),
                  // const SizedBox(height: 100), // Space for save button
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

  Widget _buildSpecialTypeChips() {
    final types = [
      TransactionSpecialType.none,
      TransactionSpecialType.upcoming,
      TransactionSpecialType.subscription,
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
      child: TextField(
        controller: _titleController,
        focusNode: _titleFocusNode,
        style: TextStyle(fontSize: 15, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Title (optional)',
          hintStyle: TextStyle(color: AppColors.textMuted),
          filled: true,
          fillColor: AppColors.primarySurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _accentColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon: Icon(
            Icons.edit_outlined,
            size: 20,
            color: AppColors.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildNotesInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _notesController,
        style: TextStyle(fontSize: 15, color: AppColors.textPrimary),
        maxLines: 3,
        minLines: 1,
        decoration: InputDecoration(
          hintText: 'Notes',
          hintStyle: TextStyle(color: AppColors.textMuted),
          filled: true,
          fillColor: AppColors.primarySurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _accentColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon: Icon(
            Icons.notes_outlined,
            size: 20,
            color: AppColors.textMuted,
          ),
        ),
      ),
    );
  }

  // Widget _buildMoreOptions() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16),
  //     child: Column(
  //       children: [
  //         InkWell(
  //           onTap: () {
  //             HapticFeedback.lightImpact();
  //             setState(() => _showMoreOptions = !_showMoreOptions);
  //           },
  //           borderRadius: BorderRadius.circular(12),
  //           child: Container(
  //             padding: const EdgeInsets.symmetric(vertical: 14),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   'More Options',
  //                   style: TextStyle(
  //                     fontSize: 14,
  //                     color: AppColors.textSecondary,
  //                   ),
  //                 ),
  //                 const SizedBox(width: 4),
  //                 Icon(
  //                   _showMoreOptions
  //                       ? Icons.keyboard_arrow_up
  //                       : Icons.keyboard_arrow_down,
  //                   size: 20,
  //                   color: AppColors.textSecondary,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         if (_showMoreOptions) ...[
  //           const SizedBox(height: 8),
  //           // Payment method, budget, objective selectors would go here
  //           Container(
  //             padding: const EdgeInsets.all(16),
  //             decoration: BoxDecoration(
  //               color: AppColors.primarySurface,
  //               borderRadius: BorderRadius.circular(12),
  //               border: Border.all(color: AppColors.divider),
  //             ),
  //             child: Text(
  //               'Payment method, budget, and objective selectors coming soon.',
  //               style: TextStyle(fontSize: 13, color: AppColors.textMuted),
  //             ),
  //           ),
  //         ],
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _canSave && !_isSaving ? _saveTransaction : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.divider,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isSaving
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    _isEditing ? 'Update' : 'Save',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

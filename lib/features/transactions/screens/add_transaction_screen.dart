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
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
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
              amount: _amount,
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

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
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
    final sectionColor = isRepetitive ? AppColors.neonBlue : AppColors.neonPurple;
    final sectionIcon = isRepetitive ? Icons.repeat : Icons.autorenew;
    final sectionTitle = isRepetitive ? 'Repeat Settings' : 'Subscription Settings';
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
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
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
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // End date
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _subscriptionEndDate ?? DateTime.now().add(const Duration(days: 365)),
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
                      child: Icon(Icons.clear, size: 18, color: AppColors.textMuted),
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
      child: TextField(
        controller: _titleController,
        focusNode: _titleFocusNode,
        style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
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
        decoration: InputDecoration(
          hintText: 'Title',
          hintStyle: TextStyle(color: AppColors.textMuted),
          prefixIcon: Icon(Icons.edit_outlined, color: AppColors.textMuted, size: 20),
          prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 0),
          filled: true,
          fillColor: AppColors.primarySurface.withValues(alpha: 0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.glassBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.glassBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: _accentColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
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
        style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
        maxLines: 3,
        minLines: 1,
        decoration: InputDecoration(
          hintText: 'Notes (optional)',
          hintStyle: TextStyle(color: AppColors.textMuted),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Icon(Icons.notes_outlined, color: AppColors.textMuted, size: 20),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 0),
          filled: true,
          fillColor: AppColors.primarySurface.withValues(alpha: 0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.glassBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.glassBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: _accentColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
        ),
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

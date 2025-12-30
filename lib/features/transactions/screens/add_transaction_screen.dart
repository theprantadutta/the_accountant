import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_animations.dart';
import 'package:the_accountant/data/models/transaction.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart' hide Transaction;
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/transactions/providers/transfer_provider.dart';
import 'package:the_accountant/features/transactions/providers/title_suggestions_provider.dart';
import 'package:the_accountant/features/transactions/widgets/calculator_keypad.dart';
import 'package:the_accountant/features/transactions/widgets/category_grid_selector.dart';
import 'package:the_accountant/features/transactions/widgets/title_input_section.dart';
import 'package:the_accountant/features/transactions/widgets/transaction_options_section.dart';
import 'package:the_accountant/features/transactions/widgets/transaction_type_header.dart';
import 'package:the_accountant/features/transactions/widgets/special_type_selector.dart';
import 'package:the_accountant/features/transactions/widgets/date_time_picker.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

/// Steps in the transaction creation flow (for expense/income)
enum AddTransactionStep {
  title,
  category,
  amount,
  options,
}

/// Steps in the transfer flow
enum TransferStep {
  accounts,
  amount,
  options,
}

/// Helper function to show the add transaction screen
Future<bool?> showAddTransactionScreen(
  BuildContext context, {
  TransactionTypeSelection initialType = TransactionTypeSelection.expense,
}) {
  return Navigator.of(context).push<bool>(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return AddTransactionScreen(initialType: initialType);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: AppAnimations.easeOut,
          )),
          child: child,
        );
      },
      transitionDuration: AppAnimations.medium,
    ),
  );
}

/// Main transaction creation screen (Cashew-style)
class AddTransactionScreen extends ConsumerStatefulWidget {
  final TransactionTypeSelection initialType;

  const AddTransactionScreen({
    super.key,
    this.initialType = TransactionTypeSelection.expense,
  });

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen>
    with TickerProviderStateMixin {
  // Current step in the flow
  int _currentStepIndex = 0;

  // Transaction type (expense/income/transfer)
  late TransactionTypeSelection _transactionType;

  // Form data for expense/income
  String _title = '';
  String _notes = '';
  String? _selectedCategoryId;
  double _amount = 0;
  String? _selectedWalletId;
  DateTime _selectedDateTime = DateTime.now();
  String? _selectedPaymentMethodId;
  TransactionSpecialType _specialType = TransactionSpecialType.none;
  String? _selectedBudgetId;
  String? _selectedObjectiveId;

  // For transfer
  String? _fromWalletId;
  String? _toWalletId;

  // Controllers
  late PageController _pageController;

  // Get steps based on transaction type
  List<String> get _steps {
    if (_isTransfer) {
      return ['Accounts', 'Amount', 'Details'];
    }
    return ['Title', 'Category', 'Amount', 'Options'];
  }

  bool get _isTransfer =>
      _transactionType == TransactionTypeSelection.transfer;

  // Track if we can proceed
  bool get _canProceed {
    if (_isTransfer) {
      switch (_currentStepIndex) {
        case 0: // Accounts
          return _fromWalletId != null &&
              _toWalletId != null &&
              _fromWalletId != _toWalletId;
        case 1: // Amount
          return _amount > 0;
        case 2: // Details
          return true;
        default:
          return false;
      }
    } else {
      switch (_currentStepIndex) {
        case 0: // Title
          return true; // Title is optional
        case 1: // Category
          return _selectedCategoryId != null;
        case 2: // Amount
          return _amount > 0;
        case 3: // Options
          return _selectedWalletId != null;
        default:
          return false;
      }
    }
  }

  // Track if we can save
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

  bool get _isLastStep {
    if (_isTransfer) {
      return _currentStepIndex == 2;
    }
    return _currentStepIndex == 3;
  }

  @override
  void initState() {
    super.initState();
    _transactionType = widget.initialType;
    _pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load title suggestions for expense/income
      if (!_isTransfer) {
        ref.read(titleSuggestionsProvider.notifier).loadRecentTitles();
      }
      // Set default wallets
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Color get _accentColor => _transactionType.color;

  void _goToStep(int stepIndex) {
    setState(() {
      _currentStepIndex = stepIndex;
    });
    _pageController.animateToPage(
      stepIndex,
      duration: AppAnimations.medium,
      curve: AppAnimations.easeOut,
    );
  }

  void _nextStep() {
    final maxStep = _isTransfer ? 2 : 3;
    if (_currentStepIndex < maxStep) {
      _goToStep(_currentStepIndex + 1);
    }
  }

  void _previousStep() {
    if (_currentStepIndex > 0) {
      _goToStep(_currentStepIndex - 1);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _onTypeChanged(TransactionTypeSelection type) {
    HapticFeedback.lightImpact();

    final wallets = ref.read(walletProvider).wallets;

    // Check if transfer is possible
    if (type == TransactionTypeSelection.transfer && wallets.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('You need at least 2 accounts to make a transfer'),
          backgroundColor: AppColors.warning,
          action: SnackBarAction(
            label: 'Add Account',
            textColor: AppColors.textPrimary,
            onPressed: () {
              // TODO: Navigate to add wallet screen
            },
          ),
        ),
      );
      return;
    }

    setState(() {
      _transactionType = type;
      _currentStepIndex = 0;
      _selectedCategoryId = null;
      _amount = 0;
    });

    _pageController.jumpToPage(0);
  }

  Future<void> _saveTransaction() async {
    if (!_canSave) return;

    HapticFeedback.mediumImpact();

    try {
      if (_isTransfer) {
        // Handle transfer
        await ref.read(transferProvider.notifier).createTransfer(
              sourceWalletId: _fromWalletId!,
              destinationWalletId: _toWalletId!,
              amount: _amount,
              date: _selectedDateTime,
              title: 'Transfer',
              notes: _notes.isEmpty ? null : _notes,
            );
      } else {
        // Handle regular transaction
        final isIncome = _transactionType == TransactionTypeSelection.income;
        final isPaid = !_specialType.startsUnpaid;

        await ref.read(transactionProvider.notifier).addTransactionFull(
              amount: _amount,
              isIncome: isIncome,
              categoryId: _selectedCategoryId!,
              walletId: _selectedWalletId!,
              dateTime: _selectedDateTime,
              title: _title.isEmpty ? null : _title,
              notes: _notes.isEmpty ? null : _notes,
              paymentMethodId: _selectedPaymentMethodId,
              specialType: _specialType,
              isPaid: isPaid,
              originalDueDate:
                  _specialType.requiresDueDate ? _selectedDateTime : null,
              budgetId: _selectedBudgetId,
              objectiveId: _selectedObjectiveId,
            );

        // Learn the title-category association
        if (_title.isNotEmpty && _selectedCategoryId != null) {
          await ref
              .read(titleSuggestionsProvider.notifier)
              .addTitleAssociation(
                title: _title,
                categoryId: _selectedCategoryId!,
              );
        }
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving transaction: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallets = ref.watch(walletProvider).wallets;
    final canTransfer = wallets.length >= 2;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header with close and type selector
            _buildHeader(canTransfer),

            // Step indicator
            _buildStepIndicator(),

            // Main content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentStepIndex = index;
                  });
                },
                children: _isTransfer
                    ? [
                        _buildTransferAccountsStep(),
                        _buildAmountStep(),
                        _buildTransferDetailsStep(),
                      ]
                    : [
                        _buildTitleStep(),
                        _buildCategoryStep(),
                        _buildAmountStep(),
                        _buildOptionsStep(),
                      ],
              ),
            ),

            // Bottom action bar
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool canTransfer) {
    return Padding(
      padding: AppSpacing.paddingMd,
      child: Column(
        children: [
          // Top row with close button
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close, color: AppColors.textPrimary),
              ),
              const Spacer(),
              Text(
                _isTransfer ? 'New Transfer' : 'New Transaction',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 48),
            ],
          ),
          AppSpacing.gapMd,

          // Transaction type selector
          TransactionTypeHeader(
            selectedType: _transactionType,
            onTypeChanged: _onTypeChanged,
            showTransfer: canTransfer,
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: List.generate(_steps.length, (index) {
          final isActive = index <= _currentStepIndex;
          final isCurrent = index == _currentStepIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (index < _currentStepIndex) {
                  _goToStep(index);
                }
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      if (index > 0)
                        Expanded(
                          child: Container(
                            height: 2,
                            color: isActive ? _accentColor : AppColors.divider,
                          ),
                        ),
                      AnimatedContainer(
                        duration: AppAnimations.fast,
                        width: isCurrent ? 12 : 8,
                        height: isCurrent ? 12 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive ? _accentColor : AppColors.divider,
                          border: isCurrent
                              ? Border.all(
                                  color: _accentColor.withValues(alpha: 0.5),
                                  width: 3,
                                )
                              : null,
                        ),
                      ),
                      if (index < _steps.length - 1)
                        Expanded(
                          child: Container(
                            height: 2,
                            color: index < _currentStepIndex
                                ? _accentColor
                                : AppColors.divider,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _steps[index],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isActive ? _accentColor : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ==================== EXPENSE/INCOME STEPS ====================

  Widget _buildTitleStep() {
    return SingleChildScrollView(
      padding: AppSpacing.paddingMd,
      child: TitleInputSection(
        initialTitle: _title,
        initialNotes: _notes,
        onTitleChanged: (title) {
          setState(() {
            _title = title;
          });
        },
        onNotesChanged: (notes) {
          setState(() {
            _notes = notes;
          });
        },
        onCategorySuggested: (suggestion) {
          setState(() {
            _selectedCategoryId = suggestion.categoryId;
          });
        },
        accentColor: _accentColor,
      ),
    );
  }

  Widget _buildCategoryStep() {
    return Padding(
      padding: AppSpacing.paddingMd,
      child: CategoryGridSelector(
        selectedCategoryId: _selectedCategoryId,
        onCategorySelected: (category) {
          setState(() {
            _selectedCategoryId = category.id;
          });
          // Auto-advance to amount step
          Future.delayed(const Duration(milliseconds: 200), () {
            _nextStep();
          });
        },
        isIncome: _transactionType.isIncome,
        showAddButton: true,
        onAddCategory: () {
          // TODO: Navigate to add category screen
        },
      ),
    );
  }

  Widget _buildAmountStep() {
    return CalculatorKeypad(
      initialAmount: _amount,
      onAmountChanged: (amount) {
        setState(() {
          _amount = amount;
        });
      },
      isIncome: _transactionType == TransactionTypeSelection.income,
      currencySymbol: '\$',
    );
  }

  Widget _buildOptionsStep() {
    return SingleChildScrollView(
      padding: AppSpacing.paddingMd,
      child: TransactionOptionsSection(
        selectedWalletId: _selectedWalletId,
        onWalletChanged: (walletId) {
          setState(() {
            _selectedWalletId = walletId;
          });
        },
        selectedDateTime: _selectedDateTime,
        onDateTimeChanged: (dateTime) {
          setState(() {
            _selectedDateTime = dateTime;
          });
        },
        selectedPaymentMethodId: _selectedPaymentMethodId,
        onPaymentMethodChanged: (methodId) {
          setState(() {
            _selectedPaymentMethodId = methodId;
          });
        },
        specialType: _specialType,
        onSpecialTypeChanged: (type) {
          setState(() {
            _specialType = type;
          });
        },
        selectedBudgetId: _selectedBudgetId,
        onBudgetChanged: (budgetId) {
          setState(() {
            _selectedBudgetId = budgetId;
          });
        },
        selectedObjectiveId: _selectedObjectiveId,
        onObjectiveChanged: (objectiveId) {
          setState(() {
            _selectedObjectiveId = objectiveId;
          });
        },
        isIncome: _transactionType.isIncome,
        accentColor: _accentColor,
      ),
    );
  }

  // ==================== TRANSFER STEPS ====================

  Widget _buildTransferAccountsStep() {
    final wallets = ref.watch(walletProvider).wallets;

    return SingleChildScrollView(
      padding: AppSpacing.paddingMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transfer Between Accounts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            'Select the source and destination accounts',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.gapXl,

          // From wallet
          _buildWalletSection(
            label: 'From Account',
            icon: Icons.arrow_upward,
            iconColor: AppColors.error,
            wallets: wallets,
            selectedId: _fromWalletId,
            excludeId: _toWalletId,
            onSelected: (id) {
              setState(() {
                _fromWalletId = id;
              });
            },
          ),

          AppSpacing.gapLg,

          // Arrow indicator
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _accentColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_downward,
                color: _accentColor,
                size: 24,
              ),
            ),
          ),

          AppSpacing.gapLg,

          // To wallet
          _buildWalletSection(
            label: 'To Account',
            icon: Icons.arrow_downward,
            iconColor: AppColors.success,
            wallets: wallets,
            selectedId: _toWalletId,
            excludeId: _fromWalletId,
            onSelected: (id) {
              setState(() {
                _toWalletId = id;
              });
            },
          ),

          // Validation message
          if (_fromWalletId != null &&
              _toWalletId != null &&
              _fromWalletId == _toWalletId) ...[
            AppSpacing.gapLg,
            Container(
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: AppSpacing.borderRadiusMd,
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 20,
                  ),
                  AppSpacing.gapHSm,
                  Expanded(
                    child: Text(
                      'Source and destination accounts must be different',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWalletSection({
    required String label,
    required IconData icon,
    required Color iconColor,
    required List<Wallet> wallets,
    required String? selectedId,
    required String? excludeId,
    required ValueChanged<String> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            AppSpacing.gapHSm,
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        AppSpacing.gapSm,
        ...wallets.map((wallet) {
          final isSelected = wallet.id == selectedId;
          final isExcluded = wallet.id == excludeId;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: isExcluded
                  ? null
                  : () {
                      HapticFeedback.lightImpact();
                      onSelected(wallet.id);
                    },
              child: AnimatedContainer(
                duration: AppAnimations.fast,
                padding: AppSpacing.paddingMd,
                decoration: BoxDecoration(
                  color: isSelected
                      ? _accentColor.withValues(alpha: 0.15)
                      : isExcluded
                          ? AppColors.primarySurface.withValues(alpha: 0.5)
                          : AppColors.primarySurface,
                  borderRadius: AppSpacing.borderRadiusMd,
                  border: Border.all(
                    color: isSelected
                        ? _accentColor
                        : isExcluded
                            ? AppColors.divider.withValues(alpha: 0.5)
                            : AppColors.divider,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _parseColor(wallet.color).withValues(alpha: 0.2),
                        borderRadius: AppSpacing.borderRadiusSm,
                      ),
                      child: Icon(
                        Icons.account_balance_wallet,
                        color: isExcluded
                            ? AppColors.textMuted
                            : _parseColor(wallet.color),
                        size: 20,
                      ),
                    ),
                    AppSpacing.gapHMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wallet.name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isExcluded
                                  ? AppColors.textMuted
                                  : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '\$${wallet.balance.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 13,
                              color: isExcluded
                                  ? AppColors.textMuted.withValues(alpha: 0.5)
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: _accentColor,
                        size: 24,
                      ),
                    if (isExcluded && !isSelected)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: AppSpacing.borderRadiusSm,
                        ),
                        child: Text(
                          label == 'From Account' ? 'Destination' : 'Source',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTransferDetailsStep() {
    return SingleChildScrollView(
      padding: AppSpacing.paddingMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transfer Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.gapLg,

          // Date & Time
          _buildOptionTile(
            icon: Icons.event,
            label: 'Date & Time',
            child: DateTimePicker(
              selectedDateTime: _selectedDateTime,
              onDateTimeChanged: (dateTime) {
                setState(() {
                  _selectedDateTime = dateTime;
                });
              },
              accentColor: _accentColor,
              label: '',
              showTime: true,
            ),
          ),

          AppSpacing.gapMd,

          // Notes (optional)
          _buildOptionTile(
            icon: Icons.notes,
            label: 'Notes (optional)',
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _notes = value;
                });
              },
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'Add any notes about this transfer...',
                hintStyle: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
                filled: true,
                fillColor: AppColors.primaryElevated,
                border: OutlineInputBorder(
                  borderRadius: AppSpacing.borderRadiusSm,
                  borderSide: BorderSide.none,
                ),
                contentPadding: AppSpacing.paddingMd,
              ),
            ),
          ),

          AppSpacing.gapLg,

          // Transfer summary
          _buildTransferSummary(),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: _accentColor),
              AppSpacing.gapHSm,
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          AppSpacing.gapSm,
          child,
        ],
      ),
    );
  }

  Widget _buildTransferSummary() {
    final wallets = ref.watch(walletProvider).wallets;
    final fromWallet = wallets.firstWhere(
      (w) => w.id == _fromWalletId,
      orElse: () => wallets.first,
    );
    final toWallet = wallets.firstWhere(
      (w) => w.id == _toWalletId,
      orElse: () => wallets.last,
    );

    return Container(
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: _accentColor.withValues(alpha: 0.1),
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(
          color: _accentColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Transfer Summary',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _accentColor,
            ),
          ),
          AppSpacing.gapMd,
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      color: AppColors.error,
                      size: 28,
                    ),
                    AppSpacing.gapSm,
                    Text(
                      fromWallet.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Icon(
                      Icons.arrow_forward,
                      color: _accentColor,
                      size: 24,
                    ),
                    AppSpacing.gapSm,
                    Text(
                      '\$${_amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _accentColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      color: AppColors.success,
                      size: 28,
                    ),
                    AppSpacing.gapSm,
                    Text(
                      toWallet.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        border: Border(
          top: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Row(
        children: [
          // Back button
          if (_currentStepIndex > 0)
            TextButton.icon(
              onPressed: _previousStep,
              icon: Icon(Icons.arrow_back, color: AppColors.textSecondary),
              label: Text(
                'Back',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          else
            const SizedBox(width: 80),

          const Spacer(),

          // Summary chip
          if (_amount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _accentColor.withValues(alpha: 0.1),
                borderRadius: AppSpacing.borderRadiusFull,
              ),
              child: Text(
                '\$${_amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _accentColor,
                ),
              ),
            ),

          const Spacer(),

          // Next/Save button
          ElevatedButton(
            onPressed: _isLastStep
                ? (_canSave ? _saveTransaction : null)
                : (_canProceed ? _nextStep : null),
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.divider,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: AppSpacing.borderRadiusMd,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isLastStep ? 'Save' : 'Next',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!_isLastStep) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String? colorCode) {
    if (colorCode == null) return AppColors.primaryAccent;
    try {
      if (colorCode.startsWith('#')) {
        return Color(int.parse(colorCode.substring(1), radix: 16) | 0xFF000000);
      }
      return AppColors.primaryAccent;
    } catch (e) {
      return AppColors.primaryAccent;
    }
  }
}

/// Screen for editing an existing transaction
class EditTransactionScreen extends ConsumerStatefulWidget {
  final Transaction transaction;

  const EditTransactionScreen({
    super.key,
    required this.transaction,
  });

  @override
  ConsumerState<EditTransactionScreen> createState() =>
      _EditTransactionScreenState();
}

class _EditTransactionScreenState extends ConsumerState<EditTransactionScreen>
    with TickerProviderStateMixin {
  // Current step in the flow
  int _currentStepIndex = 0;

  // Transaction type (expense/income)
  late TransactionTypeSelection _transactionType;

  // Form data
  late String _title;
  late String _notes;
  late String? _selectedCategoryId;
  late double _amount;
  late String? _selectedWalletId;
  late DateTime _selectedDateTime;
  String? _selectedPaymentMethodId;
  TransactionSpecialType _specialType = TransactionSpecialType.none;
  String? _selectedBudgetId;
  String? _selectedObjectiveId;

  // Controllers
  late PageController _pageController;

  // Steps for editing
  List<String> get _steps => ['Title', 'Category', 'Amount', 'Options'];

  // Track if we can proceed
  bool get _canProceed {
    switch (_currentStepIndex) {
      case 0: // Title
        return true; // Title is optional
      case 1: // Category
        return _selectedCategoryId != null;
      case 2: // Amount
        return _amount > 0;
      case 3: // Options
        return _selectedWalletId != null;
      default:
        return false;
    }
  }

  // Track if we can save
  bool get _canSave {
    return _amount > 0 &&
        _selectedCategoryId != null &&
        _selectedWalletId != null;
  }

  bool get _isLastStep => _currentStepIndex == 3;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Initialize from existing transaction
    final t = widget.transaction;
    _transactionType = t.type == 'income'
        ? TransactionTypeSelection.income
        : TransactionTypeSelection.expense;
    _title = t.title.isNotEmpty ? t.title : t.notes; // Prefer title, fallback to notes
    _notes = t.notes;
    _selectedCategoryId = t.categoryId;
    _amount = t.amount;
    _selectedWalletId = t.walletId;
    _selectedDateTime = t.date;
    _selectedPaymentMethodId = t.paymentMethod.isNotEmpty ? t.paymentMethod : null;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Color get _accentColor => _transactionType.color;

  void _goToStep(int stepIndex) {
    setState(() {
      _currentStepIndex = stepIndex;
    });
    _pageController.animateToPage(
      stepIndex,
      duration: AppAnimations.medium,
      curve: AppAnimations.easeOut,
    );
  }

  void _nextStep() {
    if (_currentStepIndex < 3) {
      _goToStep(_currentStepIndex + 1);
    }
  }

  void _previousStep() {
    if (_currentStepIndex > 0) {
      _goToStep(_currentStepIndex - 1);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _onTypeChanged(TransactionTypeSelection type) {
    HapticFeedback.lightImpact();
    setState(() {
      _transactionType = type;
      _selectedCategoryId = null;
    });
  }

  Future<void> _saveTransaction() async {
    if (!_canSave) return;

    HapticFeedback.mediumImpact();

    try {
      final isIncome = _transactionType == TransactionTypeSelection.income;

      await ref.read(transactionProvider.notifier).updateTransaction(
            id: widget.transaction.id,
            amount: _amount,
            isIncome: isIncome,
            title: _title.isEmpty ? null : _title,
            categoryId: _selectedCategoryId!,
            walletId: _selectedWalletId!,
            date: _selectedDateTime,
            notes: _notes.isEmpty ? null : _notes,
            paymentMethodId: _selectedPaymentMethodId,
          );

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Transaction updated'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating transaction: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header with close and type selector
            _buildHeader(),

            // Step indicator
            _buildStepIndicator(),

            // Main content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentStepIndex = index;
                  });
                },
                children: [
                  _buildTitleStep(),
                  _buildCategoryStep(),
                  _buildAmountStep(),
                  _buildOptionsStep(),
                ],
              ),
            ),

            // Bottom action bar
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: AppSpacing.paddingMd,
      child: Column(
        children: [
          // Top row with close button
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close, color: AppColors.textPrimary),
              ),
              const Spacer(),
              Text(
                'Edit Transaction',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 48),
            ],
          ),
          AppSpacing.gapMd,

          // Transaction type selector
          TransactionTypeHeader(
            selectedType: _transactionType,
            onTypeChanged: _onTypeChanged,
            showTransfer: false, // Can't change to transfer when editing
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: List.generate(_steps.length, (index) {
          final isActive = index <= _currentStepIndex;
          final isCurrent = index == _currentStepIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (index < _currentStepIndex) {
                  _goToStep(index);
                }
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      if (index > 0)
                        Expanded(
                          child: Container(
                            height: 2,
                            color: isActive ? _accentColor : AppColors.divider,
                          ),
                        ),
                      AnimatedContainer(
                        duration: AppAnimations.fast,
                        width: isCurrent ? 12 : 8,
                        height: isCurrent ? 12 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive ? _accentColor : AppColors.divider,
                          border: isCurrent
                              ? Border.all(
                                  color: _accentColor.withValues(alpha: 0.5),
                                  width: 3,
                                )
                              : null,
                        ),
                      ),
                      if (index < _steps.length - 1)
                        Expanded(
                          child: Container(
                            height: 2,
                            color: index < _currentStepIndex
                                ? _accentColor
                                : AppColors.divider,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _steps[index],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isActive ? _accentColor : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTitleStep() {
    return SingleChildScrollView(
      padding: AppSpacing.paddingMd,
      child: TitleInputSection(
        initialTitle: _title,
        initialNotes: _notes,
        onTitleChanged: (title) {
          setState(() {
            _title = title;
          });
        },
        onNotesChanged: (notes) {
          setState(() {
            _notes = notes;
          });
        },
        onCategorySuggested: (suggestion) {
          setState(() {
            _selectedCategoryId = suggestion.categoryId;
          });
        },
        accentColor: _accentColor,
      ),
    );
  }

  Widget _buildCategoryStep() {
    return Padding(
      padding: AppSpacing.paddingMd,
      child: CategoryGridSelector(
        selectedCategoryId: _selectedCategoryId,
        onCategorySelected: (category) {
          setState(() {
            _selectedCategoryId = category.id;
          });
          // Auto-advance to amount step
          Future.delayed(const Duration(milliseconds: 200), () {
            _nextStep();
          });
        },
        isIncome: _transactionType.isIncome,
        showAddButton: true,
        onAddCategory: () {
          // TODO: Navigate to add category screen
        },
      ),
    );
  }

  Widget _buildAmountStep() {
    return CalculatorKeypad(
      initialAmount: _amount,
      onAmountChanged: (amount) {
        setState(() {
          _amount = amount;
        });
      },
      isIncome: _transactionType == TransactionTypeSelection.income,
      currencySymbol: '\$',
    );
  }

  Widget _buildOptionsStep() {
    return SingleChildScrollView(
      padding: AppSpacing.paddingMd,
      child: TransactionOptionsSection(
        selectedWalletId: _selectedWalletId,
        onWalletChanged: (walletId) {
          setState(() {
            _selectedWalletId = walletId;
          });
        },
        selectedDateTime: _selectedDateTime,
        onDateTimeChanged: (dateTime) {
          setState(() {
            _selectedDateTime = dateTime;
          });
        },
        selectedPaymentMethodId: _selectedPaymentMethodId,
        onPaymentMethodChanged: (methodId) {
          setState(() {
            _selectedPaymentMethodId = methodId;
          });
        },
        specialType: _specialType,
        onSpecialTypeChanged: (type) {
          setState(() {
            _specialType = type;
          });
        },
        selectedBudgetId: _selectedBudgetId,
        onBudgetChanged: (budgetId) {
          setState(() {
            _selectedBudgetId = budgetId;
          });
        },
        selectedObjectiveId: _selectedObjectiveId,
        onObjectiveChanged: (objectiveId) {
          setState(() {
            _selectedObjectiveId = objectiveId;
          });
        },
        isIncome: _transactionType.isIncome,
        accentColor: _accentColor,
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        border: Border(
          top: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Row(
        children: [
          // Back button
          if (_currentStepIndex > 0)
            TextButton.icon(
              onPressed: _previousStep,
              icon: Icon(Icons.arrow_back, color: AppColors.textSecondary),
              label: Text(
                'Back',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          else
            const SizedBox(width: 80),

          const Spacer(),

          // Summary chip
          if (_amount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _accentColor.withValues(alpha: 0.1),
                borderRadius: AppSpacing.borderRadiusFull,
              ),
              child: Text(
                '\$${_amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _accentColor,
                ),
              ),
            ),

          const Spacer(),

          // Next/Save button
          ElevatedButton(
            onPressed: _isLastStep
                ? (_canSave ? _saveTransaction : null)
                : (_canProceed ? _nextStep : null),
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.divider,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: AppSpacing.borderRadiusMd,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isLastStep ? 'Update' : 'Next',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!_isLastStep) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Legacy class for backward compatibility
@Deprecated('Use AddTransactionScreen instead')
class AddTransactionScreenWithPreset extends StatelessWidget {
  final String presetType;
  final String presetCategoryName;

  const AddTransactionScreenWithPreset({
    super.key,
    required this.presetType,
    required this.presetCategoryName,
  });

  @override
  Widget build(BuildContext context) {
    return AddTransactionScreen(
      initialType: presetType == 'income'
          ? TransactionTypeSelection.income
          : TransactionTypeSelection.expense,
    );
  }
}

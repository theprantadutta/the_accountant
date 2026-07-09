import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/transactions/providers/smart_categorization_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/transactions/services/smart_categorization_service.dart';
import 'package:the_accountant/features/transactions/widgets/amount_input.dart';
import 'package:the_accountant/features/transactions/widgets/category_grid_selector.dart';
import 'package:the_accountant/features/transactions/widgets/transfer_bottom_sheet.dart';
import 'package:the_accountant/features/transactions/widgets/wallet_selector.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/features/recurring/providers/recurring_provider.dart';
import 'package:the_accountant/features/subscriptions/providers/subscription_dashboard_provider.dart';
import 'package:the_accountant/features/transactions/widgets/horizontal_chip_selector.dart';

/// Transaction creation steps
enum TransactionStep { amount, category, details }

/// Transaction type for the type selector
enum TransactionType { expense, income, transfer }

/// Show the transaction bottom sheet
/// Returns true if a transaction was created
Future<bool?> showTransactionBottomSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const TransactionBottomSheet(),
  );
}

/// Full-screen transaction creation bottom sheet.
/// Flow: Amount → Category → Details → Save
class TransactionBottomSheet extends ConsumerStatefulWidget {
  const TransactionBottomSheet({super.key});

  @override
  ConsumerState<TransactionBottomSheet> createState() =>
      _TransactionBottomSheetState();
}

class _TransactionBottomSheetState
    extends ConsumerState<TransactionBottomSheet> {
  TransactionStep _currentStep = TransactionStep.amount;

  // Transaction type (expense, income, transfer)
  TransactionType _transactionType = TransactionType.expense;

  // Transaction data
  double _amount = 0.0;
  bool _isIncome = false;
  Category? _selectedCategory;
  String? _selectedWalletId;
  String _title = '';
  String _notes = '';
  DateTime _date = DateTime.now();
  TransactionSpecialType _specialType = TransactionSpecialType.none;
  bool _isPaid = true;

  // Subscription config
  String _subscriptionFrequency = 'monthly';
  int _subscriptionPeriodLength = 1;
  DateTime? _subscriptionEndDate;

  bool _isSaving = false;

  // Smart categorization
  final TextEditingController _titleController = TextEditingController();
  CategorySuggestion? _categorySuggestion;
  bool _isCheckingSuggestion = false;

  @override
  void initState() {
    super.initState();
    // Get default wallet from persisted preference (falls back to database default)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final defaultWalletId = ref.read(effectiveDefaultWalletIdProvider);
      setState(() {
        _selectedWalletId = defaultWalletId;
      });
    });

    // Listen to title changes for smart categorization
    _titleController.addListener(_onTitleChanged);
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _titleController.dispose();
    super.dispose();
  }

  /// Check for category suggestions when title changes
  void _onTitleChanged() {
    _title = _titleController.text;
    _checkCategorySuggestion(_title);
  }

  /// Query smart categorization service for suggestions
  Future<void> _checkCategorySuggestion(String title) async {
    if (title.isEmpty || title.length < 3) {
      if (_categorySuggestion != null) {
        setState(() {
          _categorySuggestion = null;
        });
      }
      return;
    }

    if (_isCheckingSuggestion) return;

    setState(() {
      _isCheckingSuggestion = true;
    });

    try {
      final service = ref.read(smartCategorizationServiceProvider);
      final suggestion = await service.suggestCategory(title);

      if (mounted) {
        setState(() {
          // Only show suggestion if it differs from current selection
          if (suggestion != null &&
              suggestion.category.id != _selectedCategory?.id &&
              suggestion.category.isIncome == _isIncome) {
            _categorySuggestion = suggestion;
          } else {
            _categorySuggestion = null;
          }
          _isCheckingSuggestion = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCheckingSuggestion = false;
        });
      }
    }
  }

  void _goToStep(TransactionStep step) {
    HapticFeedback.lightImpact();
    setState(() {
      _currentStep = step;
    });
  }

  void _nextStep() {
    switch (_currentStep) {
      case TransactionStep.amount:
        if (_amount <= 0) {
          _showError('Please enter an amount');
          return;
        }

        // If Transfer is selected, show the transfer bottom sheet
        if (_transactionType == TransactionType.transfer) {
          _openTransferSheet();
          return;
        }

        _goToStep(TransactionStep.category);
        break;
      case TransactionStep.category:
        if (_selectedCategory == null) {
          _showError('Please select a category');
          return;
        }
        _goToStep(TransactionStep.details);
        break;
      case TransactionStep.details:
        _saveTransaction();
        break;
    }
  }

  /// Open the transfer bottom sheet
  Future<void> _openTransferSheet() async {
    Navigator.pop(context); // Close this bottom sheet first
    await showTransferBottomSheet(context);
  }

  void _previousStep() {
    switch (_currentStep) {
      case TransactionStep.amount:
        Navigator.pop(context);
        break;
      case TransactionStep.category:
        _goToStep(TransactionStep.amount);
        break;
      case TransactionStep.details:
        _goToStep(TransactionStep.category);
        break;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _saveTransaction() async {
    if (_isSaving) return;

    // Validate category before saving
    if (_selectedCategory == null) {
      _showError('Please select a category');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final transactionNotifier = ref.read(transactionProvider.notifier);
      final walletNotifier = ref.read(walletProvider.notifier);
      final effectiveWalletId =
          _selectedWalletId ?? walletNotifier.getDefaultWalletId();

      if (effectiveWalletId == null || effectiveWalletId.isEmpty) {
        _showError('Please select a wallet');
        setState(() => _isSaving = false);
        return;
      }

      // Use addTransactionFull for complete Cashew-style transaction creation
      // This method handles wallet balance updates internally
      final newTransactionId = await transactionNotifier.addTransactionFull(
        amount: (_amount * 100).round(), // dollars -> integer cents
        isIncome: _isIncome,
        categoryId: _selectedCategory!.id,
        walletId: effectiveWalletId,
        dateTime: _date,
        title: _title,
        notes: _notes.isNotEmpty ? _notes : null,
        specialType: _specialType,
        isPaid: _isPaid,
      );

      // Create RecurringConfig for subscriptions
      if (_specialType == TransactionSpecialType.subscription &&
          newTransactionId != null) {
        final recurringService = ref.read(recurringServiceProvider);
        await recurringService.createRecurringConfig(
          baseTransactionId: newTransactionId,
          reoccurrence: _subscriptionFrequency,
          periodLength: _subscriptionPeriodLength,
          startDate: _date,
          endDate: _subscriptionEndDate,
        );
        ref.read(subscriptionDashboardProvider.notifier).refresh();
      }

      // Learn from this transaction for smart categorization
      if (_title.isNotEmpty && _selectedCategory != null) {
        final smartCategorizationService = ref.read(
          smartCategorizationServiceProvider,
        );
        await smartCategorizationService.addTitleAssociation(
          title: _title,
          categoryId: _selectedCategory!.id,
          isExactMatch: true,
        );
      }

      if (mounted) {
        HapticFeedback.mediumImpact();
        Navigator.pop(
          context,
          true,
        ); // Return true to indicate transaction was created
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isIncome ? 'Income added!' : 'Expense added!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: _isIncome
                ? Colors.green
                : Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showError('Failed to save transaction: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  /// Apply the category suggestion
  void _applyCategorySuggestion() {
    if (_categorySuggestion == null) return;

    HapticFeedback.lightImpact();
    final dbCategory = _categorySuggestion!.category;
    setState(() {
      // Convert db.Category to provider's Category type
      _selectedCategory = Category(
        id: dbCategory.id,
        name: dbCategory.name,
        colorCode: dbCategory.color,
        type: dbCategory.isIncome ? 'income' : 'expense',
        isDefault: false,
      );
      _categorySuggestion = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(theme),

            // Step Indicator
            _buildStepIndicator(theme),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _buildStepContent(theme),
                ),
              ),
            ),

            // Bottom Actions
            _buildBottomActions(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Back/Close Button
          IconButton(
            icon: Icon(
              _currentStep == TransactionStep.amount
                  ? Icons.close
                  : Icons.arrow_back,
            ),
            onPressed: _previousStep,
          ),

          // Title
          Expanded(
            child: Text(
              _getStepTitle(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),

          // Placeholder for balance
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case TransactionStep.amount:
        return 'Enter Amount';
      case TransactionStep.category:
        return 'Select Category';
      case TransactionStep.details:
        return 'Transaction Details';
    }
  }

  Widget _buildStepIndicator(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          _buildStepDot(theme, TransactionStep.amount),
          _buildStepLine(theme, TransactionStep.amount),
          _buildStepDot(theme, TransactionStep.category),
          _buildStepLine(theme, TransactionStep.category),
          _buildStepDot(theme, TransactionStep.details),
        ],
      ),
    );
  }

  Widget _buildStepDot(ThemeData theme, TransactionStep step) {
    final isActive = _currentStep.index >= step.index;
    final isCurrent = _currentStep == step;
    final color = _isIncome ? Colors.green : theme.colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isCurrent ? 12 : 8,
      height: isCurrent ? 12 : 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? color : theme.colorScheme.surfaceContainerHighest,
        border: Border.all(
          color: isActive
              ? color
              : theme.colorScheme.outline.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
    );
  }

  Widget _buildStepLine(ThemeData theme, TransactionStep step) {
    final isActive = _currentStep.index > step.index;
    final color = _isIncome ? Colors.green : theme.colorScheme.primary;

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isActive ? color : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  Widget _buildStepContent(ThemeData theme) {
    switch (_currentStep) {
      case TransactionStep.amount:
        return _buildAmountStep(theme);
      case TransactionStep.category:
        return _buildCategoryStep(theme);
      case TransactionStep.details:
        return _buildDetailsStep(theme);
    }
  }

  Widget _buildAmountStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Transaction Type Selector (Expense/Income/Transfer)
          _buildTransactionTypeSelector(theme),
          const SizedBox(height: 16),

          // Amount Input (hide toggle since we have type selector)
          AmountInput(
            initialAmount: _amount,
            isIncome: _isIncome,
            showToggle: false, // Hide the built-in toggle
            onAmountChanged: (amount) {
              setState(() {
                _amount = amount;
              });
            },
            onIsIncomeChanged: (isIncome) {
              setState(() {
                _isIncome = isIncome;
                // Reset category when switching income/expense
                _selectedCategory = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTypeSelector(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _buildTypeTab(
            theme,
            type: TransactionType.expense,
            label: 'Expense',
            color: Colors.red,
            icon: Icons.arrow_downward,
          ),
          const SizedBox(width: 4),
          _buildTypeTab(
            theme,
            type: TransactionType.income,
            label: 'Income',
            color: Colors.green,
            icon: Icons.arrow_upward,
          ),
          const SizedBox(width: 4),
          _buildTypeTab(
            theme,
            type: TransactionType.transfer,
            label: 'Transfer',
            color: Colors.teal,
            icon: Icons.swap_horiz,
          ),
        ],
      ),
    );
  }

  Widget _buildTypeTab(
    ThemeData theme, {
    required TransactionType type,
    required String label,
    required Color color,
    required IconData icon,
  }) {
    final isSelected = _transactionType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() {
            _transactionType = type;
            // Update isIncome based on type
            _isIncome = type == TransactionType.income;
            // Reset category when changing type
            _selectedCategory = null;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: color, width: 2)
                : Border.all(color: Colors.transparent, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? color : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? color
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryStep(ThemeData theme) {
    return CategoryGridSelector(
      selectedCategoryId: _selectedCategory?.id,
      isIncome: _isIncome,
      onCategorySelected: (category) {
        setState(() {
          _selectedCategory = category;
        });
      },
      showAddButton: true,
    );
  }

  Widget _buildDetailsStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Card
          _buildSummaryCard(theme),
          const SizedBox(height: 24),

          // Wallet Selector
          WalletSelector(
            selectedWalletId: _selectedWalletId,
            onWalletSelected: (wallet) {
              setState(() {
                _selectedWalletId = wallet.id;
              });
            },
            label: 'Account',
          ),
          const SizedBox(height: 24),

          // Title/Description with smart categorization
          _buildTitleInput(theme),

          // Category Suggestion
          if (_categorySuggestion != null) ...[
            const SizedBox(height: 12),
            _buildCategorySuggestion(theme),
          ],
          const SizedBox(height: 16),

          // Date Picker
          _buildDatePicker(theme),
          const SizedBox(height: 16),

          // Special Type Selector
          _buildSpecialTypeSelector(theme),
          if (_specialType == TransactionSpecialType.subscription)
            _buildSubscriptionConfigSection(theme),
          const SizedBox(height: 16),

          // Notes
          _buildTextField(
            theme,
            label: 'Notes (Optional)',
            hint: 'Add any notes...',
            value: _notes,
            onChanged: (value) => setState(() => _notes = value),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialTypeSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaction Type',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildSpecialTypeChip(
              theme,
              type: TransactionSpecialType.none,
              label: 'Regular',
              icon: Icons.receipt_long,
            ),
            _buildSpecialTypeChip(
              theme,
              type: TransactionSpecialType.upcoming,
              label: 'Upcoming',
              icon: Icons.schedule,
            ),
            _buildSpecialTypeChip(
              theme,
              type: TransactionSpecialType.subscription,
              label: 'Subscription',
              icon: Icons.autorenew,
            ),
            _buildSpecialTypeChip(
              theme,
              type: TransactionSpecialType.repetitive,
              label: 'Repetitive',
              icon: Icons.repeat,
            ),
            if (!_isIncome) ...[
              _buildSpecialTypeChip(
                theme,
                type: TransactionSpecialType.credit,
                label: 'Lent',
                icon: Icons.arrow_upward,
              ),
              _buildSpecialTypeChip(
                theme,
                type: TransactionSpecialType.debt,
                label: 'Borrowed',
                icon: Icons.arrow_downward,
              ),
            ],
          ],
        ),
        // Show "Mark as Paid" toggle for non-regular types
        if (_specialType != TransactionSpecialType.none &&
            _specialType != TransactionSpecialType.repetitive) ...[
          const SizedBox(height: 12),
          SwitchListTile(
            value: _isPaid,
            onChanged: (value) => setState(() => _isPaid = value),
            title: Text(
              'Mark as Paid',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              _isPaid ? 'Transaction is completed' : 'Transaction is pending',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ],
      ],
    );
  }

  Widget _buildSubscriptionConfigSection(ThemeData theme) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.autorenew, size: 16, color: AppColors.neonPurple),
            const SizedBox(width: 6),
            Text(
              'Subscription Settings',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.neonPurple,
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
          colorBuilder: (_) => AppColors.neonPurple,
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
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _subscriptionPeriodLength > 1
                  ? () => setState(() => _subscriptionPeriodLength--)
                  : null,
              icon: Icon(Icons.remove_circle_outline, size: 22),
              color: theme.colorScheme.onSurfaceVariant,
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
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            IconButton(
              onPressed: _subscriptionPeriodLength < 365
                  ? () => setState(() => _subscriptionPeriodLength++)
                  : null,
              icon: Icon(Icons.add_circle_outline, size: 22),
              color: theme.colorScheme.onSurfaceVariant,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
            const SizedBox(width: 4),
            Text(
              periodUnit(_subscriptionFrequency),
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurfaceVariant,
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
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.event,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _subscriptionEndDate != null
                        ? 'Ends: ${_subscriptionEndDate!.day}/${_subscriptionEndDate!.month}/${_subscriptionEndDate!.year}'
                        : 'No end date',
                    style: TextStyle(
                      fontSize: 14,
                      color: _subscriptionEndDate != null
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (_subscriptionEndDate != null)
                  GestureDetector(
                    onTap: () => setState(() => _subscriptionEndDate = null),
                    child: Icon(
                      Icons.clear,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialTypeChip(
    ThemeData theme, {
    required TransactionSpecialType type,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _specialType == type;
    final color = _isIncome ? Colors.green : theme.colorScheme.primary;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _specialType = type;
          // Reset isPaid based on type
          if (type == TransactionSpecialType.none ||
              type == TransactionSpecialType.repetitive) {
            _isPaid = true;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? color : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? color : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleInput(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title (Optional)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'What is this for?',
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            suffixIcon: _isCheckingSuggestion
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySuggestion(ThemeData theme) {
    final suggestion = _categorySuggestion!;
    // suggestion.category is db.Category, which has 'color' field
    final categoryColor = _parseColor(suggestion.category.color);

    return GestureDetector(
      onTap: _applyCategorySuggestion,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: categoryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: categoryColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.lightbulb_outline, size: 18, color: categoryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Did you mean "${suggestion.category.name}"?',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    suggestion.explanation,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: categoryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Apply',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(ThemeData theme) {
    final color = _isIncome ? Colors.green : theme.colorScheme.primary;
    final categoryColor = _parseColor(_selectedCategory?.colorCode);
    final walletCurrency = ref.watch(walletCurrencyProvider(_selectedWalletId));
    final currencySymbol = CurrencyInfo.getSymbol(walletCurrency);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Category Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.category, color: categoryColor),
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedCategory?.name ?? 'Category',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  _isIncome ? 'Income' : 'Expense',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            '$currencySymbol${_amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    ThemeData theme, {
    required String label,
    required String hint,
    required String value,
    required ValueChanged<String> onChanged,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value),
          onChanged: onChanged,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date & Time',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Date picker
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      // Preserve the time from the current date
                      _date = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        _date.hour,
                        _date.minute,
                      );
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _formatDate(_date),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Time picker
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_date),
                  );
                  if (time != null) {
                    setState(() {
                      _date = DateTime(
                        _date.year,
                        _date.month,
                        _date.day,
                        time.hour,
                        time.minute,
                      );
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 20,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(_date),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return '$hour12:$minute $period';
  }

  Widget _buildBottomActions(ThemeData theme) {
    final color = _isIncome ? Colors.green : theme.colorScheme.primary;
    final buttonText = _currentStep == TransactionStep.details
        ? (_isSaving ? 'Saving...' : 'Save Transaction')
        : 'Continue';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: ElevatedButton(
          onPressed: _isSaving ? null : _nextStep,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Color _parseColor(String? colorCode) {
    if (colorCode == null) return Colors.grey;
    try {
      if (colorCode.startsWith('#')) {
        return Color(int.parse(colorCode.substring(1), radix: 16) | 0xFF000000);
      }
      return Colors.grey;
    } catch (e) {
      return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/transactions/providers/smart_categorization_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/transactions/services/smart_categorization_service.dart';
import 'package:the_accountant/features/transactions/widgets/amount_input.dart';
import 'package:the_accountant/features/transactions/widgets/category_grid_selector.dart';
import 'package:the_accountant/features/transactions/widgets/wallet_selector.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

/// Transaction creation steps
enum TransactionStep {
  amount,
  category,
  details,
}

/// Show the transaction bottom sheet
Future<void> showTransactionBottomSheet(BuildContext context) {
  return showModalBottomSheet(
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
  ConsumerState<TransactionBottomSheet> createState() => _TransactionBottomSheetState();
}

class _TransactionBottomSheetState extends ConsumerState<TransactionBottomSheet> {
  TransactionStep _currentStep = TransactionStep.amount;

  // Transaction data
  double _amount = 0.0;
  bool _isIncome = false;
  Category? _selectedCategory;
  String? _selectedWalletId;
  String _title = '';
  String _notes = '';
  DateTime _date = DateTime.now();

  bool _isSaving = false;

  // Smart categorization
  final TextEditingController _titleController = TextEditingController();
  CategorySuggestion? _categorySuggestion;
  bool _isCheckingSuggestion = false;

  @override
  void initState() {
    super.initState();
    // Get default wallet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final walletNotifier = ref.read(walletProvider.notifier);
      setState(() {
        _selectedWalletId = walletNotifier.getDefaultWalletId();
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

    setState(() {
      _isSaving = true;
    });

    try {
      final transactionNotifier = ref.read(transactionProvider.notifier);
      final walletNotifier = ref.read(walletProvider.notifier);

      await transactionNotifier.addTransaction(
        amount: _amount,
        isIncome: _isIncome,
        category: _selectedCategory?.name ?? '',
        categoryId: _selectedCategory?.id ?? '',
        walletId: _selectedWalletId ?? walletNotifier.getDefaultWalletId() ?? '',
        date: _date,
        notes: _notes,
        title: _title,
      );

      // Update wallet balance
      if (_selectedWalletId != null) {
        await walletNotifier.balanceService.updateBalanceAfterTransaction(
          walletId: _selectedWalletId!,
          amount: _amount,
          isIncome: _isIncome,
        );
        await walletNotifier.loadWallets();
      }

      // Learn from this transaction for smart categorization
      if (_title.isNotEmpty && _selectedCategory != null) {
        final smartCategorizationService = ref.read(smartCategorizationServiceProvider);
        await smartCategorizationService.addTitleAssociation(
          title: _title,
          categoryId: _selectedCategory!.id,
          isExactMatch: true,
        );
      }

      if (mounted) {
        HapticFeedback.mediumImpact();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isIncome ? 'Income added!' : 'Expense added!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: _isIncome ? Colors.green : Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showError('Failed to save transaction');
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
              _currentStep == TransactionStep.amount ? Icons.close : Icons.arrow_back,
            ),
            onPressed: _previousStep,
          ),

          // Title
          Expanded(
            child: Text(
              _getStepTitle(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
          color: isActive ? color : theme.colorScheme.outline.withOpacity(0.3),
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
      child: AmountInput(
        initialAmount: _amount,
        isIncome: _isIncome,
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
      onAddCategory: () {
        // TODO: Open add category dialog
      },
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
          border: Border.all(
            color: categoryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 18,
              color: categoryColor,
            ),
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
              color: categoryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.category,
              color: categoryColor,
            ),
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedCategory?.name ?? 'Category',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
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
            '\$${_amount.toStringAsFixed(2)}',
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
          'Date',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _date,
              firstDate: DateTime(2000),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              setState(() {
                _date = date;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
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
            color: theme.colorScheme.outline.withOpacity(0.1),
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
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

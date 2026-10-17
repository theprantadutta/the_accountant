import 'package:flutter/material.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/features/ai/screens/receipt_scanner_screen.dart';
import 'package:the_accountant/features/ai_assistant/widgets/quick_add_sheet.dart';
import 'package:the_accountant/shared/widgets/neo_button.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart'
    show Wallet, Transaction, TitleUsage;
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart'
    hide Transaction;
import 'package:the_accountant/features/transactions/providers/title_usage_provider.dart';
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
import 'package:the_accountant/features/wallets/screens/wallet_management_screen.dart';
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
  String? prefillCategoryName,
  DateTime? prefillDate,
  String? prefillNote,
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
          prefillCategoryName: prefillCategoryName,
          prefillDate: prefillDate,
          prefillNote: prefillNote,
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

  /// A category picked by name (from a receipt or a typed note).
  final String? prefillCategoryName;
  final DateTime? prefillDate;
  final String? prefillNote;
  final TransactionSpecialType? initialSpecialType;

  const AddTransactionScreen({
    super.key,
    this.initialType = TransactionTypeSelection.expense,
    this.existingTransaction,
    this.prefillAmount,
    this.prefillTitle,
    this.prefillCategoryName,
    this.prefillDate,
    this.prefillNote,
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
  bool _subscriptionAskFirst = false;

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

  /// What actually landed in the destination, when the two accounts count in
  /// different currencies. Zero means "use the app's own rate".
  ///
  /// Asked for rather than always computed because a bank's rate and its
  /// charges are not the mid-market figure, and the user is the one who can see
  /// what arrived.
  double _receivedAmount = 0;

  /// Anchors the suggestion list so it can be scrolled into view.
  final GlobalKey _suggestionsKey = GlobalKey();

  /// The query the list was last scrolled for, so it is not re-scrolled on
  /// every rebuild — only when what is being offered actually changes.
  String? _scrolledSuggestionsFor;

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
    // Suggestions are shown only while the field is focused, so the screen has
    // to hear about focus changing.
    _titleFocusNode.addListener(_onTitleFocusChanged);

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

  /// Open the receipt scanner and prefill this form from what it read.
  Future<void> _scanReceipt() async {
    HapticFeedback.lightImpact();

    final result = await Navigator.of(context).push<ReceiptScanResult>(
      MaterialPageRoute(
        builder: (_) => const ReceiptScannerScreenGated(returnResult: true),
      ),
    );
    if (result == null || !mounted) return;
    _applyDraft(
      title: result.title,
      amount: result.amount > 0 ? result.amount : null,
      categoryName: result.category,
      date: result.date,
      note: result.note,
    );
  }

  /// "Describe it": a typed note becomes a filled-in form.
  Future<void> _quickAdd() async {
    HapticFeedback.lightImpact();
    final draft = await showQuickAddSheet(context);
    if (draft == null || !mounted) return;
    // Closing the sheet hands focus back to the title field it was opened
    // from; leave the filled-in form unfocused instead, so no cursor or
    // keyboard sits over it. A frame later, once that hand-back has run.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _titleFocusNode.unfocus();
    });
    _applyDraft(
      title: draft.title,
      amount: draft.amount,
      isIncome: draft.isIncome,
      categoryName: draft.category,
      walletName: draft.wallet,
      date: draft.date,
      note: draft.note,
    );
  }

  /// Fills the form from an AI draft, leaving alone anything it did not say.
  void _applyDraft({
    String? title,
    double? amount,
    bool? isIncome,
    String? categoryName,
    String? walletName,
    DateTime? date,
    String? note,
  }) {
    setState(() {
      if (isIncome != null && !_isTransfer) {
        final type = isIncome
            ? TransactionTypeSelection.income
            : TransactionTypeSelection.expense;
        if (type != _transactionType) {
          _transactionType = type;
          _selectedCategoryId = null;
          _selectedCategory = null;
        }
      }
      if (amount != null && amount > 0) _amount = amount;
      if ((title ?? '').trim().isNotEmpty) {
        _titleController.text = title!.trim();
      }
      if (date != null) _selectedDateTime = _onDay(date);
      if ((note ?? '').trim().isNotEmpty) _notesController.text = note!.trim();
      if (walletName != null) {
        final wallet = ref
            .read(selectableWalletsProvider)
            .where((w) => w.name.toLowerCase() == walletName.toLowerCase())
            .firstOrNull;
        if (wallet != null) _selectedWalletId = wallet.id;
      }
    });
    _pickCategoryByName(categoryName);
  }

  /// Selects the category of that name for the current type, if there is one.
  void _pickCategoryByName(String? name) {
    if (name == null || name.trim().isEmpty) return;
    final type = _isIncome ? 'income' : 'expense';
    final match = ref
        .read(categoryProvider)
        .selectable
        .where(
          (c) =>
              c.type == type &&
              c.name.toLowerCase() == name.trim().toLowerCase(),
        )
        .firstOrNull;
    if (match != null) {
      setState(() {
        _selectedCategoryId = match.id;
        _selectedCategory = match;
      });
    }
  }

  /// [day] at the current time of day: an AI draft knows the date, not the time.
  DateTime _onDay(DateTime day) {
    final now = DateTime.now();
    return DateTime(day.year, day.month, day.day, now.hour, now.minute);
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
            _subscriptionAskFirst = !config.autoPay;
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
    if (widget.prefillDate != null) {
      _selectedDateTime = _onDay(widget.prefillDate!);
    }
    if ((widget.prefillNote ?? '').isNotEmpty) {
      _notesController.text = widget.prefillNote!;
    }
    if (widget.prefillCategoryName != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _pickCategoryByName(widget.prefillCategoryName),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wallets = ref.read(selectableWalletsProvider);
      if (wallets.isEmpty) return;

      setState(() {
        _selectedWalletId = wallets.first.id;
        _fromWalletId = wallets.first.id;
        // The default pair has to be a pair a transfer is allowed to use, or
        // the form opens already holding a combination it will refuse to save.
        _toWalletId = _firstWalletOtherThan(wallets, wallets.first)?.id;
      });
    });
  }

  /// The currency of [walletId], or the first account's if it cannot be found.
  ///
  /// Falls back to the chosen display currency when there is no account at all,
  /// rather than reaching for `first` on an empty list.
  String _currencyOf(List<Wallet> wallets, String? walletId) {
    final match = wallets.where((w) => w.id == walletId).firstOrNull;
    return (match ?? wallets.firstOrNull)?.currency ??
        ref.read(settingsProvider).currency;
  }

  /// The account [id] names, or the first one, on a list known to be non-empty.
  ///
  /// Every caller sits below the `wallets.isEmpty` guard in [build], so the
  /// fallback is safe rather than hopeful. It is written as one helper so that
  /// the assumption is stated once instead of at each picker, which is how the
  /// empty list got past three of them.
  Wallet _pick(List<Wallet> wallets, String? id) =>
      wallets.where((w) => w.id == id).firstOrNull ?? wallets.first;

  /// The first wallet that is not [origin].
  ///
  /// Any other account will do now. Transfers used to have to stay within one
  /// currency, so this looked for a currency match and both pickers hid
  /// everything else — which quietly made a supported feature unreachable once
  /// the service and the server had learned to cross currencies.
  Wallet? _firstWalletOtherThan(List<Wallet> wallets, Wallet origin) {
    for (final wallet in wallets) {
      if (wallet.id != origin.id) return wallet;
    }
    return null;
  }

  /// Whether the current pair of accounts count in different currencies.
  bool _transferCrossesCurrency(List<Wallet> wallets) {
    if (wallets.isEmpty || _fromWalletId == null || _toWalletId == null) {
      return false;
    }
    return _currencyOf(wallets, _fromWalletId) !=
        _currencyOf(wallets, _toWalletId);
  }

  void _loadCategoryDetails() {
    if (_selectedCategoryId != null) {
      final categories = ref.read(categoryProvider).categories;
      final category = categories
          .where((c) => c.id == _selectedCategoryId)
          .firstOrNull;
      setState(() {
        _selectedCategory = category;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _titleFocusNode.removeListener(_onTitleFocusChanged);
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _onTypeChanged(TransactionTypeSelection type) {
    final wallets = ref.read(selectableWalletsProvider);

    if (type == TransactionTypeSelection.transfer && wallets.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context).txYouNeedAtLeast2),
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
    final wallet =
        ref
            .read(walletProvider)
            .wallets
            .where((w) => w.id == walletId)
            .firstOrNull ??
        ref.read(selectableWalletsProvider).firstOrNull;
    final currencySymbol = CurrencyInfo.getSymbol(
      wallet?.currency ?? ref.read(settingsProvider).currency,
    );

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

  /// Teach the app where a title belongs, from a transaction just created.
  ///
  /// A "contains" rule rather than an exact one, because titles carry noise --
  /// a card reference, a branch, a date -- and a rule that only fires on an
  /// exact repeat would almost never fire at all. Silent by design: a failure
  /// here must not fail the save the user actually asked for.
  Future<void> _learnTitleRule() async {
    final title = _titleController.text.trim();
    final categoryId = _selectedCategoryId;
    if (title.isEmpty || title.length < 3 || categoryId == null) return;

    try {
      await ref
          .read(databaseProvider)
          .setAssociatedTitle(title: title, categoryId: categoryId);
    } catch (_) {
      // Not worth interrupting anyone for.
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
              // Zero means "not stated", which is different from zero received.
              receivedAmount: _receivedAmount > 0
                  ? (_receivedAmount * 100).round()
                  : null,
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
            autoPay: !_subscriptionAskFirst,
          );
          ref.read(subscriptionDashboardProvider.notifier).refresh();
        }

        // Remember where this title was filed, so the next one like it lands
        // in the same place. Only on create: an edit is as often a correction
        // to this one row as it is a change of mind about the rule, and the
        // rules screen is where a rule is meant to be changed deliberately.
        await _learnTitleRule();
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
          autoPay: !_subscriptionAskFirst,
        );
      } else {
        await recurringService.createRecurringConfig(
          baseTransactionId: transactionId,
          reoccurrence: _subscriptionFrequency,
          periodLength: _subscriptionPeriodLength,
          startDate: _selectedDateTime,
          endDate: _subscriptionEndDate,
          autoPay: !_subscriptionAskFirst,
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
      label: L10n.of(context).txPaymentMethod,
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
      label: L10n.of(context).entityBudget,
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
      label: L10n.of(context).txObjective,
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
        title: Text(
          L10n.of(context).txDeleteTransaction,
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          L10n.of(context).txAreYouSureYouWant,
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              L10n.of(context).actionCancel,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              L10n.of(context).actionDelete,
              style: TextStyle(color: AppColors.error),
            ),
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
    final wallets = ref.watch(selectableWalletsProvider);

    // Nothing on this form can be saved without an account to file it against,
    // and every picker below assumes there is at least one. The screen can
    // open before the accounts have been read back (a cold-start shortcut), and
    // an archived account still counts for the shell's wallet gate while this
    // list leaves it out. The first is a wait, the second a dead end.
    if (wallets.isEmpty) {
      return ref.watch(walletsLoadingProvider)
          ? _buildLoadingAccounts()
          : _buildNoAccounts();
    }
    // Any two accounts: each leg of a transfer carries its own currency.
    final canTransfer = wallets.length > 1;

    final walletId = _isTransfer ? _fromWalletId : _selectedWalletId;
    final currentWallet = wallets.firstWhere(
      (w) => w.id == walletId,
      orElse: () => wallets.first,
    );
    final currencySymbol = CurrencyInfo.getSymbol(currentWallet.currency);
    final c = context.sunrise;
    final l10n = L10n.of(context);

    final sheet = Container(
      decoration: BoxDecoration(
        color: c.base,
        borderRadius: SunriseRadius.sheetTop,
      ),
      padding: const EdgeInsets.fromLTRB(
        SunriseSpace.screenX,
        26,
        SunriseSpace.screenX,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_isTransfer) ...[
            _buildTransferWalletSelectors(wallets, currencySymbol),
            const SizedBox(height: SunriseSpace.section),
          ] else ...[
            SectionLabel(l10n.addCategory),
            _buildCategoryGrid(),
            const SizedBox(height: SunriseSpace.section),
          ],
          SunriseCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTitleInput(),
                _buildTitleSuggestions(),
                if (!_isTransfer) ...[
                  Divider(height: 1, color: c.divider),
                  _buildWalletRow(wallets),
                ],
                Divider(height: 1, color: c.divider),
                CompactDateTimePicker(
                  selectedDateTime: _selectedDateTime,
                  onDateTimeChanged: (dateTime) {
                    setState(() => _selectedDateTime = dateTime);
                  },
                  accentColor: c.accent,
                  dateFormat: ref.watch(dateFormatSettingProvider),
                ),
                Divider(height: 1, color: c.divider),
                _buildNotesInput(),
              ],
            ),
          ),
          if (!_isTransfer) ...[
            const SizedBox(height: SunriseSpace.gap),
            _buildRepeatMonthlyRow(),
            const SizedBox(height: SunriseSpace.section),
            SectionLabel(l10n.addMoreOptions),
            _buildSpecialTypeChips(),
            if (_specialType == TransactionSpecialType.subscription ||
                _specialType == TransactionSpecialType.repetitive)
              _buildSubscriptionConfigSection(),
            const SizedBox(height: 12),
            LoanTypeChips(
              selectedType: _specialType,
              onTypeChanged: (type) => setState(() => _specialType = type),
              accentColor: c.accent,
            ),
            // Optional links (hidden when the user has none)
            _buildPaymentMethodSelector(),
            _buildBudgetSelector(),
            _buildObjectiveSelector(),
          ],
        ],
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: c.base,
        systemNavigationBarIconBrightness: c.isDark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: c.base,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: SunriseContentWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(canTransfer, currencySymbol),
                      // The sheet rides up over the header by a few dozen dp.
                      Transform.translate(
                        offset: const Offset(0, -40),
                        child: sheet,
                      ),
                    ],
                  ),
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

  String _typeLabel(TransactionTypeSelection type) {
    final l10n = L10n.of(context);
    return switch (type) {
      TransactionTypeSelection.expense => l10n.addTypeExpense,
      TransactionTypeSelection.income => l10n.addTypeIncome,
      TransactionTypeSelection.transfer => l10n.addTypeTransfer,
    };
  }

  /// The full-bleed sunrise header: close, title, scan (or delete), the type
  /// control and the big amount.
  Widget _buildHeader(bool canTransfer, String currencySymbol) {
    final c = context.sunrise;
    final l10n = L10n.of(context);
    final title = _isEditing
        ? l10n.addEditTitle
        : switch (_transactionType) {
            TransactionTypeSelection.expense => l10n.addNewExpense,
            TransactionTypeSelection.income => l10n.addNewIncome,
            TransactionTypeSelection.transfer => l10n.addNewTransfer,
          };
    final onGlass = c.onFill.withValues(alpha: .18);

    return Container(
      decoration: BoxDecoration(gradient: c.headerGradient),
      padding: EdgeInsets.fromLTRB(
        SunriseSpace.screenX,
        MediaQuery.paddingOf(context).top + 8,
        SunriseSpace.screenX,
        76,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SunriseIconButton(
                icon: Symbols.close_rounded,
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                background: onGlass,
                foreground: c.onFill,
                onTap: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.pushTitle.copyWith(color: c.onFill),
                ),
              ),
              if (_isEditing)
                SunriseIconButton(
                  icon: Symbols.delete_rounded,
                  tooltip: l10n.addDelete,
                  background: onGlass,
                  foreground: c.onFill,
                  onTap: _deleteTransaction,
                )
              else ...[
                SunriseIconButton(
                  icon: Symbols.auto_awesome_rounded,
                  tooltip: l10n.quickAddTitle,
                  background: onGlass,
                  foreground: c.onFill,
                  onTap: _quickAdd,
                ),
                const SizedBox(width: 8),
                SunriseIconButton(
                  icon: Symbols.document_scanner_rounded,
                  tooltip: l10n.addScanReceipt,
                  background: onGlass,
                  foreground: c.onFill,
                  onTap: _scanReceipt,
                ),
              ],
            ],
          ),
          const SizedBox(height: 22),
          _buildTypeSelector(canTransfer),
          const SizedBox(height: 26),
          _buildAmountDisplay(currencySymbol),
        ],
      ),
    );
  }

  /// Expense / Income / Transfer on the header gradient.
  ///
  /// What a transaction *is* cannot be edited (an expense cannot become a
  /// transfer, because a transfer is a pair of rows), so while editing only
  /// the current type is shown and it cannot be changed.
  Widget _buildTypeSelector(bool canTransfer) {
    final List<TransactionTypeSelection> types;
    if (_isEditing) {
      types = [_transactionType];
    } else if (canTransfer) {
      types = TransactionTypeSelection.values;
    } else {
      types = [
        TransactionTypeSelection.expense,
        TransactionTypeSelection.income,
      ];
    }

    return KeyedSubtree(
      // Named so a test can ask what the type chips say without also matching
      // the save button, which is labelled "Transfer" in transfer mode too.
      key: const ValueKey('transaction-type-selector'),
      child: SunriseSegmented<TransactionTypeSelection>(
        onGradient: true,
        height: 46,
        value: _transactionType,
        options: [for (final t in types) SegmentOption(t, _typeLabel(t))],
        onChanged: _isEditing ? (_) {} : _onTypeChanged,
      ),
    );
  }

  /// The amount at 64/600 in white, decimals at half strength. Tapping opens
  /// the calculator keypad.
  Widget _buildAmountDisplay(String currencySymbol) {
    final c = context.sunrise;
    final l10n = L10n.of(context);
    final hasAmount = _amount > 0;
    final whole = _formatAmount(_amount.truncateToDouble());
    final cents = ((_amount * 100).round() % 100).toString().padLeft(2, '0');
    final big = SunriseType.amountHero.copyWith(color: c.onFill);

    return Semantics(
      button: true,
      label: '${l10n.addAmount} $currencySymbol${_formatAmount(_amount)}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.selectionClick();
          _showCalculator();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.addAmount,
              style: SunriseType.label.copyWith(
                color: c.onFill.withValues(alpha: .85),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    currencySymbol,
                    style: big.copyWith(
                      fontSize: 54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(whole, style: big),
                  Text(
                    '.$cents',
                    style: big.copyWith(color: c.onFill.withValues(alpha: .5)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hasAmount ? 'Tap to edit amount' : 'Tap to enter amount',
              style: SunriseType.caption.copyWith(
                color: c.onFill.withValues(alpha: .8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Three likely categories as tiles, plus More for the full picker.
  Widget _buildCategoryGrid() {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final wantType = _isIncome ? 'income' : 'expense';
    final usable = ref
        .watch(categoryProvider)
        .selectable
        .where((cat) => !cat.isSystem && cat.mainCategoryId == null)
        .toList();
    final ofType = usable.where((cat) => cat.type == wantType).toList();
    final pool = ofType.isEmpty ? usable : ofType;

    final shown = <Category>[];
    if (_selectedCategory != null) shown.add(_selectedCategory!);
    for (final cat in pool) {
      if (shown.length >= 3) break;
      if (!shown.any((s) => s.id == cat.id)) shown.add(cat);
    }

    return LayoutBuilder(
      builder: (context, box) {
        final slot = box.maxWidth / 4;
        final tile = (slot - 20).clamp(48.0, 56.0);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final cat in shown)
              CategoryTile(
                icon: cat.iconName != null
                    ? IconRegistry.getIcon(cat.iconName!)
                    : Symbols.category_rounded,
                emoji: IconRegistry.emojiOf(cat.iconName),
                label: cat.name,
                size: tile,
                width: slot - 4,
                selected: cat.id == _selectedCategoryId,
                onTap: () => setState(() {
                  _selectedCategoryId = cat.id;
                  _selectedCategory = cat;
                }),
              ),
            for (var i = shown.length; i < 3; i++) SizedBox(width: slot - 4),
            CategoryTile(
              icon: Symbols.grid_view_rounded,
              label: l10n.addMore,
              size: tile,
              width: slot - 4,
              selected: false,
              color: c.accent,
              onTap: () => _showCategoryPicker(),
            ),
          ],
        );
      },
    );
  }

  /// "Repeat monthly": a shortcut onto the existing repetitive type.
  Widget _buildRepeatMonthlyRow() {
    final c = context.sunrise;
    final on =
        _specialType == TransactionSpecialType.repetitive &&
        _subscriptionFrequency == 'monthly' &&
        _subscriptionPeriodLength == 1;
    return SunriseCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: SettingsRow(
        icon: Symbols.repeat_rounded,
        iconBackground: Colors.transparent,
        iconColor: c.accent,
        title: L10n.of(context).addRepeatMonthly,
        trailing: SettingsTrailing.none,
        onTap: () => _setRepeatMonthly(!on),
        trailingWidget: SunriseToggle(
          value: on,
          semanticLabel: L10n.of(context).addRepeatMonthly,
          onChanged: _setRepeatMonthly,
        ),
      ),
    );
  }

  void _setRepeatMonthly(bool on) {
    setState(() {
      if (on) {
        _specialType = TransactionSpecialType.repetitive;
        _subscriptionFrequency = 'monthly';
        _subscriptionPeriodLength = 1;
      } else if (_specialType == TransactionSpecialType.repetitive) {
        _specialType = TransactionSpecialType.none;
      }
    });
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
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                L10n.of(context).txTransactionType,
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
                L10n.of(context).budgetEvery,
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
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: _subscriptionAskFirst,
            activeTrackColor: sectionColor,
            onChanged: (value) => setState(() => _subscriptionAskFirst = value),
            title: Text(
              L10n.of(context).subAskBeforeEachPayment,
              style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
            ),
            subtitle: Text(
              L10n.of(context).subAskBeforeEachPaymentHint,
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  /// The form's shell while the accounts are still being read.
  Widget _buildLoadingAccounts() => Scaffold(
    backgroundColor: Colors.transparent,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        icon: const CloseButtonIcon(),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(_isEditing ? 'Edit Transaction' : 'New Transaction'),
    ),
    body: const Center(child: CircularProgressIndicator()),
  );

  /// What the form shows when there is no account it could write to.
  ///
  /// Reached either by a user who has none yet or - far more likely, since the
  /// app routes that case to the create-first-account screen - by one who has
  /// closed every account they had. Both are fixed in the same place, so both
  /// get sent there.
  Widget _buildNoAccounts() {
    final l10n = L10n.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          icon: const CloseButtonIcon(),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(_isEditing ? 'Edit Transaction' : 'New Transaction'),
      ),
      body: Center(
        child: Padding(
          padding: AppSpacing.paddingXl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 48,
                color: AppColors.textMuted,
              ),
              AppSpacing.gapLg,
              Text(
                l10n.txNoAccountTitle,
                textAlign: TextAlign.center,
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.gapSm,
              Text(
                l10n.txNoAccountBody,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textMuted),
              ),
              AppSpacing.gapXl,
              NeoButton(
                label: l10n.txNoAccountAction,
                leadingIcon: Icons.account_balance_wallet_outlined,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const WalletManagementScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Wallet: the chosen account, tap to pick another.
  Widget _buildWalletRow(List<Wallet> wallets) {
    final c = context.sunrise;
    final l10n = L10n.of(context);
    final selected = _pick(wallets, _selectedWalletId);
    String label(Wallet w) => '${w.name} (${w.currency})';

    return Pressable(
      scale: .985,
      onTap: () async {
        final chosen = await showSunriseSheet<String>(
          context: context,
          builder: (sheet) => SunriseBottomSheet(
            title: l10n.addWallet,
            child: Column(
              children: [
                for (final w in wallets)
                  SheetAction(
                    icon: Symbols.account_balance_wallet_rounded,
                    label: w.name,
                    subtitle: w.currency,
                    selected: w.id == selected.id,
                    onTap: () => Navigator.pop(sheet, w.id),
                  ),
              ],
            ),
          ),
        );
        if (chosen != null) setState(() => _selectedWalletId = chosen);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(
              Symbols.account_balance_wallet_rounded,
              color: c.accent,
              size: 24,
            ),
            const SizedBox(width: 14),
            Text(
              l10n.addWallet,
              style: SunriseType.rowTitle.copyWith(color: c.ink),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label(selected),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: SunriseType.rowTitle.copyWith(color: c.ink),
              ),
            ),
            const SizedBox(width: 6),
            Icon(Symbols.chevron_right_rounded, color: c.chevron, size: 20),
          ],
        ),
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
            selectedItem: _pick(wallets, _fromWalletId),
            labelBuilder: (wallet) => '${wallet.name} (${wallet.currency})',
            onSelected: (wallet) {
              setState(() {
                _fromWalletId = wallet.id;
                // The only pair a transfer still refuses is an account with
                // itself, so the destination moves only when it collides.
                if (_toWalletId == null || _toWalletId == wallet.id) {
                  _toWalletId = _firstWalletOtherThan(wallets, wallet)?.id;
                }
                // A pair that no longer crosses currencies has nothing left to
                // receive; leaving a stale figure would re-price the transfer.
                if (!_transferCrossesCurrency(wallets)) _receivedAmount = 0;
              });
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
              setState(() {
                _toWalletId = wallet.id;
                if (!_transferCrossesCurrency(wallets)) _receivedAmount = 0;
              });
            },
            padding: EdgeInsets.zero,
          ),
          if (_transferCrossesCurrency(wallets)) ...[
            AppSpacing.gapLg,
            _buildReceivedAmountSection(wallets),
          ],
          // Only offered when creating. Editing a transfer updates the pair and
          // nothing else, so a fee control here would look like it saved
          // something when it did not.
          if (!_isEditing) ...[
            AppSpacing.gapLg,
            _buildTransferFeeSection(wallets),
          ],
        ],
      ),
    );
  }

  /// What actually landed on the other side of a cross-currency transfer.
  ///
  /// Only shown when the two accounts count in different currencies, because
  /// within one currency a transfer moves a single figure and asking twice
  /// would invite the two to disagree.
  ///
  /// The user is asked rather than told: a bank's rate and its charges are not
  /// the mid-market number, and they are the one who can see what arrived. Left
  /// at zero, the app's own stored rate is used — and if it has none, the
  /// service refuses rather than inventing one.
  Widget _buildReceivedAmountSection(List<Wallet> wallets) {
    final destination = wallets.firstWhere(
      (w) => w.id == _toWalletId,
      orElse: () => wallets.last,
    );
    final symbol = CurrencyInfo.getSymbol(destination.currency);

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
          Text('Amount received', style: AppTypography.titleSmall),
          Text(
            'These accounts count in different currencies. Enter what actually '
            'landed in ${destination.name}, or leave it blank to use the '
            "app's rate.",
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          AppSpacing.gapMd,
          InkWell(
            key: const Key('transfer_received_amount'),
            onTap: () => _showReceivedCalculator(symbol),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.currency_exchange,
                    size: AppSpacing.iconSm,
                    color: AppColors.textMuted,
                  ),
                  AppSpacing.gapHMd,
                  Expanded(
                    child: Text(
                      'In ${destination.currency}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Text(
                    '$symbol${_receivedAmount.toStringAsFixed(2)}',
                    style: AppTypography.monoMedium.copyWith(
                      color: _receivedAmount > 0
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
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

  Future<void> _showReceivedCalculator(String currencySymbol) async {
    final amount = await showCalculatorBottomSheet(
      context: context,
      initialAmount: _receivedAmount,
      isIncome: true,
      currencySymbol: currencySymbol,
      accentColor: AppColors.success,
    );

    if (amount != null) {
      setState(() => _receivedAmount = amount);
    }
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
  Widget _buildTransferFeeSection(List<Wallet> wallets) {
    if (!_showFeeFields) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => setState(() => _showFeeFields = true),
          icon: const Icon(Icons.add, size: AppSpacing.iconXs),
          label: Text(L10n.of(context).txAddATransferFee),
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
    final chargedTo = _pick(wallets, _feeWalletId ?? _fromWalletId);

    // The fee is its own expense on that wallet, so it is counted in that
    // wallet's money — not the transfer's. Those are the same currency when the
    // charge comes off the source, and need not be when it does not: this field
    // was labelled with the transfer's symbol either way, which showed a charge
    // billed to a taka wallet as though it were dollars.
    final feeCurrencySymbol = CurrencyInfo.getSymbol(chargedTo.currency);

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
                child: Text(
                  L10n.of(context).txTransferFee,
                  style: AppTypography.titleSmall,
                ),
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
                child: Text(L10n.of(context).txRemove),
              ),
            ],
          ),
          Text(
            L10n.of(context).txChargedSeparatelySoTheTransfer,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          AppSpacing.gapMd,

          InkWell(
            onTap: () => _showFeeCalculator(feeCurrencySymbol),
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
                      L10n.of(context).filterAmount,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Text(
                    '$feeCurrencySymbol${_feeAmount.toStringAsFixed(2)}',
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
            L10n.of(context).txDeductedFrom,
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

  void _onTitleFocusChanged() {
    if (mounted) setState(() {});
    if (!_titleFocusNode.hasFocus) _applyNamingRule();
  }

  /// Let a naming rule file the transaction, once the title is settled.
  ///
  /// Rules were stored, edited, listed and synced, and nothing read one. A user
  /// who wrote "anything called Tesco is Groceries" saw it change nothing,
  /// because the form only ever suggested categories from transaction history.
  ///
  /// Applied on losing focus rather than on every keystroke: a rule matching a
  /// prefix of what is still being typed would file the row under something the
  /// user has not finished naming. Only when nothing has been chosen yet — a
  /// rule is a default, and overruling a category the user picked by hand would
  /// be the app arguing with them.
  Future<void> _applyNamingRule() async {
    if (_isTransfer || _selectedCategoryId != null) return;

    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final categoryId = await ref.read(databaseProvider).categoryForTitle(title);
    if (categoryId == null || !mounted) return;
    if (_selectedCategoryId != null) return;

    final category = ref
        .read(categoryProvider)
        .categories
        .where((c) => c.id == categoryId)
        .firstOrNull;
    if (category == null) return;

    setState(() {
      _selectedCategoryId = category.id;
      _selectedCategory = category;
    });
  }

  /// Fill in a whole transaction's worth of decisions from one tap.
  ///
  /// A title the user has used before was filed under something last time, and
  /// almost always belongs there again — which is the entire point of offering
  /// it. Taking the title without the category would leave the slower half of
  /// the job undone.
  void _applyTitleSuggestion(TitleUsage suggestion) {
    HapticFeedback.selectionClick();

    final category = ref
        .read(categoryProvider)
        .selectable
        .where((c) => c.id == suggestion.categoryId)
        .firstOrNull;

    setState(() {
      _titleController.text = suggestion.title;
      _titleController.selection = TextSelection.fromPosition(
        TextPosition(offset: suggestion.title.length),
      );
      if (category != null) {
        _selectedCategoryId = category.id;
        _selectedCategory = category;
      }
    });

    // Title and category are both settled, so the only thing left is the
    // figure — which is where the guided flow would have arrived anyway, two
    // taps later.
    _titleFocusNode.unfocus();
    if (!_isTransfer && _amount == 0) {
      _showCalculator();
    }
  }

  Widget _buildTitleInput() {
    final c = context.sunrise;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: _titleController,
        focusNode: _titleFocusNode,
        onChanged: (_) => setState(() {}),
        textInputAction: TextInputAction.done,
        textCapitalization: TextCapitalization.sentences,
        style: SunriseType.rowTitle.copyWith(color: c.ink),
        decoration: InputDecoration(
          hintText: _isTransfer
              ? 'e.g. Move to savings (optional)'
              : 'What was it for?',
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          prefixIcon: Icon(Symbols.edit_rounded, color: c.accent, size: 24),
          prefixIconConstraints: const BoxConstraints(minWidth: 38),
        ),
        onSubmitted: (_) {
          // After the title, open the category picker (then the amount).
          if (!_isTransfer && _selectedCategoryId == null) {
            _showCategoryPicker(openAmountAfter: true);
          } else if (!_isTransfer && _amount == 0) {
            _showCalculator();
          }
        },
      ),
    );
  }

  /// Titles this user has entered before, offered while they type a new one.
  ///
  /// Sits under the field rather than floating over it: an overlay here would
  /// have to be positioned against a form that scrolls and resizes with the
  /// keyboard, and would cover the fields underneath while doing it.
  Widget _buildTitleSuggestions() {
    if (_isTransfer) return const SizedBox.shrink();
    if (!_titleFocusNode.hasFocus) return const SizedBox.shrink();

    final query = _titleController.text.trim();
    if (query.isEmpty) {
      _scrolledSuggestionsFor = null;
      return const SizedBox.shrink();
    }

    final matches = ref.watch(titleUsageSearchProvider(query)).asData?.value;
    if (matches == null || matches.isEmpty) return const SizedBox.shrink();

    // If the only match is what has already been typed, there is nothing left
    // to suggest.
    final useful = matches
        .where((m) => m.title.toLowerCase() != query.toLowerCase())
        .toList();
    if (useful.isEmpty) return const SizedBox.shrink();

    final categories = ref.watch(categoryProvider).categories;

    // The keyboard is up, so bring the suggestions into view once per set of
    // results.
    if (_scrolledSuggestionsFor != query) {
      _scrolledSuggestionsFor = query;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final anchor = _suggestionsKey.currentContext;
        if (anchor == null || !mounted) return;
        Scrollable.ensureVisible(
          anchor,
          duration: SunriseMotion.tab,
          curve: SunriseMotion.standard,
          alignment: 1.0,
        );
      });
    }

    final c = context.sunrise;
    return Padding(
      key: _suggestionsKey,
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        // Named so a test can ask what is being suggested without also matching
        // the text sitting in the field above it.
        key: const ValueKey('title-suggestions'),
        decoration: BoxDecoration(
          color: c.tintOrange,
          borderRadius: SunriseRadius.inputAll,
        ),
        child: Column(
          children: [
            for (final suggestion in useful.take(4))
              _TitleSuggestionRow(
                suggestion: suggestion,
                category: categories
                    .where((cat) => cat.id == suggestion.categoryId)
                    .firstOrNull,
                onTap: () => _applyTitleSuggestion(suggestion),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesInput() {
    final c = context.sunrise;
    return TextField(
      controller: _notesController,
      maxLines: 3,
      minLines: 1,
      textCapitalization: TextCapitalization.sentences,
      style: SunriseType.rowTitle.copyWith(color: c.ink),
      decoration: InputDecoration(
        hintText: L10n.of(context).addNoteHint,
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        prefixIcon: Icon(Symbols.notes_rounded, color: c.accent, size: 24),
        prefixIconConstraints: const BoxConstraints(minWidth: 38),
      ),
    );
  }

  Widget _buildSaveButton() {
    final c = context.sunrise;
    return DecoratedBox(
      decoration: BoxDecoration(color: c.base),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            SunriseSpace.screenX,
            8,
            SunriseSpace.screenX,
            12,
          ),
          child: SunriseContentWidth(
            child: NeoButton(
              label: _isEditing
                  ? 'Update'
                  : (_isTransfer ? 'Transfer' : 'Save'),
              onPressed: _canSave && !_isSaving ? _saveTransaction : null,
              isLoading: _isSaving,
              isExpanded: true,
              size: NeoButtonSize.large,
            ),
          ),
        ),
      ),
    );
  }
}

/// One previously-used title, with the category it carries.
///
/// Shows the category because the category is half of what tapping this does:
/// a row that only promised the words would be a worse trade than typing them.
class _TitleSuggestionRow extends StatelessWidget {
  const _TitleSuggestionRow({
    required this.suggestion,
    required this.category,
    required this.onTap,
  });

  final TitleUsage suggestion;
  final Category? category;
  final VoidCallback onTap;

  Color get _tint {
    final code = category?.colorCode;
    if (code == null || !code.startsWith('#')) return AppColors.primaryAccent;
    try {
      return Color(int.parse(code.substring(1), radix: 16) | 0xFF000000);
    } catch (_) {
      return AppColors.primaryAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusLg,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(
              Icons.history,
              size: AppSpacing.iconXs,
              color: AppColors.textMuted,
            ),
            AppSpacing.gapHMd,
            Expanded(
              child: Text(
                suggestion.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyMedium,
              ),
            ),
            if (category != null) ...[
              AppSpacing.gapHSm,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: _tint.withValues(alpha: 0.15),
                  borderRadius: AppSpacing.borderRadiusFull,
                ),
                child: Text(
                  category!.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSmall.copyWith(
                    letterSpacing: 0,
                    color: _tint,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

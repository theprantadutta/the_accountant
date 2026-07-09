import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/features/subscriptions/providers/subscription_dashboard_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart'
    hide Transaction;
import 'package:the_accountant/features/transactions/widgets/calculator_bottom_sheet.dart';
import 'package:the_accountant/features/transactions/widgets/horizontal_chip_selector.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart'
    show Wallet;

/// Show the edit subscription bottom sheet
Future<bool?> showEditSubscriptionBottomSheet(
  BuildContext context, {
  required SubscriptionItem item,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => EditSubscriptionBottomSheet(item: item),
  );
}

class EditSubscriptionBottomSheet extends ConsumerStatefulWidget {
  final SubscriptionItem item;

  const EditSubscriptionBottomSheet({super.key, required this.item});

  @override
  ConsumerState<EditSubscriptionBottomSheet> createState() =>
      _EditSubscriptionBottomSheetState();
}

class _EditSubscriptionBottomSheetState
    extends ConsumerState<EditSubscriptionBottomSheet> {
  late TextEditingController _titleController;
  late double _amount;
  late String _frequency;
  late int _periodLength;
  DateTime? _endDate;
  late String _walletId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _titleController = TextEditingController(text: item.name);
    // item.amount is integer cents; input accumulator works in major-unit dollars.
    _amount = item.amount / 100.0;
    _frequency = item.frequency.toLowerCase();
    _periodLength = item.periodLength;
    _endDate = item.config.endDate;
    _walletId = item.walletId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _showCalculator() async {
    final walletCurrency = ref.read(walletCurrencyProvider(_walletId));
    final currencySymbol = CurrencyInfo.getSymbol(walletCurrency);

    final isRepetitive =
        widget.item.specialType == TransactionSpecialType.repetitive;
    final calcAccent = isRepetitive ? AppColors.neonBlue : AppColors.neonPurple;

    final amount = await showCalculatorBottomSheet(
      context: context,
      initialAmount: _amount,
      isIncome: widget.item.isIncome,
      currencySymbol: currencySymbol,
      accentColor: calcAccent,
    );

    if (amount != null) {
      setState(() => _amount = amount);
    }
  }

  Future<void> _save() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      // Update the base transaction
      await ref
          .read(transactionProvider.notifier)
          .updateTransaction(
            id: widget.item.baseTransaction.id,
            title: _titleController.text.isEmpty ? null : _titleController.text,
            amount: (_amount * 100).round(), // dollars -> integer cents
            walletId: _walletId,
          );

      // Update recurring config
      await ref
          .read(subscriptionDashboardProvider.notifier)
          .updateSubscriptionConfig(
            configId: widget.item.config.id,
            reoccurrence: _frequency,
            periodLength: _periodLength,
            endDate: _endDate,
          );

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

  @override
  Widget build(BuildContext context) {
    final wallets = ref.watch(walletProvider).wallets;
    final walletCurrency = ref.watch(walletCurrencyProvider(_walletId));
    final currencySymbol = CurrencyInfo.getSymbol(walletCurrency);
    final frequencies = ['daily', 'weekly', 'monthly', 'yearly'];
    final isRepetitive =
        widget.item.specialType == TransactionSpecialType.repetitive;
    final accentColor = isRepetitive
        ? AppColors.neonBlue
        : AppColors.neonPurple;

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
          return _periodLength == 1 ? 'day' : 'days';
        case 'weekly':
          return _periodLength == 1 ? 'week' : 'weeks';
        case 'monthly':
          return _periodLength == 1 ? 'month' : 'months';
        case 'yearly':
          return _periodLength == 1 ? 'year' : 'years';
        default:
          return freq;
      }
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  color: AppColors.textSecondary,
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    isRepetitive ? 'Edit Recurring Bill' : 'Edit Subscription',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Title',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Subscription name',
                      hintStyle: TextStyle(color: AppColors.textMuted),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Amount
                  Text(
                    'Amount',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _showCalculator,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        '$currencySymbol${_amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Frequency
                  Row(
                    children: [
                      Icon(Icons.autorenew, size: 16, color: accentColor),
                      const SizedBox(width: 6),
                      Text(
                        'Frequency',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: accentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  HorizontalChipSelector<String>(
                    items: frequencies,
                    selectedItem: _frequency,
                    labelBuilder: frequencyLabel,
                    colorBuilder: (_) => accentColor,
                    onSelected: (freq) {
                      setState(() => _frequency = freq);
                    },
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 16),

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
                        onPressed: _periodLength > 1
                            ? () => setState(() => _periodLength--)
                            : null,
                        icon: Icon(Icons.remove_circle_outline, size: 22),
                        color: AppColors.textSecondary,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                      Container(
                        width: 36,
                        alignment: Alignment.center,
                        child: Text(
                          '$_periodLength',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _periodLength < 365
                            ? () => setState(() => _periodLength++)
                            : null,
                        icon: Icon(Icons.add_circle_outline, size: 22),
                        color: AppColors.textSecondary,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        periodUnit(_frequency),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // End date
                  GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate:
                            _endDate ??
                            DateTime.now().add(const Duration(days: 365)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          const Duration(days: 3650),
                        ),
                      );
                      if (date != null) {
                        setState(() => _endDate = date);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.event,
                            size: 18,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _endDate != null
                                  ? 'Ends: ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                                  : 'No end date',
                              style: TextStyle(
                                fontSize: 14,
                                color: _endDate != null
                                    ? AppColors.textPrimary
                                    : AppColors.textMuted,
                              ),
                            ),
                          ),
                          if (_endDate != null)
                            GestureDetector(
                              onTap: () => setState(() => _endDate = null),
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
                  const SizedBox(height: 20),

                  // Wallet
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
                      (w) => w.id == _walletId,
                      orElse: () => wallets.first,
                    ),
                    labelBuilder: (wallet) =>
                        '${wallet.name} (${wallet.currency})',
                    onSelected: (wallet) {
                      setState(() => _walletId = wallet.id);
                    },
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
          // Save button
          Container(
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
                  onPressed: !_isSaving ? _save : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.divider,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

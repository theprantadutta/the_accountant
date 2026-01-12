import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/wallets/widgets/wallet_list_item.dart';
import 'package:the_accountant/features/wallets/widgets/add_wallet_form.dart';

class WalletManagementScreen extends ConsumerStatefulWidget {
  const WalletManagementScreen({super.key});

  @override
  ConsumerState<WalletManagementScreen> createState() =>
      _WalletManagementScreenState();
}

class _WalletManagementScreenState
    extends ConsumerState<WalletManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  bool _isAddingWallet = false;

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _toggleAddWalletForm() {
    setState(() {
      _isAddingWallet = !_isAddingWallet;
    });
  }

  void _submitForm({
    required String currency,
    required String icon,
    required String color,
    required bool isDefault,
  }) {
    final walletNotifier = ref.read(walletProvider.notifier);
    walletNotifier.addWallet(
      name: _nameController.text,
      currency: currency,
      balance: double.tryParse(_balanceController.text) ?? 0.0,
      iconName: icon,
      color: color,
      isDefault: isDefault,
    );

    _nameController.clear();
    _balanceController.clear();
    setState(() {
      _isAddingWallet = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _toggleAddWalletForm,
          ),
        ],
      ),
      body: _isAddingWallet
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddWalletForm(
                    formKey: _formKey,
                    nameController: _nameController,
                    balanceController: _balanceController,
                    onSubmit: _submitForm,
                    onCancel: _toggleAddWalletForm,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            )
          : walletState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : walletState.wallets.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No wallets yet. Add your first wallet to get started.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: walletState.wallets.length,
                      itemBuilder: (context, index) {
                        final wallet = walletState.wallets[index];
                        return WalletListItem(
                          wallet: wallet,
                          onTap: () {
                            _showEditWalletSheet(wallet);
                          },
                          onEdit: () {
                            _showEditWalletSheet(wallet);
                          },
                          onDelete: () {
                            _showDeleteConfirmationDialog(wallet.id);
                          },
                        );
                      },
                    ),
    );
  }

  void _showDeleteConfirmationDialog(String walletId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primarySurface,
          title: Text(
            'Delete Wallet',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: Text(
            'Are you sure you want to delete this wallet? This action cannot be undone.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(walletProvider.notifier).deleteWallet(walletId);
                Navigator.of(context).pop();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
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
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.glassGradient,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: AppColors.glassBorder),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: AppSpacing.paddingLg,
              child: AddWalletForm(
                formKey: editFormKey,
                nameController: editNameController,
                balanceController: editBalanceController,
                initialCurrency: wallet.currency,
                initialIcon: wallet.iconName,
                initialColor: wallet.color,
                initialIsDefault: wallet.isDefault ?? false,
                isEditing: true,
                onSubmit: ({
                  required String currency,
                  required String icon,
                  required String color,
                  required bool isDefault,
                }) {
                  ref.read(walletProvider.notifier).updateWallet(
                    id: wallet.id,
                    name: editNameController.text,
                    currency: currency,
                    balance: double.tryParse(editBalanceController.text),
                    iconName: icon,
                    color: color,
                    isDefault: isDefault,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Wallet updated successfully'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                onCancel: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

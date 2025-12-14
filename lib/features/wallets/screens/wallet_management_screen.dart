import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isAddingWallet)
              AddWalletForm(
                formKey: _formKey,
                nameController: _nameController,
                balanceController: _balanceController,
                onSubmit: _submitForm,
                onCancel: _toggleAddWalletForm,
              ),
            const SizedBox(height: 16),
            if (walletState.wallets.isEmpty && !walletState.isLoading)
              const Center(
                child: Text(
                  'No wallets yet. Add your first wallet to get started.',
                  textAlign: TextAlign.center,
                ),
              )
            else if (walletState.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.builder(
                  itemCount: walletState.wallets.length,
                  itemBuilder: (context, index) {
                    final wallet = walletState.wallets[index];
                    return WalletListItem(
                      wallet: wallet,
                      onTap: () {
                        // Navigate to wallet detail screen
                      },
                      onEdit: () {
                        // Show edit form
                      },
                      onDelete: () {
                        _showDeleteConfirmationDialog(wallet.id);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(String walletId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Wallet'),
          content: const Text(
            'Are you sure you want to delete this wallet? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ref.read(walletProvider.notifier).deleteWallet(walletId);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

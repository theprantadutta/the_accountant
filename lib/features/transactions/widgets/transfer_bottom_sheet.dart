import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/transactions/providers/transfer_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

/// Show the transfer bottom sheet
Future<bool?> showTransferBottomSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const TransferBottomSheet(),
  );
}

/// Bottom sheet for creating wallet-to-wallet transfers.
/// Similar to Cashew's transfer flow with source/destination wallet selection.
class TransferBottomSheet extends ConsumerStatefulWidget {
  const TransferBottomSheet({super.key});

  @override
  ConsumerState<TransferBottomSheet> createState() =>
      _TransferBottomSheetState();
}

class _TransferBottomSheetState extends ConsumerState<TransferBottomSheet> {
  String? _sourceWalletId;
  String? _destinationWalletId;
  double _amount = 0.0;
  DateTime _date = DateTime.now();
  String _notes = '';
  final String _title = '';
  bool _isSaving = false;

  // Calculator display
  String _expression = '0';

  @override
  void initState() {
    super.initState();
    // Set default source wallet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final walletNotifier = ref.read(walletProvider.notifier);
      final defaultWalletId = walletNotifier.getDefaultWalletId();
      if (defaultWalletId != null) {
        setState(() {
          _sourceWalletId = defaultWalletId;
        });
      }
    });
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

  void _swapWallets() {
    HapticFeedback.lightImpact();
    setState(() {
      final temp = _sourceWalletId;
      _sourceWalletId = _destinationWalletId;
      _destinationWalletId = temp;
    });
  }

  Future<void> _saveTransfer() async {
    // Validate inputs
    if (_sourceWalletId == null) {
      _showError('Please select a source wallet');
      return;
    }
    if (_destinationWalletId == null) {
      _showError('Please select a destination wallet');
      return;
    }
    if (_sourceWalletId == _destinationWalletId) {
      _showError('Source and destination must be different');
      return;
    }
    if (_amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final success = await ref
          .read(transferProvider.notifier)
          .createTransfer(
            sourceWalletId: _sourceWalletId!,
            destinationWalletId: _destinationWalletId!,
            amount: _amount,
            date: _date,
            notes: _notes.isEmpty ? null : _notes,
            title: _title.isEmpty ? null : _title,
          );

      if (success && mounted) {
        HapticFeedback.mediumImpact();
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transfer created successfully!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.teal,
          ),
        );
      } else if (mounted) {
        _showError('Failed to create transfer');
      }
    } catch (e) {
      if (mounted) {
        _showError('Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  // Calculator methods
  void _onDigit(String digit) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_expression == '0' && digit != '.') {
        _expression = digit;
      } else {
        _expression += digit;
      }
      _updateAmount();
    });
  }

  void _onDecimal() {
    HapticFeedback.lightImpact();
    if (_expression.contains('.')) return;
    setState(() {
      _expression += '.';
    });
  }

  void _onBackspace() {
    HapticFeedback.lightImpact();
    setState(() {
      if (_expression.length > 1) {
        _expression = _expression.substring(0, _expression.length - 1);
      } else {
        _expression = '0';
      }
      _updateAmount();
    });
  }

  void _onClear() {
    HapticFeedback.mediumImpact();
    setState(() {
      _expression = '0';
      _amount = 0.0;
    });
  }

  void _updateAmount() {
    try {
      _amount = double.parse(_expression);
    } catch (e) {
      _amount = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletState = ref.watch(walletProvider);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(theme),

            // Wallet Selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildWalletSelection(theme, walletState),
            ),
            const SizedBox(height: 16),

            // Amount Display
            _buildAmountDisplay(theme),
            const SizedBox(height: 8),

            // Optional: Date and Notes
            _buildOptionalFields(theme),
            const SizedBox(height: 8),

            // Calculator Pad
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: bottomPadding,
                ),
                child: _buildCalculatorPad(theme),
              ),
            ),

            // Save Button
            _buildSaveButton(theme),
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
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Transfer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // Placeholder for balance
        ],
      ),
    );
  }

  Widget _buildWalletSelection(ThemeData theme, WalletState walletState) {
    final wallets = walletState.wallets;
    final walletNotifier = ref.read(walletProvider.notifier);

    final sourceWallet = _sourceWalletId != null
        ? walletNotifier.getWalletById(_sourceWalletId!)
        : null;
    final destWallet = _destinationWalletId != null
        ? walletNotifier.getWalletById(_destinationWalletId!)
        : null;

    return Row(
      children: [
        // Source Wallet
        Expanded(
          child: _buildWalletCard(
            theme,
            label: 'From',
            wallet: sourceWallet,
            wallets: wallets,
            onSelect: (wallet) => setState(() => _sourceWalletId = wallet.id),
            color: Colors.red.shade400,
          ),
        ),

        // Swap Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GestureDetector(
            onTap: _swapWallets,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.swap_horiz, color: theme.colorScheme.primary),
            ),
          ),
        ),

        // Destination Wallet
        Expanded(
          child: _buildWalletCard(
            theme,
            label: 'To',
            wallet: destWallet,
            wallets: wallets,
            onSelect: (wallet) =>
                setState(() => _destinationWalletId = wallet.id),
            color: Colors.green.shade400,
          ),
        ),
      ],
    );
  }

  Widget _buildWalletCard(
    ThemeData theme, {
    required String label,
    required Wallet? wallet,
    required List<Wallet> wallets,
    required ValueChanged<Wallet> onSelect,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => _showWalletPicker(wallets, onSelect),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: wallet != null
                ? color.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _parseColor(wallet?.color).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance_wallet,
                    size: 14,
                    color: _parseColor(wallet?.color),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    wallet?.name ?? 'Select',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: theme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showWalletPicker(List<Wallet> wallets, ValueChanged<Wallet> onSelect) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _WalletPickerSheet(
        wallets: wallets,
        onWalletSelected: (wallet) {
          onSelect(wallet);
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildAmountDisplay(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '\$',
            style: TextStyle(
              fontSize: 24,
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            _amount.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionalFields(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Date Picker
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() => _date = date);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(_date),
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Notes Button
          Expanded(
            child: GestureDetector(
              onTap: () => _showNotesDialog(theme),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notes,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _notes.isEmpty ? 'Add note' : _notes,
                        style: TextStyle(
                          fontSize: 12,
                          color: _notes.isEmpty
                              ? theme.colorScheme.onSurfaceVariant
                              : theme.colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotesDialog(ThemeData theme) {
    final controller = TextEditingController(text: _notes);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Transfer notes...'),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _notes = controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorPad(ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            _buildButton('7', theme, onTap: () => _onDigit('7')),
            _buildButton('8', theme, onTap: () => _onDigit('8')),
            _buildButton('9', theme, onTap: () => _onDigit('9')),
            _buildButton('C', theme, onTap: _onClear, isOperator: true),
          ],
        ),
        Row(
          children: [
            _buildButton('4', theme, onTap: () => _onDigit('4')),
            _buildButton('5', theme, onTap: () => _onDigit('5')),
            _buildButton('6', theme, onTap: () => _onDigit('6')),
            _buildButton(
              '\u232B',
              theme,
              onTap: _onBackspace,
              isOperator: true,
            ),
          ],
        ),
        Row(
          children: [
            _buildButton('1', theme, onTap: () => _onDigit('1')),
            _buildButton('2', theme, onTap: () => _onDigit('2')),
            _buildButton('3', theme, onTap: () => _onDigit('3')),
            const Expanded(child: SizedBox()), // Empty space
          ],
        ),
        Row(
          children: [
            _buildButton(
              '00',
              theme,
              onTap: () {
                _onDigit('0');
                _onDigit('0');
              },
            ),
            _buildButton('0', theme, onTap: () => _onDigit('0')),
            _buildButton('.', theme, onTap: _onDecimal),
            const Expanded(child: SizedBox()), // Empty space
          ],
        ),
      ],
    );
  }

  Widget _buildButton(
    String label,
    ThemeData theme, {
    VoidCallback? onTap,
    bool isOperator = false,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: isOperator
              ? theme.colorScheme.surfaceContainerHighest
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 56,
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: label.length > 1 ? 18 : 24,
                  fontWeight: FontWeight.w500,
                  color: isOperator
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(ThemeData theme) {
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
          onPressed: _isSaving ? null : _saveTransfer,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: Text(
            _isSaving ? 'Creating Transfer...' : 'Create Transfer',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Color _parseColor(String? colorCode) {
    if (colorCode == null) return Colors.indigo;
    try {
      if (colorCode.startsWith('#')) {
        return Color(int.parse(colorCode.substring(1), radix: 16) | 0xFF000000);
      }
      return Colors.indigo;
    } catch (e) {
      return Colors.indigo;
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

/// Bottom sheet for selecting a wallet
class _WalletPickerSheet extends StatelessWidget {
  final List<Wallet> wallets;
  final ValueChanged<Wallet> onWalletSelected;

  const _WalletPickerSheet({
    required this.wallets,
    required this.onWalletSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            'Select Wallet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          // Wallet List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: wallets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final wallet = wallets[index];
              return _buildWalletItem(context, theme, wallet);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildWalletItem(
    BuildContext context,
    ThemeData theme,
    Wallet wallet,
  ) {
    final color = _parseColor(wallet.color);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onWalletSelected(wallet);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.account_balance_wallet, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wallet.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    '\$${wallet.useDecimals ? wallet.balance.toStringAsFixed(2) : wallet.balance.round().toString()}',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String? colorCode) {
    if (colorCode == null) return Colors.indigo;
    try {
      if (colorCode.startsWith('#')) {
        return Color(int.parse(colorCode.substring(1), radix: 16) | 0xFF000000);
      }
      return Colors.indigo;
    } catch (e) {
      return Colors.indigo;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/core/providers/sync_provider.dart';
import 'package:the_accountant/core/services/biometric_service.dart';
import 'package:the_accountant/core/services/backend_auth_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/dashboard/providers/financial_data_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/settings/widgets/settings_tile.dart';
import 'package:the_accountant/features/settings/widgets/confirmation_dialog.dart';
import 'package:the_accountant/features/settings/widgets/destructive_confirmation_dialog.dart';
import 'package:the_accountant/features/settings/widgets/change_password_dialog.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/transactions/providers/payment_method_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/legal/legal_document_viewer.dart';

class PrivacySecurityScreen extends ConsumerStatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  ConsumerState<PrivacySecurityScreen> createState() =>
      _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends ConsumerState<PrivacySecurityScreen> {
  bool _isClearingCache = false;
  bool _isClearingData = false;
  bool? _hasPassword;
  final BackendAuthService _authService = BackendAuthService();

  @override
  void initState() {
    super.initState();
    _loadAuthProviders();
  }

  Future<void> _loadAuthProviders() async {
    try {
      final providers = await _authService.getAuthProviders();
      if (mounted) {
        setState(() {
          _hasPassword = providers['hasPassword'] as bool? ?? false;
        });
      }
    } catch (e) {
      // Default to true if we can't determine
      if (mounted) {
        setState(() => _hasPassword = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Privacy & Security'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          // SECURITY SECTION
          SettingsSection(
            title: 'SECURITY',
            tiles: [
              SettingsSwitchTile(
                icon: Icons.fingerprint,
                title: 'Biometric Lock',
                subtitle: 'Use fingerprint or face to unlock',
                value: settingsState.biometricLockEnabled,
                onChanged: (value) async {
                  if (value) {
                    // Check if biometrics are available
                    final isAvailable = await BiometricService().isAvailable();
                    if (!isAvailable) {
                      if (context.mounted) {
                        showErrorSnackBar(
                          context,
                          'Biometric authentication not available on this device',
                        );
                      }
                      return;
                    }
                    // Confirm identity before enabling
                    final authenticated = await BiometricService()
                        .authenticate();
                    if (!authenticated) return;
                  }
                  await ref
                      .read(settingsProvider.notifier)
                      .setBiometricLock(value);
                },
              ),
              if (settingsState.biometricLockEnabled)
                SettingsNavigationTile(
                  icon: Icons.timer_outlined,
                  title: 'Auto-lock',
                  subtitle: _getAutoLockLabel(
                    settingsState.autoLockTimeoutMinutes,
                  ),
                  onTap: () => _showAutoLockPicker(),
                ),
              SettingsNavigationTile(
                icon: Icons.lock_outline,
                title: _hasPassword == false
                    ? 'Set Password'
                    : 'Change Password',
                subtitle: _hasPassword == false
                    ? 'Add password to your account'
                    : 'Update your account password',
                onTap: () async {
                  final hasPassword = _hasPassword ?? true;
                  final result = await showChangePasswordDialog(
                    context: context,
                    hasPassword: hasPassword,
                    authService: _authService,
                  );
                  if (result == true && context.mounted) {
                    showSuccessSnackBar(
                      context,
                      hasPassword
                          ? 'Password changed successfully'
                          : 'Password set successfully',
                    );
                    // Refresh auth providers to update hasPassword state
                    _loadAuthProviders();
                  }
                },
              ),
            ],
          ),

          // DATA PRIVACY SECTION
          SettingsSection(
            title: 'DATA PRIVACY',
            tiles: [
              SettingsActionTile(
                icon: Icons.cached,
                title: 'Clear Cache',
                subtitle: 'Clear cached data and force re-sync',
                onTap: _isClearingCache ? () {} : _showClearCacheDialog,
              ),
              SettingsActionTile(
                icon: Icons.delete_forever,
                iconColor: AppColors.error,
                title: 'Clear All Data',
                subtitle: 'Delete all transactions, budgets, and settings',
                onTap: _isClearingData ? () {} : _showClearDataDialog,
              ),
            ],
          ),

          // LEGAL SECTION
          SettingsSection(
            title: 'LEGAL',
            tiles: [
              SettingsNavigationTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                onTap: _openPrivacyPolicy,
              ),
              SettingsNavigationTile(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                subtitle: 'Read our terms of service',
                onTap: _openTermsOfService,
              ),
            ],
          ),

          // DANGER ZONE
          SettingsSection(
            title: 'DANGER ZONE',
            tiles: [
              SettingsActionTile(
                icon: Icons.person_remove,
                iconColor: AppColors.error,
                title: 'Delete Account',
                subtitle: 'Permanently delete your account and all data',
                onTap: _showDeleteAccountDialog,
              ),
            ],
          ),

          SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  String _getAutoLockLabel(int minutes) {
    final timeouts = ref.read(autoLockTimeoutsProvider);
    final match = timeouts.firstWhere(
      (t) => t['value'] == minutes,
      orElse: () => {'label': '$minutes minutes'},
    );
    return match['label'];
  }

  Future<void> _showAutoLockPicker() async {
    final timeouts = ref.read(autoLockTimeoutsProvider);
    final currentTimeout = ref.read(settingsProvider).autoLockTimeoutMinutes;

    final selected = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.primarySurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildPickerSheet(
        title: 'Auto-lock Timeout',
        items: timeouts
            .map((t) => {'value': t['value'], 'label': t['label']})
            .toList(),
        selectedValue: currentTimeout,
      ),
    );

    if (selected != null) {
      await ref.read(settingsProvider.notifier).setAutoLockTimeout(selected);
    }
  }

  Widget _buildPickerSheet({
    required String title,
    required List<Map<String, dynamic>> items,
    required int selectedValue,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.close, color: AppColors.textMuted),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: AppColors.divider),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = item['value'] == selectedValue;
              return ListTile(
                title: Text(
                  item['label'],
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primaryAccent
                        : AppColors.textPrimary,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check, color: AppColors.primaryAccent)
                    : null,
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.pop(context, item['value']);
                },
              );
            },
          ),
        ),
        SizedBox(height: AppSpacing.md),
      ],
    );
  }

  Future<void> _showClearCacheDialog() async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Clear Cache',
      message:
          'This will clear cached data and force a re-sync on next app launch. Your data will not be deleted.',
      confirmText: 'Clear Cache',
      isDangerous: false,
    );

    if (confirmed == true) {
      await _clearCache();
    }
  }

  Future<void> _clearCache() async {
    setState(() => _isClearingCache = true);

    try {
      await showLoadingDialog(
        context: context,
        message: 'Clearing cache...',
        operation: () async {
          final db = ref.read(databaseProvider);
          await db.clearCache();
          await ref.read(syncNotifierProvider.notifier).triggerAutoSync();
        },
      );

      if (mounted) {
        showSuccessSnackBar(context, 'Cache cleared and sync triggered');
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, 'Failed to clear cache');
      }
    } finally {
      if (mounted) {
        setState(() => _isClearingCache = false);
      }
    }
  }

  Future<void> _showClearDataDialog() async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Clear All Data',
      message:
          'This will permanently delete ALL your transactions, budgets, wallets, categories, and settings. This action cannot be undone!',
      confirmText: 'Delete Everything',
      isDangerous: true,
    );

    if (confirmed == true && mounted) {
      // Show second confirmation requiring the user to type DELETE
      final doubleConfirmed = await showDestructiveConfirmationDialog(
        context: context,
        title: 'Are you absolutely sure?',
        message: 'All your financial data will be permanently erased.',
        confirmationWord: 'DELETE',
        confirmText: 'Yes, Delete All',
      );

      if (doubleConfirmed == true) {
        await _clearAllData();
      }
    }
  }

  Future<void> _clearAllData() async {
    setState(() => _isClearingData = true);

    try {
      await showLoadingDialog(
        context: context,
        message: 'Clearing all data...',
        operation: () async {
          final db = ref.read(databaseProvider);
          await db.clearAllData();

          // Clear default wallet from SharedPreferences
          await ref.read(defaultWalletProvider.notifier).clearDefaultWallet();

          // Refresh all in-memory providers
          await Future.wait([
            ref.read(walletProvider.notifier).loadWallets(silent: true),
            ref.read(categoryProvider.notifier).loadCategories(silent: true),
            ref
                .read(transactionProvider.notifier)
                .loadTransactions(silent: true),
            ref
                .read(paymentMethodProvider.notifier)
                .loadPaymentMethods(silent: true),
            ref.read(budgetProvider.notifier).loadBudgets(silent: true),
            ref
                .read(financialDataProvider.notifier)
                .loadFinancialData(silent: true),
          ]);

          // Reload settings from DB (picks up freshly inserted defaults)
          await ref.read(settingsProvider.notifier).loadSettings();
        },
      );

      if (mounted) {
        showSuccessSnackBar(context, 'All data cleared successfully');
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/dashboard', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, 'Failed to clear data: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isClearingData = false);
      }
    }
  }

  void _openPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LegalDocumentViewer(
          title: 'Privacy Policy',
          assetPath: 'assets/legal/privacy.md',
        ),
      ),
    );
  }

  void _openTermsOfService() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LegalDocumentViewer(
          title: 'Terms of Service',
          assetPath: 'assets/legal/terms.md',
        ),
      ),
    );
  }

  Future<void> _showDeleteAccountDialog() async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Delete Account',
      message:
          'You\'ll be taken to a form to request account deletion. '
          'The process takes a few days to complete. '
          'Once processed, all data on the server will be permanently deleted.',
      confirmText: 'Continue',
      isDangerous: true,
    );

    if (confirmed == true && mounted) {
      final uri = Uri.parse('https://forms.gle/gbU1FuqfXZgEYzq46');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }
}

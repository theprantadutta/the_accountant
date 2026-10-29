import 'package:flutter/material.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/core/providers/privacy_provider.dart';
import 'package:the_accountant/core/providers/sync_provider.dart';
import 'package:the_accountant/core/services/biometric_service.dart';
import 'package:the_accountant/core/services/backend_auth_service.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/dashboard/providers/financial_data_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/settings/widgets/confirmation_dialog.dart';
import 'package:the_accountant/features/settings/widgets/privacy_sheets.dart';
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
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final settingsState = ref.watch(settingsProvider);
    final privacy = ref.watch(privacyProvider);

    return SunrisePushPage(
      title: l10n.settingsPrivacySecurity,
      children: [
        // For when someone can see the screen.
        SettingsGroup(
          label: l10n.privacyAmounts,
          footer: l10n.privacyAmountsFooter,
          children: [
            SettingsRow.toggle(
              key: const Key('privacy_hide_amounts'),
              icon: Symbols.visibility_off_rounded,
              iconColor: c.accent,
              iconBackground: c.tintOrange,
              title: l10n.privacyHideTitle,
              subtitle: l10n.privacyHideSub,
              value: privacy.hideAmounts,
              onChanged: (v) => ref.read(privacyProvider.notifier).setHidden(v),
            ),
            SettingsRow(
              key: const Key('privacy_start'),
              icon: Symbols.lock_clock_rounded,
              iconColor: c.accent,
              iconBackground: c.tintOrange,
              title: l10n.privacyStartTitle,
              value: privacyStartLabel(privacy.start, l10n),
              onTap: () => choosePrivacyStart(context, ref),
            ),
            SettingsRow.toggle(
              key: const Key('privacy_tap_to_reveal'),
              icon: Symbols.touch_app_rounded,
              iconColor: c.accent,
              iconBackground: c.tintOrange,
              title: l10n.privacyTapTitle,
              subtitle: l10n.privacyTapSub,
              value: privacy.tapToReveal,
              onChanged: (v) =>
                  ref.read(privacyProvider.notifier).setTapToReveal(v),
            ),
          ],
        ),
        SettingsGroup(
          label: l10n.settingsSecurity,
          children: [
            SettingsRow.toggle(
              icon: Symbols.fingerprint_rounded,
              iconColor: c.accent,
              iconBackground: c.tintOrange,
              title: l10n.settingsBiometricLock,
              subtitle: l10n.settingsUseFingerprintOrFaceTo,
              value: settingsState.biometricLockEnabled,
              onChanged: (value) async {
                if (value) {
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
                  // Confirm identity before enabling.
                  final authenticated = await BiometricService().authenticate();
                  if (!authenticated) return;
                }
                await ref
                    .read(settingsProvider.notifier)
                    .setBiometricLock(value);
              },
            ),
            if (settingsState.biometricLockEnabled)
              SettingsRow(
                icon: Symbols.timer_rounded,
                iconColor: const Color(0xFFD97706),
                iconBackground: c.tintAmber,
                title: l10n.settingsAutoLock,
                value: _getAutoLockLabel(settingsState.autoLockTimeoutMinutes),
                onTap: _showAutoLockPicker,
              ),
            SettingsRow(
              icon: Symbols.password_rounded,
              iconColor: const Color(0xFF0284C7),
              iconBackground: c.tintSky,
              title: _hasPassword == false ? 'Set Password' : 'Change Password',
              subtitle: _hasPassword == false
                  ? 'Add password to your account'
                  : null,
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
                  _loadAuthProviders();
                }
              },
            ),
          ],
        ),
        const SizedBox(height: SunriseSpace.section),
        SettingsGroup(
          label: l10n.settingsDataPrivacy,
          children: [
            SettingsRow(
              icon: Symbols.cached_rounded,
              iconColor: const Color(0xFFD97706),
              iconBackground: c.tintAmber,
              title: l10n.settingsClearCache,
              subtitle: l10n.settingsClearCachedDataAndForce,
              enabled: !_isClearingCache,
              onTap: _showClearCacheDialog,
            ),
            SettingsRow(
              icon: Symbols.shield_lock_rounded,
              iconColor: c.positive,
              iconBackground: c.tintGreen,
              title: l10n.settingsPrivacyPolicy,
              trailing: SettingsTrailing.external,
              onTap: _openPrivacyPolicy,
            ),
            SettingsRow(
              icon: Symbols.description_rounded,
              iconColor: const Color(0xFF7C3AED),
              iconBackground: c.tintViolet,
              title: l10n.settingsTermsOfService,
              trailing: SettingsTrailing.external,
              onTap: _openTermsOfService,
            ),
            SettingsRow(
              icon: Symbols.receipt_long_rounded,
              iconColor: const Color(0xFF0284C7),
              iconBackground: c.tintSky,
              title: l10n.settingsRefundPolicy,
              trailing: SettingsTrailing.external,
              onTap: _openRefundPolicy,
            ),
          ],
        ),
        const SizedBox(height: SunriseSpace.section),
        SettingsGroup(
          label: l10n.settingsDangerZone,
          danger: true,
          children: [
            SettingsRow(
              icon: Symbols.delete_sweep_rounded,
              title: l10n.settingsClearAllData,
              subtitle: l10n.settingsDeleteAllTransactionsBudgetsAnd,
              destructive: true,
              enabled: !_isClearingData,
              onTap: _showClearDataDialog,
            ),
            SettingsRow(
              icon: Symbols.person_remove_rounded,
              title: l10n.settingsDeleteAccount,
              subtitle: l10n.settingsPermanentlyDeleteYourAccountAnd,
              destructive: true,
              onTap: _showDeleteAccountDialog,
            ),
          ],
        ),
      ],
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

    final selected = await showSunriseSheet<int>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: L10n.of(context).settingsAutoLockTimeout,
        child: Column(
          children: [
            for (final t in timeouts)
              SheetAction(
                icon: Symbols.timer_rounded,
                label: t['label'] as String,
                selected: t['value'] == currentTimeout,
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.pop(sheet, t['value'] as int);
                },
              ),
          ],
        ),
      ),
    );

    if (selected != null) {
      await ref.read(settingsProvider.notifier).setAutoLockTimeout(selected);
    }
  }

  Future<void> _showClearCacheDialog() async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: L10n.of(context).settingsClearCache,
      message:
          'This will clear cached data and force a re-sync on next app launch. Your data will not be deleted.',
      confirmText: L10n.of(context).settingsClearCache,
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
      title: L10n.of(context).settingsClearAllData,
      message:
          'This will permanently delete ALL your transactions, budgets, wallets, categories, and settings. This action cannot be undone!',
      confirmText: L10n.of(context).settingsDeleteEverything,
      isDangerous: true,
    );

    if (confirmed == true && mounted) {
      // Show second confirmation requiring the user to type DELETE
      final doubleConfirmed = await showDestructiveConfirmationDialog(
        context: context,
        title: L10n.of(context).settingsAreYouAbsolutelySure,
        message: 'All your financial data will be permanently erased.',
        confirmationWord: 'DELETE',
        confirmText: L10n.of(context).settingsYesDeleteAll,
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
        // Back to the dashboard under the auth gate, not a fresh copy of it
        // with the gate removed (which left sign-out with nowhere to go).
        Navigator.of(context).popUntil((route) => route.isFirst);
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
        builder: (context) => LegalDocumentViewer(
          title: L10n.of(context).settingsPrivacyPolicy,
          assetPath: 'assets/legal/privacy.md',
        ),
      ),
    );
  }

  void _openTermsOfService() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LegalDocumentViewer(
          title: L10n.of(context).settingsTermsOfService,
          assetPath: 'assets/legal/terms.md',
        ),
      ),
    );
  }

  void _openRefundPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LegalDocumentViewer(
          title: L10n.of(context).settingsRefundPolicy,
          assetPath: 'assets/legal/refund.md',
        ),
      ),
    );
  }

  Future<void> _showDeleteAccountDialog() async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: L10n.of(context).settingsDeleteAccount,
      message:
          'You\'ll be taken to a form to request account deletion. '
          'The process takes a few days to complete. '
          'Once processed, all data on the server will be permanently deleted.',
      confirmText: L10n.of(context).settingsContinue,
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

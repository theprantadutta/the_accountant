import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/settings/widgets/settings_tile.dart';
import 'package:the_accountant/features/settings/widgets/confirmation_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacySecurityScreen extends ConsumerStatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  ConsumerState<PrivacySecurityScreen> createState() =>
      _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends ConsumerState<PrivacySecurityScreen> {
  bool _isClearingCache = false;
  bool _isClearingData = false;

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
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
                title: 'Change Password',
                subtitle: 'Update your account password',
                onTap: () {
                  showInfoSnackBar(context, 'Password change coming soon');
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
      final db = ref.read(databaseProvider);
      await db.clearCache();

      if (mounted) {
        showSuccessSnackBar(context, 'Cache cleared successfully');
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

    if (confirmed == true) {
      // Show second confirmation for extra safety
      final doubleConfirmed = await showConfirmationDialog(
        context: context,
        title: 'Are you absolutely sure?',
        message:
            'Type "DELETE" to confirm. All your financial data will be permanently erased.',
        confirmText: 'Yes, Delete All',
        isDangerous: true,
      );

      if (doubleConfirmed == true) {
        await _clearAllData();
      }
    }
  }

  Future<void> _clearAllData() async {
    setState(() => _isClearingData = true);

    try {
      final db = ref.read(databaseProvider);
      await db.clearAllData();

      if (mounted) {
        showSuccessSnackBar(context, 'All data cleared successfully');
        // Navigate back to settings
        Navigator.pop(context);
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

  Future<void> _openPrivacyPolicy() async {
    final uri = Uri.parse('https://theaccountant.app/privacy');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        showErrorSnackBar(context, 'Could not open privacy policy');
      }
    }
  }

  Future<void> _openTermsOfService() async {
    final uri = Uri.parse('https://theaccountant.app/terms');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        showErrorSnackBar(context, 'Could not open terms of service');
      }
    }
  }

  Future<void> _showDeleteAccountDialog() async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Delete Account',
      message:
          'This will permanently delete your account and all associated data from our servers. This action cannot be undone.',
      confirmText: 'Delete Account',
      isDangerous: true,
    );

    if (confirmed == true && mounted) {
      showInfoSnackBar(
        context,
        'Account deletion coming soon. Please contact support for now.',
      );
    }
  }
}

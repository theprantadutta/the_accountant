import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/providers/daily_reminder_provider.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/settings/screens/backup_screen.dart';
import 'package:the_accountant/features/settings/screens/theme_selection_screen.dart';
import 'package:the_accountant/features/settings/screens/about_screen.dart';
import 'package:the_accountant/features/settings/screens/help_screen.dart';
import 'package:the_accountant/features/settings/screens/export_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart' show SharePlus, ShareParams;

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final dailyReminderState = ref.watch(dailyReminderProvider);
    final premiumState = ref.watch(premiumProvider);
    final settingsState = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          // ACCOUNT SECTION
          _buildSectionHeader('ACCOUNT'),
          _buildSettingsCard([
            _buildNavigationTile(
              icon: Icons.workspace_premium,
              iconColor: premiumState.isPremium ? Colors.amber : AppColors.textMuted,
              title: 'Subscription',
              subtitle: premiumState.isPremium
                  ? premiumState.tier.displayName
                  : 'Upgrade to Premium',
              onTap: () => Navigator.pushNamed(context, '/premium'),
              trailing: premiumState.isPremium
                  ? const Icon(Icons.verified, color: Colors.amber, size: 20)
                  : null,
            ),
            _buildDivider(),
            _buildActionTile(
              icon: Icons.logout,
              iconColor: AppColors.error,
              title: 'Sign Out',
              onTap: _showSignOutDialog,
            ),
          ]),

          // APPEARANCE SECTION
          _buildSectionHeader('APPEARANCE'),
          _buildSettingsCard([
            _buildNavigationTile(
              icon: Icons.palette_outlined,
              title: 'Theme',
              subtitle: _getThemeDisplayName(settingsState.themeMode),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ThemeSelectionScreen()),
              ),
            ),
          ]),

          // REGIONAL SECTION
          _buildSectionHeader('REGIONAL'),
          _buildSettingsCard([
            _buildNavigationTile(
              icon: Icons.attach_money,
              title: 'Currency',
              subtitle: settingsState.currency,
              onTap: () => _showCurrencyPicker(),
            ),
            _buildDivider(),
            _buildNavigationTile(
              icon: Icons.calendar_today_outlined,
              title: 'Date Format',
              subtitle: _getDateFormatLabel(settingsState.dateFormat),
              onTap: () => _showDateFormatPicker(),
            ),
            _buildDivider(),
            _buildNavigationTile(
              icon: Icons.numbers,
              title: 'Number Format',
              subtitle: _getNumberFormatLabel(settingsState.numberFormat),
              onTap: () => _showNumberFormatPicker(),
            ),
            _buildDivider(),
            _buildNavigationTile(
              icon: Icons.currency_exchange,
              title: 'Exchange Rates',
              subtitle: 'Manage currency conversion rates',
              onTap: () => Navigator.pushNamed(context, '/exchange-rates'),
            ),
          ]),

          // NOTIFICATIONS SECTION
          _buildSectionHeader('NOTIFICATIONS'),
          _buildSettingsCard([
            _buildSwitchTile(
              icon: Icons.notifications_outlined,
              title: 'Daily Reminders',
              subtitle: 'Get reminded to track expenses',
              value: dailyReminderState.isEnabled,
              onChanged: (value) async {
                HapticFeedback.lightImpact();
                if (value) {
                  await ref.read(dailyReminderProvider.notifier).enableReminders();
                } else {
                  await ref.read(dailyReminderProvider.notifier).disableReminders();
                }
              },
            ),
            if (dailyReminderState.isEnabled) ...[
              _buildDivider(),
              _buildNavigationTile(
                icon: Icons.access_time,
                title: 'Reminder Time',
                subtitle: _formatTimeOfDay(dailyReminderState.reminderTime),
                onTap: () => _showReminderTimePicker(),
              ),
            ],
            _buildDivider(),
            _buildSwitchTile(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Budget Alerts',
              subtitle: 'Notify when approaching budget limit',
              value: settingsState.budgetNotificationsEnabled,
              onChanged: (value) async {
                HapticFeedback.lightImpact();
                await ref.read(settingsProvider.notifier).toggleBudgetNotifications(value);
              },
            ),
            if (settingsState.budgetNotificationsEnabled) ...[
              _buildDivider(),
              _buildSliderTile(
                icon: Icons.warning_amber_outlined,
                title: 'Warning Threshold',
                subtitle: '${settingsState.budgetWarningThreshold.toInt()}% of budget',
                value: settingsState.budgetWarningThreshold,
                min: 50,
                max: 95,
                divisions: 9,
                onChanged: (value) async {
                  await ref.read(settingsProvider.notifier).setBudgetWarningThreshold(value);
                },
              ),
            ],
          ]),

          // SECURITY SECTION
          _buildSectionHeader('SECURITY'),
          _buildSettingsCard([
            _buildSwitchTile(
              icon: Icons.fingerprint,
              title: 'Biometric Lock',
              subtitle: 'Use fingerprint or face to unlock',
              value: settingsState.biometricLockEnabled,
              onChanged: (value) async {
                HapticFeedback.lightImpact();
                await ref.read(settingsProvider.notifier).setBiometricLock(value);
              },
            ),
            if (settingsState.biometricLockEnabled) ...[
              _buildDivider(),
              _buildNavigationTile(
                icon: Icons.timer_outlined,
                title: 'Auto-lock',
                subtitle: _getAutoLockLabel(settingsState.autoLockTimeoutMinutes),
                onTap: () => _showAutoLockPicker(),
              ),
            ],
          ]),

          // DATA MANAGEMENT SECTION
          _buildSectionHeader('DATA MANAGEMENT'),
          _buildSettingsCard([
            _buildNavigationTile(
              icon: Icons.cloud_outlined,
              title: 'Backup & Restore',
              subtitle: 'Sync to Google Drive',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BackupScreenGated()),
              ),
              trailing: premiumState.isPremium
                  ? null
                  : _buildPremiumBadge(),
            ),
            _buildDivider(),
            _buildNavigationTile(
              icon: Icons.download_outlined,
              title: 'Export Data',
              subtitle: 'Export to CSV or PDF',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExportScreen()),
              ),
            ),
            _buildDivider(),
            _buildActionTile(
              icon: Icons.delete_outline,
              iconColor: AppColors.error,
              title: 'Clear All Data',
              onTap: _showClearDataDialog,
            ),
          ]),

          // HELP & SUPPORT SECTION
          _buildSectionHeader('HELP & SUPPORT'),
          _buildSettingsCard([
            _buildNavigationTile(
              icon: Icons.help_outline,
              title: 'Help & FAQ',
              subtitle: 'Get answers to common questions',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpScreen()),
              ),
            ),
            _buildDivider(),
            _buildActionTile(
              icon: Icons.email_outlined,
              title: 'Contact Support',
              onTap: () => _launchEmail(),
            ),
            _buildDivider(),
            _buildActionTile(
              icon: Icons.star_outline,
              title: 'Rate the App',
              onTap: () => _rateApp(),
            ),
            _buildDivider(),
            _buildActionTile(
              icon: Icons.share_outlined,
              title: 'Share with Friends',
              onTap: () => _shareApp(),
            ),
          ]),

          // ABOUT SECTION
          _buildSectionHeader('ABOUT'),
          _buildSettingsCard([
            _buildNavigationTile(
              icon: Icons.info_outline,
              title: 'About The Accountant',
              subtitle: 'Version, licenses, and more',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              ),
            ),
          ]),

          SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.sm,
        top: AppSpacing.lg,
        bottom: AppSpacing.sm,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textMuted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.divider,
      indent: 56,
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    Color? iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primaryAccent).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.primaryAccent,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
              ),
            )
          : null,
      trailing: trailing ?? Icon(
        Icons.chevron_right,
        color: AppColors.textMuted,
      ),
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    Color? iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primaryAccent).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.primaryAccent,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: iconColor ?? AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    Color? iconColor,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primaryAccent).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.primaryAccent,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
              ),
            )
          : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.primaryAccent.withValues(alpha: 0.5),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryAccent;
          }
          return AppColors.textMuted;
        }),
      ),
    );
  }

  Widget _buildSliderTile({
    required IconData icon,
    Color? iconColor,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    int? divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (iconColor ?? AppColors.primaryAccent).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppColors.primaryAccent,
              size: 22,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 56,
            right: AppSpacing.md,
            bottom: AppSpacing.sm,
          ),
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.primaryAccent,
              inactiveTrackColor: AppColors.glassWhite,
              thumbColor: AppColors.primaryAccent,
              overlayColor: AppColors.primaryAccent.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'PRO',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // Helper methods
  String _getThemeDisplayName(String themeMode) {
    switch (themeMode) {
      case 'dark':
        return 'Dark (Default)';
      case 'light':
        return 'Light';
      default:
        return themeMode.replaceAll('_', ' ').split(' ').map((word) {
          return word[0].toUpperCase() + word.substring(1);
        }).join(' ');
    }
  }

  String _getDateFormatLabel(String format) {
    final formats = ref.read(dateFormatsProvider);
    final match = formats.firstWhere(
      (f) => f['value'] == format,
      orElse: () => {'label': format},
    );
    return match['label']!.split(' ').first;
  }

  String _getNumberFormatLabel(String format) {
    final formats = ref.read(numberFormatsProvider);
    final match = formats.firstWhere(
      (f) => f['value'] == format,
      orElse: () => {'label': format},
    );
    return match['label']!.split(' ').first;
  }

  String _getAutoLockLabel(int minutes) {
    final timeouts = ref.read(autoLockTimeoutsProvider);
    final match = timeouts.firstWhere(
      (t) => t['value'] == minutes,
      orElse: () => {'label': '$minutes minutes'},
    );
    return match['label'];
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  // Dialog methods
  Future<void> _showCurrencyPicker() async {
    final currencies = ref.read(currenciesProvider);
    final currentCurrency = ref.read(settingsProvider).currency;

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.primarySurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildPickerSheet(
        title: 'Select Currency',
        items: currencies.map((c) => {'value': c, 'label': c}).toList(),
        selectedValue: currentCurrency,
      ),
    );

    if (selected != null) {
      await ref.read(settingsProvider.notifier).setCurrency(selected);
    }
  }

  Future<void> _showDateFormatPicker() async {
    final formats = ref.read(dateFormatsProvider);
    final currentFormat = ref.read(settingsProvider).dateFormat;

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.primarySurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildPickerSheet(
        title: 'Select Date Format',
        items: formats,
        selectedValue: currentFormat,
      ),
    );

    if (selected != null) {
      await ref.read(settingsProvider.notifier).setDateFormat(selected);
    }
  }

  Future<void> _showNumberFormatPicker() async {
    final formats = ref.read(numberFormatsProvider);
    final currentFormat = ref.read(settingsProvider).numberFormat;

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.primarySurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildPickerSheet(
        title: 'Select Number Format',
        items: formats,
        selectedValue: currentFormat,
      ),
    );

    if (selected != null) {
      await ref.read(settingsProvider.notifier).setNumberFormat(selected);
    }
  }

  Future<void> _showAutoLockPicker() async {
    final timeouts = ref.read(autoLockTimeoutsProvider);
    final currentTimeout = ref.read(settingsProvider).autoLockTimeoutMinutes;

    final selected = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.primarySurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildPickerSheet<int>(
        title: 'Auto-lock Timeout',
        items: timeouts.map((t) => {'value': t['value'], 'label': t['label']}).toList(),
        selectedValue: currentTimeout,
      ),
    );

    if (selected != null) {
      await ref.read(settingsProvider.notifier).setAutoLockTimeout(selected);
    }
  }

  Future<void> _showReminderTimePicker() async {
    final dailyReminderState = ref.read(dailyReminderProvider);
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: dailyReminderState.reminderTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primaryAccent,
              surface: AppColors.primarySurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      await ref.read(dailyReminderProvider.notifier).setReminderTime(selectedTime);
    }
  }

  Widget _buildPickerSheet<T>({
    required String title,
    required List<Map<String, dynamic>> items,
    required T selectedValue,
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
              Spacer(),
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
                    color: isSelected ? AppColors.primaryAccent : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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

  Future<void> _showSignOutDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primarySurface,
        title: Text('Sign Out', style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Implement sign out
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign out functionality coming soon')),
        );
      }
    }
  }

  Future<void> _showClearDataDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primarySurface,
        title: Text(
          'Clear All Data',
          style: TextStyle(color: AppColors.error),
        ),
        content: Text(
          'This will permanently delete all your transactions, budgets, wallets, and settings. This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text('Delete Everything'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Implement clear all data
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data clearing functionality coming soon'),
            backgroundColor: AppColors.warning,
          ),
        );
      }
    }
  }

  Future<void> _launchEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@theaccountant.app',
      queryParameters: {
        'subject': 'The Accountant App - Support Request',
      },
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _rateApp() async {
    // TODO: Replace with actual Play Store / App Store URL
    final uri = Uri.parse('https://play.google.com/store/apps/details?id=com.theaccountant.app');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareApp() async {
    await SharePlus.instance.share(
      ShareParams(
        text: 'Check out The Accountant - a beautiful personal finance app!\n\nhttps://play.google.com/store/apps/details?id=com.theaccountant.app',
        subject: 'The Accountant - Personal Finance App',
      ),
    );
  }
}

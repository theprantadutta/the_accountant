import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/features/authentication/providers/auth_provider.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/settings/screens/backup_screen.dart';
import 'package:the_accountant/features/settings/screens/theme_selection_screen.dart';
import 'package:the_accountant/features/settings/screens/about_screen.dart';
import 'package:the_accountant/features/settings/screens/help_screen.dart';
import 'package:the_accountant/features/settings/screens/export_screen.dart';
import 'package:the_accountant/features/settings/screens/profile_edit_screen.dart';
import 'package:the_accountant/features/settings/screens/privacy_security_screen.dart';
import 'package:the_accountant/features/settings/screens/notifications_screen.dart';
import 'package:the_accountant/features/settings/screens/regional_settings_screen.dart';
import 'package:the_accountant/features/settings/widgets/settings_tile.dart';
import 'package:the_accountant/features/settings/widgets/confirmation_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart' show SharePlus, ShareParams;

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
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
          // PROFILE CARD
          _buildProfileCard(context, authState),
          SizedBox(height: AppSpacing.sm),

          // ACCOUNT SECTION
          SettingsSection(
            title: 'ACCOUNT',
            tiles: [
              SettingsNavigationTile(
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
              SettingsActionTile(
                icon: Icons.logout,
                iconColor: AppColors.error,
                title: 'Sign Out',
                onTap: () => _showSignOutDialog(context, ref),
              ),
            ],
          ),

          // APPEARANCE SECTION
          SettingsSection(
            title: 'APPEARANCE',
            tiles: [
              SettingsNavigationTile(
                icon: Icons.palette_outlined,
                title: 'Theme',
                subtitle: _getThemeDisplayName(settingsState.themeMode),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ThemeSelectionScreen()),
                ),
              ),
            ],
          ),

          // REGIONAL SECTION
          SettingsSection(
            title: 'REGIONAL',
            tiles: [
              SettingsNavigationTile(
                icon: Icons.language,
                title: 'Regional Settings',
                subtitle: '${settingsState.currency} - ${_getDateFormatLabel(settingsState.dateFormat, ref)}',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegionalSettingsScreen()),
                ),
              ),
            ],
          ),

          // NOTIFICATIONS SECTION
          SettingsSection(
            title: 'NOTIFICATIONS',
            tiles: [
              SettingsNavigationTile(
                icon: Icons.notifications_outlined,
                title: 'Notification Settings',
                subtitle: 'Daily reminders, budget alerts',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                ),
              ),
            ],
          ),

          // PRIVACY & SECURITY SECTION
          SettingsSection(
            title: 'PRIVACY & SECURITY',
            tiles: [
              SettingsNavigationTile(
                icon: Icons.security,
                title: 'Privacy & Security',
                subtitle: 'Biometric lock, data management',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrivacySecurityScreen()),
                ),
              ),
            ],
          ),

          // DATA MANAGEMENT SECTION
          SettingsSection(
            title: 'DATA MANAGEMENT',
            tiles: [
              SettingsNavigationTile(
                icon: Icons.cloud_outlined,
                title: 'Backup & Restore',
                subtitle: 'Sync to Google Drive',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BackupScreenGated()),
                ),
                trailing: premiumState.isPremium ? null : const PremiumBadge(),
              ),
              SettingsNavigationTile(
                icon: Icons.download_outlined,
                title: 'Export Data',
                subtitle: 'Export to CSV or PDF',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExportScreen()),
                ),
              ),
            ],
          ),

          // HELP & SUPPORT SECTION
          SettingsSection(
            title: 'HELP & SUPPORT',
            tiles: [
              SettingsNavigationTile(
                icon: Icons.help_outline,
                title: 'Help & FAQ',
                subtitle: 'Get answers to common questions',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HelpScreen()),
                ),
              ),
              SettingsActionTile(
                icon: Icons.email_outlined,
                title: 'Contact Support',
                onTap: () => _launchEmail(),
              ),
              SettingsActionTile(
                icon: Icons.star_outline,
                title: 'Rate the App',
                onTap: () => _rateApp(),
              ),
              SettingsActionTile(
                icon: Icons.share_outlined,
                title: 'Share with Friends',
                onTap: () => _shareApp(),
              ),
            ],
          ),

          // ABOUT SECTION
          SettingsSection(
            title: 'ABOUT',
            tiles: [
              SettingsNavigationTile(
                icon: Icons.info_outline,
                title: 'About The Accountant',
                subtitle: 'Version, licenses, and more',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, AuthState authState) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileEditScreen()),
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: AppSpacing.md),
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: AppSpacing.borderRadiusXl,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGlow.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: authState.photoUrl != null && authState.photoUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        authState.photoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 28,
                    ),
            ),
            SizedBox(width: AppSpacing.md),

            // Name and Email
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authState.displayName ?? 'User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    authState.userEmail ?? '',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Edit indicator
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  String _getDateFormatLabel(String format, WidgetRef ref) {
    final formats = ref.read(dateFormatsProvider);
    final match = formats.firstWhere(
      (f) => f['value'] == format,
      orElse: () => {'label': format},
    );
    return match['label']!.split(' ').first;
  }

  Future<void> _showSignOutDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Sign Out',
      message: 'Are you sure you want to sign out of your account?',
      confirmText: 'Sign Out',
      isDangerous: true,
    );

    if (confirmed == true) {
      try {
        await ref.read(authProvider.notifier).signOut();
        // Navigation to login is handled by auth state listener
      } catch (e) {
        if (context.mounted) {
          showErrorSnackBar(context, 'Failed to sign out: ${e.toString()}');
        }
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

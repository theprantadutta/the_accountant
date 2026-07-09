import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/features/authentication/providers/auth_provider.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/settings/screens/sync_settings_screen.dart';
import 'package:the_accountant/features/settings/screens/about_screen.dart';
import 'package:the_accountant/features/settings/screens/contact_support_screen.dart';
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
import 'package:the_accountant/core/providers/walkthrough_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Check if text matches search query (case-insensitive)
  bool _matchesSearch(String text) {
    if (_searchQuery.isEmpty) return true;
    return text.toLowerCase().contains(_searchQuery.toLowerCase());
  }

  /// Check if any keywords match search query
  bool _matchesKeywords(List<String> keywords) {
    if (_searchQuery.isEmpty) return true;
    return keywords.any(
      (k) => k.toLowerCase().contains(_searchQuery.toLowerCase()),
    );
  }

  /// Notice shown to free users: their data lives only on this device (cloud sync
  /// is a premium feature), so a reinstall or new phone can lose it. Taps through
  /// to the premium screen.
  Widget _buildDeviceOnlyDataNotice(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pushNamed(context, '/premium');
      },
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                color: AppColors.warning,
                size: 22,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your data is on this device only',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Free accounts aren't backed up to the cloud, so reinstalling "
                    "or switching phones can lose your data. Upgrade for automatic "
                    "cloud sync — or export a backup regularly.",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Upgrade for cloud backup',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.warning,
                        size: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final premiumState = ref.watch(premiumProvider);
    final settingsState = ref.watch(settingsProvider);

    // Build all settings sections with search filtering
    final sections = _buildFilteredSections(
      context,
      ref,
      authState,
      premiumState,
      settingsState,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search settings...',
                  hintStyle: TextStyle(color: AppColors.textMuted),
                  prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: AppColors.textMuted),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.primarySurface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primaryAccent),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                style: TextStyle(color: AppColors.textPrimary),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            // Settings list
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                children: [
                  // Show profile card only when not searching
                  if (_searchQuery.isEmpty) ...[
                    _buildProfileCard(context, authState),
                    SizedBox(height: AppSpacing.sm),
                    // Warn free users their data is device-only (no cloud backup).
                    if (!premiumState.isPremium) ...[
                      _buildDeviceOnlyDataNotice(context),
                      SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                  // Show filtered sections
                  ...sections,
                  // No results message
                  if (sections.isEmpty && _searchQuery.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: AppColors.textMuted,
                            ),
                            SizedBox(height: AppSpacing.md),
                            Text(
                              'No settings found',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Try a different search term',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Bottom padding
                  SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFilteredSections(
    BuildContext context,
    WidgetRef ref,
    AuthState authState,
    PremiumState premiumState,
    SettingsState settingsState,
  ) {
    final sections = <Widget>[];

    // ACCOUNT SECTION
    final accountTiles = <Widget>[];
    if (_matchesSearch('Subscription') ||
        _matchesKeywords(['premium', 'upgrade', 'plan'])) {
      accountTiles.add(
        SettingsNavigationTile(
          icon: Icons.workspace_premium,
          iconColor: premiumState.isPremium
              ? Colors.amber
              : AppColors.textMuted,
          title: 'Subscription',
          subtitle: premiumState.isPremium
              ? premiumState.tier.displayName
              : 'Upgrade to Premium',
          onTap: () => Navigator.pushNamed(context, '/premium'),
          trailing: premiumState.isPremium
              ? const Icon(Icons.verified, color: Colors.amber, size: 20)
              : null,
        ),
      );
    }
    if (_matchesSearch('Sign Out') || _matchesKeywords(['logout', 'exit'])) {
      accountTiles.add(
        SettingsActionTile(
          icon: Icons.logout,
          iconColor: AppColors.error,
          title: 'Sign Out',
          onTap: () => _showSignOutDialog(context, ref),
        ),
      );
    }
    if (accountTiles.isNotEmpty) {
      sections.add(SettingsSection(title: 'ACCOUNT', tiles: accountTiles));
    }

    // REGIONAL SECTION
    final regionalTiles = <Widget>[];
    if (_matchesSearch('Regional') ||
        _matchesKeywords(['currency', 'date', 'format', 'language'])) {
      regionalTiles.add(
        SettingsNavigationTile(
          icon: Icons.language,
          title: 'Regional Settings',
          subtitle:
              '${settingsState.currency} - ${_getDateFormatLabel(settingsState.dateFormat, ref)}',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegionalSettingsScreen()),
          ),
        ),
      );
    }
    if (regionalTiles.isNotEmpty) {
      sections.add(SettingsSection(title: 'REGIONAL', tiles: regionalTiles));
    }

    // NOTIFICATIONS SECTION
    final notificationTiles = <Widget>[];
    if (_matchesSearch('Notification') ||
        _matchesKeywords(['reminder', 'alert', 'budget alert', 'daily'])) {
      notificationTiles.add(
        SettingsNavigationTile(
          icon: Icons.notifications_outlined,
          title: 'Notification Settings',
          subtitle: 'Daily reminders, budget alerts',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          ),
        ),
      );
    }
    if (notificationTiles.isNotEmpty) {
      sections.add(
        SettingsSection(title: 'NOTIFICATIONS', tiles: notificationTiles),
      );
    }

    // PRIVACY & SECURITY SECTION
    final privacyTiles = <Widget>[];
    if (_matchesSearch('Privacy') ||
        _matchesSearch('Security') ||
        _matchesKeywords(['biometric', 'lock', 'fingerprint', 'password'])) {
      privacyTiles.add(
        SettingsNavigationTile(
          icon: Icons.security,
          title: 'Privacy & Security',
          subtitle: 'Biometric lock, data management',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PrivacySecurityScreen()),
          ),
        ),
      );
    }
    if (privacyTiles.isNotEmpty) {
      sections.add(
        SettingsSection(title: 'PRIVACY & SECURITY', tiles: privacyTiles),
      );
    }

    // DATA MANAGEMENT SECTION
    final dataTiles = <Widget>[];
    if (_matchesSearch('Cloud Sync') ||
        _matchesKeywords(['sync', 'cloud', 'backup'])) {
      dataTiles.add(
        SettingsNavigationTile(
          icon: Icons.sync,
          title: 'Cloud Sync',
          subtitle: 'Sync your data across devices',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SyncSettingsScreenGated()),
          ),
          trailing: premiumState.isPremium ? null : const PremiumBadge(),
        ),
      );
    }
    if (_matchesSearch('Export') ||
        _matchesKeywords(['csv', 'pdf', 'download', 'data'])) {
      dataTiles.add(
        SettingsNavigationTile(
          icon: Icons.download_outlined,
          title: 'Export Data',
          subtitle: 'Export to CSV or PDF',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ExportScreenGated()),
          ),
          trailing: premiumState.isPremium ? null : const PremiumBadge(),
        ),
      );
    }
    if (dataTiles.isNotEmpty) {
      sections.add(SettingsSection(title: 'DATA MANAGEMENT', tiles: dataTiles));
    }

    // HELP & SUPPORT SECTION
    final helpTiles = <Widget>[];
    if (_matchesSearch('Help') ||
        _matchesSearch('FAQ') ||
        _matchesKeywords(['question', 'guide'])) {
      helpTiles.add(
        SettingsNavigationTile(
          icon: Icons.help_outline,
          title: 'Help & FAQ',
          subtitle: 'Get answers to common questions',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HelpScreen()),
          ),
        ),
      );
    }
    if (_matchesSearch('Contact') ||
        _matchesSearch('Support') ||
        _matchesKeywords(['email', 'feedback'])) {
      helpTiles.add(
        SettingsNavigationTile(
          icon: Icons.email_outlined,
          title: 'Contact Support',
          subtitle: 'Questions, complaints, or feedback',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ContactSupportScreen()),
          ),
        ),
      );
    }
    if (_matchesSearch('Rate') || _matchesKeywords(['review', 'star'])) {
      helpTiles.add(
        SettingsActionTile(
          icon: Icons.star_outline,
          title: 'Rate the App',
          onTap: () => _rateApp(),
        ),
      );
    }
    if (_matchesSearch('Share') || _matchesKeywords(['friends', 'invite'])) {
      helpTiles.add(
        SettingsActionTile(
          icon: Icons.share_outlined,
          title: 'Share with Friends',
          onTap: () => _shareApp(),
        ),
      );
    }
    if (_matchesSearch('Replay App Tour') ||
        _matchesKeywords([
          'walkthrough',
          'tour',
          'tutorial',
          'guide',
          'replay',
        ])) {
      helpTiles.add(
        SettingsActionTile(
          icon: Icons.play_circle_outline,
          title: 'Replay App Tour',
          subtitle: 'See the feature walkthrough again',
          onTap: () {
            ref.read(walkthroughProvider.notifier).resetWalkthrough();
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/dashboard',
              (route) => false,
            );
          },
        ),
      );
    }
    if (helpTiles.isNotEmpty) {
      sections.add(SettingsSection(title: 'HELP & SUPPORT', tiles: helpTiles));
    }

    // ABOUT SECTION
    final aboutTiles = <Widget>[];
    if (_matchesSearch('About') ||
        _matchesKeywords(['version', 'license', 'info'])) {
      aboutTiles.add(
        SettingsNavigationTile(
          icon: Icons.info_outline,
          title: 'About The Accountant',
          subtitle: 'Version, licenses, and more',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AboutScreen()),
          ),
        ),
      );
    }
    if (aboutTiles.isNotEmpty) {
      sections.add(SettingsSection(title: 'ABOUT', tiles: aboutTiles));
    }

    // DEVELOPER SECTION (debug mode only)
    if (kDebugMode) {
      final devTiles = <Widget>[];
      if (_matchesSearch('Test Crash') ||
          _matchesKeywords(['crash', 'debug', 'crashlytics'])) {
        devTiles.add(
          SettingsActionTile(
            icon: Icons.bug_report,
            iconColor: Colors.orange,
            title: 'Test Crash',
            subtitle: 'Trigger a test exception for Crashlytics',
            onTap: () async {
              await FirebaseCrashlytics.instance
                  .setCrashlyticsCollectionEnabled(true);
              final exception = Exception('Test Crashlytics exception');
              await FirebaseCrashlytics.instance.recordError(
                exception,
                StackTrace.current,
                reason: 'Manual test crash from settings',
              );
              await FirebaseCrashlytics.instance
                  .setCrashlyticsCollectionEnabled(false);
            },
          ),
        );
      }
      if (devTiles.isNotEmpty) {
        sections.add(SettingsSection(title: 'DEVELOPER', tiles: devTiles));
      }
    }

    return sections;
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
              child:
                  authState.photoUrl != null && authState.photoUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        authState.photoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    )
                  : const Icon(Icons.person, color: Colors.white, size: 28),
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
              child: const Icon(Icons.edit, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
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

  Future<void> _rateApp() async {
    final uri = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.pranta.theaccountant',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareApp() async {
    await SharePlus.instance.share(
      ShareParams(
        text:
            'Check out The Accountant - a beautiful personal finance app!\n\nhttps://play.google.com/store/apps/details?id=com.pranta.theaccountant',
        subject: 'The Accountant - Personal Finance App',
      ),
    );
  }
}

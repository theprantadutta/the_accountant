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
    return keywords.any((k) => k.toLowerCase().contains(_searchQuery.toLowerCase()));
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
                  // Extra padding for floating bottom nav bar
                  SizedBox(height: AppSpacing.huge + 80),
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
    if (_matchesSearch('Subscription') || _matchesKeywords(['premium', 'upgrade', 'plan'])) {
      accountTiles.add(SettingsNavigationTile(
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
      ));
    }
    if (_matchesSearch('Sign Out') || _matchesKeywords(['logout', 'exit'])) {
      accountTiles.add(SettingsActionTile(
        icon: Icons.logout,
        iconColor: AppColors.error,
        title: 'Sign Out',
        onTap: () => _showSignOutDialog(context, ref),
      ));
    }
    if (accountTiles.isNotEmpty) {
      sections.add(SettingsSection(title: 'ACCOUNT', tiles: accountTiles));
    }

    // APPEARANCE SECTION
    final appearanceTiles = <Widget>[];
    if (_matchesSearch('Theme') || _matchesKeywords(['dark', 'light', 'appearance', 'color'])) {
      appearanceTiles.add(SettingsNavigationTile(
        icon: Icons.palette_outlined,
        title: 'Theme',
        subtitle: _getThemeDisplayName(settingsState.themeMode),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ThemeSelectionScreen()),
        ),
      ));
    }
    if (appearanceTiles.isNotEmpty) {
      sections.add(SettingsSection(title: 'APPEARANCE', tiles: appearanceTiles));
    }

    // REGIONAL SECTION
    final regionalTiles = <Widget>[];
    if (_matchesSearch('Regional') || _matchesKeywords(['currency', 'date', 'format', 'language'])) {
      regionalTiles.add(SettingsNavigationTile(
        icon: Icons.language,
        title: 'Regional Settings',
        subtitle: '${settingsState.currency} - ${_getDateFormatLabel(settingsState.dateFormat, ref)}',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RegionalSettingsScreen()),
        ),
      ));
    }
    if (regionalTiles.isNotEmpty) {
      sections.add(SettingsSection(title: 'REGIONAL', tiles: regionalTiles));
    }

    // NOTIFICATIONS SECTION
    final notificationTiles = <Widget>[];
    if (_matchesSearch('Notification') || _matchesKeywords(['reminder', 'alert', 'budget alert', 'daily'])) {
      notificationTiles.add(SettingsNavigationTile(
        icon: Icons.notifications_outlined,
        title: 'Notification Settings',
        subtitle: 'Daily reminders, budget alerts',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotificationsScreen()),
        ),
      ));
    }
    if (notificationTiles.isNotEmpty) {
      sections.add(SettingsSection(title: 'NOTIFICATIONS', tiles: notificationTiles));
    }

    // PRIVACY & SECURITY SECTION
    final privacyTiles = <Widget>[];
    if (_matchesSearch('Privacy') || _matchesSearch('Security') || _matchesKeywords(['biometric', 'lock', 'fingerprint', 'password'])) {
      privacyTiles.add(SettingsNavigationTile(
        icon: Icons.security,
        title: 'Privacy & Security',
        subtitle: 'Biometric lock, data management',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PrivacySecurityScreen()),
        ),
      ));
    }
    if (privacyTiles.isNotEmpty) {
      sections.add(SettingsSection(title: 'PRIVACY & SECURITY', tiles: privacyTiles));
    }

    // DATA MANAGEMENT SECTION
    final dataTiles = <Widget>[];
    if (_matchesSearch('Backup') || _matchesKeywords(['restore', 'google drive', 'sync', 'cloud'])) {
      dataTiles.add(SettingsNavigationTile(
        icon: Icons.cloud_outlined,
        title: 'Backup & Restore',
        subtitle: 'Sync to Google Drive',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BackupScreenGated()),
        ),
        trailing: premiumState.isPremium ? null : const PremiumBadge(),
      ));
    }
    if (_matchesSearch('Export') || _matchesKeywords(['csv', 'pdf', 'download', 'data'])) {
      dataTiles.add(SettingsNavigationTile(
        icon: Icons.download_outlined,
        title: 'Export Data',
        subtitle: 'Export to CSV or PDF',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ExportScreen()),
        ),
      ));
    }
    if (dataTiles.isNotEmpty) {
      sections.add(SettingsSection(title: 'DATA MANAGEMENT', tiles: dataTiles));
    }

    // HELP & SUPPORT SECTION
    final helpTiles = <Widget>[];
    if (_matchesSearch('Help') || _matchesSearch('FAQ') || _matchesKeywords(['question', 'guide'])) {
      helpTiles.add(SettingsNavigationTile(
        icon: Icons.help_outline,
        title: 'Help & FAQ',
        subtitle: 'Get answers to common questions',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HelpScreen()),
        ),
      ));
    }
    if (_matchesSearch('Contact') || _matchesSearch('Support') || _matchesKeywords(['email', 'feedback'])) {
      helpTiles.add(SettingsActionTile(
        icon: Icons.email_outlined,
        title: 'Contact Support',
        onTap: () => _launchEmail(),
      ));
    }
    if (_matchesSearch('Rate') || _matchesKeywords(['review', 'star'])) {
      helpTiles.add(SettingsActionTile(
        icon: Icons.star_outline,
        title: 'Rate the App',
        onTap: () => _rateApp(),
      ));
    }
    if (_matchesSearch('Share') || _matchesKeywords(['friends', 'invite'])) {
      helpTiles.add(SettingsActionTile(
        icon: Icons.share_outlined,
        title: 'Share with Friends',
        onTap: () => _shareApp(),
      ));
    }
    if (helpTiles.isNotEmpty) {
      sections.add(SettingsSection(title: 'HELP & SUPPORT', tiles: helpTiles));
    }

    // ABOUT SECTION
    final aboutTiles = <Widget>[];
    if (_matchesSearch('About') || _matchesKeywords(['version', 'license', 'info'])) {
      aboutTiles.add(SettingsNavigationTile(
        icon: Icons.info_outline,
        title: 'About The Accountant',
        subtitle: 'Version, licenses, and more',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AboutScreen()),
        ),
      ));
    }
    if (aboutTiles.isNotEmpty) {
      sections.add(SettingsSection(title: 'ABOUT', tiles: aboutTiles));
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

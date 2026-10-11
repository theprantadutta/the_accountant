import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart' show SharePlus, ShareParams;
import 'package:the_accountant/core/providers/theme_provider.dart';
import 'package:the_accountant/core/providers/walkthrough_provider.dart';
import 'package:the_accountant/features/ai_assistant/screens/ai_assistant_screen.dart'
    show AIAssistantScreenGated;
import 'package:the_accountant/features/authentication/providers/auth_provider.dart';
import 'package:the_accountant/features/backup/screens/backup_screen.dart';
import 'package:the_accountant/features/budgets/screens/budget_list_screen.dart';
import 'package:the_accountant/features/categories/screens/category_management_screen.dart';
import 'package:the_accountant/features/dashboard/screens/home_layout_screen.dart';
import 'package:the_accountant/features/import/screens/import_screen.dart';
import 'package:the_accountant/features/objectives/screens/objectives_list_screen.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/settings/screens/about_screen.dart';
import 'package:the_accountant/features/settings/screens/contact_support_screen.dart';
import 'package:the_accountant/features/settings/screens/export_screen.dart';
import 'package:the_accountant/features/settings/screens/help_screen.dart';
import 'package:the_accountant/features/settings/screens/notifications_screen.dart';
import 'package:the_accountant/features/settings/screens/privacy_security_screen.dart';
import 'package:the_accountant/features/settings/screens/profile_edit_screen.dart';
import 'package:the_accountant/features/settings/screens/regional_settings_screen.dart';
import 'package:the_accountant/features/settings/screens/sync_settings_screen.dart';
import 'package:the_accountant/features/settings/screens/theme_selection_screen.dart';
import 'package:the_accountant/features/settings/widgets/settings_tile.dart'
    show PremiumBadge;
import 'package:the_accountant/features/transactions/screens/payment_methods_screen.dart';
import 'package:the_accountant/features/transactions/screens/recently_deleted_screen.dart';
import 'package:the_accountant/features/transactions/screens/title_rules_screen.dart';
import 'package:the_accountant/features/transactions/screens/upcoming_transactions_screen.dart';
import 'package:the_accountant/features/wallets/screens/wallet_management_screen.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';
import 'package:url_launcher/url_launcher.dart';

/// One searchable settings entry.
class _Entry {
  const _Entry({
    required this.row,
    required this.title,
    this.keywords = const [],
  });

  final Widget row;

  /// Matched against the search, along with [keywords] (English synonyms).
  final String title;
  final List<String> keywords;
}

/// More: profile, Premium, then every setting in labelled groups, searchable.
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

  bool _matches(_Entry e) {
    if (_searchQuery.isEmpty) return true;
    final q = _searchQuery.toLowerCase();
    return e.title.toLowerCase().contains(q) ||
        e.keywords.any((k) => k.toLowerCase().contains(q));
  }

  void _push(Widget screen) {
    HapticFeedback.selectionClick();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final authState = ref.watch(authProvider);
    final premiumState = ref.watch(premiumProvider);
    final groups = _groups(context, premiumState);
    final searching = _searchQuery.isNotEmpty;

    final visible = <Widget>[];
    for (final (label, entries, danger) in groups) {
      final rows = entries.where(_matches).map((e) => e.row).toList();
      if (rows.isEmpty) continue;
      visible.add(
        Padding(
          padding: const EdgeInsets.only(top: SunriseSpace.section),
          child: SettingsGroup(label: label, danger: danger, children: rows),
        ),
      );
    }

    return SunriseTabPage(
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: SunriseSpace.tabBarClearance),
        children: [
          LargeTitleHeader(title: l10n.moreTitle),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SunriseSpace.screenX,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!searching) ...[
                  _ProfileCard(
                    auth: authState,
                    onTap: () => _push(const ProfileEditScreen()),
                  ),
                  const SizedBox(height: SunriseSpace.sectionTight),
                  if (premiumState.isPremium)
                    _PremiumActiveCard(
                      tier: premiumState.tier.displayName,
                      onTap: () => Navigator.pushNamed(context, '/premium'),
                    )
                  else ...[
                    _GoPremiumBanner(
                      onTap: () => Navigator.pushNamed(context, '/premium'),
                    ),
                    const SizedBox(height: SunriseSpace.sectionTight),
                    _DeviceOnlyNotice(
                      onTap: () => Navigator.pushNamed(context, '/premium'),
                    ),
                  ],
                  const SizedBox(height: SunriseSpace.sectionTight),
                ],
                SunriseSearchField(
                  hint: l10n.settingsSearchSettings,
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v.trim()),
                  onClear: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                ),
                ...visible,
                if (visible.isEmpty && searching)
                  EmptyState(
                    icon: Symbols.search_off_rounded,
                    title: l10n.settingsNoSettingsFound,
                    message: l10n.settingsTryADifferentSearchTerm,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Every group, in display order: (label, entries, danger).
  List<(String, List<_Entry>, bool)> _groups(
    BuildContext context,
    PremiumState premiumState,
  ) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final settings = ref.watch(settingsProvider);
    final theme = ref.watch(themeProvider);

    final preferences = [
      _Entry(
        title: l10n.settingsAppearance,
        keywords: const [
          'theme',
          'dark',
          'light',
          'colour',
          'color',
          'appearance',
        ],
        row: SettingsRow(
          icon: Symbols.palette_rounded,
          iconColor: c.accent,
          iconBackground: c.tintOrange,
          title: l10n.settingsAppearance,
          value: ThemeSelectionScreen.currentLabel(
            theme,
            MediaQuery.platformBrightnessOf(context),
            l10n,
          ),
          onTap: () => _push(const ThemeSelectionScreen()),
        ),
      ),
      _Entry(
        title: l10n.settingsRegionalTitle,
        keywords: const ['currency', 'date', 'format', 'language', 'region'],
        row: SettingsRow(
          icon: Symbols.language_rounded,
          iconColor: const Color(0xFF0284C7),
          iconBackground: c.tintSky,
          title: l10n.settingsRegionalTitle,
          value: settings.currency,
          onTap: () => _push(const RegionalSettingsScreen()),
        ),
      ),
      _Entry(
        title: l10n.settingsNotificationSettings,
        keywords: const [
          'reminder',
          'alert',
          'budget alert',
          'daily',
          'notification',
        ],
        row: SettingsRow(
          icon: Symbols.notifications_rounded,
          iconColor: const Color(0xFFD97706),
          iconBackground: c.tintAmber,
          title: l10n.settingsNotificationSettings,
          onTap: () => _push(const NotificationsScreen()),
        ),
      ),
      _Entry(
        title: l10n.settingsCategories,
        keywords: const ['category', 'categories', 'icon', 'colour', 'color'],
        row: SettingsRow(
          icon: Symbols.category_rounded,
          iconColor: const Color(0xFF7C3AED),
          iconBackground: c.tintViolet,
          title: l10n.settingsCategories,
          onTap: () => _push(const CategoryManagementScreen()),
        ),
      ),
      _Entry(
        title: l10n.layoutTitle,
        keywords: const [
          'home',
          'layout',
          'sections',
          'reorder',
          'arrange',
          'today',
        ],
        row: SettingsRow(
          icon: Symbols.dashboard_customize_rounded,
          iconColor: c.accent,
          iconBackground: c.tintPeach,
          title: l10n.layoutTitle,
          subtitle: l10n.layoutSubtitle,
          onTap: () => _push(const HomeLayoutScreen()),
        ),
      ),
    ];

    final money = [
      _Entry(
        title: l10n.moreAiAssistant,
        keywords: const ['ai', 'assistant', 'chat', 'coach', 'gemini', 'ask'],
        row: SettingsRow(
          icon: Symbols.auto_awesome_rounded,
          iconColor: c.accent,
          iconBackground: c.tintOrange,
          title: l10n.moreAiAssistant,
          subtitle: l10n.moreAiAssistantSub,
          badge: premiumState.isPremium ? null : const PremiumBadge(),
          onTap: () => _push(const AIAssistantScreenGated()),
        ),
      ),
      _Entry(
        title: l10n.settingsGoals,
        keywords: const ['goal', 'objective', 'saving', 'target'],
        row: SettingsRow(
          icon: Symbols.flag_rounded,
          iconColor: c.positive,
          iconBackground: c.tintGreen,
          title: l10n.settingsGoals,
          subtitle: l10n.settingsSaveTowardSomethingAndTrack,
          onTap: () => _push(const ObjectivesListScreen()),
        ),
      ),
      _Entry(
        title: l10n.settingsBudgets,
        keywords: const ['budget', 'limit', 'spending'],
        row: SettingsRow(
          icon: Symbols.donut_large_rounded,
          iconColor: const Color(0xFF0284C7),
          iconBackground: c.tintSky,
          title: l10n.settingsBudgets,
          subtitle: l10n.settingsSetLimitsAndSeeHow,
          onTap: () => _push(const BudgetListScreen()),
        ),
      ),
      _Entry(
        title: l10n.settingsUpcomingAndOverdue,
        keywords: const ['upcoming', 'overdue', 'scheduled', 'due'],
        row: SettingsRow(
          icon: Symbols.event_upcoming_rounded,
          iconColor: const Color(0xFFD97706),
          iconBackground: c.tintAmber,
          title: l10n.settingsUpcomingAndOverdue,
          subtitle: l10n.settingsWhatIsDueAndWhat,
          onTap: () => _push(const UpcomingTransactionsScreen()),
        ),
      ),
      _Entry(
        title: l10n.settingsAccounts,
        keywords: const ['wallet', 'account', 'balance'],
        row: SettingsRow(
          icon: Symbols.account_balance_wallet_rounded,
          iconColor: c.accent,
          iconBackground: c.tintPeach,
          title: l10n.settingsAccounts,
          subtitle: l10n.settingsAddReorderAndEditYour,
          onTap: () => _push(const WalletManagementScreen()),
        ),
      ),
      _Entry(
        title: l10n.payTitle,
        keywords: const ['payment', 'card', 'method'],
        row: SettingsRow(
          icon: Symbols.credit_card_rounded,
          iconColor: const Color(0xFF0284C7),
          iconBackground: c.tintSky,
          title: l10n.payTitle,
          subtitle: l10n.settingsTheCardsAndAccountsYou,
          onTap: () => _push(const PaymentMethodsScreen()),
        ),
      ),
      _Entry(
        title: l10n.rulesTitle,
        keywords: const [
          'rule',
          'title',
          'automatic',
          'categorise',
          'categorize',
          'naming rules',
        ],
        row: SettingsRow(
          icon: Symbols.rule_rounded,
          iconColor: const Color(0xFF7C3AED),
          iconBackground: c.tintViolet,
          title: l10n.rulesTitle,
          subtitle: l10n.settingsWhereSomethingGoesBasedOn,
          onTap: () => _push(const TitleRulesScreen()),
        ),
      ),
    ];

    final data = [
      _Entry(
        title: l10n.settingsCloudSync,
        keywords: const ['sync', 'cloud', 'backup'],
        row: SettingsRow(
          icon: Symbols.cloud_sync_rounded,
          iconColor: const Color(0xFF0284C7),
          iconBackground: c.tintSky,
          title: l10n.settingsCloudSync,
          subtitle: l10n.settingsSyncYourDataAcrossDevices,
          badge: premiumState.isPremium ? null : const PremiumBadge(),
          onTap: () => _push(const SyncSettingsScreenGated()),
        ),
      ),
      _Entry(
        title: l10n.settingsBackupRestore,
        keywords: const ['backup', 'restore', 'google', 'drive', 'copy'],
        row: SettingsRow(
          icon: Symbols.backup_rounded,
          iconColor: c.positive,
          iconBackground: c.tintGreen,
          title: l10n.settingsBackupRestore,
          subtitle: l10n.settingsBackupRestoreSubtitle,
          onTap: () => _push(const BackupScreen()),
        ),
      ),
      _Entry(
        title: l10n.settingsExportData,
        keywords: const ['csv', 'pdf', 'download', 'data', 'export'],
        row: SettingsRow(
          icon: Symbols.download_rounded,
          iconColor: c.accent,
          iconBackground: c.tintOrange,
          title: l10n.settingsExportData,
          subtitle: l10n.settingsCsvIsFreePdfReport,
          onTap: () => _push(const ExportScreen()),
        ),
      ),
      _Entry(
        title: l10n.settingsImportStatement,
        keywords: const ['import', 'csv', 'statement', 'bank', 'upload'],
        row: SettingsRow(
          icon: Symbols.upload_file_rounded,
          iconColor: const Color(0xFF7C3AED),
          iconBackground: c.tintViolet,
          title: l10n.settingsImportStatement,
          subtitle: l10n.settingsImportStatementSubtitle,
          onTap: () => _push(const ImportScreen()),
        ),
      ),
      _Entry(
        title: l10n.settingsRecentlyDeleted,
        keywords: const ['deleted', 'restore', 'undo', 'trash'],
        row: SettingsRow(
          icon: Symbols.restore_from_trash_rounded,
          iconColor: c.negative,
          iconBackground: c.tintRose,
          title: l10n.settingsRecentlyDeleted,
          subtitle: l10n.settingsRecentlyDeletedSubtitle,
          onTap: () => _push(const RecentlyDeletedScreen()),
        ),
      ),
    ];

    final help = [
      _Entry(
        title: l10n.settingsContactSupport,
        keywords: const ['contact', 'support', 'email', 'feedback'],
        row: SettingsRow(
          icon: Symbols.mail_rounded,
          iconColor: const Color(0xFF0284C7),
          iconBackground: c.tintSky,
          title: l10n.settingsContactSupport,
          subtitle: l10n.settingsQuestionsComplaintsOrFeedback,
          onTap: () => _push(const ContactSupportScreen()),
        ),
      ),
      _Entry(
        title: l10n.settingsRateTheApp,
        keywords: const ['rate', 'review', 'star'],
        row: SettingsRow(
          icon: Symbols.star_rounded,
          iconColor: const Color(0xFFD97706),
          iconBackground: c.tintAmber,
          title: l10n.settingsRateTheApp,
          trailing: SettingsTrailing.external,
          onTap: _rateApp,
        ),
      ),
      _Entry(
        title: l10n.settingsShareWithFriends,
        keywords: const ['share', 'friends', 'invite'],
        row: SettingsRow(
          icon: Symbols.share_rounded,
          iconColor: c.positive,
          iconBackground: c.tintGreen,
          title: l10n.settingsShareWithFriends,
          trailing: SettingsTrailing.none,
          onTap: _shareApp,
        ),
      ),
      _Entry(
        title: l10n.settingsReplayAppTour,
        keywords: const ['walkthrough', 'tour', 'tutorial', 'guide', 'replay'],
        row: SettingsRow(
          icon: Symbols.play_circle_rounded,
          iconColor: c.accent,
          iconBackground: c.tintOrange,
          title: l10n.settingsReplayAppTour,
          subtitle: l10n.settingsSeeTheFeatureWalkthroughAgain,
          trailing: SettingsTrailing.none,
          onTap: () async {
            // Wait for the flag to clear: the dashboard reads it on its first
            // frame, and an unfinished reset meant the tour only appeared on
            // the next launch.
            await ref.read(walkthroughProvider.notifier).resetWalkthrough();
            if (!context.mounted) return;
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/dashboard',
              (route) => false,
            );
          },
        ),
      ),
      _Entry(
        title: l10n.settingsAboutTheAccountant,
        keywords: const ['about', 'version', 'license', 'info'],
        row: SettingsRow(
          icon: Symbols.info_rounded,
          iconColor: c.muted,
          iconBackground: c.tintPeach,
          title: l10n.settingsAboutTheAccountant,
          subtitle: l10n.settingsVersionLicensesAndMore,
          onTap: () => _push(const AboutScreen()),
        ),
      ),
    ];

    final account = [
      _Entry(
        title: l10n.settingsSubscription,
        keywords: const ['premium', 'upgrade', 'plan', 'subscription'],
        row: SettingsRow(
          icon: Symbols.workspace_premium_rounded,
          iconColor: c.accent,
          iconBackground: c.tintOrange,
          title: l10n.settingsSubscription,
          value: premiumState.isPremium
              ? premiumState.tier.displayName
              : l10n.moreUpgradeToPremium,
          onTap: () => Navigator.pushNamed(context, '/premium'),
        ),
      ),
      _Entry(
        title: l10n.settingsPrivacySecurity,
        keywords: const [
          'privacy',
          'security',
          'biometric',
          'lock',
          'fingerprint',
          'password',
        ],
        row: SettingsRow(
          icon: Symbols.shield_lock_rounded,
          iconColor: c.positive,
          iconBackground: c.tintGreen,
          title: l10n.settingsPrivacySecurity,
          onTap: () => _push(const PrivacySecurityScreen()),
        ),
      ),
      _Entry(
        title: l10n.settingsHelpFaq,
        keywords: const ['help', 'faq', 'question', 'guide'],
        row: SettingsRow(
          icon: Symbols.help_rounded,
          iconColor: const Color(0xFF0284C7),
          iconBackground: c.tintSky,
          title: l10n.settingsHelpFaq,
          onTap: () => _push(const HelpScreen()),
        ),
      ),
      _Entry(
        title: l10n.settingsSignOut,
        keywords: const ['sign out', 'logout', 'exit'],
        row: SettingsRow(
          icon: Symbols.logout_rounded,
          title: l10n.settingsSignOut,
          destructive: true,
          onTap: _signOut,
        ),
      ),
    ];

    return [
      (l10n.sectionPreferences, preferences, false),
      (l10n.sectionTools, money, false),
      (l10n.sectionDataManagement, data, false),
      (l10n.sectionHelpSupport, help, false),
      (l10n.sectionAccount, account, false),
      if (kDebugMode)
        (
          l10n.settingsDeveloper,
          [
            _Entry(
              title: l10n.settingsTestCrash,
              keywords: const ['crash', 'debug', 'crashlytics'],
              row: SettingsRow(
                icon: Symbols.bug_report_rounded,
                iconColor: const Color(0xFFD97706),
                iconBackground: c.tintAmber,
                title: l10n.settingsTestCrash,
                subtitle: l10n.settingsTriggerATestExceptionFor,
                trailing: SettingsTrailing.none,
                onTap: _testCrash,
              ),
            ),
          ],
          false,
        ),
    ];
  }

  Future<void> _testCrash() async {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    await FirebaseCrashlytics.instance.recordError(
      Exception('Test Crashlytics exception'),
      StackTrace.current,
      reason: 'Manual test crash from settings',
    );
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  Future<void> _signOut() async {
    final l10n = L10n.of(context);
    final confirmed = await showSunriseConfirm(
      context: context,
      title: l10n.settingsSignOut,
      message: l10n.moreSignOutConfirm,
      confirmLabel: l10n.settingsSignOut,
      destructive: true,
      icon: Symbols.logout_rounded,
    );
    if (!confirmed) return;
    try {
      await ref.read(authProvider.notifier).signOut();
      // Navigation to sign-in is handled by the auth state listener.
    } catch (_) {
      if (mounted) {
        showSunriseSnack(
          context,
          l10n.moreSignOutFailed,
          tone: SnackTone.error,
        );
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

/// Avatar, name and email; opens the profile editor.
class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.auth, required this.onTap});

  final AuthState auth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final name = (auth.displayName?.trim().isNotEmpty ?? false)
        ? auth.displayName!.trim()
        : l10n.moreUser;
    final initials = name
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p.characters.first.toUpperCase())
        .join();
    final photo = auth.photoUrl;

    return SunriseCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: c.gradient,
            ),
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            child: photo != null && photo.isNotEmpty
                ? Image.network(
                    photo,
                    width: 54,
                    height: 54,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _initials(initials),
                  )
                : _initials(initials),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.section.copyWith(color: c.ink),
                ),
                if ((auth.userEmail ?? '').isNotEmpty)
                  Text(
                    auth.userEmail!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: SunriseType.label.copyWith(
                      color: c.subtle,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          Icon(Symbols.chevron_right_rounded, color: c.chevron, size: 20),
        ],
      ),
    );
  }

  Widget _initials(String text) => Builder(
    builder: (context) => Text(
      text.isEmpty ? '·' : text,
      style: SunriseType.section.copyWith(color: context.sunrise.onFill),
    ),
  );
}

/// The Go Premium banner for free users.
class _GoPremiumBanner extends StatelessWidget {
  const _GoPremiumBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return GradientCard(
      onTap: onTap,
      radius: SunriseRadius.hero,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .22),
              borderRadius: BorderRadius.circular(SunriseRadius.iconTileLg),
            ),
            child: const Icon(Symbols.workspace_premium_rounded, fill: 1),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.moreGoPremium,
                  style: SunriseType.section.copyWith(color: c.onFill),
                ),
                Text(
                  l10n.moreGoPremiumBody,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.label.copyWith(
                    color: c.onFill.withValues(alpha: .9),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: c.onFill,
              borderRadius: BorderRadius.circular(SunriseRadius.chip),
            ),
            child: Text(
              l10n.moreUnlock,
              style: SunriseType.label.copyWith(
                color: c.accent,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// What premium users see in place of the banner.
class _PremiumActiveCard extends StatelessWidget {
  const _PremiumActiveCard({required this.tier, required this.onTap});

  final String tier;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return SunriseCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          IconTile(
            icon: Symbols.verified_rounded,
            color: c.onFill,
            gradient: c.gradient,
            size: 44,
            radius: SunriseRadius.iconTileLg,
            fill: 1,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.morePremiumActive,
                  style: SunriseType.rowTitle.copyWith(color: c.ink),
                ),
                Text(
                  '$tier · ${l10n.morePremiumThanks}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.caption.copyWith(color: c.subtle),
                ),
              ],
            ),
          ),
          Icon(Symbols.chevron_right_rounded, color: c.chevron, size: 20),
        ],
      ),
    );
  }
}

/// Free users' data lives only on this device.
class _DeviceOnlyNotice extends StatelessWidget {
  const _DeviceOnlyNotice({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return SunriseCard(
      onTap: onTap,
      color: c.tintAmber,
      shadow: false,
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Symbols.cloud_off_rounded, color: Color(0xFFD97706)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsYourDataIsOnThis,
                  style: SunriseType.rowTitle.copyWith(color: c.ink),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.moreDeviceOnlyBody,
                  style: SunriseType.caption.copyWith(color: c.body),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.settingsUpgradeForCloudSync,
                  style: SunriseType.label.copyWith(
                    color: c.accentText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

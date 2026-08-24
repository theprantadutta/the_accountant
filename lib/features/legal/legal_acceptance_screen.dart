import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_page_transitions.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:the_accountant/shared/widgets/glass_card.dart';
import 'package:the_accountant/shared/widgets/legal_loading_placeholder.dart';
import 'package:the_accountant/shared/widgets/legal_markdown_style.dart';

/// Privacy and terms, shown once before the first sign-in.
///
/// Brought into line with the rest of the pre-auth flow. It used to paint its
/// own background over the app-wide one, set every string with a raw
/// `TextStyle` and `Colors.white`, space itself with bare numbers, and fake a
/// disabled button with 40% opacity over a transparent shadow. Sitting between
/// the intro and the sign-in screen — both of which use the shared scale — it
/// was the one screen that looked borrowed from somewhere else.
///
/// The consent wording is deliberately unchanged. Restyling a screen is a
/// design decision; rewording what someone is agreeing to is not one to make in
/// passing.
class LegalAcceptanceScreen extends StatefulWidget {
  final VoidCallback? onAccepted;

  const LegalAcceptanceScreen({super.key, this.onAccepted});

  @override
  State<LegalAcceptanceScreen> createState() => _LegalAcceptanceScreenState();
}

class _LegalAcceptanceScreenState extends State<LegalAcceptanceScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
  );

  bool _accepted = false;
  bool _isLoading = true;
  String _privacyContent = '';
  String _termsContent = '';

  @override
  void initState() {
    super.initState();
    _loadLegalContent();
  }

  Future<void> _loadLegalContent() async {
    final results = await Future.wait([
      rootBundle.loadString('assets/legal/privacy.md'),
      rootBundle.loadString('assets/legal/terms.md'),
    ]);
    if (!mounted) return;
    setState(() {
      _privacyContent = results[0];
      _termsContent = results[1];
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onContinue() {
    HapticFeedback.selectionClick();
    if (widget.onAccepted != null) {
      widget.onAccepted!();
      return;
    }
    Navigator.pushReplacement(
      context,
      FadeThroughPageRoute<void>(builder: (context) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The ambient background is painted once for the whole app; this screen
    // lets it through rather than stacking a second one on top.
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Column(
            children: [
              AppSpacing.gapLg,
              _buildHeader(),
              AppSpacing.gapXl,
              _buildTabs(),
              AppSpacing.gapLg,
              Expanded(
                child: GlassCard(
                  padding: EdgeInsets.zero,
                  child: ClipRRect(
                    borderRadius: AppSpacing.borderRadiusXl,
                    child: _isLoading
                        ? const LegalLoadingPlaceholder()
                        : TabBarView(
                            controller: _tabController,
                            children: [
                              _buildDocument(_privacyContent),
                              _buildDocument(_termsContent),
                            ],
                          ),
                  ),
                ),
              ),
              AppSpacing.gapLg,
              _buildConsent(),
              AppSpacing.gapLg,
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  // A null callback is what disables a button, and the theme
                  // already knows how a disabled button should look. The old
                  // screen dimmed an always-tappable one to 40% instead, which
                  // reads as disabled to a sighted user and as nothing at all
                  // to a screen reader.
                  onPressed: _accepted ? _onContinue : null,
                  child: const Text('Continue'),
                ),
              ),
              AppSpacing.gapLg,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGlow.withValues(alpha: 0.28),
                blurRadius: 28,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(
            Icons.shield_outlined,
            size: 34,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.gapLg,
        Text('Privacy & Terms', style: AppTypography.headlineSmall),
        AppSpacing.gapSm,
        Text(
          'Review these before you continue.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return GlassCard(
      padding: EdgeInsets.zero,
      borderRadius: AppSpacing.borderRadiusMd,
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: AppSpacing.borderRadiusMd,
        ),
        dividerColor: Colors.transparent,
        labelColor: AppColors.textPrimary,
        unselectedLabelColor: AppColors.textMuted,
        labelStyle: AppTypography.labelLarge,
        unselectedLabelStyle: AppTypography.labelLarge,
        tabs: const [
          Tab(text: 'Privacy Policy'),
          Tab(text: 'Terms'),
        ],
      ),
    );
  }

  Widget _buildConsent() {
    return GlassCard(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // A real Checkbox, so it is focusable, announces its state, and grows
          // with the platform's text size. The hand-rolled AnimatedContainer it
          // replaces was invisible to assistive technology.
          Checkbox(
            value: _accepted,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              setState(() => _accepted = value ?? false);
            },
            activeColor: AppColors.primaryAccent,
            side: BorderSide(color: AppColors.textMuted, width: 1.5),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _accepted = !_accepted),
              child: Text(
                'I have read and agree to the Privacy Policy and Terms & '
                'Conditions',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocument(String content) {
    return Markdown(
      data: content,
      selectable: true,
      padding: AppSpacing.paddingLg,
      styleSheet: legalMarkdownStyleSheet(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_page_transitions.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/features/legal/legal_acceptance_screen.dart';
import 'package:the_accountant/features/settings/screens/theme_selection_screen.dart';
import 'package:the_accountant/shared/widgets/glass_card.dart';

/// One page of the first-run introduction.
class _IntroStep {
  const _IntroStep({
    required this.icon,
    required this.title,
    required this.body,
    this.showThemeLink = false,
  });

  final IconData icon;
  final String title;
  final String body;

  /// The last step offers a look at themes before the user commits.
  final bool showThemeLink;
}

/// The first thing anyone sees after installing.
///
/// Rebuilt to sit inside the app's own visual language rather than beside it.
/// The previous version fought it on every axis: it painted a second background
/// over the app-wide one, gave each page its own unrelated pink or blue
/// gradient, set type with raw sizes instead of the shared scale, and put emoji
/// in headings the rest of the product does not use. Someone arriving here and
/// then reaching the sign-in screen met two different products.
///
/// Motion is the other half. There were three animations running at once — an
/// `elasticOut` slide, a `bounceOut` scale, and a two-second float looping
/// forever — all restarting on every page change. The app's actual motion
/// language is the opposite: fade-through route transitions and background orbs
/// that drift over sixteen seconds. Nothing in it bounces.
///
/// So there is one movement here now: content fades up sixteen pixels as a page
/// arrives, once, and then holds still. That is also the whole reason the screen
/// felt fast — it was not the page speed, it was four elements re-animating on
/// top of a swipe.
class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onComplete;

  const OnboardingScreen({super.key, this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  static const List<_IntroStep> _steps = [
    _IntroStep(
      icon: Icons.account_balance_wallet_outlined,
      title: 'Every account, one balance',
      body:
          'Keep cash, cards and savings side by side, and see what you '
          'actually have left.',
    ),
    _IntroStep(
      icon: Icons.pie_chart_outline_rounded,
      title: 'Budgets that tell you early',
      body:
          'Set a limit per category. The app watches the total and warns you '
          'before you pass it, not after.',
    ),
    _IntroStep(
      icon: Icons.auto_awesome_outlined,
      title: 'Ask about your own spending',
      body:
          'Scan a receipt, or ask where the money went last month, and get an '
          'answer drawn from your records.',
    ),
    _IntroStep(
      icon: Icons.palette_outlined,
      title: 'Make it look like yours',
      body: 'Pick a theme now, or change it whenever you like from settings.',
      showThemeLink: true,
    ),
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  /// Drives the single entrance: fade in, rise a little, stop.
  late final AnimationController _entrance = AnimationController(
    duration: const Duration(milliseconds: 340),
    vsync: this,
  )..forward();

  late final Animation<double> _fade = CurvedAnimation(
    parent: _entrance,
    curve: Curves.easeOutCubic,
  );

  @override
  void dispose() {
    _entrance.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _finish() {
    if (widget.onComplete != null) {
      widget.onComplete!();
      return;
    }
    Navigator.pushReplacement(
      context,
      FadeThroughPageRoute<void>(
        builder: (context) => const LegalAcceptanceScreen(),
      ),
    );
  }

  void _advance() {
    if (_currentPage == _steps.length - 1) {
      _finish();
      return;
    }
    _pageController.nextPage(
      // Matched to the app's fade-through routes: unhurried, and eased at both
      // ends so the swipe settles instead of snapping.
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // Someone who has asked their device to stop animating gets no entrance at
    // all — the content is simply there.
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final isLastStep = _currentPage == _steps.length - 1;

    // The background is painted once for the whole app in `MaterialApp.builder`;
    // this screen just lets it through.
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _steps.length,
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                  if (!reduceMotion) _entrance.forward(from: 0);
                  HapticFeedback.selectionClick();
                },
                itemBuilder: (context, index) =>
                    _buildStep(_steps[index], reduceMotion),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              child: Column(
                children: [
                  _buildProgress(),
                  AppSpacing.gapXxl,
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: _advance,
                      child: Text(isLastStep ? 'Create your account' : 'Next'),
                    ),
                  ),
                  AppSpacing.gapSm,
                  SizedBox(
                    height: 48,
                    child: isLastStep
                        ? null
                        : TextButton(
                            onPressed: _finish,
                            child: Text(
                              'Skip',
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapLg,
          ],
        ),
      ),
    );
  }

  Widget _buildStep(_IntroStep step, bool reduceMotion) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGlyph(step.icon),
        AppSpacing.gapXxxl,
        Text(
          step.title,
          style: AppTypography.displaySmall,
          textAlign: TextAlign.center,
        ),
        AppSpacing.gapLg,
        GlassCard(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Text(
            step.body,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        if (step.showThemeLink) ...[
          AppSpacing.gapMd,
          TextButton.icon(
            onPressed: () => Navigator.push(
              context,
              FadeThroughPageRoute<void>(
                builder: (context) => const ThemeSelectionScreen(),
              ),
            ),
            icon: const Icon(Icons.brush_outlined, size: 18),
            label: const Text('Browse themes'),
          ),
        ],
      ],
    );

    final padded = Padding(
      padding: AppSpacing.paddingScreen,
      child: Center(child: SingleChildScrollView(child: content)),
    );

    if (reduceMotion) return padded;

    return AnimatedBuilder(
      animation: _fade,
      builder: (context, child) => Opacity(
        opacity: _fade.value,
        // Sixteen pixels. Enough to read as arriving, not enough to notice as
        // travel.
        child: Transform.translate(
          offset: Offset(0, 16 * (1 - _fade.value)),
          child: child,
        ),
      ),
      child: padded,
    );
  }

  /// The one accented shape on the screen.
  ///
  /// Every step used to bring its own gradient — one of them pink, one of them
  /// pale blue — which read as four unrelated screens. The plate is the same
  /// primary gradient the wordmark uses at sign-in, so arriving there feels
  /// like the same app. Only the glyph changes.
  Widget _buildGlyph(IconData icon) {
    return Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXxxl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGlow.withValues(alpha: 0.28),
            blurRadius: 32,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(icon, size: 44, color: AppColors.textPrimary),
    );
  }

  Widget _buildProgress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_steps.length, (index) {
        final isCurrent = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          width: isCurrent ? 24 : 6,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: AppSpacing.borderRadiusFull,
            color: isCurrent ? AppColors.primaryAccent : AppColors.glassWhite,
            border: isCurrent
                ? null
                : Border.all(color: AppColors.glassBorder, width: 1),
          ),
        );
      }),
    );
  }
}

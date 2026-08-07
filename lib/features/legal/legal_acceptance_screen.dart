import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_page_transitions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/core/utils/animation_utils.dart';
import 'package:the_accountant/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:the_accountant/shared/widgets/legal_markdown_style.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';

class LegalAcceptanceScreen extends StatefulWidget {
  final VoidCallback? onAccepted;

  const LegalAcceptanceScreen({super.key, this.onAccepted});

  @override
  State<LegalAcceptanceScreen> createState() => _LegalAcceptanceScreenState();
}

class _LegalAcceptanceScreenState extends State<LegalAcceptanceScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  bool _accepted = false;

  String _privacyContent = '';
  String _termsContent = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _animationController.forward();
    _loadLegalContent();
  }

  Future<void> _loadLegalContent() async {
    final results = await Future.wait([
      rootBundle.loadString('assets/legal/privacy.md'),
      rootBundle.loadString('assets/legal/terms.md'),
    ]);
    setState(() {
      _privacyContent = results[0];
      _termsContent = results[1];
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onContinue() {
    HapticFeedback.mediumImpact();
    if (widget.onAccepted != null) {
      widget.onAccepted!();
    } else {
      Navigator.pushReplacement(
        context,
        FadeThroughPageRoute<void>(
          builder: (context) => const SignInScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Header
              AnimationUtils.slideTransition(
                animation: _slideAnimation,
                begin: const Offset(0, 0.2),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      AppTheme.gradientContainer(
                        gradient: AppTheme.primaryGradient,
                        width: 72,
                        height: 72,
                        borderRadius: BorderRadius.circular(20),
                        child: const Center(
                          child: Icon(
                            Icons.shield_outlined,
                            size: 36,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Privacy & Terms',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please review our policies before continuing',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Tab Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AppTheme.glassmorphicContainer(
                  borderRadius: AppSpacing.borderRadiusMd,
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: AppSpacing.borderRadiusMd,
                    ),
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: const [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.privacy_tip_outlined, size: 18),
                            SizedBox(width: 6),
                            Text('Privacy Policy'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.description_outlined, size: 18),
                            SizedBox(width: 6),
                            Text('Terms'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Tab Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AppTheme.glassmorphicContainer(
                    child: ClipRRect(
                      borderRadius: AppSpacing.borderRadiusXl,
                      child: _isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShimmerCard(height: 28, width: 200),
                                  SizedBox(height: 16),
                                  ShimmerCard(height: 14),
                                  SizedBox(height: 8),
                                  ShimmerCard(height: 14),
                                  SizedBox(height: 8),
                                  ShimmerCard(height: 14),
                                  SizedBox(height: 24),
                                  ShimmerCard(height: 14),
                                  SizedBox(height: 8),
                                  ShimmerCard(height: 14),
                                ],
                              ),
                            )
                          : TabBarView(
                              controller: _tabController,
                              children: [
                                _buildMarkdownTab(_privacyContent),
                                _buildMarkdownTab(_termsContent),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Checkbox + Continue
              AnimationUtils.slideTransition(
                animation: _slideAnimation,
                begin: const Offset(0, 0.3),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Checkbox row
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() => _accepted = !_accepted);
                        },
                        child: AppTheme.glassmorphicContainer(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    gradient: _accepted
                                        ? AppColors.primaryGradient
                                        : null,
                                    color: _accepted
                                        ? null
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: _accepted
                                          ? Colors.transparent
                                          : Colors.white.withValues(alpha: 0.4),
                                      width: 2,
                                    ),
                                  ),
                                  child: _accepted
                                      ? const Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'I have read and agree to the Privacy Policy and Terms & Conditions',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Continue button
                      AppTheme.gradientContainer(
                        gradient: _accepted ? AppTheme.primaryGradient : null,
                        width: double.infinity,
                        height: 56,
                        boxShadow: _accepted
                            ? null
                            : [const BoxShadow(color: Colors.transparent)],
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _accepted ? 1.0 : 0.4,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: _accepted ? _onContinue : null,
                              child: const Center(
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarkdownTab(String content) {
    return Markdown(
      data: content,
      selectable: true,
      padding: const EdgeInsets.all(16),
      styleSheet: legalMarkdownStyleSheet(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:the_accountant/features/settings/screens/theme_selection_screen.dart';
import 'package:the_accountant/core/utils/animation_utils.dart';
import 'package:the_accountant/core/themes/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatingAnimation;

  final List<Map<String, dynamic>> _onboardingPages = [
    {
      'title': '💰 Welcome to The Accountant',
      'description': 'Your personal finance companion with AI-powered insights and beautiful design',
      'icon': Icons.account_balance_wallet,
      'gradient': AppTheme.primaryGradient,
    },
    {
      'title': '📊 Smart Budget Management',
      'description': 'Create intelligent budgets, track spending, and never overspend again',
      'icon': Icons.pie_chart,
      'gradient': AppTheme.secondaryGradient,
    },
    {
      'title': '✨ AI-Powered Insights',
      'description': 'Get personalized financial insights and recommendations from our AI assistant',
      'icon': Icons.auto_awesome,
      'gradient': LinearGradient(
        colors: [Color(0xFFee9ca7), Color(0xFFffdde1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'title': '🎨 Choose Your Style',
      'description': 'Personalize your experience with beautiful themes that reflect your personality',
      'icon': Icons.palette,
      'gradient': LinearGradient(
        colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'isThemeSelection': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    _slideAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceOut,
    );

    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _onboardingPages.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                      // Restart animation for new page
                      _animationController.reset();
                      _animationController.forward();
                    });
                    HapticFeedback.lightImpact();
                  },
                  itemBuilder: (context, index) {
                    final page = _onboardingPages[index];
                    return _buildOnboardingPage(
                      title: page['title'] as String,
                      description: page['description'] as String,
                      icon: page['icon'] as IconData,
                      gradient: page['gradient'] as Gradient,
                      isThemeSelection: page['isThemeSelection'] as bool? ?? false,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildPageIndicator(),
                    const SizedBox(height: 32),
                    _buildActionButton(),
                    const SizedBox(height: 24),
                    if (_currentPage < _onboardingPages.length - 1)
                      _buildSkipButton(),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingPage({
    required String title,
    required String description,
    required IconData icon,
    required Gradient gradient,
    required bool isThemeSelection,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          
          // Animated floating icon
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatingAnimation.value),
                child: AnimationUtils.scaleTransition(
                  animation: _scaleAnimation,
                  child: AppTheme.gradientContainer(
                    gradient: gradient,
                    width: 200,
                    height: 200,
                    borderRadius: BorderRadius.circular(32),
                    child: Center(
                      child: Icon(
                        icon,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 60),
          
          // Animated title
          AnimationUtils.slideTransition(
            animation: _slideAnimation,
            begin: const Offset(0, 0.5),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Animated description
          AnimationUtils.slideTransition(
            animation: _slideAnimation,
            begin: const Offset(0, 1),
            child: AppTheme.glassmorphicContainer(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          
          // Special content for theme selection page
          if (isThemeSelection) ...[
            const SizedBox(height: 32),
            AnimationUtils.fadeTransition(
              animation: _fadeAnimation,
              child: AppTheme.gradientContainer(
                gradient: AppTheme.secondaryGradient,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, _) => const ThemeSelectionScreen(),
                          transitionsBuilder: (context, animation, _, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.brush, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Explore Themes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_onboardingPages.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 32 : 12,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            gradient: _currentPage == index
                ? AppTheme.primaryGradient
                : null,
            color: _currentPage != index
                ? Colors.white.withValues(alpha: 0.3)
                : null,
          ),
        );
      }),
    );
  }

  Widget _buildActionButton() {
    return AnimationUtils.scaleTransition(
      animation: _scaleAnimation,
      child: AppTheme.gradientContainer(
        gradient: AppTheme.primaryGradient,
        width: double.infinity,
        height: 56,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              if (_currentPage == _onboardingPages.length - 1) {
                // Navigate to sign in screen
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, _) => const SignInScreen(),
                    transitionsBuilder: (context, animation, _, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Center(
              child: Text(
                _currentPage == _onboardingPages.length - 1
                    ? '🚀 Get Started'
                    : 'Continue',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return AnimationUtils.fadeTransition(
      animation: _fadeAnimation,
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, _) => const SignInScreen(),
              transitionsBuilder: (context, animation, _, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
        child: Text(
          'Skip for now',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
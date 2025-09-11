import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/theme_provider.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/core/themes/premium_themes.dart';
import 'package:the_accountant/core/utils/animation_utils.dart';

class ThemeSelectionScreen extends ConsumerStatefulWidget {
  const ThemeSelectionScreen({super.key});

  @override
  ConsumerState<ThemeSelectionScreen> createState() =>
      _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends ConsumerState<ThemeSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _slideAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final premiumState = ref.watch(premiumProvider);

    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Choose Your Theme',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimationUtils.fadeTransition(
                animation: _fadeAnimation,
                child: AppTheme.glassmorphicContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '✨ Express Yourself',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Choose a theme that reflects your style and makes managing finances a joy.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Default Theme
              AnimationUtils.slideTransition(
                animation: _slideAnimation,
                begin: const Offset(-1, 0),
                child: _buildThemeOption(
                  name: 'Default',
                  description: 'The classic dark theme',
                  colors: [
                    const Color(0xFF0f0c29),
                    const Color(0xFF667eea),
                    const Color(0xFF764ba2),
                  ],
                  isSelected: themeState.currentTheme == 'Default',
                  onTap: () => _selectTheme('Default'),
                  isPremium: false,
                  isUnlocked: true,
                ),
              ),
              const SizedBox(height: 16),

              // Premium Themes Section
              AnimationUtils.fadeTransition(
                animation: _fadeAnimation,
                child: Row(
                  children: [
                    const Text(
                      'Premium Themes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppTheme.secondaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'PRO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Premium Theme Options
              ...PremiumThemes.themeNames.asMap().entries.map((entry) {
                final index = entry.key;
                final themeName = entry.value;

                return AnimationUtils.slideTransition(
                  animation: AnimationUtils.createStaggeredAnimation(
                    controller: _controller,
                    startFraction: 0.1 + (index * 0.1),
                    endFraction: 0.5 + (index * 0.1),
                  ),
                  begin: const Offset(1, 0),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: _buildThemeOption(
                      name: themeName,
                      description: _getThemeDescription(themeName),
                      colors: _getThemeColors(themeName),
                      isSelected: themeState.currentTheme == themeName,
                      onTap: () => _selectTheme(themeName),
                      isPremium: true,
                      isUnlocked: premiumState.features.isUnlocked,
                    ),
                  ),
                );
              }),

              const SizedBox(height: 32),

              // Unlock Premium Button
              if (!premiumState.features.isUnlocked)
                AnimationUtils.fadeTransition(
                  animation: _fadeAnimation,
                  child: AppTheme.gradientContainer(
                    gradient: AppTheme.secondaryGradient,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.pushNamed(context, '/premium');
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Unlock Premium Themes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
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
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required String name,
    required String description,
    required List<Color> colors,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isPremium,
    required bool isUnlocked,
  }) {
    final isLocked = isPremium && !isUnlocked;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AppTheme.glassmorphicContainer(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: isLocked ? null : onTap,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Theme Preview
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: colors.first.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        if (isSelected)
                          const Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        if (isLocked)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.lock,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Theme Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isPremium) ...[
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.stars,
                                color: Colors.amber,
                                size: 16,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Selection Indicator
                  if (isSelected && !isLocked)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Color(0xFF667eea),
                        size: 16,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectTheme(String themeName) {
    ref.read(themeProvider.notifier).setTheme(themeName);

    // Add haptic feedback
    HapticFeedback.lightImpact();
  }

  String _getThemeDescription(String themeName) {
    switch (themeName) {
      case 'Sapphire':
        return 'Ocean depths with brilliant blue accents';
      case 'Emerald':
        return 'Forest serenity with vibrant green tones';
      case 'Ruby':
        return 'Passionate intensity with rich red hues';
      case 'Amethyst':
        return 'Royal elegance with purple sophistication';
      case 'Midnight':
        return 'Cosmic darkness with silver highlights';
      default:
        return 'A beautiful theme for your finances';
    }
  }

  List<Color> _getThemeColors(String themeName) {
    switch (themeName) {
      case 'Sapphire':
        return [
          const Color(0xFF0D1B2A),
          const Color(0xFF2196F3),
          const Color(0xFF64B5F6),
        ];
      case 'Emerald':
        return [
          const Color(0xFF0A1F1A),
          const Color(0xFF4CAF50),
          const Color(0xFF81C784),
        ];
      case 'Ruby':
        return [
          const Color(0xFF2A0A1A),
          const Color(0xFFF44336),
          const Color(0xFFE57373),
        ];
      case 'Amethyst':
        return [
          const Color(0xFF1A0A2A),
          const Color(0xFF9C27B0),
          const Color(0xFFBA68C8),
        ];
      case 'Midnight':
        return [
          const Color(0xFF0A0F14),
          const Color(0xFF607D8B),
          const Color(0xFF90A4AE),
        ];
      default:
        return [
          const Color(0xFF0f0c29),
          const Color(0xFF667eea),
          const Color(0xFF764ba2),
        ];
    }
  }
}

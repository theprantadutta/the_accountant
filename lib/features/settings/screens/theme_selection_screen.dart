import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/theme_provider.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';

class ThemeSelectionScreen extends ConsumerWidget {
  const ThemeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final premiumState = ref.watch(premiumProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Selection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Theme',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildThemeOption(
                    context: context,
                    ref: ref,
                    themeName: 'Light',
                    themeState: themeState,
                    premiumState: premiumState,
                    color: Colors.blue,
                  ),
                  _buildThemeOption(
                    context: context,
                    ref: ref,
                    themeName: 'Dark',
                    themeState: themeState,
                    premiumState: premiumState,
                    color: Colors.grey[800]!,
                  ),
                  _buildThemeOption(
                    context: context,
                    ref: ref,
                    themeName: 'Sapphire',
                    themeState: themeState,
                    premiumState: premiumState,
                    color: const Color(0xFF2196F3),
                    isPremium: true,
                  ),
                  _buildThemeOption(
                    context: context,
                    ref: ref,
                    themeName: 'Emerald',
                    themeState: themeState,
                    premiumState: premiumState,
                    color: const Color(0xFF4CAF50),
                    isPremium: true,
                  ),
                  _buildThemeOption(
                    context: context,
                    ref: ref,
                    themeName: 'Ruby',
                    themeState: themeState,
                    premiumState: premiumState,
                    color: const Color(0xFFF44336),
                    isPremium: true,
                  ),
                  _buildThemeOption(
                    context: context,
                    ref: ref,
                    themeName: 'Amethyst',
                    themeState: themeState,
                    premiumState: premiumState,
                    color: const Color(0xFF9C27B0),
                    isPremium: true,
                  ),
                  _buildThemeOption(
                    context: context,
                    ref: ref,
                    themeName: 'Midnight',
                    themeState: themeState,
                    premiumState: premiumState,
                    color: const Color(0xFF607D8B),
                    isPremium: true,
                  ),
                ],
              ),
            ),
            if (!premiumState.features.isUnlocked) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Unlock Premium Themes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Get access to exclusive premium themes with a premium subscription',
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/premium');
                        },
                        child: const Text('Upgrade to Premium'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required WidgetRef ref,
    required String themeName,
    required ThemeState themeState,
    required PremiumState premiumState,
    required Color color,
    bool isPremium = false,
  }) {
    final isSelected = themeState.currentTheme == themeName;
    final isLocked = isPremium && !premiumState.features.isUnlocked;

    return GestureDetector(
      onTap: isLocked
          ? null
          : () {
              ref.read(themeProvider.notifier).setTheme(themeName);
            },
      child: Card(
        elevation: isSelected ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSelected ? Icons.check_circle : Icons.circle,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    themeName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (isLocked)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
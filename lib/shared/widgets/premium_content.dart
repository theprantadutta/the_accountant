import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';

/// A widget that shows premium content only if the user has unlocked premium features
class PremiumContent extends ConsumerWidget {
  final Widget premiumWidget;
  final Widget? fallbackWidget;
  final String feature;

  const PremiumContent({
    super.key,
    required this.premiumWidget,
    this.fallbackWidget,
    required this.feature,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final premiumState = ref.watch(premiumProvider);
    final isFeatureUnlocked =
        premiumState.features.isUnlocked &&
        premiumState.features.features.contains(feature);

    if (isFeatureUnlocked) {
      return premiumWidget;
    } else {
      return fallbackWidget ?? const _PremiumUpsellWidget();
    }
  }
}

/// A widget that shows premium content only if the user has unlocked premium features
class PremiumFeature extends ConsumerWidget {
  final Widget child;
  final String feature;
  final bool hideIfLocked;

  const PremiumFeature({
    super.key,
    required this.child,
    required this.feature,
    this.hideIfLocked = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final premiumState = ref.watch(premiumProvider);
    final isFeatureUnlocked =
        premiumState.features.isUnlocked &&
        premiumState.features.features.contains(feature);

    if (isFeatureUnlocked) {
      return child;
    } else if (hideIfLocked) {
      return const SizedBox.shrink();
    } else {
      return Opacity(opacity: 0.5, child: IgnorePointer(child: child));
    }
  }
}

class _PremiumUpsellWidget extends StatelessWidget {
  const _PremiumUpsellWidget();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.workspace_premium, size: 48, color: Colors.amber),
            const SizedBox(height: 8),
            const Text(
              'Premium Feature',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Unlock this feature with premium access',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to premium screen
                Navigator.pushNamed(context, '/premium');
              },
              child: const Text('Upgrade to Premium'),
            ),
          ],
        ),
      ),
    );
  }
}

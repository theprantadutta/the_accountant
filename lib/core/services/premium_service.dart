import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/data/models/premium_features.dart';

class PremiumService {
  final Ref _ref;

  PremiumService(this._ref);

  /// Check if premium features are unlocked
  bool isPremiumUnlocked() {
    final premiumState = _ref.read(premiumProvider);
    return premiumState.features.isUnlocked;
  }

  /// Check if a specific feature is unlocked
  bool isFeatureUnlocked(String feature) {
    final premiumState = _ref.read(premiumProvider);
    return premiumState.features.isUnlocked && 
           premiumState.features.features.contains(feature);
  }

  /// Get list of unlocked features
  List<String> getUnlockedFeatures() {
    final premiumState = _ref.read(premiumProvider);
    return premiumState.features.isUnlocked 
        ? premiumState.features.features 
        : [];
  }

  /// Get all available premium features
  List<String> getAllPremiumFeatures() {
    return PremiumFeatures.allFeatures;
  }
}
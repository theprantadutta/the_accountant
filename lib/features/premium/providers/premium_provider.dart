import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:the_accountant/core/providers/theme_provider.dart';

class PremiumState {
  final PremiumFeatures features;
  final bool isLoading;
  final String? errorMessage;

  PremiumState({
    required this.features,
    this.isLoading = false,
    this.errorMessage,
  });

  PremiumState copyWith({
    PremiumFeatures? features,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PremiumState(
      features: features ?? this.features,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class PremiumNotifier extends StateNotifier<PremiumState> {
  final Ref _ref;

  PremiumNotifier(this._ref)
      : super(
          PremiumState(
            features: const PremiumFeatures(
              isUnlocked: false,
              features: [],
            ),
          ),
        );

  void unlockPremiumFeatures() {
    state = state.copyWith(
      features: state.features.copyWith(
        isUnlocked: true,
        features: PremiumFeatures.allFeatures,
        purchaseDate: DateTime.now(),
      ),
    );
    
    // Unlock premium themes
    _ref.read(themeProvider.notifier).unlockPremiumThemes();
  }

  void lockPremiumFeatures() {
    state = state.copyWith(
      features: state.features.copyWith(
        isUnlocked: false,
        features: const [],
        purchaseDate: null,
        purchaseId: null,
      ),
    );
    
    // Lock premium themes
    _ref.read(themeProvider.notifier).lockPremiumThemes();
  }

  bool isFeatureUnlocked(String feature) {
    return state.features.isUnlocked && state.features.features.contains(feature);
  }
}

final premiumProvider = StateNotifierProvider<PremiumNotifier, PremiumState>((ref) {
  return PremiumNotifier(ref);
});
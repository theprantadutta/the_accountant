import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';

const String _hasSeenWalkthroughKey = 'has_seen_walkthrough';

class WalkthroughState {
  final bool hasSeenWalkthrough;

  const WalkthroughState({this.hasSeenWalkthrough = false});

  WalkthroughState copyWith({bool? hasSeenWalkthrough}) {
    return WalkthroughState(
      hasSeenWalkthrough: hasSeenWalkthrough ?? this.hasSeenWalkthrough,
    );
  }
}

class WalkthroughNotifier extends Notifier<WalkthroughState> {
  @override
  WalkthroughState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return WalkthroughState(
      hasSeenWalkthrough: prefs.getBool(_hasSeenWalkthroughKey) ?? false,
    );
  }

  Future<void> markWalkthroughSeen() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_hasSeenWalkthroughKey, true);
    state = state.copyWith(hasSeenWalkthrough: true);
  }

  Future<void> resetWalkthrough() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_hasSeenWalkthroughKey, false);
    state = state.copyWith(hasSeenWalkthrough: false);
  }
}

final walkthroughProvider =
    NotifierProvider<WalkthroughNotifier, WalkthroughState>(
      WalkthroughNotifier.new,
    );

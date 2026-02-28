import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';

const String _hasSeenIntroKey = 'has_seen_intro';
const String _hasAcceptedLegalKey = 'has_accepted_legal';

class IntroLegalState {
  final bool hasSeenIntro;
  final bool hasAcceptedLegal;

  const IntroLegalState({
    this.hasSeenIntro = false,
    this.hasAcceptedLegal = false,
  });

  IntroLegalState copyWith({bool? hasSeenIntro, bool? hasAcceptedLegal}) {
    return IntroLegalState(
      hasSeenIntro: hasSeenIntro ?? this.hasSeenIntro,
      hasAcceptedLegal: hasAcceptedLegal ?? this.hasAcceptedLegal,
    );
  }
}

class IntroLegalNotifier extends Notifier<IntroLegalState> {
  @override
  IntroLegalState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return IntroLegalState(
      hasSeenIntro: prefs.getBool(_hasSeenIntroKey) ?? false,
      hasAcceptedLegal: prefs.getBool(_hasAcceptedLegalKey) ?? false,
    );
  }

  Future<void> markIntroSeen() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_hasSeenIntroKey, true);
    state = state.copyWith(hasSeenIntro: true);
  }

  Future<void> markLegalAccepted() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_hasAcceptedLegalKey, true);
    state = state.copyWith(hasAcceptedLegal: true);
  }
}

final introLegalProvider =
    NotifierProvider<IntroLegalNotifier, IntroLegalState>(
      IntroLegalNotifier.new,
    );

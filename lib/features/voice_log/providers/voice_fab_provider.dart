import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The floating mic on Today: whether it is shown, whether the user has been
/// asked, and where they last left it.
///
/// Off unless the user says yes. The mic in Today's header is always there;
/// this one is for people who say most of their spending and want it under a
/// thumb. Kept on this device, like the other display settings.
class VoiceFabState {
  const VoiceFabState({
    this.loaded = false,
    this.enabled = false,
    this.asked = false,
    this.onLeft = false,
    this.height = 1,
  });

  /// False until the saved choice has been read, so nothing is asked twice.
  final bool loaded;
  final bool enabled;
  final bool asked;

  /// Which edge it rests against, and how far down, 0 (top) to 1 (bottom).
  final bool onLeft;
  final double height;

  VoiceFabState copyWith({
    bool? enabled,
    bool? asked,
    bool? onLeft,
    double? height,
  }) => VoiceFabState(
    loaded: true,
    enabled: enabled ?? this.enabled,
    asked: asked ?? this.asked,
    onLeft: onLeft ?? this.onLeft,
    height: height ?? this.height,
  );
}

class VoiceFabNotifier extends StateNotifier<VoiceFabState> {
  VoiceFabNotifier() : super(const VoiceFabState()) {
    _load();
  }

  static const String enabledKey = 'voice_fab_enabled';
  static const String askedKey = 'voice_fab_asked';
  static const String onLeftKey = 'voice_fab_on_left';
  static const String heightKey = 'voice_fab_height';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = VoiceFabState(
      loaded: true,
      enabled: prefs.getBool(enabledKey) ?? false,
      asked: prefs.getBool(askedKey) ?? false,
      onLeft: prefs.getBool(onLeftKey) ?? false,
      height: prefs.getDouble(heightKey) ?? 1,
    );
  }

  /// Turning it on or off counts as an answer, so the question never follows.
  Future<void> setEnabled(bool enabled) async {
    state = state.copyWith(enabled: enabled, asked: true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(enabledKey, enabled);
    await prefs.setBool(askedKey, true);
  }

  Future<void> moveTo({required bool onLeft, required double height}) async {
    final h = height.clamp(0.0, 1.0);
    state = state.copyWith(onLeft: onLeft, height: h);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(onLeftKey, onLeft);
    await prefs.setDouble(heightKey, h);
  }
}

final voiceFabProvider = StateNotifierProvider<VoiceFabNotifier, VoiceFabState>(
  (ref) => VoiceFabNotifier(),
);

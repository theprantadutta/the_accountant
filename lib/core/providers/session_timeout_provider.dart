import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'
    show StateNotifier, StateNotifierProvider;
import 'package:the_accountant/core/services/session_timeout_service.dart';

class SessionTimeoutNotifier extends StateNotifier<SessionTimeoutService> {
  SessionTimeoutNotifier(Ref ref) : super(SessionTimeoutService(ref)) {
    // Start the session timeout service
  }

  // Handle user activity
  void handleUserActivity() {
    state.handleUserActivity();
  }

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }
}

final sessionTimeoutProvider =
    StateNotifierProvider<SessionTimeoutNotifier, SessionTimeoutService>((ref) {
      return SessionTimeoutNotifier(ref);
    });

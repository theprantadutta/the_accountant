import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/authentication/providers/auth_provider.dart';

class SessionTimeoutService {
  static const int _timeoutDuration = 30 * 60; // 30 minutes in seconds
  static const int _warningDuration =
      5 * 60; // 5 minutes warning before timeout

  Timer? _timeoutTimer;
  Timer? _warningTimer;
  bool _isWarningShown = false;

  final Ref ref;

  SessionTimeoutService(this.ref) {
    // Start monitoring user activity
    _startMonitoring();
  }

  // Start monitoring for user activity
  void _startMonitoring() {
    // Reset timers on user activity
    _resetTimers();

    // Listen for user interactions
    WidgetsBinding.instance.addObserver(_UserActivityObserver(this));
  }

  // Reset timeout timers
  void _resetTimers() {
    _isWarningShown = false;

    // Cancel existing timers
    _timeoutTimer?.cancel();
    _warningTimer?.cancel();

    // Start new timers
    _warningTimer = Timer(
      Duration(seconds: _timeoutDuration - _warningDuration),
      _showWarning,
    );
    _timeoutTimer = Timer(Duration(seconds: _timeoutDuration), _timeoutSession);
  }

  // Show warning dialog before timeout
  void _showWarning() {
    _isWarningShown = true;

    // Get the current context
    final context = _getActiveContext();
    if (context != null && context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Session Timeout Warning'),
            content: const Text(
              'Your session will expire in 5 minutes due to inactivity. Do you want to stay signed in?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetTimers(); // Reset timers if user chooses to stay
                },
                child: const Text('Stay Signed In'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _timeoutSession(); // Log out immediately
                },
                child: const Text('Log Out'),
              ),
            ],
          );
        },
      );
    }
  }

  // Timeout the session
  void _timeoutSession() {
    // Sign out the user
    ref.read(authProvider.notifier).signOut();

    // Show timeout message
    final context = _getActiveContext();
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have been logged out due to inactivity.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // Get active context (simplified implementation)
  BuildContext? _getActiveContext() {
    // In a real implementation, you would track the active context
    // This is a simplified version for demonstration
    return null;
  }

  // Handle user activity
  void handleUserActivity() {
    if (!_isWarningShown) {
      _resetTimers();
    }
  }

  // Dispose timers
  void dispose() {
    _timeoutTimer?.cancel();
    _warningTimer?.cancel();
  }
}

// Observer for user activity
class _UserActivityObserver extends WidgetsBindingObserver {
  final SessionTimeoutService service;

  _UserActivityObserver(this.service);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // App is in foreground, reset timers
        service.handleUserActivity();
        break;
      case AppLifecycleState.paused:
        // App is in background, let timers continue
        break;
      default:
        break;
    }
  }
}

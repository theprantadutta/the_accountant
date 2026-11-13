import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:the_accountant/core/services/analytics_service.dart';

/// What Crashlytics and Analytics are told beyond crashes and raw events:
/// the screen someone was on, who they are (an opaque account id, never an
/// email), and the errors the app caught and carried on from.
///
/// Before this, Crashlytics had no breadcrumbs and not one non-fatal in 90
/// days, so a crash arrived with no story behind it and handled failures
/// were invisible; and every screen in Analytics was "MainActivity".
class Diagnostics {
  Diagnostics._();

  /// Set by tests and any host without Firebase.
  static bool disabled = false;

  static FirebaseCrashlytics? get _crashlytics {
    if (disabled || kDebugMode) return null;
    try {
      return FirebaseCrashlytics.instance;
    } catch (_) {
      return null;
    }
  }

  /// Routes the app's `Logger` instances: everything to the console while
  /// developing, and in a release build only errors, as non-fatals.
  ///
  /// Must run before any service creates its logger.
  static void installLogging() {
    Logger.defaultFilter = () => _AppLogFilter();
    Logger.defaultOutput = () => _AppLogOutput();
  }

  /// A line in the log Crashlytics sends with the next crash or non-fatal.
  static void breadcrumb(String message) {
    try {
      _crashlytics?.log(message);
    } catch (_) {}
  }

  /// A value shown alongside every later report, such as the current screen.
  static void key(String name, Object value) {
    try {
      _crashlytics?.setCustomKey(name, value);
    } catch (_) {}
  }

  /// Ties later reports to an account, or to nobody when [id] is null.
  static void setUser(String? id) {
    try {
      _crashlytics?.setUserIdentifier(id ?? '');
    } catch (_) {}
  }

  /// Reports an error the app caught and recovered from.
  ///
  /// Being offline or a server timing out is how a phone lives, not a bug,
  /// so those are left out rather than drowning the real ones.
  static void handled(Object error, StackTrace? stack, {String? reason}) {
    if (isConnectivity(error)) return;
    try {
      _crashlytics?.recordError(
        error,
        callerStack(stack ?? StackTrace.current),
        reason: reason,
        fatal: false,
      );
    } catch (_) {}
  }

  /// [stack] without the logger's frames or this file's.
  ///
  /// Crashlytics groups a report by the first app frame. Left in, every
  /// error that was only logged would be blamed on this file and land in one
  /// issue, instead of on the code that logged it.
  @visibleForTesting
  static StackTrace callerStack(StackTrace stack) {
    final lines = stack.toString().split('\n');
    final kept = lines.where(
      (l) =>
          !l.contains('package:logger/') &&
          !l.contains('core/services/diagnostics.dart'),
    );
    return StackTrace.fromString(kept.join('\n'));
  }

  /// Whether [error] is the network being unavailable rather than a fault.
  @visibleForTesting
  static bool isConnectivity(Object? error) {
    if (error is SocketException ||
        error is TimeoutException ||
        error is HttpException ||
        error is HandshakeException) {
      return true;
    }
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.transformTimeout:
        case DioExceptionType.connectionError:
        case DioExceptionType.cancel:
          return true;
        case DioExceptionType.unknown:
          return isConnectivity(error.error);
        case DioExceptionType.badCertificate:
        case DioExceptionType.badResponse:
          return false;
      }
    }
    return false;
  }
}

class _AppLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) =>
      kDebugMode || event.level.value >= Level.error.value;
}

class _AppLogOutput extends LogOutput {
  final _console = ConsoleOutput();

  @override
  void output(OutputEvent event) {
    if (kDebugMode) {
      _console.output(event);
      return;
    }
    final origin = event.origin;
    if (origin.level.value < Level.error.value) return;
    final message = '${origin.message}';
    final error = origin.error;
    if (error != null) {
      Diagnostics.handled(error, origin.stackTrace, reason: message);
    } else {
      // Most call sites put the exception into the message itself. Its type
      // is lost, but the line and the stack still group and explain it.
      Diagnostics.handled(
        _LoggedError(message),
        origin.stackTrace ?? StackTrace.current,
      );
    }
  }
}

/// An error that was only ever logged as text.
class _LoggedError implements Exception {
  _LoggedError(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Names each screen as it opens, for Analytics and for Crashlytics.
///
/// Most screens are pushed as plain `MaterialPageRoute`s with no name, which
/// Firebase's own observer skips. This one falls back to the screen widget's
/// class name, read from the route once it has built.
class ScreenTracker extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _track(route);

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) _track(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) _track(previousRoute, afterBuild: false);
  }

  void _track(Route<dynamic> route, {bool afterBuild = true}) {
    if (route is! PageRoute) return;
    void report() {
      final name = screenNameOf(route);
      if (name == null) return;
      Diagnostics.breadcrumb('screen: $name');
      Diagnostics.key('screen', name);
      AnalyticsService().logScreenView(screenName: name);
    }

    if (afterBuild) {
      WidgetsBinding.instance.addPostFrameCallback((_) => report());
    } else {
      report();
    }
  }

  /// The route's name, or else the class of the screen it shows.
  @visibleForTesting
  static String? screenNameOf(Route<dynamic> route) {
    final named = route.settings.name;
    if (named != null && named.isNotEmpty && named != '/') return named;
    final context = route is ModalRoute ? route.subtreeContext : null;
    if (context == null || !context.mounted) return named;
    return _findScreen(context as Element) ?? named;
  }

  static final _screenType = RegExp(r'(Screen|Page)$');

  static String? _findScreen(Element root) {
    // Breadth-first and bounded: the screen widget sits a few levels under the
    // route's own scaffolding, never deep in its content.
    final queue = <Element>[root];
    var visited = 0;
    while (queue.isNotEmpty && visited < 400) {
      final element = queue.removeAt(0);
      visited++;
      final type = element.widget.runtimeType.toString().split('<').first;
      if (_screenType.hasMatch(type) && !type.startsWith('_')) return type;
      element.visitChildElements(queue.add);
    }
    return null;
  }
}

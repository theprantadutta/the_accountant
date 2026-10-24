import 'package:flutter/foundation.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:the_accountant/core/domain/app_destination.dart';

/// Receives launcher shortcuts and tapped notifications, and holds each until
/// the app is ready to act on it.
///
/// The holding is the point. A tap can arrive before authentication has
/// resolved — a cold start from a notification is exactly that — and
/// navigating then would either push a screen over the sign-in wall or be
/// thrown away by the wrapper rebuilding underneath it. So an arrival is
/// parked, and the shell takes it when there is somewhere safe to put it.
///
/// Links are not accepted at all: nothing outside the app can name a screen.
/// The only ways in are the two the app itself writes, its shortcuts and its
/// notifications.
class DeepLinkService {
  DeepLinkService({QuickActions? actions})
    : _actions = actions ?? const QuickActions();

  final QuickActions _actions;

  /// The most recent arrival that has not been acted on.
  final ValueNotifier<DeepLink?> pending = ValueNotifier(null);

  /// Put the launcher shortcuts in place, and route taps on them.
  ///
  /// Idempotent, because the labels change with the language and re-registering
  /// is how they get updated.
  Future<void> registerShortcuts(List<ShortcutItem> shortcuts) async {
    try {
      _actions.initialize((type) => _offer(DeepLinkParser.forShortcut(type)));
      await _actions.setShortcutItems(shortcuts);
    } catch (e) {
      // Shortcuts are unsupported on some platforms and simply absent on
      // others; neither is a failure worth surfacing.
      debugPrint('[DeepLink] shortcuts unavailable: $e');
    }
  }

  /// Take the parked arrival, if there is one, and clear it.
  ///
  /// Clearing on read is what stops one being obeyed twice — once when it
  /// arrives and again on the next rebuild.
  DeepLink? take() {
    final link = pending.value;
    pending.value = null;
    return link;
  }

  void _offer(DeepLink? link) {
    if (link == null) return;
    pending.value = link;
  }

  /// Park [link]; a tapped notification is handed over this way.
  void offer(DeepLink link) => _offer(link);

  Future<void> dispose() async => pending.dispose();
}

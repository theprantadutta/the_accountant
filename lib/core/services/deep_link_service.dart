import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:the_accountant/core/domain/app_destination.dart';

/// Receives links and launcher shortcuts, and holds them until the app is
/// ready to act on one.
///
/// The holding is the point. A link can arrive before authentication has
/// resolved — a cold start from a shortcut is exactly that — and navigating
/// then would either push a screen over the sign-in wall or be thrown away by
/// the wrapper rebuilding underneath it. So an arrival is parked, and the shell
/// takes it when there is somewhere safe to put it.
class DeepLinkService {
  DeepLinkService({AppLinks? links, QuickActions? actions})
    : _links = links ?? AppLinks(),
      _actions = actions ?? const QuickActions();

  final AppLinks _links;
  final QuickActions _actions;

  StreamSubscription<Uri>? _subscription;

  /// The most recent arrival that has not been acted on.
  final ValueNotifier<DeepLink?> pending = ValueNotifier(null);

  /// Start listening for links. Safe to call more than once.
  ///
  /// Deliberately separate from [registerShortcuts]: listening has to begin as
  /// early as possible so a cold start from a link is not missed, while the
  /// shortcuts need localised labels and so cannot be registered until
  /// something below the MaterialApp can read them.
  Future<void> startListening() async {
    if (_subscription != null) return;

    try {
      // The link the app was launched by, if any. A cold start does not
      // deliver through the stream.
      final initial = await _links.getInitialLink();
      if (initial != null) _offer(DeepLinkParser.parse(initial));

      _subscription = _links.uriLinkStream.listen(
        (uri) => _offer(DeepLinkParser.parse(uri)),
        // A malformed link is somebody else's mistake, not a reason to take the
        // app down.
        onError: (Object e) => debugPrint('[DeepLink] stream error: $e'),
      );
    } catch (e) {
      debugPrint('[DeepLink] could not start listening: $e');
    }
  }

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
  /// Clearing on read is what stops a link being obeyed twice — once when it
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

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    pending.dispose();
  }
}

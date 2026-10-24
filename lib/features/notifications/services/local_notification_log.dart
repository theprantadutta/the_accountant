import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/features/notifications/models/notification_item.dart';

/// The notifications this phone showed by itself, kept for the inbox.
///
/// The inbox only listed what the server had sent, and the server sent
/// nothing, so it always said 0 even after budget alerts had gone off. Those,
/// and the reminders worked out on the phone, are written here as they are
/// shown and listed next to the server's.
///
/// SharedPreferences rather than the database because the background isolate
/// writes here too, and it is the one store both sides can reach without
/// opening the account's database twice. Each side reloads before reading.
class LocalNotificationLog {
  LocalNotificationLog._();

  static const String _key = 'local_notification_log_v1';

  /// Older entries fall off; the inbox is not an archive.
  static const int _max = 100;

  static Future<List<NotificationItem>> read() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final raw = prefs.getString(_key);
    if (raw == null) return const [];
    try {
      return [
        for (final e in jsonDecode(raw) as List)
          NotificationItem.fromJson(e as Map<String, dynamic>),
      ];
    } catch (_) {
      return const [];
    }
  }

  static Future<void> _write(List<NotificationItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode([for (final i in items.take(_max)) i.toJson()]),
    );
  }

  /// Note a notification that was just shown.
  static Future<void> record({
    required NotificationType type,
    required String title,
    required String body,
  }) async {
    try {
      final now = DateTime.now();
      final items = await read();
      await _write([
        NotificationItem(
          id: 'local-${now.microsecondsSinceEpoch}',
          userId: '',
          type: type,
          title: title,
          body: body,
          status: NotificationStatus.sent,
          createdAt: now,
          isLocal: true,
        ),
        ...items,
      ]);
    } catch (_) {
      // The notification itself has been shown; losing its inbox copy is not
      // worth failing anything over.
    }
  }

  static Future<void> markRead(String id) async {
    final items = await read();
    await _write([
      for (final i in items)
        i.id == id
            ? i.copyWith(
                status: NotificationStatus.read,
                readAt: DateTime.now(),
              )
            : i,
    ]);
  }

  static Future<void> markAllRead() async {
    final items = await read();
    await _write([
      for (final i in items)
        i.isRead
            ? i
            : i.copyWith(
                status: NotificationStatus.read,
                readAt: DateTime.now(),
              ),
    ]);
  }

  /// Forget everything; on signing out or switching account.
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

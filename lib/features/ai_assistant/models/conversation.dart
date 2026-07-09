/// A single AI chat conversation/thread, summarised for the chats list.
class Conversation {
  final String id;
  final String title;
  final DateTime lastMessageAt;
  final int messageCount;

  const Conversation({
    required this.id,
    required this.title,
    required this.lastMessageAt,
    required this.messageCount,
  });

  Conversation copyWith({
    String? id,
    String? title,
    DateTime? lastMessageAt,
    int? messageCount,
  }) {
    return Conversation(
      id: id ?? this.id,
      title: title ?? this.title,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      messageCount: messageCount ?? this.messageCount,
    );
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: (json['id']) as String,
      title: (json['title'] as String?)?.trim().isNotEmpty == true
          ? (json['title'] as String).trim()
          : 'New chat',
      lastMessageAt: DateTime.parse(
        (json['last_message_at'] ?? json['lastMessageAt']) as String,
      ),
      messageCount:
          (json['message_count'] ?? json['messageCount']) as int? ?? 0,
    );
  }
}

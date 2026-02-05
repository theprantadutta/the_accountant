/// Represents a chat message in the AI assistant conversation
class ChatMessage {
  final String id;
  final String text;
  final bool isFromUser;
  final DateTime timestamp;
  final bool isInsight;
  final bool isSuggestion;
  final bool isWelcome;
  final bool isAiFallback;
  final String? aiErrorType;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isFromUser,
    required this.timestamp,
    this.isInsight = false,
    this.isSuggestion = false,
    this.isWelcome = false,
    this.isAiFallback = false,
    this.aiErrorType,
  });

  /// Creates a user message
  factory ChatMessage.user({
    required String text,
    String? id,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isFromUser: true,
      timestamp: timestamp ?? DateTime.now(),
    );
  }

  /// Creates an AI message
  factory ChatMessage.ai({
    required String text,
    String? id,
    DateTime? timestamp,
    bool isInsight = false,
    bool isSuggestion = false,
    bool isWelcome = false,
    bool isAiFallback = false,
    String? aiErrorType,
  }) {
    return ChatMessage(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isFromUser: false,
      timestamp: timestamp ?? DateTime.now(),
      isInsight: isInsight,
      isSuggestion: isSuggestion,
      isWelcome: isWelcome,
      isAiFallback: isAiFallback,
      aiErrorType: aiErrorType,
    );
  }

  /// Creates a welcome message
  factory ChatMessage.welcome() {
    return ChatMessage.ai(
      text:
          "Hello! I'm your AI financial assistant. I'm here to help you manage your finances, analyze your spending, and provide personalized advice. How can I assist you today?",
      isWelcome: true,
    );
  }

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isFromUser': isFromUser,
      'timestamp': timestamp.toIso8601String(),
      'isInsight': isInsight,
      'isSuggestion': isSuggestion,
      'isWelcome': isWelcome,
    };
  }

  /// Create from JSON response (handles both snake_case and camelCase)
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      text: json['text'] as String,
      isFromUser: (json['is_from_user'] ?? json['isFromUser']) as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isInsight: (json['is_insight'] ?? json['isInsight']) as bool? ?? false,
      isSuggestion:
          (json['is_suggestion'] ?? json['isSuggestion']) as bool? ?? false,
      isWelcome: (json['is_welcome'] ?? json['isWelcome']) as bool? ?? false,
      isAiFallback:
          (json['is_ai_fallback'] ?? json['isAiFallback']) as bool? ?? false,
      aiErrorType: (json['ai_error_type'] ?? json['aiErrorType']) as String?,
    );
  }

  /// Copy with updated fields
  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isFromUser,
    DateTime? timestamp,
    bool? isInsight,
    bool? isSuggestion,
    bool? isWelcome,
    bool? isAiFallback,
    String? aiErrorType,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isFromUser: isFromUser ?? this.isFromUser,
      timestamp: timestamp ?? this.timestamp,
      isInsight: isInsight ?? this.isInsight,
      isSuggestion: isSuggestion ?? this.isSuggestion,
      isWelcome: isWelcome ?? this.isWelcome,
      isAiFallback: isAiFallback ?? this.isAiFallback,
      aiErrorType: aiErrorType ?? this.aiErrorType,
    );
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, isFromUser: $isFromUser, text: ${text.length > 50 ? "${text.substring(0, 50)}..." : text})';
  }
}

/// Response from the AI chat API
class SendMessageResponse {
  final ChatMessage userMessage;
  final ChatMessage aiMessage;
  final bool isAiFallback;
  final String? aiErrorType;

  const SendMessageResponse({
    required this.userMessage,
    required this.aiMessage,
    required this.isAiFallback,
    this.aiErrorType,
  });

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) {
    return SendMessageResponse(
      userMessage: ChatMessage.fromJson(
        (json['user_message'] ?? json['userMessage']) as Map<String, dynamic>,
      ),
      aiMessage: ChatMessage.fromJson(
        (json['ai_message'] ?? json['aiMessage']) as Map<String, dynamic>,
      ),
      isAiFallback:
          (json['is_ai_fallback'] ?? json['isAiFallback']) as bool? ?? false,
      aiErrorType: (json['ai_error_type'] ?? json['aiErrorType']) as String?,
    );
  }
}

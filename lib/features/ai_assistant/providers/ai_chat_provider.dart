import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/features/ai_assistant/models/chat_message.dart';
import 'package:the_accountant/features/ai_assistant/services/ai_chat_service.dart';

/// State for AI chat conversation
class AiChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final bool isLoadingHistory;
  final bool historyLoaded;
  final String? errorMessage;
  final String? errorType;
  final bool hasError;

  const AiChatState({
    this.messages = const [],
    this.isLoading = false,
    this.isLoadingHistory = false,
    this.historyLoaded = false,
    this.errorMessage,
    this.errorType,
    this.hasError = false,
  });

  AiChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? isLoadingHistory,
    bool? historyLoaded,
    String? errorMessage,
    String? errorType,
    bool? hasError,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      historyLoaded: historyLoaded ?? this.historyLoaded,
      errorMessage: errorMessage,
      errorType: errorType,
      hasError: hasError ?? this.hasError,
    );
  }
}

/// Notifier for managing AI chat state
class AiChatNotifier extends StateNotifier<AiChatState> {
  final AiChatService _aiChatService;

  AiChatNotifier()
    : _aiChatService = AiChatService(),
      super(const AiChatState());

  /// Load chat history from the server
  Future<void> loadHistory() async {
    // Skip if already loaded or currently loading
    if (state.historyLoaded || state.isLoadingHistory) return;

    state = state.copyWith(isLoadingHistory: true);

    try {
      final messages = await _aiChatService.loadHistory();

      // If no messages, add welcome message
      if (messages.isEmpty) {
        state = state.copyWith(
          messages: [ChatMessage.welcome()],
          isLoadingHistory: false,
          historyLoaded: true,
        );
      } else {
        state = state.copyWith(
          messages: messages,
          isLoadingHistory: false,
          historyLoaded: true,
        );
      }
    } on AiChatException catch (e) {
      // On error, show welcome message and mark as loaded
      state = state.copyWith(
        messages: [ChatMessage.welcome()],
        isLoadingHistory: false,
        historyLoaded: true,
        hasError: true,
        errorMessage: e.message,
        errorType: e.errorType,
      );
    } catch (e) {
      // On error, show welcome message and mark as loaded
      state = state.copyWith(
        messages: [ChatMessage.welcome()],
        isLoadingHistory: false,
        historyLoaded: true,
      );
    }
  }

  /// Send a message and get AI response
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message immediately for UI feedback
    final tempUserMessage = ChatMessage.user(text: text.trim());
    state = state.copyWith(
      messages: [...state.messages, tempUserMessage],
      isLoading: true,
      hasError: false,
      errorMessage: null,
      errorType: null,
    );

    try {
      // Call the API - server handles conversation history
      final response = await _aiChatService.sendMessage(text.trim());

      // Replace the temporary user message with server response
      // and add AI response
      final messages = state.messages.toList();
      // Remove the temp user message
      if (messages.isNotEmpty && messages.last.isFromUser) {
        messages.removeLast();
      }
      // Add the actual messages from server
      messages.add(response.userMessage);

      final aiMessage = response.aiMessage.copyWith(
        isAiFallback: response.isAiFallback,
        aiErrorType: response.aiErrorType,
      );
      messages.add(aiMessage);

      state = state.copyWith(
        messages: messages,
        isLoading: false,
        hasError: response.isAiFallback,
        errorMessage: response.isAiFallback
            ? _getErrorDescription(response.aiErrorType)
            : null,
        errorType: response.aiErrorType,
      );
    } on AiChatException catch (e) {
      // Create fallback AI message for errors
      final fallbackMessage = ChatMessage.ai(
        text: _getFallbackMessage(e.errorType),
        isAiFallback: true,
        aiErrorType: e.errorType,
      );

      state = state.copyWith(
        messages: [...state.messages, fallbackMessage],
        isLoading: false,
        hasError: true,
        errorMessage: e.message,
        errorType: e.errorType,
      );
    } catch (e) {
      // Generic error handling
      final fallbackMessage = ChatMessage.ai(
        text:
            "I'm having trouble connecting right now. Please try again in a moment.",
        isAiFallback: true,
        aiErrorType: 'unknown_error',
      );

      state = state.copyWith(
        messages: [...state.messages, fallbackMessage],
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
        errorType: 'unknown_error',
      );
    }
  }

  /// Clear all messages and start fresh with welcome message
  Future<void> clearMessages() async {
    await _aiChatService.clearHistory();
    state = AiChatState(messages: [ChatMessage.welcome()], historyLoaded: true);
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(
      hasError: false,
      errorMessage: null,
      errorType: null,
    );
  }

  /// Retry the last failed message
  Future<void> retryLastMessage() async {
    // Find the last user message
    final lastUserMessage = state.messages.reversed.firstWhere(
      (m) => m.isFromUser,
      orElse: () => ChatMessage.user(text: ''),
    );

    if (lastUserMessage.text.isEmpty) return;

    // Remove the last AI message (the error response)
    final messages = state.messages.toList();
    if (messages.isNotEmpty && !messages.last.isFromUser) {
      messages.removeLast();
    }
    // Also remove the last user message
    if (messages.isNotEmpty && messages.last.isFromUser) {
      messages.removeLast();
    }

    state = state.copyWith(
      messages: messages,
      hasError: false,
      errorMessage: null,
      errorType: null,
    );

    // Resend the message
    await sendMessage(lastUserMessage.text);
  }

  String _getFallbackMessage(String? errorType) {
    switch (errorType) {
      case 'rate_limit':
        return "I'm receiving too many requests right now. Please wait a moment and try again.";
      case 'timeout':
        return "The request took too long. Please try again.";
      case 'service_unavailable':
        return "The AI service is temporarily unavailable. Please try again later.";
      case 'network_error':
        return "I couldn't connect to the server. Please check your internet connection.";
      case 'premium_required':
        return "AI Assistant is a premium feature. Please upgrade to continue.";
      default:
        return "I'm having trouble connecting right now. Please try again in a moment.";
    }
  }

  String? _getErrorDescription(String? errorType) {
    switch (errorType) {
      case 'rate_limit':
        return 'Rate limit exceeded';
      case 'timeout':
        return 'Request timed out';
      case 'service_unavailable':
        return 'Service unavailable';
      case 'network_error':
        return 'Network error';
      default:
        return null;
    }
  }
}

/// Provider for AI chat state
final aiChatProvider = StateNotifierProvider<AiChatNotifier, AiChatState>((
  ref,
) {
  return AiChatNotifier();
});

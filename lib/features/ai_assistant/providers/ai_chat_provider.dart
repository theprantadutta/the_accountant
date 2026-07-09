import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/core/services/analytics_service.dart';
import 'package:the_accountant/features/ai_assistant/models/chat_message.dart';
import 'package:the_accountant/features/ai_assistant/models/conversation.dart';
import 'package:the_accountant/features/ai_assistant/services/ai_chat_service.dart';

/// State for AI chat conversation
class AiChatState {
  final List<ChatMessage> messages;
  final List<Conversation> conversations;

  /// The conversation currently open. Null means an unsaved new chat that will
  /// be created on the server when the first message is sent.
  final String? currentConversationId;
  final bool isLoading;
  final bool isLoadingHistory;
  final bool historyLoaded;
  final String? errorMessage;
  final String? errorType;
  final bool hasError;

  const AiChatState({
    this.messages = const [],
    this.conversations = const [],
    this.currentConversationId,
    this.isLoading = false,
    this.isLoadingHistory = false,
    this.historyLoaded = false,
    this.errorMessage,
    this.errorType,
    this.hasError = false,
  });

  AiChatState copyWith({
    List<ChatMessage>? messages,
    List<Conversation>? conversations,
    String? currentConversationId,
    bool? isLoading,
    bool? isLoadingHistory,
    bool? historyLoaded,
    String? errorMessage,
    String? errorType,
    bool? hasError,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      conversations: conversations ?? this.conversations,
      currentConversationId:
          currentConversationId ?? this.currentConversationId,
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

  /// Initial load: fetch conversations and open the most recent one, or land on
  /// a fresh welcome screen when there are none yet.
  Future<void> init() async {
    if (state.historyLoaded || state.isLoadingHistory) return;

    state = state.copyWith(isLoadingHistory: true);

    try {
      final conversations = await _aiChatService.getConversations();

      if (conversations.isEmpty) {
        state = state.copyWith(
          conversations: [],
          messages: [ChatMessage.welcome()],
          isLoadingHistory: false,
          historyLoaded: true,
        );
        return;
      }

      final latest = conversations.first;
      final messages = await _aiChatService.getConversationMessages(latest.id);

      state = state.copyWith(
        conversations: conversations,
        currentConversationId: latest.id,
        messages: messages.isEmpty ? [ChatMessage.welcome()] : messages,
        isLoadingHistory: false,
        historyLoaded: true,
      );
    } on AiChatException catch (e) {
      state = state.copyWith(
        messages: [ChatMessage.welcome()],
        isLoadingHistory: false,
        historyLoaded: true,
        hasError: true,
        errorMessage: e.message,
        errorType: e.errorType,
      );
    } catch (e) {
      state = state.copyWith(
        messages: [ChatMessage.welcome()],
        isLoadingHistory: false,
        historyLoaded: true,
      );
    }
  }

  /// Refresh the conversation list silently (after sending / deleting).
  Future<void> _refreshConversations() async {
    try {
      final conversations = await _aiChatService.getConversations();
      state = state.copyWith(conversations: conversations);
    } catch (_) {
      // Keep the existing list on failure.
    }
  }

  /// Start a brand-new chat. Not persisted until the first message is sent.
  void newChat() {
    state = AiChatState(
      messages: [ChatMessage.welcome()],
      conversations: state.conversations,
      historyLoaded: true,
    );
  }

  /// Open an existing conversation.
  Future<void> selectConversation(String conversationId) async {
    if (conversationId == state.currentConversationId && !state.hasError) {
      return;
    }

    state = state.copyWith(isLoadingHistory: true, hasError: false);
    try {
      final messages = await _aiChatService.getConversationMessages(
        conversationId,
      );
      state = state.copyWith(
        currentConversationId: conversationId,
        messages: messages.isEmpty ? [ChatMessage.welcome()] : messages,
        isLoadingHistory: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingHistory: false,
        hasError: true,
        errorMessage: 'Failed to open conversation.',
        errorType: 'unknown_error',
      );
    }
  }

  /// Delete a conversation. If it was the open one, fall back to the next most
  /// recent conversation or a fresh chat.
  Future<void> deleteConversation(String conversationId) async {
    final remaining = state.conversations
        .where((c) => c.id != conversationId)
        .toList();
    final wasCurrent = conversationId == state.currentConversationId;

    state = state.copyWith(conversations: remaining);
    await _aiChatService.deleteConversation(conversationId);

    if (wasCurrent) {
      if (remaining.isNotEmpty) {
        await selectConversation(remaining.first.id);
      } else {
        newChat();
      }
    }
  }

  /// Send a message and get AI response
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    AnalyticsService().logAiChatMessage();

    // Drop the client-only welcome placeholder once the chat really begins.
    final base = state.messages.where((m) => !m.isWelcome).toList();

    // Add user message immediately for UI feedback
    final tempUserMessage = ChatMessage.user(text: text.trim());
    state = state.copyWith(
      messages: [...base, tempUserMessage],
      isLoading: true,
      hasError: false,
      errorMessage: null,
      errorType: null,
    );

    try {
      final response = await _aiChatService.sendMessage(
        text.trim(),
        conversationId: state.currentConversationId,
      );

      // Replace the temporary user message with the server's echoed pair.
      final messages = state.messages.toList();
      if (messages.isNotEmpty && messages.last.isFromUser) {
        messages.removeLast();
      }
      messages.add(response.userMessage);

      final aiMessage = response.aiMessage.copyWith(
        isAiFallback: response.isAiFallback,
        aiErrorType: response.aiErrorType,
      );
      messages.add(aiMessage);

      state = state.copyWith(
        messages: messages,
        currentConversationId: response.conversationId.isNotEmpty
            ? response.conversationId
            : state.currentConversationId,
        isLoading: false,
        hasError: response.isAiFallback,
        errorMessage: response.isAiFallback
            ? _getErrorDescription(response.aiErrorType)
            : null,
        errorType: response.aiErrorType,
      );

      // Surface the new/updated thread in the chats list.
      await _refreshConversations();
    } on AiChatException catch (e) {
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

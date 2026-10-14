import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/core/services/analytics_service.dart';
import 'package:the_accountant/features/ai_assistant/providers/ai_quota_provider.dart';
import 'package:the_accountant/features/ai_assistant/services/ai_api.dart';
import 'package:the_accountant/features/ai_assistant/services/finance_context_builder.dart';
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

  /// A question held back because today's free requests ran out. The screen
  /// offers an ad (or Premium) and sends it once there is a request to spend.
  final String? pendingQuestion;

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
    this.pendingQuestion,
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
    String? pendingQuestion,
    bool clearPending = false,
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
      pendingQuestion: clearPending
          ? null
          : pendingQuestion ?? this.pendingQuestion,
    );
  }
}

/// Notifier for managing AI chat state
class AiChatNotifier extends StateNotifier<AiChatState> {
  final AiChatService _aiChatService;
  final Ref _ref;
  StreamSubscription<ChatStreamEvent>? _reply;

  AiChatNotifier(this._ref)
    : _aiChatService = AiChatService(),
      super(const AiChatState());

  @override
  void dispose() {
    _reply?.cancel();
    super.dispose();
  }

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

  /// Rename a conversation. Applies optimistically then persists.
  Future<void> renameConversation(String conversationId, String title) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;

    final updated = state.conversations
        .map((c) => c.id == conversationId ? c.copyWith(title: trimmed) : c)
        .toList();
    state = state.copyWith(conversations: updated);

    await _aiChatService.renameConversation(conversationId, trimmed);
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

  /// Ask the coach. The reply streams into the conversation as it is written.
  ///
  /// Nothing is saved on the server until the reply is complete, so a failed
  /// attempt leaves no trace and [retryLastMessage] sends the question once.
  /// When today's free requests are used up the question is held in
  /// [AiChatState.pendingQuestion] for the screen to offer an ad.
  Future<void> sendMessage(String text) async {
    final question = text.trim();
    if (question.isEmpty || state.isLoading) return;

    final quota = _ref.read(aiQuotaProvider);
    if (!quota.hasCallsLeft) {
      state = state.copyWith(pendingQuestion: question);
      return;
    }

    AnalyticsService().logAiChatMessage();

    // Drop the client-only welcome placeholder once the chat really begins.
    final base = state.messages.where((m) => !m.isWelcome).toList();
    final asked = ChatMessage.user(text: question);
    final replyId = 'streaming-${DateTime.now().microsecondsSinceEpoch}';
    final reply = ChatMessage.ai(
      text: '',
      id: replyId,
    ).copyWith(isStreaming: true);

    state = state.copyWith(
      messages: [...base, asked, reply],
      isLoading: true,
      hasError: false,
      clearPending: true,
    );

    Map<String, dynamic>? context;
    try {
      context = await FinanceContextBuilder(_ref.read).build();
    } catch (_) {
      // The coach can still answer in general terms without the figures.
    }

    final written = StringBuffer();
    final done = Completer<void>();

    _reply = _ref
        .read(aiApiProvider)
        .streamChat(
          question,
          conversationId: state.currentConversationId,
          context: context,
        )
        .listen(
          (event) {
            switch (event) {
              case ChatStarted(:final conversationId):
                if (conversationId.isNotEmpty) {
                  state = state.copyWith(currentConversationId: conversationId);
                }
              case ChatDelta(:final text):
                written.write(text);
                _updateReply(replyId, _visible(written.toString()));
              case ChatDone(:final response):
                final messages =
                    state.messages
                        .where((m) => m.id != replyId && m.id != asked.id)
                        .toList()
                      ..addAll([response.userMessage, response.aiMessage]);
                state = state.copyWith(
                  messages: messages,
                  currentConversationId: response.conversationId,
                  isLoading: false,
                );
                _ref.read(aiQuotaProvider.notifier).spendOne();
            }
          },
          onError: (Object error) {
            _failReply(asked, replyId, question, error);
            if (!done.isCompleted) done.complete();
          },
          onDone: () {
            if (!done.isCompleted) done.complete();
          },
          cancelOnError: true,
        );

    await done.future;
    _reply = null;
    if (state.isLoading) state = state.copyWith(isLoading: false);

    unawaited(_ref.read(aiQuotaProvider.notifier).refresh());
    await _refreshConversations();
  }

  /// Sends the question that was waiting for a request (after an ad).
  Future<void> sendPending() async {
    final question = state.pendingQuestion;
    if (question == null) return;
    state = state.copyWith(clearPending: true);
    await sendMessage(question);
  }

  /// Gives up on the waiting question.
  void dropPending() => state = state.copyWith(clearPending: true);

  void _updateReply(String id, String text) {
    state = state.copyWith(
      messages: [
        for (final m in state.messages)
          if (m.id == id) m.copyWith(text: text) else m,
      ],
    );
  }

  void _failReply(
    ChatMessage asked,
    String replyId,
    String question,
    Object error,
  ) {
    final ai = error is AiException ? error : null;

    if (ai != null && ai.isQuotaExhausted) {
      // Not a failure: the question waits for an ad or Premium.
      state = state.copyWith(
        messages: state.messages
            .where((m) => m.id != replyId && m.id != asked.id)
            .toList(),
        isLoading: false,
        pendingQuestion: question,
      );
      unawaited(_ref.read(aiQuotaProvider.notifier).refresh());
      return;
    }

    final notice = ChatMessage.ai(
      text:
          ai?.message ??
          'The AI service is not answering right now. Nothing was charged; '
              'please try again.',
      id: replyId,
      isAiFallback: true,
      aiErrorType: ai?.code ?? AiException.unavailable,
    );
    state = state.copyWith(
      messages: [
        for (final m in state.messages)
          if (m.id == replyId) notice else m,
      ],
      isLoading: false,
      hasError: true,
      errorMessage: notice.text,
      errorType: notice.aiErrorType,
    );
  }

  /// Hides the follow-up marker while it is still being written.
  static String _visible(String text) {
    final marker = text.indexOf('[[');
    return (marker >= 0 ? text.substring(0, marker) : text).trimRight();
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(
      hasError: false,
      errorMessage: null,
      errorType: null,
    );
  }

  /// Ask the last question again. The failed attempt was never saved, so this
  /// sends it once.
  Future<void> retryLastMessage() async {
    final lastQuestion = state.messages.reversed
        .where((m) => m.isFromUser)
        .map((m) => m.text)
        .firstOrNull;
    if (lastQuestion == null) return;

    final messages = state.messages.toList();
    if (messages.isNotEmpty && messages.last.isAiFallback) {
      messages.removeLast();
    }
    if (messages.isNotEmpty && messages.last.isFromUser) messages.removeLast();

    state = state.copyWith(messages: messages, hasError: false);
    await sendMessage(lastQuestion);
  }
}

/// Provider for AI chat state
final aiChatProvider = StateNotifierProvider<AiChatNotifier, AiChatState>((
  ref,
) {
  return AiChatNotifier(ref);
});

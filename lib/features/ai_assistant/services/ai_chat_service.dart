import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/features/ai_assistant/models/chat_message.dart';
import 'package:the_accountant/features/ai_assistant/models/conversation.dart';

/// Service for AI chat communication with the backend
class AiChatService {
  final ApiService _apiService;
  final Logger _logger = Logger();

  AiChatService({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  /// Load the list of conversations (chat threads) for the current user.
  Future<List<Conversation>> getConversations() async {
    try {
      _logger.i('Loading conversations from server');

      final response = await _apiService.get('/ai-chat/conversations');

      final data = response.data as Map<String, dynamic>;
      final list = data['conversations'] as List<dynamic>? ?? [];

      final conversations = list
          .map((c) => Conversation.fromJson(c as Map<String, dynamic>))
          .toList();

      _logger.i('Loaded ${conversations.length} conversations');
      return conversations;
    } on DioException catch (e) {
      _logger.e('Failed to load conversations: ${e.message}');
      _throwPremiumOrGeneric(e);
    } catch (e) {
      _logger.e('Unexpected error loading conversations: $e');
      throw AiChatException(
        'Failed to load conversations.',
        errorType: 'unknown_error',
      );
    }
  }

  /// Load the messages of a single conversation.
  Future<List<ChatMessage>> getConversationMessages(
    String conversationId, {
    int? limit,
  }) async {
    try {
      _logger.i('Loading messages for conversation $conversationId');

      final queryParams = <String, dynamic>{};
      if (limit != null) {
        queryParams['limit'] = limit;
      }

      final response = await _apiService.get(
        '/ai-chat/conversations/$conversationId/messages',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final data = response.data as Map<String, dynamic>;
      final messagesJson = data['messages'] as List<dynamic>? ?? [];

      final messages = messagesJson
          .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
          .toList();

      _logger.i('Loaded ${messages.length} messages');
      return messages;
    } on DioException catch (e) {
      _logger.e('Failed to load conversation messages: ${e.message}');
      _throwPremiumOrGeneric(e);
    } catch (e) {
      _logger.e('Unexpected error loading conversation messages: $e');
      throw AiChatException(
        'Failed to load chat history.',
        errorType: 'unknown_error',
      );
    }
  }

  /// Delete a conversation (all of its messages) on the server.
  Future<void> deleteConversation(String conversationId) async {
    try {
      await _apiService.delete('/ai-chat/conversations/$conversationId');
      _logger.i('Deleted conversation $conversationId');
    } on DioException catch (e) {
      _logger.e('Failed to delete conversation: ${e.message}');
      // Non-fatal for the UI; the optimistic removal holds.
    } catch (e) {
      _logger.w('Failed to delete conversation on server: $e');
    }
  }

  /// Maps a 403 PREMIUM_REQUIRED into a typed exception, otherwise a generic one.
  Never _throwPremiumOrGeneric(DioException e) {
    if (e.response?.statusCode == 403) {
      final data = e.response?.data;
      if (data is Map && data['code'] == 'PREMIUM_REQUIRED') {
        throw AiChatException(
          'Premium subscription required for AI Assistant',
          errorType: 'premium_required',
        );
      }
    }
    throw AiChatException(_getErrorMessage(e), errorType: _getErrorType(e));
  }

  /// Send a message to the AI assistant.
  /// Pass [conversationId] to continue a thread, or null to start a new one.
  /// Returns the AI response, the echoed user message and the conversation id.
  Future<SendMessageResponse> sendMessage(
    String message, {
    String? conversationId,
  }) async {
    try {
      _logger.i('Sending message to AI chat API');

      final response = await _apiService.post(
        '/ai-chat/message',
        data: {
          'message': message,
          'conversation_id': ?conversationId,
        },
      );

      _logger.i('AI chat response received');
      return SendMessageResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      _logger.e('AI chat API error: ${e.message}');

      // Check for premium required error
      if (e.response?.statusCode == 403) {
        final data = e.response?.data;
        if (data is Map && data['code'] == 'PREMIUM_REQUIRED') {
          throw AiChatException(
            'Premium subscription required for AI Assistant',
            errorType: 'premium_required',
          );
        }
      }

      // For other errors, create a fallback response
      throw AiChatException(_getErrorMessage(e), errorType: _getErrorType(e));
    } catch (e) {
      _logger.e('Unexpected error in AI chat: $e');
      throw AiChatException(
        'An unexpected error occurred. Please try again.',
        errorType: 'unknown_error',
      );
    }
  }

  String _getErrorMessage(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map && data.containsKey('detail')) {
        return data['detail'].toString();
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please check your internet and try again.';
      case DioExceptionType.connectionError:
        return 'Cannot connect to server. Please check your internet connection.';
      default:
        return 'Failed to get AI response. Please try again.';
    }
  }

  String _getErrorType(DioException error) {
    if (error.response != null) {
      switch (error.response!.statusCode) {
        case 429:
          return 'rate_limit';
        case 503:
          return 'service_unavailable';
        case 504:
          return 'timeout';
        case 401:
          return 'unauthorized';
        case 403:
          return 'forbidden';
        default:
          return 'api_error';
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'timeout';
      case DioExceptionType.connectionError:
        return 'network_error';
      default:
        return 'unknown_error';
    }
  }
}

/// Exception for AI chat errors
class AiChatException implements Exception {
  final String message;
  final String errorType;

  AiChatException(this.message, {required this.errorType});

  @override
  String toString() => message;
}

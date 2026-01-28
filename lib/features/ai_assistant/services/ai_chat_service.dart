import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/features/ai_assistant/models/chat_message.dart';

/// Service for AI chat communication with the backend
class AiChatService {
  final ApiService _apiService;
  final Logger _logger = Logger();

  AiChatService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Load chat history from the server
  Future<List<ChatMessage>> loadHistory({int? limit}) async {
    try {
      _logger.i('Loading chat history from server');

      final queryParams = <String, dynamic>{};
      if (limit != null) {
        queryParams['limit'] = limit;
      }

      final response = await _apiService.get(
        '/ai-chat/history',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final data = response.data as Map<String, dynamic>;
      final messagesJson = data['messages'] as List<dynamic>? ?? [];

      final messages = messagesJson
          .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
          .toList();

      _logger.i('Loaded ${messages.length} messages from history');
      return messages;
    } on DioException catch (e) {
      _logger.e('Failed to load chat history: ${e.message}');

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

      throw AiChatException(
        _getErrorMessage(e),
        errorType: _getErrorType(e),
      );
    } catch (e) {
      _logger.e('Unexpected error loading chat history: $e');
      throw AiChatException(
        'Failed to load chat history.',
        errorType: 'unknown_error',
      );
    }
  }

  /// Send a message to the AI assistant
  /// Returns the AI response along with the echoed user message
  Future<SendMessageResponse> sendMessage(String message) async {
    try {
      _logger.i('Sending message to AI chat API');

      final response = await _apiService.post(
        '/ai-chat/message',
        data: {'message': message},
      );

      _logger.i('AI chat response received');
      return SendMessageResponse.fromJson(response.data as Map<String, dynamic>);
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
      throw AiChatException(
        _getErrorMessage(e),
        errorType: _getErrorType(e),
      );
    } catch (e) {
      _logger.e('Unexpected error in AI chat: $e');
      throw AiChatException(
        'An unexpected error occurred. Please try again.',
        errorType: 'unknown_error',
      );
    }
  }

  /// Clear chat history on server
  Future<void> clearHistory() async {
    try {
      await _apiService.post('/ai-chat/clear');
      _logger.i('Chat history cleared');
    } on DioException catch (e) {
      _logger.e('Failed to clear chat history: ${e.message}');
      // Don't throw - clear can fail silently
    } catch (e) {
      _logger.w('Failed to clear chat history on server: $e');
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

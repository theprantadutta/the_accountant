import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/features/ai_assistant/models/ai_quota.dart';
import 'package:the_accountant/features/ai_assistant/models/chat_message.dart';

/// Why an AI request did not produce an answer.
class AiException implements Exception {
  /// The server's code (`AI_QUOTA_EXHAUSTED`, `AI_UNAVAILABLE`, ...), or
  /// `NETWORK` when the request never got an answer.
  final String code;
  final String message;
  final int? statusCode;

  const AiException(this.code, this.message, {this.statusCode});

  static const quotaExhausted = 'AI_QUOTA_EXHAUSTED';
  static const unavailable = 'AI_UNAVAILABLE';
  static const unreadable = 'AI_UNREADABLE';
  static const network = 'NETWORK';

  bool get isQuotaExhausted => code == quotaExhausted;

  @override
  String toString() => message;
}

/// One step of a streamed coach reply.
sealed class ChatStreamEvent {
  const ChatStreamEvent();
}

/// The server accepted the question; [conversationId] is now known.
class ChatStarted extends ChatStreamEvent {
  final String conversationId;
  const ChatStarted(this.conversationId);
}

/// The next piece of the reply.
class ChatDelta extends ChatStreamEvent {
  final String text;
  const ChatDelta(this.text);
}

/// The reply is complete and saved.
class ChatDone extends ChatStreamEvent {
  final SendMessageResponse response;
  const ChatDone(this.response);
}

class ReceiptReading {
  final String? merchant;
  final double? total;
  final String? currency;
  final DateTime? date;
  final List<({String name, double? amount})> items;
  final String? category;
  final String? note;

  const ReceiptReading({
    this.merchant,
    this.total,
    this.currency,
    this.date,
    this.items = const [],
    this.category,
    this.note,
  });

  factory ReceiptReading.fromJson(Map<String, dynamic> json) => ReceiptReading(
    merchant: json['merchant'] as String?,
    total: (json['total'] as num?)?.toDouble(),
    currency: json['currency'] as String?,
    date: DateTime.tryParse(json['date'] as String? ?? ''),
    items: [
      for (final item in (json['items'] as List? ?? const []))
        if (item is Map)
          (
            name: item['name']?.toString() ?? '',
            amount: (item['amount'] as num?)?.toDouble(),
          ),
    ],
    category: json['category'] as String?,
    note: json['note'] as String?,
  );
}

class QuickAddDraft {
  final String title;
  final double? amount;
  final bool isIncome;
  final DateTime? date;
  final String? category;
  final String? wallet;
  final String? note;

  const QuickAddDraft({
    required this.title,
    this.amount,
    this.isIncome = false,
    this.date,
    this.category,
    this.wallet,
    this.note,
  });

  factory QuickAddDraft.fromJson(Map<String, dynamic> json) => QuickAddDraft(
    title: json['title'] as String? ?? '',
    amount: (json['amount'] as num?)?.toDouble(),
    isIncome: json['is_income'] as bool? ?? false,
    date: DateTime.tryParse(json['date'] as String? ?? ''),
    category: json['category'] as String?,
    wallet: json['wallet'] as String?,
    note: json['note'] as String?,
  );
}

/// The backend's AI endpoints: allowance, rewards, the coach and the one-shot
/// features.
///
/// Uses the shared Dio client directly rather than [ApiService]'s wrappers:
/// those turn every failure into a bare message, and the AI screens need the
/// server's `code` to tell "out of free calls" from "the model is down".
class AiApi {
  AiApi({ApiService? api}) : _dio = (api ?? ApiService()).dio;

  final Dio _dio;

  /// Model calls can queue behind the gateway's premium lane.
  static const _aiTimeout = Duration(seconds: 120);

  Future<AiQuota> quota() async {
    final data = await _call(() => _dio.get('/ai/quota'));
    return AiQuota.fromJson(data);
  }

  /// Reports a finished rewarded ad. Returns the server's outcome
  /// (`granted`, `already_granted`, `daily_cap_reached`, `pending_verification`)
  /// and the allowance after it.
  Future<({String outcome, AiQuota? quota})> claimReward({
    required String rewardType,
    required String clientRewardId,
    String? adUnitId,
  }) async {
    try {
      final response = await _dio.post(
        '/ai/rewards/claim',
        data: {
          'reward_type': rewardType,
          'client_reward_id': clientRewardId,
          'ad_unit_id': ?adUnitId,
        },
      );
      return _rewardResult(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) return _rewardResult(e.response?.data);
      throw _toAiException(e);
    }
  }

  /// Spends one ad-earned PDF export; false when there is none.
  Future<bool> usePdfExport() async {
    try {
      await _dio.post('/ai/pdf-export/use');
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 402) return false;
      throw _toAiException(e);
    }
  }

  /// Asks the coach and yields the reply as it is written.
  Stream<ChatStreamEvent> streamChat(
    String message, {
    String? conversationId,
    Map<String, dynamic>? context,
  }) async* {
    final Response<ResponseBody> response;
    try {
      response = await _dio.post<ResponseBody>(
        '/ai-chat/message/stream',
        data: {
          'message': message,
          'conversation_id': ?conversationId,
          'context': ?context,
        },
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: _aiTimeout,
          headers: {'Accept': 'text/event-stream'},
        ),
      );
    } on DioException catch (e) {
      throw await _toAiExceptionFromStream(e);
    }

    String? event;
    final lines = response.data!.stream
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (final line in lines) {
      if (line.startsWith('event:')) {
        event = line.substring(6).trim();
        continue;
      }
      if (!line.startsWith('data:')) continue;

      final data = jsonDecode(line.substring(5).trim()) as Map<String, dynamic>;
      switch (event) {
        case 'start':
          yield ChatStarted(data['conversation_id'] as String? ?? '');
        case 'delta':
          yield ChatDelta(data['text'] as String? ?? '');
        case 'done':
          yield ChatDone(SendMessageResponse.fromJson(data));
          return;
        case 'error':
          throw AiException(
            data['code'] as String? ?? AiException.unavailable,
            data['detail'] as String? ?? 'The AI service is not answering.',
          );
      }
    }

    throw const AiException(
      AiException.unavailable,
      'The reply was cut off. Please try again.',
    );
  }

  Future<String> monthlySummary(Map<String, dynamic> context) async {
    final data = await _call(
      () => _dio.post(
        '/ai/monthly-summary',
        data: {'context': context},
        options: Options(receiveTimeout: _aiTimeout),
      ),
    );
    return data['text'] as String? ?? '';
  }

  Future<ReceiptReading> readReceipt({
    required String ocrText,
    required List<String> categories,
    String? currency,
    String? language,
  }) async {
    final data = await _call(
      () => _dio.post(
        '/ai/receipt',
        data: {
          'ocr_text': ocrText,
          'categories': categories,
          'currency': ?currency,
          'today': _today(),
          'language': ?language,
        },
        options: Options(receiveTimeout: _aiTimeout),
      ),
    );
    return ReceiptReading.fromJson(data);
  }

  Future<QuickAddDraft> quickAdd({
    required String text,
    required List<String> categories,
    required List<String> wallets,
    String? currency,
    String? language,
  }) async {
    final data = await _call(
      () => _dio.post(
        '/ai/quick-add',
        data: {
          'text': text,
          'categories': categories,
          'wallets': wallets,
          'currency': ?currency,
          'today': _today(),
          'language': ?language,
        },
        options: Options(receiveTimeout: _aiTimeout),
      ),
    );
    return QuickAddDraft.fromJson(data);
  }

  static String _today() {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${now.year}-${two(now.month)}-${two(now.day)}';
  }

  ({String outcome, AiQuota? quota}) _rewardResult(Object? data) {
    final map = data is Map<String, dynamic> ? data : const <String, dynamic>{};
    final quota = map['quota'];
    return (
      outcome: map['outcome'] as String? ?? 'unknown',
      quota: quota is Map<String, dynamic> ? AiQuota.fromJson(quota) : null,
    );
  }

  Future<Map<String, dynamic>> _call(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      final response = await request();
      final data = response.data;
      return data is Map<String, dynamic> ? data : const {};
    } on DioException catch (e) {
      throw _toAiException(e);
    }
  }

  AiException _toAiException(DioException e) {
    final response = e.response;
    if (response == null) {
      return const AiException(
        AiException.network,
        'Could not reach the server. Check your connection and try again.',
      );
    }

    final data = response.data;
    if (data is Map) {
      return AiException(
        data['code'] as String? ?? 'HTTP_${response.statusCode}',
        data['detail']?.toString() ?? 'Something went wrong.',
        statusCode: response.statusCode,
      );
    }
    return AiException(
      'HTTP_${response.statusCode}',
      'Something went wrong.',
      statusCode: response.statusCode,
    );
  }

  /// A failed streaming request carries its JSON error body as a stream.
  Future<AiException> _toAiExceptionFromStream(DioException e) async {
    final body = e.response?.data;
    if (body is ResponseBody) {
      try {
        final text = await utf8.decodeStream(body.stream.cast<List<int>>());
        final data = jsonDecode(text);
        if (data is Map) {
          return AiException(
            data['code'] as String? ?? 'HTTP_${e.response?.statusCode}',
            data['detail']?.toString() ?? 'Something went wrong.',
            statusCode: e.response?.statusCode,
          );
        }
      } catch (_) {
        // Fall through to the generic mapping.
      }
    }
    return _toAiException(e);
  }
}

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

/// One tool the coach wants the app to run.
class CoachToolCall {
  final String id;
  final String name;
  final Map<String, dynamic> args;
  const CoachToolCall(this.id, this.name, this.args);

  factory CoachToolCall.fromJson(Map<String, dynamic> json) => CoachToolCall(
    json['id'] as String? ?? '',
    json['name'] as String? ?? '',
    (json['args'] as Map?)?.cast<String, dynamic>() ?? const {},
  );
}

/// The coach needs the app to run [calls] before it can answer. Post the
/// results with [AiApi.streamChat]'s `toolResults` to carry on.
class ChatToolCalls extends ChatStreamEvent {
  final String conversationId;
  final List<CoachToolCall> calls;
  const ChatToolCalls(this.conversationId, this.calls);
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

/// A transaction sent with a voice entry, so "yesterday's rickshaw was 120"
/// can name the one it means.
class VoiceLogRecent {
  final String id;
  final String title;
  final double amount;
  final bool isIncome;
  final DateTime date;
  final String? category;
  final String? wallet;

  const VoiceLogRecent({
    required this.id,
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.date,
    this.category,
    this.wallet,
  });

  Map<String, dynamic> toJson() {
    String two(int n) => n.toString().padLeft(2, '0');
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'is_income': isIncome,
      'date':
          '${date.year}-${two(date.month)}-${two(date.day)} '
          '${two(date.hour)}:${two(date.minute)}',
      'category': ?category,
      'wallet': ?wallet,
    };
  }
}

enum VoiceLogOp { add, update, delete }

/// One thing the user asked for: a new transaction, a change, or a removal.
/// Fields left null are ones they did not mention.
class VoiceLogAction {
  final VoiceLogOp op;

  /// The recent transaction an update or delete is about.
  final String? ref;
  final String? title;
  final double? amount;
  final bool? isIncome;
  final DateTime? date;

  /// "HH:mm", only when a time was said.
  final String? time;
  final String? category;
  final String? wallet;
  final String? note;

  const VoiceLogAction({
    required this.op,
    this.ref,
    this.title,
    this.amount,
    this.isIncome,
    this.date,
    this.time,
    this.category,
    this.wallet,
    this.note,
  });

  static VoiceLogAction? fromJson(Map<String, dynamic> json) {
    final op = switch (json['op']) {
      'add' => VoiceLogOp.add,
      'update' => VoiceLogOp.update,
      'delete' => VoiceLogOp.delete,
      _ => null,
    };
    if (op == null) return null;
    return VoiceLogAction(
      op: op,
      ref: json['ref'] as String?,
      title: json['title'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      isIncome: json['is_income'] as bool?,
      date: DateTime.tryParse(json['date'] as String? ?? ''),
      time: json['time'] as String?,
      category: json['category'] as String?,
      wallet: json['wallet'] as String?,
      note: json['note'] as String?,
    );
  }
}

class VoiceLogReply {
  final List<VoiceLogAction> actions;

  /// What the AI could not settle on its own, such as which of two lunches.
  final String? message;

  const VoiceLogReply({required this.actions, this.message});

  factory VoiceLogReply.fromJson(Map<String, dynamic> json) => VoiceLogReply(
    actions: [
      for (final a in (json['actions'] as List?) ?? const [])
        if (a is Map<String, dynamic>) ?VoiceLogAction.fromJson(a),
    ],
    message: json['message'] as String?,
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
  ///
  /// Pass [toolResults] (call id to JSON result) instead of a [message] to
  /// carry on after a [ChatToolCalls]; that costs no request.
  Stream<ChatStreamEvent> streamChat(
    String? message, {
    String? conversationId,
    Map<String, dynamic>? context,
    Map<String, String>? toolResults,
  }) async* {
    final Response<ResponseBody> response;
    try {
      response = await _dio.post<ResponseBody>(
        '/ai-chat/message/stream',
        data: {
          'message': ?message,
          'conversation_id': ?conversationId,
          'context': ?context,
          'tools': true,
          if (toolResults != null)
            'tool_results': [
              for (final e in toolResults.entries)
                {'id': e.key, 'content': e.value},
            ],
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
        case 'tool':
          yield ChatToolCalls(data['conversation_id'] as String? ?? '', [
            for (final c in (data['calls'] as List? ?? const []))
              CoachToolCall.fromJson((c as Map).cast<String, dynamic>()),
          ]);
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

  /// What the user said, as transactions to add, change or remove. One call.
  Future<VoiceLogReply> voiceLog({
    required String text,
    required List<String> categories,
    required List<String> wallets,
    required List<VoiceLogRecent> recent,
    String? currency,
    String? language,
  }) async {
    final data = await _call(
      () => _dio.post(
        '/ai/voice-log',
        data: {
          'text': text,
          'categories': categories,
          'wallets': wallets,
          'recent': [for (final r in recent) r.toJson()],
          'currency': ?currency,
          'today': _today(),
          'language': ?language,
        },
        options: Options(receiveTimeout: _aiTimeout),
      ),
    );
    return VoiceLogReply.fromJson(data);
  }

  static String _today() {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${now.year}-${two(now.month)}-${two(now.day)}';
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

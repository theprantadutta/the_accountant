import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart' as db;
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/ai_assistant/providers/ai_quota_provider.dart'
    show aiApiProvider;
import 'package:the_accountant/features/ai_assistant/services/ai_api.dart';
import 'package:the_accountant/features/ai_assistant/services/coach_tool_runner.dart';
import 'package:the_accountant/features/ai_assistant/services/finance_context_builder.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/dashboard/providers/financial_data_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart'
    show transactionProvider;
import 'package:the_accountant/features/transactions/providers/transfer_provider.dart'
    show transferServiceProvider;
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

/// One thing the user said, worked out but not yet done.
///
/// [plan] is what the coach's own runner made of it: a preview to show and a
/// write to run on confirm, or why it cannot be done as said.
class VoiceDraft {
  VoiceDraft({required this.action, required this.plan})
    : included = plan.execute != null;

  final VoiceLogAction action;
  final CoachPlan plan;

  /// Whether Save will do it. Only drafts that can be done start included.
  bool included;

  bool get ready => plan.preview != null && plan.execute != null;

  /// Why it cannot be done, in the runner's words.
  String? get problem {
    final error = plan.error;
    if (error == null) return null;
    try {
      return (jsonDecode(error) as Map<String, dynamic>)['error'] as String?;
    } catch (_) {
      return error;
    }
  }
}

/// How to put back what a save did.
sealed class VoiceUndo {
  const VoiceUndo();
}

class _UndoAdd extends VoiceUndo {
  const _UndoAdd(this.id);
  final String id;
}

class _UndoUpdate extends VoiceUndo {
  const _UndoUpdate(this.before);
  final db.Transaction before;
}

class _UndoDelete extends VoiceUndo {
  const _UndoDelete(this.id);
  final String id;
}

/// What a save did, so the Today screen can offer Undo.
class VoiceSaveResult {
  const VoiceSaveResult({required this.saved, required this.undo});

  final int saved;
  final List<VoiceUndo> undo;
}

/// Saying transactions out loud: what was said goes to the AI with the
/// user's accounts, categories and recent transactions, and comes back as adds,
/// changes and removals.
///
/// Each one is planned by [CoachToolRunner], the same code the money coach
/// uses, so the preview is exactly what will happen and the write goes through
/// the notifier the add and edit screens use. Nothing is written until [save].
class VoiceLogService {
  VoiceLogService(this._read) : _runner = CoachToolRunner(_read);

  final ProviderReader _read;
  final CoachToolRunner _runner;

  /// How far back a spoken change can reach, and how many it is offered.
  static const _recentDays = 30;
  static const _recentCount = 60;

  /// Ask the AI what [text] means and plan each answer. One AI call.
  Future<(List<VoiceDraft>, String?)> interpret(String text) async {
    final categories = _read(categoryProvider);
    final names = {for (final c in categories.categories) c.id: c.name};
    final wallets = _read(walletProvider).wallets;
    final walletNames = {for (final w in wallets) w.id: w.name};

    final reply = await _read(aiApiProvider).voiceLog(
      text: text,
      categories: categories.selectable.map((c) => c.name).toList(),
      wallets: _read(selectableWalletsProvider).map((w) => w.name).toList(),
      recent: await _recent(names, walletNames),
      currency: _read(defaultCurrencyProvider),
      language: FinanceContextBuilder.languageOf(_read),
    );

    final drafts = <VoiceDraft>[];
    for (final action in reply.actions) {
      drafts.add(
        VoiceDraft(action: action, plan: await _runner.plan(_toolCall(action))),
      );
    }
    return (drafts, reply.message);
  }

  /// The transactions a spoken change or removal might mean: recent, and only
  /// the kinds the runner can change (not transfers or loans).
  Future<List<VoiceLogRecent>> _recent(
    Map<String, String> categories,
    Map<String, String> wallets,
  ) async {
    final since = DateTime.now().subtract(const Duration(days: _recentDays));
    final rows =
        (await _read(databaseProvider).getAllTransactions())
            .where(
              (t) =>
                  t.deletedAt == null &&
                  t.date.isAfter(since) &&
                  !TransactionPolicy.isTransfer(t) &&
                  !TransactionPolicy.isCreditOrDebt(t) &&
                  !TransactionPolicy.isSettlement(t),
            )
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    return [
      for (final t in rows.take(_recentCount))
        VoiceLogRecent(
          id: t.id,
          title: t.title,
          amount: t.amount / 100,
          isIncome: t.isIncome,
          date: t.date,
          category: categories[t.categoryId],
          wallet: wallets[t.walletId],
        ),
    ];
  }

  static CoachToolCall _toolCall(VoiceLogAction a) {
    String? day(DateTime? d) {
      if (d == null) return null;
      String two(int n) => n.toString().padLeft(2, '0');
      return '${d.year}-${two(d.month)}-${two(d.day)}';
    }

    final kind = a.isIncome == null
        ? null
        : a.isIncome!
        ? 'income'
        : 'expense';
    return switch (a.op) {
      VoiceLogOp.add => CoachToolCall('voice', 'add_transaction', {
        'amount': ?a.amount,
        'kind': kind ?? 'expense',
        'title': ?a.title,
        'category': ?a.category,
        'account': ?a.wallet,
        'date': ?day(a.date),
        'time': ?a.time,
        'notes': ?a.note,
      }),
      VoiceLogOp.update => CoachToolCall('voice', 'update_transaction', {
        'id': a.ref,
        'amount': ?a.amount,
        'kind': ?kind,
        'title': ?a.title,
        'category': ?a.category,
        'account': ?a.wallet,
        'date': ?day(a.date),
        'time': ?a.time,
        'notes': ?a.note,
      }),
      VoiceLogOp.delete => CoachToolCall('voice', 'delete_transaction', {
        'id': a.ref,
      }),
    };
  }

  /// Do every included draft, in order, and say how to put it all back.
  Future<VoiceSaveResult> save(List<VoiceDraft> drafts) async {
    final undo = <VoiceUndo>[];
    var saved = 0;
    for (final draft in drafts.where((d) => d.included && d.ready)) {
      // Read before the write, so Undo can put a change back as it was.
      final before = draft.action.ref == null
          ? null
          : await _read(
              databaseProvider,
            ).findTransactionById(draft.action.ref!);
      final answer = await draft.plan.execute!();
      final result = jsonDecode(answer) as Map<String, dynamic>;
      if (result['status'] != 'done') continue;
      saved++;
      switch (draft.action.op) {
        case VoiceLogOp.add:
          if (result['id'] case final String id) undo.add(_UndoAdd(id));
        case VoiceLogOp.update:
          if (before != null) undo.add(_UndoUpdate(before));
        case VoiceLogOp.delete:
          undo.add(_UndoDelete(draft.action.ref!));
      }
    }
    return VoiceSaveResult(saved: saved, undo: undo);
  }

  /// Put back what [save] did, newest first.
  Future<void> undo(VoiceSaveResult result) async {
    final transactions = _read(transactionProvider.notifier);
    for (final step in result.undo.reversed) {
      switch (step) {
        case _UndoAdd(:final id):
          await transactions.deleteTransaction(id);
        case _UndoUpdate(:final before):
          await transactions.updateTransaction(
            id: before.id,
            amount: before.amount,
            isIncome: before.isIncome,
            title: before.title,
            categoryId: before.categoryId,
            walletId: before.walletId,
            date: before.date,
            notes: before.notes ?? '',
          );
        case _UndoDelete(:final id):
          await _read(transferServiceProvider).restoreTransaction(id);
      }
    }
    await transactions.loadTransactions(silent: true);
    await _read(walletProvider.notifier).loadWallets();
    // A restore goes around the notifier, so the Today totals are told too.
    await _read(financialDataProvider.notifier).refreshData();
  }
}

final voiceLogServiceProvider = Provider<VoiceLogService>(
  (ref) => VoiceLogService(ref.read),
);

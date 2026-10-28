import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/ai_assistant/providers/ai_quota_provider.dart';
import 'package:the_accountant/features/ai_assistant/services/ai_api.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/voice_log/services/voice_log_service.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

import '../helpers/test_database.dart';

/// Saying transactions: what reaches the AI, what comes back as cards, and
/// that Save does exactly what the cards showed and Undo puts it all back.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late _FakeAi ai;
  late String bkash;
  late String food;
  late String tea;
  late String bus;

  final now = DateTime.now();
  final yesterday = DateTime(now.year, now.month, now.day - 1, 17);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    ai = _FakeAi();
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        aiApiProvider.overrideWithValue(ai),
      ],
    );
    bkash = await seedWallet(db, name: 'Bkash', openingBalance: 500000);
    food = await seedCategory(db, name: 'Food');
    await seedCategory(db, name: 'Transport');
    tea = await seedTransaction(
      db,
      walletId: bkash,
      categoryId: food,
      amount: 2000,
      title: 'Tea',
      date: yesterday,
    );
    bus = await seedTransaction(
      db,
      walletId: bkash,
      categoryId: food,
      amount: 5000,
      title: 'Bus',
      date: yesterday,
    );
    // A transfer cannot be changed by voice, so it is not offered.
    await seedTransaction(
      db,
      walletId: bkash,
      amount: 70000,
      title: 'To savings',
      transactionType: 'transfer',
      date: yesterday,
    );
    await container.read(categoryProvider.notifier).loadCategories();
    await container.read(walletProvider.notifier).loadWallets();
    await container.read(transactionProvider.notifier).loadTransactions();
  });

  tearDown(() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    container.dispose();
    await db.close();
  });

  VoiceLogService service() => container.read(voiceLogServiceProvider);

  test('recent transactions go to the AI by id, without transfers', () async {
    ai.reply = const VoiceLogReply(actions: [], message: 'Which one?');

    final (drafts, message) = await service().interpret('change the tea');

    expect(drafts, isEmpty);
    expect(message, 'Which one?');
    final sent = {for (final r in ai.lastRecent!) r.id: r.title};
    expect(sent[tea], 'Tea');
    expect(sent.values, isNot(contains('To savings')));
    expect(ai.lastCategories, containsAll(['Food', 'Transport']));
  });

  test('adds, changes and removals become cards; no amount waits', () async {
    ai.reply = VoiceLogReply(
      actions: [
        const VoiceLogAction(
          op: VoiceLogOp.add,
          title: 'Lunch',
          amount: 250,
          category: 'Food',
          wallet: 'Bkash',
          time: '13:30',
        ),
        VoiceLogAction(op: VoiceLogOp.update, ref: tea, amount: 30),
        VoiceLogAction(op: VoiceLogOp.delete, ref: bus),
        const VoiceLogAction(op: VoiceLogOp.add, title: 'Rickshaw'),
      ],
    );

    final (drafts, _) = await service().interpret('lunch 250 ...');

    expect(drafts.map((d) => d.ready), [true, true, true, false]);
    expect(drafts.map((d) => d.included), [true, true, true, false]);
    final lunch = drafts[0].plan.preview!;
    expect(
      (lunch.title, lunch.amount, lunch.category),
      ('Lunch', 25000, 'Food'),
    );
    expect((lunch.date.hour, lunch.date.minute), (13, 30));
    expect(drafts[1].plan.preview!.changes.keys, ['amount']);
    expect(drafts[3].problem, isNotNull);
  });

  test('save does what the cards showed, and undo puts it back', () async {
    ai.reply = VoiceLogReply(
      actions: [
        const VoiceLogAction(
          op: VoiceLogOp.add,
          title: 'Lunch',
          amount: 250,
          category: 'Food',
        ),
        VoiceLogAction(op: VoiceLogOp.update, ref: tea, amount: 30),
        VoiceLogAction(op: VoiceLogOp.delete, ref: bus),
      ],
    );
    final (drafts, _) = await service().interpret('...');

    final result = await service().save(drafts);

    expect(result.saved, 3);
    final after = await db.getAllTransactions();
    expect(
      after.where((t) => t.title == 'Lunch' && t.amount == 25000),
      hasLength(1),
    );
    expect((await db.findTransactionById(tea))!.amount, 3000);
    expect((await db.findTransactionById(bus))!.deletedAt, isNotNull);

    await service().undo(result);

    final undone = (await db.getAllTransactions()).where(
      (t) => t.title == 'Lunch' && t.deletedAt == null,
    );
    expect(undone, isEmpty);
    expect((await db.findTransactionById(tea))!.amount, 2000);
    expect((await db.findTransactionById(bus))!.deletedAt, isNull);
  });

  test('a card unticked is not saved', () async {
    ai.reply = VoiceLogReply(
      actions: [VoiceLogAction(op: VoiceLogOp.delete, ref: bus)],
    );
    final (drafts, _) = await service().interpret('...');
    drafts.single.included = false;

    final result = await service().save(drafts);

    expect(result.saved, 0);
    expect((await db.findTransactionById(bus))!.deletedAt, isNull);
  });
}

class _FakeAi implements AiApi {
  VoiceLogReply reply = const VoiceLogReply(actions: []);
  List<VoiceLogRecent>? lastRecent;
  List<String>? lastCategories;

  @override
  Future<VoiceLogReply> voiceLog({
    required String text,
    required List<String> categories,
    required List<String> wallets,
    required List<VoiceLogRecent> recent,
    String? currency,
    String? language,
  }) async {
    lastRecent = recent;
    lastCategories = categories;
    return reply;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

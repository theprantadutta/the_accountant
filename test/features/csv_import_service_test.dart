import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/import/domain/column_mapping.dart';
import 'package:the_accountant/features/import/domain/csv_reader.dart';
import 'package:the_accountant/features/import/domain/import_preview.dart';
import 'package:the_accountant/features/import/services/csv_import_service.dart';
import 'package:the_accountant/features/import/services/import_template_service.dart';

import '../helpers/test_database.dart';

/// Bringing a statement into the database.
///
/// The failure everybody has with this feature is importing last month's file
/// alongside this month's and silently doubling the overlap — and with it the
/// account balance. Most of what follows is about that, and about the rows a
/// file cannot supply being reported rather than dropped.
void main() {
  late AppDatabase db;
  late CsvImportService service;
  late String wallet;

  setUp(() async {
    db = openTestDatabase();
    await db.ensureSystemCategoriesExist();
    service = CsvImportService(db);
    wallet = await seedWallet(db, name: 'Current', openingBalance: 100000);
  });

  tearDown(() => db.close());

  ImportPreview previewOf(String csv) {
    final document = CsvReader.read(Uint8List.fromList(utf8.encode(csv)));
    return ImportReader.read(document, ColumnMapping.guess(document));
  }

  const twoRows =
      'Date,Description,Amount\n'
      '2026-01-01,Groceries,-45.00\n'
      '2026-01-02,Salary,2000.00\n';

  group('what lands in the database', () {
    test('one transaction per usable row', () async {
      final result = await service.import(
        preview: previewOf(twoRows),
        walletId: wallet,
      );

      expect(result.imported, 2);
      expect(await db.getAllTransactions(), hasLength(2));
    });

    test(
      'the direction lives in isIncome, and the amount is unsigned',
      () async {
        await service.import(preview: previewOf(twoRows), walletId: wallet);

        final rows = await db.getAllTransactions()
          ..sort((a, b) => a.date.compareTo(b.date));
        expect(rows.first.amount, 4500);
        expect(rows.first.isIncome, isFalse);
        expect(rows.last.amount, 200000);
        expect(rows.last.isIncome, isTrue);
      },
    );

    test('the balance is recomputed, not nudged', () async {
      await service.import(preview: previewOf(twoRows), walletId: wallet);

      expect(
        (await db.findWalletById(wallet))!.balance,
        100000 - 4500 + 200000,
      );
    });

    test('imported rows are queued to be uploaded', () async {
      await service.import(preview: previewOf(twoRows), walletId: wallet);

      expect(
        (await db.getAllTransactions()).map((t) => t.syncStatus),
        everyElement(SyncStatus.pendingCreate),
      );
    });

    test('a row the file could not supply is counted, not imported', () async {
      final result = await service.import(
        preview: previewOf(
          'Date,Description,Amount\n'
          '2026-01-01,Fine,10.00\n'
          'rubbish,Broken,10.00\n',
        ),
        walletId: wallet,
      );

      expect(result.imported, 1);
      expect(result.unusable, 1);
    });

    test('a file with nothing usable changes nothing', () async {
      final result = await service.import(
        preview: previewOf('Foo,Bar\nx,y\n'),
        walletId: wallet,
      );

      expect(result.imported, 0);
      expect(await db.getAllTransactions(), isEmpty);
      expect((await db.findWalletById(wallet))!.balance, 100000);
    });
  });

  group('importing the same statement twice', () {
    test('the overlap is skipped rather than doubled', () async {
      await service.import(preview: previewOf(twoRows), walletId: wallet);
      final second = await service.import(
        preview: previewOf(twoRows),
        walletId: wallet,
      );

      expect(second.imported, 0);
      expect(second.skippedAsDuplicates, 2);
      expect(await db.getAllTransactions(), hasLength(2));
    });

    test('the balance does not move on the second run', () async {
      await service.import(preview: previewOf(twoRows), walletId: wallet);
      final after = (await db.findWalletById(wallet))!.balance;

      await service.import(preview: previewOf(twoRows), walletId: wallet);

      expect((await db.findWalletById(wallet))!.balance, after);
    });

    test('an overlapping file still brings in what is new', () async {
      await service.import(preview: previewOf(twoRows), walletId: wallet);

      final result = await service.import(
        preview: previewOf(
          'Date,Description,Amount\n'
          '2026-01-02,Salary,2000.00\n'
          '2026-01-03,Rent,-800.00\n',
        ),
        walletId: wallet,
      );

      expect(result.imported, 1);
      expect(result.skippedAsDuplicates, 1);
      expect(await db.getAllTransactions(), hasLength(3));
    });

    /// Two coffees are two coffees.
    ///
    /// Duplicate checking used to ask whether a signature had been seen, and
    /// seeded that question with the file's own rows as it read them. So a real
    /// statement holding two identical payments on one day imported one — even
    /// into an empty ledger, where there was nothing for the second to be a
    /// duplicate of. This test asserted that behaviour while its own name said
    /// the opposite, which was the signal that the reasoning was wrong.
    ///
    /// It counts multiplicities now: import the difference between how many the
    /// file says happened and how many are already recorded.
    test('two identical rows in one file are not both dropped', () async {
      final result = await service.import(
        preview: previewOf(
          'Date,Description,Amount\n'
          '2026-01-01,Coffee,-3.50\n'
          '2026-01-01,Coffee,-3.50\n',
        ),
        walletId: wallet,
      );

      expect(
        result.imported,
        2,
        reason: 'nothing was on file, so neither row can be a duplicate of '
            'anything — two real purchases were being collapsed into one',
      );
      expect(result.skippedAsDuplicates, 0);
    });

    test('re-importing that same file adds nothing', () async {
      const twoCoffees =
          'Date,Description,Amount\n'
          '2026-01-01,Coffee,-3.50\n'
          '2026-01-01,Coffee,-3.50\n';
      await service.import(preview: previewOf(twoCoffees), walletId: wallet);

      final second = await service.import(
        preview: previewOf(twoCoffees),
        walletId: wallet,
      );

      expect(second.imported, 0);
      expect(
        second.skippedAsDuplicates,
        2,
        reason: 'two on file and two in the file is an overlap, not a pair of '
            'new purchases — which is what the check exists for',
      );
      expect(await db.getAllTransactions(), hasLength(2));
    });

    test('a third repeat is the one that is new', () async {
      await service.import(
        preview: previewOf(
          'Date,Description,Amount\n'
          '2026-01-01,Coffee,-3.50\n'
          '2026-01-01,Coffee,-3.50\n',
        ),
        walletId: wallet,
      );

      final result = await service.import(
        preview: previewOf(
          'Date,Description,Amount\n'
          '2026-01-01,Coffee,-3.50\n'
          '2026-01-01,Coffee,-3.50\n'
          '2026-01-01,Coffee,-3.50\n',
        ),
        walletId: wallet,
      );

      expect(result.imported, 1);
      expect(result.skippedAsDuplicates, 2);
      expect(await db.getAllTransactions(), hasLength(3));
    });

    test('duplicate checking can be turned off', () async {
      await service.import(preview: previewOf(twoRows), walletId: wallet);

      final second = await service.import(
        preview: previewOf(twoRows),
        walletId: wallet,
        skipDuplicates: false,
      );

      expect(second.imported, 2);
      expect(await db.getAllTransactions(), hasLength(4));
    });

    test('the same amount on a different day is not a duplicate', () async {
      await service.import(preview: previewOf(twoRows), walletId: wallet);

      final result = await service.import(
        preview: previewOf(
          'Date,Description,Amount\n2026-02-01,Groceries,-45.00\n',
        ),
        walletId: wallet,
      );

      expect(result.imported, 1);
    });
  });

  group('categories the file names', () {
    test('an existing one is matched, whatever its case', () async {
      final id = await seedCategory(db, name: 'Groceries');

      await service.import(
        preview: previewOf(
          'Date,Description,Amount,Category\n'
          '2026-01-01,Shop,-45.00,groceries\n',
        ),
        walletId: wallet,
      );

      expect((await db.getAllTransactions()).single.categoryId, id);
    });

    test('a new one is created, and reported', () async {
      final result = await service.import(
        preview: previewOf(
          'Date,Description,Amount,Category\n'
          '2026-01-01,Shop,-45.00,Hardware\n',
        ),
        walletId: wallet,
      );

      expect(result.createdCategories, ['Hardware']);
      final created = (await db.getAllCategories()).firstWhere(
        (c) => c.name == 'Hardware',
      );
      expect(created.syncStatus, SyncStatus.pendingCreate);
    });

    test('one name mentioned twice makes one category', () async {
      await service.import(
        preview: previewOf(
          'Date,Description,Amount,Category\n'
          '2026-01-01,A,-1.00,Hardware\n'
          '2026-01-02,B,-2.00,hardware\n',
        ),
        walletId: wallet,
      );

      expect(
        (await db.getAllCategories()).where((c) => c.name == 'Hardware'),
        hasLength(1),
      );
    });

    test('creation can be refused, leaving the rows uncategorised', () async {
      final result = await service.import(
        preview: previewOf(
          'Date,Description,Amount,Category\n'
          '2026-01-01,Shop,-45.00,Hardware\n',
        ),
        walletId: wallet,
        createMissingCategories: false,
      );

      expect(result.imported, 1);
      expect(result.createdCategories, isEmpty);
      expect((await db.getAllTransactions()).single.categoryId, isNull);
    });
  });

  group('accounts the file names', () {
    test('an existing one takes its own rows', () async {
      final savings = await seedWallet(db, name: 'Savings');

      await service.import(
        preview: previewOf(
          'Date,Description,Amount,Account\n'
          '2026-01-01,A,-1.00,Savings\n'
          '2026-01-02,B,-2.00,Current\n',
        ),
        walletId: wallet,
      );

      final rows = await db.getAllTransactions()
        ..sort((a, b) => a.date.compareTo(b.date));
      expect(rows.first.walletId, savings);
      expect(rows.last.walletId, wallet);
    });

    test('an unknown name goes to the chosen account, and is reported', () async {
      final result = await service.import(
        preview: previewOf(
          'Date,Description,Amount,Account\n'
          '2026-01-01,A,-1.00,Some Other Bank\n',
        ),
        walletId: wallet,
      );

      expect(result.unmatchedAccounts, ['Some Other Bank']);
      expect((await db.getAllTransactions()).single.walletId, wallet);
      expect(
        await db.getAllWallets(),
        hasLength(1),
        reason:
            'an account has a currency and an opening balance that a CSV does '
            'not know, so inventing one silently would make a total wrong for '
            'reasons nobody could find',
      );
    });

    test('every account that received rows has its balance redone', () async {
      final savings = await seedWallet(
        db,
        name: 'Savings',
        openingBalance: 5000,
      );

      await service.import(
        preview: previewOf(
          'Date,Description,Amount,Account\n'
          '2026-01-01,A,-1000,Savings\n'
          '2026-01-02,B,-2000,Current\n',
        ),
        walletId: wallet,
      );

      expect((await db.findWalletById(savings))!.balance, 5000 - 100000);
      expect((await db.findWalletById(wallet))!.balance, 100000 - 200000);
    });
  });

  group('remembering a bank', () {
    late ImportTemplateService templates;

    setUp(() => templates = ImportTemplateService(db));

    CsvDocument documentOf(String csv) =>
        CsvReader.read(Uint8List.fromList(utf8.encode(csv)));

    test('a saved mapping comes back as it went in', () async {
      final document = documentOf(twoRows);
      final mapping = ColumnMapping.guess(document);

      final saved = await templates.save(
        name: 'My bank',
        document: document,
        mapping: mapping,
        defaultWalletId: wallet,
      );

      expect(saved.name, 'My bank');
      expect(saved.defaultWalletId, wallet);
      expect(ImportTemplateService.mappingOf(saved).columns, mapping.columns);
    });

    test('the next file with the same columns is recognised', () async {
      final document = documentOf(twoRows);
      await templates.save(
        name: 'My bank',
        document: document,
        mapping: ColumnMapping.guess(document),
      );

      final next = documentOf(
        'Date,Description,Amount\n2026-03-01,Something else,-9.99\n',
      );

      expect((await templates.matching(next))?.name, 'My bank');
    });

    test(
      'a change of case in the headings does not lose the template',
      () async {
        final document = documentOf(twoRows);
        await templates.save(
          name: 'My bank',
          document: document,
          mapping: ColumnMapping.guess(document),
        );

        final shouty = documentOf(
          'DATE,DESCRIPTION,AMOUNT\n2026-03-01,X,-1.00\n',
        );

        expect(await templates.matching(shouty), isNotNull);
      },
    );

    test('a file with different columns is not matched', () async {
      final document = documentOf(twoRows);
      await templates.save(
        name: 'My bank',
        document: document,
        mapping: ColumnMapping.guess(document),
      );

      final other = documentOf(
        'Date,Payee,Money In,Money Out\n2026-03-01,X,,1.00\n',
      );

      expect(await templates.matching(other), isNull);
    });

    test(
      'a file with no header matches nothing rather than everything',
      () async {
        final document = documentOf(twoRows);
        await templates.save(
          name: 'My bank',
          document: document,
          mapping: ColumnMapping.guess(document),
        );

        expect(
          await templates.matching(documentOf('2026-03-01,X,-1.00\n')),
          isNull,
        );
      },
    );

    test('saving over one keeps a single template, not two', () async {
      final document = documentOf(twoRows);
      final first = await templates.save(
        name: 'My bank',
        document: document,
        mapping: ColumnMapping.guess(document),
      );

      await templates.save(
        id: first.id,
        name: 'My bank, renamed',
        document: document,
        mapping: ColumnMapping.guess(document),
      );

      final all = await templates.all();
      expect(all, hasLength(1));
      expect(all.single.name, 'My bank, renamed');
    });

    test('the most recently used is offered first', () async {
      final document = documentOf(twoRows);
      final older = await templates.save(
        name: 'Older',
        document: document,
        mapping: ColumnMapping.guess(document),
      );
      await templates.save(
        name: 'Newer',
        document: documentOf('Date,Payee,Amount\n2026-01-01,X,-1.00\n'),
        mapping: ColumnMapping.guess(document),
      );

      await templates.markUsed(older.id);

      expect((await templates.all()).first.name, 'Older');
    });

    test('one can be thrown away', () async {
      final document = documentOf(twoRows);
      final saved = await templates.save(
        name: 'My bank',
        document: document,
        mapping: ColumnMapping.guess(document),
      );

      await templates.delete(saved.id);

      expect(await templates.all(), isEmpty);
    });
  });
}

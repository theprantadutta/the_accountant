import 'package:drift/drift.dart' show Value;
import 'package:the_accountant/core/services/wallet_balance_service.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/import/domain/import_preview.dart';
import 'package:uuid/uuid.dart';

/// What an import did, in enough detail to be shown rather than summarised.
class ImportResult {
  const ImportResult({
    required this.imported,
    this.skippedAsDuplicates = 0,
    this.unusable = 0,
    this.createdCategories = const [],
    this.unmatchedAccounts = const [],
  });

  final int imported;

  /// Rows that already existed, matched on date, amount and description.
  final int skippedAsDuplicates;

  /// Rows the file itself could not supply — a bad date, a missing amount.
  final int unusable;

  /// Categories that did not exist and were made.
  final List<String> createdCategories;

  /// Account names in the file with nothing here to match them, which
  /// therefore went to the account the user chose.
  final List<String> unmatchedAccounts;
}

/// Brings a read statement into the database.
///
/// Entirely client-side, and deliberately so. There is a bulk-create endpoint
/// on the server, but routing an import through it would double-count every
/// balance: the endpoint mutates wallet balances itself, while in the sync
/// contract the balance is the client's to compute. It also validates only the
/// wallet, so a bad category reference makes it drop rows silently or answer
/// 500. Writing locally and letting the ordinary sync push the rows up is both
/// simpler and correct.
class CsvImportService {
  CsvImportService(this._db);

  final AppDatabase _db;

  static const _uuid = Uuid();

  Future<ImportResult> import({
    required ImportPreview preview,
    required String walletId,
    bool createMissingCategories = true,
    bool skipDuplicates = true,
  }) async {
    final rows = preview.usable.toList();
    if (rows.isEmpty) {
      return ImportResult(imported: 0, unusable: preview.unusableCount);
    }

    final categories = await _db.getAllCategories();
    final wallets = await _db.getAllWallets();

    final categoriesByName = {
      for (final category in categories)
        if (category.deletedAt == null) _key(category.name): category.id,
    };
    final walletsByName = {
      for (final wallet in wallets)
        if (!wallet.isArchived) _key(wallet.name): wallet.id,
    };

    // How many rows already on file carry each signature. Counts, not a set:
    // see `_existingFingerprints`.
    final onFile = skipDuplicates
        ? await _existingFingerprints()
        : <String, int>{};

    final createdCategories = <String>[];
    final unmatchedAccounts = <String>{};
    var imported = 0;
    var duplicates = 0;

    final touchedWallets = <String>{};

    await _db.transaction(() async {
      for (final row in rows) {
        final destination = _resolveWallet(
          row.accountName,
          walletsByName,
          walletId,
          unmatchedAccounts,
        );

        final fingerprint = _fingerprint(
          walletId: destination,
          date: row.date!,
          amountCents: row.amountCents!,
          title: row.title,
        );
        // Import the difference between what the file says happened and what
        // is already recorded, rather than one row per distinct signature.
        // Membership alone treated two real coffees of the same price on the
        // same day as one purchase — even on a first import into an empty
        // ledger, where there was nothing to be a duplicate of.
        if (skipDuplicates) {
          final remaining = onFile[fingerprint] ?? 0;
          if (remaining > 0) {
            onFile[fingerprint] = remaining - 1;
            duplicates++;
            continue;
          }
        }

        final categoryId = await _resolveCategory(
          row,
          categoriesByName,
          createMissingCategories,
          createdCategories,
        );

        final now = DateTime.now();
        await _db.addTransaction(
          TransactionsCompanion.insert(
            id: _uuid.v4(),
            // Stored unsigned; the direction lives in isIncome, the way every
            // other transaction in this app records it.
            amount: row.amountCents!.abs(),
            title: Value(row.title),
            notes: Value(row.notes),
            date: row.date!,
            isIncome: Value(row.isIncome),
            categoryId: Value(categoryId),
            walletId: destination,
            isPaid: const Value(true),
            syncStatus: const Value(SyncStatus.pendingCreate),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
        touchedWallets.add(destination);
        imported++;
      }
    });

    // Recomputed rather than nudged by the total just added, for the same
    // reason every other write in this app recomputes: a blind delta cannot
    // tell whether it has already been applied.
    final balances = WalletBalanceService(_db);
    for (final id in touchedWallets) {
      await balances.updateWalletBalance(id);
    }

    return ImportResult(
      imported: imported,
      skippedAsDuplicates: duplicates,
      unusable: preview.unusableCount,
      createdCategories: createdCategories,
      unmatchedAccounts: unmatchedAccounts.toList()..sort(),
    );
  }

  /// Which account a row belongs in.
  ///
  /// A name in the file is matched against the accounts that exist. An account
  /// is never created from a statement: an account has a currency and an
  /// opening balance, neither of which a CSV knows, and inventing one silently
  /// is how a total ends up wrong for reasons nobody can find. The row goes to
  /// the chosen account instead, and the unmatched name is reported.
  String _resolveWallet(
    String? name,
    Map<String, String> walletsByName,
    String fallback,
    Set<String> unmatched,
  ) {
    if (name == null || name.isEmpty) return fallback;
    final match = walletsByName[_key(name)];
    if (match != null) return match;
    unmatched.add(name);
    return fallback;
  }

  Future<String?> _resolveCategory(
    ImportRow row,
    Map<String, String> categoriesByName,
    bool createMissing,
    List<String> created,
  ) async {
    final name = row.categoryName;
    if (name == null || name.isEmpty) return null;

    final existing = categoriesByName[_key(name)];
    if (existing != null) return existing;
    if (!createMissing) return null;

    final id = _uuid.v4();
    final now = DateTime.now();
    await _db.addCategory(
      CategoriesCompanion.insert(
        id: id,
        name: name,
        isIncome: Value(row.isIncome),
        syncStatus: const Value(SyncStatus.pendingCreate),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    categoriesByName[_key(name)] = id;
    created.add(name);
    return id;
  }

  /// How many rows already on file carry each signature.
  ///
  /// Re-importing last month's statement alongside this month's is the normal
  /// way to use a feature like this, and the overlap between the two is
  /// entirely predictable. Doubling those transactions — and so the balance —
  /// is worth going to some trouble to avoid.
  ///
  /// A count rather than a set, because the question is how many of a thing
  /// happened, not whether it happened at all. Two coffees at the same price on
  /// the same day are two purchases; a set said one of them was a duplicate of
  /// the other and dropped it, even importing into an empty ledger where there
  /// was nothing for it to duplicate. Matching multiplicities keeps a re-import
  /// safe — two on file and two in the file imports none — which was the actual
  /// goal all along.
  Future<Map<String, int>> _existingFingerprints() async {
    final rows = await _db.getAllTransactions();
    final counts = <String, int>{};
    for (final row in rows) {
      if (row.deletedAt != null) continue;
      final key = _fingerprint(
        walletId: row.walletId,
        date: row.date,
        amountCents: row.isIncome ? row.amount : -row.amount,
        title: row.title,
      );
      counts[key] = (counts[key] ?? 0) + 1;
    }
    return counts;
  }

  /// What makes two rows the same transaction.
  ///
  /// The day rather than the timestamp, because a statement re-exported later
  /// often carries a different posting time for the same payment.
  static String _fingerprint({
    required String walletId,
    required DateTime date,
    required int amountCents,
    required String title,
  }) => [
    walletId,
    '${date.year}-${date.month}-${date.day}',
    amountCents,
    _key(title),
  ].join('|');

  static String _key(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
}

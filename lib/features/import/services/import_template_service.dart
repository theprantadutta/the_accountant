import 'package:drift/drift.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/import/domain/column_mapping.dart';
import 'package:the_accountant/features/import/domain/csv_reader.dart';
import 'package:uuid/uuid.dart';

/// Remembering how a particular bank writes its statements.
///
/// This is the part Cashew does not have: it asks for the whole mapping every
/// time. Here the answer is saved under a name, and the next file with the same
/// columns is recognised on sight.
class ImportTemplateService {
  ImportTemplateService(this._db);

  final AppDatabase _db;

  static const _uuid = Uuid();

  Future<List<ImportTemplate>> all() async {
    final rows = await _db.select(_db.importTemplates).get();
    rows.sort((a, b) {
      final left = a.lastUsedAt ?? a.createdAt;
      final right = b.lastUsedAt ?? b.createdAt;
      return right.compareTo(left);
    });
    return rows;
  }

  /// The template made for a file with these columns, if there is one.
  Future<ImportTemplate?> matching(CsvDocument document) async {
    final signature = signatureOf(document);
    if (signature.isEmpty) return null;
    final templates = await all();
    for (final template in templates) {
      if (template.columnSignature == signature) return template;
    }
    return null;
  }

  Future<ImportTemplate> save({
    String? id,
    required String name,
    required CsvDocument document,
    required ColumnMapping mapping,
    String? defaultWalletId,
  }) async {
    final now = DateTime.now();
    final templateId = id ?? _uuid.v4();

    await _db
        .into(_db.importTemplates)
        .insertOnConflictUpdate(
          ImportTemplatesCompanion.insert(
            id: templateId,
            name: name,
            delimiter: Value(document.delimiter),
            hasHeader: Value(document.hasHeader),
            mapping: mapping.encode(),
            columnSignature: Value(signatureOf(document)),
            defaultWalletId: Value(defaultWalletId),
            createdAt: Value(now),
            updatedAt: Value(now),
            lastUsedAt: Value(now),
          ),
        );

    return (await (_db.select(
      _db.importTemplates,
    )..where((t) => t.id.equals(templateId))).getSingle());
  }

  Future<void> delete(String id) async {
    await (_db.delete(_db.importTemplates)..where((t) => t.id.equals(id))).go();
  }

  Future<void> markUsed(String id) async {
    await (_db.update(_db.importTemplates)..where((t) => t.id.equals(id)))
        .write(ImportTemplatesCompanion(lastUsedAt: Value(DateTime.now())));
  }

  static ColumnMapping mappingOf(ImportTemplate template) =>
      ColumnMapping.decode(template.mapping);

  /// A fingerprint of a file's column titles.
  ///
  /// Order matters and case does not, because a bank changing `DATE` to `Date`
  /// between exports should not cost the user their saved mapping, whereas a
  /// bank moving the amount column absolutely should.
  static String signatureOf(CsvDocument document) {
    if (!document.hasHeader) return '';
    return document.header
        .map((h) => h.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' '))
        .join('|');
  }
}

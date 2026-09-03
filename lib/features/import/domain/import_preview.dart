import 'package:the_accountant/features/import/domain/column_mapping.dart';
import 'package:the_accountant/features/import/domain/csv_reader.dart';
import 'package:the_accountant/features/import/domain/import_values.dart';

/// One line of the file, read through a mapping.
///
/// A row that cannot be read carries the reason rather than being dropped. An
/// import that silently skips lines is how somebody ends up believing their
/// records are complete when a tenth of them never arrived.
class ImportRow {
  const ImportRow({
    required this.lineNumber,
    this.date,
    this.amountCents,
    this.title = '',
    this.categoryName,
    this.accountName,
    this.notes,
    this.problem,
  });

  /// Line in the file, counting the header, so a complaint can be looked up.
  final int lineNumber;

  final DateTime? date;

  /// Signed minor units: negative is money out.
  final int? amountCents;

  final String title;
  final String? categoryName;
  final String? accountName;
  final String? notes;

  /// Why this row cannot be imported, or null when it can.
  final String? problem;

  bool get isUsable => problem == null;

  bool get isIncome => (amountCents ?? 0) > 0;
}

/// Everything a file would bring in, before it brings any of it in.
class ImportPreview {
  const ImportPreview({required this.rows});

  final List<ImportRow> rows;

  Iterable<ImportRow> get usable => rows.where((r) => r.isUsable);
  Iterable<ImportRow> get unusable => rows.where((r) => !r.isUsable);

  int get usableCount => usable.length;
  int get unusableCount => unusable.length;

  int get incomeCents =>
      usable.where((r) => r.isIncome).fold(0, (sum, r) => sum + r.amountCents!);

  int get expenseCents => usable
      .where((r) => !r.isIncome)
      .fold(0, (sum, r) => sum + r.amountCents!.abs());

  /// The names the file mentions that the app may not have yet.
  Set<String> get categoryNames => {
    for (final row in usable)
      if ((row.categoryName ?? '').isNotEmpty) row.categoryName!,
  };

  Set<String> get accountNames => {
    for (final row in usable)
      if ((row.accountName ?? '').isNotEmpty) row.accountName!,
  };

  DateTime? get earliest => usable.isEmpty
      ? null
      : usable.map((r) => r.date!).reduce((a, b) => a.isBefore(b) ? a : b);

  DateTime? get latest => usable.isEmpty
      ? null
      : usable.map((r) => r.date!).reduce((a, b) => a.isAfter(b) ? a : b);
}

/// Turns a file plus a mapping into rows, without touching the database.
///
/// Kept separate from the import itself so the screen can show exactly what
/// will happen — including which lines will be refused and why — before the
/// user agrees to it.
class ImportReader {
  const ImportReader._();

  static ImportPreview read(CsvDocument document, ColumnMapping mapping) {
    if (!mapping.isUsable) return const ImportPreview(rows: []);

    final body = document.body;
    final firstLine = document.hasHeader ? 2 : 1;

    return ImportPreview(
      rows: [
        for (var i = 0; i < body.length; i++)
          _readRow(body[i], mapping, firstLine + i),
      ],
    );
  }

  static ImportRow _readRow(
    List<String> row,
    ColumnMapping mapping,
    int lineNumber,
  ) {
    String at(ImportField field) {
      final index = mapping.indexOf(field);
      return index == null ? '' : CsvDocument.cell(row, index);
    }

    final rawDate = at(ImportField.date);
    final date = mapping.dateFormat == null
        ? null
        : ImportValues.parseDate(rawDate, mapping.dateFormat!);
    if (date == null) {
      return ImportRow(
        lineNumber: lineNumber,
        problem: rawDate.isEmpty
            ? 'No date'
            : 'The date "$rawDate" does not match '
                  '${mapping.dateFormat ?? 'any known format'}',
      );
    }

    final amount = _readAmount(at, mapping);
    if (amount == null) {
      return ImportRow(
        lineNumber: lineNumber,
        date: date,
        problem: 'No amount',
      );
    }

    final notes = at(ImportField.notes);
    final category = at(ImportField.category);
    final account = at(ImportField.account);
    final title = at(ImportField.title);

    return ImportRow(
      lineNumber: lineNumber,
      date: date,
      amountCents: mapping.negateAmounts ? -amount : amount,
      // A transaction with no description at all is harder to recognise later
      // than one labelled by where it came from.
      title: title.isEmpty ? 'Imported' : title,
      categoryName: category.isEmpty ? null : category,
      accountName: account.isEmpty ? null : account,
      notes: notes.isEmpty ? null : notes,
    );
  }

  /// The signed amount, however this file chooses to express it.
  static int? _readAmount(
    String Function(ImportField) at,
    ColumnMapping mapping,
  ) {
    int? parse(String raw) => ImportValues.parseAmountCents(
      raw,
      decimalSeparator: mapping.decimalSeparator,
    );

    // A money-in/money-out pair. Both columns exist on every row and only one
    // is filled, so the one with a number in it is the answer — and its sign
    // comes from which column it was in, not from the number.
    if (mapping.has(ImportField.moneyIn) || mapping.has(ImportField.moneyOut)) {
      final out = parse(at(ImportField.moneyOut));
      if (out != null && out != 0) return -out.abs();
      final into = parse(at(ImportField.moneyIn));
      if (into != null && into != 0) return into.abs();
      // Both blank is a row with no movement; both zero is the same thing.
      return (out ?? into) == null ? null : 0;
    }

    final amount = parse(at(ImportField.amount));
    if (amount == null) return null;

    // A single unsigned column plus a word saying which way it went.
    final direction = ImportValues.parseDirection(at(ImportField.direction));
    if (direction != null) return direction ? amount.abs() : -amount.abs();

    return amount;
  }
}

import 'dart:convert';

import 'package:the_accountant/features/import/domain/csv_reader.dart';
import 'package:the_accountant/features/import/domain/import_values.dart';

/// Something an imported row can say.
enum ImportField {
  date('Date', required: true),

  /// A single column holding a signed amount: negative is money out.
  amount('Amount'),

  /// The pair some banks use instead: two columns, one of which is filled.
  moneyIn('Money in'),
  moneyOut('Money out'),

  title('Description'),

  /// A word saying which way the money went, when the amount is unsigned.
  direction('Type (credit/debit)'),

  category('Category'),
  account('Account'),
  notes('Notes');

  const ImportField(this.label, {this.required = false});

  final String label;

  /// Whether a mapping is unusable without it.
  final bool required;
}

/// Which column of the file holds which field.
///
/// Beyond Cashew, which asks for this every time: a mapping is savable under a
/// bank's name and offered back the next time a file with the same columns
/// turns up. Nobody should have to re-describe their bank's export every month.
class ColumnMapping {
  const ColumnMapping({
    this.columns = const {},
    this.dateFormat,
    this.decimalSeparator,
    this.negateAmounts = false,
  });

  /// Field to the index of the column holding it.
  final Map<ImportField, int> columns;

  /// The pattern the date column is written in.
  final String? dateFormat;

  /// Which character is the decimal point, when the file cannot settle it.
  final String? decimalSeparator;

  /// Flip every sign.
  ///
  /// Some exports write a spend as positive and a deposit as negative, which no
  /// amount of parsing can detect — the numbers are valid either way round.
  final bool negateAmounts;

  int? indexOf(ImportField field) => columns[field];

  bool has(ImportField field) => columns.containsKey(field);

  /// Whether this mapping describes enough to import anything.
  ///
  /// A date, and some way of knowing the amount. Everything else has a sensible
  /// blank.
  bool get isUsable =>
      has(ImportField.date) &&
      (has(ImportField.amount) ||
          has(ImportField.moneyIn) ||
          has(ImportField.moneyOut));

  /// What is still missing, phrased for the screen.
  List<String> get missing => [
    if (!has(ImportField.date)) 'a date column',
    if (!has(ImportField.amount) &&
        !has(ImportField.moneyIn) &&
        !has(ImportField.moneyOut))
      'an amount column',
  ];

  ColumnMapping copyWith({
    Map<ImportField, int>? columns,
    String? dateFormat,
    String? decimalSeparator,
    bool? negateAmounts,
  }) => ColumnMapping(
    columns: columns ?? this.columns,
    dateFormat: dateFormat ?? this.dateFormat,
    decimalSeparator: decimalSeparator ?? this.decimalSeparator,
    negateAmounts: negateAmounts ?? this.negateAmounts,
  );

  /// Point [field] at [index], or clear it when [index] is null.
  ///
  /// A column can only mean one thing, so assigning it to a field takes it away
  /// from whatever field had it before. Two fields reading the same column is
  /// never what was meant, and it produces a mapping that looks right on screen
  /// and imports nonsense.
  ColumnMapping assign(ImportField field, int? index) {
    final next = Map<ImportField, int>.from(columns);
    next.remove(field);
    if (index != null) {
      next.removeWhere((_, value) => value == index);
      next[field] = index;
    }
    return copyWith(columns: next);
  }

  Map<String, Object?> toJson() => {
    'columns': {
      for (final entry in columns.entries) entry.key.name: entry.value,
    },
    if (dateFormat != null) 'date_format': dateFormat,
    if (decimalSeparator != null) 'decimal_separator': decimalSeparator,
    'negate_amounts': negateAmounts,
  };

  String encode() => jsonEncode(toJson());

  static ColumnMapping decode(String source) {
    try {
      final raw = jsonDecode(source);
      if (raw is! Map) return const ColumnMapping();
      final rawColumns = raw['columns'];
      return ColumnMapping(
        columns: {
          if (rawColumns is Map)
            for (final entry in rawColumns.entries)
              if (_fieldNamed('${entry.key}') case final field?)
                if (entry.value is int) field: entry.value as int,
        },
        dateFormat: raw['date_format'] as String?,
        decimalSeparator: raw['decimal_separator'] as String?,
        negateAmounts: raw['negate_amounts'] == true,
      );
    } catch (_) {
      // A saved template that cannot be read is worth less than nothing if it
      // stops the import screen opening.
      return const ColumnMapping();
    }
  }

  static ImportField? _fieldNamed(String name) {
    for (final field in ImportField.values) {
      if (field.name == name) return field;
    }
    return null;
  }

  /// Guess a mapping from the column titles, and from the values under them.
  ///
  /// The titles carry most of it. The date format and the decimal separator
  /// cannot come from a title at all, so those are read off the data.
  static ColumnMapping guess(CsvDocument document) {
    final header = document.header;
    var mapping = const ColumnMapping();

    for (var i = 0; i < header.length; i++) {
      final field = _fieldForHeading(header[i]);
      if (field == null) continue;
      // First column wins: a file with both "Date" and "Value date" should use
      // the one the bank put first.
      if (mapping.has(field)) continue;
      mapping = mapping.assign(field, i);
    }

    // A single signed amount column and a money-in/money-out pair are two ways
    // of saying the same thing, and a file that seems to have both has been
    // misread. The pair is the more specific reading, so it wins.
    if (mapping.has(ImportField.amount) &&
        (mapping.has(ImportField.moneyIn) ||
            mapping.has(ImportField.moneyOut))) {
      mapping = mapping.assign(ImportField.amount, null);
    }

    final dateIndex = mapping.indexOf(ImportField.date);
    if (dateIndex != null) {
      mapping = mapping.copyWith(
        dateFormat: ImportValuesGuess.dateFormat(document, dateIndex),
      );
    }

    final amountIndex =
        mapping.indexOf(ImportField.amount) ??
        mapping.indexOf(ImportField.moneyOut) ??
        mapping.indexOf(ImportField.moneyIn);
    if (amountIndex != null) {
      mapping = mapping.copyWith(
        decimalSeparator: ImportValuesGuess.decimalSeparator(
          document,
          amountIndex,
        ),
      );
    }

    return mapping;
  }

  /// Words that name a field, tried longest first so `money out` is not read as
  /// `money in` would be.
  static const Map<ImportField, List<String>> _headings = {
    ImportField.moneyOut: [
      'money out',
      'paid out',
      'debit amount',
      'withdrawal',
      'withdrawals',
      'debit',
      'outflow',
      'expense',
    ],
    ImportField.moneyIn: [
      'money in',
      'paid in',
      'credit amount',
      'deposit',
      'deposits',
      'credit',
      'inflow',
      'income',
    ],
    ImportField.date: [
      'transaction date',
      'posting date',
      'value date',
      'date',
      'datetime',
    ],
    ImportField.amount: ['amount', 'value', 'sum', 'total'],
    ImportField.title: [
      'description',
      'details',
      'narrative',
      'payee',
      'merchant',
      'reference',
      'title',
      'name',
      'memo',
    ],
    ImportField.direction: [
      'transaction type',
      'type',
      'direction',
      'dr/cr',
      'debit/credit',
    ],
    ImportField.category: ['category', 'categories'],
    ImportField.account: ['account', 'account name', 'wallet'],
    ImportField.notes: ['notes', 'note', 'comment', 'comments'],
  };

  static ImportField? _fieldForHeading(String heading) {
    final normalized = heading
        .toLowerCase()
        .replaceAll(RegExp(r'[_-]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (normalized.isEmpty) return null;

    // Exact first, so "Type" is a direction rather than being caught by a
    // substring rule somewhere else.
    for (final entry in _headings.entries) {
      if (entry.value.contains(normalized)) return entry.key;
    }
    for (final entry in _headings.entries) {
      for (final word in entry.value) {
        if (normalized.contains(word)) return entry.key;
      }
    }
    return null;
  }
}

/// Reading a guess off the rows rather than the titles.
class ImportValuesGuess {
  const ImportValuesGuess._();

  static List<String> _column(CsvDocument document, int index) => [
    for (final row in document.body.take(50)) CsvDocument.cell(row, index),
  ];

  static String? dateFormat(CsvDocument document, int index) =>
      ImportValues.guessDateFormat(_column(document, index));

  static String? decimalSeparator(CsvDocument document, int index) =>
      ImportValues.guessDecimalSeparator(_column(document, index));
}

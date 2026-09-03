import 'dart:convert';
import 'dart:typed_data';

/// A CSV file that has been read, however the bank chose to write it.
class CsvDocument {
  const CsvDocument({
    required this.rows,
    required this.delimiter,
    required this.hasHeader,
  });

  /// Every row, header included when there is one.
  final List<List<String>> rows;

  final String delimiter;
  final bool hasHeader;

  /// Column titles, or `Column 1`, `Column 2`… when the file has none.
  List<String> get header {
    if (rows.isEmpty) return const [];
    if (hasHeader) return rows.first;
    return [for (var i = 1; i <= columnCount; i++) 'Column $i'];
  }

  List<List<String>> get body => hasHeader ? rows.skip(1).toList() : rows;

  int get columnCount =>
      rows.fold(0, (widest, row) => row.length > widest ? row.length : widest);

  /// Read [index] out of [row], tolerating a row that stops short.
  ///
  /// Ragged rows are normal in exported statements — a trailing empty field is
  /// often just left off — and refusing the whole file over one is not a
  /// service to anybody.
  static String cell(List<String> row, int index) =>
      index >= 0 && index < row.length ? row[index].trim() : '';
}

/// Turns the bytes of a statement into rows.
///
/// Written rather than taken from a package because the hard part here is not
/// the grammar — it is guessing the encoding, the delimiter and whether the
/// first line is a header, none of which a parser will do for you, and all of
/// which a bank will get creative about.
class CsvReader {
  const CsvReader._();

  /// Delimiters worth trying, commonest first.
  ///
  /// Semicolon is not an afterthought: it is what every bank in a country that
  /// writes `1.234,56` exports, because the comma is already spoken for.
  static const List<String> candidateDelimiters = [',', ';', '\t', '|'];

  /// Turn bytes into text, whatever they were written as.
  ///
  /// A byte-order mark is believed when there is one. Failing that the bytes
  /// are read as UTF-8, and only if that is not valid are they read as
  /// Latin-1 — which cannot fail, and is what an older Windows export
  /// generally is. Getting this wrong does not throw; it silently turns every
  /// accented payee into mojibake, which is why the guess is made here rather
  /// than left to a default somewhere.
  static String decode(Uint8List bytes) {
    if (bytes.length >= 3 &&
        bytes[0] == 0xEF &&
        bytes[1] == 0xBB &&
        bytes[2] == 0xBF) {
      return utf8.decode(bytes.sublist(3), allowMalformed: true);
    }
    if (bytes.length >= 2 && bytes[0] == 0xFF && bytes[1] == 0xFE) {
      return _decodeUtf16(bytes.sublist(2), littleEndian: true);
    }
    if (bytes.length >= 2 && bytes[0] == 0xFE && bytes[1] == 0xFF) {
      return _decodeUtf16(bytes.sublist(2), littleEndian: false);
    }

    try {
      return utf8.decode(bytes);
    } on FormatException {
      return latin1.decode(bytes, allowInvalid: true);
    }
  }

  static String _decodeUtf16(Uint8List bytes, {required bool littleEndian}) {
    final units = <int>[];
    for (var i = 0; i + 1 < bytes.length; i += 2) {
      units.add(
        littleEndian
            ? bytes[i] | (bytes[i + 1] << 8)
            : (bytes[i] << 8) | bytes[i + 1],
      );
    }
    return String.fromCharCodes(units);
  }

  /// Which character separates the fields.
  ///
  /// Scored on how consistently a candidate splits the first few lines into the
  /// same number of columns. A file separated by semicolons still "parses" with
  /// commas — it just yields one enormous column per row — so consistency alone
  /// is not enough, and a candidate that never produces more than one column
  /// is discarded.
  static String detectDelimiter(String text) {
    final sample = const LineSplitter()
        .convert(text)
        .where((line) => line.trim().isNotEmpty)
        .take(20)
        .join('\n');
    if (sample.isEmpty) return ',';

    var best = candidateDelimiters.first;
    var bestScore = -1.0;

    for (final delimiter in candidateDelimiters) {
      final rows = parse(sample, delimiter: delimiter);
      if (rows.isEmpty) continue;

      final widths = rows.map((r) => r.length).toList();
      final columns = widths.first;
      if (columns < 2) continue;

      final consistent =
          widths.where((w) => w == columns).length / widths.length;
      // Column count breaks the tie: two delimiters that both split every row
      // evenly are separated by which one actually found the fields.
      final score = consistent * 100 + columns;
      if (score > bestScore) {
        bestScore = score;
        best = delimiter;
      }
    }
    return best;
  }

  /// RFC 4180, plus the liberties real files take.
  ///
  /// A quote that turns up in the middle of an unquoted field is treated as
  /// text rather than as the start of a quoted section, because that is what it
  /// always is in practice (`5" pipe fitting`) and the alternative is
  /// swallowing the rest of the file into one field.
  static List<List<String>> parse(String text, {required String delimiter}) {
    final rows = <List<String>>[];
    var row = <String>[];
    final field = StringBuffer();
    var quoted = false;
    var started = false;

    void endField() {
      row.add(field.toString());
      field.clear();
      started = false;
    }

    void endRow() {
      endField();
      // A blank line is a separator, not a record.
      if (row.any((cell) => cell.trim().isNotEmpty)) rows.add(row);
      row = <String>[];
    }

    for (var i = 0; i < text.length; i++) {
      final char = text[i];

      if (quoted) {
        if (char == '"') {
          if (i + 1 < text.length && text[i + 1] == '"') {
            field.write('"');
            i++;
          } else {
            quoted = false;
          }
        } else {
          field.write(char);
        }
        continue;
      }

      if (char == '"' && !started) {
        quoted = true;
        started = true;
        continue;
      }
      if (char == delimiter) {
        endField();
        continue;
      }
      if (char == '\n') {
        endRow();
        continue;
      }
      if (char == '\r') {
        if (i + 1 < text.length && text[i + 1] == '\n') i++;
        endRow();
        continue;
      }

      field.write(char);
      started = true;
    }

    if (field.isNotEmpty || row.isNotEmpty) endRow();
    return rows;
  }

  /// Whether the first row names the columns rather than being one.
  ///
  /// The test is comparative: a header looks unlike the rows under it. If the
  /// first row holds nothing that reads as a number or a date while the rows
  /// below it do, it is a header. Judging the first row on its own gets files
  /// with text-only data wrong in one direction and files with numeric column
  /// names wrong in the other.
  static bool looksLikeHeader(List<List<String>> rows) {
    if (rows.length < 2) return true;

    final first = rows.first;
    final rest = rows.skip(1).take(10);

    bool numericish(String cell) {
      final trimmed = cell.trim();
      if (trimmed.isEmpty) return false;
      if (RegExp(r'^[-+(]?[\d.,\s]*\d[\d.,\s]*\)?$').hasMatch(trimmed)) {
        return true;
      }
      // A date in any of the orders, with any of the usual separators.
      return RegExp(r'^\d{1,4}[-/.]\d{1,2}[-/.]\d{1,4}').hasMatch(trimmed);
    }

    final headerHasValues = first.any(numericish);
    final bodyHasValues = rest.any((row) => row.any(numericish));

    if (headerHasValues) return false;
    if (bodyHasValues) return true;

    // Nothing numeric anywhere. Fall back to the weaker signal: a header names
    // every column, so it has no blanks.
    return first.isNotEmpty && first.every((cell) => cell.trim().isNotEmpty);
  }

  /// Read a file end to end, guessing whatever was not specified.
  static CsvDocument read(
    Uint8List bytes, {
    String? delimiter,
    bool? hasHeader,
  }) {
    final text = decode(bytes);
    final resolved = delimiter ?? detectDelimiter(text);
    final rows = parse(text, delimiter: resolved);
    return CsvDocument(
      rows: rows,
      delimiter: resolved,
      hasHeader: hasHeader ?? looksLikeHeader(rows),
    );
  }
}

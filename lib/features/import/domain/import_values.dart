import 'package:intl/intl.dart';

/// Reading the two fields banks disagree about most: what the number means, and
/// what the date means.
///
/// Both are guessed from the file and then shown back to the user to correct,
/// because neither can be got right from the text alone. `03/04/2026` is two
/// different days depending on who exported it, and `1.234` is either one
/// thousand or one and a bit. Guessing silently and being wrong would put a
/// year of records on the wrong days at the wrong amounts.
class ImportValues {
  const ImportValues._();

  // ------------------------------------------------------------------ money

  /// The characters that could be separating groups of digits.
  static const String _separators = '.,';

  /// Read an amount into minor units, signed.
  ///
  /// Handles what statements actually contain: currency symbols and codes,
  /// thousands separators either way round, a trailing or leading minus,
  /// accountants' parentheses for a negative, and the `DR`/`CR` suffixes that
  /// mean the same thing.
  ///
  /// Returns null when there is no number in there at all, which is how a row
  /// gets reported as unusable rather than quietly imported as zero.
  static int? parseAmountCents(String raw, {String? decimalSeparator}) {
    var text = raw.trim();
    if (text.isEmpty) return null;

    var negative = false;

    if (text.startsWith('(') && text.endsWith(')')) {
      negative = true;
      text = text.substring(1, text.length - 1);
    }

    final marked = RegExp(
      r'^\s*(DR|CR)\b|\b(DR|CR)\s*$',
      caseSensitive: false,
    ).firstMatch(text);
    if (marked != null) {
      if ((marked.group(1) ?? marked.group(2) ?? '').toUpperCase() == 'DR') {
        negative = true;
      }
      text = text.replaceAll(marked.group(0)!, '');
    }

    // Anything that is not a digit, a separator or a sign is decoration: a
    // currency symbol, a code, a stray space used as a thousands separator.
    final cleaned = text.replaceAll(RegExp(r'[^0-9.,+-]'), '');
    if (!RegExp(r'\d').hasMatch(cleaned)) return null;

    if (cleaned.startsWith('-')) negative = !negative;

    final digitsAndSeparators = cleaned.replaceAll(RegExp(r'[+-]'), '');
    final separator =
        decimalSeparator ?? _decimalSeparatorIn(digitsAndSeparators);

    final buffer = StringBuffer();
    for (final char in digitsAndSeparators.split('')) {
      if (char == separator) {
        buffer.write('.');
      } else if (!_separators.contains(char)) {
        buffer.write(char);
      }
    }

    final value = double.tryParse(buffer.toString());
    if (value == null) return null;

    final cents = (value * 100).round();
    return negative ? -cents : cents;
  }

  /// Which separator in a single number is the decimal point.
  ///
  /// When both appear, the last one is the decimal — true of `1.234,56` and of
  /// `1,234.56` alike. When only one appears it is a decimal point only if it
  /// is the last separator and has one or two digits behind it; `1,234` and
  /// `1.234` are a thousand, not one and a bit.
  static String? _decimalSeparatorIn(String number) {
    final lastDot = number.lastIndexOf('.');
    final lastComma = number.lastIndexOf(',');

    if (lastDot >= 0 && lastComma >= 0) {
      return lastDot > lastComma ? '.' : ',';
    }

    final index = lastDot >= 0 ? lastDot : lastComma;
    if (index < 0) return null;

    final trailing = number.length - index - 1;
    final occurrences = number.split(number[index]).length - 1;
    if (occurrences == 1 && trailing >= 1 && trailing <= 2) {
      return number[index];
    }
    return null;
  }

  /// Which separator the file as a whole uses, decided over many values.
  ///
  /// One value can be genuinely ambiguous; a column rarely is. If any value in
  /// the column settles it, that answer is used for all of them, so a file does
  /// not read `1.234,56` and `99.99` under two different rules.
  static String? guessDecimalSeparator(Iterable<String> samples) {
    var dot = 0;
    var comma = 0;
    for (final sample in samples) {
      final cleaned = sample.replaceAll(RegExp(r'[^0-9.,]'), '');
      switch (_decimalSeparatorIn(cleaned)) {
        case '.':
          dot++;
        case ',':
          comma++;
      }
    }
    if (dot == 0 && comma == 0) return null;
    return dot >= comma ? '.' : ',';
  }

  // ------------------------------------------------------------------ dates

  /// Patterns worth trying, in the order a tie should be broken.
  ///
  /// ISO first because it is unambiguous. Day-first before month-first only
  /// because more of the world writes it that way; where a file cannot settle
  /// it, the import screen shows the guess against real rows so the user can
  /// see it is wrong before committing to it.
  static const List<String> candidateDateFormats = [
    'yyyy-MM-dd',
    'yyyy-MM-dd HH:mm:ss',
    'yyyy-MM-ddTHH:mm:ss',
    'yyyy/MM/dd',
    'dd/MM/yyyy',
    'dd/MM/yyyy HH:mm',
    'MM/dd/yyyy',
    'MM/dd/yyyy HH:mm',
    'dd-MM-yyyy',
    'MM-dd-yyyy',
    'dd.MM.yyyy',
    'd MMM yyyy',
    'MMM d, yyyy',
    'd MMMM yyyy',
    'dd/MM/yy',
    'MM/dd/yy',
    'yyyyMMdd',
  ];

  /// Read a date with a known pattern, or null if it does not fit.
  ///
  /// Strict, so `13/05/2026` is refused by a month-first pattern rather than
  /// being rolled forward into the following year — which is exactly the kind
  /// of silent wrongness that makes an import untrustworthy.
  static DateTime? parseDate(String raw, String pattern) {
    final text = raw.trim();
    if (text.isEmpty) return null;
    try {
      return DateFormat(pattern).parseStrict(text);
    } catch (_) {
      return null;
    }
  }

  /// The pattern that reads the most of [samples], or null if none does.
  static String? guessDateFormat(Iterable<String> samples) {
    final values = samples
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .take(50)
        .toList();
    if (values.isEmpty) return null;

    String? best;
    var bestHits = 0;

    for (final pattern in candidateDateFormats) {
      var hits = 0;
      for (final value in values) {
        if (parseDate(value, pattern) != null) hits++;
      }
      // Strictly greater, so the earlier — less ambiguous — pattern wins a tie.
      if (hits > bestHits) {
        bestHits = hits;
        best = pattern;
      }
      if (bestHits == values.length && best == pattern) break;
    }

    return bestHits == 0 ? null : best;
  }

  // ------------------------------------------------------------ direction

  /// Words a statement uses to say which way the money went.
  static const Set<String> _incomeWords = {
    'income',
    'credit',
    'cr',
    'deposit',
    'in',
    'received',
    'receipt',
    'inflow',
  };

  static const Set<String> _expenseWords = {
    'expense',
    'debit',
    'dr',
    'withdrawal',
    'out',
    'paid',
    'payment',
    'purchase',
    'outflow',
  };

  /// Whether a type column says money came in, went out, or says nothing.
  static bool? parseDirection(String raw) {
    final word = raw.trim().toLowerCase();
    if (word.isEmpty) return null;
    if (_incomeWords.contains(word)) return true;
    if (_expenseWords.contains(word)) return false;
    return null;
  }
}

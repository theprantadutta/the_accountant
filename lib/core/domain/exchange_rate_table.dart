import 'package:the_accountant/data/datasources/local/app_database.dart';

/// The stored exchange rates, and how to get from one currency to another.
///
/// The rate downloader writes **`USD -> X` rows only**, one per currency it
/// knows. Anything that asked for a direct `from -> to` row therefore found one
/// exactly when the source happened to be dollars, and nothing else — so a
/// perfectly ordinary rate refresh left a euro expense unconvertible into a
/// dollar budget, and every non-dollar pair unconvertible into anything.
///
/// Three ways in, most specific first:
///
/// 1. a direct row, custom rate first — the user's own override is the most
///    deliberate statement there is about what a currency is worth to them;
/// 2. the inverse of a direct row in the other direction;
/// 3. through the dollar, which is the shape the download actually stores.
///
/// Where none of those produces a positive rate the answer is null. Treating
/// one dollar as one taka is not a rough answer, it is a wrong one by a factor
/// of a hundred, and it would be written into a total looking exactly as
/// settled as a correct figure.
class ExchangeRateTable {
  /// Effective rate per `from|to` pair: destination units per source unit.
  final Map<String, double> _direct;

  const ExchangeRateTable._(this._direct);

  static const String _base = 'USD';

  /// Read every stored rate once.
  ///
  /// One query rather than one per pair: a report converts many rows and the
  /// table is small, so the whole of it is cheaper than asking repeatedly.
  static Future<ExchangeRateTable> load(AppDatabase db) async {
    final direct = <String, double>{};
    try {
      for (final row in await db.getAllExchangeRates()) {
        final effective = row.useCustomRate ? row.customRate : row.apiRate;
        if (effective == null || effective <= 0) continue;
        direct[_key(row.fromCurrency, row.toCurrency)] = effective;
      }
    } catch (_) {
      // A table that cannot be read converts nothing, which excludes amounts
      // and says so, rather than inventing a rate.
    }
    return ExchangeRateTable._(direct);
  }

  /// Destination units per source unit, or null when nothing honest is known.
  double? rate({required String from, required String to}) {
    final source = from.toUpperCase();
    final target = to.toUpperCase();
    if (source == target) return 1;

    final direct = _direct[_key(source, target)];
    if (direct != null) return direct;

    final inverse = _direct[_key(target, source)];
    if (inverse != null) return 1 / inverse;

    // Through the base, which is how the downloader stores everything.
    final perSource = _perBaseUnit(source);
    final perTarget = _perBaseUnit(target);
    if (perSource == null || perTarget == null || perSource <= 0) return null;
    return perTarget / perSource;
  }

  /// How many units of [currency] one base unit buys.
  double? _perBaseUnit(String currency) {
    if (currency == _base) return 1;
    final forward = _direct[_key(_base, currency)];
    if (forward != null) return forward;
    final backward = _direct[_key(currency, _base)];
    if (backward != null && backward > 0) return 1 / backward;
    return null;
  }

  static String _key(String from, String to) =>
      '${from.toUpperCase()}|${to.toUpperCase()}';
}

import 'package:the_accountant/data/datasources/local/app_database.dart';

/// Puts amounts from different accounts into one currency before they are added.
///
/// An amount is a number of minor units of whatever account it sits in, and
/// nothing about the number says which. Every total in the app used to add them
/// raw and then label the sum in the default currency, so a taka expense and a
/// dollar expense were treated as the same size of thing and the answer was
/// wrong by roughly a factor of a hundred — while looking exactly as settled as
/// a correct figure.
///
/// Where no rate is known [convert] returns null rather than the number back.
/// Treating one dollar as one taka is not a rough answer, it is a wrong one, and
/// a total is better short and honest about it than complete and false. This is
/// the same rule cross-currency transfers already follow.
class AmountConverter {
  /// The currency every converted amount is expressed in.
  final String target;

  final Map<String, String> walletCurrency;

  /// Multiplier from each currency into [target]. Absent when no rate is known.
  final Map<String, double> rates;

  const AmountConverter({
    required this.target,
    required this.walletCurrency,
    required this.rates,
  });

  /// A converter for accounts that are all in one currency, which needs no
  /// rates and can never exclude anything.
  const AmountConverter.identity(this.target)
    : walletCurrency = const {},
      rates = const {};

  /// Read every account, and a rate for each currency they are held in.
  ///
  /// Rates come from the stored table rather than [target]-relative arithmetic
  /// on a live API: a report has to give the same answer twice, and rates move.
  static Future<AmountConverter> forDatabase(
    AppDatabase db, {
    String? target,
  }) async {
    final display = target ?? await db.displayCurrency();
    final wallets = await db.getAllWallets();

    final walletCurrency = {for (final w in wallets) w.id: w.currency};
    final rates = <String, double>{display: 1};

    for (final currency in walletCurrency.values.toSet()) {
      if (rates.containsKey(currency)) continue;
      final rate = await _rate(db, from: currency, to: display);
      if (rate != null) rates[currency] = rate;
    }

    return AmountConverter(
      target: display,
      walletCurrency: walletCurrency,
      rates: rates,
    );
  }

  static Future<double?> _rate(
    AppDatabase db, {
    required String from,
    required String to,
  }) async {
    try {
      final row = await db.getExchangeRate(from, to);
      final effective = row?.useCustomRate == true
          ? row?.customRate
          : row?.apiRate;
      if (effective == null || effective <= 0) return null;
      return effective;
    } catch (_) {
      return null;
    }
  }

  /// Whether an amount from [walletId] can be expressed in [target] at all.
  bool knowsRateFor(String walletId) => rateFor(walletId) != null;

  /// The multiplier for [walletId], or null when there is no honest one.
  ///
  /// An account this converter has never heard of is treated as already being
  /// in [target]: a row can only be missing here if it was written between the
  /// converter being built and the total being taken, and a fresh account in
  /// another currency is a far less likely reading than a stale map.
  double? rateFor(String walletId) {
    final currency = walletCurrency[walletId];
    if (currency == null) return 1;
    if (currency == target) return 1;
    return rates[currency];
  }

  /// [amount] in [target]'s minor units, or null when no rate is known.
  int? convert(int amount, String walletId) {
    final rate = rateFor(walletId);
    if (rate == null) return null;
    if (rate == 1) return amount;
    return (amount * rate).round();
  }
}

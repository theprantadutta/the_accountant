import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/amount_converter.dart';
import 'package:the_accountant/core/domain/exchange_rate_table.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

import '../helpers/test_database.dart';

/// Getting from one currency to another with the rates the app actually stores.
///
/// The downloader writes `USD -> X` rows and nothing else. Anything that looked
/// for a direct `from -> to` row therefore found one exactly when the source
/// happened to be dollars — so a euro expense was excluded from a dollar budget
/// even with a perfectly successful rate refresh behind it, and for a non-dollar
/// display currency almost everything was excluded. The tests that shipped with
/// that code seeded direct custom rates, so they never met the shape production
/// stores.
void main() {
  late AppDatabase db;

  setUp(() {
    db = openTestDatabase();
  });

  tearDown(() => db.close());

  /// What a successful rate refresh leaves behind.
  Future<void> downloadRates(Map<String, double> perDollar) async {
    for (final entry in perDollar.entries) {
      await db.upsertExchangeRate(
        fromCurrency: 'USD',
        toCurrency: entry.key,
        apiRate: entry.value,
      );
    }
  }

  group('the shapes the downloader stores', () {
    test('a direct row is used as it stands', () async {
      await downloadRates({'EUR': 0.8});

      final table = await ExchangeRateTable.load(db);

      expect(table.rate(from: 'USD', to: 'EUR'), closeTo(0.8, 1e-9));
    });

    test('the same row is inverted for the other direction', () async {
      await downloadRates({'EUR': 0.8});

      final table = await ExchangeRateTable.load(db);

      expect(
        table.rate(from: 'EUR', to: 'USD'),
        closeTo(1.25, 1e-9),
        reason: 'a euro is worth more than a dollar at 0.8, and refusing to '
            'invert the one row the downloader wrote excluded every foreign '
            'expense from a dollar budget',
      );
    });

    test('two rows make a cross rate', () async {
      await downloadRates({'EUR': 0.8, 'BDT': 120});

      final table = await ExchangeRateTable.load(db);

      expect(
        table.rate(from: 'BDT', to: 'EUR'),
        closeTo(0.8 / 120, 1e-9),
        reason: 'neither pair is stored directly, and both are derivable',
      );
    });

    test('a currency to itself is one, stored or not', () async {
      final table = await ExchangeRateTable.load(db);

      expect(table.rate(from: 'JPY', to: 'JPY'), 1);
    });

    test('an unknown currency has no rate', () async {
      await downloadRates({'EUR': 0.8});

      final table = await ExchangeRateTable.load(db);

      expect(
        table.rate(from: 'JPY', to: 'EUR'),
        isNull,
        reason: 'treating one yen as one euro is not a rough answer, it is a '
            'wrong one that looks exactly as settled as a correct figure',
      );
    });
  });

  group('what the user said beats what was downloaded', () {
    test('a custom direct rate wins over the api rate', () async {
      await downloadRates({'EUR': 0.8});
      await db.setCustomRate('USD', 'EUR', 0.9);

      final table = await ExchangeRateTable.load(db);

      expect(table.rate(from: 'USD', to: 'EUR'), closeTo(0.9, 1e-9));
    });

    test('a custom rate beats a derivable cross rate', () async {
      await downloadRates({'EUR': 0.8, 'BDT': 120});
      await db.setCustomRate('BDT', 'EUR', 0.01);

      final table = await ExchangeRateTable.load(db);

      expect(
        table.rate(from: 'BDT', to: 'EUR'),
        closeTo(0.01, 1e-9),
        reason: 'an override is the most deliberate statement there is about '
            'what a currency is worth to this user',
      );
    });

    test('a rate of zero is not a rate', () async {
      await db.upsertExchangeRate(
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        apiRate: 0,
      );

      final table = await ExchangeRateTable.load(db);

      expect(table.rate(from: 'USD', to: 'EUR'), isNull);
    });
  });

  group('the converter reads the same table', () {
    test('an ordinary refresh is enough to convert a foreign account', () async {
      await seedWallet(db, name: 'Checking', currency: 'USD');
      final euros = await seedWallet(db, name: 'Holiday', currency: 'EUR');
      await downloadRates({'EUR': 0.8});

      final converter = await AmountConverter.forDatabase(db, target: 'USD');

      expect(
        converter.convert(8000, euros),
        10000,
        reason: 'this is the whole of what a rate refresh is for; without it '
            'foreign spending was silently dropped from every total',
      );
    });

    test('an account whose currency was never downloaded is excluded', () async {
      await seedWallet(db, name: 'Checking', currency: 'USD');
      final yen = await seedWallet(db, name: 'Tokyo', currency: 'JPY');
      await downloadRates({'EUR': 0.8});

      final converter = await AmountConverter.forDatabase(db, target: 'USD');

      expect(converter.convert(8000, yen), isNull);
    });
  });
}

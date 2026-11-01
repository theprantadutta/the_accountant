import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/services/sealed_prefs.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('a value comes back as written, but is not stored readable', () async {
    final prefs = await SharedPreferences.getInstance();

    await SealedPrefs.setString(prefs, 'zakat_settings', '{"gold":"৳120000"}');

    expect(
      await SealedPrefs.getString(prefs, 'zakat_settings'),
      '{"gold":"৳120000"}',
    );
    expect(prefs.getString('zakat_settings'), isNot(contains('120000')));
  });

  test('a plain value from an older version is read, then resealed', () async {
    SharedPreferences.setMockInitialValues({'zakat_settings': 'old plain'});
    final prefs = await SharedPreferences.getInstance();

    expect(await SealedPrefs.getString(prefs, 'zakat_settings'), 'old plain');
    expect(prefs.getString('zakat_settings'), isNot('old plain'));
    expect(await SealedPrefs.getString(prefs, 'zakat_settings'), 'old plain');
  });

  test('a sealed value moved under another name does not open', () async {
    final prefs = await SharedPreferences.getInstance();
    await SealedPrefs.setString(prefs, 'a', 'secret');
    await prefs.setString('b', prefs.getString('a')!);

    expect(await SealedPrefs.getString(prefs, 'b'), isNull);
  });

  test('nothing stored reads as null', () async {
    final prefs = await SharedPreferences.getInstance();
    expect(await SealedPrefs.getString(prefs, 'missing'), isNull);
  });
}

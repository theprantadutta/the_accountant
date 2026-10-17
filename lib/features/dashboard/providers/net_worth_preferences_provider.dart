import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Whether credit cards count toward net worth. Off unless the user turns it
/// on.
///
/// A card's balance is borrowing power or a bill, not money the user has, and
/// counting it made net worth swing with every purchase on credit — or, on a
/// card paid ahead, read as savings. Some people do want the whole picture,
/// so it is a choice, kept on this device like the other display settings.
class CreditCardsInNetWorthNotifier extends StateNotifier<bool> {
  CreditCardsInNetWorthNotifier() : super(false) {
    _load();
  }

  static const String prefKey = 'net_worth_includes_credit_cards';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(prefKey) ?? false;
  }

  Future<void> set(bool include) async {
    state = include;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(prefKey, include);
  }
}

final creditCardsInNetWorthProvider =
    StateNotifierProvider<CreditCardsInNetWorthNotifier, bool>(
      (ref) => CreditCardsInNetWorthNotifier(),
    );

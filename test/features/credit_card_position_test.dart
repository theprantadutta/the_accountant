import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/features/wallets/domain/credit_card_position.dart';

/// Only a negative card balance is owed.
///
/// The dashboard took the magnitude of whatever the balance was, so a card
/// paid in advance — or one tracked from its available credit, as people
/// arriving from apps without a card type do — showed as that much debt.
void main() {
  test('a card in use owes what its balance is below zero', () {
    final card = CreditCardPosition.of(balance: -30000, limit: 100000);
    expect(card.owed, 30000);
    expect(card.inCredit, 0);
    expect(card.available, 70000);
    expect(card.usage, 0.3);
  });

  test('a card paid in advance owes nothing and has more than its limit', () {
    final card = CreditCardPosition.of(balance: 5000, limit: 100000);
    expect(card.owed, 0);
    expect(card.inCredit, 5000);
    expect(card.available, 105000);
    expect(card.usage, 0.0);
  });

  test('usage is bounded and safe without a limit', () {
    expect(CreditCardPosition.of(balance: -150000, limit: 100000).usage, 1.0);
    expect(CreditCardPosition.of(balance: -150000, limit: 0).usage, 0.0);
  });
}

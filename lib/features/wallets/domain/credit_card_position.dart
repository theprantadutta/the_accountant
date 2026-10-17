/// Where a credit card stands: what is owed on it, how far it is in credit,
/// and how much can still be spent.
///
/// A card's balance runs negative as it is used, so only a negative balance is
/// owed. The dashboard card took the magnitude of whatever the balance was,
/// which showed a card paid in advance — or one tracked from its available
/// credit, as people moving from apps without a card type do — as that much
/// debt. Both places that draw a card read it from here now.
class CreditCardPosition {
  /// Owed on the card, in minor units. Zero when it is not in debt.
  final int owed;

  /// Paid beyond what was owed, in minor units. Zero unless overpaid.
  final int inCredit;

  /// What can still be spent: the limit, less what is owed, plus any credit.
  final int available;

  /// How much of the limit is used, from 0.0 to 1.0.
  final double usage;

  const CreditCardPosition._({
    required this.owed,
    required this.inCredit,
    required this.available,
    required this.usage,
  });

  factory CreditCardPosition.of({required int balance, required int limit}) {
    final owed = balance < 0 ? -balance : 0;
    final inCredit = balance > 0 ? balance : 0;
    return CreditCardPosition._(
      owed: owed,
      inCredit: inCredit,
      available: limit - owed + inCredit,
      usage: limit <= 0 ? 0.0 : (owed / limit).clamp(0.0, 1.0),
    );
  }
}

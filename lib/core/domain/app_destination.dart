/// Somewhere the app can be sent to from outside itself.
///
/// A launcher shortcut or a tapped notification arrives as one of these, so
/// there is a single list of places either is allowed to name. Links are not
/// accepted; see [DeepLinkService].
enum AppDestination {
  dashboard,
  addExpense,
  addIncome,
  addTransfer,
  transactions,
  budgets,
  reports,
  settings,
  scanReceipt,
  notifications,

  /// Credit card bills; [DeepLink.entityId] picks out one card when set.
  cardBills,

  /// EMIs, loans, DPS and FDR; [DeepLink.entityId] opens one plan.
  plans,

  /// Where spendable money is headed, for a shortfall warning.
  forecast,

  /// Needs [DeepLink.entityId].
  transactionDetail,
}

/// A resolved instruction to go somewhere, with whatever it needs to get there.
class DeepLink {
  const DeepLink(this.destination, {this.entityId});

  final AppDestination destination;

  /// The row a detail destination is about, when there is one.
  final String? entityId;

  @override
  bool operator ==(Object other) =>
      other is DeepLink &&
      other.destination == destination &&
      other.entityId == entityId;

  @override
  int get hashCode => Object.hash(destination, entityId);

  @override
  String toString() =>
      'DeepLink(${destination.name}${entityId == null ? '' : ', $entityId'})';
}

/// Turns a launcher shortcut into a destination.
class DeepLinkParser {
  const DeepLinkParser._();

  /// Launcher shortcut ids. Stable strings: Android caches a shortcut by its
  /// type, so renaming one orphans the shortcut already on someone's home
  /// screen.
  static const String shortcutAddExpense = 'add_expense';
  static const String shortcutAddIncome = 'add_income';
  static const String shortcutScanReceipt = 'scan_receipt';
  static const String shortcutTransactions = 'transactions';

  static const Map<String, AppDestination> _shortcuts = {
    shortcutAddExpense: AppDestination.addExpense,
    shortcutAddIncome: AppDestination.addIncome,
    shortcutScanReceipt: AppDestination.scanReceipt,
    shortcutTransactions: AppDestination.transactions,
  };

  /// Read a launcher shortcut, or null if it is one this build no longer has.
  static DeepLink? forShortcut(String type) {
    final destination = _shortcuts[type];
    return destination == null ? null : DeepLink(destination);
  }
}

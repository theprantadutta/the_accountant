/// Somewhere the app can be sent to from outside itself.
///
/// A launcher shortcut, a link in an email, a notification tap — all of them
/// arrive as one of these, so there is a single list of places the outside
/// world is allowed to name.
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

/// Turns an incoming link or a launcher shortcut into a destination.
///
/// Everything here is deliberately total: an address the app does not
/// understand returns null rather than guessing. A link is untrusted input —
/// anyone can put one in an email — so the rule is that it may only name a
/// place, never carry an instruction, and never name a place the user has not
/// signed in to see. The second half of that is enforced by the caller, which
/// holds the link until authentication has resolved.
class DeepLinkParser {
  const DeepLinkParser._();

  /// The app's own scheme, for `theaccountant://…` links.
  static const String scheme = 'theaccountant';

  /// The verified domain, for `https://…` links that open the app directly.
  static const String host = 'theaccountant.pranta.dev';

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

  static const Map<String, AppDestination> _paths = {
    '': AppDestination.dashboard,
    'dashboard': AppDestination.dashboard,
    'home': AppDestination.dashboard,
    'transactions': AppDestination.transactions,
    'budgets': AppDestination.budgets,
    'reports': AppDestination.reports,
    'settings': AppDestination.settings,
    'scan': AppDestination.scanReceipt,
    'add': AppDestination.addExpense,
    'add/expense': AppDestination.addExpense,
    'add/income': AppDestination.addIncome,
    'add/transfer': AppDestination.addTransfer,
  };

  /// Read a link, or null if it names nothing this app knows.
  static DeepLink? parse(Uri uri) {
    if (!_isOurs(uri)) return null;

    final segments = [
      for (final segment in uri.pathSegments)
        if (segment.isNotEmpty) segment,
    ];

    // A custom-scheme link puts the first word in the host, not the path:
    // theaccountant://budgets has host 'budgets' and no segments at all.
    if (uri.scheme == scheme && uri.host.isNotEmpty) {
      segments.insert(0, uri.host);
    }

    if (segments.isEmpty) return const DeepLink(AppDestination.dashboard);

    // A row to open, which is the only shape that carries an id.
    if (segments.length == 2 && segments.first == 'transaction') {
      final id = segments[1].trim();
      if (id.isEmpty) return null;
      return DeepLink(AppDestination.transactionDetail, entityId: id);
    }

    // The whole path or nothing. Falling back to a shorter prefix would send
    // `settings/danger` to the settings screen, which is the same mistake as
    // obeying the part of an instruction you happened to understand: every
    // address this app answers is written out in _paths.
    return switch (_paths[segments.join('/').toLowerCase()]) {
      final destination? => DeepLink(destination),
      null => null,
    };
  }

  /// Read a launcher shortcut, or null if it is one this build no longer has.
  static DeepLink? forShortcut(String type) {
    final destination = _shortcuts[type];
    return destination == null ? null : DeepLink(destination);
  }

  /// Whether a link is addressed to this app at all.
  ///
  /// An https link has to match the verified host exactly. Accepting a
  /// subdomain, or matching on a suffix, is how a link to
  /// `theaccountant.pranta.dev.example.com` would be treated as ours.
  static bool _isOurs(Uri uri) {
    if (uri.scheme == scheme) return true;
    if (uri.scheme == 'https' || uri.scheme == 'http') {
      return uri.host.toLowerCase() == host;
    }
    return false;
  }
}

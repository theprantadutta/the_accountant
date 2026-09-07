import 'package:the_accountant/data/datasources/local/app_database.dart';

/// Which account the app treats as the default, and therefore which currency it
/// shows and counts figures in.
///
/// One function, called by everything that needs the answer. There were two
/// implementations before, and they disagreed: the entry form resolved the
/// persisted preference and accepted it even when the account had been
/// archived, while the budget engine read the database and skipped archived
/// accounts. Merging an account archives it without touching the preference —
/// so after merging the default account into one held in another currency, the
/// form asked for an amount in dollars and the engine read the stored number as
/// euros. A number can only mean one thing, and this is where that is decided.
///
/// The order is: the account the database marks default; then the one the user
/// chose, if that is still usable; then the first usable account. An archived
/// account is never the default — the user has put it away, and reading their
/// money in a currency they have retired is not what "default" is for.
///
/// The database flag comes first deliberately. It is the only part of this the
/// engine can see — a report has no access to a saved preference — so making it
/// the first choice is what lets the two callers reach the same answer. The
/// saved preference is honoured only when no account carries the flag, which is
/// the state a fresh install or an old one can be in.
Wallet? resolveDefaultWallet(
  Iterable<Wallet> wallets, {
  String? preferredId,
}) {
  final live = wallets.where((w) => !w.isArchived).toList();
  if (live.isEmpty) {
    // Everything is archived, or there are no accounts at all. The first row is
    // still a better answer than none, so the app shows *a* currency rather
    // than falling back to a hard-coded one.
    return wallets.isEmpty ? null : wallets.first;
  }

  final flagged = live.where((w) => w.isDefault).firstOrNull;
  if (flagged != null) return flagged;

  if (preferredId != null) {
    final preferred = live.where((w) => w.id == preferredId).firstOrNull;
    if (preferred != null) return preferred;
  }

  return live.first;
}

/// The currency [resolveDefaultWallet] picks, or dollars when there is nothing
/// to pick from.
String resolveDisplayCurrency(
  Iterable<Wallet> wallets, {
  String? preferredId,
}) =>
    resolveDefaultWallet(wallets, preferredId: preferredId)?.currency ?? 'USD';

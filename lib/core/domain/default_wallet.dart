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
/// The order is: the account the database marks default, then the first usable
/// account. An archived account is never the default — the user has put it away,
/// and reading their money in a currency they have retired is not what "default"
/// is for.
///
/// **The saved preference is not an input here.** It was, and sharing the
/// function was not enough to make the answers agree: the form passed the
/// preference and the engine had no way to, so with no account flagged the two
/// still disagreed — the form said one currency and the engine another for the same
/// figure. A preference the engine cannot see cannot take part in a decision
/// the engine has to make. It is reconciled into the flag instead, by
/// [AppDatabase.reconcileDefaultWallet], so that the user's choice reaches
/// everything through the one field both sides can read.
Wallet? resolveDefaultWallet(Iterable<Wallet> wallets) {
  // Live means not archived and not deleted. Both halves, stated here rather
  // than relied on from the caller: this is the shared authority on what the
  // default account is, and the last time "live" was written down twice the two
  // copies disagreed about tombstones.
  final live = wallets
      .where((w) => !w.isArchived && w.deletedAt == null)
      .toList();
  if (live.isEmpty) {
    // Everything is archived, or there are no accounts at all. The first row is
    // still a better answer than none, so the app shows *a* currency rather
    // than falling back to a hard-coded one.
    return wallets.isEmpty ? null : wallets.first;
  }

  return live.where((w) => w.isDefault).firstOrNull ?? live.first;
}

/// The currency [resolveDefaultWallet] picks, or dollars when there is nothing
/// to pick from.
String resolveDisplayCurrency(Iterable<Wallet> wallets) =>
    resolveDefaultWallet(wallets)?.currency ?? 'USD';

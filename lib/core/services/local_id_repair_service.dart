import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

/// Finishes the wallet re-key the schema-15 migration started.
///
/// A wallet id is written down in two places, and a Drift migration can only
/// reach one of them. `default_wallet_id` lives in SharedPreferences, so the
/// migration records what it changed and this service applies the rest.
///
/// Left undone, the preference would point at an id that no longer exists: the
/// app would fall back to some other wallet, and the wallet the user actually
/// chose during onboarding would quietly stop being their default.
class LocalIdRepairService {
  static const String defaultWalletKey = 'default_wallet_id';

  final AppDatabase _database;
  final SharedPreferences _prefs;

  LocalIdRepairService(this._database, this._prefs);

  /// Applies every re-key this device has not yet settled.
  ///
  /// Safe to call on every launch: a repair is marked settled once applied, and
  /// re-running it would be a no-op regardless.
  Future<void> applyPendingRepairs() async {
    final pending = await _database.unsettledIdRepairs();
    if (pending.isEmpty) return;

    for (final repair in pending) {
      final newId = repair.newId;
      if (newId == null) continue;

      if (repair.entityTable == 'wallets' &&
          _prefs.getString(defaultWalletKey) == repair.oldId) {
        await _prefs.setString(defaultWalletKey, newId);
        debugPrint('[LocalIdRepair] default wallet preference moved to $newId');
      }

      await _database.markIdRepairSettled(repair.id);
    }
  }

  /// Re-keys that were refused because the cloud may already hold the id.
  ///
  /// Nothing is retried or guessed at here — the records are intact and the
  /// decision belongs to a human. Surfaced so it reaches diagnostics instead of
  /// sitting silently in a table nobody reads.
  Future<List<LocalIdRepair>> unresolvedBlockedRepairs() =>
      _database.blockedIdRepairs();
}

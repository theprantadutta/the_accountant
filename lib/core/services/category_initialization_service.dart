import 'package:the_accountant/core/domain/default_categories.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

/// Provisions the built-in categories for a store.
///
/// Seeding is **per slug and idempotent**: only built-ins the store does not
/// already have are inserted. The old behaviour ("if there are no categories at
/// all, insert the whole set with fresh random ids") is what made a second
/// device upload a complete duplicate set of defaults — it seeded before it had
/// ever seen the account's cloud data, pushed, and only then pulled the
/// originals.
class CategoryInitializationService {
  final AppDatabase _db;

  CategoryInitializationService(this._db);

  /// Ensure every built-in category exists, including the system ones.
  ///
  /// Returns the slugs actually created.
  Future<List<String>> initializeDefaultCategories() async {
    try {
      return await _db.ensureDefaultCategories(DefaultCategoryCatalog.all);
    } catch (_) {
      // Seeding must never take the app down; a missing default is recoverable
      // on the next launch or the next sync.
      return const [];
    }
  }

  /// Ensure only the internal system categories exist.
  Future<void> initializeSystemCategories() =>
      _db.ensureSystemCategoriesExist();

  /// Whether this store still needs its built-in categories.
  Future<bool> needsDefaults() async {
    final present = await _db.liveDefaultKeys();
    return present.length < DefaultCategoryCatalog.all.length;
  }

  /// Collapse duplicate built-ins down to one row per slug.
  ///
  /// Run after a pull: a device that seeded its own defaults before it saw the
  /// cloud will hold both its copy and the account's canonical copy, and the two
  /// are provably the same built-in because they share a slug.
  Future<int> mergeDuplicates() => _db.mergeDuplicateDefaultCategories();
}

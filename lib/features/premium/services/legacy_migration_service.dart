import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:logger/logger.dart';

/// Keys used for legacy premium storage
class LegacyPremiumKeys {
  /// Old key for one-time purchase ID
  static const String purchaseId = 'premium_purchase_id';

  /// Old key for premium status
  static const String isPremium = 'is_premium';

  /// Old key for purchase date
  static const String purchaseDate = 'premium_purchase_date';

  /// Key to mark migration as complete
  static const String migrationComplete = 'legacy_premium_migration_complete';
}

/// Service to migrate legacy one-time premium purchases to Lifetime subscription
class LegacyMigrationService {
  final Ref _ref;
  final SharedPreferences _prefs;
  final ApiService? _apiService;
  final Logger _logger = Logger();

  LegacyMigrationService({
    required Ref ref,
    required SharedPreferences prefs,
    ApiService? apiService,
  })  : _ref = ref,
        _prefs = prefs,
        _apiService = apiService;

  /// Check if migration has already been completed
  bool get isMigrationComplete =>
      _prefs.getBool(LegacyPremiumKeys.migrationComplete) ?? false;

  /// Check if user has a legacy premium purchase
  bool hasLegacyPurchase() {
    final purchaseId = _prefs.getString(LegacyPremiumKeys.purchaseId);
    final isPremium = _prefs.getBool(LegacyPremiumKeys.isPremium) ?? false;

    return purchaseId != null || isPremium;
  }

  /// Get legacy purchase ID if exists
  String? getLegacyPurchaseId() {
    return _prefs.getString(LegacyPremiumKeys.purchaseId);
  }

  /// Get legacy purchase date if exists
  DateTime? getLegacyPurchaseDate() {
    final dateStr = _prefs.getString(LegacyPremiumKeys.purchaseDate);
    if (dateStr != null) {
      return DateTime.tryParse(dateStr);
    }
    return null;
  }

  /// Run migration check and migrate if needed
  /// Returns true if migration was performed, false otherwise
  Future<bool> checkAndMigrate() async {
    // Skip if already migrated
    if (isMigrationComplete) {
      _logger.d('Legacy migration already complete, skipping');
      return false;
    }

    // Check for legacy purchase
    if (!hasLegacyPurchase()) {
      _logger.d('No legacy purchase found, marking migration complete');
      await _markMigrationComplete();
      return false;
    }

    _logger.i('Legacy purchase found, initiating migration');

    // Migrate locally first (immediate user experience)
    _migrateLocally();

    // Try to migrate on backend (for sync)
    await _migrateOnBackend();

    // Mark migration as complete
    await _markMigrationComplete();

    _logger.i('Legacy migration completed successfully');
    return true;
  }

  /// Migrate locally by updating premium provider
  void _migrateLocally() {
    final purchaseId = getLegacyPurchaseId();

    _ref.read(premiumProvider.notifier).updateSubscription(
          tier: SubscriptionTier.premiumLifetime,
          purchaseId: purchaseId ?? 'legacy_migration',
        );

    _logger.i('Local migration complete: tier=premiumLifetime, purchaseId=$purchaseId');
  }

  /// Migrate on backend to ensure sync works correctly
  Future<void> _migrateOnBackend() async {
    if (_apiService == null) {
      _logger.w('ApiService not available, skipping backend migration');
      return;
    }

    try {
      final purchaseId = getLegacyPurchaseId();

      await _apiService.post(
        '/iap/migrate-legacy',
        data: {
          'legacy_purchase_id': purchaseId,
          'migration_type': 'one_time_to_lifetime',
        },
      );

      _logger.i('Backend migration request sent successfully');
    } catch (e) {
      // Don't fail the migration if backend call fails
      // User still has local access, backend can sync later
      _logger.w('Backend migration failed (will retry later): $e');
    }
  }

  /// Mark migration as complete to avoid re-running
  Future<void> _markMigrationComplete() async {
    await _prefs.setBool(LegacyPremiumKeys.migrationComplete, true);
  }

  /// Clean up old legacy keys after successful migration
  Future<void> cleanupLegacyKeys() async {
    await _prefs.remove(LegacyPremiumKeys.purchaseId);
    await _prefs.remove(LegacyPremiumKeys.isPremium);
    await _prefs.remove(LegacyPremiumKeys.purchaseDate);
    _logger.i('Legacy keys cleaned up');
  }

  /// Force reset migration status (for debugging/testing)
  Future<void> resetMigrationStatus() async {
    await _prefs.remove(LegacyPremiumKeys.migrationComplete);
    _logger.i('Migration status reset');
  }
}

/// Provider for legacy migration service
final legacyMigrationServiceProvider = Provider<LegacyMigrationService>((ref) {
  throw UnimplementedError(
    'legacyMigrationServiceProvider must be overridden in ProviderScope',
  );
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/constants/app_constants.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:drift/drift.dart' show Value;

class SettingsState {
  final String themeMode;
  final String currency;
  final bool notificationsEnabled;
  final bool budgetNotificationsEnabled;
  final double budgetWarningThreshold;
  final bool isPremium;

  SettingsState({
    required this.themeMode,
    required this.currency,
    required this.notificationsEnabled,
    required this.budgetNotificationsEnabled,
    required this.budgetWarningThreshold,
    required this.isPremium,
  });

  SettingsState copyWith({
    String? themeMode,
    String? currency,
    bool? notificationsEnabled,
    bool? budgetNotificationsEnabled,
    double? budgetWarningThreshold,
    bool? isPremium,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      currency: currency ?? this.currency,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      budgetNotificationsEnabled: budgetNotificationsEnabled ?? this.budgetNotificationsEnabled,
      budgetWarningThreshold: budgetWarningThreshold ?? this.budgetWarningThreshold,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final AppDatabase _db;

  SettingsNotifier(this._db)
      : super(
          SettingsState(
            themeMode: 'dark',
            currency: 'USD',
            notificationsEnabled: true,
            budgetNotificationsEnabled: true,
            budgetWarningThreshold: 80.0,
            isPremium: false,
          ),
        ) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final dbSettings = await _db.getSettings();
      if (dbSettings != null) {
        state = state.copyWith(
          themeMode: dbSettings.themeMode,
          currency: dbSettings.currency,
          notificationsEnabled: dbSettings.notificationsEnabled,
        );
      } else {
        // Insert default settings if none exist
        final defaultSettings = SettingsCompanion(
          themeMode: Value('dark'),
          currency: Value('USD'),
          notificationsEnabled: Value(true),
        );
        await _db.insertSettings(defaultSettings);
      }
    } catch (e) {
      // If there's an error loading settings, use defaults
      state = state.copyWith(
        themeMode: 'dark',
        currency: 'USD',
        notificationsEnabled: true,
      );
    }
  }

  Future<void> toggleThemeMode() async {
    final newThemeMode = state.themeMode == 'dark' ? 'light' : 'dark';
    state = state.copyWith(themeMode: newThemeMode);
    
    try {
      final existingSettings = await _db.getSettings();
      if (existingSettings != null) {
        final updatedSettings = SettingsCompanion(
          id: Value(1),
          themeMode: Value(newThemeMode),
          currency: Value(state.currency),
          notificationsEnabled: Value(state.notificationsEnabled),
        );
        await _db.updateSettings(updatedSettings);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> setCurrency(String currency) async {
    state = state.copyWith(currency: currency);
    
    try {
      final existingSettings = await _db.getSettings();
      if (existingSettings != null) {
        final updatedSettings = SettingsCompanion(
          id: Value(1),
          themeMode: Value(state.themeMode),
          currency: Value(currency),
          notificationsEnabled: Value(state.notificationsEnabled),
        );
        await _db.updateSettings(updatedSettings);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> toggleNotifications(bool value) async {
    state = state.copyWith(notificationsEnabled: value);
    
    try {
      final existingSettings = await _db.getSettings();
      if (existingSettings != null) {
        final updatedSettings = SettingsCompanion(
          id: Value(1),
          themeMode: Value(state.themeMode),
          currency: Value(state.currency),
          notificationsEnabled: Value(value),
        );
        await _db.updateSettings(updatedSettings);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> toggleBudgetNotifications(bool value) async {
    state = state.copyWith(budgetNotificationsEnabled: value);
    
    try {
      final existingSettings = await _db.getSettings();
      if (existingSettings != null) {
        final updatedSettings = SettingsCompanion(
          id: Value(1),
          themeMode: Value(state.themeMode),
          currency: Value(state.currency),
          notificationsEnabled: Value(state.notificationsEnabled),
        );
        await _db.updateSettings(updatedSettings);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> setBudgetWarningThreshold(double threshold) async {
    state = state.copyWith(budgetWarningThreshold: threshold);
    
    try {
      final existingSettings = await _db.getSettings();
      if (existingSettings != null) {
        final updatedSettings = SettingsCompanion(
          id: Value(1),
          themeMode: Value(state.themeMode),
          currency: Value(state.currency),
          notificationsEnabled: Value(state.notificationsEnabled),
        );
        await _db.updateSettings(updatedSettings);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> setPremiumStatus(bool isPremium) async {
    state = state.copyWith(isPremium: isPremium);
    
    try {
      final existingSettings = await _db.getSettings();
      if (existingSettings != null) {
        final updatedSettings = SettingsCompanion(
          id: Value(1),
          themeMode: Value(state.themeMode),
          currency: Value(state.currency),
          notificationsEnabled: Value(state.notificationsEnabled),
        );
        await _db.updateSettings(updatedSettings);
      }
    } catch (e) {
      // Handle error silently
    }
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final db = ref.watch(databaseProvider);
  return SettingsNotifier(db);
});

// Currency provider for easy access to supported currencies
final currenciesProvider = Provider<List<String>>((ref) {
  return AppConstants.supportedCurrencies;
});
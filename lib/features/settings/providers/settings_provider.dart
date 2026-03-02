import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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

  // Regional settings
  final String dateFormat;
  final String numberFormat;

  // Security settings
  final bool biometricLockEnabled;
  final int autoLockTimeoutMinutes;

  SettingsState({
    required this.themeMode,
    required this.currency,
    required this.notificationsEnabled,
    required this.budgetNotificationsEnabled,
    required this.budgetWarningThreshold,
    required this.isPremium,
    this.dateFormat = 'MM/dd/yyyy',
    this.numberFormat = 'comma_dot',
    this.biometricLockEnabled = false,
    this.autoLockTimeoutMinutes = 0,
  });

  SettingsState copyWith({
    String? themeMode,
    String? currency,
    bool? notificationsEnabled,
    bool? budgetNotificationsEnabled,
    double? budgetWarningThreshold,
    bool? isPremium,
    String? dateFormat,
    String? numberFormat,
    bool? biometricLockEnabled,
    int? autoLockTimeoutMinutes,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      currency: currency ?? this.currency,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      budgetNotificationsEnabled:
          budgetNotificationsEnabled ?? this.budgetNotificationsEnabled,
      budgetWarningThreshold:
          budgetWarningThreshold ?? this.budgetWarningThreshold,
      isPremium: isPremium ?? this.isPremium,
      dateFormat: dateFormat ?? this.dateFormat,
      numberFormat: numberFormat ?? this.numberFormat,
      biometricLockEnabled: biometricLockEnabled ?? this.biometricLockEnabled,
      autoLockTimeoutMinutes:
          autoLockTimeoutMinutes ?? this.autoLockTimeoutMinutes,
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
          dateFormat: 'MM/dd/yyyy',
          numberFormat: 'comma_dot',
          biometricLockEnabled: false,
          autoLockTimeoutMinutes: 0,
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
          budgetNotificationsEnabled: dbSettings.budgetNotificationsEnabled,
          budgetWarningThreshold: dbSettings.budgetWarningThreshold,
          dateFormat: dbSettings.dateFormat,
          numberFormat: dbSettings.numberFormat,
          biometricLockEnabled: dbSettings.biometricLockEnabled,
          autoLockTimeoutMinutes: dbSettings.autoLockTimeoutMinutes,
        );
      } else {
        // Insert default settings if none exist
        final defaultSettings = SettingsCompanion(
          themeMode: Value('dark'),
          currency: Value('USD'),
          notificationsEnabled: Value(true),
          budgetNotificationsEnabled: Value(true),
          budgetWarningThreshold: Value(80.0),
          dateFormat: Value('MM/dd/yyyy'),
          numberFormat: Value('comma_dot'),
          biometricLockEnabled: Value(false),
          autoLockTimeoutMinutes: Value(0),
        );
        await _db.insertSettings(defaultSettings);
      }
    } catch (e) {
      // If there's an error loading settings, use defaults
      state = state.copyWith(
        themeMode: 'dark',
        currency: 'USD',
        notificationsEnabled: true,
        budgetNotificationsEnabled: true,
        budgetWarningThreshold: 80.0,
        dateFormat: 'MM/dd/yyyy',
        numberFormat: 'comma_dot',
        biometricLockEnabled: false,
        autoLockTimeoutMinutes: 0,
      );
    }
  }

  Future<void> _saveSettings() async {
    try {
      final updatedSettings = SettingsCompanion(
        id: Value(1),
        themeMode: Value(state.themeMode),
        currency: Value(state.currency),
        notificationsEnabled: Value(state.notificationsEnabled),
        budgetNotificationsEnabled: Value(state.budgetNotificationsEnabled),
        budgetWarningThreshold: Value(state.budgetWarningThreshold),
        dateFormat: Value(state.dateFormat),
        numberFormat: Value(state.numberFormat),
        biometricLockEnabled: Value(state.biometricLockEnabled),
        autoLockTimeoutMinutes: Value(state.autoLockTimeoutMinutes),
      );
      await _db.updateSettings(updatedSettings);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> toggleThemeMode() async {
    final newThemeMode = state.themeMode == 'dark' ? 'light' : 'dark';
    state = state.copyWith(themeMode: newThemeMode);
    await _saveSettings();
  }

  Future<void> setThemeMode(String themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    await _saveSettings();
  }

  Future<void> setCurrency(String currency) async {
    state = state.copyWith(currency: currency);
    await _saveSettings();
  }

  Future<void> toggleNotifications(bool value) async {
    state = state.copyWith(notificationsEnabled: value);
    await _saveSettings();
  }

  Future<void> toggleBudgetNotifications(bool value) async {
    state = state.copyWith(budgetNotificationsEnabled: value);
    await _saveSettings();
  }

  Future<void> setBudgetWarningThreshold(double threshold) async {
    state = state.copyWith(budgetWarningThreshold: threshold);
    await _saveSettings();
  }

  Future<void> setPremiumStatus(bool isPremium) async {
    state = state.copyWith(isPremium: isPremium);
  }

  // Regional settings
  Future<void> setDateFormat(String format) async {
    state = state.copyWith(dateFormat: format);
    await _saveSettings();
  }

  Future<void> setNumberFormat(String format) async {
    state = state.copyWith(numberFormat: format);
    await _saveSettings();
  }

  // Security settings
  Future<void> setBiometricLock(bool enabled) async {
    state = state.copyWith(biometricLockEnabled: enabled);
    await _saveSettings();
  }

  Future<void> setAutoLockTimeout(int minutes) async {
    state = state.copyWith(autoLockTimeoutMinutes: minutes);
    await _saveSettings();
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) {
    final db = ref.watch(databaseProvider);
    return SettingsNotifier(db);
  },
);

// Convenience providers for regional settings
final dateFormatSettingProvider = Provider<String>(
  (ref) => ref.watch(settingsProvider).dateFormat,
);
final numberFormatSettingProvider = Provider<String>(
  (ref) => ref.watch(settingsProvider).numberFormat,
);

// Currency provider for easy access to supported currencies
final currenciesProvider = Provider<List<String>>((ref) {
  return AppConstants.supportedCurrencies;
});

// Date format options
final dateFormatsProvider = Provider<List<Map<String, String>>>((ref) {
  return [
    {'value': 'MM/dd/yyyy', 'label': 'MM/DD/YYYY (01/31/2024)'},
    {'value': 'dd/MM/yyyy', 'label': 'DD/MM/YYYY (31/01/2024)'},
    {'value': 'yyyy-MM-dd', 'label': 'YYYY-MM-DD (2024-01-31)'},
    {'value': 'dd MMM yyyy', 'label': 'DD MMM YYYY (31 Jan 2024)'},
    {'value': 'MMM dd, yyyy', 'label': 'MMM DD, YYYY (Jan 31, 2024)'},
  ];
});

// Number format options
final numberFormatsProvider = Provider<List<Map<String, String>>>((ref) {
  return [
    {'value': 'comma_dot', 'label': '1,234.56 (Comma for thousands)'},
    {'value': 'dot_comma', 'label': '1.234,56 (Dot for thousands)'},
    {'value': 'space_comma', 'label': '1 234,56 (Space for thousands)'},
    {'value': 'none_dot', 'label': '1234.56 (No separator)'},
  ];
});

// Auto-lock timeout options
final autoLockTimeoutsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return [
    {'value': 0, 'label': 'Immediately'},
    {'value': 1, 'label': '1 minute'},
    {'value': 5, 'label': '5 minutes'},
    {'value': 15, 'label': '15 minutes'},
    {'value': 30, 'label': '30 minutes'},
    {'value': -1, 'label': 'Never'},
  ];
});

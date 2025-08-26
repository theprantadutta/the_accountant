import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/services/backup_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BackupState {
  final bool isBackingUp;
  final bool isRestoring;
  final String? errorMessage;
  final List<Map<String, dynamic>> availableBackups;
  final bool isBackupAvailable;
  final bool useEncryptedBackup; // New field for encrypted backup option

  BackupState({
    this.isBackingUp = false,
    this.isRestoring = false,
    this.errorMessage,
    this.availableBackups = const [],
    this.isBackupAvailable = false,
    this.useEncryptedBackup = false, // Default to false
  });

  BackupState copyWith({
    bool? isBackingUp,
    bool? isRestoring,
    String? errorMessage,
    List<Map<String, dynamic>>? availableBackups,
    bool? isBackupAvailable,
    bool? useEncryptedBackup,
  }) {
    return BackupState(
      isBackingUp: isBackingUp ?? this.isBackingUp,
      isRestoring: isRestoring ?? this.isRestoring,
      errorMessage: errorMessage ?? this.errorMessage,
      availableBackups: availableBackups ?? this.availableBackups,
      isBackupAvailable: isBackupAvailable ?? this.isBackupAvailable,
      useEncryptedBackup: useEncryptedBackup ?? this.useEncryptedBackup,
    );
  }
}

class BackupNotifier extends StateNotifier<BackupState> {
  final BackupService _backupService;

  BackupNotifier(this._backupService) : super(BackupState()) {
    _loadAvailableBackups();
  }

  /// Create a backup and upload to Google Drive
  Future<void> createBackup({bool encrypted = false}) async {
    state = state.copyWith(isBackingUp: true, errorMessage: null);
    
    try {
      final success = await _backupService.createBackup(encrypted: encrypted);
      
      if (success) {
        state = state.copyWith(
          isBackingUp: false, 
          isBackupAvailable: true,
          useEncryptedBackup: encrypted,
        );
        // Refresh the list of available backups
        await _loadAvailableBackups();
      } else {
        state = state.copyWith(
          isBackingUp: false,
          errorMessage: 'Failed to create backup',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isBackingUp: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Restore from a backup
  Future<void> restoreFromBackup(String fileId, {bool encrypted = false}) async {
    state = state.copyWith(isRestoring: true, errorMessage: null);
    
    try {
      final success = await _backupService.restoreFromBackup(fileId, encrypted: encrypted);
      
      if (success) {
        state = state.copyWith(
          isRestoring: false,
          useEncryptedBackup: encrypted,
        );
        // Refresh the list of available backups
        await _loadAvailableBackups();
      } else {
        state = state.copyWith(
          isRestoring: false,
          errorMessage: 'Failed to restore backup',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isRestoring: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Toggle encrypted backup option
  void toggleEncryptedBackup(bool value) {
    state = state.copyWith(useEncryptedBackup: value);
  }

  /// Load available backups from Google Drive
  Future<void> _loadAvailableBackups() async {
    try {
      final backups = await _backupService.listBackups();
      state = state.copyWith(
        availableBackups: backups,
        isBackupAvailable: backups.isNotEmpty,
      );
    } catch (e) {
      // Handle error silently
    }
  }

  /// Save Google Drive credentials
  Future<void> saveGoogleDriveCredentials(String accessToken, String refreshToken) async {
    // This method is not needed anymore as we're using Google Sign-In directly
  }
}

final backupServiceProvider = Provider<BackupService>((ref) {
  final secureStorage = const FlutterSecureStorage();
  return BackupService(secureStorage);
});

final backupProvider = StateNotifierProvider<BackupNotifier, BackupState>((ref) {
  final backupService = ref.watch(backupServiceProvider);
  return BackupNotifier(backupService);
});
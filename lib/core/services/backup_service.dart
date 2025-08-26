import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path_provider/path_provider.dart';

class BackupService {
  final FlutterSecureStorage _secureStorage;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  GoogleSignInAccount? _currentUser;
  bool _isInitialized = false;

  BackupService(this._secureStorage);

  // Initialize Google Sign-In with proper scopes
  Future<void> _initGoogleSignIn() async {
    if (!_isInitialized) {
      await _googleSignIn.initialize();
      _isInitialized = true;
    }
  }

  /// Create a backup of all app data and upload to Google Drive
  Future<bool> createBackup({bool encrypted = false}) async {
    try {
      // Get the database file path
      final dbFolder = await getApplicationDocumentsDirectory();
      final dbFile = File('${dbFolder.path}/db.sqlite');

      if (!await dbFile.exists()) {
        throw Exception('Database file not found');
      }

      // Read the database file
      final dbBytes = await dbFile.readAsBytes();

      // Create backup data
      final backupData = {
        'timestamp': DateTime.now().toIso8601String(),
        'database': base64Encode(dbBytes),
      };

      // Convert to JSON
      var backupJson = jsonEncode(backupData);

      // Encrypt if requested
      if (encrypted) {
        backupJson = await _encryptBackup(backupJson);
      }

      // Save to a temporary file
      final tempDir = await getTemporaryDirectory();
      final backupFile = File('${tempDir.path}/backup.json');
      await backupFile.writeAsString(backupJson);

      // Upload to Google Drive
      final success = await _uploadToGoogleDrive(
        backupFile,
        encrypted: encrypted,
      );

      // Clean up temporary file
      await backupFile.delete();

      return success;
    } catch (e) {
      // Handle error
      return false;
    }
  }

  /// Restore data from Google Drive backup
  Future<bool> restoreFromBackup(
    String fileId, {
    bool encrypted = false,
  }) async {
    try {
      // Download backup from Google Drive
      final backupData = await _downloadFromGoogleDrive(fileId);

      if (backupData == null) {
        return false;
      }

      // Decrypt if needed
      var processedBackupData = backupData;
      if (encrypted) {
        processedBackupData = await _decryptBackup(backupData);
      }

      // Parse the backup data
      final backupJson = jsonDecode(processedBackupData);
      final dbBase64 = backupJson['database'] as String;
      final dbBytes = base64Decode(dbBase64);

      // Write to database file
      final dbFolder = await getApplicationDocumentsDirectory();
      final dbFile = File('${dbFolder.path}/db.sqlite');
      await dbFile.writeAsBytes(dbBytes);

      return true;
    } catch (e) {
      // Handle error
      return false;
    }
  }

  /// Get list of available backups from Google Drive
  Future<List<Map<String, dynamic>>> listBackups() async {
    try {
      return await _listGoogleDriveBackups();
    } catch (e) {
      // Handle error
      return [];
    }
  }

  /// Upload backup file to Google Drive
  Future<bool> _uploadToGoogleDrive(
    File backupFile, {
    bool encrypted = false,
  }) async {
    try {
      // Get authenticated Google Drive client
      final driveApi = await _getAuthenticatedDriveClient();
      if (driveApi == null) return false;

      // Create file metadata
      final fileName = encrypted
          ? 'the_accountant_backup_encrypted_${DateTime.now().millisecondsSinceEpoch}.json'
          : 'the_accountant_backup_${DateTime.now().millisecondsSinceEpoch}.json';

      final fileMetadata = drive.File()
        ..name = fileName
        ..parents = ['appDataFolder'];

      // Upload file
      final media = drive.Media(
        backupFile.openRead(),
        await backupFile.length(),
      );
      await driveApi.files.create(fileMetadata, uploadMedia: media);

      return true;
    } catch (e) {
      // Handle error
      return false;
    }
  }

  /// Download backup file from Google Drive
  Future<String?> _downloadFromGoogleDrive(String fileId) async {
    try {
      // Get authenticated Google Drive client
      final driveApi = await _getAuthenticatedDriveClient();
      if (driveApi == null) return null;

      // Download file
      final response = await driveApi.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      );

      if (response is drive.Media) {
        // Read the response
        final bytesBuilder = BytesBuilder();
        await response.stream
            .listen((data) => bytesBuilder.add(data), onDone: () async {})
            .asFuture();

        final backupData = utf8.decode(bytesBuilder.takeBytes());
        return backupData;
      }

      return null;
    } catch (e) {
      // Handle error
      return null;
    }
  }

  /// List backup files from Google Drive
  Future<List<Map<String, dynamic>>> _listGoogleDriveBackups() async {
    try {
      // Get authenticated Google Drive client
      final driveApi = await _getAuthenticatedDriveClient();
      if (driveApi == null) return [];

      // List files
      final result = await driveApi.files.list(
        spaces: 'appDataFolder',
        q: "name contains 'the_accountant_backup_' and mimeType = 'application/json'",
      );

      final backups = <Map<String, dynamic>>[];
      if (result.files != null) {
        for (final file in result.files!) {
          backups.add({
            'id': file.id,
            'name': file.name,
            'createdTime': file.createdTime,
          });
        }
      }

      return backups;
    } catch (e) {
      // Handle error
      return [];
    }
  }

  /// Get authenticated Google Drive client
  Future<drive.DriveApi?> _getAuthenticatedDriveClient() async {
    try {
      // Initialize Google Sign-In
      await _initGoogleSignIn();

      // Try lightweight authentication first
      final result = _googleSignIn.attemptLightweightAuthentication();
      if (result is Future<GoogleSignInAccount?>) {
        _currentUser = await result;
      } else {
        _currentUser = result as GoogleSignInAccount?;
      }

      // Check if user is already signed in
      if (_currentUser == null) {
        // If not signed in, try to authenticate
        if (!_googleSignIn.supportsAuthenticate()) {
          return null;
        }

        // Authenticate with Google
        _currentUser = await _googleSignIn.authenticate(
          scopeHint: ['https://www.googleapis.com/auth/drive.appdata'],
        );
        if (_currentUser == null) return null;
      }

      // Get authorization for Drive scopes
      final authzClient = _googleSignIn.authorizationClient;
      final authorization = await authzClient.authorizationForScopes([
        'https://www.googleapis.com/auth/drive.appdata',
      ]);

      if (authorization == null) return null;

      // Create authenticated HTTP client using the authClient extension
      final authenticatedClient = authorization.authClient(
        scopes: ['https://www.googleapis.com/auth/drive.appdata'],
      );

      // Create Drive API client with authenticated client
      final driveApi = drive.DriveApi(authenticatedClient);
      return driveApi;
    } catch (e) {
      // Handle error
      return null;
    }
  }

  /// Save Google Drive API credentials
  Future<void> saveGoogleDriveCredentials(
    String accessToken,
    String refreshToken,
  ) async {
    try {
      await _secureStorage.write(
        key: 'google_drive_access_token',
        value: accessToken,
      );
      await _secureStorage.write(
        key: 'google_drive_refresh_token',
        value: refreshToken,
      );
    } catch (e) {
      // Handle error
    }
  }

  /// Generate a key for encryption from user's credentials
  Future<String> _generateEncryptionKey() async {
    try {
      // Get user ID from secure storage
      final userId = await _secureStorage.read(key: 'user_id');
      if (userId == null) {
        throw Exception('User ID not found');
      }

      // Generate a key based on user ID
      final bytes = utf8.encode(userId);
      final digest = sha256.convert(bytes);
      return digest.toString();
    } catch (e) {
      // Fallback to a random key if user ID is not available
      final random = Random.secure();
      final values = List<int>.generate(32, (i) => random.nextInt(256));
      return base64Encode(values);
    }
  }

  /// Simple XOR encryption for backup data
  Future<String> _encryptBackup(String plainText) async {
    try {
      final key = await _generateEncryptionKey();
      final keyBytes = utf8.encode(key);
      final textBytes = utf8.encode(plainText);

      final encryptedBytes = <int>[];
      for (var i = 0; i < textBytes.length; i++) {
        encryptedBytes.add(textBytes[i] ^ keyBytes[i % keyBytes.length]);
      }

      // Encode to base64 for safe storage
      return base64Encode(encryptedBytes);
    } catch (e) {
      // If encryption fails, return original text
      return plainText;
    }
  }

  /// Simple XOR decryption for backup data
  Future<String> _decryptBackup(String encryptedText) async {
    try {
      final key = await _generateEncryptionKey();
      final keyBytes = utf8.encode(key);
      final encryptedBytes = base64Decode(encryptedText);

      final decryptedBytes = <int>[];
      for (var i = 0; i < encryptedBytes.length; i++) {
        decryptedBytes.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
      }

      return utf8.decode(decryptedBytes);
    } catch (e) {
      // If decryption fails, return original text
      return encryptedText;
    }
  }
}

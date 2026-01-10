import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:the_accountant/core/services/api_service.dart';

/// Service for registering and managing FCM tokens with the backend.
class FcmRegistrationService {
  final ApiService _apiService;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Logger _logger = Logger();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static final FcmRegistrationService _instance =
      FcmRegistrationService._internal(ApiService());
  factory FcmRegistrationService() => _instance;
  FcmRegistrationService._internal(this._apiService);

  /// Get or generate a unique device ID.
  Future<String> getDeviceId() async {
    // Try to get stored device ID first
    String? deviceId = await _storage.read(key: 'device_id');

    if (deviceId == null) {
      // Generate a new device ID based on platform
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? DateTime.now().millisecondsSinceEpoch.toString();
      } else {
        deviceId = DateTime.now().millisecondsSinceEpoch.toString();
      }

      // Store the device ID for future use
      await _storage.write(key: 'device_id', value: deviceId);
    }

    return deviceId;
  }

  /// Get device model information.
  Future<String?> getDeviceModel() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return '${androidInfo.manufacturer} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.utsname.machine;
      }
    } catch (e) {
      _logger.w('Failed to get device model: $e');
    }
    return null;
  }

  /// Get the current app version.
  Future<String?> getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return '${packageInfo.version}+${packageInfo.buildNumber}';
    } catch (e) {
      _logger.w('Failed to get app version: $e');
    }
    return null;
  }

  /// Get the platform string.
  String getPlatform() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (kIsWeb) return 'web';
    return 'unknown';
  }

  /// Register the current device's FCM token with the backend.
  Future<bool> registerToken() async {
    try {
      // Get FCM token
      final fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken == null) {
        _logger.w('FCM token is null, cannot register device');
        return false;
      }

      final deviceId = await getDeviceId();
      final deviceModel = await getDeviceModel();
      final appVersion = await getAppVersion();
      final platform = getPlatform();

      _logger.i('Registering device with FCM token...');
      _logger.d('Device ID: $deviceId, Platform: $platform');

      await _apiService.post(
        '/devices/register',
        data: {
          'fcm_token': fcmToken,
          'device_id': deviceId,
          'platform': platform,
          'device_model': deviceModel,
          'app_version': appVersion,
        },
      );

      // Store the registered token locally
      await _storage.write(key: 'registered_fcm_token', value: fcmToken);

      _logger.i('Device registered successfully');
      return true;
    } catch (e) {
      _logger.e('Failed to register device: $e');
      return false;
    }
  }

  /// Unregister the current device from the backend.
  Future<bool> unregisterDevice() async {
    try {
      final deviceId = await getDeviceId();

      _logger.i('Unregistering device...');

      await _apiService.delete('/devices/$deviceId');

      // Clear the stored token
      await _storage.delete(key: 'registered_fcm_token');

      _logger.i('Device unregistered successfully');
      return true;
    } catch (e) {
      _logger.e('Failed to unregister device: $e');
      return false;
    }
  }

  /// Set up a listener for FCM token refresh.
  void setupTokenRefreshListener() {
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      _logger.i('FCM token refreshed, re-registering device...');

      final storedToken = await _storage.read(key: 'registered_fcm_token');

      // Only re-register if we have a stored token (meaning user is logged in)
      if (storedToken != null) {
        await registerToken();
      }
    });
  }

  /// Check if the current FCM token is registered.
  Future<bool> isTokenRegistered() async {
    final storedToken = await _storage.read(key: 'registered_fcm_token');
    final currentToken = await _firebaseMessaging.getToken();
    return storedToken != null && storedToken == currentToken;
  }

  /// Get registered devices for the current user.
  Future<List<Map<String, dynamic>>> getRegisteredDevices() async {
    try {
      final response = await _apiService.get('/devices');
      final devices = response.data as List;
      return devices.cast<Map<String, dynamic>>();
    } catch (e) {
      _logger.e('Failed to get registered devices: $e');
      return [];
    }
  }
}

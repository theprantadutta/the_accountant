import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStorage {
  static const _storage = FlutterSecureStorage();

  // Keys for storing different types of tokens
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userIdKey = 'user_id';
  static const _userEmailKey = 'user_email';

  // Store access token
  static Future<void> storeAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  // Retrieve access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // Store refresh token
  static Future<void> storeRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  // Retrieve refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // Store user ID
  static Future<void> storeUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  // Retrieve user ID
  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  // Store user email
  static Future<void> storeUserEmail(String email) async {
    await _storage.write(key: _userEmailKey, value: email);
  }

  // Retrieve user email
  static Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  // Clear all tokens (for logout)
  static Future<void> clearAllTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _userEmailKey);
  }

  // Check if user is logged in (has user ID)
  static Future<bool> isLoggedIn() async {
    final userId = await getUserId();
    return userId != null && userId.isNotEmpty;
  }
}

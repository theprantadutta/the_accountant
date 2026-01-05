import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStorage {
  // Use platform-specific secure storage options
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    wOptions: WindowsOptions(),
  );

  // Keys for storing different types of tokens
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _tokenExpiryKey = 'token_expiry';  // Unix timestamp in milliseconds
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

  // Store token expiry (takes expiresIn in seconds, stores as Unix timestamp)
  static Future<void> storeTokenExpiry(int expiresInSeconds) async {
    final expiryTimestamp = DateTime.now().millisecondsSinceEpoch + (expiresInSeconds * 1000);
    await _storage.write(key: _tokenExpiryKey, value: expiryTimestamp.toString());
  }

  // Get token expiry timestamp
  static Future<int?> getTokenExpiry() async {
    final expiry = await _storage.read(key: _tokenExpiryKey);
    return expiry != null ? int.tryParse(expiry) : null;
  }

  // Check if token is expiring soon (less than 2 minutes remaining)
  static Future<bool> isTokenExpiringSoon() async {
    final expiry = await getTokenExpiry();
    if (expiry == null) return true;  // No expiry means we should refresh

    final now = DateTime.now().millisecondsSinceEpoch;
    final twoMinutesInMs = 2 * 60 * 1000;
    return (expiry - now) < twoMinutesInMs;
  }

  // Check if token is expired
  static Future<bool> isTokenExpired() async {
    final expiry = await getTokenExpiry();
    if (expiry == null) return true;
    return DateTime.now().millisecondsSinceEpoch >= expiry;
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
    await _storage.delete(key: _tokenExpiryKey);
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _userEmailKey);
  }

  // Check if user is logged in (has user ID)
  static Future<bool> isLoggedIn() async {
    final userId = await getUserId();
    return userId != null && userId.isNotEmpty;
  }
}

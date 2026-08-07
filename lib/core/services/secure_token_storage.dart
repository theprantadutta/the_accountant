import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStorage {
  // Use platform-specific secure storage options
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    wOptions: WindowsOptions(),
  );

  // Keys for storing different types of tokens.
  //
  // 'auth_token' rather than 'access_token': ApiService has always written the
  // access token under that name, while this class read and cleared a key nothing
  // ever wrote. clearAllTokens therefore left the real token behind, and
  // getAccessToken always returned null. One key, one owner.
  static const _accessTokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _tokenExpiryKey =
      'token_expiry'; // Unix timestamp in milliseconds
  static const _userIdKey = 'user_id';
  static const _userEmailKey = 'user_email';

  // Cached premium entitlement (moved out of plaintext SharedPreferences).
  static const _premiumTierKey = 'premium_tier';
  static const _premiumExpiresAtKey = 'premium_expires_at';
  static const _premiumPurchaseIdKey = 'premium_purchase_id';

  /// Persist the cached premium entitlement in secure storage. This is only a UX cache —
  /// the backend remains the source of truth — but keeping it out of plaintext prefs makes
  /// it harder to flip client-only premium (themes, etc.) by editing an unencrypted file.
  static Future<void> storePremiumEntitlement({
    required String tier,
    String? expiresAtIso,
    String? purchaseId,
  }) async {
    await _storage.write(key: _premiumTierKey, value: tier);
    if (expiresAtIso != null) {
      await _storage.write(key: _premiumExpiresAtKey, value: expiresAtIso);
    } else {
      await _storage.delete(key: _premiumExpiresAtKey);
    }
    if (purchaseId != null) {
      await _storage.write(key: _premiumPurchaseIdKey, value: purchaseId);
    } else {
      await _storage.delete(key: _premiumPurchaseIdKey);
    }
  }

  static Future<({String? tier, String? expiresAtIso, String? purchaseId})>
  getPremiumEntitlement() async {
    return (
      tier: await _storage.read(key: _premiumTierKey),
      expiresAtIso: await _storage.read(key: _premiumExpiresAtKey),
      purchaseId: await _storage.read(key: _premiumPurchaseIdKey),
    );
  }

  static Future<void> clearPremiumEntitlement() async {
    await _storage.delete(key: _premiumTierKey);
    await _storage.delete(key: _premiumExpiresAtKey);
    await _storage.delete(key: _premiumPurchaseIdKey);
  }

  // Store access token
  static Future<void> storeAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  // Retrieve access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // Clear only the access token, leaving the refresh token in place
  static Future<void> clearAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
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
    final expiryTimestamp =
        DateTime.now().millisecondsSinceEpoch + (expiresInSeconds * 1000);
    await _storage.write(
      key: _tokenExpiryKey,
      value: expiryTimestamp.toString(),
    );
  }

  // Get token expiry timestamp
  static Future<int?> getTokenExpiry() async {
    final expiry = await _storage.read(key: _tokenExpiryKey);
    return expiry != null ? int.tryParse(expiry) : null;
  }

  // Check if token is expiring soon (less than 10 minutes remaining)
  // Using 10 minutes buffer to ensure there's enough time to refresh
  static Future<bool> isTokenExpiringSoon() async {
    final expiry = await getTokenExpiry();
    if (expiry == null) return true; // No expiry means we should refresh

    final now = DateTime.now().millisecondsSinceEpoch;
    final tenMinutesInMs = 10 * 60 * 1000;
    return (expiry - now) < tenMinutesInMs;
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

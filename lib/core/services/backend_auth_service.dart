import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'api_service.dart';
import 'secure_token_storage.dart';

/// Backend authentication service with state management.
///
/// A singleton. It was previously constructed in five places, each holding its own
/// independent auth state while ApiService (which *is* a singleton) could only ever
/// call back into whichever instance registered onUnauthorized last — so state
/// changes made through one instance were invisible to the rest of the app.
class BackendAuthService extends ChangeNotifier {
  static final BackendAuthService _instance = BackendAuthService._internal();
  factory BackendAuthService() => _instance;
  BackendAuthService._internal();

  final ApiService _apiService = ApiService();

  bool _isInitializing = true;
  bool _isAuthenticated = false;
  bool _isPremium = false;
  String? _userEmail;
  String? _userId;
  String? _displayName;
  String? _photoUrl;
  String _subscriptionTier = 'free';
  DateTime? _subscriptionExpiresAt;
  DateTime? _createdAt;

  bool get isInitializing => _isInitializing;
  bool get isAuthenticated => _isAuthenticated;
  bool get isPremium => _isPremium;
  String? get userEmail => _userEmail;
  String? get userId => _userId;
  String? get userDisplayName => _displayName;
  String? get userPhotoUrl => _photoUrl;
  String get subscriptionTier => _subscriptionTier;
  DateTime? get subscriptionExpiresAt => _subscriptionExpiresAt;
  DateTime? get userCreatedAt => _createdAt;

  /// Initialize authentication state
  Future<void> initialize() async {
    _isInitializing = true;
    notifyListeners();

    // Set up 401 unauthorized handler
    _apiService.onUnauthorized = _handleUnauthorized;

    try {
      // Check if we have a token
      final hasToken = await _apiService.hasToken();

      if (hasToken) {
        // First, load cached user info for instant auth restoration
        final cachedInfo = await _apiService.getCachedUserInfo();

        if (cachedInfo != null) {
          debugPrint(
            '[BackendAuthService] Restoring auth from cached user info',
          );
          _userId = cachedInfo['id'];
          _userEmail = cachedInfo['email'];
          _displayName = cachedInfo['display_name'];
          _photoUrl = cachedInfo['photo_url'];
          _isPremium = cachedInfo['is_premium'] ?? false;
          _subscriptionTier = cachedInfo['subscription_tier'] ?? 'free';
          _isAuthenticated = true;
          notifyListeners();

          // Reconcile with the server without blocking startup.
          unawaited(_refreshUserInfoInBackground());
        } else {
          // A token but no cached profile — cache cleared, or a reinstall that
          // restored the keychain. Trust the token and resolve the profile before
          // finishing init, otherwise initialization completes as "signed out" and
          // the sign-in screen flashes before the app jumps back in. If the token
          // really is dead, the 401 handler forces a logout from here.
          debugPrint(
            '[BackendAuthService] Token present without cached profile - verifying',
          );
          _isAuthenticated = true;
          await _refreshUserInfoInBackground();
        }
      }
    } catch (e) {
      debugPrint('Auth initialization error: $e');
      // Don't set _isAuthenticated = false here - keep cached state
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  /// Refresh user info in background without affecting auth state on failure.
  /// Uses a shorter timeout since we already have cached data.
  Future<void> _refreshUserInfoInBackground() async {
    try {
      debugPrint('[BackendAuthService] Refreshing user info in background...');
      final userInfo = await _apiService.getCurrentUser(
        timeout: const Duration(seconds: 5),
      );
      _applyUserInfo(userInfo);
      await _apiService.saveUserInfo(userInfo);
      debugPrint('[BackendAuthService] Background refresh successful');
    } catch (e) {
      // Don't logout on network errors - the 401 handler will handle invalid tokens
      debugPrint(
        '[BackendAuthService] Background refresh failed (keeping cached state): $e',
      );
    }
  }

  /// Handle 401 unauthorized response - force logout from both backend and Firebase
  void _handleUnauthorized() {
    debugPrint('[BackendAuthService] Handling 401 - forcing logout');
    forceLogout();
  }

  /// Force logout user (used when receiving 401 from backend)
  Future<void> forceLogout() async {
    debugPrint('[BackendAuthService] Force logout triggered');

    // Clear local state
    _isAuthenticated = false;
    _isPremium = false;
    _userEmail = null;
    _userId = null;
    _displayName = null;
    _photoUrl = null;
    _subscriptionTier = 'free';
    _subscriptionExpiresAt = null;
    _createdAt = null;

    // Clear all stored tokens
    await SecureTokenStorage.clearAllTokens();

    // Sign out from Firebase (this will trigger the AuthWrapper to show login)
    try {
      await _firebaseSignOutIfAvailable();
      debugPrint('[BackendAuthService] Firebase sign out successful');
    } catch (e) {
      debugPrint('[BackendAuthService] Firebase sign out error: $e');
    }

    notifyListeners();
  }

  /// Register new user
  Future<void> register(String email, String password) async {
    final Map<String, dynamic> response;
    try {
      response = await _apiService.register(email, password);
    } on ApiException {
      // Propagate unchanged: wrapping it would discard the status code the UI
      // needs to tell a taken email from an outage.
      rethrow;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }

    _userId = response['user_id'];
    _userEmail = email;
    _isAuthenticated = true;

    // Tokens are stored and the account exists — a failed profile fetch must not
    // be reported as a failed registration, or the user retries and is told the
    // email is already taken.
    await _tryRefreshUserInfo();

    notifyListeners();
  }

  /// Login user
  Future<void> login(String email, String password) async {
    final Map<String, dynamic> response;
    try {
      response = await _apiService.login(email, password);
    } on ApiException {
      // Propagate unchanged: wrapping it would discard the status code the UI
      // needs to tell a rejected password from an outage.
      rethrow;
    } catch (e) {
      throw Exception('Login failed: $e');
    }

    _userId = response['user_id'];
    _userEmail = email;
    _isAuthenticated = true;

    // Same here: the credentials were accepted, so a flaky /auth/me is a cosmetic
    // problem, not a login failure.
    await _tryRefreshUserInfo();

    notifyListeners();
  }

  /// Best-effort profile fetch for paths where authentication has already
  /// succeeded and only the profile detail is missing.
  Future<void> _tryRefreshUserInfo() async {
    try {
      await refreshUserInfo();
    } catch (e) {
      debugPrint(
        '[BackendAuthService] Profile fetch failed after auth (non-fatal): $e',
      );
    }
  }

  /// Logout user. Revokes only this device's session unless [allDevices] is set.
  Future<void> logout({bool allDevices = false}) async {
    try {
      await _apiService.logout(allDevices: allDevices);
    } catch (e) {
      debugPrint('Logout error: $e');
    } finally {
      _isAuthenticated = false;
      _isPremium = false;
      _userEmail = null;
      _userId = null;
      _displayName = null;
      _photoUrl = null;
      _subscriptionTier = 'free';
      _subscriptionExpiresAt = null;
      _createdAt = null;

      notifyListeners();
    }
  }

  /// Authenticate with Firebase token (Google Sign-In)
  Future<void> authenticateWithGoogle(String firebaseToken) async {
    try {
      debugPrint('[BackendAuthService] Authenticating with Firebase token...');
      final response = await _apiService.authenticateWithFirebase(
        firebaseToken,
      );
      debugPrint('[BackendAuthService] Authentication response received');
      debugPrint('   - Response keys: ${response.keys}');

      _userId = response['user_id'];
      _isAuthenticated = true;
      debugPrint('[BackendAuthService] User authenticated, ID: $_userId');

      // Fetch full user info (non-fatal: the session is already established)
      debugPrint('[BackendAuthService] Fetching full user info...');
      await _tryRefreshUserInfo();
      debugPrint('[BackendAuthService] User info loaded: $_userEmail');

      notifyListeners();
    } on AccountLinkingRequiredException {
      // Re-throw account linking exceptions so they can be handled by the UI
      debugPrint('[BackendAuthService] Account linking required');
      rethrow;
    } on ApiException catch (e) {
      // Propagate unchanged so the UI can distinguish a backend outage from a
      // rejected token. Both used to surface as "an error occurred".
      debugPrint(
        '[BackendAuthService] Backend rejected the Firebase token: '
        '${e.statusCode} ${e.message}',
      );
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('[BackendAuthService] Google authentication failed: $e');
      debugPrint('[BackendAuthService] Stack trace: $stackTrace');
      throw Exception('Google authentication failed: $e');
    }
  }

  /// Link Google account to existing account (requires password verification)
  /// This also logs the user in after successful linking
  Future<void> linkGoogleAccount({
    required String firebaseToken,
    required String password,
  }) async {
    try {
      final response = await _apiService.linkGoogleAccount(
        firebaseToken: firebaseToken,
        password: password,
      );

      // Update local state - user is now authenticated
      _userId = response['user_id'];
      _isAuthenticated = true;

      // Refresh user info to get full profile (non-fatal)
      await _tryRefreshUserInfo();

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to link Google account: $e');
    }
  }

  /// Unlink Google account from current account
  Future<void> unlinkGoogleAccount() async {
    try {
      await _apiService.unlinkGoogleAccount();

      // Refresh user info to get updated linked accounts
      await refreshUserInfo();

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to unlink Google account: $e');
    }
  }

  /// Get linked authentication providers
  Future<Map<String, dynamic>> getAuthProviders() async {
    try {
      final response = await _apiService.getAuthProviders();
      return response;
    } catch (e) {
      throw Exception('Failed to get auth providers: $e');
    }
  }

  /// Change or set password
  Future<void> changePassword({
    String? currentPassword,
    required String newPassword,
  }) async {
    try {
      await _apiService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      throw Exception('$e');
    }
  }

  /// Request a password-reset code be emailed to [email].
  Future<void> forgotPassword(String email) async {
    try {
      await _apiService.forgotPassword(email.trim());
    } catch (e) {
      throw Exception('$e');
    }
  }

  /// Complete a password reset with the emailed [code] and a [newPassword].
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      await _apiService.resetPassword(
        email: email.trim(),
        code: code.trim(),
        newPassword: newPassword,
      );
    } catch (e) {
      throw Exception('$e');
    }
  }

  /// Apply user info map to local state and notify listeners
  void _applyUserInfo(Map<String, dynamic> userInfo) {
    _userId = userInfo['id'];
    _userEmail = userInfo['email'];
    _displayName = userInfo['display_name'];
    _photoUrl = userInfo['photo_url'];
    _isPremium = userInfo['is_premium'] ?? false;
    _subscriptionTier = userInfo['subscription_tier'] ?? 'free';
    _isAuthenticated = true;

    if (userInfo['subscription_expires_at'] != null) {
      _subscriptionExpiresAt = DateTime.parse(
        userInfo['subscription_expires_at'],
      );
    }

    if (userInfo['created_at'] != null) {
      _createdAt = DateTime.parse(userInfo['created_at']);
    }

    debugPrint(
      '[BackendAuthService] User info applied: email=$_userEmail, displayName=$_displayName',
    );

    notifyListeners();
  }

  /// Refresh user information and subscription status
  Future<void> refreshUserInfo() async {
    try {
      final userInfo = await _apiService.getCurrentUser();
      _applyUserInfo(userInfo);
      await _apiService.saveUserInfo(userInfo);
    } catch (e) {
      throw Exception('Failed to fetch user info: $e');
    }
  }

  /// Update user profile
  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    try {
      final data = <String, dynamic>{};
      if (displayName != null) data['display_name'] = displayName;
      if (photoUrl != null) data['photo_url'] = photoUrl;

      if (data.isEmpty) return;

      await _apiService.put('/auth/me', data: data);

      // Update local state
      if (displayName != null) _displayName = displayName;
      if (photoUrl != null) _photoUrl = photoUrl;

      notifyListeners();
    } catch (e) {
      debugPrint('Profile update error: $e');
      rethrow;
    }
  }
}

/// Sign out of Firebase when it is available.
///
/// Firebase is optional at runtime (and absent in tests); a missing app must not
/// turn signing out into an error, because the user would then be stuck in a
/// session they explicitly asked to end.
Future<void> _firebaseSignOutIfAvailable() async {
  try {
    await FirebaseAuth.instance.signOut();
  } catch (_) {
    // No Firebase app configured, or no Firebase session to end.
  }
}

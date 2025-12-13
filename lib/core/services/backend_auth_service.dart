import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'api_service.dart';

/// Backend authentication service with state management
class BackendAuthService extends ChangeNotifier {
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

  bool get isInitializing => _isInitializing;
  bool get isAuthenticated => _isAuthenticated;
  bool get isPremium => _isPremium;
  String? get userEmail => _userEmail;
  String? get userId => _userId;
  String? get userDisplayName => _displayName;
  String? get userPhotoUrl => _photoUrl;
  String get subscriptionTier => _subscriptionTier;
  DateTime? get subscriptionExpiresAt => _subscriptionExpiresAt;

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
        // Try to fetch current user
        await refreshUserInfo();
      }
    } catch (e) {
      debugPrint('Auth initialization error: $e');
      _isAuthenticated = false;
    } finally {
      _isInitializing = false;
      notifyListeners();
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

    // Sign out from Firebase (this will trigger the AuthWrapper to show login)
    try {
      await FirebaseAuth.instance.signOut();
      debugPrint('[BackendAuthService] Firebase sign out successful');
    } catch (e) {
      debugPrint('[BackendAuthService] Firebase sign out error: $e');
    }

    notifyListeners();
  }

  /// Register new user
  Future<void> register(String email, String password) async {
    try {
      final response = await _apiService.register(email, password);

      _userId = response['user_id'];
      _userEmail = email;
      _isAuthenticated = true;

      // Fetch full user info
      await refreshUserInfo();

      notifyListeners();
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  /// Login user
  Future<void> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);

      _userId = response['user_id'];
      _userEmail = email;
      _isAuthenticated = true;

      // Fetch full user info
      await refreshUserInfo();

      notifyListeners();
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _apiService.logout();
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

      notifyListeners();
    }
  }

  /// Authenticate with Firebase token (Google Sign-In)
  Future<void> authenticateWithGoogle(String firebaseToken) async {
    try {
      debugPrint(
        '[BackendAuthService] Authenticating with Firebase token...',
      );
      final response = await _apiService.authenticateWithFirebase(
        firebaseToken,
      );
      debugPrint('[BackendAuthService] Authentication response received');
      debugPrint('   - Response keys: ${response.keys}');

      _userId = response['user_id'];
      _isAuthenticated = true;
      debugPrint('[BackendAuthService] User authenticated, ID: $_userId');

      // Fetch full user info
      debugPrint('[BackendAuthService] Fetching full user info...');
      await refreshUserInfo();
      debugPrint('[BackendAuthService] User info loaded: $_userEmail');

      notifyListeners();
    } on AccountLinkingRequiredException {
      // Re-throw account linking exceptions so they can be handled by the UI
      debugPrint('[BackendAuthService] Account linking required');
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

      // Refresh user info to get full profile
      await refreshUserInfo();

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

  /// Refresh user information and subscription status
  Future<void> refreshUserInfo() async {
    try {
      final userInfo = await _apiService.getCurrentUser();

      _userId = userInfo['id'];
      _userEmail = userInfo['email'];
      _displayName = userInfo['display_name'];
      _photoUrl = userInfo['photo_url'];
      _isPremium = userInfo['is_premium'] ?? false;
      _subscriptionTier = userInfo['subscription_tier'] ?? 'free';
      _isAuthenticated = true;

      // Parse expiration date if present
      if (userInfo['subscription_expires_at'] != null) {
        _subscriptionExpiresAt = DateTime.parse(
          userInfo['subscription_expires_at'],
        );
      }

      debugPrint('[BackendAuthService] User info refreshed: email=$_userEmail, displayName=$_displayName');

      notifyListeners();
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

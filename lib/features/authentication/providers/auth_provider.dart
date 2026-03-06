import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/core/services/analytics_service.dart';
import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/core/services/backend_auth_service.dart';
import 'package:the_accountant/core/services/google_sign_in_service.dart';
import 'package:the_accountant/core/services/secure_token_storage.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  // Backend user info
  final String? userId;
  final String? userEmail;
  final String? displayName;
  final String? photoUrl;
  final bool isPremium;
  final String subscriptionTier;
  final DateTime? createdAt;

  // For account linking flow
  final bool requiresLinking;
  final String? pendingFirebaseToken;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.userId,
    this.userEmail,
    this.displayName,
    this.photoUrl,
    this.isPremium = false,
    this.subscriptionTier = 'free',
    this.createdAt,
    this.requiresLinking = false,
    this.pendingFirebaseToken,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    String? userId,
    String? userEmail,
    String? displayName,
    String? photoUrl,
    bool? isPremium,
    String? subscriptionTier,
    DateTime? createdAt,
    bool? requiresLinking,
    String? pendingFirebaseToken,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      isPremium: isPremium ?? this.isPremium,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      createdAt: createdAt ?? this.createdAt,
      requiresLinking: requiresLinking ?? this.requiresLinking,
      pendingFirebaseToken: pendingFirebaseToken ?? this.pendingFirebaseToken,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final BackendAuthService _backendAuth = BackendAuthService();
  final GoogleSignInService _googleSignIn = GoogleSignInService();

  AuthNotifier() : super(const AuthState(isLoading: true)) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      // Initialize backend auth service
      await _backendAuth.initialize();

      // Listen to backend auth state changes
      _backendAuth.addListener(_onBackendAuthChanged);

      // Update state based on backend auth
      _updateStateFromBackendAuth();

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        error: 'Failed to initialize authentication',
      );
    }
  }

  void _onBackendAuthChanged() {
    _updateStateFromBackendAuth();
  }

  void _updateStateFromBackendAuth() {
    state = state.copyWith(
      isAuthenticated: _backendAuth.isAuthenticated,
      userId: _backendAuth.userId,
      userEmail: _backendAuth.userEmail,
      displayName: _backendAuth.userDisplayName,
      photoUrl: _backendAuth.userPhotoUrl,
      isPremium: _backendAuth.isPremium,
      subscriptionTier: _backendAuth.subscriptionTier,
      createdAt: _backendAuth.userCreatedAt,
      isLoading: _backendAuth.isInitializing,
    );
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _backendAuth.login(email, password);

      // Store basic info
      await SecureTokenStorage.storeUserId(_backendAuth.userId ?? '');
      await SecureTokenStorage.storeUserEmail(email);

      AnalyticsService().logLogin(method: 'email');

      state = state.copyWith(
        isAuthenticated: true,
        userId: _backendAuth.userId,
        userEmail: email,
        displayName: _backendAuth.userDisplayName,
        isLoading: false,
      );
    } catch (e) {
      String errorMessage = 'An error occurred during sign in';
      if (e.toString().contains('Incorrect email or password')) {
        errorMessage = 'Incorrect email or password.';
      }

      state = state.copyWith(
        isAuthenticated: false,
        error: errorMessage,
        isLoading: false,
      );
    }
  }

  Future<void> signUpWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _backendAuth.register(email, password);

      // Update profile with name
      await _backendAuth.updateProfile(displayName: name);

      // Store basic info
      await SecureTokenStorage.storeUserId(_backendAuth.userId ?? '');
      await SecureTokenStorage.storeUserEmail(email);

      AnalyticsService().logSignUp(method: 'email');

      state = state.copyWith(
        isAuthenticated: true,
        userId: _backendAuth.userId,
        userEmail: email,
        displayName: name,
        isLoading: false,
      );
    } catch (e) {
      String errorMessage = 'An error occurred during sign up';
      if (e.toString().contains('Email already registered')) {
        errorMessage =
            'The email address is already in use by another account.';
      }

      state = state.copyWith(
        isAuthenticated: false,
        error: errorMessage,
        isLoading: false,
      );
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Step 1: Google Sign-In + Firebase
      debugPrint('[AuthProvider] Starting Google Sign-In...');
      final userCredential = await _googleSignIn.signInWithGoogle();

      if (userCredential == null || userCredential.user == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Google Sign-In was cancelled or failed',
        );
        return;
      }

      debugPrint(
        '[AuthProvider] Google Sign-In successful, getting Firebase ID token...',
      );

      // Step 2: Get Firebase ID token
      final firebaseToken = await _googleSignIn.getFirebaseIdToken();

      if (firebaseToken == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to get Firebase ID token',
        );
        return;
      }

      debugPrint(
        '[AuthProvider] Got Firebase ID token, authenticating with backend...',
      );

      // Step 3: Authenticate with backend
      try {
        await _backendAuth.authenticateWithGoogle(firebaseToken);

        // Store basic info
        await SecureTokenStorage.storeUserId(_backendAuth.userId ?? '');
        await SecureTokenStorage.storeUserEmail(_backendAuth.userEmail ?? '');

        AnalyticsService().logLogin(method: 'google');

        state = state.copyWith(
          isAuthenticated: true,
          userId: _backendAuth.userId,
          userEmail: _backendAuth.userEmail,
          displayName: _backendAuth.userDisplayName,
          photoUrl: _backendAuth.userPhotoUrl,
          isLoading: false,
        );
      } on AccountLinkingRequiredException {
        // Sign out of Firebase to prevent auto-login interference
        await FirebaseAuth.instance.signOut();

        // Set state for account linking
        state = state.copyWith(
          requiresLinking: true,
          pendingFirebaseToken: firebaseToken,
          isLoading: false,
          error: null,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred during Google sign in';
      if (e.code == 'account-exists-with-different-credential') {
        errorMessage =
            'An account already exists with the same email address but different sign-in credentials.';
      } else if (e.code == 'invalid-credential') {
        errorMessage =
            'The supplied auth credential is malformed or has expired.';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = 'Google sign-in is disabled.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'The user account has been disabled.';
      }

      state = state.copyWith(
        isAuthenticated: false,
        error: errorMessage,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isAuthenticated: false,
        error: 'An error occurred during Google sign in',
        isLoading: false,
      );
    }
  }

  Future<void> linkGoogleAccount(String password) async {
    if (state.pendingFirebaseToken == null) {
      state = state.copyWith(error: 'No pending account to link');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _backendAuth.linkGoogleAccount(
        firebaseToken: state.pendingFirebaseToken!,
        password: password,
      );

      // Store basic info
      await SecureTokenStorage.storeUserId(_backendAuth.userId ?? '');
      await SecureTokenStorage.storeUserEmail(_backendAuth.userEmail ?? '');

      state = state.copyWith(
        isAuthenticated: true,
        userId: _backendAuth.userId,
        userEmail: _backendAuth.userEmail,
        displayName: _backendAuth.userDisplayName,
        photoUrl: _backendAuth.userPhotoUrl,
        requiresLinking: false,
        pendingFirebaseToken: null,
        isLoading: false,
      );
    } catch (e) {
      String errorMessage = 'Failed to link account';
      if (e.toString().contains('Incorrect password')) {
        errorMessage = 'Incorrect password. Please try again.';
      }

      state = state.copyWith(error: errorMessage, isLoading: false);
    }
  }

  void cancelLinking() {
    state = state.copyWith(
      requiresLinking: false,
      pendingFirebaseToken: null,
      error: null,
    );
  }

  Future<void> signOut() async {
    try {
      AnalyticsService().logLogout();
      await _backendAuth.logout();
      await _googleSignIn.signOut();
      await SecureTokenStorage.clearAllTokens();

      state = const AuthState(isAuthenticated: false, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'An error occurred during sign out');
    }
  }

  // Check if user is logged in using stored tokens
  Future<bool> checkLoginStatus() async {
    return await SecureTokenStorage.isLoggedIn();
  }

  @override
  void dispose() {
    _backendAuth.removeListener(_onBackendAuthChanged);
    super.dispose();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

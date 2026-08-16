import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/core/services/analytics_service.dart';
import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/core/services/apple_sign_in_service.dart';
import 'package:the_accountant/core/services/backend_auth_service.dart';
import 'package:the_accountant/core/services/google_sign_in_service.dart';
import 'package:the_accountant/core/services/secure_token_storage.dart';

/// Sentinel type for [AuthState.copyWith]; see [AuthState._unset].
class _Unset {
  const _Unset();
}

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

  /// Nullable fields that callers need to actively clear ([error],
  /// [pendingFirebaseToken]) can't use the usual `x ?? this.x` idiom — passing
  /// null would be indistinguishable from omitting the argument. They take a
  /// sentinel instead, so omitting keeps the current value and passing null
  /// clears it. Previously `error` was always overwritten (so any unrelated
  /// copyWith silently wiped the message) and `pendingFirebaseToken` could never
  /// be cleared at all, leaving a stale Firebase token in memory after cancel.
  AuthState copyWith({
    bool? isLoading,
    Object? error = _unset,
    bool? isAuthenticated,
    String? userId,
    String? userEmail,
    String? displayName,
    String? photoUrl,
    bool? isPremium,
    String? subscriptionTier,
    DateTime? createdAt,
    bool? requiresLinking,
    Object? pendingFirebaseToken = _unset,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _unset) ? this.error : error as String?,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      isPremium: isPremium ?? this.isPremium,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      createdAt: createdAt ?? this.createdAt,
      requiresLinking: requiresLinking ?? this.requiresLinking,
      pendingFirebaseToken: identical(pendingFirebaseToken, _unset)
          ? this.pendingFirebaseToken
          : pendingFirebaseToken as String?,
    );
  }

  /// Marker for "argument not supplied", distinct from an explicit null.
  /// A private type rather than `Object()` so no caller can accidentally pass a
  /// value Dart canonicalises to the same instance.
  static const Object _unset = _Unset();
}

/// Turns a failed backend call into something the user can act on.
///
/// Every failure used to collapse into "an error occurred", so a total backend
/// outage was indistinguishable from a mistyped password. That is exactly what
/// App Store review hit: the API was answering 500 to every request and the
/// screen said the same words a typo produces, which gave no clue where to
/// look. [fallback] covers failures that never reached the API at all.
String _describeAuthFailure(Object error, String fallback) {
  if (error is! ApiException) return fallback;

  if (error.isNetworkError) return error.message;

  if (error.isRateLimited) {
    return 'Too many attempts. Please wait a minute and try again.';
  }

  if (error.isServerError) {
    return 'We could not reach our servers. This is on our side — '
        'please try again in a few minutes.';
  }

  // 4xx: the server explained itself ("Incorrect email or password",
  // "Email already registered"), so pass that through rather than
  // string-matching it back into a hardcoded message.
  return error.message;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final BackendAuthService _backendAuth = BackendAuthService();
  final GoogleSignInService _googleSignIn = GoogleSignInService();
  final AppleSignInService _appleSignIn = AppleSignInService();

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
      state = state.copyWith(
        isAuthenticated: false,
        error: _describeAuthFailure(e, 'An error occurred during sign in'),
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
      state = state.copyWith(
        isAuthenticated: false,
        error: _describeAuthFailure(e, 'An error occurred during sign up'),
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
        await _firebaseSignOutIfAvailable();

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
        error: _describeAuthFailure(
          e,
          'An error occurred during Google sign in',
        ),
        isLoading: false,
      );
    }
  }

  Future<void> signInWithApple() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Step 1: Sign in with Apple + Firebase
      debugPrint('[AuthProvider] Starting Sign in with Apple...');
      final userCredential = await _appleSignIn.signInWithApple();

      if (userCredential == null || userCredential.user == null) {
        // Null means the user cancelled the Apple sheet — not an error.
        state = state.copyWith(isLoading: false);
        return;
      }

      debugPrint(
        '[AuthProvider] Apple Sign-In successful, getting Firebase ID token...',
      );

      // Step 2: Get Firebase ID token (provider-agnostic).
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

      // Step 3: Authenticate with backend (verifies the Firebase token
      // regardless of which provider issued it).
      try {
        await _backendAuth.authenticateWithGoogle(firebaseToken);

        // Store basic info
        await SecureTokenStorage.storeUserId(_backendAuth.userId ?? '');
        await SecureTokenStorage.storeUserEmail(_backendAuth.userEmail ?? '');

        AnalyticsService().logLogin(method: 'apple');

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
        await _firebaseSignOutIfAvailable();

        // Set state for account linking
        state = state.copyWith(
          requiresLinking: true,
          pendingFirebaseToken: firebaseToken,
          isLoading: false,
          error: null,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred during Apple sign in';
      if (e.code == 'account-exists-with-different-credential') {
        errorMessage =
            'An account already exists with the same email address but different sign-in credentials.';
      } else if (e.code == 'invalid-credential') {
        errorMessage =
            'The supplied auth credential is malformed or has expired.';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = 'Apple sign-in is disabled.';
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
        error: _describeAuthFailure(
          e,
          'An error occurred during Apple sign in',
        ),
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

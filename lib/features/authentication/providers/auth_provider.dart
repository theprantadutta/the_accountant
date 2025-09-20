import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_accountant/core/services/secure_token_storage.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final User? user;
  final bool isAuthenticated;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.user,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    User? user,
    bool? isAuthenticated,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  AuthNotifier() : super(const AuthState(isLoading: true)) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      // Check if user is already signed in
      final currentUser = _auth.currentUser;
      
      if (currentUser != null) {
        // User is already signed in
        await SecureTokenStorage.storeUserId(currentUser.uid);
        await SecureTokenStorage.storeUserEmail(currentUser.email ?? '');
        
        state = state.copyWith(
          isAuthenticated: true,
          user: currentUser,
          isLoading: false,
        );
      } else {
        // No user signed in
        state = state.copyWith(
          isAuthenticated: false,
          user: null,
          isLoading: false,
        );
      }

      // Listen to auth state changes
      _auth.authStateChanges().listen((User? user) async {
        if (user != null) {
          // Store user tokens securely
          await SecureTokenStorage.storeUserId(user.uid);
          await SecureTokenStorage.storeUserEmail(user.email ?? '');

          state = state.copyWith(
            isAuthenticated: true,
            user: user,
            isLoading: false,
          );
        } else {
          state = state.copyWith(
            isAuthenticated: false,
            user: null,
            isLoading: false,
          );
        }
      });
    } catch (e) {
      state = state.copyWith(
        isAuthenticated: false,
        user: null,
        isLoading: false,
        error: 'Failed to initialize authentication',
      );
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      // Store user tokens securely
      if (userCredential.user != null) {
        await SecureTokenStorage.storeUserId(userCredential.user!.uid);
        await SecureTokenStorage.storeUserEmail(
          userCredential.user!.email ?? '',
        );
      }

      state = state.copyWith(
        isAuthenticated: true,
        user: userCredential.user,
        isLoading: false,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred during sign in';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is invalid.';
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
        error: 'An error occurred during sign in',
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
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update user profile with name
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name);
        await SecureTokenStorage.storeUserId(userCredential.user!.uid);
        await SecureTokenStorage.storeUserEmail(
          userCredential.user!.email ?? '',
        );
      }

      state = state.copyWith(
        isAuthenticated: true,
        user: userCredential.user,
        isLoading: false,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred during sign up';
      if (e.code == 'email-already-in-use') {
        errorMessage =
            'The email address is already in use by another account.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is invalid.';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = 'Email/password accounts are not enabled.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      }

      state = state.copyWith(
        isAuthenticated: false,
        error: errorMessage,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isAuthenticated: false,
        error: 'An error occurred during sign up',
        isLoading: false,
      );
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Initialize Google Sign-In
      await _googleSignIn.initialize();

      // Try lightweight authentication first
      await _googleSignIn.attemptLightweightAuthentication();

      // If not signed in, try to authenticate
      if (!_googleSignIn.supportsAuthenticate()) {
        state = state.copyWith(
          isLoading: false,
          error: 'Google Sign-In not supported on this platform',
        );
        return;
      }

      // Authenticate with Google
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );

      // Get authorization for Firebase scopes
      final authClient = _googleSignIn.authorizationClient;
      final authorization = await authClient.authorizationForScopes(['email']);

      // Get the authentication details
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: authorization?.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Store user tokens securely
      if (userCredential.user != null) {
        await SecureTokenStorage.storeUserId(userCredential.user!.uid);
        await SecureTokenStorage.storeUserEmail(
          userCredential.user!.email ?? '',
        );
      }

      state = state.copyWith(
        isAuthenticated: true,
        user: userCredential.user,
        isLoading: false,
      );
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
      } else if (e.code == 'user-not-found') {
        errorMessage = 'There is no user corresponding to the identifier.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'The password is invalid.';
      } else if (e.code == 'invalid-verification-code') {
        errorMessage =
            'The SMS verification code used to create the phone auth credential is invalid.';
      } else if (e.code == 'invalid-verification-id') {
        errorMessage =
            'The verification ID used to create the phone auth credential is invalid.';
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

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      await SecureTokenStorage.clearAllTokens();
      state = state.copyWith(
        isAuthenticated: false,
        user: null,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: 'An error occurred during sign out');
    }
  }

  // Check if user is logged in using stored tokens
  Future<bool> checkLoginStatus() async {
    return await SecureTokenStorage.isLoggedIn();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

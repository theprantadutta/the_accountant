import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_accountant/core/services/secure_token_storage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
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

      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Store user tokens securely
      if (userCredential.user != null) {
        await SecureTokenStorage.storeUserId(userCredential.user!.uid);
        await SecureTokenStorage.storeUserEmail(
          userCredential.user!.email ?? '',
        );
      }

      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      // Initialize Google Sign-In
      await _googleSignIn.initialize();

      // Try lightweight authentication first
      await _googleSignIn.attemptLightweightAuthentication();

      // If not signed in, try to authenticate
      if (!_googleSignIn.supportsAuthenticate()) {
        throw Exception('Google Sign-In not supported on this platform');
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

      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      await SecureTokenStorage.clearAllTokens();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  // Check if user is logged in using stored tokens
  Future<bool> checkLoginStatus() async {
    return await SecureTokenStorage.isLoggedIn();
  }

  // Update user profile
  Future<void> updateDisplayName(String name) async {
    try {
      if (currentUser != null) {
        await currentUser!.updateDisplayName(name);
      }
    } catch (e) {
      rethrow;
    }
  }
}
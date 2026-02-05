import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

/// Service to handle Google Sign-In authentication flow
///
/// This service coordinates between Google Sign-In, Firebase Authentication,
/// and The Accountant backend to provide a complete authentication solution.
class GoogleSignInService {
  static final GoogleSignInService _instance = GoogleSignInService._internal();
  factory GoogleSignInService() => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  GoogleSignInService._internal() {
    // Initialize Google Sign-In with client ID from environment
    final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];

    if (webClientId != null &&
        webClientId.isNotEmpty &&
        webClientId != 'YOUR_GOOGLE_WEB_CLIENT_ID_HERE') {
      _googleSignIn.initialize(serverClientId: webClientId);
      debugPrint('Google Sign-In initialized with Web Client ID');
    } else {
      debugPrint('GOOGLE_WEB_CLIENT_ID not properly configured in .env file');
    }
  }

  /// Get current Firebase user
  User? get currentUser => _auth.currentUser;

  /// Check if user is signed in to Firebase
  bool get isSignedIn => currentUser != null;

  /// Stream of Firebase auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with Google and authenticate with Firebase
  ///
  /// Returns a [UserCredential] on success, null on failure
  ///
  /// Flow:
  /// 1. Check if Google Sign-In authenticate is supported
  /// 2. Trigger Google Sign-In flow
  /// 3. Get Google authentication tokens
  /// 4. Create Firebase credential
  /// 5. Sign in to Firebase with the credential
  Future<UserCredential?> signInWithGoogle() async {
    try {
      debugPrint('[Google Sign-In] Starting Google Sign-In...');

      // Check if authentication is supported on this platform
      if (_googleSignIn.supportsAuthenticate()) {
        // Use authenticate method for supported platforms
        final GoogleSignInAccount googleUser = await _googleSignIn
            .authenticate();

        debugPrint(
          '[Google Sign-In] Google user signed in: ${googleUser.email}',
        );

        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth = googleUser.authentication;

        if (googleAuth.idToken == null) {
          debugPrint('[Google Sign-In] Failed to get Google ID token');
          throw Exception('Failed to get Google ID token');
        }

        // Create a new Firebase credential
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        debugPrint('[Google Sign-In] Creating Firebase credential...');

        // Sign in to Firebase with the credential
        final UserCredential result = await _auth.signInWithCredential(
          credential,
        );

        if (result.user != null) {
          debugPrint(
            '[Google Sign-In] Firebase sign-in successful: ${result.user!.uid}',
          );
        }

        return result;
      } else {
        debugPrint(
          '[Google Sign-In] authenticate not supported on this platform',
        );
        return null;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(
        '[Google Sign-In] Firebase Auth error: ${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('[Google Sign-In] Error signing in with Google: $e');
      debugPrint('[Google Sign-In] Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Get Firebase ID token for backend authentication
  ///
  /// This token should be sent to the backend for verification
  Future<String?> getFirebaseIdToken() async {
    try {
      final user = currentUser;
      if (user == null) {
        debugPrint('[Google Sign-In] Cannot get ID token: no user signed in');
        return null;
      }

      final token = await user.getIdToken();
      debugPrint('[Google Sign-In] Retrieved Firebase ID token');
      return token;
    } catch (e, stackTrace) {
      debugPrint('[Google Sign-In] Error getting Firebase ID token: $e');
      debugPrint('[Google Sign-In] Stack trace: $stackTrace');
      return null;
    }
  }

  /// Sign out from both Google and Firebase
  Future<void> signOut() async {
    try {
      debugPrint('[Google Sign-In] Signing out from Google and Firebase...');
      await _googleSignIn.signOut();
      await _auth.signOut();
      debugPrint('[Google Sign-In] Sign out successful');
    } catch (e, stackTrace) {
      debugPrint('[Google Sign-In] Error signing out: $e');
      debugPrint('[Google Sign-In] Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Disconnect Google account completely (more aggressive than signOut)
  Future<void> disconnect() async {
    try {
      debugPrint('[Google Sign-In] Disconnecting Google account...');
      await _googleSignIn.disconnect();
      await _auth.signOut();
      debugPrint('[Google Sign-In] Disconnect successful');
    } catch (e, stackTrace) {
      debugPrint('[Google Sign-In] Error disconnecting: $e');
      debugPrint('[Google Sign-In] Stack trace: $stackTrace');
      // Don't rethrow - disconnect can fail if already disconnected
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Service to handle Sign in with Apple.
///
/// Uses firebase_auth's native [AppleAuthProvider] flow (`signInWithProvider`):
/// Firebase presents the system Apple sheet and handles the nonce/token
/// exchange internally. This is more reliable than the manual
/// `sign_in_with_apple` + `OAuthProvider('apple.com')` nonce flow, which is a
/// common source of "invalid-credential / Invalid OAuth response from apple.com".
///
/// Required by App Store Review Guideline 4.8 whenever a third-party social
/// login (Google) is offered.
class AppleSignInService {
  static final AppleSignInService _instance = AppleSignInService._internal();
  factory AppleSignInService() => _instance;
  AppleSignInService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign in with Apple and authenticate with Firebase.
  ///
  /// Returns a [UserCredential] on success, `null` if the user cancelled.
  /// Firebase sets the user's display name from Apple on first sign-in.
  Future<UserCredential?> signInWithApple() async {
    try {
      debugPrint('[Apple Sign-In] Starting Sign in with Apple...');

      final appleProvider = AppleAuthProvider()
        ..addScope('email')
        ..addScope('name');

      final UserCredential result = await _auth.signInWithProvider(
        appleProvider,
      );

      if (result.user != null) {
        debugPrint(
          '[Apple Sign-In] Firebase sign-in successful: ${result.user!.uid}',
        );
      }
      return result;
    } on FirebaseAuthException catch (e) {
      // The system sheet's Cancel button surfaces as an exception — treat it
      // as a benign no-op rather than an error.
      if (e.code == 'canceled' ||
          e.code == 'user-cancelled' ||
          e.code == 'web-context-canceled') {
        debugPrint('[Apple Sign-In] Cancelled by user');
        return null;
      }
      debugPrint(
        '[Apple Sign-In] Firebase Auth error: ${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('[Apple Sign-In] Error signing in with Apple: $e');
      debugPrint('[Apple Sign-In] Stack trace: $stackTrace');
      rethrow;
    }
  }
}

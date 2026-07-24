import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Service to handle Sign in with Apple authentication flow.
///
/// Required by App Store Review Guideline 4.8 whenever a third-party social
/// login (Google) is offered. Mirrors [GoogleSignInService]: it authenticates
/// with Apple, exchanges the credential for a Firebase session, and lets the
/// existing backend flow verify the resulting Firebase ID token.
class AppleSignInService {
  static final AppleSignInService _instance = AppleSignInService._internal();
  factory AppleSignInService() => _instance;
  AppleSignInService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Whether Sign in with Apple is available on the current device.
  /// (iOS 13+/macOS; also supported via web on other platforms.)
  Future<bool> isAvailable() => SignInWithApple.isAvailable();

  /// Generates a cryptographically secure random nonce.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }

  /// Sign in with Apple and authenticate with Firebase.
  ///
  /// Returns a [UserCredential] on success, `null` if the user cancelled.
  ///
  /// Flow:
  /// 1. Generate a nonce (raw + SHA256) to protect against replay attacks
  /// 2. Request an Apple ID credential
  /// 3. Build a Firebase OAuth credential for `apple.com`
  /// 4. Sign in to Firebase with the credential
  /// 5. On first sign-in, persist the user's name (Apple only returns it once)
  Future<UserCredential?> signInWithApple() async {
    try {
      debugPrint('[Apple Sign-In] Starting Sign in with Apple...');

      final rawNonce = _generateNonce();
      final hashedNonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      if (appleCredential.identityToken == null) {
        debugPrint('[Apple Sign-In] Failed to get Apple identity token');
        throw Exception('Failed to get Apple identity token');
      }

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      debugPrint('[Apple Sign-In] Creating Firebase credential...');
      final UserCredential result = await _auth.signInWithCredential(
        oauthCredential,
      );

      // Apple only returns the full name on the very first authorization, so
      // capture it into the Firebase profile when we have it.
      final givenName = appleCredential.givenName;
      final familyName = appleCredential.familyName;
      if (result.user != null &&
          (result.user!.displayName == null ||
              result.user!.displayName!.isEmpty) &&
          (givenName != null || familyName != null)) {
        final fullName = [
          givenName,
          familyName,
        ].where((p) => p != null && p.isNotEmpty).join(' ').trim();
        if (fullName.isNotEmpty) {
          await result.user!.updateDisplayName(fullName);
        }
      }

      if (result.user != null) {
        debugPrint(
          '[Apple Sign-In] Firebase sign-in successful: ${result.user!.uid}',
        );
      }

      return result;
    } on SignInWithAppleAuthorizationException catch (e) {
      // User cancelled the native Apple sheet — treat as a benign no-op.
      if (e.code == AuthorizationErrorCode.canceled) {
        debugPrint('[Apple Sign-In] User cancelled the sign-in');
        return null;
      }
      debugPrint('[Apple Sign-In] Authorization error: ${e.code} - ${e.message}');
      rethrow;
    } on FirebaseAuthException catch (e) {
      debugPrint('[Apple Sign-In] Firebase Auth error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('[Apple Sign-In] Error signing in with Apple: $e');
      debugPrint('[Apple Sign-In] Stack trace: $stackTrace');
      rethrow;
    }
  }
}

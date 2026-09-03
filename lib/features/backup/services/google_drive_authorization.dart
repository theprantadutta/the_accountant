import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_accountant/features/backup/services/drive_client.dart';

/// Gets Drive credentials from the Google account the user is already signed in
/// with.
///
/// Sign-in and *authorization* are two separate grants in google_sign_in 7:
/// signing in identifies the user, and it does not carry permission to touch
/// their Drive. That separation is worth keeping rather than folding the Drive
/// scope into the sign-in request — somebody who only wants cloud sync should
/// never be asked for Drive access at all.
class GoogleDriveAuthorization implements DriveAuthorization {
  const GoogleDriveAuthorization();

  static const List<String> _scopes = [DriveBackupClient.scope];

  @override
  Future<Map<String, String>?> headers({bool interactive = false}) {
    return GoogleSignIn.instance.authorizationClient.authorizationHeaders(
      _scopes,
      promptIfNecessary: interactive,
    );
  }

  /// Whether Drive access has already been granted, without asking for it.
  Future<bool> isAuthorized() async =>
      await headers(interactive: false) != null;

  /// Ask for Drive access. Only call this from something the user pressed.
  Future<bool> requestAccess() async =>
      await headers(interactive: true) != null;

  /// Give the permission back.
  ///
  /// The token is cleared rather than the whole account being signed out: cloud
  /// sync uses the same account, and turning off backups must not log the user
  /// out of everything else.
  Future<void> revoke() async {
    final client = GoogleSignIn.instance.authorizationClient;
    final authorization = await client.authorizationForScopes(_scopes);
    if (authorization == null) return;
    await GoogleSignIn.instance.authorizationClient.clearAuthorizationToken(
      accessToken: authorization.accessToken,
    );
  }
}

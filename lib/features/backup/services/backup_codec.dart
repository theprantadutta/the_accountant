import 'package:the_accountant/features/backup/domain/backup_document.dart';
import 'package:the_accountant/features/backup/domain/backup_seal.dart';
import 'package:the_accountant/features/backup/services/account_data_key.dart';

/// Turns a backup into the file that leaves the phone, and back.
///
/// Every backup is written sealed with the account's data key. Reading accepts
/// both sealed files and the plain JSON written by earlier versions, so nothing
/// a user already saved stops being restorable.
///
/// For an account with a passphrase, the file also carries the key locked
/// under the passphrase and the recovery code. When the key cannot be had any
/// other way — our server unreachable on a phone that never cached it, or a
/// backup made by another account — [decode] throws [BackupNeedsSecret], and
/// [decodeWithSecret] opens it with what the user types.
class BackupCodec {
  BackupCodec({
    Future<List<int>> Function()? key,
    Future<BackupLocks?> Function()? locks,
  }) : _key = key ?? const AccountDataKey().read,
       _locks = locks ?? const AccountDataKey().backupLocks;

  final Future<List<int>> Function() _key;
  final Future<BackupLocks?> Function() _locks;

  Future<String> encode(BackupDocument document) async {
    final key = await _key();
    BackupLocks? locks;
    try {
      locks = await _locks();
    } catch (_) {
      // The backup is still worth making; it just needs the server to open.
    }
    return BackupSeal.seal(document.encode(), key, locks: locks);
  }

  Future<BackupDocument> decode(String source) async {
    if (!BackupSeal.isSealed(source)) return BackupDocument.decode(source);
    final locks = BackupSeal.locksOf(source);

    final List<int> key;
    try {
      key = await _key();
    } on AccountDataKeyUnavailable catch (e) {
      if (locks != null) throw const BackupNeedsSecret();
      throw BackupFormatException(e.message);
    } on AccountDataKeyLocked catch (e) {
      if (locks != null) throw const BackupNeedsSecret();
      throw BackupFormatException(e.toString());
    }

    try {
      return BackupDocument.decode(await BackupSeal.open(source, key));
    } on BackupWrongKey {
      // Made by another account that has a passphrase: its own secret opens it.
      if (locks != null) throw const BackupNeedsSecret();
      rethrow;
    }
  }

  /// Opens a backup that asked for [BackupNeedsSecret] with the passphrase,
  /// or with the recovery code when [isRecoveryCode].
  ///
  /// Throws [BackupWrongSecret] when it does not open the file.
  Future<BackupDocument> decodeWithSecret(
    String source,
    String secret, {
    bool isRecoveryCode = false,
  }) async {
    final locks = BackupSeal.locksOf(source);
    if (locks == null) {
      throw const BackupFormatException(
        'This backup cannot be opened with a passphrase.',
      );
    }
    final key = isRecoveryCode
        ? await locks.openWithRecoveryCode(secret)
        : await locks.openWithPassphrase(secret);
    if (key == null) throw const BackupWrongSecret();
    return BackupDocument.decode(await BackupSeal.open(source, key));
  }
}

/// The backup can be opened with its passphrase or recovery code; ask for it.
class BackupNeedsSecret extends BackupFormatException {
  const BackupNeedsSecret()
    : super(
        'This backup is protected with a passphrase. Enter it, or the '
        'recovery code, to restore it.',
      );
}

/// What was typed does not open the backup.
class BackupWrongSecret extends BackupFormatException {
  const BackupWrongSecret()
    : super('That passphrase or recovery code does not open this backup.');
}

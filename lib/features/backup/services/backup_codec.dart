import 'package:the_accountant/features/backup/domain/backup_document.dart';
import 'package:the_accountant/features/backup/domain/backup_seal.dart';
import 'package:the_accountant/features/backup/services/account_data_key.dart';

/// Turns a backup into the file that leaves the phone, and back.
///
/// Every backup is written sealed with the account's data key. Reading accepts
/// both sealed files and the plain JSON written by earlier versions, so nothing
/// a user already saved stops being restorable.
class BackupCodec {
  BackupCodec({Future<List<int>> Function()? key})
    : _key = key ?? const AccountDataKey().read;

  final Future<List<int>> Function() _key;

  Future<String> encode(BackupDocument document) async =>
      BackupSeal.seal(document.encode(), await _key());

  Future<BackupDocument> decode(String source) async {
    if (!BackupSeal.isSealed(source)) return BackupDocument.decode(source);
    final List<int> key;
    try {
      key = await _key();
    } on AccountDataKeyUnavailable catch (e) {
      throw BackupFormatException(e.message);
    }
    return BackupDocument.decode(await BackupSeal.open(source, key));
  }
}

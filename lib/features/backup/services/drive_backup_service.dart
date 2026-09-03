import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/backup/domain/backup_document.dart';
import 'package:the_accountant/features/backup/domain/backup_schedule.dart';
import 'package:the_accountant/features/backup/services/backup_service.dart';
import 'package:the_accountant/features/backup/services/drive_client.dart';

/// Keeps a rolling set of backups in the folder on Google Drive that only this
/// app can see.
///
/// Modelled on how Cashew does it — an interval, a number of files to keep, and
/// a list you can download, delete or restore from — but deliberately *not* on
/// how Cashew syncs. Cashew merges whole database files by modification time,
/// which means the device that saved last wins the whole database. This app has
/// a record-level delta protocol, so Drive here is only ever a safety net, and
/// restoring from it is an explicit act rather than something that happens
/// behind the user's back.
class DriveBackupService {
  DriveBackupService({
    required AppDatabase database,
    required DriveBackupClient client,
    BackupService? backups,
  }) : _db = database,
       // A named parameter cannot be a private initializing formal, so the
       // lint's suggestion is not expressible here.
       // ignore: prefer_initializing_formals
       _client = client,
       _backups = backups ?? BackupService(database);

  final AppDatabase _db;
  final DriveBackupClient _client;
  final BackupService _backups;

  static const String _frequencyKey = 'drive_backup_frequency';
  static const String _keepKey = 'drive_backup_keep';
  static const String _lastAtKey = 'drive_backup_last_at';
  static const String _lastFailureKey = 'drive_backup_last_failure';

  // ----------------------------------------------------------- the schedule

  Future<BackupSchedule> readSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final lastAt = prefs.getInt(_lastAtKey);
    return BackupSchedule(
      frequency: BackupFrequency.fromName(prefs.getString(_frequencyKey)),
      keep: prefs.getInt(_keepKey) ?? BackupSchedule.defaultKeep,
      lastBackupAt: lastAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(lastAt),
      lastFailure: prefs.getString(_lastFailureKey),
    );
  }

  Future<void> writeSchedule(BackupSchedule schedule) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_frequencyKey, schedule.frequency.name);
    await prefs.setInt(_keepKey, schedule.keep);
    if (schedule.lastBackupAt != null) {
      await prefs.setInt(
        _lastAtKey,
        schedule.lastBackupAt!.millisecondsSinceEpoch,
      );
    }
    if (schedule.lastFailure == null) {
      await prefs.remove(_lastFailureKey);
    } else {
      await prefs.setString(_lastFailureKey, schedule.lastFailure!);
    }
  }

  // ------------------------------------------------------------- the files

  Future<List<DriveBackupFile>> list({bool interactive = false}) =>
      _client.list(interactive: interactive);

  Future<void> delete(String fileId) => _client.delete(fileId);

  /// Fetch a backup's contents without applying them, for saving a copy.
  Future<String> download(String fileId) => _client.download(fileId);

  /// Take a backup now and put it in Drive.
  ///
  /// Old files are pruned only once the new one has landed, so a failed upload
  /// never costs the user a copy they already had.
  Future<DriveBackupFile> backupNow({
    String appVersion = '',
    String device = '',
    bool interactive = true,
  }) async {
    final document = await _backups.create(
      appVersion: appVersion,
      device: device,
    );

    final uploaded = await _client.upload(
      name: fileNameFor(
        schemaVersion: document.metadata.schemaVersion,
        device: device,
        at: document.metadata.createdAt,
      ),
      content: document.encode(),
      properties: {
        'schemaVersion': '${document.metadata.schemaVersion}',
        'appVersion': appVersion,
        'device': device,
        'rowCount': '${document.rowCount}',
      },
      interactive: interactive,
    );

    final schedule = await readSchedule();
    await writeSchedule(
      schedule.copyWith(
        lastBackupAt: document.metadata.createdAt,
        clearFailure: true,
      ),
    );
    await pruneTo(schedule.keep, interactive: interactive);

    return uploaded;
  }

  /// Remove the oldest backups until only [keep] remain.
  ///
  /// Returns how many were removed. A file that will not delete is left alone
  /// rather than aborting the sweep: it is better to keep one file too many
  /// than to stop pruning for ever because of a single stuck row.
  Future<int> pruneTo(int keep, {bool interactive = false}) async {
    if (keep <= 0) return 0;
    final files = await _client.list(interactive: interactive);
    if (files.length <= keep) return 0;

    final sorted = [...files]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    var removed = 0;
    for (final file in sorted.skip(keep)) {
      try {
        await _client.delete(file.id, interactive: false);
        removed++;
      } on DriveException {
        continue;
      }
    }
    return removed;
  }

  /// Read a backup out of Drive and make it this device's data.
  ///
  /// The file's own header is checked before a single row is written — a
  /// backup from a newer build describes a database this one cannot place, and
  /// half-placing it would be worse than refusing.
  Future<RestoreSummary> restoreFrom(String fileId) async {
    final source = await _client.download(fileId);
    return _backups.restore(BackupDocument.decode(source));
  }

  /// Run the scheduled backup if one is owed.
  ///
  /// Never prompts. A grant the user has let lapse means the run is skipped and
  /// the reason recorded, because throwing a Google consent screen at somebody
  /// who has just opened their finance app is not a reasonable way to ask.
  ///
  /// Returns true only when a backup actually went up.
  /// [describeDevice] is a callback rather than a value because naming the
  /// device means asking the platform, and that must not happen on a startup
  /// where no backup is owed — which is nearly every startup.
  Future<bool> runAutomaticIfDue({
    DateTime? now,
    String appVersion = '',
    String device = '',
    Future<String> Function()? describeDevice,
  }) async {
    final schedule = await readSchedule();
    if (!schedule.isDue(now ?? DateTime.now())) return false;

    try {
      await backupNow(
        appVersion: appVersion,
        device: describeDevice == null ? device : await describeDevice(),
        interactive: false,
      );
      return true;
    } on DriveException catch (e) {
      await writeSchedule(schedule.copyWith(lastFailure: e.message));
      return false;
    } catch (e) {
      await writeSchedule(
        schedule.copyWith(lastFailure: 'The backup could not be taken: $e'),
      );
      return false;
    }
  }

  /// Whether [file] can be restored by this build at all.
  ///
  /// Checked against the properties Drive already returned, so a file that is
  /// no use is greyed out in the list rather than being downloaded first.
  String? whyUnrestorable(DriveBackupFile file) {
    final version = file.schemaVersion;
    if (version == null) return null;
    if (version > _db.schemaVersion) {
      return 'Written by a newer version of the app.';
    }
    if (version < BackupDocument.minimumSchemaVersion) {
      return 'Older than this version of the app can read.';
    }
    return null;
  }

  /// `the-accountant-v21-Pixel-8-20260903-142530.json`
  ///
  /// The schema version and the device are in the name as well as in Drive's
  /// own properties, so a file downloaded and looked at by hand still says what
  /// it is and where it came from.
  static String fileNameFor({
    required int schemaVersion,
    required String device,
    required DateTime at,
  }) {
    final stamp = [
      at.year.toString().padLeft(4, '0'),
      at.month.toString().padLeft(2, '0'),
      at.day.toString().padLeft(2, '0'),
      '-',
      at.hour.toString().padLeft(2, '0'),
      at.minute.toString().padLeft(2, '0'),
      at.second.toString().padLeft(2, '0'),
    ].join();

    final safeDevice = device
        .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');

    final name = [
      'the-accountant',
      'v$schemaVersion',
      if (safeDevice.isNotEmpty) safeDevice,
      stamp,
    ].join('-').toLowerCase();
    return '$name.json';
  }
}

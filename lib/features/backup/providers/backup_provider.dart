import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/backup/domain/backup_schedule.dart';
import 'package:the_accountant/features/backup/services/backup_service.dart';
import 'package:the_accountant/features/backup/services/drive_backup_service.dart';
import 'package:the_accountant/features/backup/services/drive_client.dart';
import 'package:the_accountant/features/backup/services/google_drive_authorization.dart';

final backupServiceProvider = Provider<BackupService>(
  (ref) => BackupService(ref.watch(databaseProvider)),
);

final googleDriveAuthorizationProvider = Provider<GoogleDriveAuthorization>(
  (ref) => const GoogleDriveAuthorization(),
);

final driveBackupServiceProvider = Provider<DriveBackupService>(
  (ref) => DriveBackupService(
    database: ref.watch(databaseProvider),
    client: DriveBackupClient(
      authorization: ref.watch(googleDriveAuthorizationProvider),
    ),
  ),
);

/// What the user has asked automatic backups to do.
final backupScheduleProvider = FutureProvider<BackupSchedule>(
  (ref) => ref.watch(driveBackupServiceProvider).readSchedule(),
);

/// Whether Drive access has already been granted, asked without prompting.
final driveAuthorizedProvider = FutureProvider<bool>(
  (ref) => ref.watch(googleDriveAuthorizationProvider).isAuthorized(),
);

/// The backups currently sitting in Drive, newest first.
final driveBackupsProvider = FutureProvider<List<DriveBackupFile>>((ref) async {
  if (!await ref.watch(driveAuthorizedProvider.future)) return const [];
  return ref.watch(driveBackupServiceProvider).list();
});

/// How a backup names the machine it came from, so a list of them can be told
/// apart at a glance.
///
/// Best effort: a device that will not identify itself is worth a backup with a
/// blank label far more than it is worth an error.
final deviceLabelProvider = FutureProvider<String>((ref) async {
  try {
    final info = DeviceInfoPlugin();
    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = await info.androidInfo;
      return '${android.manufacturer} ${android.model}'.trim();
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return (await info.iosInfo).name;
    }
    if (defaultTargetPlatform == TargetPlatform.windows) {
      return (await info.windowsInfo).computerName;
    }
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return (await info.macOsInfo).computerName;
    }
    if (defaultTargetPlatform == TargetPlatform.linux) {
      return (await info.linuxInfo).prettyName;
    }
  } catch (_) {
    // Nothing here is worth failing a backup over.
  }
  return '';
});

final appVersionLabelProvider = FutureProvider<String>((ref) async {
  try {
    final info = await PackageInfo.fromPlatform();
    return '${info.version}+${info.buildNumber}';
  } catch (_) {
    return '';
  }
});

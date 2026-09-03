import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/data_reload.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/backup/domain/backup_document.dart';
import 'package:the_accountant/features/backup/domain/backup_schedule.dart';
import 'package:the_accountant/features/backup/providers/backup_provider.dart';
import 'package:the_accountant/features/backup/services/backup_service.dart';
import 'package:the_accountant/features/backup/services/drive_backup_service.dart';
import 'package:the_accountant/features/backup/services/drive_client.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/settings/widgets/confirmation_dialog.dart';

/// Getting your records off this device, and back onto it.
///
/// Cloud sync is a paid feature, which left a free user with no way at all to
/// move to a new phone or survive a reinstall. Backup and restore are free, for
/// everyone, because an app that can lose years of records with no recourse is
/// not one worth keeping them in.
class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Backup & Restore'),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          _infoCard(
            'A backup is a single file holding everything on this device — '
            'every transaction, account, budget and goal. Keep one somewhere '
            'safe and nothing here is ever lost for good.',
          ),
          SizedBox(height: AppSpacing.lg),

          _header('ON THIS DEVICE'),
          _card([
            _tile(
              icon: Icons.save_alt,
              title: 'Save a backup file',
              subtitle: 'Share it to Files, email, or anywhere you like',
              onTap: _busy ? null : _saveToFile,
            ),
            _divider(),
            _tile(
              icon: Icons.settings_backup_restore,
              title: 'Restore from a file',
              subtitle: 'Replaces everything currently on this device',
              onTap: _busy ? null : _restoreFromFile,
            ),
          ]),
          SizedBox(height: AppSpacing.lg),

          _header('GOOGLE DRIVE'),
          _driveSection(),
          SizedBox(height: AppSpacing.lg),

          _header('BACKUPS IN DRIVE'),
          _driveList(),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  // ------------------------------------------------------------ local files

  Future<void> _saveToFile() async {
    setState(() => _busy = true);
    try {
      final device = await ref.read(deviceLabelProvider.future);
      final appVersion = await ref.read(appVersionLabelProvider.future);
      final document = await ref
          .read(backupServiceProvider)
          .create(appVersion: appVersion, device: device);

      // A save dialog rather than the share sheet. A backup is a file the user
      // is meant to still have in a year, and sharing it into a chat thread is
      // not that.
      final saved = await _writeOut(
        name: DriveBackupService.fileNameFor(
          schemaVersion: document.metadata.schemaVersion,
          device: device,
          at: document.metadata.createdAt,
        ),
        contents: document.encode(),
      );
      if (saved) _say('Backed up ${document.rowCount} records.');
    } catch (e) {
      _say('The backup could not be taken: $e', bad: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Ask where to put [contents], and put it there. False if the user backed
  /// out of the dialog.
  Future<bool> _writeOut({
    required String name,
    required String contents,
  }) async {
    final destination = await FilePicker.saveFile(
      fileName: name,
      bytes: Uint8List.fromList(utf8.encode(contents)),
      mimeType: 'application/json',
      type: FileType.custom,
      allowedExtensions: const ['json'],
      dialogTitle: 'Save backup',
    );
    return destination != null;
  }

  Future<void> _restoreFromFile() async {
    final picked = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['json'],
      dialogTitle: 'Choose a backup file',
    );
    if (picked == null) return;

    // Read through the plugin rather than opening the path: on Android a
    // picked file usually lives behind a content:// URI that File() cannot
    // open at all.
    final bytes = await picked.readAsBytes();
    if (!mounted) return;

    final BackupDocument document;
    try {
      document = BackupDocument.decode(utf8.decode(bytes));
    } on BackupFormatException catch (e) {
      _say(e.message, bad: true);
      return;
    } catch (e) {
      _say('That file could not be read: $e', bad: true);
      return;
    }

    if (!mounted) return;
    await _confirmAndRestore(
      document.metadata,
      () => ref.read(backupServiceProvider).restore(document),
    );
  }

  /// The one place a restore is agreed to, whatever it came from.
  ///
  /// The header is shown back to the user first — when it was taken, on what,
  /// and by whom. A restore erases what is here, and "are you sure?" is not a
  /// fair question unless it says what you are about to swap for what.
  Future<void> _confirmAndRestore(
    BackupMetadata metadata,
    Future<RestoreSummary> Function() run,
  ) async {
    final dateFormat = ref.read(dateFormatSettingProvider);
    final owner = await ref.read(databaseProvider).getLocalStoreMeta();
    final differentAccount =
        metadata.ownerUserId != null &&
        owner?.ownerUserId != null &&
        metadata.ownerUserId != owner!.ownerUserId;

    if (!mounted) return;
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Restore this backup?',
      message: [
        'Taken ${AppDateFormatter.formatDate(metadata.createdAt, dateFormat)}'
            '${metadata.device.isEmpty ? '' : ' on ${metadata.device}'}.',
        if (metadata.ownerEmail != null)
          'It belonged to ${metadata.ownerEmail}.',
        if (differentAccount)
          'That is not the account signed in here. Restoring will put someone '
              "else's records on this device.",
        '',
        'Everything currently on this device is erased and replaced. Anything '
            'that has not synced yet is lost. This cannot be undone.',
      ].join('\n'),
      confirmText: 'Erase & Restore',
      isDangerous: true,
    );
    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    try {
      final summary = await run();
      if (!mounted) return;
      reloadAllData(ref);
      _say(
        summary.isComplete
            ? 'Restored ${summary.rowsRestored} records.'
            : 'Restored ${summary.rowsRestored} records. Some of the file did '
                  'not fit this version and was left out.',
      );
    } on BackupFormatException catch (e) {
      _say(e.message, bad: true);
    } catch (e) {
      _say('Nothing was changed — the restore failed: $e', bad: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // ----------------------------------------------------------------- Drive

  Widget _driveSection() {
    final authorized = ref.watch(driveAuthorizedProvider);
    final schedule = ref.watch(backupScheduleProvider);

    return authorized.when(
      loading: () => _card([const ListTile(title: Text('Checking…'))]),
      error: (e, _) => _card([
        _tile(
          icon: Icons.cloud_off,
          title: 'Google Drive is unavailable',
          subtitle: '$e',
          onTap: null,
        ),
      ]),
      data: (isAuthorized) {
        if (!isAuthorized) {
          return _card([
            _tile(
              icon: Icons.add_to_drive,
              title: 'Connect Google Drive',
              subtitle:
                  'Backups go in a private folder only this app can open. '
                  'Your other files are never read.',
              onTap: _busy ? null : _connectDrive,
            ),
          ]);
        }

        final current = schedule.value ?? const BackupSchedule();
        return _card([
          _tile(
            icon: Icons.backup,
            title: 'Back up now',
            subtitle: current.lastBackupAt == null
                ? 'No backup has gone up from this device yet'
                : 'Last backed up '
                      '${AppDateFormatter.formatDate(current.lastBackupAt!, ref.watch(dateFormatSettingProvider))}',
            onTap: _busy ? null : _backupToDrive,
          ),
          _divider(),
          _tile(
            icon: Icons.schedule,
            title: 'Automatic backups',
            subtitle: current.frequency.label,
            onTap: _busy ? null : () => _pickFrequency(current),
          ),
          _divider(),
          _tile(
            icon: Icons.layers,
            title: 'Keep',
            subtitle:
                '${current.keep} backups — older ones are removed after a new '
                'one lands',
            onTap: _busy ? null : () => _pickKeep(current),
          ),
          if (current.lastFailure != null) ...[
            _divider(),
            _tile(
              icon: Icons.warning_amber,
              iconColor: AppColors.warning,
              title: 'The last automatic backup did not run',
              subtitle: current.lastFailure!,
              onTap: _busy ? null : _backupToDrive,
            ),
          ],
          _divider(),
          _tile(
            icon: Icons.link_off,
            title: 'Disconnect Google Drive',
            subtitle:
                'Stops automatic backups. Nothing already saved is '
                'deleted.',
            onTap: _busy ? null : _disconnectDrive,
          ),
        ]);
      },
    );
  }

  Widget _driveList() {
    final files = ref.watch(driveBackupsProvider);

    return files.when(
      loading: () => _card([const ListTile(title: Text('Loading…'))]),
      error: (e, _) => _card([
        ListTile(
          title: Text(
            e is DriveException ? e.message : 'Could not list your backups: $e',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ]),
      data: (list) {
        if (list.isEmpty) {
          return _card([
            ListTile(
              title: Text(
                'Nothing here yet.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ]);
        }

        final service = ref.watch(driveBackupServiceProvider);
        final dateFormat = ref.watch(dateFormatSettingProvider);

        return _card([
          for (var i = 0; i < list.length; i++) ...[
            if (i > 0) _divider(),
            _driveFileTile(
              list[i],
              service.whyUnrestorable(list[i]),
              dateFormat,
            ),
          ],
        ]);
      },
    );
  }

  Widget _driveFileTile(
    DriveBackupFile file,
    String? unusable,
    String dateFormat,
  ) {
    final size = file.sizeBytes;
    return ListTile(
      leading: _leading(
        unusable == null ? Icons.cloud_done : Icons.cloud_off,
        unusable == null ? AppColors.primaryAccent : AppColors.textMuted,
      ),
      title: Text(
        AppDateFormatter.formatDate(file.createdAt, dateFormat),
        style: TextStyle(
          color: unusable == null ? AppColors.textPrimary : AppColors.textMuted,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        unusable ??
            [
              if ((file.device ?? '').isNotEmpty) file.device!,
              if (size != null) _readableSize(size),
            ].join(' · '),
        style: TextStyle(color: AppColors.textMuted, fontSize: 13),
      ),
      trailing: PopupMenuButton<String>(
        icon: Icon(Icons.more_vert, color: AppColors.textMuted),
        onSelected: (action) => _driveFileAction(action, file),
        itemBuilder: (_) => [
          if (unusable == null)
            const PopupMenuItem(value: 'restore', child: Text('Restore')),
          const PopupMenuItem(value: 'download', child: Text('Save a copy')),
          const PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
    );
  }

  Future<void> _driveFileAction(String action, DriveBackupFile file) async {
    switch (action) {
      case 'restore':
        await _restoreFromDrive(file);
      case 'download':
        await _downloadFromDrive(file);
      case 'delete':
        await _deleteFromDrive(file);
    }
  }

  Future<void> _connectDrive() async {
    setState(() => _busy = true);
    try {
      final granted = await ref
          .read(googleDriveAuthorizationProvider)
          .requestAccess();
      if (!granted) {
        _say('Google Drive access was not granted.', bad: true);
        return;
      }
      ref.invalidate(driveAuthorizedProvider);
      ref.invalidate(driveBackupsProvider);
    } catch (e) {
      _say('Google Drive could not be connected: $e', bad: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _disconnectDrive() async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Disconnect Google Drive?',
      message:
          'Automatic backups stop. The backups already in Drive stay where '
          'they are, and you can reconnect at any time.',
      confirmText: 'Disconnect',
    );
    if (confirmed != true || !mounted) return;

    final service = ref.read(driveBackupServiceProvider);
    await service.writeSchedule(
      (await service.readSchedule()).copyWith(
        frequency: BackupFrequency.manual,
        clearFailure: true,
      ),
    );
    await ref.read(googleDriveAuthorizationProvider).revoke();
    if (!mounted) return;
    ref.invalidate(driveAuthorizedProvider);
    ref.invalidate(driveBackupsProvider);
    ref.invalidate(backupScheduleProvider);
  }

  Future<void> _backupToDrive() async {
    setState(() => _busy = true);
    try {
      final file = await ref
          .read(driveBackupServiceProvider)
          .backupNow(
            device: await ref.read(deviceLabelProvider.future),
            appVersion: await ref.read(appVersionLabelProvider.future),
          );
      _say('Saved ${file.name} to Google Drive.');
      ref.invalidate(driveBackupsProvider);
      ref.invalidate(backupScheduleProvider);
    } on DriveException catch (e) {
      _say(e.message, bad: true);
    } catch (e) {
      _say('The backup could not be taken: $e', bad: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restoreFromDrive(DriveBackupFile file) async {
    setState(() => _busy = true);
    final String source;
    try {
      source = await ref.read(driveBackupServiceProvider).download(file.id);
    } on DriveException catch (e) {
      _say(e.message, bad: true);
      if (mounted) setState(() => _busy = false);
      return;
    } finally {
      if (mounted) setState(() => _busy = false);
    }

    final BackupDocument document;
    try {
      document = BackupDocument.decode(source);
    } on BackupFormatException catch (e) {
      _say(e.message, bad: true);
      return;
    }

    if (!mounted) return;
    await _confirmAndRestore(
      document.metadata,
      () => ref.read(backupServiceProvider).restore(document),
    );
  }

  Future<void> _downloadFromDrive(DriveBackupFile file) async {
    setState(() => _busy = true);
    try {
      final source = await ref
          .read(driveBackupServiceProvider)
          .download(file.id);
      await _writeOut(name: file.name, contents: source);
    } on DriveException catch (e) {
      _say(e.message, bad: true);
    } catch (e) {
      _say('That backup could not be saved: $e', bad: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteFromDrive(DriveBackupFile file) async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Delete this backup?',
      message: 'It is removed from Google Drive for good.',
      confirmText: 'Delete',
      isDangerous: true,
    );
    if (confirmed != true || !mounted) return;

    try {
      await ref.read(driveBackupServiceProvider).delete(file.id);
      ref.invalidate(driveBackupsProvider);
    } on DriveException catch (e) {
      _say(e.message, bad: true);
    }
  }

  Future<void> _pickFrequency(BackupSchedule current) async {
    final picked = await showDialog<BackupFrequency>(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: AppColors.primarySurface,
        title: const Text('Automatic backups'),
        children: [
          RadioGroup<BackupFrequency>(
            groupValue: current.frequency,
            onChanged: (value) => Navigator.pop(context, value),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final frequency in BackupFrequency.values)
                  RadioListTile<BackupFrequency>(
                    value: frequency,
                    title: Text(frequency.label),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
    if (picked == null) return;

    final service = ref.read(driveBackupServiceProvider);
    await service.writeSchedule(
      current.copyWith(frequency: picked, clearFailure: true),
    );
    if (!mounted) return;
    ref.invalidate(backupScheduleProvider);
  }

  Future<void> _pickKeep(BackupSchedule current) async {
    final picked = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: AppColors.primarySurface,
        title: const Text('How many backups to keep'),
        children: [
          RadioGroup<int>(
            groupValue: current.keep,
            onChanged: (value) => Navigator.pop(context, value),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final keep in BackupSchedule.keepOptions)
                  RadioListTile<int>(value: keep, title: Text('$keep')),
              ],
            ),
          ),
        ],
      ),
    );
    if (picked == null) return;

    final service = ref.read(driveBackupServiceProvider);
    await service.writeSchedule(current.copyWith(keep: picked));
    if (!mounted) return;
    ref.invalidate(backupScheduleProvider);
  }

  // ---------------------------------------------------------------- chrome

  void _say(String message, {bool bad = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bad ? AppColors.error : AppColors.success,
        duration: Duration(seconds: bad ? 8 : 4),
      ),
    );
  }

  static String _readableSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Widget _header(String title) => Padding(
    padding: EdgeInsets.only(left: AppSpacing.sm, bottom: AppSpacing.sm),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textMuted,
        letterSpacing: 1.2,
      ),
    ),
  );

  Widget _card(List<Widget> children) => Container(
    decoration: BoxDecoration(
      color: AppColors.primarySurface,
      borderRadius: AppSpacing.borderRadiusLg,
      border: Border.all(color: AppColors.glassBorder),
    ),
    child: Material(
      type: MaterialType.transparency,
      borderRadius: AppSpacing.borderRadiusLg,
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    ),
  );

  Widget _divider() =>
      Divider(height: 1, thickness: 1, color: AppColors.divider, indent: 56);

  Widget _leading(IconData icon, Color color) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(icon, color: color, size: 22),
  );

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    Color? iconColor,
  }) => ListTile(
    leading: _leading(icon, iconColor ?? AppColors.primaryAccent),
    title: Text(
      title,
      style: TextStyle(
        color: onTap == null ? AppColors.textMuted : AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
    ),
    subtitle: Text(
      subtitle,
      style: TextStyle(color: AppColors.textMuted, fontSize: 13),
    ),
    onTap: onTap == null
        ? null
        : () {
            HapticFeedback.selectionClick();
            onTap();
          },
  );

  Widget _infoCard(String message) => Container(
    padding: EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.info.withValues(alpha: 0.1),
      borderRadius: AppSpacing.borderRadiusLg,
      border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
    ),
    child: Row(
      children: [
        Icon(Icons.info_outline, color: AppColors.info),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            message,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ),
      ],
    ),
  );
}

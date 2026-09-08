import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:the_accountant/core/providers/sync_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
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

class _BackupScreenState extends ConsumerState<BackupScreen>
    with WidgetsBindingObserver {
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Re-read the Drive listing whenever the app comes back to the foreground.
  ///
  /// Saving a backup opens the system's own file dialog, and on Android one of
  /// the places it offers is Drive itself — so a file can land in the folder
  /// this screen lists without the app ever being told. Coming back is the one
  /// moment we know something might have changed underneath us.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || !mounted) return;
    ref.invalidate(driveBackupsProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(L10n.of(context).settingsBackupRestore),
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
              title: L10n.of(context).backupSaveABackupFile,
              subtitle: L10n.of(context).backupShareItToFilesEmail,
              onTap: _busy ? null : _saveToFile,
            ),
            _divider(),
            _tile(
              icon: Icons.settings_backup_restore,
              title: L10n.of(context).backupRestoreFromAFile,
              subtitle: L10n.of(
                context,
              ).backupReplacesEverythingCurrentlyOnThis,
              onTap: _busy ? null : _restoreFromFile,
            ),
          ]),
          SizedBox(height: AppSpacing.lg),

          _header('GOOGLE DRIVE'),
          _driveSection(),
          SizedBox(height: AppSpacing.lg),

          _header(
            'BACKUPS IN DRIVE',
            action: _refreshDriveButton(),
          ),
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
      if (saved) {
        _say('Backed up ${document.rowCount} records.');
        // The system dialog can write into Drive itself, and if it did then the
        // list below is already out of date.
        await _refreshDriveBackups();
      }
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
    // Never replace the database underneath a sync that is halfway through
    // applying to it. The restore runs in one transaction and the sync runs in
    // another; whichever committed second would win, and the loser's work would
    // be gone with nothing to say so.
    //
    // This is the early, courteous half: say so now rather than after the user
    // has read a page of warnings. It is not the guarantee — a sync can start
    // while the dialog below is open, so the restore itself takes the lock.
    if (ref.read(syncServiceProvider).isBusy) {
      _say(L10n.of(context).backupBusySyncing, bad: true);
      return;
    }

    final dateFormat = ref.read(dateFormatSettingProvider);
    final owner = await ref.read(databaseProvider).getLocalStoreMeta();
    final differentAccount =
        metadata.ownerUserId != null &&
        owner?.ownerUserId != null &&
        metadata.ownerUserId != owner!.ownerUserId;

    if (!mounted) return;
    final confirmed = await showConfirmationDialog(
      context: context,
      title: L10n.of(context).backupRestoreThisBackup,
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
      confirmText: L10n.of(context).backupEraseRestore,
      isDangerous: true,
    );
    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    try {
      // Under the lock, so a sync cannot be applying to the database while it
      // is being replaced. Null means one already is.
      final summary = await ref
          .read(syncServiceProvider)
          .runExclusively(run);
      if (!mounted) return;
      if (summary == null) {
        _say(L10n.of(context).backupBusySyncing, bad: true);
        return;
      }
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
      loading: () =>
          _card([ListTile(title: Text(L10n.of(context).backupChecking))]),
      error: (e, _) => _card([
        _tile(
          icon: Icons.cloud_off,
          title: L10n.of(context).backupGoogleDriveIsUnavailable,
          subtitle: '$e',
          onTap: null,
        ),
      ]),
      data: (isAuthorized) {
        if (!isAuthorized) {
          return _card([
            _tile(
              icon: Icons.add_to_drive,
              title: L10n.of(context).backupConnectGoogleDrive,
              subtitle:
                  'Backups go in a private folder only this app can open. '
                  'Your other files are never read.',
              onTap: _busy ? null : _connectDrive,
            ),
          ]);
        }

        final current = schedule.value ?? const BackupSchedule();
        return _card([
          // Says so plainly. Connecting used to change nothing on screen except
          // the last row turning into "Disconnect", which asks the user to work
          // out that it must have succeeded from the absence of the button they
          // pressed.
          ListTile(
            key: const ValueKey('drive-connected'),
            leading: _leading(Icons.check_circle, AppColors.success),
            title: Text(
              'Google Drive connected',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              current.lastBackupAt == null
                  ? 'Backups from this device will go to a folder called '
                        '"${DriveBackupClient.folderName}" in your Drive.'
                  : 'Backups go to "${DriveBackupClient.folderName}" in your '
                        'Drive.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ),
          _divider(),
          _tile(
            icon: Icons.backup,
            title: L10n.of(context).backupBackUpNow,
            subtitle: current.lastBackupAt == null
                ? 'No backup has gone up from this device yet'
                : 'Last backed up '
                      '${AppDateFormatter.formatDate(current.lastBackupAt!, ref.watch(dateFormatSettingProvider))}',
            onTap: _busy ? null : _backupToDrive,
          ),
          _divider(),
          _tile(
            icon: Icons.schedule,
            title: L10n.of(context).backupAutomaticBackups,
            subtitle: current.frequency.label,
            onTap: _busy ? null : () => _pickFrequency(current),
          ),
          _divider(),
          _tile(
            icon: Icons.layers,
            title: L10n.of(context).backupKeep,
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
              title: L10n.of(context).backupTheLastAutomaticBackupDid,
              subtitle: current.lastFailure!,
              onTap: _busy ? null : _backupToDrive,
            ),
          ],
          _divider(),
          _tile(
            icon: Icons.link_off,
            title: L10n.of(context).backupDisconnectGoogleDrive,
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
      loading: () =>
          _card([ListTile(title: Text(L10n.of(context).backupLoading))]),
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
                L10n.of(context).backupNothingHereYet,
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
            PopupMenuItem(
              value: 'restore',
              child: Text(L10n.of(context).trashRestore),
            ),
          PopupMenuItem(
            value: 'download',
            child: Text(L10n.of(context).backupSaveACopy),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Text(L10n.of(context).actionDelete),
          ),
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
      _say('Google Drive connected.');
    } catch (e) {
      _say('Google Drive could not be connected: $e', bad: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _disconnectDrive() async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: L10n.of(context).backupDisconnectGoogleDrive2,
      message:
          'Automatic backups stop. The backups already in Drive stay where '
          'they are, and you can reconnect at any time.',
      confirmText: L10n.of(context).backupDisconnect,
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
      ref.invalidate(backupScheduleProvider);
      // Awaited, not just invalidated. A rebuild triggered by an invalidation
      // is not a guarantee that the new listing has arrived, and a backup that
      // does not appear until the app is restarted reads as one that was not
      // taken.
      await _refreshDriveBackups();
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
      title: L10n.of(context).backupDeleteThisBackup,
      message: 'It is removed from Google Drive for good.',
      confirmText: L10n.of(context).actionDelete,
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
        title: Text(L10n.of(context).backupAutomaticBackups),
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
        title: Text(L10n.of(context).backupHowManyBackupsToKeep),
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

  Widget _header(String title, {Widget? action}) => Padding(
    padding: EdgeInsets.only(left: AppSpacing.sm, bottom: AppSpacing.sm),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ?action,
      ],
    ),
  );

  /// Ask Drive again, by hand.
  ///
  /// Drive does not always list a file the instant it is written, and a backup
  /// can arrive from somewhere this screen never saw — another device, or the
  /// system save dialog writing straight into the folder. Waiting for the app
  /// to be restarted is not an answer to either.
  Widget _refreshDriveButton() {
    final files = ref.watch(driveBackupsProvider);
    final authorized = ref.watch(driveAuthorizedProvider).value ?? false;
    if (!authorized) return const SizedBox.shrink();

    if (files.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return IconButton(
      key: const ValueKey('refresh-drive-backups'),
      onPressed: _refreshDriveBackups,
      icon: Icon(Icons.refresh, size: 20, color: AppColors.textMuted),
      tooltip: 'Refresh',
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.all(8),
    );
  }

  /// Re-read the listing and wait for it, so the button's spinner lasts exactly
  /// as long as the work does.
  Future<void> _refreshDriveBackups() async {
    ref.invalidate(driveBackupsProvider);
    try {
      await ref.read(driveBackupsProvider.future);
    } catch (_) {
      // Whatever went wrong is already on screen: the list itself renders the
      // error. Throwing here would only add an unhandled one.
    }
  }

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

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:the_accountant/core/providers/data_reload.dart';
import 'package:the_accountant/core/providers/sync_provider.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/import/services/cashew_import_service.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Bring everything over from a Cashew backup.
///
/// Two steps, so nothing is written before the user has seen what the file
/// holds: choose the backup and read what is in it, then import.
class CashewImportScreen extends ConsumerStatefulWidget {
  const CashewImportScreen({super.key});

  @override
  ConsumerState<CashewImportScreen> createState() => _CashewImportScreenState();
}

class _CashewImportScreenState extends ConsumerState<CashewImportScreen> {
  String? _path;
  CashewBackupSummary? _summary;
  String? _message;
  bool _messageIsBad = false;
  bool _busy = false;

  CashewImportService get _service =>
      CashewImportService(ref.read(databaseProvider));

  Future<void> _choose() async {
    // Any file: Cashew names its backups .sql, which Android does not know,
    // so filtering by extension would hide the very file wanted. The content
    // is checked instead.
    final picked = await FilePicker.pickFile(type: FileType.any);
    if (picked == null) return;

    // Through the plugin: on Android a picked file usually lives behind a
    // content:// URI that File() cannot open.
    final bytes = await picked.readAsBytes();
    if (!mounted) return;
    final l10n = L10n.of(context);
    if (!CashewImportService.looksLikeCashewBackup(bytes)) {
      _say(l10n.cashewNotBackup, bad: true);
      return;
    }

    // SQLite reads files, not bytes, so the backup is copied somewhere it can.
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/cashew-import.sqlite');
    await file.writeAsBytes(bytes, flush: true);
    try {
      final summary = _service.summarize(file.path);
      setState(() {
        _path = file.path;
        _summary = summary;
        _message = null;
      });
    } on Object {
      _say(l10n.cashewNotBackup, bad: true);
    }
  }

  Future<void> _import() async {
    final path = _path;
    if (path == null || _busy) return;
    final l10n = L10n.of(context);
    setState(() => _busy = true);
    try {
      // Under the sync lock, so a sync cannot be applying to the database
      // while thousands of rows are written into it. Null means one is.
      final result = await ref
          .read(syncServiceProvider)
          .runExclusively(() => _service.import(path));
      if (!mounted) return;
      if (result == null) {
        _say(l10n.backupBusySyncing, bad: true);
        return;
      }
      reloadAllData(ref);
      setState(() => _summary = null);
      _say(
        result.transactionsAdded == 0
            ? l10n.cashewNothingNew
            : l10n.cashewDone(result.transactionsAdded),
      );
    } catch (e) {
      _say('Nothing was changed — the import failed: $e', bad: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _say(String message, {bool bad = false}) => setState(() {
    _message = message;
    _messageIsBad = bad;
  });

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final summary = _summary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(l10n.settingsImportCashew),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            l10n.cashewIntro,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          SizedBox(height: AppSpacing.lg),
          OutlinedButton.icon(
            onPressed: _busy ? null : _choose,
            icon: const Icon(Symbols.folder_open_rounded),
            label: Text(l10n.cashewChoose),
          ),
          if (summary != null) ...[
            SizedBox(height: AppSpacing.lg),
            SunriseCard(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.cashewFound(
                      summary.transactions,
                      summary.accounts,
                      summary.categories,
                      summary.budgets,
                      summary.goals,
                    ),
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.cashewMergeNote,
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                  SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _busy ? null : _import,
                      child: _busy
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.cashewImport),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (_message != null) ...[
            SizedBox(height: AppSpacing.lg),
            Text(
              _message!,
              style: TextStyle(
                color: _messageIsBad ? AppColors.error : AppColors.success,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';
import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/data_reload.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/features/import/domain/column_mapping.dart';
import 'package:the_accountant/features/import/domain/csv_reader.dart';
import 'package:the_accountant/features/import/domain/import_preview.dart';
import 'package:the_accountant/features/import/domain/import_values.dart';
import 'package:the_accountant/features/import/providers/import_provider.dart';
import 'package:the_accountant/features/import/services/csv_import_service.dart';
import 'package:the_accountant/features/import/services/import_template_service.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/settings/widgets/confirmation_dialog.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/l10n/app_l10n.dart';

/// Bringing a bank statement in.
///
/// The screen is built around one idea: nothing is written until the user has
/// seen what will be written. Every guess the app makes — which column is the
/// date, what `03/04/2026` means, which way the signs run — is shown against
/// real rows from their own file and can be corrected before anything happens.
class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  CsvDocument? _document;
  String _fileName = '';
  ColumnMapping _mapping = const ColumnMapping();
  String? _walletId;
  ImportTemplate? _template;

  bool _createMissingCategories = true;
  bool _skipDuplicates = true;
  bool _busy = false;

  ImportPreview get _preview => _document == null
      ? const ImportPreview(rows: [])
      : ImportReader.read(_document!, _mapping);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(L10n.of(context).settingsImportStatement),
      ),
      body: CappedBody(child: _document == null ? _chooseFile() : _configure()),
    );
  }

  // ------------------------------------------------------------ choosing

  Widget _chooseFile() => ListView(
    padding: EdgeInsets.all(AppSpacing.md),
    children: [
      _info(L10n.of(context).importIntro),
      SizedBox(height: AppSpacing.lg),
      SunriseButton(
        label: L10n.of(context).importChooseACsvFile,
        icon: Symbols.folder_open_rounded,
        loading: _busy,
        onPressed: _busy ? null : _pickFile,
      ),
      SizedBox(height: AppSpacing.lg),
      _savedTemplates(),
    ],
  );

  Widget _savedTemplates() {
    final templates = ref.watch(importTemplatesProvider);
    final list = templates.value ?? const [];
    if (list.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(L10n.of(context).importSavedBanks),
        _card([
          for (var i = 0; i < list.length; i++) ...[
            if (i > 0) _divider(),
            ListTile(
              leading: Icon(Icons.bookmark_outline, color: AppColors.textMuted),
              title: Text(
                list[i].name,
                style: TextStyle(color: AppColors.textPrimary),
              ),
              subtitle: Text(
                L10n.of(context).importAppliedAutomaticallyWhenAFile,
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete_outline, color: AppColors.textMuted),
                onPressed: () => _deleteTemplate(list[i]),
              ),
            ),
          ],
        ]),
      ],
    );
  }

  Future<void> _pickFile() async {
    final picked = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['csv', 'txt', 'tsv'],
      dialogTitle: L10n.of(context).importChooseStatement,
    );
    if (picked == null) return;

    setState(() => _busy = true);
    try {
      // Read through the plugin: on Android a picked file usually sits behind a
      // content:// URI that cannot be opened as a path at all.
      final Uint8List bytes = await picked.readAsBytes();
      final document = CsvReader.read(bytes);

      if (document.body.isEmpty) {
        if (!mounted) return;
        _say(L10n.of(context).importNoRows, bad: true);
        return;
      }

      final template = await ref
          .read(importTemplateServiceProvider)
          .matching(document);

      if (!mounted) return;
      setState(() {
        _document = document;
        _fileName = picked.name;
        _template = template;
        _mapping = template == null
            ? ColumnMapping.guess(document)
            : ImportTemplateService.mappingOf(template);
        _walletId =
            template?.defaultWalletId ??
            ref.read(selectableWalletsProvider).firstOrNull?.id;
      });

      if (template != null && mounted) {
        _say(L10n.of(context).importUsingSavedMapping(template.name));
      }
    } catch (e) {
      if (mounted) _say(L10n.of(context).importCouldNotRead('$e'), bad: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteTemplate(ImportTemplate template) async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: L10n.of(context).importForgetTitle(template.name),
      message: L10n.of(context).importForgetBody,
      confirmText: L10n.of(context).importForget,
      isDangerous: true,
    );
    if (confirmed != true) return;
    await ref.read(importTemplateServiceProvider).delete(template.id);
    if (!mounted) return;
    ref.invalidate(importTemplatesProvider);
  }

  // --------------------------------------------------------- configuring

  Widget _configure() {
    final document = _document!;
    final preview = _preview;

    return ListView(
      padding: EdgeInsets.all(AppSpacing.md),
      children: [
        _fileCard(document),
        SizedBox(height: AppSpacing.lg),

        _header(L10n.of(context).importColumnsHeader),
        _card([
          for (var i = 0; i < ImportField.values.length; i++) ...[
            if (i > 0) _divider(),
            _columnPicker(ImportField.values[i], document),
          ],
        ]),
        SizedBox(height: AppSpacing.lg),

        _header(L10n.of(context).importHowToRead),
        _card([
          _dateFormatTile(),
          _divider(),
          _decimalTile(),
          _divider(),
          _negateTile(),
        ]),
        SizedBox(height: AppSpacing.lg),

        _header(L10n.of(context).importWhereItGoes),
        _card([
          _walletTile(),
          _divider(),
          _duplicatesTile(),
          _divider(),
          _categoriesTile(),
        ]),
        SizedBox(height: AppSpacing.lg),

        _header(L10n.of(context).importWhatWillBeAdded),
        _summary(preview),
        SizedBox(height: AppSpacing.md),
        _rowsPreview(preview),
        if (preview.unusableCount > 0) ...[
          SizedBox(height: AppSpacing.md),
          _problems(preview),
        ],
        SizedBox(height: AppSpacing.xl),

        _importButton(preview),
        SizedBox(height: AppSpacing.md),
        TextButton(
          onPressed: _busy ? null : _saveTemplate,
          child: Text(L10n.of(context).importRememberTheseSettingsForThis),
        ),
      ],
    );
  }

  Widget _fileCard(CsvDocument document) => _card([
    ListTile(
      leading: _leading(Icons.description_outlined, AppColors.primaryAccent),
      title: Text(
        _fileName,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        [
          L10n.of(context).importRowsCount(document.body.length),
          L10n.of(context).importColumnsCount(document.columnCount),
          L10n.of(
            context,
          ).importSeparatedBy(_delimiterName(document.delimiter)),
          if (_template != null)
            L10n.of(context).importMappedAs(_template!.name),
        ].join(' · '),
        style: TextStyle(color: AppColors.textMuted, fontSize: 13),
      ),
      trailing: TextButton(
        onPressed: _busy
            ? null
            : () => setState(() {
                _document = null;
                _template = null;
              }),
        child: Text(L10n.of(context).importChange),
      ),
    ),
  ]);

  /// One row per field, offering the columns the file actually has.
  Widget _columnPicker(ImportField field, CsvDocument document) {
    final header = document.header;
    final selected = _mapping.indexOf(field);

    return ListTile(
      title: Text(field.label, style: TextStyle(color: AppColors.textPrimary)),
      subtitle: selected == null
          ? Text(
              field.required
                  ? L10n.of(context).importRequired
                  : L10n.of(context).importNotImported,
              style: TextStyle(
                color: field.required ? AppColors.warning : AppColors.textMuted,
                fontSize: 13,
              ),
            )
          : Text(
              // The first value under the column, so the choice can be checked
              // against the data rather than trusted from the heading.
              _sampleFor(selected),
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
      trailing: DropdownButton<int?>(
        value: selected,
        dropdownColor: AppColors.primarySurface,
        underline: const SizedBox.shrink(),
        hint: Text('—', style: TextStyle(color: AppColors.textMuted)),
        items: [
          const DropdownMenuItem<int?>(child: Text('—')),
          for (var i = 0; i < header.length; i++)
            DropdownMenuItem<int?>(value: i, child: Text(header[i])),
        ],
        onChanged: (index) => setState(() {
          _mapping = _mapping.assign(field, index);
          if (field == ImportField.date && index != null) {
            // A different date column almost certainly means a different
            // format, and carrying the old one over would reject every row.
            _mapping = _mapping.copyWith(
              dateFormat: ImportValuesGuess.dateFormat(_document!, index),
            );
          }
        }),
      ),
    );
  }

  String _sampleFor(int index) {
    for (final row in _document!.body) {
      final value = CsvDocument.cell(row, index);
      if (value.isNotEmpty) return value;
    }
    return L10n.of(context).importEmptySample;
  }

  /// The date format, with the guess shown against a real value from the file.
  ///
  /// This is the field most worth getting right and the one nobody can check in
  /// the abstract, so the preview is not optional decoration — it is the only
  /// way to see that `03/04` was read as the 3rd of April rather than the 4th
  /// of March.
  Widget _dateFormatTile() {
    final index = _mapping.indexOf(ImportField.date);
    final sample = index == null ? '' : _sampleFor(index);
    final pattern = _mapping.dateFormat;
    final parsed = pattern == null
        ? null
        : ImportValues.parseDate(sample, pattern);
    final dateFormat = ref.watch(dateFormatSettingProvider);

    return ListTile(
      title: Text(
        L10n.of(context).importDateFormat,
        style: TextStyle(color: AppColors.textPrimary),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSpacing.xs),
          DropdownButton<String>(
            value: pattern,
            isExpanded: true,
            dropdownColor: AppColors.primarySurface,
            hint: Text(
              L10n.of(context).importChooseOne,
              style: TextStyle(color: AppColors.textMuted),
            ),
            items: [
              for (final candidate in ImportValues.candidateDateFormats)
                DropdownMenuItem(value: candidate, child: Text(candidate)),
            ],
            onChanged: (value) =>
                setState(() => _mapping = _mapping.copyWith(dateFormat: value)),
          ),
          Text(
            sample.isEmpty
                ? L10n.of(context).importPickDateColumnFirst
                : parsed == null
                ? L10n.of(context).importDateDoesNotFit(sample)
                : L10n.of(context).importDateReadsAs(
                    sample,
                    AppDateFormatter.formatDate(parsed, dateFormat),
                  ),
            style: TextStyle(
              color: parsed == null && sample.isNotEmpty
                  ? AppColors.error
                  : AppColors.textMuted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _decimalTile() {
    final separator = _mapping.decimalSeparator;
    return ListTile(
      title: Text(
        L10n.of(context).importDecimalPoint,
        style: TextStyle(color: AppColors.textPrimary),
      ),
      subtitle: Text(
        separator == null
            ? L10n.of(context).importDecimalAuto
            : separator == '.'
            ? L10n.of(context).importDecimalFullStop
            : L10n.of(context).importDecimalComma,
        style: TextStyle(color: AppColors.textMuted, fontSize: 13),
      ),
      trailing: DropdownButton<String?>(
        value: separator,
        dropdownColor: AppColors.primarySurface,
        underline: const SizedBox.shrink(),
        hint: Text(L10n.of(context).importAuto),
        items: [
          DropdownMenuItem<String?>(child: Text(L10n.of(context).importAuto)),
          DropdownMenuItem<String?>(value: '.', child: Text('.')),
          DropdownMenuItem<String?>(value: ',', child: Text(',')),
        ],
        onChanged: (value) => setState(
          () => _mapping = ColumnMapping(
            columns: _mapping.columns,
            dateFormat: _mapping.dateFormat,
            decimalSeparator: value,
            negateAmounts: _mapping.negateAmounts,
          ),
        ),
      ),
    );
  }

  Widget _negateTile() => SwitchListTile(
    value: _mapping.negateAmounts,
    onChanged: (value) =>
        setState(() => _mapping = _mapping.copyWith(negateAmounts: value)),
    title: Text(
      L10n.of(context).importFlipTheSigns,
      style: TextStyle(color: AppColors.textPrimary),
    ),
    subtitle: Text(
      L10n.of(context).importForExportsThatWriteA,
      style: TextStyle(color: AppColors.textMuted, fontSize: 13),
    ),
  );

  Widget _walletTile() {
    final wallets = ref.watch(selectableWalletsProvider);
    return ListTile(
      title: Text(
        L10n.of(context).entityAccount,
        style: TextStyle(color: AppColors.textPrimary),
      ),
      subtitle: Text(
        L10n.of(context).importWhereRowsGoWhenThe,
        style: TextStyle(color: AppColors.textMuted, fontSize: 13),
      ),
      trailing: DropdownButton<String>(
        value: _walletId,
        dropdownColor: AppColors.primarySurface,
        underline: const SizedBox.shrink(),
        items: [
          for (final wallet in wallets)
            DropdownMenuItem(value: wallet.id, child: Text(wallet.name)),
        ],
        onChanged: (value) => setState(() => _walletId = value),
      ),
    );
  }

  Widget _duplicatesTile() => SwitchListTile(
    value: _skipDuplicates,
    onChanged: (value) => setState(() => _skipDuplicates = value),
    title: Text(
      L10n.of(context).importSkipWhatIsAlreadyHere,
      style: TextStyle(color: AppColors.textPrimary),
    ),
    subtitle: Text(
      L10n.of(context).importDuplicatesHint,
      style: TextStyle(color: AppColors.textMuted, fontSize: 13),
    ),
  );

  Widget _categoriesTile() => SwitchListTile(
    value: _createMissingCategories,
    onChanged: (value) => setState(() => _createMissingCategories = value),
    title: Text(
      L10n.of(context).importCreateCategoriesTheFileNames,
      style: TextStyle(color: AppColors.textPrimary),
    ),
    subtitle: Text(
      L10n.of(context).importOtherwiseThoseRowsArriveUncategorised,
      style: TextStyle(color: AppColors.textMuted, fontSize: 13),
    ),
  );

  // -------------------------------------------------------------- preview

  Widget _summary(ImportPreview preview) {
    if (!_mapping.isUsable) {
      final missing = _mapping.missing;
      return _warning(
        missing.length > 1
            ? L10n.of(context).importStillNeedsBoth(missing[0], missing[1])
            : L10n.of(context).importStillNeeds(missing.first),
      );
    }
    if (preview.usableCount == 0) {
      return _warning(L10n.of(context).importNothingReadable);
    }

    final currency = ref
        .watch(selectableWalletsProvider)
        .where((w) => w.id == _walletId)
        .firstOrNull
        ?.currency;
    final numberFormat = ref.watch(numberFormatSettingProvider);
    String money(int cents) =>
        cents.formatCurrency(currency ?? 'USD', numberFormat: numberFormat);

    final from = preview.earliest;
    final to = preview.latest;
    final dateFormat = ref.watch(dateFormatSettingProvider);

    return _card([
      ListTile(
        leading: _leading(Icons.playlist_add_check, AppColors.success),
        title: Text(
          L10n.of(context).importTransactionsCount(preview.usableCount),
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          [
            if (from != null && to != null)
              '${AppDateFormatter.formatDate(from, dateFormat)} — '
                  '${AppDateFormatter.formatDate(to, dateFormat)}',
            L10n.of(context).importAmountIn(money(preview.incomeCents)),
            L10n.of(context).importAmountOut(money(preview.expenseCents)),
          ].join('\n'),
          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
        isThreeLine: true,
      ),
      if (preview.categoryNames.isNotEmpty) ...[
        _divider(),
        ListTile(
          leading: _leading(Icons.label_outline, AppColors.primaryAccent),
          title: Text(
            L10n.of(context).importCategoriesInThisFile,
            style: TextStyle(color: AppColors.textPrimary),
          ),
          subtitle: Text(
            preview.categoryNames.join(', '),
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ),
      ],
    ]);
  }

  /// The first handful of rows as they will actually be stored.
  Widget _rowsPreview(ImportPreview preview) {
    final rows = preview.usable.take(8).toList();
    if (rows.isEmpty) return const SizedBox.shrink();

    final dateFormat = ref.watch(dateFormatSettingProvider);
    final numberFormat = ref.watch(numberFormatSettingProvider);
    final currency = ref
        .watch(selectableWalletsProvider)
        .where((w) => w.id == _walletId)
        .firstOrNull
        ?.currency;

    return _card([
      for (var i = 0; i < rows.length; i++) ...[
        if (i > 0) _divider(),
        ListTile(
          dense: true,
          title: Text(
            rows[i].title,
            style: TextStyle(color: AppColors.textPrimary),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            AppDateFormatter.formatDate(rows[i].date!, dateFormat),
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          trailing: Text(
            rows[i].amountCents!.abs().formatCurrency(
              currency ?? 'USD',
              numberFormat: numberFormat,
            ),
            style: TextStyle(
              color: rows[i].isIncome ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
      if (preview.usableCount > rows.length)
        Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Text(
            L10n.of(context).importAndMore(preview.usableCount - rows.length),
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ),
    ]);
  }

  /// Lines the file cannot supply, named so they can be looked up and fixed.
  Widget _problems(ImportPreview preview) {
    final problems = preview.unusable.take(10).toList();
    return _card([
      ListTile(
        leading: _leading(Icons.report_problem_outlined, AppColors.warning),
        title: Text(
          L10n.of(context).importLinesSkipped(preview.unusableCount),
          style: TextStyle(color: AppColors.textPrimary),
        ),
        subtitle: Text(
          [
            for (final row in problems)
              L10n.of(
                context,
              ).importLineProblem(row.lineNumber, '${row.problem}'),
            if (preview.unusableCount > problems.length)
              L10n.of(
                context,
              ).importAndMore(preview.unusableCount - problems.length),
          ].join('\n'),
          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
        isThreeLine: true,
      ),
    ]);
  }

  Widget _importButton(ImportPreview preview) {
    final ready =
        _mapping.isUsable && preview.usableCount > 0 && _walletId != null;
    return ElevatedButton(
      onPressed: _busy || !ready ? null : _runImport,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryAccent,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
      ),
      child: _busy
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              _walletId == null
                  ? L10n.of(context).importAddAccountFirst
                  : L10n.of(context).importImportCount(preview.usableCount),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
    );
  }

  // --------------------------------------------------------------- doing it

  Future<void> _runImport() async {
    final preview = _preview;
    final confirmed = await showConfirmationDialog(
      context: context,
      title: L10n.of(context).importConfirmTitle(preview.usableCount),
      message: [
        L10n.of(context).importConfirmBody,
        if (preview.unusableCount > 0)
          L10n.of(context).importLinesSkippedSentence(preview.unusableCount),
        if (_skipDuplicates) L10n.of(context).importConfirmDuplicates,
      ].join('\n\n'),
      confirmText: L10n.of(context).importImport,
    );
    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    try {
      final result = await ref
          .read(csvImportServiceProvider)
          .import(
            preview: preview,
            walletId: _walletId!,
            createMissingCategories: _createMissingCategories,
            skipDuplicates: _skipDuplicates,
          );

      if (!mounted) return;
      reloadAllData(ref);
      await _showOutcome(result);
    } catch (e) {
      if (mounted) _say(L10n.of(context).importFailed('$e'), bad: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// What actually happened, in full.
  ///
  /// A snackbar saying "imported!" is not enough for something that just wrote
  /// hundreds of rows: the skipped duplicates, the categories created and the
  /// account names that did not match all change what the user should do next.
  Future<void> _showOutcome(ImportResult result) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.of(context).importImportedTitle(result.imported)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final line in [
              if (result.skippedAsDuplicates > 0)
                L10n.of(
                  context,
                ).importSkippedDuplicates(result.skippedAsDuplicates),
              if (result.unusable > 0)
                L10n.of(context).importUnreadableLines(result.unusable),
              if (result.createdCategories.isNotEmpty)
                L10n.of(
                  context,
                ).importNewCategories(result.createdCategories.join(', ')),
              if (result.unmatchedAccounts.isNotEmpty)
                L10n.of(
                  context,
                ).importUnmatchedAccounts(result.unmatchedAccounts.join(', ')),
            ])
              Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text(
                  line,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(L10n.of(context).importDone),
          ),
        ],
      ),
    );
  }

  Future<void> _saveTemplate() async {
    final controller = TextEditingController(
      text: _template?.name ?? _fileName.replaceAll(RegExp(r'\.\w+$'), ''),
    );
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.of(context).importRememberThisBank),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L10n.of(context).importRememberBody,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            SizedBox(height: AppSpacing.sm),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(labelText: L10n.of(context).payName),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(L10n.of(context).actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(L10n.of(context).actionSave),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty || !mounted) return;

    if (!_document!.hasHeader) {
      _say(L10n.of(context).importNoHeaderCannotSave, bad: true);
      return;
    }

    final saved = await ref
        .read(importTemplateServiceProvider)
        .save(
          id: _template?.id,
          name: name,
          document: _document!,
          mapping: _mapping,
          defaultWalletId: _walletId,
        );

    if (!mounted) return;
    setState(() => _template = saved);
    ref.invalidate(importTemplatesProvider);
    _say(L10n.of(context).importTemplateSaved);
  }

  // ---------------------------------------------------------------- chrome

  static String _delimiterName(String delimiter) => switch (delimiter) {
    ',' => appL10n.importDelimCommas,
    ';' => appL10n.importDelimSemicolons,
    '\t' => appL10n.importDelimTabs,
    '|' => appL10n.importDelimPipes,
    _ => '"$delimiter"',
  };

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
      Divider(height: 1, thickness: 1, color: AppColors.divider);

  Widget _leading(IconData icon, Color color) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(icon, color: color, size: 22),
  );

  Widget _info(String message) =>
      _banner(message, AppColors.primaryAccent, Symbols.info_rounded);

  Widget _warning(String message) =>
      _banner(message, AppColors.warning, Icons.warning_amber);

  Widget _banner(String message, Color color, IconData icon) => Container(
    padding: EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: AppSpacing.borderRadiusLg,
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Row(
      children: [
        Icon(icon, color: color),
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

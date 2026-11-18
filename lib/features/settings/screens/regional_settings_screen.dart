import 'package:material_ui/material_ui.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise_page.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/core/providers/locale_provider.dart';
import 'package:the_accountant/core/utils/time_formatter.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/domain/regional_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/settings/widgets/settings_tile.dart';
import 'package:the_accountant/shared/widgets/currency_picker_sheet.dart';

class RegionalSettingsScreen extends ConsumerWidget {
  const RegionalSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);
    final l10n = L10n.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(l10n.settingsRegionalTitle),
      ),
      body: CappedBody(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          children: [
            // CURRENCY SECTION
            SettingsSection(
              title: l10n.settingsSectionCurrency,
              tiles: [
                SettingsNavigationTile(
                  icon: Icons.attach_money,
                  title: l10n.settingsDefaultCurrency,
                  subtitle: settingsState.currency,
                  onTap: () => _showCurrencyPicker(context, ref),
                ),
                SettingsNavigationTile(
                  icon: Icons.currency_exchange,
                  title: l10n.settingsExchangeRates,
                  subtitle: l10n.settingsExchangeRatesSubtitle,
                  onTap: () => Navigator.pushNamed(context, '/exchange-rates'),
                ),
              ],
            ),

            // FORMAT SECTION
            SettingsSection(
              title: l10n.settingsSectionDisplayFormat,
              tiles: [
                SettingsNavigationTile(
                  icon: Icons.calendar_today_outlined,
                  title: l10n.settingsDateFormat,
                  subtitle: _getDateFormatLabel(settingsState.dateFormat, ref),
                  onTap: () => _showDateFormatPicker(context, ref),
                ),
                SettingsNavigationTile(
                  icon: Icons.numbers,
                  title: l10n.settingsNumberFormat,
                  subtitle: _getNumberFormatExample(settingsState.numberFormat),
                  onTap: () => _showNumberFormatPicker(context, ref),
                ),
                SettingsNavigationTile(
                  icon: Icons.sell_outlined,
                  title: l10n.settingsCurrencySymbol,
                  subtitle: settingsState.symbolPosition.example,
                  onTap: () => _showSymbolPositionPicker(context, ref),
                ),
                SettingsNavigationTile(
                  icon: Icons.schedule,
                  title: l10n.settingsTimeFormat,
                  subtitle: _timeFormatLabel(settingsState.timeFormat, l10n),
                  onTap: () => _showTimeFormatPicker(context, ref),
                ),
                SettingsNavigationTile(
                  icon: Icons.view_week_outlined,
                  title: l10n.settingsFirstDayOfWeek,
                  subtitle: _weekdayLabel(settingsState.firstDayOfWeek, l10n),
                  onTap: () => _showFirstDayPicker(context, ref),
                ),
              ],
            ),

            // LANGUAGE SECTION
            SettingsSection(
              title: l10n.settingsSectionLanguage,
              tiles: [
                SettingsNavigationTile(
                  icon: Icons.translate,
                  title: l10n.settingsLanguage,
                  subtitle: ref.watch(localeProvider) == null
                      ? l10n.languageSystem
                      : AppLanguages.labelFor(ref.watch(localeProvider)),
                  onTap: () => _showLanguagePicker(context, ref),
                ),
              ],
            ),

            // PREVIEW SECTION
            _buildPreviewCard(context, settingsState),

            SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard(BuildContext context, SettingsState settings) {
    final l10n = L10n.of(context);
    final now = DateTime.now();
    final formattedDate = _formatDate(now, settings.dateFormat);
    // Through the real formatter rather than a local copy of it, so the preview
    // cannot claim one thing while the rest of the app does another.
    final formattedAmount = 1234567.formatCurrency(
      settings.currency,
      numberFormat: settings.numberFormat,
      symbolPosition: settings.symbolPosition,
    );
    final formattedTime = AppTimeFormatter.formatTime(
      now,
      use24Hour: settings.timeFormat.resolve(
        platformUses24Hour: AppTimeFormatter.platformUses24Hour(context),
      ),
    );
    final weekStart = FirstDayOfWeek.startOfWeek(now, settings.firstDayOfWeek);

    return Container(
      margin: EdgeInsets.only(top: AppSpacing.lg),
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settingsPreview,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          _buildPreviewRow(l10n.previewDate, formattedDate),
          SizedBox(height: AppSpacing.sm),
          _buildPreviewRow(l10n.previewTime, formattedTime),
          SizedBox(height: AppSpacing.sm),
          _buildPreviewRow(l10n.previewAmount, formattedAmount),
          SizedBox(height: AppSpacing.sm),
          _buildPreviewRow(
            l10n.previewWeekStarts,
            AppDateFormatter.formatDate(weekStart, settings.dateFormat),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: AppColors.textSecondary)),
        Text(
          value,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date, String format) {
    return AppDateFormatter.formatDate(date, format);
  }

  String _getDateFormatLabel(String format, WidgetRef ref) {
    final formats = ref.read(dateFormatsProvider);
    final match = formats.firstWhere(
      (f) => f['value'] == format,
      orElse: () => {'label': format},
    );
    return match['label']!;
  }

  String _getNumberFormatExample(String format) {
    switch (format) {
      case 'comma_dot':
        return '1,234.56';
      case 'dot_comma':
        return '1.234,56';
      case 'space_comma':
        return '1 234,56';
      case 'none_dot':
        return '1234.56';
      default:
        return '1,234.56';
    }
  }

  Future<void> _showCurrencyPicker(BuildContext context, WidgetRef ref) async {
    final currentCurrency = ref.read(settingsProvider).currency;

    final selected = await showCurrencyPickerSheet(
      context,
      selectedCurrency: currentCurrency,
    );

    if (selected != null) {
      await ref.read(settingsProvider.notifier).setCurrency(selected);
    }
  }

  Future<void> _showDateFormatPicker(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final formats = ref.read(dateFormatsProvider);
    final currentFormat = ref.read(settingsProvider).dateFormat;

    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => _PickerSheet(
        title: L10n.of(context).selectDateFormat,
        items: formats,
        selectedValue: currentFormat,
      ),
    );

    if (selected != null) {
      await ref.read(settingsProvider.notifier).setDateFormat(selected);
    }
  }

  /// The English labels on [SymbolPosition] and friends are the fallback for
  /// callers with no context; the screen resolves them properly.
  String _symbolPositionLabel(SymbolPosition position, L10n l10n) =>
      switch (position) {
        SymbolPosition.before => l10n.symbolBeforeAmount,
        SymbolPosition.after => l10n.symbolAfterAmount,
      };

  String _timeFormatLabel(TimeFormatChoice choice, L10n l10n) =>
      switch (choice) {
        TimeFormatChoice.system => l10n.choiceMatchMyPhone,
        TimeFormatChoice.twelveHour => l10n.time12Hour,
        TimeFormatChoice.twentyFourHour => l10n.time24Hour,
      };

  String _weekdayLabel(int day, L10n l10n) => switch (day) {
    DateTime.monday => l10n.weekdayMonday,
    DateTime.saturday => l10n.weekdaySaturday,
    DateTime.sunday => l10n.weekdaySunday,
    _ => l10n.choiceMatchMyPhone,
  };

  Future<void> _showLanguagePicker(BuildContext context, WidgetRef ref) async {
    // A sentinel, because null already means "follow the phone" and the sheet
    // returns null when it is dismissed. Without one, cancelling would look
    // like choosing the default.
    const followPhone = Locale('und');
    final current = ref.read(localeProvider) ?? followPhone;

    final selected = await _pickOne<Locale>(
      context: context,
      title: L10n.of(context).settingsLanguage,
      options: [
        for (final locale in AppLanguages.supported)
          (
            value: locale ?? followPhone,
            label: locale == null
                ? L10n.of(context).languageSystem
                : AppLanguages.labelFor(locale),
          ),
      ],
      current: current,
    );
    if (selected == null) return;
    await ref
        .read(localeProvider.notifier)
        .setLocale(selected == followPhone ? null : selected);
  }

  Future<void> _showSymbolPositionPicker(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final selected = await _pickOne<SymbolPosition>(
      context: context,
      title: L10n.of(context).settingsCurrencySymbol,
      options: [
        for (final position in SymbolPosition.values)
          (
            value: position,
            label:
                '${_symbolPositionLabel(position, L10n.of(context))}'
                '  ${position.example}',
          ),
      ],
      current: ref.read(settingsProvider).symbolPosition,
    );
    if (selected != null) {
      await ref.read(settingsProvider.notifier).setSymbolPosition(selected);
    }
  }

  Future<void> _showTimeFormatPicker(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final selected = await _pickOne<TimeFormatChoice>(
      context: context,
      title: L10n.of(context).settingsTimeFormat,
      options: [
        for (final choice in TimeFormatChoice.values)
          (value: choice, label: _timeFormatLabel(choice, L10n.of(context))),
      ],
      current: ref.read(settingsProvider).timeFormat,
    );
    if (selected != null) {
      await ref.read(settingsProvider.notifier).setTimeFormat(selected);
    }
  }

  Future<void> _showFirstDayPicker(BuildContext context, WidgetRef ref) async {
    final selected = await _pickOne<int>(
      context: context,
      title: L10n.of(context).settingsFirstDayOfWeek,
      options: [
        for (final day in FirstDayOfWeek.labels.keys)
          (value: day, label: _weekdayLabel(day, L10n.of(context))),
      ],
      current: ref.read(settingsProvider).firstDayOfWeek,
    );
    if (selected != null) {
      await ref.read(settingsProvider.notifier).setFirstDayOfWeek(selected);
    }
  }

  Future<void> _showNumberFormatPicker(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final formats = ref.read(numberFormatsProvider);
    final currentFormat = ref.read(settingsProvider).numberFormat;

    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => _PickerSheet(
        title: L10n.of(context).selectNumberFormat,
        items: formats,
        selectedValue: currentFormat,
      ),
    );

    if (selected != null) {
      await ref.read(settingsProvider.notifier).setNumberFormat(selected);
    }
  }
}

/// One sheet shape for the three settings that are a short list of choices.
Future<T?> _pickOne<T>({
  required BuildContext context,
  required String title,
  required List<({T value, String label})> options,
  required T current,
}) {
  return showModalBottomSheet<T>(
    context: context,
    // Eleven languages do not fit a default sheet on a short or wide screen;
    // the last few were cut off and could not be chosen. The list scrolls.
    isScrollControlled: true,
    builder: (context) => SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final option in options)
                    ListTile(
                      title: Text(
                        option.label,
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                      trailing: option.value == current
                          ? Icon(Icons.check, color: AppColors.primaryAccent)
                          : null,
                      onTap: () => Navigator.pop(context, option.value),
                    ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    ),
  );
}

class _PickerSheet extends StatelessWidget {
  const _PickerSheet({
    required this.title,
    required this.items,
    required this.selectedValue,
  });

  final String title;
  final List<Map<String, String>> items;
  final String selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.close, color: AppColors.textMuted),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: AppColors.divider),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = item['value'] == selectedValue;
              return ListTile(
                title: Text(
                  item['label']!,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primaryAccent
                        : AppColors.textPrimary,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check, color: AppColors.primaryAccent)
                    : null,
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.pop(context, item['value']);
                },
              );
            },
          ),
        ),
        SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

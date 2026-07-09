import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/core/utils/number_formatter.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/settings/widgets/settings_tile.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';

class RegionalSettingsScreen extends ConsumerWidget {
  const RegionalSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Regional Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          // CURRENCY SECTION
          SettingsSection(
            title: 'CURRENCY',
            tiles: [
              SettingsNavigationTile(
                icon: Icons.attach_money,
                title: 'Default Currency',
                subtitle: settingsState.currency,
                onTap: () => _showCurrencyPicker(context, ref),
              ),
              SettingsNavigationTile(
                icon: Icons.currency_exchange,
                title: 'Exchange Rates',
                subtitle: 'Manage currency conversion rates',
                onTap: () => Navigator.pushNamed(context, '/exchange-rates'),
              ),
            ],
          ),

          // FORMAT SECTION
          SettingsSection(
            title: 'DISPLAY FORMAT',
            tiles: [
              SettingsNavigationTile(
                icon: Icons.calendar_today_outlined,
                title: 'Date Format',
                subtitle: _getDateFormatLabel(settingsState.dateFormat, ref),
                onTap: () => _showDateFormatPicker(context, ref),
              ),
              SettingsNavigationTile(
                icon: Icons.numbers,
                title: 'Number Format',
                subtitle: _getNumberFormatExample(settingsState.numberFormat),
                onTap: () => _showNumberFormatPicker(context, ref),
              ),
            ],
          ),

          // PREVIEW SECTION
          _buildPreviewCard(settingsState),

          SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildPreviewCard(SettingsState settings) {
    final now = DateTime.now();
    final formattedDate = _formatDate(now, settings.dateFormat);
    final formattedNumber = _formatNumber(12345.67, settings.numberFormat);

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
            'Preview',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          _buildPreviewRow('Date', formattedDate),
          SizedBox(height: AppSpacing.sm),
          _buildPreviewRow('Amount', '${settings.currency} $formattedNumber'),
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

  String _formatNumber(double number, String format) {
    return AppNumberFormatter.get(format).format(number);
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

    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: _CurrencyPickerSheet(selectedCurrency: currentCurrency),
      ),
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
      backgroundColor: AppColors.primarySurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _PickerSheet(
        title: 'Select Date Format',
        items: formats,
        selectedValue: currentFormat,
      ),
    );

    if (selected != null) {
      await ref.read(settingsProvider.notifier).setDateFormat(selected);
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
      backgroundColor: AppColors.primarySurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _PickerSheet(
        title: 'Select Number Format',
        items: formats,
        selectedValue: currentFormat,
      ),
    );

    if (selected != null) {
      await ref.read(settingsProvider.notifier).setNumberFormat(selected);
    }
  }
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

class _CurrencyPickerSheet extends ConsumerStatefulWidget {
  const _CurrencyPickerSheet({required this.selectedCurrency});

  final String selectedCurrency;

  @override
  ConsumerState<_CurrencyPickerSheet> createState() =>
      _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends ConsumerState<_CurrencyPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyState = ref.watch(currencyProvider);
    final filteredCurrencies = currencyState.searchCurrencies(_searchQuery);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Select Currency',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search by code or name...',
                hintStyle: TextStyle(color: AppColors.textMuted),
                prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: AppColors.textMuted),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          const SizedBox(height: 16),
          // Loading state
          if (currencyState.isLoading &&
              currencyState.availableCurrencies.isEmpty)
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    ShimmerCard(height: 56),
                    SizedBox(height: 12),
                    ShimmerCard(height: 56),
                    SizedBox(height: 12),
                    ShimmerCard(height: 56),
                    SizedBox(height: 12),
                    ShimmerCard(height: 56),
                  ],
                ),
              ),
            )
          // Error state
          else if (currencyState.error != null &&
              currencyState.availableCurrencies.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    const SizedBox(height: 12),
                    Text(
                      currencyState.error!,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () =>
                          ref.read(currencyProvider.notifier).loadCurrencies(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          // Currency list
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: filteredCurrencies.length,
                itemBuilder: (context, index) {
                  final entry = filteredCurrencies[index];
                  final code = entry.key;
                  final name = entry.value;
                  final isSelected =
                      widget.selectedCurrency.toUpperCase() == code;
                  final symbol = CurrencyInfo.getSymbol(code);
                  final displaySymbol = symbol.length > 3
                      ? code.substring(0, 3)
                      : symbol;

                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.pop(context, code);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryAccent.withValues(alpha: 0.1)
                            : Colors.white.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(14),
                        border: isSelected
                            ? Border.all(
                                color: AppColors.primaryAccent,
                                width: 1.5,
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryAccent.withValues(
                                      alpha: 0.15,
                                    )
                                  : Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(4),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                displaySymbol,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.primaryAccent
                                      : AppColors.textPrimary,
                                  fontSize: displaySymbol.length > 2
                                      ? 12.0
                                      : 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  code,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? AppColors.primaryAccent
                                        : AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textMuted,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: AppColors.primaryAccent,
                              size: 22,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

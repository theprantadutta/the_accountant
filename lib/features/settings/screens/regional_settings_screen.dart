import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/settings/widgets/settings_tile.dart';

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
    switch (format) {
      case 'MM/dd/yyyy':
        return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
      case 'dd/MM/yyyy':
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      case 'yyyy-MM-dd':
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      case 'dd MMM yyyy':
        final months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        return '${date.day} ${months[date.month - 1]} ${date.year}';
      case 'MMM dd, yyyy':
        final months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        return '${months[date.month - 1]} ${date.day}, ${date.year}';
      default:
        return '${date.month}/${date.day}/${date.year}';
    }
  }

  String _formatNumber(double number, String format) {
    final intPart = number.floor().toString();
    final decPart = ((number - number.floor()) * 100)
        .round()
        .toString()
        .padLeft(2, '0');

    String formatIntPart(String s, String thousand) {
      final result = StringBuffer();
      for (int i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) {
          result.write(thousand);
        }
        result.write(s[i]);
      }
      return result.toString();
    }

    switch (format) {
      case 'comma_dot':
        return '${formatIntPart(intPart, ',')}.$decPart';
      case 'dot_comma':
        return '${formatIntPart(intPart, '.')},$decPart';
      case 'space_comma':
        return '${formatIntPart(intPart, ' ')},$decPart';
      case 'none_dot':
        return '$intPart.$decPart';
      default:
        return '${formatIntPart(intPart, ',')}.$decPart';
    }
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
    final currencies = ref.read(currenciesProvider);
    final currentCurrency = ref.read(settingsProvider).currency;

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.primarySurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => _CurrencyPickerSheet(
          currencies: currencies,
          selectedCurrency: currentCurrency,
          scrollController: scrollController,
        ),
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

class _CurrencyPickerSheet extends StatefulWidget {
  const _CurrencyPickerSheet({
    required this.currencies,
    required this.selectedCurrency,
    required this.scrollController,
  });

  final List<String> currencies;
  final String selectedCurrency;
  final ScrollController scrollController;

  @override
  State<_CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<_CurrencyPickerSheet> {
  late TextEditingController _searchController;
  late List<String> _filteredCurrencies;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredCurrencies = widget.currencies;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCurrencies(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCurrencies = widget.currencies;
      } else {
        _filteredCurrencies = widget.currencies
            .where((c) => c.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Text(
                'Select Currency',
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.glassWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: AppColors.textPrimary),
              onChanged: _filterCurrencies,
              decoration: InputDecoration(
                hintText: 'Search currencies...',
                hintStyle: TextStyle(color: AppColors.textMuted),
                prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Divider(height: 1, color: AppColors.divider),
        Expanded(
          child: ListView.builder(
            controller: widget.scrollController,
            itemCount: _filteredCurrencies.length,
            itemBuilder: (context, index) {
              final currency = _filteredCurrencies[index];
              final isSelected = currency == widget.selectedCurrency;
              return ListTile(
                title: Text(
                  currency,
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
                  Navigator.pop(context, currency);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

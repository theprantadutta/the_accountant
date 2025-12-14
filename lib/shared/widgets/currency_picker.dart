import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';

/// A widget for selecting a currency from a searchable list
class CurrencyPicker extends ConsumerStatefulWidget {
  final String? selectedCurrency;
  final ValueChanged<String> onCurrencySelected;
  final String? label;
  final String? hint;
  final bool showSymbol;

  const CurrencyPicker({
    super.key,
    this.selectedCurrency,
    required this.onCurrencySelected,
    this.label,
    this.hint,
    this.showSymbol = true,
  });

  @override
  ConsumerState<CurrencyPicker> createState() => _CurrencyPickerState();
}

class _CurrencyPickerState extends ConsumerState<CurrencyPicker> {
  @override
  Widget build(BuildContext context) {
    final currencyState = ref.watch(currencyProvider);
    final selectedName = widget.selectedCurrency != null
        ? currencyState.availableCurrencies[widget.selectedCurrency!.toUpperCase()]
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: AppTypography.labelMedium),
          AppSpacing.gapSm,
        ],
        InkWell(
          onTap: () => _showCurrencyPicker(context),
          borderRadius: AppSpacing.borderRadiusMd,
          child: Container(
            padding: AppSpacing.paddingMd,
            decoration: BoxDecoration(
              color: AppColors.glassWhite,
              borderRadius: AppSpacing.borderRadiusMd,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              children: [
                if (widget.selectedCurrency != null && widget.showSymbol) ...[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryAccent.withValues(alpha: 0.2),
                      borderRadius: AppSpacing.borderRadiusSm,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      CurrencyInfo.getSymbol(widget.selectedCurrency!),
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.primaryAccent,
                      ),
                    ),
                  ),
                  AppSpacing.gapHMd,
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.selectedCurrency?.toUpperCase() ??
                            widget.hint ??
                            'Select currency',
                        style: widget.selectedCurrency != null
                            ? AppTypography.bodyLarge
                            : AppTypography.bodyLarge.copyWith(
                                color: AppColors.textSecondary,
                              ),
                      ),
                      if (selectedName != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          selectedName,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCurrencyPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CurrencyPickerSheet(
        selectedCurrency: widget.selectedCurrency,
        onCurrencySelected: (currency) {
          widget.onCurrencySelected(currency);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _CurrencyPickerSheet extends ConsumerStatefulWidget {
  final String? selectedCurrency;
  final ValueChanged<String> onCurrencySelected;

  const _CurrencyPickerSheet({
    this.selectedCurrency,
    required this.onCurrencySelected,
  });

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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.glassBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: AppSpacing.horizontalPadding(AppSpacing.md),
            child: Row(
              children: [
                Text('Select Currency', style: AppTypography.titleLarge),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Search bar
          Padding(
            padding: AppSpacing.paddingMd,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by code or name...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.glassWhite,
                border: OutlineInputBorder(
                  borderRadius: AppSpacing.borderRadiusMd,
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          // Loading state
          if (currencyState.isLoading && currencyState.availableCurrencies.isEmpty)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          // Error state
          else if (currencyState.error != null && currencyState.availableCurrencies.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    AppSpacing.gapMd,
                    Text(currencyState.error!, style: AppTypography.bodyMedium),
                    AppSpacing.gapMd,
                    ElevatedButton(
                      onPressed: () => ref.read(currencyProvider.notifier).loadCurrencies(),
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
                itemCount: filteredCurrencies.length,
                itemBuilder: (context, index) {
                  final entry = filteredCurrencies[index];
                  final code = entry.key;
                  final name = entry.value;
                  final isSelected =
                      widget.selectedCurrency?.toUpperCase() == code;
                  final symbol = CurrencyInfo.getSymbol(code);

                  return ListTile(
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryAccent.withValues(alpha: 0.2)
                            : AppColors.glassWhite,
                        borderRadius: AppSpacing.borderRadiusSm,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        symbol,
                        style: AppTypography.titleMedium.copyWith(
                          color: isSelected
                              ? AppColors.primaryAccent
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    title: Text(
                      code,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : null,
                      ),
                    ),
                    subtitle: Text(
                      name,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: AppColors.primaryAccent)
                        : null,
                    selected: isSelected,
                    onTap: () => widget.onCurrencySelected(code),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// A simple inline currency selector for forms
class CurrencyDropdown extends ConsumerWidget {
  final String? selectedCurrency;
  final ValueChanged<String?> onChanged;
  final String? hint;

  const CurrencyDropdown({
    super.key,
    this.selectedCurrency,
    required this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyState = ref.watch(currencyProvider);
    final currencies = currencyState.sortedCurrencyCodes;

    return DropdownButtonFormField<String>(
      value: selectedCurrency,
      hint: Text(hint ?? 'Select currency'),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.glassWhite,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide(color: AppColors.glassBorder),
        ),
      ),
      items: currencies.map((code) {
        final name = currencyState.availableCurrencies[code] ?? code;
        return DropdownMenuItem(
          value: code,
          child: Text('$code - $name'),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

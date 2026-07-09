import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';

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
        ? currencyState.availableCurrencies[widget.selectedCurrency!
              .toUpperCase()]
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
                  _buildCurrencySymbolBox(
                    CurrencyInfo.getSymbol(widget.selectedCurrency!),
                    widget.selectedCurrency!,
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
                Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencySymbolBox(String symbol, String code) {
    final displayText = symbol.length > 3 ? code.substring(0, 3) : symbol;
    final fontSize = displayText.length > 2 ? 12.0 : 16.0;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primaryAccent.withValues(alpha: 0.2),
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          displayText,
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.primaryAccent,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: _CurrencyPickerSheet(
          selectedCurrency: widget.selectedCurrency,
          onCurrencySelected: (currency) {
            widget.onCurrencySelected(currency);
            Navigator.pop(context);
          },
        ),
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

  // Crypto/non-fiat currencies are hidden by default. If the current selection
  // is itself a crypto currency, start enabled so the user still sees it.
  late bool _includeCrypto =
      widget.selectedCurrency != null &&
      CurrencyInfo.isCrypto(widget.selectedCurrency!);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyState = ref.watch(currencyProvider);
    final filteredCurrencies = currencyState.searchCurrencies(
      _searchQuery,
      includeCrypto: _includeCrypto,
    );

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
          // Include crypto currencies toggle (off by default)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _includeCrypto = !_includeCrypto),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: _includeCrypto
                          ? AppColors.primaryAccent
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: _includeCrypto
                            ? AppColors.primaryAccent
                            : AppColors.glassBorder,
                        width: 1.5,
                      ),
                    ),
                    child: _includeCrypto
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Include crypto currencies',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
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
                    AppSpacing.gapMd,
                    Text(currencyState.error!, style: AppTypography.bodyMedium),
                    AppSpacing.gapMd,
                    ElevatedButton(
                      onPressed: () =>
                          ref.read(currencyProvider.notifier).loadCurrencies(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          // Empty state (no matches, e.g. searching a crypto with it disabled)
          else if (filteredCurrencies.isEmpty)
            Expanded(child: _buildEmptyState())
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
                      widget.selectedCurrency?.toUpperCase() == code;
                  final symbol = CurrencyInfo.getSymbol(code);

                  return GestureDetector(
                    onTap: () => widget.onCurrencySelected(code),
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
                          _CurrencySymbolBox(
                            symbol: symbol,
                            code: code,
                            isSelected: isSelected,
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(
              'No currencies found',
              style: AppTypography.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (!_includeCrypto) ...[
              const SizedBox(height: 6),
              Text(
                "Enable 'Include crypto currencies' to search crypto tokens.",
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
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
      initialValue: selectedCurrency,
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
        return DropdownMenuItem(value: code, child: Text('$code - $name'));
      }).toList(),
      onChanged: onChanged,
    );
  }
}

/// Reusable widget for displaying currency symbols that adapts to length
class _CurrencySymbolBox extends StatelessWidget {
  final String symbol;
  final String code;
  final bool isSelected;

  const _CurrencySymbolBox({
    required this.symbol,
    required this.code,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = symbol.length > 3 ? code.substring(0, 3) : symbol;
    final fontSize = displayText.length > 2 ? 12.0 : 16.0;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryAccent.withValues(alpha: 0.15)
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          displayText,
          style: TextStyle(
            color: isSelected ? AppColors.primaryAccent : AppColors.textPrimary,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

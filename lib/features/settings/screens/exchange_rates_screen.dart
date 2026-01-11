import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/shared/widgets/neo_button.dart';

/// Screen for managing exchange rates
class ExchangeRatesScreen extends ConsumerStatefulWidget {
  const ExchangeRatesScreen({super.key});

  @override
  ConsumerState<ExchangeRatesScreen> createState() => _ExchangeRatesScreenState();
}

class _ExchangeRatesScreenState extends ConsumerState<ExchangeRatesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _baseCurrency = 'USD';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyState = ref.watch(currencyProvider);

    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Exchange Rates', style: AppTypography.titleLarge),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh rates',
              onPressed: currencyState.isLoading
                  ? null
                  : () => ref.read(currencyProvider.notifier).refreshRates(),
            ),
          ],
        ),
        body: Column(
          children: [
            // Header info
            Padding(
              padding: AppSpacing.horizontalPadding(AppSpacing.md),
              child: Container(
                padding: AppSpacing.paddingMd,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: AppSpacing.borderRadiusMd,
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.currency_exchange,
                          color: AppColors.primaryAccent,
                        ),
                        AppSpacing.gapHMd,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Base Currency: $_baseCurrency',
                                style: AppTypography.titleMedium,
                              ),
                              if (currencyState.lastFetched != null)
                                Text(
                                  'Last updated: ${_formatDate(currencyState.lastFetched!)}',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (currencyState.isLoading)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.gapMd,

            // Search bar
            Padding(
              padding: AppSpacing.horizontalPadding(AppSpacing.md),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search currencies...',
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
            AppSpacing.gapMd,

            // Rates list
            Expanded(
              child: _buildRatesList(currencyState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatesList(CurrencyState currencyState) {
    if (currencyState.isLoading && currencyState.apiRates.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (currencyState.error != null && currencyState.apiRates.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            AppSpacing.gapMd,
            Text(currencyState.error!, style: AppTypography.bodyMedium),
            AppSpacing.gapMd,
            NeoButton(
              label: 'Retry',
              style: NeoButtonStyle.primary,
              onPressed: () => ref.read(currencyProvider.notifier).loadRates(),
            ),
          ],
        ),
      );
    }

    // Filter and sort rates
    final rates = currencyState.apiRates.entries.where((entry) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      final currencyName =
          currencyState.availableCurrencies[entry.key]?.toLowerCase() ?? '';
      return entry.key.toLowerCase().contains(query) ||
          currencyName.contains(query);
    }).toList();

    rates.sort((a, b) => a.key.compareTo(b.key));

    if (rates.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 48, color: AppColors.textSecondary),
            AppSpacing.gapMd,
            Text(
              'No currencies found',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: AppSpacing.horizontalPadding(AppSpacing.md),
      itemCount: rates.length,
      itemBuilder: (context, index) {
        final entry = rates[index];
        final currencyCode = entry.key;
        final rate = entry.value;
        final currencyName =
            currencyState.availableCurrencies[currencyCode] ?? currencyCode;
        final symbol = CurrencyInfo.getSymbol(currencyCode);

        return _ExchangeRateTile(
          currencyCode: currencyCode,
          currencyName: currencyName,
          symbol: symbol,
          rate: rate,
          baseCurrency: _baseCurrency,
          onEditRate: () => _showEditRateDialog(currencyCode, rate),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else {
      return '${diff.inDays} days ago';
    }
  }

  void _showEditRateDialog(String currencyCode, double currentRate) {
    final controller = TextEditingController(text: currentRate.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primarySurface,
        title: Text('Edit Rate: $_baseCurrency → $currencyCode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current API rate: $currentRate',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.gapMd,
            TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Custom rate',
                filled: true,
                fillColor: AppColors.glassWhite,
                border: OutlineInputBorder(
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Clear custom rate
              await ref
                  .read(currencyProvider.notifier)
                  .clearCustomRate(_baseCurrency, currencyCode);
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Use API Rate'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newRate = double.tryParse(controller.text);
              if (newRate != null && newRate > 0) {
                await ref
                    .read(currencyProvider.notifier)
                    .setCustomRate(_baseCurrency, currencyCode, newRate);
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _ExchangeRateTile extends StatelessWidget {
  final String currencyCode;
  final String currencyName;
  final String symbol;
  final double rate;
  final String baseCurrency;
  final VoidCallback onEditRate;

  const _ExchangeRateTile({
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
    required this.rate,
    required this.baseCurrency,
    required this.onEditRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: ListTile(
        contentPadding: AppSpacing.paddingMd,
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryAccent.withValues(alpha: 0.2),
            borderRadius: AppSpacing.borderRadiusSm,
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(4),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              symbol.length > 3 ? currencyCode.substring(0, 3) : symbol,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primaryAccent,
                fontSize: symbol.length > 2 ? 14 : 18,
              ),
            ),
          ),
        ),
        title: Text(currencyCode, style: AppTypography.titleMedium),
        subtitle: Text(
          currencyName,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  rate.toStringAsFixed(rate < 1 ? 6 : 4),
                  style: AppTypography.titleMedium,
                ),
                Text(
                  '1 $baseCurrency = $currencyCode',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            AppSpacing.gapHSm,
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              color: AppColors.textSecondary,
              onPressed: onEditRate,
              tooltip: 'Set custom rate',
            ),
          ],
        ),
      ),
    );
  }
}

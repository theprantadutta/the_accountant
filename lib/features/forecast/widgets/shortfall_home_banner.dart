import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/forecast/providers/forecast_provider.dart';
import 'package:the_accountant/features/forecast/screens/cash_flow_forecast_screen.dart';
import 'package:the_accountant/features/forecast/services/cash_flow_forecast_service.dart';
import 'package:the_accountant/features/plans/widgets/plan_labels.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// A quiet line on the home screen when money would run short within two
/// weeks. It opens the forecast, and can be put away until the shortfall
/// moves to another day.
class ShortfallHomeBanner extends ConsumerWidget {
  const ShortfallHomeBanner({super.key, required this.forecast});

  /// One with a shortfall, from [homeShortfallProvider].
  final CashFlowForecast forecast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final f = PlanFormat(ref, context);
    final day = forecast.shortfall!;

    return SunriseCard(
      key: const Key('home_shortfall'),
      padding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CashFlowForecastScreen()),
        );
      },
      child: Row(
        children: [
          IconTile(icon: Symbols.warning_rounded, color: c.negative, size: 34),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.forecastHomeWarning(
                    f.day(day.date),
                    f.money(forecast.shortfallAmount, forecast.currency),
                  ),
                  style: SunriseType.rowTitle.copyWith(
                    color: c.ink,
                    fontSize: 14,
                  ),
                ),
                Text(
                  l10n.forecastHomeWarningBody,
                  style: SunriseType.caption.copyWith(color: c.subtle),
                ),
              ],
            ),
          ),
          IconButton(
            key: const Key('home_shortfall_dismiss'),
            tooltip: l10n.forecastDismiss,
            icon: Icon(Symbols.close_rounded, color: c.subtle, size: 20),
            onPressed: () =>
                ref.read(dismissedShortfallProvider.notifier).dismiss(day.date),
          ),
        ],
      ),
    );
  }
}

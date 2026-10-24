import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/features/forecast/providers/forecast_provider.dart';
import 'package:the_accountant/features/forecast/screens/cash_flow_forecast_screen.dart';
import 'package:the_accountant/features/forecast/services/cash_flow_forecast_service.dart';
import 'package:the_accountant/features/forecast/widgets/shortfall_home_banner.dart';

import '../helpers/localized_app.dart';

/// What the forecast screen and the home warning say about a shortfall.
void main() {
  final start = DateTime(2030, 3, 1);

  /// 1,000.00 to start, rent of 1,500.00 on the 4th, salary of 2,000.00 on
  /// the 10th: short by 500.00 from the 4th to the 9th.
  CashFlowForecast forecastOf(int days) {
    final events = [
      ForecastEvent(
        date: DateTime(2030, 3, 4),
        amount: 150000,
        isIncome: false,
        source: ForecastSource.upcoming,
        kind: ForecastEventKind.upcoming,
        title: 'Rent',
      ),
      ForecastEvent(
        date: DateTime(2030, 3, 10),
        amount: 200000,
        isIncome: true,
        source: ForecastSource.recurring,
        kind: ForecastEventKind.recurringIncome,
        title: 'Salary',
      ),
    ];
    return CashFlowForecast(
      start: start,
      days: days,
      currency: 'USD',
      startingBalance: 100000,
      events: events,
      daily: [
        for (var i = 0; i <= days; i++)
          ForecastDay(
            DateTime(2030, 3, 1 + i),
            100000 - (i >= 3 ? 150000 : 0) + (i >= 9 ? 200000 : 0),
          ),
      ],
    );
  }

  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('the screen warns of the shortfall and lists what causes it', (
    tester,
  ) async {
    final asked = <int>[];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cashFlowForecastProvider.overrideWith((ref, days) async {
            asked.add(days);
            return forecastOf(days);
          }),
        ],
        child: localizedApp(home: const CashFlowForecastScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('forecast_shortfall')), findsOneWidget);
    expect(
      find.text(r'On 4 Mar 2030 you would be $500.00 short'),
      findsOneWidget,
    );
    expect(find.text('Rent · Upcoming'), findsOneWidget);
    expect(find.byKey(const Key('forecast_chart')), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Salary'), 300);
    expect(find.text('Rent'), findsOneWidget);
    expect(find.text(r'+$2,000.00'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('90 days'), -300);
    await tester.tap(find.text('90 days'));
    await tester.pumpAndSettle();
    expect(asked, [30, 90]);
  });

  testWidgets('the home warning can be put away for that date', (tester) async {
    late WidgetRef widgetRef;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cashFlowForecastProvider.overrideWith(
            (ref, days) async => forecastOf(days),
          ),
        ],
        child: localizedApp(
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) {
                widgetRef = ref;
                final forecast = ref.watch(homeShortfallProvider);
                return forecast == null
                    ? const SizedBox()
                    : ShortfallHomeBanner(forecast: forecast);
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(r'You may be $500.00 short on 4 Mar 2030'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('home_shortfall_dismiss')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home_shortfall')), findsNothing);
    expect(widgetRef.read(dismissedShortfallProvider), '2030-03-04');
  });
}

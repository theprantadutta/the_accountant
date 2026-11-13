import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/diagnostics.dart';

void main() {
  group('being offline is not reported as a fault', () {
    final options = RequestOptions(path: '/sync');

    test('network failures are left out', () {
      for (final error in <Object>[
        const SocketException('no route'),
        TimeoutException('slow'),
        const HttpException('closed'),
        DioException.connectionError(requestOptions: options, reason: 'down'),
        DioException.connectionTimeout(
          requestOptions: options,
          timeout: const Duration(seconds: 10),
        ),
        DioException(
          requestOptions: options,
          error: const SocketException('inner'),
        ),
      ]) {
        expect(Diagnostics.isConnectivity(error), isTrue, reason: '$error');
      }
    });

    test('real faults are kept', () {
      for (final error in <Object>[
        StateError('bad state'),
        const FormatException('bad json'),
        DioException.badResponse(
          statusCode: 500,
          requestOptions: options,
          response: Response(requestOptions: options, statusCode: 500),
        ),
        DioException(requestOptions: options, error: StateError('inner')),
      ]) {
        expect(Diagnostics.isConnectivity(error), isFalse, reason: '$error');
      }
    });
  });

  test('a report is blamed on the code that logged it, not the logger', () {
    final stack = StackTrace.fromString(
      [
        '#0      _AppLogOutput.output (package:the_accountant/core/services/diagnostics.dart:140:5)',
        '#1      Logger.log (package:logger/src/logger.dart:180:9)',
        '#2      Logger.e (package:logger/src/logger.dart:120:5)',
        '#3      SyncService.syncAll (package:the_accountant/core/services/sync/sync_service.dart:88:15)',
      ].join('\n'),
    );

    final trimmed = Diagnostics.callerStack(stack).toString();

    expect(trimmed, isNot(contains('diagnostics.dart')));
    expect(trimmed, isNot(contains('package:logger/')));
    expect(trimmed, contains('SyncService.syncAll'));
  });

  group('screens are named', () {
    testWidgets('by the screen widget when the route has no name', (
      tester,
    ) async {
      final navigator = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(navigatorKey: navigator, home: const SizedBox()),
      );
      final route = MaterialPageRoute<void>(
        builder: (_) => const _BudgetsScreen(),
      );
      navigator.currentState!.push(route);
      await tester.pumpAndSettle();

      expect(ScreenTracker.screenNameOf(route), 'BudgetsScreen');
    });

    testWidgets('by its name when it has one', (tester) async {
      final navigator = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(navigatorKey: navigator, home: const SizedBox()),
      );
      final route = MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/premium'),
        builder: (_) => const _BudgetsScreen(),
      );
      navigator.currentState!.push(route);
      await tester.pumpAndSettle();

      expect(ScreenTracker.screenNameOf(route), '/premium');
    });
  });
}

// Private classes are skipped as screen names (they are the parts a screen is
// built from), so the test wraps a public-looking one.
class _BudgetsScreen extends StatelessWidget {
  const _BudgetsScreen();

  @override
  Widget build(BuildContext context) => const BudgetsScreen();
}

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(body: Text('budgets'));
}

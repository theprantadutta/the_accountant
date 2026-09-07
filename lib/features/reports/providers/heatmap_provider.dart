import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/domain/amount_converter.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/reports/domain/daily_net.dart';

/// How far back the heatmap looks.
///
/// A year, because the shape it is there to show — which months run hot, what
/// happens around payday, whether last December was as bad as it felt — only
/// appears at that length. A shorter window is just a bar chart with worse
/// labels.
const Duration kHeatmapWindow = Duration(days: 364);

/// A year of daily nets, ending today.
///
/// Autodisposed: it holds a value per day over a year, and there is no reason
/// to keep it alive while the user is somewhere else in the app.
final dailyNetCalendarProvider = FutureProvider.autoDispose<DailyNetCalendar>((
  ref,
) async {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final to = DateTime(now.year, now.month, now.day);
  final from = to.subtract(kHeatmapWindow);

  return DailyNetCalendar.build(
    transactions: await db.getAllTransactions(),
    from: from,
    to: to,
    converter: await AmountConverter.forDatabase(db),
  );
});

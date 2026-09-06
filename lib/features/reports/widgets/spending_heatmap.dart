import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/domain/regional_preferences.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/features/reports/domain/daily_net.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';

/// A year of days as coloured squares: green where more came in than went out,
/// red where it did not.
///
/// The point of it is the shape rather than any single figure — which weeks ran
/// hot, whether the end of every month looks the same — so the squares are
/// deliberately small and the detail is on tap.
class SpendingHeatmap extends StatelessWidget {
  const SpendingHeatmap({
    super.key,
    required this.calendar,
    required this.money,
    required this.dateFormat,
    this.onDayTapped,
  });

  final DailyNetCalendar calendar;

  /// Formats an amount in the user's currency and number format.
  final String Function(int cents) money;

  final String dateFormat;

  final void Function(DailyNet day)? onDayTapped;

  static const double _square = 13;
  static const double _gap = 3;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final weeks = _weeks();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Horizontal, because a year does not fit and squeezing it to fit is
        // how a heatmap becomes unreadable.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _weekdayLabels(context),
              SizedBox(width: _gap * 2),
              for (final week in weeks) _weekColumn(context, week),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md),
        _legend(context, l10n),
      ],
    );
  }

  /// The calendar split into columns, each starting on the user's first day of
  /// the week, with the leading and trailing partial weeks padded out.
  List<List<DailyNet?>> _weeks() {
    if (calendar.days.isEmpty) return const [];

    final start = FirstDayOfWeek.startOfWeek(
      calendar.days.first.day,
      RegionalPreferences.firstDayOfWeek,
    );
    final leading = calendar.days.first.day.difference(start).inDays;

    final cells = <DailyNet?>[
      ...List<DailyNet?>.filled(leading, null),
      ...calendar.days,
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    return [for (var i = 0; i < cells.length; i += 7) cells.sublist(i, i + 7)];
  }

  Widget _weekColumn(BuildContext context, List<DailyNet?> week) => Padding(
    padding: const EdgeInsets.only(right: _gap),
    child: Column(
      children: [
        for (final day in week)
          Padding(
            padding: const EdgeInsets.only(bottom: _gap),
            child: day == null
                ? const SizedBox(width: _square, height: _square)
                : _daySquare(context, day),
          ),
      ],
    ),
  );

  Widget _daySquare(BuildContext context, DailyNet day) {
    final shade = calendar.shade(day);
    final base = shade.spent ? AppColors.error : AppColors.success;

    return Tooltip(
      message: _describe(day),
      waitDuration: const Duration(milliseconds: 400),
      child: GestureDetector(
        onTap: onDayTapped == null ? null : () => onDayTapped!(day),
        child: Container(
          width: _square,
          height: _square,
          decoration: BoxDecoration(
            // An empty day is drawn, not omitted: a hole in the grid would read
            // as a missing day rather than a quiet one.
            color: shade.weight == 0
                ? AppColors.glassWhite
                : base.withValues(alpha: shade.weight),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: AppColors.glassBorder, width: 0.5),
          ),
        ),
      ),
    );
  }

  String _describe(DailyNet day) {
    final when = DateFormat(dateFormat).format(day.day);
    if (day.isEmpty) return when;
    return '$when\n${money(day.netCents)}';
  }

  /// Only alternate rows are labelled; seven labels in a 13-pixel rhythm is
  /// unreadable, and the pattern is legible from three.
  Widget _weekdayLabels(BuildContext context) {
    final anchor = FirstDayOfWeek.startOfWeek(
      DateTime.now(),
      RegionalPreferences.firstDayOfWeek,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < 7; i++)
          SizedBox(
            height: _square + _gap,
            child: i.isOdd
                ? Text(
                    DateFormat(
                      'E',
                    ).format(anchor.add(Duration(days: i))).substring(0, 1),
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 9,
                      height: 1.4,
                    ),
                  )
                : null,
          ),
      ],
    );
  }

  Widget _legend(BuildContext context, L10n l10n) => Row(
    children: [
      Text(
        l10n.heatmapSpentMore,
        style: TextStyle(color: AppColors.textMuted, fontSize: 11),
      ),
      SizedBox(width: AppSpacing.xs),
      for (final weight in const [1.0, 0.6, 0.3])
        _swatch(AppColors.error.withValues(alpha: weight)),
      _swatch(AppColors.glassWhite),
      for (final weight in const [0.3, 0.6, 1.0])
        _swatch(AppColors.success.withValues(alpha: weight)),
      SizedBox(width: AppSpacing.xs),
      Text(
        l10n.heatmapEarnedMore,
        style: TextStyle(color: AppColors.textMuted, fontSize: 11),
      ),
    ],
  );

  Widget _swatch(Color color) => Container(
    width: 10,
    height: 10,
    margin: const EdgeInsets.symmetric(horizontal: 1.5),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(2),
      border: Border.all(color: AppColors.glassBorder, width: 0.5),
    ),
  );
}

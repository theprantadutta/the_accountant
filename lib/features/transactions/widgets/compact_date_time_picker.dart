import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/core/utils/time_formatter.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// The Date row of a form: "Date ... Today, 6:02 PM ›".
///
/// The date and the time are separate tap targets, each opening its own
/// picker. The pickers use the app theme (they used to force a dark scheme,
/// which was unreadable in light mode) and honour the user's clock setting.
class CompactDateTimePicker extends StatelessWidget {
  final DateTime selectedDateTime;
  final ValueChanged<DateTime> onDateTimeChanged;

  /// Kept for callers; the row draws in the theme accent.
  final Color accentColor;
  final String? dateFormat;

  const CompactDateTimePicker({
    super.key,
    required this.selectedDateTime,
    required this.onDateTimeChanged,
    required this.accentColor,
    this.dateFormat,
  });

  String _dateLabel(DateTime date) =>
      AppDateFormatter.formatRelativeDate(date, dateFormat ?? 'MM/dd/yyyy');

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null) return;
    HapticFeedback.lightImpact();
    onDateTimeChanged(
      DateTime(
        picked.year,
        picked.month,
        picked.day,
        selectedDateTime.hour,
        selectedDateTime.minute,
      ),
    );
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      builder: (context, child) => AppTimeFormatter.withClock(context, child!),
    );
    if (picked == null) return;
    HapticFeedback.lightImpact();
    onDateTimeChanged(
      DateTime(
        selectedDateTime.year,
        selectedDateTime.month,
        selectedDateTime.day,
        picked.hour,
        picked.minute,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final valueStyle = SunriseType.rowTitle.copyWith(color: c.ink);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(Symbols.calendar_month_rounded, color: c.accent, size: 24),
          const SizedBox(width: 14),
          Text(L10n.of(context).addDate, style: valueStyle),
          const SizedBox(width: 12),
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Pressable(
                  onTap: () => _pickDate(context),
                  semanticLabel: _dateLabel(selectedDateTime),
                  child: Text(_dateLabel(selectedDateTime), style: valueStyle),
                ),
                Text(', ', style: valueStyle),
                Pressable(
                  onTap: () => _pickTime(context),
                  semanticLabel: AppTimeFormatter.of(context, selectedDateTime),
                  child: Text(
                    AppTimeFormatter.of(context, selectedDateTime),
                    style: valueStyle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Icon(Symbols.chevron_right_rounded, color: c.chevron, size: 20),
        ],
      ),
    );
  }
}

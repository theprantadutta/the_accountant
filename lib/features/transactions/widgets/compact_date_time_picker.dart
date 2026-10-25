import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/core/utils/time_formatter.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// The date row of a form, on one line: `[cal] Yesterday   6 : 02  PM`.
///
/// A calendar button, the day in large type, then the time as separate boxes
/// for the hour, the minutes and AM/PM. The day and the calendar button open
/// the date picker; any part of the time opens the time picker.
///
/// It used to be a "Date" label with the day and the time as two pills that
/// wrapped onto a second line on a phone, so the row read as two rows and the
/// time sat apart from the day it belonged to. Everything here fits one line
/// at 360dp: the day shrinks to fit before anything wraps.
///
/// The pickers use the app theme and honour the user's clock setting.
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

  /// The earliest day offered. Far enough back for anyone entering an old
  /// receipt or a whole year of history by hand.
  static final DateTime firstDate = DateTime(2000);

  /// Today, Yesterday or Tomorrow when it is one of those, otherwise the day
  /// with the month written out ("October 17"), in the order the user's date
  /// format puts them, and the year only when it is not this one.
  String _dateLabel(DateTime date, L10n l10n) {
    final format = dateFormat ?? 'MM/dd/yyyy';
    final now = DateTime.now();
    final days = DateTime(
      date.year,
      date.month,
      date.day,
    ).difference(DateTime(now.year, now.month, now.day)).inDays;
    if (days.abs() <= 1) {
      return AppDateFormatter.formatRelativeDate(date, format, l10n: l10n);
    }
    final dayFirst = format.startsWith('d');
    final pattern = date.year == now.year
        ? (dayFirst ? 'd MMMM' : 'MMMM d')
        : (dayFirst ? 'd MMMM yyyy' : 'MMMM d, yyyy');
    return DateFormat(pattern).format(date);
  }

  /// Closing a picker hands focus back to whatever had it, and on this form
  /// that is usually the title field, so the keyboard sprang back up over the
  /// date that had just been chosen.
  static void _dropFocus() => FocusManager.instance.primaryFocus?.unfocus();

  Future<void> _pickDate(BuildContext context) async {
    _dropFocus();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime.isBefore(firstDate)
          ? firstDate
          : selectedDateTime,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 5, 12, 31),
    );
    _dropFocus();
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
    _dropFocus();
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      builder: (context, child) => AppTimeFormatter.withClock(context, child!),
    );
    _dropFocus();
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
    final l10n = L10n.of(context);
    final day = _dateLabel(selectedDateTime, l10n);
    final time = AppTimeFormatter.of(context, selectedDateTime);
    final use24Hour = AppTimeFormatter.use24Hour(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // The day: the button and the words both open the calendar.
          Expanded(
            child: Semantics(
              button: true,
              label: l10n.addChangeDate(day),
              excludeSemantics: true,
              child: Pressable(
                key: const Key('date_button'),
                onTap: () => _pickDate(context),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: c.tintPeach,
                        borderRadius: BorderRadius.circular(
                          SunriseRadius.input,
                        ),
                      ),
                      child: Icon(
                        Symbols.calendar_month_rounded,
                        color: c.accent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          day,
                          maxLines: 1,
                          style: SunriseType.rowTitle.copyWith(
                            color: c.ink,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // The time, as the parts it is set by.
          Semantics(
            button: true,
            label: l10n.addChangeTime(time),
            excludeSemantics: true,
            child: Pressable(
              key: const Key('time_button'),
              onTap: () => _pickTime(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TimePart(
                    DateFormat(use24Hour ? 'HH' : 'h').format(selectedDateTime),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      ':',
                      style: SunriseType.rowTitle.copyWith(
                        color: c.ink,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _TimePart(DateFormat('mm').format(selectedDateTime)),
                  if (!use24Hour) ...[
                    const SizedBox(width: 6),
                    _TimePart(
                      DateFormat('a').format(selectedDateTime),
                      small: true,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One box of the time: the hour, the minutes, or AM/PM.
class _TimePart extends StatelessWidget {
  const _TimePart(this.text, {this.small = false});

  final String text;

  /// AM/PM, in lighter type than the digits.
  final bool small;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Container(
      constraints: const BoxConstraints(minWidth: 40, minHeight: 44),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: c.tintPeach,
        borderRadius: BorderRadius.circular(SunriseRadius.input),
      ),
      child: Text(
        text,
        style: SunriseType.rowTitle.copyWith(
          color: c.ink,
          fontSize: small ? 15 : 20,
          fontWeight: small ? FontWeight.w600 : FontWeight.w700,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

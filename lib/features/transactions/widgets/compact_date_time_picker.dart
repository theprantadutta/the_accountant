import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/core/utils/time_formatter.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// The Date row of a form: "Date ... [Yesterday] [6:02 PM]".
///
/// The date and the time are two buttons, each opening its own picker. They
/// used to be bare text with no outline, and only the words themselves took a
/// tap: the row looked like a label, the chevron did nothing, and people
/// concluded the date could not be changed. The pickers use the app theme and
/// honour the user's clock setting.
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

  String _dateLabel(DateTime date) =>
      AppDateFormatter.formatRelativeDate(date, dateFormat ?? 'MM/dd/yyyy');

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
    final time = AppTimeFormatter.of(context, selectedDateTime);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(Symbols.calendar_month_rounded, color: c.accent, size: 24),
          const SizedBox(width: 14),
          Text(
            l10n.addDate,
            style: SunriseType.rowTitle.copyWith(color: c.ink),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 8,
              children: [
                _PickerButton(
                  key: const Key('date_button'),
                  icon: Symbols.event_rounded,
                  label: _dateLabel(selectedDateTime),
                  semanticLabel: l10n.addChangeDate(
                    _dateLabel(selectedDateTime),
                  ),
                  onTap: () => _pickDate(context),
                ),
                _PickerButton(
                  key: const Key('time_button'),
                  icon: Symbols.schedule_rounded,
                  label: time,
                  semanticLabel: l10n.addChangeTime(time),
                  onTap: () => _pickTime(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One of the two buttons: a tinted pill with an icon, so it reads as
/// something to press rather than as a value.
class _PickerButton extends StatelessWidget {
  const _PickerButton({
    super.key,
    required this.icon,
    required this.label,
    required this.semanticLabel,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: Pressable(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: c.tintPeach,
            borderRadius: BorderRadius.circular(SunriseRadius.input),
            border: Border.all(color: c.accent.withValues(alpha: .35)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: c.accent),
              const SizedBox(width: 6),
              Text(
                label,
                style: SunriseType.label.copyWith(
                  color: c.ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

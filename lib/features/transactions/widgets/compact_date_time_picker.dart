import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/themes/app_colors.dart';

/// Compact date and time picker displayed in a single row.
/// Shows date as "Today", "Yesterday", "Tomorrow", or formatted date.
/// Shows time as hour:minute AM/PM with separate tappable segments.
class CompactDateTimePicker extends StatelessWidget {
  final DateTime selectedDateTime;
  final ValueChanged<DateTime> onDateTimeChanged;
  final Color accentColor;

  const CompactDateTimePicker({
    super.key,
    required this.selectedDateTime,
    required this.onDateTimeChanged,
    required this.accentColor,
  });

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(date.year, date.month, date.day);

    final difference = selected.difference(today).inDays;

    if (difference == 0) return 'Today';
    if (difference == -1) return 'Yesterday';
    if (difference == 1) return 'Tomorrow';

    // For dates within the same year, show "Jan 12"
    if (date.year == now.year) {
      return DateFormat('MMM d').format(date);
    }
    // For other years, show "Jan 12, 2025"
    return DateFormat('MMM d, y').format(date);
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: accentColor,
              onPrimary: Colors.white,
              surface: AppColors.primarySurface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      HapticFeedback.lightImpact();
      onDateTimeChanged(DateTime(
        picked.year,
        picked.month,
        picked.day,
        selectedDateTime.hour,
        selectedDateTime.minute,
      ));
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: accentColor,
              onPrimary: Colors.white,
              surface: AppColors.primarySurface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      HapticFeedback.lightImpact();
      onDateTimeChanged(DateTime(
        selectedDateTime.year,
        selectedDateTime.month,
        selectedDateTime.day,
        picked.hour,
        picked.minute,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final hour = selectedDateTime.hour;
    final minute = selectedDateTime.minute;
    final isPM = hour >= 12;
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          // Calendar icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.calendar_today_rounded,
              size: 20,
              color: accentColor,
            ),
          ),
          const SizedBox(width: 12),

          // Date chip (tappable)
          GestureDetector(
            onTap: () => _showDatePicker(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryElevated,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getDateLabel(selectedDateTime),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),

          const Spacer(),

          // Time display (tappable)
          GestureDetector(
            onTap: () => _showTimePicker(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Hour
                _TimeSegment(
                  value: displayHour.toString(),
                  color: accentColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    ':',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                // Minute
                _TimeSegment(
                  value: minute.toString().padLeft(2, '0'),
                  color: accentColor,
                ),
                const SizedBox(width: 6),
                // AM/PM
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isPM ? 'PM' : 'AM',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeSegment extends StatelessWidget {
  final String value;
  final Color color;

  const _TimeSegment({
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryElevated,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

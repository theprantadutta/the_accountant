import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_animations.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:intl/intl.dart';

/// Date and time picker widget for transaction creation.
/// Features quick presets (Today, Yesterday) and combined date/time selection.
class DateTimePicker extends StatelessWidget {
  /// Currently selected date and time
  final DateTime selectedDateTime;

  /// Callback when date/time changes
  final ValueChanged<DateTime> onDateTimeChanged;

  /// Accent color for styling
  final Color? accentColor;

  /// Label text
  final String label;

  /// Whether to show time picker
  final bool showTime;

  /// Whether to allow future dates
  final bool allowFutureDates;

  /// Date format setting string from regional settings
  final String? dateFormat;

  const DateTimePicker({
    super.key,
    required this.selectedDateTime,
    required this.onDateTimeChanged,
    this.accentColor,
    this.label = 'Date & Time',
    this.showTime = true,
    this.allowFutureDates = true,
    this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.primaryAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        AppSpacing.gapSm,

        // Quick presets
        _buildQuickPresets(context, color),
        AppSpacing.gapSm,

        // Date/Time selector
        Row(
          children: [
            // Date picker
            Expanded(
              flex: 1,
              child: _DateButton(
                dateTime: selectedDateTime,
                onTap: () => _showDatePicker(context),
                color: color,
                dateFormat: dateFormat,
              ),
            ),
            AppSpacing.gapHSm,

            // Time picker
            if (showTime)
              _TimeButton(
                dateTime: selectedDateTime,
                onTap: () => _showTimePicker(context),
                color: color,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickPresets(BuildContext context, Color color) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));
    final selectedDate = DateTime(
      selectedDateTime.year,
      selectedDateTime.month,
      selectedDateTime.day,
    );

    final presets = [
      (label: 'Yesterday', date: yesterday, enabled: true),
      (label: 'Today', date: today, enabled: true),
      if (allowFutureDates) (label: 'Tomorrow', date: tomorrow, enabled: true),
    ];

    return Row(
      children: presets.map((preset) {
        final isSelected = selectedDate == preset.date;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _PresetChip(
            label: preset.label,
            isSelected: isSelected,
            onTap: () {
              HapticFeedback.lightImpact();
              final newDateTime = DateTime(
                preset.date.year,
                preset.date.month,
                preset.date.day,
                selectedDateTime.hour,
                selectedDateTime.minute,
              );
              onDateTimeChanged(newDateTime);
            },
            color: color,
          ),
        );
      }).toList(),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    HapticFeedback.lightImpact();

    final now = DateTime.now();
    final firstDate = DateTime(2000);
    final lastDate = allowFutureDates
        ? now.add(const Duration(days: 365 * 5))
        : now;

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime.isBefore(lastDate)
          ? selectedDateTime
          : lastDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: accentColor ?? AppColors.primaryAccent,
              surface: AppColors.primarySurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final newDateTime = DateTime(
        picked.year,
        picked.month,
        picked.day,
        selectedDateTime.hour,
        selectedDateTime.minute,
      );
      onDateTimeChanged(newDateTime);
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    HapticFeedback.lightImpact();

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: accentColor ?? AppColors.primaryAccent,
              surface: AppColors.primarySurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final newDateTime = DateTime(
        selectedDateTime.year,
        selectedDateTime.month,
        selectedDateTime.day,
        picked.hour,
        picked.minute,
      );
      onDateTimeChanged(newDateTime);
    }
  }
}

/// Quick preset chip button.
class _PresetChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _PresetChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.2)
              : AppColors.primarySurface,
          borderRadius: AppSpacing.borderRadiusFull,
          border: Border.all(
            color: isSelected ? color : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? color : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// Date selector button.
class _DateButton extends StatelessWidget {
  final DateTime dateTime;
  final VoidCallback onTap;
  final Color color;
  final String? dateFormat;

  const _DateButton({
    required this.dateTime,
    required this.onTap,
    required this.color,
    this.dateFormat,
  });

  String _formatDate() {
    final df = dateFormat ?? 'MM/dd/yyyy';
    return AppDateFormatter.formatRelativeDate(dateTime, df);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.paddingMd,
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 20, color: color),
            AppSpacing.gapHSm,
            Expanded(
              child: Text(
                _formatDate(),
                style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

/// Time selector button.
class _TimeButton extends StatelessWidget {
  final DateTime dateTime;
  final VoidCallback onTap;
  final Color color;

  const _TimeButton({
    required this.dateTime,
    required this.onTap,
    required this.color,
  });

  String _formatTime() {
    return DateFormat('h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.paddingMd,
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.access_time, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              _formatTime(),
              style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact inline date/time selector for use in lists/forms.
class DateTimeSelector extends StatelessWidget {
  final DateTime selectedDateTime;
  final ValueChanged<DateTime> onDateTimeChanged;
  final Color? accentColor;
  final bool showTime;
  final String? dateFormat;

  const DateTimeSelector({
    super.key,
    required this.selectedDateTime,
    required this.onDateTimeChanged,
    this.accentColor,
    this.showTime = true,
    this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.primaryAccent;

    return GestureDetector(
      onTap: () => _showDateTimePicker(context),
      child: Container(
        padding: AppSpacing.paddingMd,
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Icon(Icons.event, size: 20, color: color),
            AppSpacing.gapHSm,
            Expanded(
              child: Text(
                _formatDateTime(),
                style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime() {
    final df = dateFormat ?? 'MM/dd/yyyy';
    final dateStr = AppDateFormatter.formatRelativeDate(selectedDateTime, df);

    if (showTime) {
      final timeStr = DateFormat('h:mm a').format(selectedDateTime);
      return '$dateStr, $timeStr';
    }
    return dateStr;
  }

  Future<void> _showDateTimePicker(BuildContext context) async {
    HapticFeedback.lightImpact();

    // First show date picker
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (date == null) return;

    if (!showTime) {
      onDateTimeChanged(date);
      return;
    }

    // Then show time picker
    if (context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (time != null) {
        onDateTimeChanged(
          DateTime(date.year, date.month, date.day, time.hour, time.minute),
        );
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/shared/widgets/neo_text_field.dart';

/// The horizontal month picker above a transaction list.
///
/// Three states, and only one of them is loud: the month being shown is
/// filled, the current month is outlined so there is always a way back to it,
/// and everything else is quiet. Months that have not happened yet are marked
/// in blue rather than green — everywhere else in this app green means money
/// coming in, and a date is not income.
///
/// Lives here rather than in a screen because two screens show it — the full
/// list and the income/expense views reached from the dashboard — and they had
/// drifted into two near-identical copies with different bugs.
class MonthStrip extends StatelessWidget {
  const MonthStrip({
    super.key,
    required this.months,
    required this.selectedIndex,
    required this.onSelected,
    this.controller,
  });

  final List<DateTime> months;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final ScrollController? controller;

  /// Width of one chip.
  ///
  /// Fixed on purpose: [centeringOffset] has to know how wide the chips are to
  /// centre one, and it cannot measure them. Wide enough for the longest label
  /// the formatter below can produce — the previous value clipped "Sept 2026".
  static const double chipWidth = 104.0;
  static const double chipGap = AppSpacing.xs;
  static const double stripPadding = AppSpacing.md;
  static const double itemExtent = chipWidth + chipGap * 2;
  static const double height = 52.0;

  /// The scroll offset that puts [index] in the middle of the strip.
  ///
  /// Callers clamp it to their controller's scroll extent.
  static double centeringOffset(int index, double viewportWidth) =>
      stripPadding +
      (index * itemExtent) +
      (itemExtent / 2) -
      (viewportWidth / 2);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month);

    return SizedBox(
      height: height,
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: stripPadding,
          vertical: AppSpacing.sm,
        ),
        itemCount: months.length,
        itemBuilder: (context, index) {
          final month = months[index];
          final isSelected = index == selectedIndex;
          final isCurrentMonth = month == thisMonth;
          final isFutureMonth = month.isAfter(thisMonth);

          final Color labelColor;
          if (isSelected) {
            labelColor = AppColors.textPrimary;
          } else if (isCurrentMonth) {
            labelColor = AppColors.primaryAccent;
          } else if (isFutureMonth) {
            labelColor = AppColors.info;
          } else {
            labelColor = AppColors.textSecondary;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: chipGap),
            child: GestureDetector(
              onTap: () => onSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                width: chipWidth,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryAccent
                      : AppColors.glassWhite,
                  borderRadius: AppSpacing.borderRadiusFull,
                  border: Border.all(
                    color: isSelected || isCurrentMonth
                        ? AppColors.primaryAccent
                        : AppColors.glassBorder,
                  ),
                ),
                child: Text(
                  DateFormat('MMM yyyy').format(month),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: labelColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// The divider between one day's transactions and the next.
///
/// A section marker, not a status, so it is a quiet label against a hairline
/// rather than a filled pill. Days still to come keep a clock icon, which says
/// "not yet" without borrowing income's green.
class TransactionDateHeader extends StatelessWidget {
  const TransactionDateHeader({
    super.key,
    required this.date,
    required this.label,
  });

  final DateTime date;

  /// Already formatted by the caller — the two screens word "today" and
  /// "yesterday" their own way.
  final String label;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isFuture = date.isAfter(today);
    final labelColor = isFuture ? AppColors.info : AppColors.textMuted;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        AppSpacing.lg,
        AppSpacing.xxl,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          if (isFuture) ...[
            Icon(Icons.schedule, size: AppSpacing.iconXs, color: labelColor),
            AppSpacing.gapHSm,
          ],
          Text(
            label.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: labelColor,
              letterSpacing: 0.8,
            ),
          ),
          AppSpacing.gapHMd,
          Expanded(child: Container(height: 1, color: AppColors.divider)),
        ],
      ),
    );
  }
}

/// Search, with whatever narrows the list next to it.
///
/// Both list screens pair a search box with a filter control; keeping them in
/// one widget is what stops one of them growing a differently-styled copy.
class TransactionSearchField extends StatelessWidget {
  const TransactionSearchField({
    super.key,
    required this.controller,
    required this.query,
    required this.onCleared,
    this.hint = 'Search transactions',
    this.trailing,
  });

  final TextEditingController controller;
  final String query;
  final VoidCallback onCleared;
  final String hint;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: NeoTextField(
              controller: controller,
              hint: hint,
              prefixIcon: Icons.search,
              textInputAction: TextInputAction.search,
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close, size: AppSpacing.iconXs),
                      color: AppColors.textMuted,
                      onPressed: onCleared,
                    ),
            ),
          ),
          if (trailing != null) ...[AppSpacing.gapHSm, trailing!],
        ],
      ),
    );
  }
}

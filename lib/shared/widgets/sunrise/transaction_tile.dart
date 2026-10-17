import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_colors.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_tokens.dart';
import 'package:the_accountant/shared/widgets/sunrise/cards.dart';
import 'package:the_accountant/shared/widgets/sunrise/pressable.dart';

/// How an amount reads: money in, money out, or neither (transfers).
enum AmountTone { income, expense, neutral }

/// One transaction row: tinted icon tile, title, "Category · time", amount.
///
/// Expense amounts are ink and income amounts positive green, the same as the
/// mock; [AmountTone.neutral] is for transfers.
class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.icon,
    this.emoji,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.tone = AmountTone.expense,
    this.onTap,
    this.onLongPress,
    this.trailingBelow,
    this.leading,
    this.dimmed = false,
  });

  final IconData icon;

  /// Shown instead of [icon] when the category has an emoji.
  final String? emoji;
  final Color iconColor;
  final String title;
  final String subtitle;

  /// Already formatted, sign included.
  final String amount;
  final AmountTone tone;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// A small line under the amount (wallet name, "Pending", ...).
  final Widget? trailingBelow;

  /// Replaces the icon tile (a selection checkbox, say).
  final Widget? leading;

  /// For pending / upcoming items.
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final amountColor = switch (tone) {
      AmountTone.income => c.positive,
      AmountTone.expense => c.ink,
      AmountTone.neutral => c.muted,
    };
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          leading ?? IconTile(icon: icon, emoji: emoji, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // Up to two lines each: beside the amount, one line cut off
              // ordinary titles and the time on a 360dp phone. A row only
              // grows when its text needs it.
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.rowTitle.copyWith(color: c.ink),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.caption.copyWith(color: c.subtle),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * .38,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    amount,
                    maxLines: 1,
                    style: SunriseType.amount.copyWith(color: amountColor),
                  ),
                ),
                if (trailingBelow != null) ...[
                  const SizedBox(height: 2),
                  DefaultTextStyle.merge(
                    style: SunriseType.caption.copyWith(color: c.subtle),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    child: trailingBelow!,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
    final body = Opacity(opacity: dimmed ? .6 : 1, child: row);
    if (onTap == null && onLongPress == null) return body;
    return Pressable(onTap: onTap, onLongPress: onLongPress, child: body);
  }
}

/// A list card: rows separated by hairline dividers, radius 22, padding 4×14.
class ListCard extends StatelessWidget {
  const ListCard({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    this.dividerIndent = 0,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final double dividerIndent;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return SunriseCard(
      padding: padding,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 1,
                indent: dividerIndent,
                color: c.divider,
              ),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// A day's transactions: "Today · Tue 11 ... +৳3,950" above a list card.
class DayGroupCard extends StatelessWidget {
  const DayGroupCard({
    super.key,
    required this.label,
    required this.children,
    this.total,
    this.totalColor,
  });

  final String label;

  /// The day's net, formatted.
  final String? total;
  final Color? totalColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.label.copyWith(
                    color: c.subtle,
                    fontSize: 14,
                  ),
                ),
              ),
              if (total != null)
                Text(
                  total!,
                  style: SunriseType.label.copyWith(
                    color: totalColor ?? c.subtle,
                    fontSize: 14,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
            ],
          ),
        ),
        ListCard(children: children),
      ],
    );
  }
}

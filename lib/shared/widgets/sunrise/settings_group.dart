import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_colors.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_tokens.dart';
import 'package:the_accountant/shared/widgets/sunrise/cards.dart';
import 'package:the_accountant/shared/widgets/sunrise/controls.dart';
import 'package:the_accountant/shared/widgets/sunrise/headers.dart';
import 'package:the_accountant/shared/widgets/sunrise/pressable.dart';

/// A labelled card of [SettingsRow]s ("PREFERENCES", "ACCOUNT", ...).
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({
    super.key,
    this.label,
    required this.children,
    this.danger = false,
    this.footer,
  });

  final String? label;
  final List<Widget> children;

  /// The danger zone: a negative label and a 1px negative inset at 25%.
  final bool danger;

  /// Small print under the card.
  final String? footer;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final visible = children.where((w) => w is! SizedBox).toList();
    if (visible.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null)
          SectionLabel(label!, color: danger ? c.negative : null),
        SunriseCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          border: danger
              ? Border.all(color: c.negative.withValues(alpha: .25))
              : null,
          shadow: !danger,
          child: Column(
            children: [
              for (var i = 0; i < visible.length; i++) ...[
                if (i > 0) Divider(height: 1, thickness: 1, color: c.divider),
                visible[i],
              ],
            ],
          ),
        ),
        if (footer != null)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(4, 8, 4, 0),
            child: Text(
              footer!,
              style: SunriseType.caption.copyWith(color: c.subtle),
            ),
          ),
      ],
    );
  }
}

/// What sits at the end of a [SettingsRow].
enum SettingsTrailing { chevron, external, none }

/// One settings row: tinted 36dp tile, title (and subtitle), trailing.
///
/// Variants: chevron (default), a [value] before the chevron, a [toggle], an
/// external-link glyph, or [destructive] (negative title, no chevron).
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
    this.iconBackground,
    this.value,
    this.onTap,
    this.trailing = SettingsTrailing.chevron,
    this.destructive = false,
    this.trailingWidget,
    this.enabled = true,
    this.badge,
  });

  /// A row with a [SunriseToggle] at the end.
  factory SettingsRow.toggle({
    Key? key,
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    Color? iconBackground,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) => SettingsRow(
    key: key,
    icon: icon,
    title: title,
    subtitle: subtitle,
    iconColor: iconColor,
    iconBackground: iconBackground,
    trailing: SettingsTrailing.none,
    onTap: onChanged == null ? null : () => onChanged(!value),
    trailingWidget: SunriseToggle(
      value: value,
      onChanged: onChanged,
      semanticLabel: title,
    ),
  );

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;
  final Color? iconBackground;
  final String? value;
  final VoidCallback? onTap;
  final SettingsTrailing trailing;
  final bool destructive;
  final Widget? trailingWidget;
  final bool enabled;

  /// A small marker after the title ("PRO").
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final tint = destructive ? c.negative : (iconColor ?? c.accent);
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: SunriseSpace.rowYSettings),
      child: Row(
        children: [
          IconTile(
            icon: icon,
            color: tint,
            background: destructive ? c.tintRose : iconBackground,
            size: 36,
            radius: SunriseRadius.iconTileSm,
            iconSize: 20,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: SunriseType.rowTitle.copyWith(
                          color: destructive ? c.negative : c.ink,
                        ),
                      ),
                    ),
                    if (badge != null) ...[const SizedBox(width: 8), badge!],
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 1),
                  Text(
                    subtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: SunriseType.caption.copyWith(color: c.subtle),
                  ),
                ],
              ],
            ),
          ),
          if (value != null) ...[
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 140),
              child: Text(
                value!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: SunriseType.label.copyWith(color: c.subtle),
              ),
            ),
          ],
          if (trailingWidget != null) ...[
            const SizedBox(width: 8),
            trailingWidget!,
          ] else if (!destructive) ...switch (trailing) {
            SettingsTrailing.chevron => [
              const SizedBox(width: 4),
              Icon(
                Symbols.chevron_right_rounded,
                size: 20,
                color: c.chevron,
                textDirection: Directionality.of(context),
              ),
            ],
            SettingsTrailing.external => [
              const SizedBox(width: 4),
              Icon(Symbols.open_in_new_rounded, size: 20, color: c.chevron),
            ],
            SettingsTrailing.none => const <Widget>[],
          },
        ],
      ),
    );
    return Opacity(
      opacity: enabled ? 1 : .45,
      child: Pressable(
        onTap: enabled ? onTap : null,
        scale: .985,
        child: row,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_colors.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_tokens.dart';
import 'package:the_accountant/shared/widgets/sunrise/pressable.dart';

/// A 40dp circular button on the surface colour (back, close, bell, filter).
class SunriseIconButton extends StatelessWidget {
  const SunriseIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 40,
    this.iconSize = 22,
    this.tooltip,
    this.background,
    this.foreground,
    this.badge,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final String? tooltip;
  final Color? background;
  final Color? foreground;

  /// Optional overlay in the top-right corner (an unread dot or count).
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    Widget button = Pressable(
      onTap: onTap,
      haptic: true,
      semanticLabel: tooltip,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: background ?? c.surface,
          shape: BoxShape.circle,
          boxShadow: background == null ? c.cardShadow : null,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: iconSize, color: foreground ?? c.ink),
      ),
    );
    if (badge != null) {
      button = Stack(
        clipBehavior: Clip.none,
        children: [
          button,
          PositionedDirectional(top: -2, end: -2, child: badge!),
        ],
      );
    }
    if (tooltip != null) button = Tooltip(message: tooltip, child: button);
    return button;
  }
}

/// The iOS-style large title on tab roots, with optional trailing actions.
class LargeTitleHeader extends StatelessWidget {
  const LargeTitleHeader({
    super.key,
    required this.title,
    this.trailing,
    this.padding = const EdgeInsetsDirectional.fromSTEB(
      SunriseSpace.screenX,
      SunriseSpace.screenTop,
      SunriseSpace.screenX,
      SunriseSpace.sectionTight,
    ),
  });

  final String title;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: SunriseType.largeTitle.copyWith(color: c.ink),
              ),
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
        ],
      ),
    );
  }
}

/// The header of a pushed screen: circular back (or close) button and a title.
class PushHeader extends StatelessWidget {
  const PushHeader({
    super.key,
    required this.title,
    this.onBack,
    this.close = false,
    this.actions = const [],
    this.centerTitle = false,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  /// Defaults to popping the route.
  final VoidCallback? onBack;

  /// Show an × instead of a back arrow (modal screens).
  final bool close;
  final List<Widget> actions;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final canPop = onBack != null || Navigator.of(context).canPop();
    final titleText = Column(
      crossAxisAlignment: centerTitle
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: centerTitle ? TextAlign.center : TextAlign.start,
            style: SunriseType.pushTitle.copyWith(color: c.ink),
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: SunriseType.caption.copyWith(color: c.subtle),
          ),
      ],
    );
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        SunriseSpace.screenX,
        SunriseSpace.screenTop,
        SunriseSpace.screenX,
        SunriseSpace.sectionTight,
      ),
      child: SizedBox(
        height: 44,
        child: Row(
          children: [
            if (canPop) ...[
              SunriseIconButton(
                icon: close
                    ? Symbols.close_rounded
                    : Symbols.arrow_back_rounded,
                tooltip: close
                    ? MaterialLocalizations.of(context).closeButtonTooltip
                    : MaterialLocalizations.of(context).backButtonTooltip,
                onTap: onBack ?? () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(width: 14),
            ],
            Expanded(child: titleText),
            for (final a in actions) ...[const SizedBox(width: 8), a],
            // Balance the back button so a centred title is truly centred.
            if (centerTitle && canPop && actions.isEmpty)
              const SizedBox(width: 54),
          ],
        ),
      ),
    );
  }
}

/// An uppercase section label above a group ("PREFERENCES", "PLANNING").
class SectionLabel extends StatelessWidget {
  const SectionLabel(
    this.text, {
    super.key,
    this.color,
    this.trailing,
    this.padding = const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 10),
  });

  final String text;
  final Color? color;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                text.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: SunriseType.overline.copyWith(color: color ?? c.subtle),
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// A sentence-case section title with an optional link ("Today · All activity").
class SectionTitle extends StatelessWidget {
  const SectionTitle(
    this.text, {
    super.key,
    this.actionLabel,
    this.onAction,
    this.trailing,
  });

  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: SunriseType.section.copyWith(color: c.ink),
              ),
            ),
          ),
          // Capped, so a long translation or a large figure gives way before
          // it pushes the row off a narrow phone.
          if (actionLabel != null || trailing != null)
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * .5,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (actionLabel != null)
                    Flexible(
                      child: Pressable(
                        onTap: onAction,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            actionLabel!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: SunriseType.label.copyWith(
                              color: c.accentText,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (trailing != null)
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerEnd,
                        child: trailing,
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

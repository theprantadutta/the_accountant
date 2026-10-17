import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_colors.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_tokens.dart';
import 'package:the_accountant/shared/widgets/sunrise/cards.dart';
import 'package:the_accountant/shared/widgets/sunrise/controls.dart';

/// The body of a Sunrise bottom sheet: grab handle, optional title, content.
///
/// Use with [showSunriseSheet], or inside any `showModalBottomSheet` builder
/// to restyle an existing sheet without touching how it is opened.
class SunriseBottomSheet extends StatelessWidget {
  const SunriseBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.padding = const EdgeInsets.fromLTRB(16, 0, 16, 20),
    this.scrollable = true,
    this.actions,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final EdgeInsetsGeometry padding;

  /// Wrap the content in a scroll view (turn off for sheets that scroll
  /// themselves, such as long lists).
  final bool scrollable;

  /// Sticky buttons under the content.
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final media = MediaQuery.of(context);
    Widget content = Padding(padding: padding, child: child);
    content = Flexible(
      child: scrollable ? SingleChildScrollView(child: content) : content,
    );

    return Container(
      constraints: BoxConstraints(maxHeight: media.size.height * .92),
      decoration: BoxDecoration(
        color: c.base,
        borderRadius: SunriseRadius.sheetTop,
      ),
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: c.chevron.withValues(alpha: .6),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            if (title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      style: SunriseType.section.copyWith(
                        color: c.ink,
                        fontSize: 20,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: SunriseType.body.copyWith(
                          color: c.muted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              )
            else
              const SizedBox(height: 14),
            content,
            if (actions != null && actions!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < actions!.length; i++) ...[
                      if (i > 0) const SizedBox(height: 10),
                      actions![i],
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Open a Sunrise sheet. Returns what the sheet pops with.
Future<T?> showSunriseSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = true,
  bool useRootNavigator = true,
  bool enableDrag = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: useRootNavigator,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: Colors.transparent,
    elevation: 0,
    barrierColor: const Color(0x8C140D0A),
    builder: builder,
  );
}

/// A row inside a sheet's option list (Edit, Delete, ...).
class SheetAction extends StatelessWidget {
  const SheetAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
    this.subtitle,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final bool destructive;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final color = destructive ? c.negative : c.accent;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            IconTile(
              icon: icon,
              color: color,
              background: destructive ? c.tintRose : c.tintOrange,
              size: 40,
              iconSize: 21,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: SunriseType.rowTitle.copyWith(
                      color: destructive ? c.negative : c.ink,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: SunriseType.caption.copyWith(color: c.subtle),
                    ),
                ],
              ),
            ),
            if (selected)
              Icon(Symbols.check_circle_rounded, color: c.accent, fill: 1),
          ],
        ),
      ),
    );
  }
}

/// The content of a Sunrise dialog: optional icon, title, message, actions.
class SunriseDialog extends StatelessWidget {
  const SunriseDialog({
    super.key,
    required this.title,
    this.message,
    this.content,
    this.icon,
    this.iconColor,
    this.actions = const [],
  });

  final String title;
  final String? message;
  final Widget? content;
  final IconData? icon;
  final Color? iconColor;

  /// Usually [SunriseButton]s, stacked full width.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Dialog(
      backgroundColor: c.base,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(SunriseRadius.hero)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (icon != null) ...[
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: IconTile(
                    icon: icon!,
                    color: iconColor ?? c.accent,
                    size: 48,
                    radius: 14,
                    iconSize: 24,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                title,
                style: SunriseType.section.copyWith(color: c.ink, fontSize: 20),
              ),
              if (message != null) ...[
                const SizedBox(height: 8),
                Text(
                  message!,
                  style: SunriseType.body.copyWith(
                    color: c.muted,
                    fontSize: 14,
                  ),
                ),
              ],
              if (content != null) ...[const SizedBox(height: 16), content!],
              if (actions.isNotEmpty) ...[
                const SizedBox(height: 22),
                for (var i = 0; i < actions.length; i++) ...[
                  if (i > 0) const SizedBox(height: 10),
                  actions[i],
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Open a Sunrise dialog.
Future<T?> showSunriseDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: const Color(0x8C140D0A),
    builder: builder,
  );
}

/// A yes/no confirmation as a bottom sheet. Resolves to true on confirm.
Future<bool> showSunriseConfirm({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  String? cancelLabel,
  bool destructive = false,
  IconData? icon,
}) async {
  final result = await showSunriseSheet<bool>(
    context: context,
    builder: (ctx) {
      final c = ctx.sunrise;
      return SunriseBottomSheet(
        actions: [
          if (destructive)
            SunriseButton.destructive(
              label: confirmLabel,
              onPressed: () => Navigator.of(ctx).pop(true),
            )
          else
            SunriseButton(
              label: confirmLabel,
              height: 54,
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
          SunriseButton.secondary(
            label:
                cancelLabel ?? MaterialLocalizations.of(ctx).cancelButtonLabel,
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              IconTile(
                icon: icon,
                color: destructive ? c.negative : c.accent,
                background: destructive ? c.tintRose : c.tintOrange,
                size: 52,
                radius: 16,
                iconSize: 26,
              ),
              const SizedBox(height: 16),
            ],
            Text(
              title,
              style: SunriseType.section.copyWith(color: c.ink, fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: SunriseType.body.copyWith(color: c.muted, fontSize: 14),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
  return result ?? false;
}

enum SnackTone { success, error, info }

/// A Sunrise snackbar: ink pill with a toned leading icon.
void showSunriseSnack(
  BuildContext context,
  String message, {
  SnackTone tone = SnackTone.info,
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 3),
}) {
  final c = context.sunrise;
  final (IconData icon, Color color) = switch (tone) {
    SnackTone.success => (
      Symbols.check_circle_rounded,
      c.isDark ? const Color(0xFF16A34A) : const Color(0xFF4ADE80),
    ),
    SnackTone.error => (
      Symbols.error_rounded,
      c.isDark ? const Color(0xFFE11D48) : const Color(0xFFFB7185),
    ),
    SnackTone.info => (
      Symbols.info_rounded,
      c.isDark ? c.gradientMid : c.gradientStart,
    ),
  };
  if (tone == SnackTone.error) HapticFeedback.mediumImpact();
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: duration,
        content: Row(
          children: [
            Icon(icon, color: color, fill: 1, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        action: actionLabel == null
            ? null
            : SnackBarAction(label: actionLabel, onPressed: onAction ?? () {}),
      ),
    );
}

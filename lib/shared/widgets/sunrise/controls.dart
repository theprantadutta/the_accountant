import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_colors.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_tokens.dart';
import 'package:the_accountant/shared/widgets/sunrise/pressable.dart';

/// A filter chip: ink when active, surface with muted text when idle.
class SunriseChip extends StatelessWidget {
  const SunriseChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.outlined = false,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  /// A transparent chip with a border (secondary suggestion chips).
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final fg = selected ? c.chipActiveFg : c.muted;
    return Pressable(
      onTap: onTap == null
          ? null
          : () {
              HapticFeedback.selectionClick();
              onTap!();
            },
      child: AnimatedContainer(
        duration: SunriseMotion.press,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? c.chipActiveBg
              : outlined
              ? Colors.transparent
              : c.surface,
          borderRadius: BorderRadius.circular(SunriseRadius.chip),
          border: outlined && !selected
              ? Border.all(color: c.tabBarBorder, width: 1.2)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: fg, fill: selected ? 1 : 0),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              maxLines: 1,
              style: SunriseType.label.copyWith(color: fg, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

/// One option of a [SunriseSegmented].
class SegmentOption<T> {
  const SegmentOption(this.value, this.label, {this.locked = false});

  final T value;
  final String label;

  /// Shows a lock after the label (premium-only periods).
  final bool locked;
}

/// The segmented control: a surface track with a sliding ink thumb.
///
/// [onGradient] is the variant on the Add header: a translucent white track,
/// a white thumb and accent text.
class SunriseSegmented<T> extends StatelessWidget {
  const SunriseSegmented({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.onGradient = false,
    this.height = 44,
  });

  final List<SegmentOption<T>> options;
  final T value;
  final ValueChanged<T> onChanged;
  final bool onGradient;
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final index = options.indexWhere((o) => o.value == value).clamp(0, 99);
    final track = onGradient ? Colors.white.withValues(alpha: .22) : c.surface;
    final thumb = onGradient ? Colors.white : c.chipActiveBg;
    final activeFg = onGradient ? c.accent : c.chipActiveFg;
    final idleFg = onGradient ? Colors.white : c.muted;

    return Container(
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: track,
        borderRadius: BorderRadius.circular(SunriseRadius.segmented),
        boxShadow: onGradient ? null : c.cardShadow,
      ),
      child: LayoutBuilder(
        builder: (context, box) {
          final w = box.maxWidth / options.length;
          final rtl = Directionality.of(context) == TextDirection.rtl;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: SunriseMotion.tab,
                curve: SunriseMotion.emphasized,
                left: rtl ? null : w * index,
                right: rtl ? w * index : null,
                top: 0,
                bottom: 0,
                width: w,
                child: Container(
                  decoration: BoxDecoration(
                    color: thumb,
                    borderRadius: BorderRadius.circular(
                      SunriseRadius.segmentedItem,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < options.length; i++)
                    Expanded(
                      child: Semantics(
                        selected: i == index,
                        button: true,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (options[i].value == value) return;
                            HapticFeedback.selectionClick();
                            onChanged(options[i].value);
                          },
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: SunriseMotion.tab,
                              style: SunriseType.label.copyWith(
                                fontSize: 15,
                                fontWeight: i == index
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: i == index ? activeFg : idleFg,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      options[i].label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (options[i].locked) ...[
                                    const SizedBox(width: 4),
                                    Icon(
                                      Symbols.lock_rounded,
                                      size: 15,
                                      color: i == index ? activeFg : idleFg,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

/// The Sunrise switch: 46×28, gradient track when on.
class SunriseToggle extends StatelessWidget {
  const SunriseToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final enabled = onChanged != null;
    return Semantics(
      toggled: value,
      enabled: enabled,
      label: semanticLabel,
      child: GestureDetector(
        onTap: enabled
            ? () {
                HapticFeedback.selectionClick();
                onChanged!(!value);
              }
            : null,
        child: Opacity(
          opacity: enabled ? 1 : .5,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            width: 46,
            height: 28,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: value ? null : c.toggleOff,
              gradient: value ? c.gradientShort : null,
              borderRadius: BorderRadius.circular(14),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              alignment: value
                  ? AlignmentDirectional.centerEnd
                  : AlignmentDirectional.centerStart,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x332B1B12),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Search box: height 46, radius 14, surface fill.
class SunriseSearchField extends StatelessWidget {
  const SunriseSearchField({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.onClear,
  });

  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;

  /// Shown as an × when the field has text.
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final field = TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      style: SunriseType.body.copyWith(color: c.ink),
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        prefixIcon: Icon(Symbols.search_rounded, color: c.subtle, size: 22),
        prefixIconConstraints: const BoxConstraints(minWidth: 48),
        suffixIcon: controller == null || onClear == null
            ? null
            : ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller!,
                builder: (_, v, _) => v.text.isEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                        icon: Icon(
                          Symbols.close_rounded,
                          color: c.subtle,
                          size: 20,
                        ),
                        onPressed: onClear,
                      ),
              ),
        contentPadding: const EdgeInsets.symmetric(vertical: 13),
        border: OutlineInputBorder(
          borderRadius: SunriseRadius.inputAll,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: SunriseRadius.inputAll,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: SunriseRadius.inputAll,
          borderSide: BorderSide(color: c.accent, width: 1.5),
        ),
      ),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: SunriseRadius.inputAll,
        boxShadow: c.cardShadow,
      ),
      child: SizedBox(height: 46, child: field),
    );
  }
}

/// A labelled text input (height 52, radius 14, accent border when focused).
class SunriseTextField extends StatelessWidget {
  const SunriseTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.icon,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.autofocus = false,
    this.suffix,
    this.focusNode,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.readOnly = false,
    this.onTap,
    this.initialValue,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final IconData? icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool enabled;
  final bool autofocus;
  final Widget? suffix;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4, bottom: 8),
            child: Text(
              label!,
              style: SunriseType.label.copyWith(color: c.muted),
            ),
          ),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          focusNode: focusNode,
          enabled: enabled,
          autofocus: autofocus,
          readOnly: readOnly,
          onTap: onTap,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          autofillHints: autofillHints,
          inputFormatters: inputFormatters,
          maxLines: obscureText ? 1 : maxLines,
          minLines: minLines,
          maxLength: maxLength,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          validator: validator,
          style: SunriseType.body.copyWith(color: c.ink),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon == null
                ? null
                : Icon(icon, size: 22, color: c.subtle),
            suffixIcon: suffix,
            counterText: '',
          ),
        ),
      ],
    );
  }
}

/// Primary (gradient), secondary (surface) or destructive (negative) button.
enum SunriseButtonStyle { primary, secondary, destructive, ghost }

class SunriseButton extends StatelessWidget {
  const SunriseButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = SunriseButtonStyle.primary,
    this.icon,
    this.loading = false,
    this.expand = true,
    this.height = 58,
  });

  const SunriseButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expand = true,
    this.height = 52,
  }) : style = SunriseButtonStyle.secondary;

  const SunriseButton.destructive({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expand = true,
    this.height = 52,
  }) : style = SunriseButtonStyle.destructive;

  final String label;
  final VoidCallback? onPressed;
  final SunriseButtonStyle style;
  final IconData? icon;
  final bool loading;
  final bool expand;
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final enabled = onPressed != null && !loading;
    final (
      Color? bg,
      Gradient? grad,
      Color fg,
      List<BoxShadow>? shadow,
    ) = switch (style) {
      SunriseButtonStyle.primary when onPressed == null => (
        c.isDark ? const Color(0xFF2B1F19) : c.toggleOff,
        null,
        c.faint,
        null,
      ),
      SunriseButtonStyle.primary => (
        null,
        c.gradient,
        Colors.white,
        enabled ? c.buttonShadow : null,
      ),
      SunriseButtonStyle.secondary => (c.surface, null, c.ink, c.cardShadow),
      SunriseButtonStyle.destructive => (c.negative, null, Colors.white, null),
      SunriseButtonStyle.ghost => (
        Colors.transparent,
        null,
        c.accentText,
        null,
      ),
    };

    final content = loading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: fg),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: fg, fill: 1),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.button.copyWith(color: fg),
                ),
              ),
            ],
          );

    final button = AnimatedOpacity(
      duration: SunriseMotion.press,
      opacity: onPressed == null && style != SunriseButtonStyle.primary
          ? .5
          : 1,
      child: Container(
        height: height,
        width: expand ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: bg,
          gradient: grad,
          borderRadius: SunriseRadius.buttonAll,
          boxShadow: shadow,
        ),
        alignment: Alignment.center,
        child: content,
      ),
    );

    return Pressable(
      onTap: enabled ? onPressed : null,
      haptic: true,
      semanticLabel: label,
      child: button,
    );
  }
}

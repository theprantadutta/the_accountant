import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/themes/app_animations.dart';

/// A modern glass-styled text field with animations.
///
/// Features:
/// - Glass container style
/// - Animated label (Material 3 style)
/// - Focus glow animation
/// - Error shake animation
/// - Password visibility toggle
/// - Prefix and suffix icon support
class NeoTextField extends StatefulWidget {
  const NeoTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.autofocus = false,
    this.readOnly = false,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.enableSuggestions = true,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final bool enabled;
  final bool autofocus;
  final bool readOnly;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final bool enableSuggestions;

  @override
  State<NeoTextField> createState() => _NeoTextFieldState();
}

class _NeoTextFieldState extends State<NeoTextField>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  bool _isFocused = false;
  bool _obscureText = false;
  String? _errorText;

  /// What the form validator last reported, drawn under the box.
  String? _validatorError;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _obscureText = widget.obscureText;
    _errorText = widget.errorText;

    _shakeController = AnimationController(
      vsync: this,
      duration: AppAnimations.normal,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void didUpdateWidget(NeoTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorText != oldWidget.errorText) {
      _errorText = widget.errorText;
      if (_errorText != null) {
        _triggerShake();
      }
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _shakeController.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _triggerShake() {
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
    HapticFeedback.mediumImpact();
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final hasError = _errorText != null && _errorText!.isNotEmpty;

    // A field one step off whatever it sits on: white on the warm page in
    // light, a lifted brown in dark, so it reads on cards as well as on the
    // wash. Focus changes the outline's colour only, never its weight, so
    // the field does not jump.
    final fill = c.isDark ? const Color(0xFF2B1F19) : c.surface;
    final Color borderColor;
    if (hasError) {
      borderColor = c.negative;
    } else if (_isFocused) {
      borderColor = c.accent;
    } else {
      borderColor = c.isDark ? const Color(0x14FFFFFF) : c.tabBarBorder;
    }
    final iconColor = hasError
        ? c.negative
        : _isFocused
        ? c.accent
        : c.subtle;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        final shake = _shakeAnimation.value * 10;
        return Transform.translate(
          offset: Offset(
            shake * ((_shakeAnimation.value * 10).toInt() % 2 == 0 ? 1 : -1),
            0,
          ),
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 4, bottom: 8),
              child: Text(
                widget.label!,
                style: SunriseType.label.copyWith(
                  color: hasError ? c.negative : c.muted,
                ),
              ),
            ),
          AnimatedContainer(
            duration: SunriseMotion.press,
            constraints: const BoxConstraints(minHeight: 54),
            decoration: BoxDecoration(
              color: fill,
              borderRadius: SunriseRadius.inputAll,
              border: Border.all(color: borderColor, width: 1.5),
              boxShadow: _isFocused && !hasError
                  ? [
                      BoxShadow(
                        color: c.accent.withValues(alpha: .14),
                        blurRadius: 0,
                        spreadRadius: 4,
                      ),
                    ]
                  : (c.isDark ? null : c.cardShadow),
            ),
            alignment: Alignment.center,
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: _obscureText,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onSubmitted,
              onTap: widget.onTap,
              validator: (value) {
                final error = widget.validator?.call(value);
                // Shown under the box rather than inside it, so the field
                // keeps its height when a message appears.
                if (error != _validatorError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => _validatorError = error);
                  });
                }
                return error == null ? null : '';
              },
              inputFormatters: widget.inputFormatters,
              maxLines: widget.obscureText ? 1 : widget.maxLines,
              minLines: widget.minLines,
              maxLength: widget.maxLength,
              enabled: widget.enabled,
              autofocus: widget.autofocus,
              readOnly: widget.readOnly,
              textCapitalization: widget.textCapitalization,
              autocorrect: widget.autocorrect,
              enableSuggestions: widget.enableSuggestions,
              style: SunriseType.body.copyWith(
                color: widget.enabled ? c.ink : c.subtle,
                fontSize: 16,
              ),
              cursorColor: c.accent,
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: SunriseType.body.copyWith(
                  color: c.faint,
                  fontSize: 16,
                ),
                filled: false,
                isDense: true,
                prefixIcon: widget.prefixIcon != null
                    ? Icon(widget.prefixIcon, color: iconColor, size: 22)
                    : null,
                prefixIconConstraints: const BoxConstraints(minWidth: 50),
                suffixIcon: widget.obscureText
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Symbols.visibility_rounded
                              : Symbols.visibility_off_rounded,
                          color: c.subtle,
                          size: 22,
                        ),
                        onPressed: _toggleObscureText,
                      )
                    : widget.suffixIcon,
                contentPadding: EdgeInsetsDirectional.fromSTEB(
                  widget.prefixIcon == null ? 16 : 0,
                  16,
                  16,
                  16,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorStyle: const TextStyle(height: 0, fontSize: 0),
                counterText: '',
              ),
            ),
          ),
          if (_shownError != null || widget.helperText != null) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_shownError != null) ...[
                    Icon(Symbols.error_rounded, size: 15, color: c.negative),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      _shownError ?? widget.helperText ?? '',
                      style: SunriseType.caption.copyWith(
                        color: _shownError != null ? c.negative : c.subtle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// The message under the box: an explicit [NeoTextField.errorText] first,
  /// then whatever the validator said last.
  String? get _shownError => (_errorText != null && _errorText!.isNotEmpty)
      ? _errorText
      : _validatorError;
}

/// A search text field with glass styling
class NeoSearchField extends StatefulWidget {
  const NeoSearchField({
    super.key,
    this.controller,
    this.hint = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;

  @override
  State<NeoSearchField> createState() => _NeoSearchFieldState();
}

class _NeoSearchFieldState extends State<NeoSearchField> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_handleTextChange);
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _handleClear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.inputHeight,
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
        cursorColor: AppColors.primaryAccent,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textMuted,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textMuted,
            size: AppSpacing.iconSm,
          ),
          suffixIcon: _hasText
              ? IconButton(
                  icon: Icon(
                    Icons.close,
                    color: AppColors.textMuted,
                    size: AppSpacing.iconXs,
                  ),
                  onPressed: _handleClear,
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}

/// A currency/amount input field with monospace styling
class NeoCurrencyField extends StatelessWidget {
  const NeoCurrencyField({
    super.key,
    this.controller,
    this.label = 'Amount',
    this.currencySymbol = '\$',
    this.onChanged,
    this.errorText,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String label;
  final String currencySymbol;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return NeoTextField(
      controller: controller,
      label: label,
      hint: '0.00',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
      errorText: errorText,
      autofocus: autofocus,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      prefixIcon: Icons.attach_money,
    );
  }
}

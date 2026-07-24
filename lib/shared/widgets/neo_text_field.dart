import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final hasError = _errorText != null && _errorText!.isNotEmpty;
    final borderColor = hasError
        ? AppColors.error
        : _isFocused
        ? AppColors.primaryAccent
        : AppColors.glassBorder;

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
          AnimatedContainer(
            duration: AppAnimations.fast,
            decoration: BoxDecoration(
              color: AppColors.glassWhite,
              borderRadius: AppSpacing.borderRadiusMd,
              border: Border.all(
                color: borderColor,
                width: _isFocused || hasError ? 2 : 1,
              ),
              boxShadow: _isFocused && !hasError
                  ? [
                      BoxShadow(
                        color: AppColors.primaryAccent.withValues(alpha: 0.2),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ]
                  : null,
            ),
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: _obscureText,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onSubmitted,
              onTap: widget.onTap,
              validator: widget.validator,
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
              style: AppTypography.bodyLarge.copyWith(
                color: widget.enabled
                    ? AppColors.textPrimary
                    : AppColors.textMuted,
              ),
              cursorColor: AppColors.primaryAccent,
              decoration: InputDecoration(
                labelText: widget.label,
                hintText: widget.hint,
                labelStyle: AppTypography.bodyMedium.copyWith(
                  color: _isFocused
                      ? AppColors.primaryAccent
                      : AppColors.textSecondary,
                ),
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                ),
                floatingLabelStyle: AppTypography.labelMedium.copyWith(
                  color: hasError
                      ? AppColors.error
                      : _isFocused
                      ? AppColors.primaryAccent
                      : AppColors.textSecondary,
                ),
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        color: _isFocused
                            ? AppColors.primaryAccent
                            : AppColors.textMuted,
                        size: AppSpacing.iconSm,
                      )
                    : null,
                suffixIcon: widget.obscureText
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textMuted,
                          size: AppSpacing.iconSm,
                        ),
                        onPressed: _toggleObscureText,
                      )
                    : widget.suffixIcon,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
          if (_errorText != null || widget.helperText != null) ...[
            AppSpacing.gapXs,
            Padding(
              padding: EdgeInsets.only(left: AppSpacing.md),
              child: Text(
                _errorText ?? widget.helperText ?? '',
                style: AppTypography.bodySmall.copyWith(
                  color: _errorText != null
                      ? AppColors.error
                      : AppColors.textMuted,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
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
        color: AppColors.glassWhite,
        borderRadius: AppSpacing.borderRadiusFull,
        border: Border.all(color: AppColors.glassBorder, width: 1),
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

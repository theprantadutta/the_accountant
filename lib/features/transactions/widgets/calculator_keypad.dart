import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_animations.dart';

/// Calculator-style keypad for entering transaction amounts.
/// Supports basic arithmetic operations (+, -, ×, ÷).
class CalculatorKeypad extends StatefulWidget {
  /// Initial amount to display
  final double initialAmount;

  /// Callback when amount changes
  final ValueChanged<double> onAmountChanged;

  /// Whether this is an income (green) or expense (red)
  final bool isIncome;

  /// Currency symbol to display
  final String currencySymbol;

  /// Number of decimal places to show
  final int decimalPlaces;

  const CalculatorKeypad({
    super.key,
    this.initialAmount = 0.0,
    required this.onAmountChanged,
    this.isIncome = false,
    this.currencySymbol = '\$',
    this.decimalPlaces = 2,
  });

  @override
  State<CalculatorKeypad> createState() => _CalculatorKeypadState();
}

class _CalculatorKeypadState extends State<CalculatorKeypad> {
  // Calculator state
  String _display = '0';
  double _firstOperand = 0;
  String? _operator;
  bool _waitingForOperand = false;
  bool _hasDecimal = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialAmount > 0) {
      _display = _formatDisplayValue(widget.initialAmount);
      _hasDecimal = _display.contains('.');
    }
  }

  String _formatDisplayValue(double value) {
    if (value == value.truncate()) {
      return value.truncate().toString();
    }
    return value.toStringAsFixed(widget.decimalPlaces);
  }

  double get _currentValue {
    try {
      return double.parse(_display.replaceAll(',', ''));
    } catch (e) {
      return 0;
    }
  }

  void _handleDigit(String digit) {
    HapticFeedback.lightImpact();

    setState(() {
      if (_waitingForOperand) {
        _display = digit;
        _waitingForOperand = false;
        _hasDecimal = false;
      } else {
        // Limit display length
        if (_display.replaceAll('.', '').length >= 12) return;

        if (_display == '0') {
          _display = digit;
        } else {
          _display += digit;
        }
      }
    });

    widget.onAmountChanged(_currentValue);
  }

  void _handleDecimal() {
    HapticFeedback.lightImpact();

    if (_hasDecimal && !_waitingForOperand) return;

    setState(() {
      if (_waitingForOperand) {
        _display = '0.';
        _waitingForOperand = false;
      } else {
        _display += '.';
      }
      _hasDecimal = true;
    });

    widget.onAmountChanged(_currentValue);
  }

  void _handleOperator(String operator) {
    HapticFeedback.mediumImpact();

    setState(() {
      if (_operator != null && !_waitingForOperand) {
        _calculate();
      }
      _firstOperand = _currentValue;
      _operator = operator;
      _waitingForOperand = true;
    });
  }

  void _calculate() {
    if (_operator == null) return;

    double result = _firstOperand;
    final secondOperand = _currentValue;

    switch (_operator) {
      case '+':
        result = _firstOperand + secondOperand;
        break;
      case '-':
        result = _firstOperand - secondOperand;
        break;
      case '×':
        result = _firstOperand * secondOperand;
        break;
      case '÷':
        if (secondOperand != 0) {
          result = _firstOperand / secondOperand;
        }
        break;
    }

    setState(() {
      _display = _formatDisplayValue(result);
      _hasDecimal = _display.contains('.');
      _operator = null;
      _waitingForOperand = true;
    });

    widget.onAmountChanged(result);
  }

  void _handleEquals() {
    HapticFeedback.mediumImpact();
    _calculate();
  }

  void _handleBackspace() {
    HapticFeedback.lightImpact();

    setState(() {
      if (_display.length > 1) {
        final char = _display[_display.length - 1];
        if (char == '.') _hasDecimal = false;
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });

    widget.onAmountChanged(_currentValue);
  }

  void _handleClear() {
    HapticFeedback.mediumImpact();

    setState(() {
      _display = '0';
      _firstOperand = 0;
      _operator = null;
      _waitingForOperand = false;
      _hasDecimal = false;
    });

    widget.onAmountChanged(0);
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.isIncome ? AppColors.success : AppColors.error;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Amount Display
        _buildAmountDisplay(accentColor),
        AppSpacing.gapMd,

        // Calculator Keypad
        _buildKeypad(accentColor),
      ],
    );
  }

  Widget _buildAmountDisplay(Color accentColor) {
    // Format display with thousand separators
    String formattedDisplay = _display;
    if (!formattedDisplay.contains('.')) {
      // Add thousand separators
      final number = int.tryParse(formattedDisplay) ?? 0;
      formattedDisplay = number.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    }

    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Operator indicator
          if (_operator != null)
            Text(
              '$_firstOperand $_operator',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),

          // Main amount display
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.currencySymbol,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: accentColor.withValues(alpha: 0.7),
                ),
              ),
              AppSpacing.gapHSm,
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    formattedDisplay,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeypad(Color accentColor) {
    return Column(
      children: [
        // Row 1: 7, 8, 9, ÷
        _buildKeyRow([
          _buildDigitKey('7'),
          _buildDigitKey('8'),
          _buildDigitKey('9'),
          _buildOperatorKey('÷', accentColor),
        ]),
        AppSpacing.gapSm,

        // Row 2: 4, 5, 6, ×
        _buildKeyRow([
          _buildDigitKey('4'),
          _buildDigitKey('5'),
          _buildDigitKey('6'),
          _buildOperatorKey('×', accentColor),
        ]),
        AppSpacing.gapSm,

        // Row 3: 1, 2, 3, -
        _buildKeyRow([
          _buildDigitKey('1'),
          _buildDigitKey('2'),
          _buildDigitKey('3'),
          _buildOperatorKey('-', accentColor),
        ]),
        AppSpacing.gapSm,

        // Row 4: ., 0, ⌫, +
        _buildKeyRow([
          _buildDecimalKey(),
          _buildDigitKey('0'),
          _buildBackspaceKey(),
          _buildOperatorKey('+', accentColor),
        ]),
        AppSpacing.gapSm,

        // Row 5: Clear, Equals
        _buildKeyRow([
          _buildClearKey(),
          Expanded(flex: 2, child: _buildEqualsKey(accentColor)),
        ]),
      ],
    );
  }

  Widget _buildKeyRow(List<Widget> keys) {
    return Row(
      children: keys.map((key) {
        if (key is Expanded) return key;
        return Expanded(child: key);
      }).toList(),
    );
  }

  Widget _buildDigitKey(String digit) {
    return _KeyButton(
      label: digit,
      onTap: () => _handleDigit(digit),
      backgroundColor: AppColors.primaryElevated,
      textColor: AppColors.textPrimary,
    );
  }

  Widget _buildDecimalKey() {
    return _KeyButton(
      label: '.',
      onTap: _handleDecimal,
      backgroundColor: AppColors.primaryElevated,
      textColor: AppColors.textPrimary,
      enabled: !_hasDecimal || _waitingForOperand,
    );
  }

  Widget _buildBackspaceKey() {
    return _KeyButton(
      icon: Icons.backspace_outlined,
      onTap: _handleBackspace,
      onLongPress: _handleClear,
      backgroundColor: AppColors.primarySurface,
      textColor: AppColors.textSecondary,
    );
  }

  Widget _buildOperatorKey(String operator, Color accentColor) {
    final isSelected = _operator == operator;
    return _KeyButton(
      label: operator,
      onTap: () => _handleOperator(operator),
      backgroundColor: isSelected
          ? accentColor.withValues(alpha: 0.3)
          : AppColors.primarySurface,
      textColor: accentColor,
      borderColor: isSelected ? accentColor : null,
    );
  }

  Widget _buildClearKey() {
    return _KeyButton(
      label: 'C',
      onTap: _handleClear,
      backgroundColor: AppColors.primarySurface,
      textColor: AppColors.warning,
    );
  }

  Widget _buildEqualsKey(Color accentColor) {
    return _KeyButton(
      label: '=',
      onTap: _handleEquals,
      backgroundColor: accentColor,
      textColor: AppColors.textPrimary,
    );
  }
}

/// Individual calculator key button with press animation.
class _KeyButton extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final bool enabled;

  const _KeyButton({
    this.label,
    this.icon,
    required this.onTap,
    this.onLongPress,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.enabled = true,
  }) : assert(label != null || icon != null);

  @override
  State<_KeyButton> createState() => _KeyButtonState();
}

class _KeyButtonState extends State<_KeyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.instant,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: AppAnimations.pressedScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppAnimations.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(_) {
    if (widget.enabled) {
      _controller.forward();
    }
  }

  void _handleTapUp(_) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.enabled ? widget.onTap : null,
        onLongPress: widget.enabled ? widget.onLongPress : null,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: AppSpacing.borderRadiusMd,
              border: widget.borderColor != null
                  ? Border.all(color: widget.borderColor!, width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: widget.icon != null
                  ? Icon(
                      widget.icon,
                      color: widget.enabled
                          ? widget.textColor
                          : widget.textColor.withValues(alpha: 0.4),
                      size: 24,
                    )
                  : Text(
                      widget.label!,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: widget.enabled
                            ? widget.textColor
                            : widget.textColor.withValues(alpha: 0.4),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

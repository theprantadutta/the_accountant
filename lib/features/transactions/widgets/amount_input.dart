import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Calculator-style amount input widget for transactions.
/// Supports math expressions (e.g., 50+25=75).
class AmountInput extends StatefulWidget {
  /// Initial amount to display
  final double initialAmount;

  /// Whether this is an income transaction (affects styling)
  final bool isIncome;

  /// Callback when amount changes
  final ValueChanged<double>? onAmountChanged;

  /// Callback when income/expense toggle changes
  final ValueChanged<bool>? onIsIncomeChanged;

  /// Currency symbol to display
  final String currencySymbol;

  /// Whether to show the income/expense toggle
  final bool showToggle;

  const AmountInput({
    super.key,
    this.initialAmount = 0.0,
    this.isIncome = false,
    this.onAmountChanged,
    this.onIsIncomeChanged,
    this.currencySymbol = '\$',
    this.showToggle = true,
  });

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  late String _expression;
  late bool _isIncome;
  double _result = 0.0;
  bool _justCalculated = false;

  @override
  void initState() {
    super.initState();
    _isIncome = widget.isIncome;
    if (widget.initialAmount > 0) {
      _expression = _formatNumber(widget.initialAmount);
      _result = widget.initialAmount;
    } else {
      _expression = '0';
      _result = 0.0;
    }
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  void _onDigit(String digit) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_justCalculated) {
        _expression = digit;
        _justCalculated = false;
      } else if (_expression == '0' && digit != '.') {
        _expression = digit;
      } else {
        _expression += digit;
      }
      _updateResult();
    });
  }

  void _onDecimal() {
    HapticFeedback.lightImpact();
    // Check if current number already has decimal
    final parts = _expression.split(RegExp(r'[+\-*/]'));
    final lastPart = parts.last;
    if (lastPart.contains('.')) return;

    setState(() {
      if (_justCalculated) {
        _expression = '0.';
        _justCalculated = false;
      } else {
        _expression += '.';
      }
    });
  }

  void _onOperator(String operator) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_expression.isEmpty || _expression == '0') {
        return;
      }
      // If last char is an operator, replace it
      final lastChar = _expression[_expression.length - 1];
      if (['+', '-', '*', '/'].contains(lastChar)) {
        _expression =
            _expression.substring(0, _expression.length - 1) + operator;
      } else {
        _expression += operator;
      }
      _justCalculated = false;
    });
  }

  void _onEquals() {
    HapticFeedback.mediumImpact();
    _calculateResult();
  }

  void _calculateResult() {
    try {
      // Parse and evaluate the expression
      final result = _evaluateExpression(_expression);
      setState(() {
        _result = result;
        _expression = _formatNumber(result);
        _justCalculated = true;
      });
      widget.onAmountChanged?.call(result.abs());
    } catch (e) {
      // Invalid expression, keep current
    }
  }

  double _evaluateExpression(String expr) {
    // Simple expression parser for +, -, *, /
    expr = expr.replaceAll(' ', '');
    if (expr.isEmpty) return 0;

    // Handle negative start
    bool isNegative = expr.startsWith('-');
    if (isNegative) expr = expr.substring(1);

    // Split by operators while keeping them
    final tokens = <String>[];
    var currentNumber = '';

    for (var i = 0; i < expr.length; i++) {
      final char = expr[i];
      if (['+', '-', '*', '/'].contains(char) && currentNumber.isNotEmpty) {
        tokens.add(currentNumber);
        tokens.add(char);
        currentNumber = '';
      } else {
        currentNumber += char;
      }
    }
    if (currentNumber.isNotEmpty) {
      tokens.add(currentNumber);
    }

    if (tokens.isEmpty) return 0;

    // First pass: handle * and /
    var i = 0;
    while (i < tokens.length) {
      if (tokens[i] == '*' || tokens[i] == '/') {
        final left = double.parse(tokens[i - 1]);
        final right = double.parse(tokens[i + 1]);
        final result = tokens[i] == '*' ? left * right : left / right;
        tokens[i - 1] = result.toString();
        tokens.removeAt(i);
        tokens.removeAt(i);
      } else {
        i++;
      }
    }

    // Second pass: handle + and -
    var result = double.parse(tokens[0]);
    i = 1;
    while (i < tokens.length) {
      final operator = tokens[i];
      final value = double.parse(tokens[i + 1]);
      if (operator == '+') {
        result += value;
      } else if (operator == '-') {
        result -= value;
      }
      i += 2;
    }

    return isNegative ? -result : result;
  }

  void _updateResult() {
    try {
      _result = _evaluateExpression(_expression);
      widget.onAmountChanged?.call(_result.abs());
    } catch (e) {
      // Expression not yet complete
    }
  }

  void _onBackspace() {
    HapticFeedback.lightImpact();
    setState(() {
      if (_expression.length > 1) {
        _expression = _expression.substring(0, _expression.length - 1);
      } else {
        _expression = '0';
      }
      _justCalculated = false;
      _updateResult();
    });
  }

  void _onClear() {
    HapticFeedback.mediumImpact();
    setState(() {
      _expression = '0';
      _result = 0.0;
      _justCalculated = false;
    });
    widget.onAmountChanged?.call(0.0);
  }

  void _toggleIncomeExpense() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isIncome = !_isIncome;
    });
    widget.onIsIncomeChanged?.call(_isIncome);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = _isIncome ? Colors.green : theme.colorScheme.primary;

    return Column(
      children: [
        // Income/Expense Toggle
        if (widget.showToggle) ...[
          _buildToggle(theme, primaryColor),
          const SizedBox(height: 16),
        ],

        // Amount Display
        _buildAmountDisplay(theme, primaryColor),
        const SizedBox(height: 24),

        // Calculator Pad
        _buildCalculatorPad(theme, primaryColor),
      ],
    );
  }

  Widget _buildToggle(ThemeData theme, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            label: 'Expense',
            isSelected: !_isIncome,
            onTap: () {
              if (_isIncome) _toggleIncomeExpense();
            },
            color: Colors.red,
            theme: theme,
          ),
          const SizedBox(width: 4),
          _buildToggleButton(
            label: 'Income',
            isSelected: _isIncome,
            onTap: () {
              if (!_isIncome) _toggleIncomeExpense();
            },
            color: Colors.green,
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: color, width: 2)
              : Border.all(color: Colors.transparent, width: 2),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : theme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildAmountDisplay(ThemeData theme, Color primaryColor) {
    final displayExpression = _expression
        .replaceAll('*', '\u00D7')
        .replaceAll('/', '\u00F7');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Expression (smaller, if different from result)
          if (_expression.contains(RegExp(r'[+\-*/]')))
            Text(
              displayExpression,
              style: TextStyle(
                fontSize: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          // Result
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.currencySymbol,
                style: TextStyle(
                  fontSize: 24,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _formatNumber(_result.abs()),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
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

  Widget _buildCalculatorPad(ThemeData theme, Color primaryColor) {
    return Column(
      children: [
        Row(
          children: [
            _buildButton('C', theme, onTap: _onClear, isOperator: true),
            _buildButton(
              '\u00F7',
              theme,
              onTap: () => _onOperator('/'),
              isOperator: true,
            ),
            _buildButton(
              '\u00D7',
              theme,
              onTap: () => _onOperator('*'),
              isOperator: true,
            ),
            _buildButton(
              '\u232B',
              theme,
              onTap: _onBackspace,
              isOperator: true,
            ),
          ],
        ),
        Row(
          children: [
            _buildButton('7', theme, onTap: () => _onDigit('7')),
            _buildButton('8', theme, onTap: () => _onDigit('8')),
            _buildButton('9', theme, onTap: () => _onDigit('9')),
            _buildButton(
              '-',
              theme,
              onTap: () => _onOperator('-'),
              isOperator: true,
            ),
          ],
        ),
        Row(
          children: [
            _buildButton('4', theme, onTap: () => _onDigit('4')),
            _buildButton('5', theme, onTap: () => _onDigit('5')),
            _buildButton('6', theme, onTap: () => _onDigit('6')),
            _buildButton(
              '+',
              theme,
              onTap: () => _onOperator('+'),
              isOperator: true,
            ),
          ],
        ),
        Row(
          children: [
            _buildButton('1', theme, onTap: () => _onDigit('1')),
            _buildButton('2', theme, onTap: () => _onDigit('2')),
            _buildButton('3', theme, onTap: () => _onDigit('3')),
            _buildButton(
              '=',
              theme,
              onTap: _onEquals,
              isPrimary: true,
              primaryColor: primaryColor,
            ),
          ],
        ),
        Row(
          children: [
            _buildButton(
              '00',
              theme,
              onTap: () {
                _onDigit('0');
                _onDigit('0');
              },
            ),
            _buildButton('0', theme, onTap: () => _onDigit('0')),
            _buildButton('.', theme, onTap: _onDecimal),
            const Expanded(child: SizedBox()), // Empty space to align
          ],
        ),
      ],
    );
  }

  Widget _buildButton(
    String label,
    ThemeData theme, {
    VoidCallback? onTap,
    bool isOperator = false,
    bool isPrimary = false,
    Color? primaryColor,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: isPrimary
              ? (primaryColor ?? theme.colorScheme.primary)
              : isOperator
              ? theme.colorScheme.surfaceContainerHighest
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          elevation: isPrimary ? 2 : 0,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 64,
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: label.length > 1 ? 20 : 28,
                  fontWeight: FontWeight.w500,
                  color: isPrimary
                      ? Colors.white
                      : isOperator
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

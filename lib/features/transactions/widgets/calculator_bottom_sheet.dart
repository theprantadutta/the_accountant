import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Enter an amount on the Sunrise keypad, with + − × ÷ for quick sums.
/// Resolves to the amount when the user taps Done, or null when dismissed.
Future<double?> showCalculatorBottomSheet({
  required BuildContext context,
  required double initialAmount,
  required bool isIncome,
  required String currencySymbol,
  Color? accentColor,
}) {
  return showSunriseSheet<double>(
    context: context,
    builder: (context) => _AmountInputSheet(
      initialAmount: initialAmount,
      currencySymbol: currencySymbol,
    ),
  );
}

class _AmountInputSheet extends StatefulWidget {
  const _AmountInputSheet({
    required this.initialAmount,
    required this.currencySymbol,
  });

  final double initialAmount;
  final String currencySymbol;

  @override
  State<_AmountInputSheet> createState() => _AmountInputSheetState();
}

class _AmountInputSheetState extends State<_AmountInputSheet> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialAmount > 0 ? _plain(widget.initialAmount) : '',
  );
  final FocusNode _focusNode = FocusNode();

  static const _ops = ['+', '−', '×', '÷'];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
    // Focused so a hardware keyboard (or a test) can type straight in; the
    // on-screen keyboard stays away because the field asks for none.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  static String _plain(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

  String get _text => _controller.text;
  bool get _hasOperator => _ops.any((o) => _text.contains(o));

  /// The expression's value, rounded to cents. Unfinished sums are evaluated
  /// as far as they go ("12+" is 12).
  double get _amount {
    final value = _evaluate(_text);
    if (value == null || value.isNaN || value.isInfinite || value < 0) {
      return 0;
    }
    return (value * 100).round() / 100;
  }

  static double? _evaluate(String expr) {
    var s = expr.replaceAll(' ', '');
    while (s.isNotEmpty && '+−×÷.'.contains(s[s.length - 1])) {
      s = s.substring(0, s.length - 1);
    }
    if (s.isEmpty) return 0;
    final tokens = RegExp(
      r'(\d+\.?\d*|\.\d+|[+−×÷])',
    ).allMatches(s).map((m) => m.group(0)!).toList();
    if (tokens.isEmpty) return null;
    // × and ÷ first, then + and −.
    final terms = <double>[];
    final signs = <String>[];
    double? current;
    String? pending;
    for (final t in tokens) {
      if (t == '×' || t == '÷') {
        pending = t;
      } else if (t == '+' || t == '−') {
        if (current != null) terms.add(current);
        signs.add(t);
        current = null;
      } else {
        final n = double.tryParse(t);
        if (n == null) return null;
        if (pending != null && current != null) {
          current = pending == '×' ? current * n : current / n;
          pending = null;
        } else {
          current = n;
        }
      }
    }
    if (current != null) terms.add(current);
    if (terms.isEmpty) return 0;
    var total = terms.first;
    for (var i = 1; i < terms.length; i++) {
      total = signs[i - 1] == '+' ? total + terms[i] : total - terms[i];
    }
    return total;
  }

  void _set(String text) {
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _press(String key) {
    HapticFeedback.selectionClick();
    final t = _text;
    if (_ops.contains(key)) {
      if (t.isEmpty) return;
      final last = t[t.length - 1];
      _set(_ops.contains(last) ? t.substring(0, t.length - 1) + key : t + key);
      return;
    }
    final lastNumber = t.split(RegExp('[+−×÷]')).last;
    if (key == '.') {
      if (lastNumber.contains('.')) return;
      _set(t + (lastNumber.isEmpty ? '0.' : '.'));
      return;
    }
    // At most two decimals in a number.
    final dot = lastNumber.indexOf('.');
    if (dot >= 0 && lastNumber.length - dot > 2) return;
    if (lastNumber == '0') {
      _set(t.substring(0, t.length - 1) + key);
      return;
    }
    if (t.length >= 24) return;
    _set(t + key);
  }

  void _backspace() {
    HapticFeedback.selectionClick();
    if (_text.isEmpty) return;
    _set(_text.substring(0, _text.length - 1));
  }

  void _clear() {
    HapticFeedback.mediumImpact();
    _set('');
  }

  void _done() {
    HapticFeedback.mediumImpact();
    Navigator.pop(context, _amount);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final big = SunriseType.amountHero.copyWith(fontSize: 52, color: c.ink);

    return SunriseBottomSheet(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  l10n.addAmount,
                  style: SunriseType.section.copyWith(color: c.ink),
                ),
              ),
              SunriseIconButton(
                icon: Symbols.close_rounded,
                size: 36,
                iconSize: 20,
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
            decoration: BoxDecoration(
              gradient: c.softStrip,
              borderRadius: SunriseRadius.cardAll,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 18,
                  child: _hasOperator
                      ? Text(
                          '= ${widget.currencySymbol}${_plain(_amount)}',
                          style: SunriseType.label.copyWith(color: c.muted),
                        )
                      : null,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.currencySymbol,
                      style: big.copyWith(
                        fontSize: 34,
                        fontWeight: FontWeight.w500,
                        color: c.accentText,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        // The keypad below is the input; no system keyboard.
                        keyboardType: TextInputType.none,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9.+−×÷]'),
                          ),
                        ],
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        style: big,
                        cursorColor: c.accent,
                        showCursor: true,
                        decoration: InputDecoration(
                          hintText: '0.00',
                          hintStyle: big.copyWith(color: c.faint),
                          filled: false,
                          isDense: true,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSubmitted: (_) => _done(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _Keypad(onKey: _press, onBackspace: _backspace, onClear: _clear),
          const SizedBox(height: 14),
          SunriseButton(label: l10n.importDone, height: 56, onPressed: _done),
        ],
      ),
    );
  }
}

/// Digits on the left, operators down the right; long-press ⌫ clears.
/// Done evaluates whatever sum is on the display.
class _Keypad extends StatelessWidget {
  const _Keypad({
    required this.onKey,
    required this.onBackspace,
    required this.onClear,
  });

  final ValueChanged<String> onKey;
  final VoidCallback onBackspace;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['7', '8', '9', '÷'],
      ['4', '5', '6', '×'],
      ['1', '2', '3', '−'],
      ['.', '0', '⌫', '+'],
    ];
    return Column(
      children: [
        for (var r = 0; r < rows.length; r++) ...[
          if (r > 0) const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 0; i < 4; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(child: _key(context, rows[r][i])),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _key(BuildContext context, String k) {
    final c = context.sunrise;
    final isOp = '÷×−+'.contains(k);
    if (k == '⌫') {
      return _KeyTile(
        background: c.surface,
        onTap: onBackspace,
        onLongPress: onClear,
        semanticLabel: MaterialLocalizations.of(context).deleteButtonTooltip,
        child: Icon(Symbols.backspace_rounded, color: c.ink, size: 24),
      );
    }
    return _KeyTile(
      background: isOp ? c.tintOrange : c.surface,
      onTap: () => onKey(k),
      semanticLabel: k,
      child: Text(
        k,
        style: SunriseType.pushTitle.copyWith(
          color: isOp ? c.accentText : c.ink,
          fontSize: isOp ? 26 : 24,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _KeyTile extends StatelessWidget {
  const _KeyTile({
    required this.background,
    required this.onTap,
    required this.child,
    required this.semanticLabel,
    this.onLongPress,
  });

  final Color background;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Widget child;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Pressable(
      onTap: onTap,
      onLongPress: onLongPress,
      scale: .94,
      semanticLabel: semanticLabel,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(SunriseRadius.category),
          boxShadow: background == c.surface ? c.cardShadow : null,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

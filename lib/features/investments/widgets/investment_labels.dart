import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/data/models/investment.dart';
import 'package:the_accountant/features/plans/widgets/plan_labels.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sensitive.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Names, icons and colours for the kinds of holding, in one place.
extension InvestmentKindLabels on InvestmentKind {
  String label(L10n l10n) => switch (this) {
    InvestmentKind.fund => l10n.investmentKindFund,
    InvestmentKind.stock => l10n.investmentKindStock,
    InvestmentKind.other => l10n.investmentKindOther,
  };

  IconData get icon => switch (this) {
    InvestmentKind.fund => Symbols.pie_chart_rounded,
    InvestmentKind.stock => Symbols.candlestick_chart_rounded,
    InvestmentKind.other => Symbols.diamond_rounded,
  };

  Color get color => switch (this) {
    InvestmentKind.fund => const Color(0xFF7C3AED),
    InvestmentKind.stock => const Color(0xFF2563EB),
    InvestmentKind.other => const Color(0xFFCA8A04),
  };
}

final _units = NumberFormat('#,##0.####');

/// Units the way a statement shows them: grouped, up to four places.
String formatUnits(double units) => _units.format(units);

/// A gain or loss, in money and as a percentage of what went in.
class GainLine extends ConsumerWidget {
  const GainLine({
    super.key,
    required this.gain,
    required this.putIn,
    required this.currency,
    this.compact = false,
  });

  final int gain;
  final int putIn;
  final String currency;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final f = PlanFormat(ref, context);
    final color = gain > 0
        ? c.positive
        : gain < 0
        ? c.negative
        : c.muted;
    final sign = gain > 0 ? '+' : (gain < 0 ? '−' : '');
    final percent = putIn == 0
        ? ''
        : ' ($sign${(gain.abs() / putIn * 100).toStringAsFixed(1)}%)';
    final amount = '$sign${f.money(gain.abs(), currency)}';
    final text = '$amount$percent';
    // The percentage says how it is going without saying how much is in it.
    return SensitiveText(
      compact ? text : l10n.investmentGainLine(text),
      amounts: [amount],
      style: SunriseType.caption.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

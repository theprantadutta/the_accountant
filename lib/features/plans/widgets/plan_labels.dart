import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/data/models/plan.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Names, icons and colours for the kinds of plan, in one place.
extension PlanKindLabels on PlanKind {
  String label(L10n l10n) => switch (this) {
    PlanKind.emi => l10n.planKindEmi,
    PlanKind.loan => l10n.planKindLoan,
    PlanKind.dps => l10n.planKindDps,
    PlanKind.fdr => l10n.planKindFdr,
  };

  String describe(L10n l10n) => switch (this) {
    PlanKind.emi => l10n.planKindEmiHint,
    PlanKind.loan => l10n.planKindLoanHint,
    PlanKind.dps => l10n.planKindDpsHint,
    PlanKind.fdr => l10n.planKindFdrHint,
  };

  IconData get icon => switch (this) {
    PlanKind.emi => Symbols.shopping_bag_rounded,
    PlanKind.loan => Symbols.account_balance_rounded,
    PlanKind.dps => Symbols.savings_rounded,
    PlanKind.fdr => Symbols.lock_clock_rounded,
  };

  Color get color => switch (this) {
    PlanKind.emi => const Color(0xFFF97316),
    PlanKind.loan => const Color(0xFFE11D48),
    PlanKind.dps => const Color(0xFF0EA5E9),
    PlanKind.fdr => const Color(0xFF10B981),
  };

  /// Whether its money is saved rather than spent.
  bool get isSaving => this == PlanKind.dps || this == PlanKind.fdr;
}

extension PlanFrequencyLabels on PlanFrequency {
  String label(L10n l10n) => switch (this) {
    PlanFrequency.weekly => l10n.planWeekly,
    PlanFrequency.monthly => l10n.planMonthly,
    PlanFrequency.yearly => l10n.planYearly,
  };
}

/// Money and dates the way the rest of the app writes them.
class PlanFormat {
  PlanFormat(this.ref, this.context);

  final WidgetRef ref;
  final BuildContext context;

  String money(int cents, String currency, {bool useDecimals = true}) =>
      cents.formatCurrency(
        currency,
        useDecimals: useDecimals,
        numberFormat: ref.watch(numberFormatSettingProvider),
      );

  String day(DateTime d) => DateFormat(
    'd MMM yyyy',
    Localizations.localeOf(context).toString(),
  ).format(d);
}

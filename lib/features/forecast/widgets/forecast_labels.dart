import 'package:flutter/widgets.dart';
import 'package:the_accountant/features/forecast/services/cash_flow_forecast_service.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Names and icons for what a forecast event is, in one place.
extension ForecastEventKindLabels on ForecastEventKind {
  String label(L10n l10n) => switch (this) {
    ForecastEventKind.installment => l10n.forecastKindInstallment,
    ForecastEventKind.premium => l10n.forecastKindPremium,
    ForecastEventKind.deposit => l10n.forecastKindDeposit,
    ForecastEventKind.sipBuy => l10n.forecastKindSipBuy,
    ForecastEventKind.profit => l10n.forecastKindProfit,
    ForecastEventKind.maturity => l10n.forecastKindMaturity,
    ForecastEventKind.cardBill => l10n.forecastKindCardBill,
    ForecastEventKind.cardBillNext => l10n.forecastKindCardBillNext,
    ForecastEventKind.subscription => l10n.forecastKindSubscription,
    ForecastEventKind.recurringBill => l10n.forecastKindRecurringBill,
    ForecastEventKind.recurringIncome => l10n.forecastKindRecurringIncome,
    ForecastEventKind.upcoming => l10n.forecastKindUpcoming,
    ForecastEventKind.borrowed => l10n.forecastKindBorrowed,
    ForecastEventKind.lent => l10n.forecastKindLent,
  };

  IconData get icon => switch (this) {
    ForecastEventKind.installment => Symbols.shopping_bag_rounded,
    ForecastEventKind.premium => Symbols.shield_rounded,
    ForecastEventKind.deposit => Symbols.savings_rounded,
    ForecastEventKind.sipBuy => Symbols.auto_graph_rounded,
    ForecastEventKind.profit => Symbols.payments_rounded,
    ForecastEventKind.maturity => Symbols.lock_clock_rounded,
    ForecastEventKind.cardBill ||
    ForecastEventKind.cardBillNext => Symbols.credit_card_rounded,
    ForecastEventKind.subscription => Symbols.autorenew_rounded,
    ForecastEventKind.recurringBill => Symbols.event_repeat_rounded,
    ForecastEventKind.recurringIncome => Symbols.south_west_rounded,
    ForecastEventKind.upcoming => Symbols.event_upcoming_rounded,
    ForecastEventKind.borrowed ||
    ForecastEventKind.lent => Symbols.handshake_rounded,
  };
}

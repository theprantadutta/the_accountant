import 'package:the_accountant/l10n/app_l10n.dart';

/// The next payment a repeating schedule will record, before it has.
///
/// A schedule writes its transaction on the day it falls due, so until then
/// it exists only as a date on the schedule. Upcoming showed only rows that
/// had been written, which left a rent or a DPS due in three days nowhere on
/// the screen meant to show what is coming.
class ScheduledPayment {
  const ScheduledPayment({
    required this.configId,
    required this.baseTransactionId,
    required this.title,
    required this.amount,
    required this.walletId,
    required this.isIncome,
    required this.date,
    required this.frequency,
    required this.periodLength,
    required this.autoPay,
    this.categoryId,
  });

  final String configId;
  final String baseTransactionId;
  final String title;

  /// Minor units of [walletId]'s currency.
  final int amount;
  final String walletId;
  final bool isIncome;
  final String? categoryId;
  final DateTime date;
  final String frequency;
  final int periodLength;

  /// False when the schedule waits for the payment to be confirmed.
  final bool autoPay;

  String get frequencyText => recurrenceLabel(frequency, periodLength);
}

/// "Monthly", "Every 3 months": how often a schedule repeats.
String recurrenceLabel(String frequency, int periodLength) {
  if (periodLength == 1) {
    switch (frequency.toLowerCase()) {
      case 'daily':
        return appL10n.budgetPeriodDaily;
      case 'weekly':
        return appL10n.planWeekly;
      case 'monthly':
        return appL10n.planMonthly;
      case 'yearly':
        return appL10n.planYearly;
      default:
        return frequency;
    }
  }
  switch (frequency.toLowerCase()) {
    case 'daily':
      return appL10n.subEveryDays(periodLength);
    case 'weekly':
      return appL10n.subEveryWeeks(periodLength);
    case 'monthly':
      return appL10n.subEveryMonths(periodLength);
    case 'yearly':
      return appL10n.subEveryYears(periodLength);
    default:
      return appL10n.subEveryOther(periodLength, frequency);
  }
}

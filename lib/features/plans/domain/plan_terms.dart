import 'dart:math' as math;

import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/plan.dart';

/// The arithmetic of EMIs, loans, DPS and FDR.
///
/// Banks quote their own figures and a user can always enter those instead;
/// these are the standard formulas, so a plan made from a rate and a term
/// starts from a sensible number.
class PlanMath {
  const PlanMath._();

  /// Installments a year for [frequency] every [interval] periods.
  static double periodsPerYear(PlanFrequency frequency, int interval) =>
      switch (frequency) {
        PlanFrequency.weekly => 52,
        PlanFrequency.monthly => 12,
        PlanFrequency.yearly => 1,
      } /
      math.max(1, interval);

  /// The level installment that repays [principal] with interest at
  /// [annualRate] percent, on the reducing balance, in [count] installments.
  /// No rate means the principal split evenly.
  static int installmentFor({
    required int principal,
    required double? annualRate,
    required int count,
    required PlanFrequency frequency,
    int interval = 1,
  }) {
    if (count <= 0) return principal;
    final rate = annualRate ?? 0;
    if (rate <= 0) return (principal / count).ceil();
    final r = rate / 100 / periodsPerYear(frequency, interval);
    final growth = math.pow(1 + r, count);
    return (principal * r * growth / (growth - 1)).round();
  }

  /// How each installment of a loan divides into interest and principal, on
  /// the reducing balance. The last installment takes whatever principal is
  /// left, so the parts always add up to exactly what was borrowed.
  static List<({int principal, int interest})> amortize({
    required int principal,
    required double? annualRate,
    required int installment,
    required int count,
    required PlanFrequency frequency,
    int interval = 1,
  }) {
    final rate = annualRate ?? 0;
    final r = rate <= 0
        ? 0.0
        : rate / 100 / periodsPerYear(frequency, interval);
    var balance = principal;
    final rows = <({int principal, int interest})>[];
    for (var n = 1; n <= count; n++) {
      final interest = (balance * r).round();
      var repay = installment - interest;
      if (n == count || repay > balance) repay = balance;
      if (repay < 0) repay = 0;
      balance -= repay;
      rows.add((principal: repay, interest: interest));
    }
    return rows;
  }

  /// What a DPS pays back: [installment] saved at the start of each of
  /// [count] periods, growing at [annualRate] percent compounded each period.
  static int dpsMaturity({
    required int installment,
    required double? annualRate,
    required int count,
    required PlanFrequency frequency,
    int interval = 1,
  }) {
    final rate = annualRate ?? 0;
    if (rate <= 0) return installment * count;
    final i = rate / 100 / periodsPerYear(frequency, interval);
    return (installment * ((math.pow(1 + i, count) - 1) / i) * (1 + i)).round();
  }

  /// What an FDR of [principal] at [annualRate] percent comes to after
  /// [months]: simple interest up to a year, compounded yearly after that, as
  /// banks usually quote them.
  static int fdrMaturity({
    required int principal,
    required double? annualRate,
    required int months,
  }) {
    final rate = (annualRate ?? 0) / 100;
    if (rate <= 0) return principal;
    if (months <= 12) return (principal * (1 + rate * months / 12)).round();
    return (principal * math.pow(1 + rate, months / 12)).round();
  }

  /// An FDR's profit each month when it is paid out monthly, before tax.
  static int fdrMonthlyProfit({
    required int principal,
    required double? annualRate,
  }) => (principal * (annualRate ?? 0) / 100 / 12).round();

  /// What is left of [profit] after [taxRate] percent is taken at source.
  static int afterTax(int profit, double? taxRate) =>
      (profit * (1 - (taxRate ?? 0).clamp(0, 100) / 100)).round();

  /// A fixed deposit's profit for one payout, after tax: a month's or a
  /// quarter's, by [payout].
  static int periodicProfit(Plan plan) => afterTax(
    (plan.principal *
            (plan.interestRate ?? 0) /
            100 /
            (plan.payout == PlanPayout.quarterly ? 4 : 12))
        .round(),
    plan.taxRate,
  );
}

/// Where a plan's dates fall.
class PlanDates {
  const PlanDates._();

  /// [start] moved on by [periods] of [frequency]. A day past the end of a
  /// month means its last day, so an EMI due on the 31st falls on the 30th in
  /// April and the 28th in February, and goes back to the 31st after.
  static DateTime shift(DateTime start, PlanFrequency frequency, int periods) {
    switch (frequency) {
      case PlanFrequency.weekly:
        return DateTime(
          start.year,
          start.month,
          start.day + 7 * periods,
          start.hour,
          start.minute,
        );
      case PlanFrequency.monthly:
        final last = DateTime(start.year, start.month + periods + 1, 0).day;
        return DateTime(
          start.year,
          start.month + periods,
          math.min(start.day, last),
          start.hour,
          start.minute,
        );
      case PlanFrequency.yearly:
        final last = DateTime(start.year + periods, start.month + 1, 0).day;
        return DateTime(
          start.year + periods,
          start.month,
          math.min(start.day, last),
          start.hour,
          start.minute,
        );
    }
  }

  /// How many months an FDR runs for.
  static int fdrMonths(Plan plan) =>
      plan.installmentCount *
      plan.interval *
      switch (plan.frequency) {
        PlanFrequency.yearly => 12,
        _ => 1,
      };

  /// The day a DPS, FDR or bond matures, an insurance policy pays out (or
  /// takes its last premium), or an EMI or loan's last installment.
  static DateTime endOf(Plan plan) {
    if (plan.kind.isFixedDeposit) {
      return shift(plan.startDate, PlanFrequency.monthly, fdrMonths(plan));
    }
    final paysOut =
        plan.kind == PlanKind.dps ||
        (plan.kind == PlanKind.insurance && (plan.maturityAmount ?? 0) > 0);
    return shift(
      plan.startDate,
      plan.frequency,
      (plan.installmentCount - (paysOut ? 0 : 1)) * plan.interval,
    );
  }
}

/// One thing a plan does on a day.
enum PlanEventType {
  /// EMI or loan installment paid, or a DPS deposit made.
  installment,

  /// An FDR's monthly profit received.
  profit,

  /// A DPS or FDR paid back.
  maturity,
}

/// One scheduled event of a plan, with what it is worth.
class PlanEvent {
  const PlanEvent({
    required this.number,
    required this.type,
    required this.date,
    required this.amount,
    this.principalPart = 0,
    this.interestPart = 0,
  });

  /// Stored on the transactions it makes, as [Transactions.planInstallment].
  final int number;
  final PlanEventType type;
  final DateTime date;

  /// Minor units: the installment, the profit, or the whole maturity.
  final int amount;

  /// Loan installments: the part that repays what was borrowed. Maturities:
  /// the part that was deposited.
  final int principalPart;

  /// Loan installments: the interest. Maturities: the profit.
  final int interestPart;
}

/// Everything a plan is scheduled to do, in order.
List<PlanEvent> planEvents(Plan plan) {
  DateTime due(int n) =>
      PlanDates.shift(plan.startDate, plan.frequency, (n - 1) * plan.interval);
  List<PlanEvent> installments() => [
    for (var n = 1; n <= plan.installmentCount; n++)
      PlanEvent(
        number: n,
        type: PlanEventType.installment,
        date: due(n),
        amount: plan.installmentAmount,
      ),
  ];

  switch (plan.kind) {
    case PlanKind.emi:
      return installments();
    case PlanKind.insurance:
      final payout = plan.maturityAmount ?? 0;
      return [
        ...installments(),
        if (payout > 0)
          PlanEvent(
            number: plan.installmentCount + 1,
            type: PlanEventType.maturity,
            date: PlanDates.endOf(plan),
            amount: payout,
            interestPart: payout,
          ),
      ];
    case PlanKind.loan:
      final parts = PlanMath.amortize(
        principal: plan.principal,
        annualRate: plan.interestRate,
        installment: plan.installmentAmount,
        count: plan.installmentCount,
        frequency: plan.frequency,
        interval: plan.interval,
      );
      return [
        for (var n = 1; n <= plan.installmentCount; n++)
          PlanEvent(
            number: n,
            type: PlanEventType.installment,
            date: due(n),
            amount: parts[n - 1].principal + parts[n - 1].interest,
            principalPart: parts[n - 1].principal,
            interestPart: parts[n - 1].interest,
          ),
      ];
    case PlanKind.dps:
      final deposited = plan.installmentAmount * plan.installmentCount;
      final profit = PlanMath.afterTax(
        math.max(0, (plan.maturityAmount ?? deposited) - deposited),
        plan.taxRate,
      );
      return [
        ...installments(),
        PlanEvent(
          number: plan.installmentCount + 1,
          type: PlanEventType.maturity,
          date: PlanDates.endOf(plan),
          amount: deposited + profit,
          principalPart: deposited,
          interestPart: profit,
        ),
      ];
    case PlanKind.fdr:
    case PlanKind.bond:
      final months = PlanDates.fdrMonths(plan);
      final every = switch (plan.payout) {
        PlanPayout.monthly => 1,
        PlanPayout.quarterly => 3,
        PlanPayout.atMaturity => 0,
      };
      final payouts = every == 0 ? 0 : months ~/ every;
      final profit = PlanMath.periodicProfit(plan);
      final atEnd = every == 0
          ? PlanMath.afterTax(
              math.max(
                0,
                (plan.maturityAmount ?? plan.principal) - plan.principal,
              ),
              plan.taxRate,
            )
          : 0;
      return [
        for (var n = 1; n <= payouts; n++)
          PlanEvent(
            number: n,
            type: PlanEventType.profit,
            date: PlanDates.shift(
              plan.startDate,
              PlanFrequency.monthly,
              n * every,
            ),
            amount: profit,
            interestPart: profit,
          ),
        PlanEvent(
          number: months + 1,
          type: PlanEventType.maturity,
          date: PlanDates.endOf(plan),
          amount: plan.principal + atEnd,
          principalPart: plan.principal,
          interestPart: atEnd,
        ),
      ];
  }
}

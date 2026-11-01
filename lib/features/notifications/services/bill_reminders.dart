import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/services/notified_once.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/plan.dart';
import 'package:the_accountant/data/models/wallet.dart';
import 'package:the_accountant/features/cards/domain/card_statement.dart';
import 'package:the_accountant/features/plans/domain/plan_terms.dart';
import 'package:the_accountant/features/plans/services/plan_service.dart';

/// Credit-card bill and plan reminders, worked out on the phone.
///
/// The server used to send these by reading the card's transactions and the
/// plan's amounts. From 5.0 those are sealed and the server cannot read them,
/// so the phone says the same things itself — which also means they now reach
/// users who never synced at all. The catch: the phone has to run to send
/// them, so a phone that does not open the app for days can miss one. Settings
/// says so.
class BillReminders {
  const BillReminders._();

  /// Not before this hour, local time, like the server.
  static const int earliestHour = 8;

  /// The user's "Bill reminders" switch (Notifications settings).
  static const String enabledPrefKey =
      'notification_prefs_bill_reminders_enabled';

  /// What there is to say about [bill] today, if anything.
  static List<BillReminder> forCard({
    required Wallet card,
    required CardStatement bill,
    required DateTime today,
    required String Function(int minor) money,
    required String Function(DateTime day) date,
  }) {
    final day = CardCycle.dateOnly(today);
    final due = date(bill.dueDate);
    final daysLeft = bill.dueDate.difference(day).inDays;
    final out = <BillReminder>[];
    final key = 'card:${card.id}:${NotifiedOnce.day(bill.dueDate)}';

    if (day ==
            CardCycle.dateOnly(
              bill.statementDate,
            ).add(const Duration(days: 1)) &&
        bill.owed > 0) {
      out.add(
        BillReminder(
          key: '$key:statement',
          title: '${card.name} statement is ready',
          body: bill.isSettled
              ? 'It came to ${money(bill.owed)}, already paid. Nothing more is due.'
              : '${money(bill.remaining)} is due by $due.',
        ),
      );
    }
    if (bill.isSettled) return out;

    final paidSoFar = bill.paid > 0
        ? ' ${money(bill.paid)} of ${money(bill.owed)} is already paid.'
        : '';
    final remindBefore = card.dueReminderDays;
    if (remindBefore > 0 && daysLeft == remindBefore) {
      out.add(
        BillReminder(
          key: '$key:due',
          title: daysLeft == 1
              ? '${card.name} bill is due tomorrow'
              : '${card.name} bill is due in $daysLeft days',
          body: 'Pay ${money(bill.remaining)} by $due.$paidSoFar',
        ),
      );
    }
    if (daysLeft == 0) {
      out.add(
        BillReminder(
          key: '$key:today',
          title: '${card.name} bill is due today',
          body:
              '${money(bill.remaining)} is still unpaid.$paidSoFar Paying today avoids a late fee.',
        ),
      );
    }
    return out;
  }

  /// What to say about [next] today, or null when today is not the day.
  static BillReminder? forPlan({
    required Plan plan,
    required PlanEvent next,
    required String account,
    required DateTime today,
    required String Function(int minor) money,
    required String Function(DateTime day) date,
  }) {
    final day = DateTime(today.year, today.month, today.day);
    final on = DateTime(next.date.year, next.date.month, next.date.day);
    final daysLeft = on.difference(day).inDays;
    final byHand = !plan.autoCollect;
    final maturity = next.type == PlanEventType.maturity;
    if (daysLeft < 0) return null;
    if (daysLeft != plan.reminderDaysBefore &&
        !(daysLeft == 0 && (byHand || maturity))) {
      return null;
    }

    final when = switch (daysLeft) {
      0 => 'today',
      1 => 'tomorrow',
      _ => 'in $daysLeft days',
    };
    final key = 'plan:${plan.id}:${next.number}:$daysLeft';
    final amount = money(next.amount);
    final onDay = date(next.date);

    if (maturity) {
      return plan.kind == PlanKind.insurance
          ? BillReminder(
              key: key,
              title: '${plan.name} pays out $when',
              body: '$amount is due to $account on $onDay.',
            )
          : BillReminder(
              key: key,
              title: '${plan.name} matures $when',
              body: '$amount comes back to $account on $onDay.',
            );
    }

    final what = switch (plan.kind) {
      PlanKind.dps => 'deposit',
      PlanKind.insurance => 'premium',
      PlanKind.sip => 'SIP',
      _ => 'installment',
    };
    return BillReminder(
      key: key,
      title:
          '${plan.name}: $what ${next.number} of ${plan.installmentCount} due $when',
      body: switch ((byHand, plan.kind)) {
        (true, PlanKind.sip) => 'Invest $amount by $onDay.',
        (true, _) => 'Pay $amount by $onDay.',
        (false, PlanKind.sip) =>
          '$amount will be invested from $account on $onDay.',
        _ => '$amount will be recorded from $account on $onDay.',
      },
    );
  }

  /// Everything due to be said now, each claimed so it is said only once.
  ///
  /// Run from the hourly background task; [show] posts one notification.
  static Future<int> run({
    required AppDatabase db,
    required SharedPreferences prefs,
    required DateTime now,
    required String Function(int minor, String walletId) money,
    required String Function(DateTime day) date,
    required Future<void> Function(BillReminder reminder) show,
  }) async {
    if (!(prefs.getBool(enabledPrefKey) ?? true)) return 0;
    if (now.hour < earliestHour) return 0;

    final due = <BillReminder>[];
    final wallets = await db.getAllWallets();

    for (final card in wallets) {
      if (card.walletType != WalletType.creditCard ||
          card.isArchived ||
          card.billingCycleDay == null ||
          card.paymentDueDay == null ||
          card.dueReminderDays <= 0) {
        continue;
      }
      final bill = CardBill.of(
        card,
        await db.getTransactionsByWallet(card.id),
        today: now,
        historyLength: 0,
      ).latest;
      if (bill == null) continue;
      due.addAll(
        forCard(
          card: card,
          bill: bill,
          today: now,
          money: (m) => money(m, card.id),
          date: date,
        ),
      );
    }

    final names = {for (final w in wallets) w.id: w.name};
    final plans = PlanService(db);
    for (final plan in await plans.allPlans()) {
      if (plan.status != PlanStatus.active || plan.reminderDaysBefore <= 0) {
        continue;
      }
      final progress = await plans.progressOf(plan);
      final upcoming = progress.events
          .where(
            (e) =>
                e.type != PlanEventType.profit &&
                !progress.recorded.contains(e.number),
          )
          .firstOrNull;
      if (upcoming == null) continue;
      final reminder = forPlan(
        plan: plan,
        next: upcoming,
        account: names[plan.walletId] ?? 'your account',
        today: now,
        money: (m) => money(m, plan.walletId),
        date: date,
      );
      if (reminder != null) due.add(reminder);
    }

    var sent = 0;
    for (final reminder in due) {
      if (!await NotifiedOnce.claim('bill:${reminder.key}', prefs: prefs)) {
        continue;
      }
      await show(reminder);
      sent++;
    }
    return sent;
  }
}

/// One reminder: what to say, and the key that makes it say it once.
class BillReminder {
  const BillReminder({
    required this.key,
    required this.title,
    required this.body,
  });

  final String key;
  final String title;
  final String body;
}

import 'dart:ui' show PlatformDispatcher;

import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/providers/locale_provider.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/services/financial_calculation_service.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/models/transaction.dart'
    show TransactionSpecialType;
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/budgets/domain/budget_engine.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart'
    show BudgetView;
import 'package:the_accountant/features/categories/providers/category_provider.dart'
    as cat;
import 'package:the_accountant/features/dashboard/providers/net_worth_preferences_provider.dart';
import 'package:the_accountant/features/objectives/providers/objectives_provider.dart';
import 'package:the_accountant/features/recurring/services/recurring_service.dart';
import 'package:the_accountant/features/subscriptions/providers/subscription_dashboard_provider.dart'
    show SubscriptionItem;
import 'package:the_accountant/features/transactions/providers/upcoming_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

/// Reads a provider; both [Ref.read] and [WidgetRef.read] fit.
typedef ProviderReader = T Function<T>(ProviderListenable<T> provider);

/// The user's money in a form the AI can reason about.
///
/// Built on the device because only Premium users sync: for everyone else the
/// server has no transactions to read. Everything is converted to the user's
/// main currency and in major units, and lists are trimmed to what the server
/// accepts, so the model never sees cents, exchange rates or a whole ledger.
class FinanceContextBuilder {
  FinanceContextBuilder(this._read);

  final ProviderReader _read;

  static const _topCategories = 12;
  static const _recent = 60;
  static const _recentDays = 60;
  static const _historyMonths = 6;

  /// The app's language for AI replies: "bn" when Bangla, else "en".
  static String languageOf(ProviderReader read) {
    final chosen = read(localeProvider)?.languageCode;
    final code = chosen ?? PlatformDispatcher.instance.locale.languageCode;
    return code == 'bn' ? 'bn' : 'en';
  }

  Future<Map<String, dynamic>> build() async {
    final db = _read(databaseProvider);
    final currency = _read(defaultCurrencyProvider);
    final calc = FinancialCalculationService(
      db,
      _read(currencyServiceProvider),
    );
    final categories = <String, String>{
      for (final c in _read(cat.categoryProvider).categories) c.id: c.name,
    };

    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    final lastStart = DateTime(now.year, now.month - 1, 1);
    final lastEnd = DateTime(now.year, now.month, 0);

    double major(int cents) => cents / 100.0;

    final totals = await Future.wait([
      calc.getTotalIncomeConverted(
        startDate: monthStart,
        endDate: monthEnd,
        targetCurrency: currency,
      ),
      calc.getTotalExpensesConverted(
        startDate: monthStart,
        endDate: monthEnd,
        targetCurrency: currency,
      ),
      calc.getTotalIncomeConverted(
        startDate: lastStart,
        endDate: lastEnd,
        targetCurrency: currency,
      ),
      calc.getTotalExpensesConverted(
        startDate: lastStart,
        endDate: lastEnd,
        targetCurrency: currency,
      ),
    ]);

    final thisMonthByCategory = await calc
        .getSpendingByCategoryConvertedBetween(monthStart, monthEnd, currency);
    final lastMonthByCategory = await calc
        .getSpendingByCategoryConvertedBetween(lastStart, lastEnd, currency);

    final topCategories = thisMonthByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final includeCards = _read(creditCardsInNetWorthProvider);
    final netWorth = await calc.getTotalBalanceConverted(
      currency,
      includeCreditCards: includeCards,
    );

    return {
      'currency': currency,
      'language': languageOf(_read),
      'today': _date(now),
      'this_month': {'income': major(totals[0]), 'expense': major(totals[1])},
      'last_month': {'income': major(totals[2]), 'expense': major(totals[3])},
      'top_categories': [
        for (final e in topCategories.take(_topCategories))
          {
            'name': categories[e.key] ?? 'Other',
            'amount': major(e.value),
            'last_month': major(lastMonthByCategory[e.key] ?? 0),
          },
      ],
      'budgets': await _budgets(calc, currency),
      'goals': await _goals(currency, calc),
      'upcoming': await _upcoming(calc, currency),
      'wallets': await _wallets(calc, currency, includeCards),
      'net_worth': {
        'total': major(netWorth),
        'includes_credit_cards': includeCards,
      },
      'loans': await _loans(calc, currency),
      'recurring': await _recurring(calc, currency),
      'history': await _history(calc, currency, now),
      'recent': await _recentTransactions(calc, currency, categories),
    };
  }

  /// Earned and spent in each of the last few whole months, oldest first.
  ///
  /// One month is a poor guide to what is normal: a bonus or a hospital bill
  /// swings it. Several let the coach say what a usual month looks like.
  Future<List<Map<String, dynamic>>> _history(
    FinancialCalculationService calc,
    String currency,
    DateTime now,
  ) async {
    final months = <Map<String, dynamic>>[];
    for (var back = _historyMonths; back >= 1; back--) {
      final start = DateTime(now.year, now.month - back, 1);
      final end = DateTime(now.year, now.month - back + 1, 0);
      final income = await calc.getTotalIncomeConverted(
        startDate: start,
        endDate: end,
        targetCurrency: currency,
      );
      final expense = await calc.getTotalExpensesConverted(
        startDate: start,
        endDate: end,
        targetCurrency: currency,
      );
      if (income == 0 && expense == 0) continue;
      months.add({
        'month': '${start.year}-${start.month.toString().padLeft(2, '0')}',
        'income': income / 100.0,
        'expense': expense / 100.0,
      });
    }
    return months;
  }

  /// Money lent or borrowed that has not been paid back in full.
  Future<List<Map<String, dynamic>>> _loans(
    FinancialCalculationService calc,
    String currency,
  ) async {
    final db = _read(databaseProvider);
    try {
      final open = (await db.getCreditDebtTransactions())
          .where((t) => TransactionPolicy.outstandingAmount(t) > 0)
          .take(15);
      return [
        for (final t in open)
          {
            'title': t.title.isEmpty ? 'Untitled' : t.title,
            'lent': t.specialType == TransactionSpecialType.credit,
            'amount':
                await calc.convertFromWallet(t.amount, t.walletId, currency) /
                100.0,
            'outstanding':
                await calc.convertFromWallet(
                  TransactionPolicy.outstandingAmount(t),
                  t.walletId,
                  currency,
                ) /
                100.0,
            'date': _date(t.date),
          },
      ];
    } catch (_) {
      return const [];
    }
  }

  /// Active subscriptions and repeating bills or income.
  Future<List<Map<String, dynamic>>> _recurring(
    FinancialCalculationService calc,
    String currency,
  ) async {
    try {
      final all = await RecurringService(
        database: _read(databaseProvider),
      ).getAllRecurringWithTransactions();
      final items = all
          .map(
            (r) => SubscriptionItem(
              config: r.config,
              baseTransaction: r.baseTransaction,
            ),
          )
          .where((i) => i.isActive)
          .take(20);
      return [
        for (final i in items)
          {
            'name': i.name,
            'amount':
                await calc.convertFromWallet(i.amount, i.walletId, currency) /
                100.0,
            'frequency': i.frequencyText.toLowerCase(),
            'next': _date(i.nextPayment),
            'is_income': i.isIncome,
            if (!i.isIncome)
              'monthly_cost':
                  await calc.convertFromWallet(
                    i.monthlyCost.round(),
                    i.walletId,
                    currency,
                  ) /
                  100.0,
          },
      ];
    } catch (_) {
      return const [];
    }
  }

  Future<List<Map<String, dynamic>>> _budgets(
    FinancialCalculationService calc,
    String currency,
  ) async {
    final db = _read(databaseProvider);
    try {
      final rows = await db.getActiveBudgets();
      final progress = await BudgetEngine(
        db,
      ).progressForAll(rows.map(BudgetView.fromRow).toList());
      final service = _read(currencyServiceProvider);
      final now = DateTime.now();

      return [
        for (final p in progress.take(15))
          {
            'name': p.budget.name,
            'limit': await _toMain(service, p.limit, p.currency, currency),
            'spent': await _toMain(service, p.spent, p.currency, currency),
            'days_left': p.window.end.difference(now).inDays.clamp(0, 366),
          },
      ];
    } catch (_) {
      return const [];
    }
  }

  Future<List<Map<String, dynamic>>> _goals(
    String currency,
    FinancialCalculationService calc,
  ) async {
    try {
      final goals = await _read(
        objectivesServiceProvider,
      ).getGoalsWithProgress();
      return [
        for (final g in goals.where((g) => !g.objective.isArchived).take(10))
          {
            'name': g.objective.name,
            'target':
                await calc.convertFromWallet(
                  g.objective.targetAmount,
                  g.objective.walletId,
                  currency,
                ) /
                100.0,
            'saved':
                await calc.convertFromWallet(
                  g.currentAmount,
                  g.objective.walletId,
                  currency,
                ) /
                100.0,
            if (g.objective.endDate != null)
              'deadline': _date(g.objective.endDate!),
          },
      ];
    } catch (_) {
      return const [];
    }
  }

  Future<List<Map<String, dynamic>>> _upcoming(
    FinancialCalculationService calc,
    String currency,
  ) async {
    final state = _read(upcomingProvider);
    final items = [
      for (final t in state.overdueTransactions) (t, true),
      for (final t in state.upcomingTransactions) (t, false),
    ];
    return [
      for (final (t, overdue) in items.take(15))
        {
          'title': t.title,
          'amount':
              await calc.convertFromWallet(t.amount, t.walletId, currency) /
              100.0,
          'due': _date(t.date),
          'overdue': overdue,
        },
    ];
  }

  /// Every open account with what kind it is, so a card's balance is read as
  /// what is owed rather than as money the user has.
  Future<List<Map<String, dynamic>>> _wallets(
    FinancialCalculationService calc,
    String currency,
    bool includeCards,
  ) async {
    final wallets = _read(walletProvider).wallets.where((w) => !w.isArchived);
    return [
      for (final w in wallets.take(12))
        {
          'name': w.currency == currency ? w.name : '${w.name} (${w.currency})',
          'balance':
              await calc.convertFromWallet(w.balance, w.id, currency) / 100.0,
          'type': _walletType(w.walletType),
          if (w.walletType == WalletType.creditCard && w.creditLimit != null)
            'credit_limit':
                await calc.convertFromWallet(w.creditLimit!, w.id, currency) /
                100.0,
          'in_net_worth': FinancialCalculationService.countsInNetWorth(
            w,
            includeCreditCards: includeCards,
          ),
        },
    ];
  }

  static String _walletType(WalletType type) => switch (type) {
    WalletType.cash => 'cash',
    WalletType.bankAccount => 'bank_account',
    WalletType.creditCard => 'credit_card',
    WalletType.subscription => 'subscription',
    WalletType.deposit => 'deposit',
    WalletType.investment => 'investment',
    WalletType.asset => 'asset',
  };

  Future<List<Map<String, dynamic>>> _recentTransactions(
    FinancialCalculationService calc,
    String currency,
    Map<String, String> categories,
  ) async {
    final db = _read(databaseProvider);
    final walletNames = {
      for (final w in _read(walletProvider).wallets) w.id: w.name,
    };
    final now = DateTime.now();
    final rows = await db.getTransactionsByDateRange(
      now.subtract(const Duration(days: _recentDays)),
      now,
    );
    final counted =
        rows
            .where(
              (t) =>
                  TransactionPolicy.countsAsExpense(t) ||
                  TransactionPolicy.countsAsIncome(t),
            )
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    return [
      for (final t in counted.take(_recent))
        {
          'date': _date(t.date),
          'title': t.title.isEmpty
              ? (categories[t.categoryId] ?? 'Untitled')
              : t.title,
          'category': categories[t.categoryId] ?? 'Uncategorised',
          'amount':
              await calc.convertFromWallet(t.amount, t.walletId, currency) /
              100.0,
          'is_income': t.isIncome,
          'wallet': ?walletNames[t.walletId],
        },
    ];
  }

  static Future<double> _toMain(
    CurrencyService service,
    int cents,
    String from,
    String to,
  ) async {
    if (from == to) return cents / 100.0;
    try {
      return await service.convert(cents / 100.0, from, to);
    } catch (_) {
      return cents / 100.0;
    }
  }

  static String _date(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }
}

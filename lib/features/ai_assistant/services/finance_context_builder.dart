import 'dart:ui' show PlatformDispatcher;

import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/providers/locale_provider.dart';
import 'package:the_accountant/core/services/currency_service.dart';
import 'package:the_accountant/core/services/financial_calculation_service.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/budgets/domain/budget_engine.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart'
    show BudgetView;
import 'package:the_accountant/features/categories/providers/category_provider.dart'
    as cat;
import 'package:the_accountant/features/objectives/providers/objectives_provider.dart';
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
  static const _recent = 30;
  static const _recentDays = 45;

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
      'wallets': await _wallets(calc, currency),
      'recent': await _recentTransactions(calc, currency, categories),
    };
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

  Future<List<Map<String, dynamic>>> _wallets(
    FinancialCalculationService calc,
    String currency,
  ) async {
    final wallets = _read(walletProvider).wallets.where((w) => !w.isArchived);
    return [
      for (final w in wallets.take(12))
        {
          'name': w.currency == currency ? w.name : '${w.name} (${w.currency})',
          'balance':
              await calc.convertFromWallet(w.balance, w.id, currency) / 100.0,
        },
    ];
  }

  Future<List<Map<String, dynamic>>> _recentTransactions(
    FinancialCalculationService calc,
    String currency,
    Map<String, String> categories,
  ) async {
    final db = _read(databaseProvider);
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

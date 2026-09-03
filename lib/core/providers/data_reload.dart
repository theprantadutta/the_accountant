import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/credit_debt/providers/credit_debt_provider.dart';
import 'package:the_accountant/features/dashboard/providers/financial_data_provider.dart';
import 'package:the_accountant/features/objectives/providers/objectives_provider.dart';
import 'package:the_accountant/features/reports/providers/reports_provider.dart';
import 'package:the_accountant/features/subscriptions/providers/subscription_dashboard_provider.dart';
import 'package:the_accountant/features/transactions/providers/payment_method_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/transactions/providers/upcoming_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';

/// Throw away every cached view of the database and read it again.
///
/// The notifiers hold their rows in memory, so anything that replaces the store
/// underneath them — restoring a backup, restoring from the cloud, importing a
/// statement — leaves the screens showing records that no longer exist. Before
/// this, the only way to see the truth after a restore was to kill the app,
/// which is a poor thing to have to discover on your own.
///
/// Invalidating rather than reloading is deliberate: a notifier rebuilt from
/// scratch cannot carry a half-updated field across, and every one of these
/// loads its data on construction.
void reloadAllData(WidgetRef ref) {
  ref.invalidate(walletProvider);
  ref.invalidate(categoryProvider);
  ref.invalidate(transactionProvider);
  ref.invalidate(budgetProvider);
  ref.invalidate(allObjectivesProvider);
  ref.invalidate(activeObjectivesProvider);
  ref.invalidate(pinnedObjectivesProvider);
  ref.invalidate(paymentMethodProvider);
  ref.invalidate(upcomingProvider);
  ref.invalidate(creditDebtProvider);
  ref.invalidate(subscriptionDashboardProvider);
  ref.invalidate(reportsProvider);
  // Last, because it reads through the others.
  ref.invalidate(financialDataProvider);
}

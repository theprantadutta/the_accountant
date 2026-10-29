import 'package:drift/drift.dart';
import 'package:the_accountant/data/models/category.dart';
import 'package:the_accountant/data/models/wallet.dart';

/// What a plan is.
///
/// Stored by index, and the server holds the same numbers, so new kinds go on
/// the end.
enum PlanKind {
  /// Something bought and paid for in installments, from any account: a card,
  /// a bank account, or cash at a shop.
  emi,

  /// A Deposit Pension Scheme: a fixed amount saved every period for a fixed
  /// time, paid back with profit at the end.
  dps,

  /// A Fixed Deposit Receipt: one sum put away for a fixed time, with profit
  /// paid each month or at the end. Savings certificates work the same way.
  fdr,

  /// Money borrowed, received into an account, and repaid in installments.
  loan,

  /// An insurance policy: a premium every period, spent, and for a savings
  /// policy a sum paid back at the end.
  insurance,

  /// A bond or savings certificate (sanchayapatra): one sum held for a fixed
  /// time, with profit monthly, quarterly or at the end, usually taxed at
  /// source. It runs exactly like an FDR.
  bond,

  /// A systematic investment plan: a fixed sum into a fund or share every
  /// period, bought at its latest price.
  sip;

  /// FDR and bond: one sum put away, paid back at the end.
  bool get isFixedDeposit => this == fdr || this == bond;

  /// DPS, FDR and bond: money set aside in a deposit account of its own.
  bool get holdsMoney => this == dps || isFixedDeposit;
}

/// How often a plan's installments fall due.
enum PlanFrequency { weekly, monthly, yearly }

/// When an FDR or bond pays its profit.
enum PlanPayout { atMaturity, monthly, quarterly }

/// Whether a plan is still running.
enum PlanStatus { active, completed, closed }

/// EMIs, loans, DPS and FDR: money that moves on a schedule for a fixed term.
///
/// A plan holds the terms. What has actually been paid or received is
/// ordinary transactions carrying the plan's id and which installment they
/// were ([Transactions.planId], [Transactions.planInstallment]), so balances,
/// reports and sync treat them like anything else.
///
/// DPS and FDR money is not spent, it is set aside, so it moves by transfer
/// into a deposit account of its own ([holdingWalletId]); the total across
/// accounts stays right and the deposit's balance is what has been saved.
class Plans extends Table {
  TextColumn get id => text().customConstraint('UNIQUE NOT NULL')();

  IntColumn get kind => intEnum<PlanKind>()();
  TextColumn get name => text()();

  /// The account installments come out of, or that a loan or a matured
  /// deposit is paid into.
  TextColumn get walletId => text().references(Wallets, #id)();

  /// For DPS and FDR: the deposit account the money sits in.
  TextColumn get holdingWalletId => text().nullable()();

  /// For EMI and loan installments: what they are filed under.
  TextColumn get categoryId => text().nullable().references(Categories, #id)();

  /// Minor units. EMI: the price. Loan: the amount borrowed. FDR: the sum
  /// deposited. DPS: what the installments add up to.
  IntColumn get principal => integer().withDefault(const Constant(0))();

  /// Minor units, each installment. Zero for an FDR.
  IntColumn get installmentAmount => integer().withDefault(const Constant(0))();

  /// How many installments (EMI, DPS, loan), or for an FDR how many periods
  /// it runs for.
  IntColumn get installmentCount => integer().withDefault(const Constant(1))();

  IntColumn get frequency => intEnum<PlanFrequency>()();

  /// Every [interval] periods: 2 with [PlanFrequency.weekly] is fortnightly.
  IntColumn get interval => integer().withDefault(const Constant(1))();

  /// EMI, DPS, loan: when the first installment is due. FDR: when it opened.
  DateTimeColumn get startDate => dateTime()();

  /// Yearly rate, as a percentage. Informational for an EMI.
  RealColumn get interestRate => real().nullable()();

  /// DPS and FDR: what the bank pays back at the end, in minor units.
  IntColumn get maturityAmount => integer().nullable()();

  IntColumn get payout =>
      intEnum<PlanPayout>().withDefault(const Constant(0))();

  /// Record each installment, profit payment and the maturity by itself on
  /// the day it falls due.
  BoolColumn get autoCollect => boolean().withDefault(const Constant(true))();

  /// Days before each due date to remind; 0 is off.
  IntColumn get reminderDaysBefore =>
      integer().withDefault(const Constant(3))();

  IntColumn get status =>
      intEnum<PlanStatus>().withDefault(const Constant(0))();
  DateTimeColumn get closedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();

  /// The bank, insurer or issuer.
  TextColumn get provider => text().nullable()();

  /// Policy, account or certificate number.
  TextColumn get reference => text().nullable()();

  /// Percent of profit taken as tax at source (FDR, DPS, bond); the profit
  /// recorded is what is left.
  RealColumn get taxRate => real().nullable()();

  // Sync fields
  TextColumn get serverId => text().nullable()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

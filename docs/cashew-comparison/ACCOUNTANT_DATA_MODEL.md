# The Accountant: Data Model and Domain Logic

Analysed at version 3.0.0+21, schema **17**. Paths are relative to `the_accountant/` (Flutter) and `the-accountant-backend/src/` (backend) unless stated.

---

## 1. Drift schema (version 17) and migrations

Schema version: `lib/data/datasources/local/app_database.dart:163` (`schemaVersion => 17`). Registered tables: `app_database.dart:136-157`: Users, Categories, Wallets, Transactions, Budgets, Settings, UserProfiles, PaymentMethods, RecurringConfigs, Objectives, ObjectiveTransactions, AssociatedTitles, SyncStates, ExchangeRates, LocalStoreMetas, CategoryReconciliations, LocalIdRepairs.

All money columns are **integer minor units (cents)** since schema 11. All entity PKs are UUID text. Sync-tracked tables carry `serverId` (text, nullable; never observed being written), `syncStatus` int, `createdAt`, `updatedAt`, `deletedAt` (soft delete), except where noted.

### Enums

| Enum | Values | File |
|---|---|---|
| `TransactionType` (row provenance; text column `transaction_type`) | `regular('regular',0)`, `transfer('transfer',1)`, `recurringInstance('recurring_instance',2)` | `lib/data/models/transaction.dart:24-65` |
| `TransactionSpecialType` (intEnum, `special_type`) | `none=0, upcoming=1, subscription=2, repetitive=3, credit=4, debt=5` | `transaction.dart:70-87`; backend `TheAccountant.Domain/Enums/SpecialType.cs` identical |
| `WalletType` (intEnum) | `cash=0, bankAccount=1, creditCard=2, subscription=3` | `lib/data/models/wallet.dart:4-16`; backend `Enums/WalletType.cs` |
| `BudgetPeriod` (Dart enum exists but column is **text**) | `weekly, monthly, yearly, custom` | `lib/data/models/budget.dart:4`; backend `Enums/BudgetPeriod.cs` (int 0-3) |
| `ObjectiveType` (Dart enum exists but column is **text** `'goal'`/`'loan'`) | `goal, loan` | `lib/data/models/objective.dart:5-8`; backend `Enums/ObjectiveType.cs` |
| `RecurrenceType` (Dart enum exists but column is **text**) | `daily, weekly, monthly, yearly` | `lib/data/models/recurring_config.dart:4`; backend `Enums/Reoccurrence.cs` |
| `SyncStatus` (int constants) | `synced=0, pendingCreate=1, pendingUpdate=2, pendingDelete=3, conflict=4` | `app_database.dart:41-78` |
| PaymentMethod `type` (free text, not enum) | `'card','bank','cash','digital_wallet'` (comment only) | `lib/data/models/payment_method.dart:15-17` |

### Tables

**Transactions** (`lib/data/models/transaction.dart:90-207`). Indexes: unique `idx_transactions_occurrence_key` on `occurrenceKey`; `idx_transactions_paired` on `pairedTransactionId` (lines 90-96).
- `id` text PK; `amount` int (cents, always stored as magnitude); `title` text default ''; `notes` text?; `date` datetime
- `isIncome` bool default false (**the direction field**); `type` text default 'regular', deprecated (line 111-113; actually receives `'income'`/`'expense'` from RecurringService at `recurring_service.dart:170`)
- `transactionType` text default 'regular' (regular / transfer / recurring_instance)
- `categoryId` text? FK Categories; `walletId` text FK Wallets (NOT NULL); `paymentMethodId` text? FK PaymentMethods; `paymentMethod` text? deprecated
- `pairedTransactionId` text? (transfer partner); `feeForTransactionId` text? (soft link to transfer expense leg, deliberately not FK, lines 130-144, added v16)
- `recurringConfigId` text? FK RecurringConfigs; `occurrenceKey` text? = `<configId>@<UTC yyyy-MM-dd>` (lines 149-158, added v12)
- `budgetId` text? (not FK); `objectiveId` text? (not FK, source of truth for goal links since v12)
- `isRecurring` bool, `recurrencePattern` text?: both deprecated
- `receiptImageUrl` text?: **only ever written by sync pull** (`sync_service.dart:1186`); no local code sets it
- `specialType` intEnum nullable default 0
- `isPaid` bool default **true**; `originalDueDate` datetime?; `paidAmount` int default 0 (cents); `skipPaid` bool default false
- sync/timestamps as above

**Wallets** (`lib/data/models/wallet.dart:19-63`): `id`, `name`, `iconName` ('wallet'), `color` ('#6366F1'), `currency` ('USD'), `balance` int (stored/denormalized), `openingBalance` int (added v11), `isDefault` bool, `useDecimals` bool default true, `walletType` intEnum default 0, `creditLimit` int?, `billingCycleDay` int? (1-31), `orderIndex` int, sync fields, timestamps, `deletedAt`. **No** archived/hidden/excludeFromTotal columns.

**Categories** (`lib/data/models/category.dart:3-60`): unique index `idx_categories_default_key`. `id`, `name`, `iconName` ('category'), `color`, `mainCategoryId` text? (one-level subcategory, not FK), `isIncome` bool, `orderIndex`, `type` text? deprecated, `isDefault` bool, `defaultKey` text? (stable slug, added v13), sync, timestamps, `deletedAt`.

**Budgets** (`lib/data/models/budget.dart:7-55`): `id`, `name`, `amount` int (cents), `period` text default 'monthly', `startDate`, `endDate?`, `walletIds` text JSON array default '[]', `categoryIds` text JSON default '[]', `categoryId` text? (legacy single), `isIncome` bool, `isPinned`, `isArchived`, `limit` real? (legacy dollars), sync, timestamps, `deletedAt`.

**Objectives** (`lib/data/models/objective.dart:11-50`): `id`, `name`, `iconName` ('flag'), `color`, `targetAmount` int, `type` text ('goal'), `walletId` text? FK Wallets, `startDate`, `endDate?`, `isPinned`, `isArchived`, sync, timestamps, `deletedAt`.

**ObjectiveTransactions** (`lib/data/models/objective_transaction.dart:7-20`): `id`, `objectiveId` FK, `transactionId` FK, `createdAt`. **Legacy, never synced, nothing writes to it any more** (`app_database.dart:2392-2398`).

**RecurringConfigs** (`lib/data/models/recurring_config.dart:7-41`): `id`, `baseTransactionId` text (not FK), `periodLength` int default 1, `reoccurrence` text default 'monthly', `startDate`, `endDate?`, `nextOccurrence` datetime, `isActive` bool default true, sync fields, `createdAt`/`updatedAt`. **No `deletedAt`**; deletion = `isActive=false` + `pendingDelete` tombstone.

**PaymentMethods** (`lib/data/models/payment_method.dart:7-36`): `id`, `name`, `iconName` ('credit_card'), `type` text ('card'), `lastFourDigits?`, `institution?`, `isDefault`, sync, timestamps, `deletedAt`. Backend `PaymentMethod.cs` lacks `type`/`lastFourDigits`/`institution`; those three are **not synced** (`sync_service.dart:1767-1772`).

**AssociatedTitles** (`lib/data/models/associated_title.dart:6-31`): `id`, `title`, `categoryId` FK, `isExactMatch` bool, sync fields (vestigial), timestamps. Device-local (`app_database.dart:2927-2930`).

**ExchangeRates** (`lib/data/models/exchange_rate.dart:5-35`): `id`, `fromCurrency`, `toCurrency`, `apiRate` real?, `customRate` real?, `useCustomRate` bool, `apiRateFetchedAt?`, sync fields (vestigial), timestamps. Device-local. Note id is `millisecondsSinceEpoch.toString()`, not UUID (`app_database.dart:2728`).

**SyncStates** (`lib/data/models/sync_state.dart:5-23`): autoincrement `id`, `syncTableName`, `lastSyncAt?`, `lastServerVersion` int, `pendingChanges` text JSON '[]', `updatedAt`. A `'_global'` row stores the pull cursor (`app_database.dart:2791-2820`).

**Settings** (`lib/data/models/settings.dart:3-28`): single row `id`=1, `themeMode` 'dark', `currency` 'USD', `notificationsEnabled`, `budgetNotificationsEnabled`, `budgetWarningThreshold` real 80.0, `dateFormat` 'MM/dd/yyyy', `numberFormat` 'comma_dot', `biometricLockEnabled`, `autoLockTimeoutMinutes`.

**Users** (`user.dart`): `id`, `fullName?`, `email` unique, `createdAt`, `isPremium`. **UserProfiles** (`user_profile.dart`): `userId` PK, `fullName?`, `email` unique, `phoneNumber?`, `profileImageUrl?`, `createdAt`, `updatedAt`, `isPremium`.

**LocalStoreMetas** (`local_store_meta.dart:17-34`): single row binding the DB file to `ownerUserId`/`ownerEmail`/`claimedAt`. **CategoryReconciliations** (`category_reconciliation.dart:22-51`): PK `defaultKey`, `provisionalCategoryId`, `catalogName`, `catalogIsIncome`, `candidatesJson`, `resolutionKind?`, `resolutionCandidateId?`, `detectedAt`, `resolvedAt?`; device-local pending server question. **LocalIdRepairs** (`local_id_repair.dart:22-43`): autoincrement, `entityTable`, `oldId`, `newId?`, `status` ('applied'/'blocked'), `detail?`, `settledAt?`, `createdAt`.

`SupportTicket` (`lib/data/models/support_ticket.dart`) is an Equatable class, not a Drift table.

### Migration history (`app_database.dart:186-279` and helpers)

- **<10** (`:187-217`): fix credit/debt direction (`special_type=5 → is_income=1`, `=4 → is_income=0`), recompute every wallet balance with rule `is_paid=1 OR special_type IN (4,5)`.
- **<11** (`:219-255`): REAL dollars → INTEGER cents on wallets.balance/credit_limit, transactions.amount/paid_amount, budgets.amount, objectives.target_amount; add `wallets.opening_balance`; backfill `opening_balance = balance − Σ(realized effects)`.
- **12** (`:318-412`): add `occurrence_key`; system categories `transfer-category-0`/`balance-correction-0` re-keyed to fixed UUIDs; all synced categories flipped to `pendingCreate`; `objective_transactions` backfilled onto `transactions.objective_id`; dedupe recurring instances per (config, UTC day), backfill keys, create unique index + paired index.
- **13** (`:434-441`, data at `:753-902`): add `categories.default_key`; retire fixed system UUIDs (re-key only `pendingCreate` rows); backfill slugs on `is_default` rows by name+direction; merge duplicate defaults; normalise `transaction_type` spelling; unique index on `default_key`.
- **14** (`:523-532`): create `category_reconciliations`; `pruneDeadBudgetReferences()` (`:1848-1897`).
- **15** (`:545-554`): create `local_id_repairs`; `rekeyUnsyncedNonUuidWallets()` (`:631-705`) replaces onboarding's epoch-millis wallet ids (only `pendingCreate` rows; others logged `blocked`).
- **16** (`:560-562`): add `transactions.fee_for_transaction_id`.
- **17** (`:576-603`): rename built-ins still carrying `legacyName` (the two "Loan" categories → "Money Lent"/"Money Borrowed" etc.).
- `beforeOpen` (`:280-294`): FK enforcement deliberately OFF; ensures LocalStoreMeta row; installs triggers `trg_<table>_keep_pending_create` on 7 synced tables that revert `pendingCreate→pendingUpdate` writes (`:906-946`).

---

## 2. Transaction model details

**Direction**: `isIncome` only; `amount` stored as magnitude, sign applied by `TransactionPolicy.walletBalanceEffect` (`lib/core/domain/transaction_policy.dart:116-119`).

**The policy** (`transaction_policy.dart`) is the single eligibility source:

```dart
static bool affectsWalletBalance(Transaction t) {
  if (!isLive(t)) return false;
  return t.isPaid || isCreditOrDebt(t);           // :107-110
}
static bool isSettled(Transaction t) { if (t.amount <= 0) return true; return t.paidAmount >= t.amount; }  // :135-138
static bool countsInAnalytics(t) => affectsWalletBalance(t) && !isTransfer(t);   // :180-181
static bool isForecast(t) => isLive(t) && !t.isPaid && !t.skipPaid && isUpcoming(t);   // :240-241
```

**isPaid semantics per special type** (`add_transaction_screen.dart:594,633` via `startsUnpaid` at `lib/features/transactions/widgets/special_type_selector.dart:87-89`; `transaction_provider.dart:301-306, 472-478`):
- `none`, `subscription`, `repetitive`: forced `isPaid=true` always.
- `upcoming`: starts `isPaid=false` (only type with `startsUnpaid`); `isPaid` = "has happened".
- `credit`/`debt`: `isPaid` stays true (cash moved); settlement is `paidAmount >= amount`. Direction is forced: credit → `isIncome=false`, debt → `isIncome=true` (`add_transaction_screen.dart:639-645`).
- `requiresDueDate` = upcoming/credit/debt → `originalDueDate = selectedDateTime` (`special_type_selector.dart:79-83`; `add_transaction_screen.dart:663-665`).

**Marking paid/unpaid** (`app_database.dart:1261-1304`): `markTransactionAsPaid` sets `isPaid=true`, preserves `originalDueDate ?? date`, sets `date = paymentDate ?? now`. `markTransactionAsUnpaid` restores `date = originalDueDate ?? date`. `UpcomingNotifier.markAsPaid/markAsUnpaid` (`lib/features/transactions/providers/upcoming_provider.dart:82-130`) applies the **incremental** delta via `updateBalanceAfterTransaction`.

**Skip** (`app_database.dart:1283-1288`): `skipTransaction` sets `skip_paid`, sync-aware. Excluded from upcoming/overdue queries and `isForecast`. Skip exists only for individual rows; there is no "skip next occurrence" on a RecurringConfig.

**Upcoming/overdue** (`app_database.dart:1188-1205`): `getUpcomingTransactions` = `isPaid=false AND skipPaid=false AND date > now`; `getOverdueTransactions` = same with `date < now`. Note these don't filter on `specialType`, whereas `TransactionPolicy.isForecast` requires `specialType==upcoming`.

**Wallet-balance effect on create** (`transaction_provider.dart:332-348`): `shouldUpdateBalance = credit || debt || effectiveIsPaid` → incremental `updateBalanceAfterTransaction`. Update (`:520-530`) and delete (`:661-671`) use full `updateWalletBalance` recompute on old+new wallets.

**Editing instance vs series**: There is no series edit. A recurring instance is an independent row (`recurringConfigId` set). The base transaction is the template; `getRecurringConfigByBaseTransactionId` links base→config (`recurring_service.dart:379-387`, linear scan of all configs). Editing the base's schedule fields goes through `_reconcileRecurringConfig` (`add_transaction_screen.dart:709-739`). Editing the base's amount/title does affect *future* instances (they copy from base at generation time, `recurring_service.dart:163-184`) but not existing ones.

**Transfers** (`lib/features/transactions/services/transfer_service.dart`): two rows with `transactionType='transfer'`, reciprocal `pairedTransactionId`, equal `amount`, opposite `isIncome`, both `isPaid=true`, category = system `transfer` slug (`:229-258, 365-395`). Optional fee = third `regular` expense row filed under `fees_charges` with `feeForTransactionId = expenseLegId` (`:262-273, 325-359`). Cross-currency transfers are **refused** (`:294-316`). Update/delete act on both legs + fee in one DB transaction and recompute wallets (`:402-570`). `TransferIntegrity.validatePair` (`:48-145`) and `reconcileTransferPairs` (delete wins, `:636-660`) exist. Generic `updateTransaction`/`deleteTransaction` delegate to TransferService if the row is a transfer (`transaction_provider.dart:446-455, 648-655`).

**Attachments/receipts**: `receiptImageUrl` column exists but nothing writes it locally. OCR (`lib/features/ai/services/ocr_service.dart:314-330`) returns `ReceiptData{merchant, date?, total, items[], barcodeInfo?, imageLabels?}` and only prefills the form (`add_transaction_screen.dart:208-220`).

**Tags, location, per-transaction currency, contact/person**: **not present** in any table (grep of `lib/data/models` for tag/location/contact/person/payee/interest returned nothing). Currency is per-wallet only.

**Budget/objective assignment**: `budgetId`, `objectiveId` on the row, selectable in the add screen (`add_transaction_screen.dart:817-829`).

---

## 3. Credit/Debt (loan) model

Lending/borrowing is a **transaction row** with `specialType=credit` (lent, `isIncome=false`) or `debt` (borrowed, `isIncome=true`). No separate loan table, no contact/person field, no interest, no instalment schedule.

- **Balance**: affects wallet immediately at creation regardless of `isPaid` (`transaction_policy.dart:107-110`; `transaction_provider.dart:335-338`).
- **Repayment** (`lib/features/credit_debt/providers/credit_debt_provider.dart`): `recordPayment(transactionId, paymentAmount)` (`:194-260`) clamps to outstanding, inserts a **separate regular transaction** (`specialType=none`, `isPaid=true`, direction = `isCredit` → income; copies parent's wallet/category/paymentMethod/objective; title `"Received: <title>"`/`"Paid: <title>"`, `:268-295`), then increments parent `paidAmount`. **There is no FK/link from the repayment row back to the loan**; only `notes` text "Partial payment for credit: ..." (`:228-229`).
- `markAsSettled` (`:135-185`) = repayment row for the remainder + `paidAmount = amount`. `markAsPending` (`:303-341`) inserts a single compensating reversal row and zeroes `paidAmount`. `isPaid` is never touched by any of these.
- **Settlement/overdue** derive from `TransactionPolicy.isSettled/outstandingAmount/isOverdue` (`transaction_policy.dart:135-171`); due = `originalDueDate ?? date`.
- **Reminders**: one-off WorkManager task via `ReminderSchedulerService` (`lib/core/services/reminder_scheduler_service.dart:13-55`) on create/update; periodic task also notifies up to 3 overdue loans (`background_task_service.dart:121-155`). Cancelled on settle.
- **Exposure**: `CreditDebtState.unpaidCredit/unpaidDebt/netBalance` sum `outstandingAmount` (`credit_debt_provider.dart:53-67`).
- **Long-term loan objective**: `Objectives.type='loan'` exists (`objective.dart:7`) and is computed identically to a goal; no interest, no schedule, no link to credit/debt transactions except a transaction's `objectiveId`.
- `getUnpaidCreditDebtTransactions` (`app_database.dart:1239-1248`) filters on `isPaid=false`, which contradicts the settled-by-paidAmount policy (unused by provider; provider uses `getCreditTransactions/getDebtTransactions`).

---

## 4. Objectives / goals

Service `lib/features/objectives/services/objectives_service.dart`; providers `.../providers/objectives_provider.dart`.
- Types: `'goal'` and `'loan'` text (`objective.dart:24`). Optional `walletId`, `startDate`, nullable `endDate` (made nullable on backend too, `Objective.cs:17-26`), `isPinned`, `isArchived`, `iconName`, `color`.
- Linking: `transactions.objectiveId` (`app_database.dart:2399-2453` link/unlink/unlinkAll, all sync-aware). Deletion detaches all transactions then tombstones (`objectives_service.dart:100-118`).
- **Progress** = `Σ amount` of all live linked transactions, **irrespective of `isIncome`, `isPaid`, or transfer type** (`app_database.dart:2408-2410`). Percent clamped 0-100 (`objectives_service.dart:193-195`), `dailyTarget = remaining/daysRemaining`, `projectedCompletionDays = remaining / (current/daysSinceStart)` (`:198-236`).
- Free tier: `maxActiveObjectives = 2` (`lib/data/models/premium_features.dart:96`).
- **No objectives screen exists**: `lib/features/objectives/` has only `providers/` and `services/`; the only UI reference outside that folder is the objective picker in `add_transaction_screen.dart:817-829`. No code path outside the service calls `createObjective`.

---

## 5. Wallets

Columns listed in §1. `balance` is **stored/denormalized**; `openingBalance` is the seed. `addWallet` sets both `balance` and `openingBalance` to the initial value (`lib/features/wallets/providers/wallet_provider.dart:166-169`).

**WalletBalanceService** (`lib/core/services/wallet_balance_service.dart`):
- `calculateWalletBalance` (`:14-29`) = `openingBalance + Σ TransactionPolicy.walletBalanceEffect(t)` over live transactions of that wallet, i.e. counts rows where `isPaid || credit || debt`; transfers count on both legs; unpaid upcoming excluded; skipped rows only excluded if also unpaid.
- `updateBalanceAfterTransaction` (`:47-78`) = blind ± delta on stored balance (no policy check; callers decide; used by `addTransactionFull` and Upcoming mark paid/unpaid).
- `updateWalletBalance` (`:40-43`) = full recompute, marks wallet pending via `markEditedSql` (`app_database.dart:2218-2228`).
- `recalculateAllWalletBalancesLocal` (`:96-103`) = recompute **without** touching `syncStatus`; run after every pull (`sync_service.dart:277-289`) because server `Balance` is a last-write-wins scalar that is not trusted.
- Credit card: `creditLimit`/`billingCycleDay` are display-only (`lib/features/dashboard/widgets/wallet_cards_section.dart:153-159`: outstanding = |balance|, available = limit − outstanding). No billing-cycle logic.
- Default wallet: `isDefault` column plus a SharedPreferences override (`wallet_provider.dart:321-341`).
- Delete cascades soft-delete of all its transactions and prunes budget `walletIds` (`wallet_provider.dart:254-266`; `app_database.dart:2183-2208`).
- Free tier `maxWallets = 3` (`premium_features.dart:93`).

**Currency / net worth**: `FinancialCalculationService.getTotalBalance` sums stored balances (`lib/core/services/financial_calculation_service.dart:72-79`); `getTotalBalanceConverted` converts each wallet via `CurrencyService.convert` (`:83-111`). Rates from fawazahmed0 currency-api (`lib/core/services/currency_service.dart:13-18`), cached in SharedPreferences and `exchange_rates` table (USD-base only, `:297-320`); custom overrides via `useCustomRate`. There is no "net worth" concept beyond total balance; loans are not netted.

---

## 6. Budgets

Columns in §1. Backend stores `WalletIds`/`CategoryIds` as `jsonb` (`Configurations/BudgetConfiguration.cs:25-28`).

- **UI only offers weekly/monthly** with hard-coded 7/30-day end dates (`lib/features/budgets/screens/add_budget_screen.dart:61-65, 208-236`; constants `lib/core/constants/app_constants.dart:34-35`). `yearly`/`custom` exist in the enum only.
- `BudgetNotifier.addBudget` (`lib/features/budgets/providers/budget_provider.dart:113-165`) writes **legacy `limit` (dollars) and single `categoryId`**, never `amount`, `categoryIds`, `walletIds`, `isIncome`, `isPinned`. `loadBudgets` filters out budgets with null `endDate` (`:80-82`).
- **Computation** (`financial_calculation_service.dart:299-395`): for each `getActiveBudgets()` row, transactions in `[startDate, endDate ?? now]`, filtered by `TransactionPolicy.countsTowardBudget(t, budgetIsIncome, categoryFamilyIds(categoryId))` (`transaction_policy.dart:215-229`; family = category + direct children, `app_database.dart:2465-2475`). Only the legacy `categoryId` is consulted here; `categoryIds`/`walletIds` arrays are **not** used for computation anywhere found.
- **Alerts**: `BudgetNotificationNotifier` hourly timer (`lib/features/budgets/providers/budget_notification_provider.dart:32-34`) compares `spent/limit*100 >= budgetWarningThreshold` using its own filter (`type=='expense'`, exact `categoryId`, dollars vs `limit`); it does **not** use TransactionPolicy and sums cents against a dollar limit (`:52-70`).
- No rollover, no per-period history, no wallet scoping in computation. Reference hygiene helpers: `pruneCategoryFromBudgets`, `pruneWalletFromBudgets`, `repointBudgetsToCategory`, `pruneDeadBudgetReferences` (`app_database.dart:1761-1897`).
- Free tier `maxActiveBudgets = 3`.

---

## 7. Categories

- Flat list with **one-level subcategories** via `mainCategoryId` (`category.dart:20`; `add_category_form.dart:376-387` prevents a parent from becoming a child). `isIncome` is retained but the UI treats categories as one list regardless of direction (`category_provider.dart:287-292`; `default_categories.dart:43-49`).
- Defaults: `DefaultCategoryCatalog` (`lib/core/domain/default_categories.dart:105-379`): 18 expense slugs (`food_dining … fees_charges`), 11 income slugs (`salary … other_income`), 2 system (`transfer`, `balance_correction`). Seeded per-slug, `pendingCreate`, random UUIDs (`app_database.dart:1476-1504`). Cross-device identity is `defaultKey`; server enforces unique `(user_id, default_key)` (`CategoryConfiguration.cs:48-50`).
- Default categories cannot be deleted (`category_provider.dart:269-271`). Soft-delete prunes budgets (`app_database.dart:1410-1421`).
- **Merge**: only automatic; duplicate built-ins by slug (`mergeDuplicateDefaultCategories`, `app_database.dart:1571-1602`; `_absorbCategory` re-points transactions, subcategories, budgets, associated titles `:2097-2136`). No user-facing merge. **No reorder UI** (`orderIndex` exists; grep found no reorder code in category screens).
- **Auto-categorization**: (a) `CategoryAssignmentService` keyword map keyed by category *name* (`lib/features/ai/services/category_assignment_service.dart:5+`), used by the legacy `addTransaction` path which then stores the **name as `categoryId`** (`transaction_provider.dart:227-234`, a bug); (b) `searchTitleUsages` suggests past titles + last category (`app_database.dart:2490-2543`); (c) `AssociatedTitles` table with exact/contains matching (`:2562-2578`).
- Free tier `maxCustomCategories = 10`.

---

## 8. Recurring / subscription engine

**Storage**: one `RecurringConfig` per base transaction; `reoccurrence` text ∈ daily/weekly/monthly/yearly, `periodLength` interval, `startDate`, `endDate?`, `nextOccurrence` cursor, `isActive`. **No occurrence count**, no weekday/day-of-month selection.

**Creation**: `add_transaction_screen.dart:671-684`: when `specialType` is subscription or repetitive, after `addTransactionFull` it calls `RecurringService.createRecurringConfig(baseTransactionId, reoccurrence, periodLength, startDate=selectedDateTime, endDate)`; `nextOccurrence = calculateNextOccurrence(startDate)` (`recurring_service.dart:263-307`). The base transaction itself is a paid, realized row (so a subscription's first payment is the base).

**Materialization**: `RecurringService.processRecurringTransactions` (`lib/features/recurring/services/recurring_service.dart:27-140`):

```dart
final dueConfigs = await _database.getDueRecurringConfigs();   // isActive && nextOccurrence <= now  (app_database.dart:2297-2303)
while (nextOccurrence.isBefore(now) || isAtSameMomentAs(now)) {
  final following = calculateNextOccurrence(scheduled, config.reoccurrence, config.periodLength);
  final endsHere = config.endDate != null && following.isAfter(config.endDate!);
  await _database.transaction(() async {
    inserted = await _createTransactionInstance(base, config, scheduled, existingKeys);  // insertOrIgnore on occurrenceKey
    await _database.updateNextOccurrence(config.id, following, !endsHere);
  });
  if (endsHere) break;
}
```

Instance copies amount/title/notes/isIncome/category/wallet/paymentMethod/specialType/budgetId/objectiveId from base, sets `transactionType='recurring_instance'`, `isPaid=true`, `occurrenceKey`, `pendingCreate` (`:163-184`), then full wallet recompute (`:201-203`). Month arithmetic clamps to month end (`:242-260`); yearly uses `DateTime(y+n, m, d)` without Feb-29 clamping (`:226-233`).

**When it runs**: (1) app startup `BackgroundTaskService.runStartupProcessing(db)` from `lib/core/providers/account_store_provider.dart:210`; (2) WorkManager periodic task every 1 hour (`lib/main.dart:105-112`) → `executePeriodicProcessing` (`lib/core/services/background_task_service.dart:37-221`), which also fires notifications for upcoming items due within the offset window, overdue loans, and configs due within the window; (3) manual `RecurringNotifier.processRecurring` (`recurring_provider.dart:43-51`). Not on mark-paid.

**Pause/resume/cancel**: `updateRecurringConfig(isActive:)` (`recurring_service.dart:400-444`; cadence change recomputes `nextOccurrence` from `startDate`, not from last instance); `deleteRecurringConfig` = `isActive=false` + `pendingDelete` tombstone (`:457-477`). Dashboard aggregation in `lib/features/subscriptions/providers/subscription_dashboard_provider.dart` (monthly normalisation `:77-91`, weekly×4.33).

**Skip**: only per generated row (`skipTransaction`); instances are already `isPaid=true` so skip has no balance effect on them.

**Idempotency across devices**: unique local index on `occurrence_key`; backend unique `(user_id, occurrence_key)` (`TransactionConfiguration.cs:100-103`); push returns Applied without insert on duplicate key (`PushChangesCommandHandler.cs:841-846`); pull replaces a local duplicate with the server row (`sync_service.dart:1203-1217`).

---

## 9. Sync / backend

**What syncs** (both ends, `SyncEntityOrder.applyOrder`: `lib/core/services/sync/sync_models.dart:19-27`; `SyncDtos.cs:65-79`): wallets, categories, payment_methods, budgets, objectives, transactions, recurring_configs. **Local-only**: exchange_rates, associated_titles (`app_database.dart:2927-2930`), objective_transactions, settings, sync_states, local_store_metas, category_reconciliations, local_id_repairs, plus PaymentMethod `type/lastFourDigits/institution` and Wallet `useDecimals` (not in `_walletToMap`, `sync_service.dart:1710-1723`).

**Transport**: `POST /sync/push`, `GET /sync/pull?since=` (`lib/core/services/sync/sync_transport.dart:54-72`). Premium-gated (`sync_service.dart:219-225`). Store ownership asserted before any sync (`:251-255`).

**Client push** (`sync_service.dart:493-596`): collect rows with `syncStatus>0` per table, operation from status (`:1565-1575`), flatten in dependency order, chunk. Holds back provisional categories under an open reconciliation and everything referencing them (`:898-1006`). On response: accepted creates/updates are marked synced with **compare-and-set on `updatedAt`** (`:1819-1920`); accepted deletes hard-delete the local tombstone only if still `pendingDelete` (`:1922-1970`); recurring config tombstones just clear the flag. Conflicted rows stay pending.

**Client pull** (`:264-332`): apply in server-provided `entity_order`, upserts first, deletes reverse (`sync_models.dart:305-337`); each record checked for missing live parent first (`:655+`); pulled rows written with `syncStatus=synced` and local `updatedAt=now`; on any apply failure the cursor is **not advanced**; otherwise cursor = server `ServerTime`. After a clean pull: recompute balances locally, `reconcileTransferPairs`, merge duplicate defaults, seed missing built-ins.

**Backend push** (`TheAccountant.Application/Features/Sync/Commands/PushChanges/PushChangesCommandHandler.cs`): single DB transaction (`:138`), 6 phases (`:167-214`): independents → transactions (RecurringConfigId and PairedTransactionId deferred) → recurring configs → backfill RecurringConfigId → link/validate transfer pairs → validate fee links. `ApplyResiliently` (`:622-689`) retries a failed phase record-by-record so one bad row becomes a per-record conflict.
- **Concurrency/conflict resolution**: last-write-wins by timestamp: `if (entity.UpdatedAt > data.UpdatedAt) return StaleConflict` on every update (`:907, 1056, 1167, 1460, 1666, 1734, 1815`); conflict code `stale_version`. No version counters on entities; only `Wallet` has an `xmin` row version (`AppDbContext.cs:79-85`), and `SaveWithConcurrencyRetry` is a plain 3× retry (`:701-720`). `UpdatedAt` stamped server-side on modified entities (`AppDbContext.cs:143-154`).
- Create is idempotent on id (`existing → Applied`). Reference validation requires parents live and owned by caller (`:731-769`). Wallet balance is client-authoritative; server never derives it (`:805-808, 893-895`).
- Soft deletes: `DeletedAt` on SoftDeletableEntity; RecurringConfig delete = `IsActive=false` (`:1767-1777`). Transaction delete cascades to paired leg and fees (`:979-1006`).
- Category creates with `DefaultKey`: duplicate slug → `duplicate_default_category`; pre-slug name+direction matches → `legacy_category_reconciliation_required` with candidates, resolved by user via `adopt_legacy_category`/`create_separate_category` (`:1076-1407`; client side `sync_service.dart:787-896`, table `category_reconciliations`).
- **Pull** (`Queries/PullChanges/PullChangesQueryHandler.cs`): `UpdatedAt > since` per table; op = delete if `DeletedAt`, create if `CreatedAt > since`, else update; returns `ServerTime` and `EntityOrder`. Recurring configs never emit "delete" (`:214-231`).
- Backend indexes: unique `(user_id, default_key)` filtered, unique `(user_id, occurrence_key)` filtered, unique `fee_for_transaction_id` filtered on live rows, 1:1 `PairedTransactionId` FK SetNull (`TransactionConfiguration.cs:56-103`).

**Backup/restore**: cloud restore = full pull, `clearAllData(reseedSystemCategories:false)`, apply all-or-nothing in one transaction, recompute balances (`sync_service.dart:106-215`; UI `sync_settings_screen.dart:318-370`). Local export: CSV (free) and PDF (premium) via share sheet (`lib/features/settings/screens/export_screen.dart:28, 537-656`; also `TransactionNotifier.exportToCSV/generatePDFReport`, `transaction_provider.dart:752-1033`). **No JSON backup, no import.**

---

## 10. Other domain concepts

- **Payment methods**: table + provider (`lib/features/transactions/providers/payment_method_provider.dart`), free-tier max 5.
- **Smart categorisation**: keyword service, title-usage search, AssociatedTitles (see §7).
- **Receipt OCR** (premium): `ReceiptData` prefill only; `ReceiptItem{name, price}`; no line items persisted.
- **AI**: `monthly_summary_service.dart` (category breakdown), `ai_assistant` chat models; none persist to Drift.
- **Notifications**: settings `budgetWarningThreshold`; WorkManager reminders keyed `due_reminder_<txId>`; channels for upcoming/loan/recurring. Backend `NotificationType` enum includes DailyReminder, BudgetWarning, BudgetExceeded, LargeTransaction, RecurringReminder, SubscriptionExpiringSoon/Expired, Promotional, Custom (`Enums/NotificationType.cs`).
- **Premium gating**: `FreeTierLimits` (`premium_features.dart:93-97`), sync/restore/PDF/OCR premium.
- **Multi-account local stores**: per-account DB file selected via `LocalStoreManager`; `LocalStoreMetas` claims ownership (`app_database.dart:565-627`).

---

## Gaps / oddities (factual, from code)

1. **No dedicated Objectives UI**: service/providers exist; only entry point is the picker in add-transaction. `type='loan'` objectives are indistinguishable from goals in logic.
2. **Objective progress sums raw `amount` regardless of direction/paid/transfer** (`app_database.dart:2408-2410`).
3. **Budgets**: UI writes only legacy `limit` (dollars) + single `categoryId`, never `amount`/`categoryIds`/`walletIds`/`isIncome`; computation reads `amount` and legacy `categoryId`. `amount` is a required int column with no default (`budget.dart:13-14`) and `addBudget` omits it. `budget_notification_provider.dart:52-70` sums cents against a dollar `limit` and bypasses `TransactionPolicy`. Only weekly/monthly reachable; no rollover, no period history.
4. **Loan repayments have no structural link to the loan** (only a notes string); `getUnpaidCreditDebtTransactions` still filters on `isPaid=false`, contradicting the settlement policy.
5. **No contact/person, interest, instalments, tags, location, attachments actually written, per-transaction currency.** `receiptImageUrl` is write-only from sync.
6. **Wallet balance denormalized** (`balance`) with two update paths (blind delta vs. full recompute); server value is discarded on pull. No archived/hidden/exclude-from-total flags. Credit-card fields are display-only.
7. **Cross-currency transfers refused**; no exchange-rate-at-transaction recording.
8. **Recurring**: no occurrence count, no day-of-week/month rule, `calculateNextOccurrence` yearly does not clamp Feb 29; changing cadence resets `nextOccurrence` from `startDate`; base→config lookup is O(n) (`recurring_service.dart:379-387`); `baseTransactionId` is not a FK and RecurringConfig has no `deletedAt`.
9. **`upcoming` queries vs. policy diverge**: DB queries use `isPaid/skipPaid/date` only; `TransactionPolicy.isForecast` also requires `specialType==upcoming`.
10. **Legacy `addTransaction` path** stores a category *name* in `categoryId` when the keyword service matches (`transaction_provider.dart:232-233`).
11. **PaymentMethod `type/lastFourDigits/institution` and Wallet `useDecimals` are not synced** (absent from backend entity/DTO).
12. **Deprecated columns still live**: `transactions.type`, `paymentMethod`, `isRecurring`, `recurrencePattern`; `categories.type`; `budgets.limit`, `categoryId`; `objective_transactions` table. `serverId` columns are never populated.
13. **Sync conflict handling is timestamp LWW only**, dependent on client clocks for `UpdatedAt`; no field-level merge; `SyncStatus.conflict=4` is defined but never assigned.
14. **`exchange_rates.id` is epoch millis, not UUID**; harmless because device-local.
15. **FK enforcement off in SQLite by design** (`app_database.dart:280-289`); integrity relies on `_missingParentFor` and prune helpers.

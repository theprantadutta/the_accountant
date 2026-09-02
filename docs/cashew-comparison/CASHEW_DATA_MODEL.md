# Cashew: Data Model and Domain Logic

Source: https://github.com/jameskokoska/Cashew, version 5.4.3+416, schema version **46**.
All paths are relative to the repo's `budget/` folder. `T` = `lib/database/tables.dart`, `U` = `lib/struct/upcomingTransactionsFunctions.dart`.

Limits: `NAME_LIMIT=250`, `NOTE_LIMIT=500`, `COLOUR_LIMIT=50` (`T:34-36`). All primary keys are **text UUIDs** (`uuid.v4()` client default). A few reserved string PKs matter: wallet `"0"` = default/primary wallet, category `"0"` = "balance correction" category, `"-1"` = placeholder PK used by UI before insert (replaced by `Value.absent()` when `insert: true`, `T:3585-3590`).

---

## 1. Enums (`T:42-236`)

| Enum | Values (index order) | Where |
|---|---|---|
| `BudgetReoccurence` | `custom, daily, weekly, monthly, yearly` | `T:42` |
| `TransactionSpecialType` | `upcoming, subscription, repetitive, credit /*lent, withdraw, owed*/, debt /*borrowed, deposit, owe*/` | `T:44-50` |
| `ObjectiveType` | `goal, loan /*income==true ? lent : borrowed*/` | `T:52-55` |
| `SharedOwnerMember` | `owner, member` | `T:57-60` |
| `ExpenseIncome` | `income, expense` (search-filter only) | `T:62-65` |
| `PaidStatus` | `paid, notPaid, skipped` (search-filter only) | `T:67-71` |
| `BudgetTransactionFilters` | `addedToOtherBudget, sharedToOtherBudget, includeIncome, includeDebtAndCredit, addedToObjective, defaultBudgetTransactionFilters, includeBalanceCorrection` | `T:76-84` |
| `HomePageWidgetDisplay` | `WalletSwitcher, WalletList, NetWorth, AllSpendingSummary, PieChart` | `T:86-92` |
| `ThemeSetting` | `dark, light` | `T:120` |
| `MethodAdded` | `email, shared, csv, preview, appLink` | `T:122-128` |
| `SharedStatus` | `waiting, shared, error` | `T:130` |
| `DeleteLogType` / `UpdateLogType` | `TransactionWallet, TransactionCategory, Budget, CategoryBudgetLimit, Transaction, TransactionAssociatedTitle, ScannerTemplate, Objective, Unused` | `T:214-236` |
| `CycleType` (period picker) | `allTime, dateRange, pastDays, cycle` | `lib/widgets/periodCyclePicker.dart:19-24` |
| `TitleType` | `TitleExists, CategoryName, SubCategoryName, PartialTitleExists` | `T:7643-7648` |

`isFilterSelectedWithDefaults` (`T:99-118`): if the filter list is `null`, every filter is "on". If it contains `defaultBudgetTransactionFilters`, then `includeIncome`, `includeDebtAndCredit`, `includeBalanceCorrection` are **off** and everything else **on**. Otherwise the filter is on iff it is in the list.

List columns are stored as JSON strings via type converters (`T:132-212`): `IntListInColumnConverter`, `BudgetTransactionFiltersListInColumnConverter` (enum index list, out-of-range indices dropped), `HomePageWidgetDisplayListInColumnConverter`, `StringListInColumnConverter`, `DoubleListInColumnConverter`.

---

## 2. Tables

Registered in `@DriftDatabase` (`T:679-691`): `Wallets, Transactions, Categories, CategoryBudgetLimits, AssociatedTitles, Budgets, AppSettings, ScannerTemplates, DeleteLogs, Objectives`. (A `Labels` table exists only as commented code, `T:408-420`.)

### 2.1 `Wallets` → data class `TransactionWallet` (`T:250-271`)

| Column | Type | Meaning |
|---|---|---|
| `walletPk` | text PK, uuid | `"0"` is the built-in primary wallet |
| `name` | text(250) | |
| `colour` | text(50) nullable | hex; null = theme colour |
| `iconName` | text nullable | |
| `dateCreated` | datetime, client default now | |
| `dateTimeModified` | datetime nullable, default now | sync clock |
| `order` | int | display order |
| `currency` | text nullable | currency code (lowercase, e.g. "usd") |
| `currencyFormat` | text nullable | added v46 (`T:1150`); not consumed by any logic found beyond storage |
| `decimals` | int default 2 | display precision |
| `homePageWidgetDisplay` | JSON list of `HomePageWidgetDisplay` nullable | which home widgets show this wallet; default `[WalletSwitcher, WalletList]` (`T:94-97`, applied on insert at `T:2744`) |

### 2.2 `Transactions` → `Transaction` (`T:273-340`)

| Column | Type | Meaning |
|---|---|---|
| `transactionPk` | text PK | may be a "predictable key" `<orig>::predict::N` for auto-generated recurrences (`U:197-213`) |
| `pairedTransactionFk` | FK → Transactions nullable | links the two halves of a balance transfer (v46) |
| `name` | text(250) | title (may be empty; label derived from category) |
| `amount` | real | **signed**: negative = expense, positive = income (`fixTransactionPolarity`, `T:7579-7591` enforces `abs()*(income?1:-1)`) |
| `note` | text(500) | not trimmed (links need trailing space, `T:3446-3449`) |
| `categoryFk` | FK → Categories | main category; `"0"` = balance correction |
| `subCategoryFk` | FK → Categories nullable | subcategory |
| `walletFk` | FK → Wallets default `"0"` | owning account |
| `dateCreated` | datetime | the transaction's **date** (not creation time); used for all period logic |
| `dateTimeModified` | datetime nullable | last-write-wins sync clock |
| `originalDateDue` | datetime nullable | "When a transaction is paid, the date gets set to the current time. This stores the original date it was supposed to be due on." (`T:294-297`) |
| `income` | bool default false | |
| `periodLength` | int nullable | recurrence multiplier |
| `reoccurrence` | `BudgetReoccurence` nullable | recurrence unit |
| `endDate` | datetime nullable | recurrence stop date |
| `upcomingTransactionNotification` | bool nullable default true | per-transaction reminder flag (UI passes it through, `addTransactionPage.dart:694-696`) |
| `type` | `TransactionSpecialType` nullable | null = normal |
| `paid` | bool default false | see §3; **inverted for credit/debt** (`T:305-307`) |
| `createdAnotherFutureTransaction` | bool nullable default false | "If user sets to paid and then un pays it will not create a new transaction" (`T:309`) |
| `skipPaid` | bool default false | instance was skipped |
| `methodAdded` | `MethodAdded` nullable | provenance |
| `transactionOwnerEmail`, `transactionOriginalOwnerEmail` | text nullable | shared-budget payer |
| `sharedKey`, `sharedOldKey` | text nullable | Firestore doc key; `sharedOldKey` = previous key after un-sharing (`T:322-323`) |
| `sharedStatus` | `SharedStatus` nullable | |
| `sharedDateUpdated` | datetime nullable | |
| `sharedReferenceBudgetPk` | text nullable | "the budget this transaction belongs to"; used for **both** shared budgets and local "added-only" budgets |
| `objectiveFk` | FK → Objectives nullable | goal membership |
| `objectiveLoanFk` | FK → Objectives nullable | long-term loan membership (v46) |
| `budgetFksExclude` | JSON string list nullable | budgets this transaction is excluded from |

### 2.3 `Categories` → `TransactionCategory` (`T:342-373`)

`categoryPk`, `name`, `colour`, `iconName`, `emojiIconName` (v39), `dateCreated`, `dateTimeModified`, `order`, `income` (bool), `methodAdded`, `mainCategoryPk` (FK → Categories, nullable: **null = main category, non-null = subcategory**, `T:355-360`).

### 2.4 `CategoryBudgetLimits` → `CategoryBudgetLimit` (`T:375-392`)

`categoryLimitPk`, `categoryFk`, `budgetFk`, `amount` (real; either absolute money or a **percentage** depending on `Budget.isAbsoluteSpendingLimit`), `dateTimeModified`, `walletFk` (default `"0"`, currency of the limit; v45 `T:1111`).

### 2.5 `AssociatedTitles` → `TransactionAssociatedTitle` (`T:394-406`)

`associatedTitlePk`, `categoryFk`, `title`, `dateCreated`, `dateTimeModified`, `order`, `isExactMatch` (bool default false). Comment `T:390-393`: if "apple" is a title in Food, typing "pineapple" selects Food.

### 2.6 `Budgets` → `Budget` (`T:422-476`)

| Column | Meaning |
|---|---|
| `budgetPk`, `name`, `amount`, `colour` | |
| `startDate`, `endDate` | for `custom` reoccurrence = the fixed range; otherwise `startDate` anchors the cycle (`endDate` written as `selectedEndDate ?? now`, `addBudgetPage.dart:302`) |
| `walletFks` | JSON list nullable; only count transactions from these wallets |
| `categoryFks`, `categoryFksExclude` | JSON lists nullable |
| `income` | bool; a "savings" budget counting income instead of expenses |
| `archived` | bool (v46) |
| `addedTransactionsOnly` | bool; "added-only" budget: only transactions whose `sharedReferenceBudgetPk == budgetPk` count |
| `periodLength`, `reoccurrence` | cycle |
| `dateCreated`, `dateTimeModified`, `pinned`, `order` | |
| `walletFk` | currency of `amount` (default `"0"`) |
| `budgetTransactionFilters` | JSON list of `BudgetTransactionFilters` nullable |
| `memberTransactionFilters` | JSON list of member emails nullable |
| `sharedKey`, `sharedOwnerMember`, `sharedDateUpdated`, `sharedMembers`, `sharedAllMembersEver` | shared-budget (Firestore) metadata |
| `isAbsoluteSpendingLimit` | bool; category limits are money (true) vs % of budget (false) |

### 2.7 `AppSettings` → `AppSetting` (`T:478-486`)

`settingsPk` int autoincrement (always row 0), `settingsJSON` text (the SharedPreferences `userSettings` JSON blob), `dateUpdated`. Written by `backupSettings()` (`lib/struct/settings.dart:323-333`) so settings ride along in DB backups.

### 2.8 `ScannerTemplates` → `ScannerTemplate` (`T:488-512`)

`scannerTemplatePk`, `dateCreated`, `dateTimeModified`, `templateName`, `contains` (email must contain this string), `titleTransactionBefore/After`, `amountTransactionBefore/After` (substring delimiters used to extract title/amount, `autoTransactionsPageEmail.dart:100-110, 613-640`), `defaultCategoryFk`, `walletFk` (default `"0"`), `ignore` (bool). Used for Gmail auto-transactions.

### 2.9 `DeleteLogs` → `DeleteLog` (`T:238-248`)

`deleteLogPk`, `entryPk` (PK of deleted row), `type` (`DeleteLogType`), `dateTimeModified` (deletion time).

### 2.10 `Objectives` → `Objective` (`T:514-539`)

`objectivePk`, `type` (`ObjectiveType`, default 0=goal), `name`, `amount`, `order`, `colour`, `dateCreated` (**used as the objective start date**, `addObjectivePage.dart:285`), `endDate` nullable, `dateTimeModified`, `iconName`, `emojiIconName`, `income` (bool; goal: saving vs spending; loan: lent vs borrowed), `pinned` (default **true**), `archived`, `walletFk` (currency of `amount`).

### 2.11 Non-table helper classes (`T:541-676`)

`TransactionWithCategory` (transaction + category + wallet + budget + objective + subCategory + objectiveLoan), `TransactionActivityLog`, `CategoryWithDetails`, `WalletWithDetails` (wallet + `totalSpent` + `numberTransactions`), `AllWallets` (list + `indexedByPk`, `allContainSameCurrency()`, `containsMultipleAccountsWithSameCurrency()`), `SelectedWalletPk`, `CategoryWithTotal`, `TotalWithCount`, `TransactionWithCount`, `EarliestLatestDateTime`, `TransactionAssociatedTitleWithCategory`.

### 2.12 Migration highlights (`T:700-1180`)

v37→38 `originalDateDue` (`T:952`); v39→40 `objectiveFk` + `Objectives` table (`T:977`); v40→41 `categoryFksExclude`; v41→44 `objectives.endDate`, `budgets.walletFks`, `budgets.income`; v44→45 `objectives.walletFk`, `categoryBudgetLimits.walletFk`; v45→46 `pairedTransactionFk`, `objectiveLoanFk`, `wallets.currencyFormat`, `budgets.archived`, `objectives.archived`, `objectives.type` (`T:1119-1165`). `beforeOpen` retries adding `budgetFksExclude` every launch (`T:1170-1178`).

---

## 3. Transaction model and special types

### 3.1 Sign / income

`amount` is signed; UI writes `abs()` for income, `-abs()` for expense (`addTransactionPage.dart:656-658`). `createOrUpdateTransaction` (`T:3427-3599`) additionally forces: **credit → `income=false, amount=-abs`**, **debt → `income=true, amount=+abs`** (`T:3451-3457`). It clamps `|amount| ≤ 999,999,999,999`, rejects NaN/∞ (`T:3435-3444`), trims `name`, and if a *subcategory* was chosen as main category it swaps to main+sub (`T:3478-3486`). It also "touches" `dateTimeModified` of the category/subcategory so sync keeps them (`T:3474-3510`). Balance-correction transactions (`categoryFk=="0"`) have their seconds forced to `:30` (negative) / `:31` (positive) to keep deterministic order (`T:3459-3470`).

### 3.2 `paid` semantics

- Normal (type null): `paid=true` on creation (`addTransactionPage.dart:268-269`; `createTransaction` line 629-631 `paid = selectedType == null`).
- `upcoming/subscription/repetitive`: created with `paid=false` (`addTransactionPage.dart:280-286`). `paid=false && skipPaid=false` ⇒ pending; `paid=true` ⇒ settled; `skipPaid=true` ⇒ skipped.
- `credit/debt`: **inverted**. Created with `paid=true` meaning "outstanding, counts toward totals"; when collected/settled → `paid=false` so the net effect drops out of totals (`T:305-307`, `U:404-411`; `openUnpayDebtCreditPopup` sets back `paid:true`, `U:595-600`).
- Almost every sum query filters `sum(filter: transactions.paid.equals(true))` (`T:1384`, `5632`, `5655`, `5731`, `6494`, `6565`, `6717`, `6771`, ...), so **unpaid upcoming/subscription/repetitive instances are excluded from balances, budgets, goals**, and settled credit/debt is excluded too. `getAllTransactionsFromWallet` also requires `paid` (`T:4100-4107`).
- Exceptions: upcoming/overdue totals (`watchTotalWithCountOfUpcomingOverdue`, `T:6789-6858`) sum `paid=false & skipPaid=false` of the 3 recurring types; `watchTotalSpentGivenList` sums selection regardless (`T:5700`).

### 3.3 Pending → paid / skip

`openPayPopup` (`U:214-289`) → `markAsPaid` (`U:291-323`):

```dart
Transaction transactionNew = transaction.copyWith(
  paid: true,
  dateCreated: appStateSettings["markAsPaidOnOriginalDay"] ? null : DateTime.now(),
  createdAnotherFutureTransaction: Value(true),
  originalDateDue: Value(transaction.dateCreated),
);
await database.createOrUpdateTransaction(transactionNew);
await createNewSubscriptionTransaction(...);
```

So paying moves `dateCreated` to *now* unless the setting `markAsPaidOnOriginalDay` is on (default false, `defaultPreferences.dart:121`), and remembers the due date in `originalDateDue`. `markAsSkipped` (`U:325-355`) sets `skipPaid=true, dateCreated=now, createdAnotherFutureTransaction=true` and also spawns the next instance. If the transaction is a balance correction (`categoryFk=="0"`), its paired half is paid/skipped first (`U:297-309`).

Undo: `openUnpayPopup` (`U:541-573`) deletes and re-inserts with `paid=false` and shared fields cleared. It does **not** reset `createdAnotherFutureTransaction`, so re-paying will not spawn a duplicate next instance (`U:23`). `openRemoveSkipPopup` (`U:511-539`) just sets `skipPaid=false`.

### 3.4 Upcoming vs overdue

Determined purely by `dateCreated` vs `DateTime.now()` among `paid=false & skipPaid=false` and type ∈ {subscription, repetitive, upcoming}: overdue = `dateCreated < now`, upcoming = `dateCreated > now` (`T:1901-1935`, `T:6829-6835`). `getAllUpcomingTransactions` looks ahead 1000 days (`T:1864-1880`). `getAllSubscriptions` / `getAllOverdueUpcomingTransactions` / `getAllOverdueRepetitiveTransactions` (`T:1822-1862`) return all unpaid, unskipped of each type (no date filter; the caller checks dates).

Auto-pay (`U:607-682`): if `automaticallyPaySubscriptions` / `automaticallyPayRepetitive` / `automaticallyPayUpcoming` (all default true, `defaultPreferences.dart:118-120`), on launch overdue instances (`dateCreated < now + 1 min`) with `createdAnotherFutureTransaction != true` are set `paid=true` **keeping their original date** and the next instance is created; loops up to 50 iterations because the new instance may also be overdue (`U:611-654`). `markUpcomingAsPaid` for `upcoming` just sets `paid=true` (no next instance).

### 3.5 Editing an instance vs series

There is **no series entity**: each recurrence is an independent row; the "series" is just the chain of rows created from one another. Editing edits only that row. `createTransaction()` (`addTransactionPage.dart:625-704`): when editing and the type changes, `createdAnotherFutureTransaction=false` and `paid` is reset (`true` for credit/debt, `false` for the recurring types). Deleting a balance-transfer half asks "delete both?" (`addTransactionPage.dart:3471-3527`); editing one asks "update both?" (`addTransactionPage.dart:471-548`, applying `updateCloselyRelatedBalanceTransfer`, `T:7532-7568`). `upcomingTransactionNotification`, `originalDateDue`, `pairedTransactionFk`, `methodAdded`, and shared fields are carried over from the original when editing.

### 3.6 Search/filter semantics for types (`onlyShowIfFollowsSearchFilters`, `T:5773-5957`)

`PaidStatus.paid/notPaid` only apply to `type != null` and exclude credit/debt (`T:5820-5840`); `skipped` = `skipPaid & type not null`. Income/expense filters exclude loans (`isNotLoan = objectiveLoanFk null & type ∉ {credit,debt}`) and balance corrections unless category "0" is explicitly selected (`T:5794-5808`). Filtering by `TransactionSpecialType.credit` also matches long-term-loan transactions whose loan objective is `income==true` (lent); `debt` matches `objective.income==false` (`T:5846-5867`).

---

## 4. Recurring engine (subscription / repetitive / upcoming)

- `upcoming` = one-off future transaction (no recurrence, no next instance).
- `subscription` and `repetitive` are treated **identically** by the engine (`U:24-26`); they differ only in label/icon and separate auto-pay settings.
- **Next-instance generation**: `createNewSubscriptionTransaction` (`U:21-133`), guarded by `createdAnotherFutureTransaction == false`. Offset: yearly → `+periodLength` years; monthly → `+periodLength` months; weekly → `+periodLength*7` days; daily → `+periodLength` days; **`custom` reoccurrence adds nothing** (falls through with zero offsets). New date built with `DateTime(y+yo, m+mo, d+do, h, min, s, ms)` (Dart normalises overflow). Stops with a snackbar if `endDate` is before the new date (`U:47-61`) or, when attached to a goal (`objectiveFk != null && endDate == null`), if the goal total has been reached (`U:63-92`). The new row is `copyWith(paid:false, transactionPk: updatePredictableKey(pk), dateCreated:newDate, createdAnotherFutureTransaction:false, pairedTransactionFk: predictable key of paired half or null)` and inserted with `insert:false` (the predictable PK is kept, `U:95-103`).
- **Predictable keys** (`U:191-213`): `"<pk>::predict::1"`, `::predict::2`, ... so that two devices auto-paying the same subscription produce the same PK and sync dedupes.
- `countTransactionOccurrences` (`U:135-189`) counts remaining instances until `endDate` (max 999) for the "× N remain until …" label in the pay popup.
- **Mark all as paid**: no bulk UI function exists; the automatic pass (`markSubscriptionsAsPaid`, `U:607-660`) is the "mark all overdue as paid". `settleTransactions` (`selectedTransactionsAppBar.dart:909-919`) is the bulk action for credit/debt (sets `paid=false`).
- UI period editing: `selectedPeriodLength` / `selectedRecurrence` (`addTransactionPage.dart:143-146`); `periodLength <= 0` with a type is coerced to 1 (`addTransactionPage.dart:671-673`); `addDefaultMissingValues` defaults `reoccurrence=monthly, periodLength=1` (`addTransactionPage.dart:373-391`).
- Notifications: `setUpcomingNotifications` re-scheduled after every pay/skip/add (`U:322`, `addTransactionPage.dart:592-598`).

---

## 5. Loans

### 5.1 One-time loans: `TransactionSpecialType.credit` / `debt`

- `credit` = "lent / withdraw / owed": expense, `income=false`, negative amount. `debt` = "borrowed / deposit / owe": `income=true`, positive amount (`T:3451-3457`; UI mirrors this and flips type if the user flips income: `addTransactionPage.dart:254-259, 353-364`).
- Created with `paid=true` (money left/entered your wallet, so it *does* count in the wallet balance). "Collect all"/"Settle all" (`openPayDebtCreditPopup`, `U:357-410`) sets `paid=false` ⇒ the transaction vanishes from all paid-only totals. The app models repayment as **netting to zero**, not as a second transaction (a commented alternative at `U:413-422` was never enabled).
- `isTransactionActionDealtWith` (`transactionEntryTypeButton.dart:230-247`): credit/debt are "dealt with" when `paid==false`.
- **Partial collection** (`U:428-508`): converts the one-time loan into a long-term loan objective: creates `Objective(type: loan, amount: 0, income: !transaction.income, name: transaction label, walletFk, icon/colour from category)`, rewrites the original transaction as `type:null, objectiveLoanFk:newPk, name:"initial-record"`, and inserts a second transaction with **inverted polarity** (`income: !transaction.income, amount: selectedAmount * (!transaction.income ? 1 : -1)`, `dateCreated: now`, chosen wallet).
- Loans page totals: `watchTotalWithCountOfCreditDebt` (`T:6870-6966`) sums **paid** transactions where `type==credit|debt` OR `objectiveLoanFk != null` (excluding archived loan objectives), with credit ≙ `objective.income==true`, debt ≙ `objective.income==false`.
- Budgets exclude credit/debt and loan transactions by default via `includeDebtAndCredit` (`T:6079-6093`); wallet "income/expense only" views exclude them via `onlyShowIfOnlyExpenseAndIncome` (`T:6702-6709`).

### 5.2 Long-term loans: `Objective` with `type == loan`

- `income == true` ⇒ **lent** (someone owes you); `income == false` ⇒ **borrowed** (`T:54`). `cleanseTransactionForLongTermLoan` (`T:3407-3425`) guarantees a transaction can't have both `objectiveFk` and `objectiveLoanFk`, and strips `type` credit/debt when `objectiveLoanFk` is set.
- **Creation** (`addObjectivePage.dart:237-308`): for a new (non-difference) loan the objective's `amount` is forced to **0** (also enforced in `createOrUpdateObjective`, `T:2766-2770`: "Objective loans should always have offset of 0 when inserted for the first time"). The entered amount becomes an **"initial-record" transaction** with `income: !selectedIncome`, `amount: abs * (!selectedIncome ? 1 : -1)`, `paid:true`, `type:null`, `objectiveLoanFk`. Lending 100 creates a −100 expense in your wallet; borrowing creates +100 income. The loan principal *does* affect wallet balance via ordinary transactions.
- `Objective.amount` on a loan is later usable as an **offset** (kept "because of the total offset" when editing, `addObjectivePage.dart:297-300`) and feeds `watchTotalWithCountOfCreditDebtLongTermLoansOffset` (`T:6968-7019`), which adds `|amount| * (income ? -1 : 1)` per non-archived, non-difference loan to the loans page total.
- **Progress** (`WatchTotalAndAmountOfObjective`, `objectivesListPage.dart:1004-1071`):
  - `watchTotalTowardsObjective` (`T:5650-5673`): Σ paid amounts with `objectiveLoanFk == pk` (all polarities).
  - `watchTotalAmountObjectiveLoan` (`T:5627-5648`): Σ paid amounts with `objectiveLoanFk == pk` **and `income == !objective.income`**, i.e. only the principal-side records.
  - `objectiveAmount = principalSum + objective.amount*(income?-1:1)` (currency-converted), `totalAmount = (allSum − principalSum) * -1` (the repayments), `percent = total/objectiveAmount`; both are then sign-flipped by `(objective.income ? -1 : 1)` for display. Repayments toward a lent loan are income transactions with `objectiveLoanFk`, and progress = repayments / (principal + offset).
  - Because both sums are paid-only, marking a repayment unpaid removes it from progress.
- **Repayment entry**: tapping the loan action button on a transaction opens `AddTransactionPage(selectedObjective: loan, selectedIncome: loan.income)` (`transactionEntryTypeButton.dart:73-79`); `setSelectedLoanObjectivePk` clears `objectiveFk` and resets a credit/debt type to default (`addTransactionPage.dart:325-341`). A transfer popup opened from a loan passes `initialObjectiveLoanPk`, and only the **from-wallet half** of the transfer gets `objectiveLoanFk` (`addWalletPage.dart:1193-1207`).
- **"Difference only" loans** (`getIsDifferenceOnlyLoan`, `objectivesListPage.dart:27-32`; SQL twin `T:4303-4307`): a loan is difference-only iff `amount == -1 && type == loan && appStateSettings["longTermLoansDifferenceFeature"] == true` (feature flag default **false**, `defaultPreferences.dart:236`). Toggle: `addObjectivePage.dart:293-296` writes `-1` as amount. Semantics: no fixed principal; `getDifferenceOfLoan = income ? total − objectiveAmount : objectiveAmount − total` ("negative to collect / you are owed, positive to pay back / you owe", `objectivesListPage.dart:34-41`). Percent is 1 when the difference rounds to 0, else 0 (`objectivesListPage.dart:1038-1053`). The action button on a difference-loan transaction inserts a mirror transaction (`income` flipped, `amount * -1`, now) to settle it (`transactionEntryTypeButton.dart:56-72`). Difference loans are excluded from the offset total (`T:6979`) and can be looked up by person name (`getPersonsLongTermDifferenceLoanInstance`, `T:4309-4318`). `getAllPinnedObjectives(showDifferenceLoans:)` can separate them (`T:2178-2194`).
- **Paying off**: there is no explicit "paid off" state; progress reaching 100% is purely computed. Users may archive (`editObjectivesPage.dart:208`), and archived loans drop out of the loans total (`T:6920`, `6977`). Deleting a loan objective nulls `objectiveLoanFk` on its transactions (`deleteObjective`, `T:4863-4876`); the transactions and their wallet effects remain.
- **Bug**: `getTotalTowardsObjective` (`T:5674-5698`) uses `objectiveLoanFk` for **both** branches of the ternary, so for goals (used in the "goal reached" check in `U:70-73`) it sums loan-linked rows rather than `objectiveFk` rows.

---

## 6. Objectives: goals (`type == goal`)

- `income=true` ⇒ savings goal (count income), `income=false` ⇒ expense/spending goal (`addObjectivePage.dart:970, 1009`).
- Progress (`objectivesListPage.dart:1059-1068`): `total = Σ paid amount where objectiveFk == pk` (currency-converted per wallet, `T:5650-5673`), negated for expense goals; `percent = total / objectiveAmountToPrimaryCurrency(objective)` (`currencyFunctions.dart:141-145`). Transactions are linked explicitly via `objectiveFk` (user picks the goal in the add page; there is no date-range mechanism).
- `dateCreated` is the user-selected start date; `endDate` optional (cleared if before start, `addObjectivePage.dart:279-282`). With an `endDate`, a "remaining per day" label is computed: `(total − amount)/remainingDays * -1` (`objectivesListPage.dart:940-960`).
- `pinned` (default true) controls the home widget (`getAllPinnedObjectives`, `T:2178`); `archived` toggled in `editObjectivesPage.dart:208`; `order` maintained by `moveObjective/shiftObjectives/fixOrderObjectives` (`T:2270-2367, 3218`).
- Budgets can exclude goal-linked transactions with the `addedToObjective` filter (`T:6095-6103`). Deleting a goal nulls `objectiveFk` (`T:4866-4870`, `moveTransactionsToObjective` `T:5196-5233`).
- Recurring transactions attached to a goal stop generating once the goal is reached (`U:63-92`).

---

## 7. Wallets / accounts

- **Balance is derived, never stored**: `WalletWithDetails.totalSpent = Σ amount where paid` per wallet (`watchAllWalletsWithDetails`, `T:2405-2447`, `sum(filter: paid == true)`), shown in `AmountAccount` (`walletEntry.dart:318-360`). `watchTotalOfWalletNoConversion` (`T:6767-6787`) and `watchTotalWithCountOfWallet` (`T:6711-6765`) give totals with optional income/expense split, period cycle, balance-correction inclusion (`includeBalanceCorrection`), and "only income & expense" (drops loans + balance corrections).
- **Net worth** = `watchTotalWithCountOfWallet(isIncome:null, followCustomPeriodCycle:true, cycleSettingsExtension:"NetWorth")` across selected wallets (`homePageNetWorth.dart:80-88`); with `isIncome == null` balance corrections **are** included (`onlyShowIfNotBalanceCorrection`, `T:6261-6266`).
- **Currency conversion**: totals are computed per wallet, each multiplied by `amountRatioToPrimaryCurrency(allWallets, wallet.currency)` and then summed (`totalDoubleStream`, `T:5421-5425`). Rate = USD-based table from `cdn.jsdelivr.net/npm/@fawazahmed0/currency-api` cached in settings `cachedCurrencyExchange`, overridable by `customCurrencyAmounts` (`currencyFunctions.dart:14-40, 116-133`). Primary currency = currency of `appStateSettings["selectedWalletPk"]` (`currencyFunctions.dart:56-89`). Budget/objective/limit amounts are converted using their own `walletFk` (`currencyFunctions.dart:135-151`).
- **Transfers** (`addWalletPage.dart:1136-1207`): two balance-correction transactions (category `"0"`, `paid:true`, `type:null`) are created via `createCorrectionTransaction` (`addWalletPage.dart:984-1017`): the *to* wallet gets `+amount * ratio(to)` at `date+1s`, the *from* wallet gets `−amount * ratio(from)` at `date`, with `pairedTransactionFk` = the *to* transaction's PK on the *from* row. `income = amount > 0`. Titles default to "<wallet> transfer-in/out"; note "transferred-balance\nA → B". The balance-correction category `"0"` is created lazily (`initializeBalanceCorrectionCategory`, `addWalletPage.dart:958-982`). Pairing lookup falls back to "same category 0, opposite `income`, within ±1 s" when `pairedTransactionFk` is absent (`getCloselyRelatedBalanceCorrectionTransaction`, `T:7471-7530`). Transfer fee code exists but is commented out (`addWalletPage.dart:1208+`).
- **Balance correction** (single-sided) uses the same `createCorrectionTransaction` without a pair (the "correct total" flow in `addWalletPage.dart`).
- **Ordering**: `order` column; `moveWallet`, `shiftWallets`, `fixOrderWallets` (`T:2590-2660, 3270`).
- **Default/primary wallet**: `appStateSettings["selectedWalletPk"]` (default `"0"`, `defaultPreferences.dart:30`); `setPrimaryWallet` (`walletEntry.dart:395`). Wallet `"0"` cannot be deleted directly; `deleteWallet("0")` promotes the next wallet by copying it onto PK `"0"` and moving transactions (`T:5059-5099`). Deleting any wallet deletes its transactions (`deleteWalletsTransactions`, `T:5277-5289`), with delete logs.
- **Moving transactions between wallets** converts amounts by `amountRatioFromToCurrency` (`moveWalletTransactions`, `T:5101-5128`); `transferTransactionsOnly` moves without conversion (`T:5130`).
- **"All accounts" view**: `WalletDetailsPage(wallet: null)` (`homePageNetWorth.dart:96`); `AllWallets` is a Provider; per-wallet home widgets are chosen via `homePageWidgetDisplay` (`getAllPinnedWallets`, `T:2163-2171`; `mergeLikeCurrencies` groups by currency, `T:2437`).

---

## 8. Budgets

- **Types**: `addedTransactionsOnly == false` ⇒ "all transactions" budget filtered by categories/wallets/filters; `true` ⇒ "added-only" budget: only rows with `sharedReferenceBudgetPk == budgetPk` count (`onlyShowIfCertainBudget`, `T:6442-6447`, passed when `sharedKey != null || addedTransactionsOnly`, `budgetContainer.dart:66-70`). Added-only budgets get `budgetTransactionFilters`/`memberTransactionFilters` = null (`addBudgetPage.dart:327-338`). For an added-only **custom** (non-shared) budget, `onlyShowBasedOnTimeRange` returns `true`: all its transactions count regardless of date (`T:6415-6424`).
- **Period**: `getBudgetDate(budget, date)` (`functions.dart:575-685`): custom ⇒ `[startDate, endDate]`; otherwise steps forward/backward from `startDate` in `periodLength` units (daily/weekly*7/monthly/yearly via `justDay(...Offset)`) until the window containing `date` is found; returned range is `[loopStart, loopEnd − 1 day]`. `limitBudgetPeriod` (`T:4198-4222`) caps periodLength (10 y / 100 mo / 500 wk / 1000 d), min 1, and truncates `startDate` to the day. History: `getDatePastToDetermineBudgetDate(index, budget)` (`functions.dart:521`) steps back `index` periods (monthly uses day 1 to dodge 31st issues) and `pastBudgetsPage.dart:117-135` computes one total per past range.
- **Spent** = Σ of `watchTotalSpentInEachCategoryInTimeRangeFromCategories` (`T:6550-6700`) × `determineBudgetPolarity` (+1 income budget, −1 expense; `budgetPage.dart:1450-1456`). Query applies: time range (inclusive on both end days, `T:6425-6435`), `isInCategory(categoryFks, categoryFksExclude)` (`T:6216-6228`), `walletFks`, `onlyShowIfNotBalanceCorrection`, `onlyShowIfFollowsFilters`, `onlyShowIfNotExcludedFromBudget` (`budgetFksExclude`), paid-only, per-wallet currency conversion. `watchTotalOfBudget` (`T:6465-6545`) is the scalar twin. "Over": `budgetAmount − totalSpent < 0` (`budgetContainer.dart:116`, `budgetPage.dart:1335`), label "overspent-amount-of"/"over-saved-amount-of" (`budgetPage.dart:1437-1448`). `todayPercent = getPercentBetweenDates(range, now)` (`functions.dart:716-724`).
- **Filters** (`onlyShowIfFollowsFilters`, `T:6028-6114`): `memberTransactionFilters` (shared: owner email ∈ list or not shared); `sharedToOtherBudget` (exclude `sharedKey != null`); `addedToOtherBudget` (exclude rows with `sharedReferenceBudgetPk` set and not shared); `includeIncome` (otherwise only `income == budget.income`); `includeDebtAndCredit` (otherwise exclude credit/debt type **and** `objectiveLoanFk != null`); `addedToObjective` (otherwise exclude `objectiveFk != null`); `includeBalanceCorrection` (otherwise exclude category "0").
- **Exclusion**: `Transaction.budgetFksExclude` lists budgets to drop the row from (`onlyShowIfNotExcludedFromBudget`, `T:6449-6456`); cleared on budget delete (`clearExcludeTransactions`, `T:5180-5194`); `watchAllExcludedTransactionsBudgetsInUse` (`T:7570`).
- **Category spending limits**: one `CategoryBudgetLimit` per (budget, category), subcategory limits too. If `isAbsoluteSpendingLimit` they are money in `limit.walletFk` currency, else **percent** (main = % of budget; sub = % of its main's limit). `toggleAbsolutePercentSpendingCategoryBudgetLimits` (`T:3007-3064`) converts existing limits both ways. Totals: `watchTotalOfCategoryLimitsInBudgetWithCategories` (`T:5516`), `...WithSubCategories` (`T:5572`); "over" = total > budget (absolute) or > 100% (`categoryLimits.dart:74-76`). `fixWanderingCategoryLimitsInBudget` (`T:5458-5514`) repairs limits with missing wallet/category/budget and dedupes.
- **Shared budgets** (deprecated; gated by `appStateSettings["sharedBudgets"]`, default false, `defaultPreferences.dart:178`): `shareBudget` creates a Firestore `budgets/{key}` doc and sets `sharedKey`, `sharedOwnerMember=owner`, `sharedMembers` (`shareBudget.dart:19-67`); transactions are pushed via `sendTransactionAdd/Set/Delete` from `createOrUpdateTransaction` (`T:3513-3580`) and pulled via `createOrUpdateFromSharedTransaction` (`T:4139-4173`, matches on `sharedKey|sharedOldKey`), `createOrUpdateFromSharedBudget` (`T:4042-4073`). `deleteBudget` (`T:4823-4861`) leaves/removes the shared budget, unlinks added transactions, clears excludes, deletes limits, logs deletion.
- `archived` budgets hidden by `watchAllBudgets(hideArchived)` (`T:1966-1990`); `pinned` → home (`getAllPinnedBudgets`, `T:2170`).

---

## 9. Categories and AssociatedTitles

- Main vs sub via `mainCategoryPk` (`T:355-360`); `onlyShowMainCategoryListing` = `mainCategoryPk IS NULL` (`T:6438`). `income` flag on a category sets the transaction's income when selected (`addTransactionPage.dart:190-197`). Icon = `iconName` (asset png) or `emojiIconName`; `colour` hex.
- Default categories PK `"1".."11"` (Dining, Groceries, Shopping, Transit, Entertainment, Bills & Fees, Gifts, Beauty, Work, Travel, Income[income=true]) created with `dateTimeModified = DateTime(0)` (`defaultCategories.dart:6-139`, `initializeDefaultDatabase.dart:26-38`); PK `"0"` reserved for balance correction (`defaultCategories.dart:8`). Default wallet `"0"` uses device currency (`initializeDefaultDatabase.dart:40-51`).
- Restructuring: `makeMainCategoryIntoSubcategory` / `makeSubcategoryIntoMainCategory` / `mergeAndDeleteCategory` rewrite transactions, titles, subcategories (`T:5320-5420`). Deleting a category deletes its transactions and titles (`deleteCategory`, `T:4963`); `deleteWanderingTransactions` / `deleteWanderingTitles` remove rows whose category vanished (`T:7397-7438`).
- **Auto-categorisation**: while typing a title, `getSimilarAssociatedTitles` (`T:2010-2144`) matches `associatedTitles.title LIKE %typed%` (ordered by `order` desc), optionally word-level partial matches (`PartialTitleExists`, completed via `completePartialTitle`, `T:2146-2158`), then category/subcategory names (`CategoryName`/`SubCategoryName`). `autoAddAssociatedTitles` (default true) saves title→category on every add (`addTransactionPage.dart:462-469`). `isExactMatch` column exists but no query was found using it. `getRelatingCategory` / `getRelatingWallet` (`T:2882-2934`) do exact → case-insensitive → LIKE matching for CSV/email import.

---

## 10. Deletion and sync

- Every user-facing delete writes a `DeleteLog` (`createDeleteLog`, `T:2671-2688`; batch `T:2690-2722`) and, for transactions, pushes to an in-memory "recently deleted" list. Sync-internal deletes (`processSyncLogs`) do **not** log.
- **Google Drive sync** (`lib/struct/syncClient.dart`): each device uploads its whole SQLite as `sync-<clientID>.sqlite` in the Drive appDataFolder (`createSyncBackup`, lines 80-150). `_syncData` (196-547) downloads every *other* device's file newer than `dateOfLastSyncedWithClient[client]`, opens it as a second Drift DB, and collects `SyncLog`s: all rows with `dateTimeModified >= lastSynced` for wallets, categories, budgets, limits, transactions, titles, scanner templates, objectives (`getAllNew*`, `T:2472-2585`) plus `DeleteLog`s with `dateTimeModified >= lastSynced` (`T:2660`).
- **Merge**: `processSyncLogs` (`T:3601-3805`): logs sorted by `transactionDateTime`; deletes apply only if the local row's `dateTimeModified < log time`; updates do `batch.update(... where dateTimeModified < log time)` then `batch.insert(..., insertOrReplace)` (so missing rows are created and nulls overwrite). Last-writer-wins on `dateTimeModified`. Afterwards the primary wallet is validated (`syncClient.dart:527-533`).
- Order/uniqueness repairs run separately (`fixOrderBudgets`, `fixDuplicateAssociatedTitles`, etc., `T:3195-3378`).

---

## 11. Other domain concepts

- `dateTimeModified` is set to `now` on every create/update path (`T:3583`, `2737`, `2757`, `4013`, `4270`, `2831`); defaults `DateTime(0)` for seeded defaults so any device's edit wins.
- `originalDateDue`: only written by `markAsPaid` (`U:315`), preserved on edit.
- `methodAdded`: `email` (Gmail scanner), `csv` (import), `shared` (downloaded from shared budget), `preview` (demo data, cleared on first real edit, `T:3593-3595`), `appLink` (deep-link add). Filterable (`onlyShowBasedOnMethodAdded`, `T:6341`; `watchAllDistinctMethodAdded`, `T:2948`).
- `walletFk` on Budgets/Objectives/CategoryBudgetLimits/ScannerTemplates denotes the **currency** of the stored amount (and default wallet for scanner), not membership.
- `sharedReferenceBudgetPk` doubles as "added to budget" for local budgets; `onlyShowBasedOnBudgetFks` treats `null` in the filter list as "not in any budget" (`T:6348-6360`); same pattern for `objectiveFks`/`objectiveLoanFks` (`T:6371-6410`, where "null" for loans also means `type ∉ {credit, debt}`).
- `transactionOwnerEmail` = payer (`selectedPayer`, defaults to current user when a shared budget is chosen, `addTransactionPage.dart:307-319`); `watchTotalSpentByUser` (`T:6156`).
- Net-before-start-date totals for cumulative / "net date banner" views: `watchTotalNetBeforeStartDateTransactionCategoryWithDay` (`T:1362-1453`), `watchTotalNetBeforeStartDate` (`T:7221`), `getTotalBeforeStartDateInTimeRangeFromCategories` (`T:7289`).
- Period cycles for home widgets: settings `selectedPeriodCycleType<Ext>`, `cyclePeriodLength<Ext>`, `cycleReoccurrence<Ext>`, `cycleStartDate<Ext>`, `customPeriodStartDate/EndDate/PastDays<Ext>` for Ext ∈ {"", PieChart, NetWorth, AllSpendingSummary, OverdueUpcoming, CreditDebts, …} (`defaultPreferences.dart:239-291`), resolved by `onlyShowIfFollowCustomPeriodCycle` (`T:6268-6318`) using a temporary Budget (`getCycleDateTimeRange`, `periodCyclePicker.dart:525-531`).
- Common-transaction suggestions: last 60 days, `type IS NULL`, grouped by category+name, top 5 (`getCommonTransactions`, `T:7448-7469`).
- Settings relevant to domain (defaults): `automaticallyPayUpcoming/Repetitive/Subscriptions=true`, `markAsPaidOnOriginalDay=false`, `autoAddAssociatedTitles=true`, `longTermLoansDifferenceFeature=false`, `sharedBudgets=false`, `selectedWalletPk="0"`, `netWorthAllWallets=true`, `showTotalSpentForBudget=false` (`defaultPreferences.dart:30-236`).

### Not found / not present

- No `includeTransactionsBefore` field or concept on Objectives.
- No stored wallet balance, no series/template entity for recurring transactions, no explicit "loan paid off" flag, no bulk "mark all as paid" UI (only the automatic overdue pass).
- `Wallets.currencyFormat` and `AssociatedTitles.isExactMatch` are stored but no logic was found consuming them.

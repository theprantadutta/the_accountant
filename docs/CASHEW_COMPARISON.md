# The Accountant vs. Cashew

> **Read this as a page:** https://claude.ai/code/artifact/b10a4f6f-37b4-48ec-baab-3aa84577e248
>
> **Detailed source reports** (the raw code-level findings this comparison is built from) live in [`cashew-comparison/`](cashew-comparison/README.md):
> - [Cashew data model and domain logic](cashew-comparison/CASHEW_DATA_MODEL.md)
> - [Cashew feature inventory](cashew-comparison/CASHEW_FEATURE_INVENTORY.md)
> - [The Accountant data model and domain logic](cashew-comparison/ACCOUNTANT_DATA_MODEL.md)
> - [The Accountant feature inventory](cashew-comparison/ACCOUNTANT_FEATURE_INVENTORY.md)

A feature-by-feature and architecture-by-architecture comparison of **The Accountant** (this app) against **Cashew** by James Kokoska, the open-source budgeting app this project drew inspiration from.

Both codebases were read in full for this document. Cashew was analysed at version 5.4.3 (schema 46). The Accountant was analysed at version 3.0.0+21 (schema 17). Every claim below is backed by code that was actually read, not by store listings or memory. Where a feature exists in code but cannot be reached from the UI, it is called out explicitly, because that distinction matters a lot for this app.

---

## 1. Executive summary

**The short version:** The Accountant has the better foundations and the thinner product.

Cashew is a mature, single-developer app with roughly the same amount of Dart code as ours, but almost all of it is user-facing. It ships a customizable home page with fourteen sections, budgets with recurring periods and history, category spending limits, a heatmap, CSV and Google Sheets import, a bill splitter, Android widgets, HTTPS app links, forty-eight languages, bulk editing, an activity log with undo, and a mature loan system. Its data model, however, is full of clever hacks that a second developer would struggle with: signed floating-point amounts, an inverted `paid` flag for loans, transfers implemented as balance-correction transactions paired by timestamp, recurring transactions implemented as a chain of rows with predictable primary keys, and sync implemented by uploading whole SQLite files to Google Drive and merging by modification time.

The Accountant made the opposite trade. Money is stored as integer cents. Transfers are a first-class transaction type with an explicit paired row and an optional fee row. Recurring transactions have a real configuration entity and a deterministic occurrence key that survives multi-device sync. Loans track partial repayment through a `paidAmount` field and post real repayment transactions. Sync is a proper delta protocol against a server with tombstones, dependency ordering, and a reconciliation flow. There is receipt OCR, an AI assistant, a rich notification system with actionable notifications, a notification inbox, server-verified in-app purchases, and per-account local databases.

But a large part of that foundation has no door on it. There is **no objectives screen** at all despite a complete service layer. The **upcoming transactions screen is unreachable**. The **category management screen is unreachable**. **Payment methods cannot be created** anywhere. **Budgets are functionally broken**: the create form writes only legacy columns, stores a category *name* where an id belongs, and the alert timer compares cents to dollars. The theme picker is reachable only from the intro slideshow. The app is dark-mode only and English only. There is no transaction detail screen, no duplicate, no bulk select, no swipe actions, no wallet detail page, no CSV import, no local backup file, no heatmap, no widgets, no deep links.

So the answer to "are we doing everything Cashew does?" is **no, not yet**, and the gap is mostly in surface area rather than in engineering depth. The good news is that closing most of the gap means building screens on top of models and services that already exist and are, in several places, better designed than Cashew's.

### Scorecard

| Area | Cashew | The Accountant | Verdict |
|---|---|---|---|
| Money representation | `REAL`, signed | integer cents, `isIncome` flag | **Ahead** |
| Transaction special types | 5 types, inverted `paid` for loans | 5 types + `none`, `paidAmount` for loans | **Ahead** on model |
| Transfers | balance-correction hack, cross-currency OK | first-class, fee support, same-currency only | **Mixed** |
| Recurring engine | row chain, created on pay | config entity, occurrence key, background job | **Ahead** on model, **Behind** on UX (no pending confirmation) |
| Loans (one-time) | settle = hide, partial converts to objective | partial repayments as real rows, settle/undo | **Ahead** on model, missing counterparty and link |
| Loans (long-term) | loan objectives, progress, difference-only | `type='loan'` objectives exist, no UI, no distinct logic | **Behind** |
| Goals/objectives | full UI, pin, archive, installments, confetti | service only, **no screen** | **Behind** |
| Wallets | derived balance, merge, correct balance, detail page | stored balance, types incl. credit card, reorder, no detail page | **Mixed** |
| Multi-currency | per-wallet, conversion in amount field, cross-currency transfer | per-wallet, rates screen with overrides, header sums unconverted | **Behind** |
| Budgets | periods, history, limits, filters, income budgets, archive | broken create flow, weekly/monthly only, no edit/delete UI | **Far behind** |
| Categories | 277 icons + emoji, merge, promote, reorder, titles editor | 31 slug-keyed defaults, subcategories, 18 icons, no reorder/merge UI | **Behind** |
| Auto-categorisation | associated titles with editor | title-history suggestions, unused `AssociatedTitles` table | **Behind** |
| Transaction list | month pager, deep filters, drag-select, bulk edit, duplicate | month strip, type + one category filter | **Far behind** |
| Search | title/note/category/budget/goal/amount/date parsing | title/notes/category/payment method | **Behind** |
| Home page | 14 reorderable sections, per-section periods | fixed order, 7 sections | **Behind** |
| Analytics | pie, line with past overlays, heatmap, history | line, pie, category bars, budget bars, PDF | **Mixed** |
| Import | CSV with mapping, Google Sheets, raw DB | none | **Missing** |
| Export | CSV, raw DB | CSV, PDF (premium) | **Parity** |
| Backup/sync | Drive whole-file backups + LWW sync | server delta sync, restore from cloud, no local file | **Ahead** on sync, **Behind** on backup |
| Notifications | daily reminder, per-transaction upcoming | daily, budget, large tx, due reminders w/ actions, inbox, push | **Ahead** |
| Security | OS lock at cold start | biometric + auto-lock timeout | **Ahead** |
| Themes | system/light/dark/black, Material You, 6 fonts | dark only, 5 premium palettes | **Behind** |
| Localization | 48 locales | English only | **Far behind** |
| Integrations | widgets, shortcuts, app links, bill splitter | none | **Missing** |
| AI / OCR | none | OCR prefill, insights, chat | **Ahead** |
| Accounts / auth | optional Google for Drive | mandatory sign-in, email/Google/Apple, per-user DB | **Mixed** (no guest mode) |
| Monetization | soft paywall, free unlock after countdown | server-verified subscriptions, hard gates | **Ahead** on infra |
| Platforms | Android, iOS, web PWA | Android shipping, iOS configured | **Behind** |

---

## 2. Transactions and transaction types

### What Cashew does

Cashew stores `amount` as a signed `REAL`. Negative is expense, positive is income, and a helper called `fixTransactionPolarity` exists because the sign occasionally drifts out of agreement with the `income` flag. Every transaction has an optional `type` from `{upcoming, subscription, repetitive, credit, debt}`; `null` means a normal transaction.

The `paid` flag is the heart of the model, and it is overloaded:

- Normal transactions are created with `paid = true`.
- Upcoming, subscription, and repetitive transactions are created with `paid = false`. They are "pending". Almost every aggregate query in Cashew filters on `paid = true`, so pending rows are invisible to balances, budgets, and goals until the user pays them.
- Credit and debt transactions **invert** the meaning: `paid = true` means "still outstanding, counts in totals", and `paid = false` means "settled, drop out of totals". This is documented in a code comment and is a well-known source of confusion.

When the user pays a pending transaction, Cashew moves `dateCreated` to *now* (unless the `markAsPaidOnOriginalDay` setting is on) and stores the original date in `originalDateDue`. Skipping sets `skipPaid = true`. Un-paying deletes and re-inserts the row.

The add-transaction page is a 5,200-line file with a guided flow: title, category, subcategory, amount. It has an arithmetic calculator in the numpad, a currency-conversion chip, attachments that upload to Google Drive and paste a link into the note, budget and goal chips, an "exclude from budgets" list, a duplicate button, and a transfer tab.

### What The Accountant does

Amount is an unsigned integer in cents, and `isIncome` carries direction. `TransactionPolicy` in `lib/core/domain/transaction_policy.dart` is the single source of truth for "does this row count", and it is consulted by wallet balance, analytics, budgets, and forecasts. That is a cleaner design than Cashew's scattered `paid = true` filters.

The row carries two type fields. `transactionType` records provenance (`regular`, `transfer`, `recurring_instance`) and `specialType` records intent (`none`, `upcoming`, `subscription`, `repetitive`, `credit`, `debt`). `isPaid` is not overloaded: for `upcoming` it means "has happened", for loans it stays `true` and settlement is tracked separately through `paidAmount`. Skipping exists per row.

The add form covers title with history suggestions, amount, category with one level of subcategories, wallet chips, date and time, notes, a three-way expense/income/transfer selector, special type chips, loan chips, recurrence settings, a budget chip row, an objective chip row, and a transfer fee. Receipt scanning prefills amount and title.

### Where Cashew is weaker and we already do better

- **Floating-point money.** Cashew's `REAL` amounts accumulate rounding error over thousands of rows. Cents are correct.
- **Overloaded `paid`.** Our `paidAmount` model is unambiguous and supports partial settlement natively.
- **Polarity drift.** Cashew needs a repair routine for sign/flag disagreement. We cannot have that bug.
- **Policy in one place.** Cashew's eligibility logic is copy-pasted across dozens of queries. Ours lives in `TransactionPolicy`.

### Where Cashew is ahead and we should catch up

- **Calculator in the amount field.** Ours is named `calculator_bottom_sheet.dart` but is a plain number field. Add real `+ − × ÷` evaluation and keep the expression alongside the result, as Cashew does.
- **Duplicate.** Cashew has it on the edit page and in bulk. We have nothing.
- **Attachments.** Cashew at least links a Drive file. Our `receiptImageUrl` column is never written locally. We should store attachments properly (see §16).
- **Exclude from specific budgets.** Cashew has `budgetFksExclude`. We have nothing equivalent.
- **Per-transaction currency conversion chip.** When the wallet's currency differs from the primary, Cashew offers a one-tap conversion.
- **Pending recurring instances.** In Cashew a subscription instance sits as an unpaid, visible "due" item until the user confirms it, and auto-pay can be turned off per type. Ours posts instances as `isPaid = true` immediately. Power users like the confirmation step. We should offer it as an option (see §3).
- **Transaction detail screen.** Cashew opens the edit page too, but it exposes duplicate, delete-pair, and type actions there. We have only Edit and Delete on long-press.

### Divergence to fix in our own code

The DB queries `getUpcomingTransactions` and `getOverdueTransactions` filter only on `isPaid`, `skipPaid`, and `date`, whereas `TransactionPolicy.isForecast` additionally requires `specialType == upcoming`. Pick one definition. The legacy `addTransaction` path still writes a category *name* into `categoryId` when the keyword matcher fires. Delete that path.

---

## 3. Recurring transactions

### What Cashew does

There is no series entity. A subscription is a transaction with `periodLength`, `reoccurrence`, and `endDate`. When the user pays or skips it, `createNewSubscriptionTransaction` copies the row forward with a **predictable primary key** of the form `<pk>::predict::N` so two devices auto-paying the same subscription produce identical rows and sync dedupes them. The `createdAnotherFutureTransaction` flag guards against double creation. On launch, `markSubscriptionsAsPaid` auto-pays overdue instances in a loop of up to fifty iterations. `subscription` and `repetitive` are processed identically; only the label and the auto-pay setting differ.

Known problems: the `custom` reoccurrence value adds zero offset and produces a duplicate date. Month arithmetic relies on Dart's overflow normalisation, so January 31 plus one month lands on March 3. Editing one instance never propagates. Instances are only created when the app is opened.

### What The Accountant does

`RecurringConfigs` holds `baseTransactionId`, `periodLength`, `reoccurrence`, `startDate`, `endDate`, `nextOccurrence`, and `isActive`. `RecurringService.processRecurringTransactions` runs on startup, hourly through WorkManager, and on demand. It materialises every due occurrence with an `occurrenceKey` of `<configId>@<UTC date>`, enforced unique locally and on the server, so multi-device generation is idempotent by construction. Month-end is clamped. Pause, resume, and cancel exist. The subscriptions dashboard normalises cost to monthly and yearly.

### Where we are ahead

Real series entity, deterministic idempotency, background generation without opening the app, month-end clamping, pause/resume. This is simply a better engine.

### Where we are behind

- **No pending confirmation.** Cashew's users see "Netflix, due today, pay?" Ours silently posts it as paid. Add a per-config `autoPost` flag. When off, generate the instance with `isPaid = false` so it appears in Upcoming and can be paid or skipped.
- **No "this and all future" edit.** Neither app has it, but ours is positioned to add it: an edit to the base transaction should optionally regenerate unpaid future instances. Cashew cannot do this at all.
- **No occurrence count** ("repeat 12 times"). Cashew computes a remaining count for display. We should store an optional `occurrenceCount` and derive `endDate` from it.
- **No day-of-week or day-of-month rule** (every second Friday, last day of month). Neither app has it. It is a differentiator.
- **Yearly Feb 29** is not clamped. Cadence changes reset `nextOccurrence` from `startDate` instead of from the last instance. `baseTransactionId` is not a foreign key and the config has no `deletedAt`. Base-to-config lookup is a linear scan.
- **Per-subscription reminder toggle.** Cashew has `upcomingTransactionNotification` per transaction. Ours is global.

---

## 4. Loans: credit and debt

This is the area where the two apps diverge most, and where we can win decisively if we finish the job.

### What Cashew does

**One-time loans** are transactions with `type = credit` (you lent, expense) or `type = debt` (you borrowed, income). They count in the wallet balance immediately. "Collect all" or "settle all" flips `paid` to `false`, which makes the transaction vanish from every total. The repayment is modelled as *nothing*: the original transaction is simply hidden. Your history no longer shows that you were ever owed money.

**Partial collection** does something surprising: it converts the one-time loan into a long-term loan objective. It creates an `Objective` of type `loan` with `amount = 0`, rewrites the original transaction to `type = null`, `objectiveLoanFk = newPk`, `name = "initial-record"`, then inserts a second transaction with inverted polarity for the amount collected.

**Long-term loans** are `Objective` rows with `type = loan`. `income = true` means lent, `income = false` means borrowed. The principal is not stored on the objective; it is a transaction tagged `objectiveLoanFk` with the opposite polarity to repayments. Progress is repayments divided by principal plus an optional offset. A "difference only" mode, behind a feature flag defaulting to off, uses the sentinel `amount = -1` to mean "no fixed principal, just track the running balance with this person". There is no explicit "paid off" state; reaching 100% is purely computed.

Cashew has a **Loans page** with one-time and long-term tabs, lent/borrowed filters, a "you get / you owe" header, and a bulk settle action. Its **bill splitter** can generate loan transactions from a split bill.

Known bugs: `getTotalTowardsObjective` uses `objectiveLoanFk` in both branches of its ternary, so the "goal reached" check for recurring transactions attached to a *goal* reads loan rows instead.

### What The Accountant does

A loan is a transaction with `specialType = credit` or `debt`. Direction is forced. It hits the wallet balance immediately. `paidAmount` tracks settlement. `recordPayment` clamps to the outstanding amount, inserts a **real repayment transaction** (income for a credit, expense for a debt) copying the parent's wallet and category, then increments `paidAmount`. `markAsSettled` posts the remainder. `markAsPending` posts a compensating reversal and resets. Due date is `originalDueDate`. WorkManager schedules a reminder per loan and the hourly task notifies up to three overdue loans. The Credit & Debt screen has All/Credit/Debt tabs, an unpaid-only toggle, net exposure, lifetime totals, per-loan progress bars, Record Payment, and Settled with Undo.

`Objectives.type = 'loan'` exists but is computed exactly like a goal and has no UI.

### Where we are ahead

- Repayments are real, dated, wallet-affecting transactions. History is preserved. Cash flow reports are correct. Cashew's "hide the row" approach loses information.
- Partial repayment is native. Cashew's conversion-to-objective is a hack.
- Overdue detection and reminders exist. Cashew has neither for loans.
- Settle and undo are symmetrical and auditable.

### Where we are behind

- **No structural link from repayment to loan.** The repayment row only carries a notes string. Add `loanTransactionId` (or a `LoanPayments` join table) so deleting a repayment can decrement `paidAmount`, so the loan detail can list its payments, and so sync stays consistent.
- **No counterparty.** Cashew's difference-only loans are keyed by person name. We have only the title. Add a `Contacts` table (name, optional phone/email, avatar) and a `contactId` on transactions. This unlocks a "People" screen: who owes me, whom I owe, running balance per person, tap to settle.
- **No long-term or running-balance loans.** The "I keep lending my brother money and he keeps paying some back" case is Cashew's difference-only loan. With a `Contacts` table we get it for free: per-person net balance is just a query.
- **No interest, no instalment schedule.** Neither app has these. A `LoanSchedule` (principal, rate, term, frequency) generating expected instalments as upcoming transactions would put us clearly ahead.
- **No bill splitter.** Cashew's generates loan transactions directly.
- **Stale query.** `getUnpaidCreditDebtTransactions` still filters on `isPaid = false`, contradicting the `paidAmount` policy. Remove it.

---

## 5. Objectives and goals

### What Cashew does

Full feature. Savings goals (`income = true`) and spending goals. Name, icon or emoji, colour, amount, start date, optional end date, wallet for currency, pinned by default. Transactions link via `objectiveFk` from the add page. Detail page with circular progress, spent-vs-remaining toggle, status against end date, confetti at 100%, filtered transaction list, FAB to add an attached transaction. Edit page with reorder, search, archive, delete with optional detach. An **installments** helper computes payment count or per-payment amount and can create a recurring transaction that stops when the goal is reached. Pinned goals appear on the home page. Second goal per type is premium-gated.

### What The Accountant does

`Objectives` table and `ObjectivesService` with progress percent, daily target, projected completion, pin, archive, free-tier limit of two. Transactions link via `objectiveId`. **There is no screen.** `createObjective` is never called from UI. The objective chip row in the add form is always empty.

Progress sums raw `amount` regardless of direction, paid status, or transfer type, which will be wrong the moment a UI exists.

### What to do

Build the screens (list, detail, add/edit, archive) and fix progress to use `TransactionPolicy`. Add the installments helper. Then go past Cashew: goal contributions from a specific wallet, automatic "round-up" or "percentage of income" contribution rules, goal completion notifications, and goal progress on the dashboard.

---

## 6. Wallets, currencies, and transfers

### What Cashew does

Balance is **never stored**. Every read sums paid transactions per wallet, converted to the primary currency by a rate table. This is always consistent and never drifts, at the cost of an aggregate query per render. Wallet `"0"` is the reserved primary; deleting it copies the next wallet onto that key. Wallets have name, colour, icon, currency, decimals, order, and a list of which home widgets show them. Actions: merge into another wallet (with currency conversion of moved transactions), correct balance (posts an adjusting transaction in the reserved balance-correction category), transfer, reorder, set primary. The **wallet detail page** is 3,000 lines: totals grid, pie, line graph, current and history tabs, filters, and the same page with `wallet = null` is the global "All Spending" view.

Transfers are two transactions in the balance-correction category linked by `pairedTransactionFk`, with a fallback that pairs rows by "same category, opposite sign, within one second". Cross-currency transfers convert at the current rate. Seconds are forced to `:30`/`:31` for deterministic ordering. Transfer fee code exists but is commented out.

Exchange rates come from the `fawazahmed0/currency-api` CDN, cached, with per-currency custom overrides and custom currencies. Primary currency is the primary wallet's currency.

### What The Accountant does

Balance is **stored** on the wallet alongside `openingBalance`. Two update paths exist: a blind delta for creates and mark-paid, and a full recompute for updates and deletes. After every sync pull the server's balance is discarded and recomputed locally. Wallet types are cash, bank, credit card (with `creditLimit` and `billingCycleDay`, display only), and subscription. Reorder, set default, edit, delete with cascade. No archive, no exclude-from-total, no detail page. The management header sums balances **without** currency conversion.

Transfers are first-class: `transactionType = transfer`, reciprocal `pairedTransactionId`, system Transfer category, optional third fee row linked by `feeForTransactionId`, atomic update and delete of all legs, integrity validator, reconciler. Cross-currency transfers are refused.

Exchange rates come from the same CDN, cached six hours, with a rates screen and manual overrides persisted in a table.

### Where we are ahead

- Explicit transfer type with a fee row. Cashew's category-`"0"` hack and one-second pairing heuristic are fragile; ours is structural.
- Wallet types and credit-card metadata. Cashew has none.
- A rates screen with persisted overrides.

### Where we are behind

- **Cross-currency transfers.** Refusing them is a real gap for anyone with a USD and a BDT account. Store `fxRate` and the counter-leg amount on the transfer, convert at the current rate by default, let the user override the received amount, and treat the difference as an implicit FX gain/loss line.
- **Wallet detail page.** None exists. Cashew's is one of its best screens.
- **All Spending view** across wallets with period picker.
- **Correct balance** action. Ours has a `balance_correction` system category but no UI that posts to it.
- **Merge wallets.** Cashew moves and converts transactions. We only delete with cascade.
- **Archive and exclude-from-net-worth flags.** Neither exists in our schema.
- **Header total unconverted.** Known and commented. Fix it.
- **Credit card billing logic.** `billingCycleDay` is stored but unused. Statement periods, due-date reminders, and "pay statement" as a transfer would be a differentiator.

### Balance storage: which approach is right?

Cashew's derived balance is always correct but scales linearly with transaction count on every render. Our stored balance is fast but has two write paths and a documented history of drift (the schema-10 migration existed to repair it). Recommendation: keep the stored value as a **cache**, but funnel every mutation through one code path that recomputes inside the same DB transaction, drop the blind-delta path, and add a startup integrity check that recomputes and logs any mismatch. That gives Cashew's correctness with our speed.

---

## 7. Budgets

### What Cashew does

Budgets are the centre of Cashew. A budget has an amount, a colour, a **recurrence** (`custom` one-off range, or daily/weekly/monthly/yearly with a `periodLength` such as "every 2 weeks") anchored on a start date, included and excluded categories, a wallet filter, an `income` flag for savings budgets, an `addedTransactionsOnly` mode where only explicitly attached transactions count, a set of transaction filters (include income, include loans, include balance corrections, exclude rows already in another budget or goal), pin, archive, and order.

The budget detail page steps through **past periods** with arrows (premium), shows a category pie and per-category rows with over-limit colouring, a daily or cumulative **line graph with previous periods overlaid** and a pro-rated target line, and a "today" marker. **Category spending limits** live in their own table and can be absolute money or a percentage of the budget, with subcategory limits as a percentage of the parent's limit. **Budget history** graphs totals across periods, shows average spent, and overlays "watched categories" over time. The list shows progress, a today pace marker, "N per day for M more days", and shakes when over. Shared budgets via Firestore are fully coded but hard-disabled. There is no rollover.

### What The Accountant does

The schema is nearly as rich: `amount`, `period` (weekly/monthly/yearly/custom), `startDate`, `endDate`, `walletIds` and `categoryIds` JSON arrays, `isIncome`, `isPinned`, `isArchived`. **Almost none of it is used.** The create form offers weekly or monthly with hard-coded seven or thirty day windows, one expense category chosen by name from a constants list, and writes the legacy `limit` (dollars) and `categoryId` (the *name*) columns. `amount` is a required column with no default and is not written. Computation uses `amount` and the legacy `categoryId` only, ignoring the arrays. The hourly alert compares spent cents against a dollar `limit`, so it fires about a hundred times too early. There is no edit or delete UI (the methods exist), no detail page, no history, no per-category limit.

### What to do

This is the single largest gap and the one users will hit first. Rewrite the budget feature end to end on the existing schema:

1. **Create/edit** with recurrence and period length, multi-category include and exclude, wallet scope, income budgets, colour, pin, archive. Write `amount` in cents and the JSON arrays. Delete the `limit` and single-`categoryId` paths.
2. **Computation** through `TransactionPolicy`, honouring the arrays, with a period resolver that maps any date to its budget window (Cashew's `getBudgetDate` is the reference).
3. **Detail page** with period navigation, category breakdown, daily/cumulative graph with previous-period overlay, and pace text.
4. **Category limits** table, absolute or percentage.
5. **History** page across periods.
6. **Alerts** in cents, at the user's threshold, once per period, plus an "exceeded" alert. We already have the notification plumbing Cashew lacks.

Then surpass Cashew:

- **Rollover** of unspent amount into the next period, opt-in per budget.
- **Envelope mode**: budgets funded from a wallet, with transfers between envelopes.
- **Forecast**: "at this pace you will end the month N over" using upcoming and recurring instances, which our engine already knows about and Cashew's does not.

---

## 8. Categories and auto-categorisation

### What Cashew does

Eleven default categories plus the reserved balance-correction category. Categories have an icon from a searchable library of **277 PNG icons** or an **emoji**, one of fourteen preset colours or a custom colour (premium), an income/expense flag, and an optional parent for subcategories. Management supports reorder, search, delete with merge into another category, and promoting a subcategory to a main category. Selecting a category in the add flow flips income/expense to the category's default.

**Associated titles** map a title substring to a category. Typing "pineapple" matches a stored "apple" title. Titles are learnt automatically on every save and are editable in their own page with reorder and search. Category and subcategory names also match while typing.

### What The Accountant does

Thirty-one defaults (18 expense, 11 income, 2 system) identified by stable `defaultKey` slugs, which is how cross-device merging stays sane. One level of subcategories. Fourteen colours, **eighteen** icons. Defaults cannot be deleted. Duplicate defaults are merged automatically. No reorder UI, no user-facing merge, and the management screen is only reachable from dead code; real management happens inline from the picker.

Auto-categorisation is title-history based: typing shows up to four previously used titles and tapping fills the title and its last category. An `AssociatedTitles` table and DAO exist with exact and contains matching, and the backend has endpoints for it, but no UI manages rules. A separate keyword `CategoryAssignmentService` is dead code.

### Where we are ahead

Slug-keyed defaults with a reconciliation flow is the right way to sync categories across devices. Cashew relies on hard-coded primary keys `"1"` to `"11"` and last-write-wins.

### Where we are behind

- **Icon library.** Eighteen versus 277 plus emoji. Add emoji support (free, zero assets) and expand the icon registry.
- **Category management screen.** Wire it up. Add reorder, merge, promote-to-main, and delete-with-move.
- **Associated titles editor.** The table exists. Build the screen and use it in the title suggestions.
- **Custom colour picker.**
- **Income/expense flip on category select.** The `isIncome` flag exists on categories but the UI ignores it.

---

## 9. Transaction list, search, filters, and bulk actions

### What Cashew does

The transactions page is a month pager with a sticky month selector, a per-month spending summary, and persisted filters. Search is debounced and understands titles, notes, category, subcategory, budget, goal, and loan names, numeric queries as amount bands, and month names as date filters. The filter sheet covers wallets, categories, subcategories (including "none"), budgets (including "none"), excluded budgets, goals, loans, income/expense, paid status (paid, not paid, skipped), transaction types, method added, an amount range slider bounded by the real min and max, and a date range.

Selection is by long-press or **drag across rows**. The selection bar shows the live total, and offers share/copy summary, delete, select all, **duplicate**, and **bulk edit** of date, title, category, account, budget, goal, or loan. An **activity log** shows the last thirty modified and thirty deleted transactions and can **restore** deleted ones.

### What The Accountant does

Month strip with swipeable month pages, day grouping, search over title, notes, category, and payment method, a filter sheet with type and a single category. No wallet, date-range, amount, or paid filters. No sort. No swipe actions. No multi-select. No bulk actions. No duplicate. No detail screen. No undo except on mark-paid. The whole table is loaded into memory.

### What to do

This is the second-largest gap and affects daily use.

- Filter sheet with wallets, multiple categories, subcategories, date range, amount range, paid status, special type, budget, objective, and transfer visibility. Persist it.
- Search that parses amounts and dates like Cashew's.
- Multi-select with bulk delete, bulk category, bulk wallet, bulk date, bulk budget/objective, and **bulk mark paid**, which Cashew does not have.
- Duplicate.
- Swipe actions (Cashew has none; quick delete and quick duplicate on swipe would be a differentiator).
- A transaction detail screen with all actions and, later, attachments and the loan payment list.
- Recently deleted with restore, backed by our soft-delete column, which Cashew lacks (it keeps a list in SharedPreferences).
- Pagination or windowing for large tables.

---

## 10. Home page

### What Cashew does

Fourteen sections, each toggleable and reorderable from an edit page with drag handles, with a separate order for wide screens that assigns sections to left and right panels: greeting, wallet switcher, wallet list, budgets carousel, upcoming/overdue, spending summary, net worth, goals, loans, long-term loans, line graph, pie chart, heatmap, and a transactions list. Most sections have their own period picker (all time, cycle, past days, date range). Pull-down triggers a Drive sync. A rating prompt appears every thirteenth launch.

### What The Accountant does

Seven sections in a fixed order: greeting, wallet cards with per-wallet balance masking, income and expense stat cards, credit/debt and subscription cards, one line chart, recent transactions, budget progress. Pull to refresh. Tablet layout is two columns. The quick-action grid is commented out. An unused hero balance card exists.

### What to do

Add a home layout preference (ordered list of section ids with visibility) and an edit screen. Then add sections we already have data for: upcoming and overdue totals, net worth (converted), objectives, and a heatmap. Per-section period pickers can follow.

---

## 11. Analytics and reports

### What Cashew does

Pie charts (budget, home, wallet), line graphs (daily or cumulative, past periods faded behind, pro-rated target), a **heatmap** calendar of daily net with four intensity buckets, budget history across periods with watched categories, and a wallet/All Spending page with current and history tabs. No bar chart in use, no net-worth-over-time, no calendar view, no report export.

### What The Accountant does

Reports tab with week (free), month, and year (premium) timeframes, expense line, income line (which reuses the expense series, a bug), category pie, category breakdown bars (always current month regardless of timeframe), budget-versus-actual bars, and a "Spending Insights" monthly summary with templated advice (which shows raw category UUIDs). CSV export is free, **PDF report** is premium. Growth percent is the same number for spent, earned, and net.

### Where we are ahead

PDF export. Cashew has none.

### Where we are behind

Heatmap, past-period overlays, category-over-time, wallet history. Fix the income series, the fixed-month category breakdown, the UUIDs, and the growth percent first, then add heatmap and net worth over time (which neither app has).

---

## 12. Import, export, backup, and sync

### What Cashew does

**CSV import** with charset detection, header detection, a column mapping sheet, custom date format with live preview and common-format fallback, auto-creation of missing categories and wallets, sign handling for bank exports, and title learning. **Google Sheets** import via a public share URL. Raw SQLite export and import. CSV export.

**Backup** to Google Drive's hidden app folder, automatic every three days by default, with a list to download, delete, or restore. **Sync** uploads one SQLite file per device; on sync the app downloads other devices' files, opens them as a second database, and applies rows changed since the last sync plus a `DeleteLogs` tombstone table, last-write-wins on `dateTimeModified`. Nulls overwrite. It depends entirely on device clocks and downloads whole databases.

### What The Accountant does

**Sync** is a premium delta protocol: push pending rows in dependency order in chunks, pull with parent checks and cursor hold-back on failure, soft-delete tombstones, idempotent creates, conflict per record, a category reconciliation flow, an ownership check between the JWT and the local store, and a full "Restore from Cloud" that applies atomically. Conflict resolution is still timestamp last-write-wins on client-supplied `updatedAt`.

There is **no local backup file**, **no import** of any kind, and no Drive integration. Sync is premium, so a free user has no backup path at all except CSV export, which cannot be re-imported.

### What to do

- **Local backup and restore** (JSON or the SQLite file) to the device and to the share sheet, free. This is a trust feature; a free user must be able to get their data out and back in.
- **CSV import** with a mapping sheet and, beyond Cashew, **saved mapping templates** per bank.
- **Server-assigned version counters** instead of client timestamps for conflict detection. The infrastructure is already there; `SyncStatus.conflict` is defined and never assigned.
- Optionally, Google Drive as a free backup target for parity.

---

## 13. Notifications

### What Cashew does

A daily reminder with three modes (if app not opened, a day from last open, every day), scheduled fourteen days ahead with twenty-six random messages, and per-transaction upcoming notifications scheduled up to a year ahead. Tapping opens the add page or the scheduled page. **No budget alerts.** Nothing on web.

### What The Accountant does

Daily reminder at a chosen time, budget warnings (buggy units), recurring processed, upcoming due, overdue loans, per-loan due reminders with snooze and skip actions handled in a background isolate, large-transaction alerts, subscription-expiry, and FCM push, all with an inbox with unread badge, mark read, and preferences synced to the server. **Tap navigation is not implemented.** The debug section ships to users.

### Verdict

We are clearly ahead. Fix the budget units, implement tap-to-navigate, add per-transaction reminder toggles, and add quiet hours. Then this area is a genuine selling point.

---

## 14. Security, appearance, and localisation

| | Cashew | The Accountant |
|---|---|---|
| Lock | OS biometric or credential at cold start only | Biometric with auto-lock timeout; no PIN fallback |
| Theme mode | System, light, dark, true black | Dark only; light theme defined but unselectable |
| Accent | Material You or custom accent colour | 5 premium palettes; picker only reachable from intro |
| Fonts | 6 choices | Inter + JetBrains Mono, fixed |
| Number format | Custom delimiter, decimal, symbol position, compact numbers, percent precision | 4 coupled presets, symbol always prefix |
| Time and week | 12/24h, first day of week | Neither |
| Languages | 48 | 1 |

Localisation is the widest single gap and also the cheapest to start: wire up `flutter_localizations` and `.arb` files now, before more screens are written in hard-coded English. Add light and system theme modes, put the theme screen in Settings, and add a PIN fallback to the lock screen.

---

## 15. Integrations and tools

Cashew has: Android home-screen widgets (transaction shortcut, transfer shortcut, net total, net total wide), app shortcuts (add, transfer, one per budget), HTTPS app links that create or prefill transactions including a JSON batch form, a bill splitter that outputs loan transactions, and debug-gated notification-listener and Gmail parsing.

The Accountant has none of these. It has an in-app update check and a walkthrough.

Priority order: app shortcuts and deep links (cheap, high daily value), then Android and iOS widgets (Cashew has no iOS widget, so that is a differentiator), then a bill splitter that uses our `Contacts` table (§4) so each split becomes a tracked loan per person.

---

## 16. Data model changes recommended

These are the schema additions that unlock the roadmap. All are additive and sync-friendly.

| Table / column | Purpose |
|---|---|
| `Contacts` (id, name, phone?, email?, avatar?, notes) | Counterparty for loans, bill splits, "People" screen |
| `Transactions.contactId` | Link any transaction to a person |
| `Transactions.loanTransactionId` | Structural link from repayment to loan |
| `Transactions.fxRate`, `Transactions.counterAmount` | Cross-currency transfers with recorded rate |
| `Transactions.excludedBudgetIds` (JSON) | Exclude from specific budgets |
| `Tags`, `TransactionTags` | Free-form labels; neither app has them |
| `Attachments` (id, transactionId, localPath, remoteUrl?, mime, size) | Receipts and files stored properly |
| `TransactionSplits` (id, transactionId, categoryId, amount) | One purchase across several categories; neither app has it |
| `Wallets.isArchived`, `Wallets.excludeFromTotal` | Hide old accounts, exclude from net worth |
| `RecurringConfigs.autoPost`, `occurrenceCount`, `dayRule` | Pending confirmation, fixed count, weekday/month-day rules |
| `CategoryBudgetLimits` (budgetId, categoryId, amount, isPercent) | Per-category limits inside a budget |
| `Budgets.rollover` | Carry unspent into next period |
| `LoanSchedules` (loanId, principal, rate, termMonths, frequency) | Interest and instalments |
| `HomeLayout` in Settings (JSON) | Section order and visibility |
| `AssociatedTitles` (already exists) | Wire the UI |

Columns to retire: `Transactions.type`, `paymentMethod`, `isRecurring`, `recurrencePattern`; `Categories.type`; `Budgets.limit`, `Budgets.categoryId`; the `ObjectiveTransactions` table; the never-populated `serverId` columns.

---

## 17. Cashew design problems we can avoid or fix better

Collected in one place so they inform our design rather than get copied.

1. **Signed floating-point amounts** with a polarity repair routine. We use cents and a flag.
2. **Inverted `paid` on loans.** We use `paidAmount`.
3. **Loan settlement hides the row.** We post repayments.
4. **Partial loan payment mutates the loan into an objective** and renames the original row to `initial-record`. We keep the loan and link payments.
5. **Sentinel `amount = -1`** for difference-only loans. We model running balances per contact.
6. **Transfers as balance corrections** with a one-second pairing heuristic and forced seconds for ordering. We have an explicit type and pair id.
7. **Recurring rows chained by predictable keys**, created only when the previous one is paid, only when the app is open. We have a config entity and a background job.
8. **`custom` recurrence adds zero offset**; month overflow lands on the wrong day. We clamp.
9. **Reserved primary keys** `"0"` for the primary wallet and balance-correction category, with a copy-onto-`"0"` hack on delete. We use UUIDs and slugs.
10. **Whole-database sync** by device file, merged by client clock, nulls overwrite. We do delta sync with tombstones.
11. **Eligibility logic copy-pasted** into dozens of queries. We centralise it in `TransactionPolicy`.
12. **Settings as one JSON blob** in SharedPreferences mirrored to a one-row table. We have typed settings and server-synced preferences.
13. **`getTotalTowardsObjective` bug** reading loan rows for goals. Our objective progress must use `TransactionPolicy` to avoid the equivalent mistake.
14. **No budget notifications.** We have the plumbing; we need to fix the units.
15. **Premium enforced locally** with a countdown bypass. Ours is server-verified.

---

## 18. Our own defects found during this analysis

Not about Cashew, but they surfaced while reading and should be fixed before any new feature work.

- Budget create writes `limit` in dollars and the category *name* as `categoryId`; `amount` is never written. Budget alert compares cents to dollars. No edit or delete UI.
- No objectives screen. Objective progress ignores direction and paid state.
- Upcoming transactions screen, category management screen, support ticket screen, and theme screen (from Settings) are unreachable.
- Payment methods have no creation UI.
- Hard-coded `$` in Upcoming, Subscriptions, Budgets, and Insights summaries.
- Monthly summary displays category UUIDs.
- Reports "Income" chart reuses the expense series; growth percent is identical across metrics; category breakdown ignores the selected timeframe.
- Two disagreeing price tables (`product_ids.dart` vs `premium_screen.dart`). Premium gate copy says "One-time purchase" while selling subscriptions.
- Wallet management header sums unconverted.
- Legacy `addTransaction` path writes a category name into `categoryId`.
- Loan repayments have no structural link to the loan; `getUnpaidCreditDebtTransactions` uses the wrong settlement rule.
- Notification tap navigation not implemented; debug notification section visible to users.
- `receiptImageUrl` never written locally.
- Objective and payment-method free-tier limits throw without a dialog.
- `README.md` and `CLAUDE.md` describe Gemini and FastAPI; the app uses on-device ML Kit, a self-hosted OpenAI-compatible gateway, and ASP.NET Core.

---

## 19. Roadmap

### Phase 0: repair what exists (foundation)

Fix everything in §18. Wire the unreachable screens. Rewrite budgets on the existing schema (§7 steps 1, 2, 6). Build the objectives screens. Add the repayment link and the `Contacts` table. Start localisation scaffolding. Add light and system themes and move the theme picker into Settings.

### Phase 1: reach parity on daily-use surfaces

Transaction filters, search parsing, multi-select and bulk edit, duplicate, detail screen, recently deleted. Wallet detail page and All Spending. Cross-currency transfers. Category management with reorder, merge, emoji, larger icon set, and the associated-titles editor. Budget detail with periods, limits, and history. Home page layout editor. Local backup and restore. CSV import. Heatmap. Calculator in the amount field. Pending confirmation option for recurring instances.

### Phase 2: surpass

People screen with per-contact running balances. Loan schedules with interest. Bill splitter that generates per-person loans. Tags. Split transactions. Attachments stored locally and synced. Rollover and envelope budgets. Budget forecasts using upcoming and recurring data. Net worth over time. Calendar view. Recurring rules by weekday and month-day, occurrence counts, and "this and future" edits. Credit-card statement cycles. App shortcuts, deep links, Android and iOS widgets. Quiet hours and tap-to-navigate notifications. PIN fallback. Guest mode with later account upgrade. Saved CSV mapping templates. Translations.

---

## 20. Open questions

1. **Guest mode.** Cashew never requires an account. Ours requires sign-in before anything works. Do you want a local-only mode with an optional upgrade to an account later, or is mandatory sign-in a deliberate product decision?
2. **Free-tier backup.** Sync is premium. Should a local backup file be free so that free users are never locked in?
3. **Recurring confirmation.** Should the default for new subscriptions be "post automatically" (current) or "ask me" (Cashew), with the other as an option?
4. **Long-term loans.** Do you want a separate "long-term loan" concept like Cashew's, or is the `Contacts` running-balance model enough?
5. **Platforms.** Is web a target? Cashew ships a PWA. Several of our plugins are mobile-only.
6. **Localisation.** Which languages first? Bangla and English would be the obvious starting pair.
7. **"Proper texts."** This document interprets that as a properly written analysis. If you meant user-facing copy (onboarding, empty states, feature explanations, the ⓘ popups Cashew has for each transaction type), say so and it can be written next.

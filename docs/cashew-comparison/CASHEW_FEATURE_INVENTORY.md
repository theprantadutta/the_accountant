# Cashew: Feature Inventory (from code)

Source: https://github.com/jameskokoska/Cashew. Version inventoried: `pubspec.yaml` → `5.4.3+416`; DB `schemaVersionGlobal = 46` (`lib/database/tables.dart`). All `lib/...` paths are relative to the repo's `budget/` folder. Sources read: `README.md`, `promotional/` listing, `lib/main.dart`, `lib/pages/**`, `lib/widgets/**`, `lib/struct/**`, `lib/database/tables.dart`, `android/app/src/main/AndroidManifest.xml`, `assets/`.

## 0. `lib/pages` directory listing (42 files + `homePage/`)

```
aboutPage.dart              addWalletPage.dart              editBudgetLimitsPage.dart     objectivesListPage.dart
accountsPage.dart           autoTransactionsPageEmail.dart  editBudgetPage.dart           onBoardingPage.dart
activityPage.dart           billSplitter.dart               editCategoriesPage.dart       pastBudgetsPage.dart
addAssociatedTitlePage.dart budgetPage.dart                 editHomePage.dart             premiumPage.dart
addBudgetPage.dart          budgetsListPage.dart            editObjectivesPage.dart       settingsPage.dart
addButton.dart              creditDebtTransactionsPage.dart editWalletsPage.dart          sharedBudgetSettings.dart
addCategoryPage.dart        debugPage.dart                  exchangeRatesPage.dart        subscriptionsPage.dart
addEmailTemplate.dart       detailedChangelogPage.dart      notificationsPage.dart        transactionFilters.dart
addObjectivePage.dart       editAssociatedTitlesPage.dart   objectivePage.dart            transactionsListPage.dart
addTransactionPage.dart                                                                   transactionsSearchPage.dart
                                                                                          upcomingOverdueTransactionsPage.dart
                                                                                          walletDetailsPage.dart
homePage/: homePage, homePageAllSpendingSummary, homePageBudgets, homePageCreditDebts, homePageHeatmap,
           homePageLineGraph, homePageNetWorth, homePageObjectives, homePagePieChart,
           homePageUpcomingTransactions, homePageUsername, homePageWalletList, homePageWalletSwitcher, homeTransactions
```

`promotional/` contains only store assets: `AppStore/` (iPad, iPhone 5.5, iPhone 6.7 screenshots), `PlayStore/` (phone/tablet/Chromebook screenshots, feature graphics, icon512), `GitHub/SocialPreviewGitHub.png`, `icons/`, `store-banners/` (App Store, Google Play, GitHub, PWA badges), `youtube-promo/`, `play-store-feature/`, `material-apps-feature/`.

---

## 1. Platform, architecture, offline behaviour

- **Platforms built**: `android/`, `ios/`, `web/` only; no `windows/`, `macos/`, `linux/` folders. Distributed on App Store, Google Play, GitHub releases, and as a PWA (`README.md`). `web/` bundles `sql-wasm.js/.wasm` for SQLite-in-browser.
- **Stack**: Flutter + Drift (SQLite) local DB, `shared_preferences` for settings (also mirrored into the `AppSettings` DB table so settings ride along in backups), Firebase (`firebase_core`, `firebase_auth`, `cloud_firestore`) used only for shared budgets (disabled) and anonymous feedback submission, `googleapis` for Drive/Gmail (`lib/main.dart`, `lib/struct/firebaseAuthGlobal.dart`, `lib/widgets/accountAndBackup.dart`).
- **Offline-first**: every read/write is local Drift; network is only used for exchange rates (`lib/struct/currencyFunctions.dart`), Drive backup/sync, Google Sheets CSV fetch, IAP, and feedback. Exchange rates fall back to the cached map, then to `1` (`getCurrencyExchangeRate`, `currencyFunctions.dart:110`).
- **Platform detection**: `getPlatform({ignoreEmulation})` in `lib/functions.dart:1342` returns `isIOS | isAndroid | web`; a debug `iOSEmulate` flag can force iOS styling.
- **Web-disabled**: notifications (`notificationsGlobalEnabled = kIsWeb == false`), biometrics (forced off), quick actions, home-screen widgets, IAP/premium popups. Web-only: `syncEveryChange` toggle.
- **Boot sequence** (`lib/main.dart`): Firebase init → EasyLocalization → SharedPreferences → `constructDb('db')` → `initializeNotifications()` → load currency + language-name JSON → `initializeSettings()` → timezone → `setHighRefreshRate()` → `runApp(DevicePreview → InitializeLocalizations → RestartApp → InitializeApp)`. `MaterialApp.builder` nests `OnAppResume → InitializeBiometrics → InitializeNotificationService → InitializeAppLinks → WatchForDayChange → WatchSelectedWalletPk → WatchAllWallets`. Post-launch work (changelog, sync, auto-pay, notification scheduling) happens in `PageNavigationFrameworkState.initState` (`lib/widgets/navigationFramework.dart`).
- **Global keyboard shortcuts** (`lib/struct/keyboardIntents.dart`): `Esc` pops the route or returns to page 0; `Ctrl+1..4` switch bottom-nav pages.
- **Bundled forks**: `packages/sliding_sheet-0.5.2-modified`, `packages/implicitly_animated_reorderable_list-0.4.2-modified`; also a forked `file_picker` and `reorderable_grid_view` (`pubspec.yaml`).

---

## 2. Home page and its customizable sections

`lib/pages/homePage/homePage.dart` renders sections from `Map<String, Widget?> homePageSections` in the order stored in `homePageOrder` (phone) or `homePageOrderFullScreen` (wide screens, split by sentinel keys `ORDER:LEFT` / `ORDER:RIGHT` into a top-centre column plus two side panels). Each section is gated by `show<Section>` / `show<Section>FullScreen` settings. The whole page is wrapped in `SwipeToSelectTransactions` and `PullDownToRefreshSync` (pull-down = Google Drive sync when signed in).

| Section key | Widget / file | What it shows | Options |
|---|---|---|---|
| username banner | `HomePageUsername` (`homePageUsername.dart`) | Greeting + large tappable username (tap to edit); shrinks on scroll; seasonal `santa-hat.png`/`party-hat.png` overlay from `assets/icons/fun/` in late December / Jan 1 | `username`, `enableGreetingMessage`, `showUsernameWelcomeBanner` |
| `wallets` | `HomePageWalletSwitcher` | Horizontal account cards for wallets pinned to `HomePageWidgetDisplay.WalletSwitcher`; tap selects the primary account and everything converts to its currency | `EditHomePagePinnedWalletsPopup` pins/unpins accounts, long-press edits account |
| `walletsList` | `HomePageWalletList` | Vertical list of pinned account totals; optional per-currency breakdown section | `walletsListCurrencyBreakdown` |
| `budgets` | `HomePageBudgets` | Carousel (phone) / horizontal list (wide) of pinned `BudgetContainer`s | `EditHomePagePinnedBudgetsPopup` + `TotalSpentToggle` |
| `overdueUpcoming` | `HomePageUpcomingTransactions` | "upcoming" and "overdue" totals with counts, auto-refreshing every 5 s | period cycle picker (`cycleSettingsExtension: "OverdueUpcoming"`) |
| `allSpendingSummary` | `HomePageAllSpendingSummary` | Side-by-side expense and income totals for a period; tap → filtered search | `WalletPickerPeriodCycle` (accounts + period) |
| `netWorth` | `HomePageNetWorth` | Single net-worth figure (all accounts or pinned accounts), optional green/red colouring; tap → All Spending page | `netWorthAllWallets`, `netTotalsColorful`, period cycle; also feeds the Android widget |
| `objectives` | `HomePageObjectives(goal)` | Pinned goals with circular progress | `EditHomePagePinnedGoalsPopup` |
| `creditDebts` | `HomePageCreditDebts` | "lent" and "borrowed" totals (one-time + long-term loans) | period cycle (`CreditDebts`) |
| `objectiveLoans` | `HomePageObjectives(loan)` | Pinned long-term loans; separate card for "difference-only" loans when that flag is on | `longTermLoansDifferenceFeature` |
| `spendingGraph` | `HomePageLineGraph` | Line graph: last 30 days, all time, custom start date, or a chosen budget's graph | `LineGraphDisplay { Default30Days, CustomStartDate, Budget, AllTime }`, `showCumulativeSpending`, `ignorePastAmountSpent` |
| `pieChart` | `HomePagePieChart` | Two swipeable pie pages (outgoing/incoming) with category list, percent-of-total, subcategory expansion; tap → filtered search | `pieChartTotal`, `pieChartIncomeAndExpenseOnly`, `pieChartAllWallets`, period cycle |
| `heatMap` | `HomePageHeatMap` | GitHub-style daily heatmap, 5 months (10 on wide), "view more" loads more; colour = net daily amount, red/green with 4 intensity buckets | `firstDayOfWeek` |
| `transactionsList` | `HomeTransactions` (`homeTransactions.dart`) | Transactions from 1 month back to N days ahead (max 7 past days, 50/day), with all/outgoing/incoming or income/expense selector + "view all" button | `futureTransactionDaysHomePage` (0/1/4/7/14), `homePageTransactionsListIncomeAndExpenseOnly` |

- **Edit home page** (`lib/pages/editHomePage.dart`): `SliverReorderableList` with drag handles to reorder; per-row switch to show/hide; tapping a row opens that section's settings; `PanelSectionSeparator` rows for left/right panel assignment on wide layouts; `fixHomePageOrder()` repairs saved order on each launch.
- **Rating box** (`HomePageRatingBox`, `homePage.dart`): every 13th launch, "enjoying Cashew?" stars; ≥4 opens store listing (`appStoreId 6463662930`), <4 opens feedback form; hidden on web.
- **Per-section period cycles** (`lib/widgets/periodCyclePicker.dart`): `CycleType { allTime, cycle, pastDays, dateRange }`, stored with a suffix per section (`selectedPeriodCycleType<Ext>`, `cyclePeriodLength<Ext>`, `cycleReoccurrence<Ext>`, `cycleStartDate<Ext>`, `customPeriodStartDate<Ext>`, `customPeriodEndDate<Ext>`, `customPeriodPastDays<Ext>` for `PieChart`, `NetWorth`, `AllSpendingSummary`, `OverdueUpcoming`, `CreditDebts`, and the unsuffixed set for All Spending).

## 3. Navigation

- **Bottom nav** (`lib/widgets/bottomNavBar.dart`, `lib/struct/navBarIconsData.dart`): 4 slots: 3 customizable (`customNavBarShortcut0/1/2`, defaults home / transactions / budgets) + fixed "more". Long-press a slot → `SelectNavBarShortcutPopup` choosing from home, transactions, budgets, goals, allSpending, subscriptions, scheduled, loans (with inline settings gears). Android uses Material 3 `NavigationBar`, iOS a custom row. Tapping the active tab scrolls to top.
- **Navigation framework** (`lib/widgets/navigationFramework.dart`): `LazyIndexedStack` of 4 primary + 14 extended pages; FAB on pages 0/1/2/14; `HandleWillPopScope`: Back deselects selection → returns to page 0 → exits app.
- **Sidebar on wide screens** (`lib/widgets/navigationSidebar.dart`): collapsible rail/expanded (`expandedNavigationSidebar`), clock (tap → date picker), page buttons, edit-data buttons, Google account, settings, about, `SyncButton` with last-sync time.
- **"More" page** (`MoreActionsPage`, `lib/pages/settingsPage.dart`): premium banner + tiles for Settings, All Spending, About, Feedback, Notifications (or Bill Splitter), Google login, Subscriptions, Scheduled, Goals, Loans, Accounts/Budgets/Categories/Titles; FAQ link in overflow.

---

## 4. Add / edit transaction (`lib/pages/addTransactionPage.dart`, 5,207 lines)

- **Single page for create and edit**; accepts pre-seeds (`selectedBudget`, `selectedType`, `selectedObjective`, `selectedIncome`, `selectedAmount`, `selectedTitle`, `selectedCategory`, `selectedSubCategory`, `selectedWallet`, `selectedDate`, `selectedNotes`, `transferBalancePopup`) used by app links, widgets, notifications and quick actions.
- **Guided add sequence**: on new transaction, title popup (if `askForTransactionTitle`) → category → subcategory (if any) → amount numpad with "add-transaction" button that saves and pops. Budget (`SelectAddedBudget`) and goal (`SelectObjective`) chips are embedded in the category step.
- **Title with auto-category** (`TitleInput`, ~line 4891; `database.getSimilarAssociatedTitles`, `tables.dart:2011`): live `LIKE %text%` suggestions (3, or 5 on wide screens) from `AssociatedTitles` (most-recently-used first) and from category/subcategory names; `TitleType { TitleExists, CategoryName, SubCategoryName, PartialTitleExists }`. Tapping sets category (+subcategory) and fills title. On save, `addAssociatedTitles` learns the association when `autoAddAssociatedTitles` is on.
- **Amount numpad with calculator** (`lib/widgets/selectAmount.dart`): `÷ × − +`, decimals limited by the wallet's `decimals`, evaluated with `math_expressions`; optional `00`/`000` key (`extraZerosButton`), layout (`numberPadFormat`), haptics (`numberPadHapticFeedback`). Both result and raw expression are kept (`selectedAmountCalculation`).
- **Currency conversion in the amount field**: when the entry wallet's currency differs from the primary wallet's, a chip converts via `amountRatioToPrimaryCurrencyGivenPk` and switches to the primary wallet (`selectAmount.dart:528-665`). No `originalCurrency` column; amount is stored in the wallet's currency.
- **Category / subcategory**: `SelectCategoryWithIncomeExpenseSelector` grid with income/expense tab, then a subcategory sheet with "none"; inline `SelectSubcategoryChips`; picking a main category flips income/expense to the category's default; `ReorderCategoriesPopup` from the sheet; `showAllCategoriesWhenSelecting` setting.
- **Account picker**: horizontal chips (hidden when one wallet), long-press to edit, "+" to add, chevron for full list at >3 wallets; also a wallet picker inside the numpad.
- **Date and time** (`DateButton` ~line 2288): tap date → `showCustomDatePicker`; tap time → `showCustomTimePicker`; long-press resets to now.
- **Notes** (`TransactionNotesTextInput`): multiline, link detection/highlighting (`lib/struct/linkHighlighter.dart`), inline rendering of Google Drive images.
- **Attachments** (`lib/struct/uploadAttachment.dart`): "take-photo" (camera), "select-photo" (gallery, `image_picker`), "select-file" (`file_picker`) → uploaded to a Google Drive folder named `Cashew`, and the `webViewLink` is pasted into the note (attachments are note links, not a DB column; requires Drive `driveFileScope` sign-in).
- **Income/expense toggle** (`IncomeExpenseTabSelector`); sign applied on save.
- **Transaction type chips**: Default / Upcoming / Subscription / Repetitive / Borrowed (debt) / Lent (credit) (`transactionTypeDisplayToEnum`, lines 75-88) with ⓘ explanations (`SelectTransactionTypePopup`); extra "installments" chip → `startCreatingInstallment` (goal-based plan, `addObjectivePage.dart:1030`). `setSelectedType` fixes paid defaults (credit/debt start paid=true; upcoming/subscription/repetitive start paid=false).
- **Repeat settings** (for subscription/repetitive): "repeat every N {day|week|month|year}" (`periodLength` + `BudgetReoccurence`), "until …" end date (or "until goal reached"/"until loan reached"), live "( ×N )" occurrence count (`countTransactionOccurrences`).
- **Paid state**: `SelectIncludeAmount` "include-amount" switch bound to `paid`; `skipPaid` preserved.
- **Add to budget** (`SelectAddedBudget` → `sharedReferenceBudgetPk`), **exclude from budgets** (`SelectExcludeBudget` → `budgetFksExclude` JSON list, under "more options").
- **Goal / loan selection**: `SelectObjective(goal)` → `objectiveFk`; `SelectObjective(loan)` → `objectiveLoanFk`; mutually exclusive.
- **Transfer between accounts**: "transfer" tab in the header for new transactions when >1 wallet (`showTransactionsBalanceTransferTab`); `TransferBalancePopup` (`lib/pages/addWalletPage.dart:1022`) creates **two balance-correction transactions** in category `"0"` linked by `pairedTransactionFk`, with cross-currency conversion; editing one prompts "update both transfers?" (`updateCloselyRelatedBalanceTransfer`), deleting one offers to delete the pair. Colour setting `balanceTransferAmountColor`.
- **Duplicate** button in "more options" when editing (long-press = duplicate at current time).
- **Quick add**: no "add another" button exists (grep `add-another|addAnother` = 0). Quick entry paths are: FAB, app shortcuts, Android widget, app links, notification tap.
- **Keyboard**: `incognitoKeyboard` option (debug); `askForTransactionNoteWithTitle` prompts a note too.

## 5. Transaction list, search, filters, bulk edit

- **Transactions page** (`lib/pages/transactionsListPage.dart`): month-paged `PageView` with sticky `MonthSelector` header and arrows on wide screens; per-month spending summary (`showTransactionsMonthlySpendingSummary`); filter icon + search icon; filters persisted in `transactionsListPageSetFiltersString`. `TransactionsSettings`: auto-pay upcoming/repetitive/subscriptions, `markAsPaidOnOriginalDay`, `netSpendingDayTotal` (day banner shows net vs spent), monthly summary toggle, transfer-tab toggle.
- **Search page** (`lib/pages/transactionsSearchPage.dart`): debounced (500 ms) query, date-range picker with "all time", filter sheet, flat date-divided results with running cash-flow total; filters persisted in `searchTransactionsSetFiltersString`.
- **Search semantics** (`tables.dart:5959`, `transactionFilters.dart:378-450`): matches title, note, category, subcategory, budget, goal, loan names; numeric query → amount band; month-name (+day/year) query → date filter.
- **Filters** (`SearchFilters`, `lib/pages/transactionFilters.dart:26-88`): `walletPks`, `categoryPks`, `subcategoryPks` (null = "no subcategory"), `budgetPks` (null entry = "no budget"), `excludedBudgetPks`, `objectivePks`, `objectiveLoanPks`, `expenseIncome`, `positiveCashFlow` (no UI; programmatic), `paidStatus {paid, notPaid, skipped}`, `transactionTypes` (incl. null = default), `budgetTransactionFilters`, `methodAdded`, `amountRange` (slider bounded by real min/max, `lib/widgets/amountRangeSlider.dart`), `dateTimeRange`, `searchQuery`, `titleContains` (comma-separated, with autocomplete), `noteContains`. Serialised via `getFilterString()/loadFilterString()`; active filters shown as `AppliedFilterChips`.
- **Grouping** (`lib/widgets/transactionEntries.dart`, `dateDivider.dart`): grouped by day with sticky `DateDivider` (worded date, "• N days" for future, day total or net); future transactions collapsible (`CollapseFutureTransactions`).
- **Swipe**: no swipe-to-delete/edit (no `Dismissible`/`Slidable` on rows). Swipe/drag across rows is **drag-to-multi-select** (`lib/widgets/transactionEntry/swipeToSelectTransactions.dart`); long-press starts selection; iOS/web show checkboxes.
- **Bulk actions** (`lib/widgets/selectedTransactionsAppBar.dart`): live selected total (long-press copies), share/copy summary text, **delete**, **select all** (capped), **duplicate** (≤10; long-press = at current time; re-pairs transfers), **edit** → change date, change title, change category, change account, add-to/remove-from budget, add-to/remove-from goal, add-to/remove-from loan; **settle-and-collect-all** (loans page only). No bulk mark-paid and no bulk income/expense flip.

## 6. Transaction row actions (pay / skip / settle)

`lib/widgets/transactionEntry/transactionEntryTypeButton.dart` + `lib/struct/upcomingTransactionsFunctions.dart`: trailing action button routes by state: pay ("pay?"/"deposit?") with **skip** option; un-pay ("remove-payment?"); remove-skip; for loans **collect-all/settle-all** or **partially collect/settle** (which converts the one-time loan into a long-term-loan Objective). Paying a subscription/repetitive spawns the next occurrence (`createNewSubscriptionTransaction`, honouring `endDate` and goal completion). Auto-pay on launch: `markUpcomingAsPaid()`, `markSubscriptionsAsPaid()`. Row also shows `TransactionEntryTag` (budget/goal/account label), note, amount with income arrow.

## 7. Special-type pages

- **Scheduled (upcoming/overdue)** (`lib/pages/upcomingOverdueTransactionsPage.dart`): all / upcoming / overdue selector, search, totals with counts, monthly/yearly/total upcoming switcher, per-row pay/skip, multi-select, settings (auto-pay upcoming/repetitive, paid-date rule). No explicit "pay all overdue" button; auto-pay settings do this.
- **Subscriptions** (`lib/pages/subscriptionsPage.dart`): list with recurrence header and normalised "/month" or "/year" cost; monthly/yearly/total aggregate; auto-pay subscriptions setting.
- **Loans** (`lib/pages/creditDebtTransactionsPage.dart`): tabs **one-time** (credit/debt transactions) and **long-term** (loan Objectives); all/lent/borrowed selector; header "you get"/"you owe"; `AddLoanPopup` (long-term vs one-time); bulk settle-all. Persisted tab `loansLastPage`.
- **Goals** (`lib/pages/objectivesListPage.dart`, `objectivePage.dart`, `addObjectivePage.dart`, `editObjectivesPage.dart`): savings vs expense goals (`income` flag), name/icon or emoji/colour/amount/start date/optional end date/account/pin; detail page with circular progress, percent, spent-vs-remaining toggle (`showTotalSpentForObjective`), status vs end date, confetti at 100%, filtered transaction list, FAB adds attached transaction. Edit page: reorder, search, archive/unarchive (archiving unpins), delete (optionally detaching transactions). **Installments** (`InstallmentObjectivePopup`) compute payment count or per-payment amount.
- **Long-term loans**: loan-type Objectives whose total is the sum of opposite-polarity transactions (README "Long Term Loans"); "difference-only" loans (`amount == -1`, behind `longTermLoansDifferenceFeature`) show "to-pay"/"to-collect"/"all-settled".
- **Activity log** (`lib/pages/activityPage.dart`): last 30 modified + 30 deleted transactions; restore deleted transactions (kept in `recentlyDeletedTransactions`, max 50, in SharedPreferences).

---

## 8. Budgets

- **Model** (`Budgets` table, `tables.dart:414-475`): `amount`, `colour`, `startDate/endDate`, `reoccurrence {custom, daily, weekly, monthly, yearly}` + `periodLength` (e.g. every 2 weeks), `walletFks`, `categoryFks`, `categoryFksExclude`, `income` (savings budget), `addedTransactionsOnly`, `budgetTransactionFilters`, `pinned`, `order`, `archived`, `isAbsoluteSpendingLimit`, shared-budget columns.
- **Create/edit** (`lib/pages/addBudgetPage.dart`): period picker or custom one-time date range; "added only" vs "all transactions" type; savings vs expense; category include/exclude; account filter; transaction filters (`BudgetTransactionFilters`: include income, include debt/credit, include balance corrections, added to other budget, added to goal…); colour; pin. Free tier gates the **second** budget (`premiumPopupBudgets`).
- **List** (`lib/pages/budgetsListPage.dart`): non-archived budgets as `BudgetContainer`s with progress bar, "today" pace marker, shake when >100 %, "N/day for M more days" pacing text (`lib/widgets/budgetContainer.dart`), spent-vs-remaining label (`showTotalSpentForBudget`).
- **Budget detail** (`lib/pages/budgetPage.dart`): period arrows to browse past periods; category pie + per-category rows with % and over-limit colouring; long-press category to set a limit; subcategory expand/collapse; `BudgetLineGraph` (daily or cumulative, previous periods as faded overlays, pro-rated target line, "today" marker, "view to today"/"view all days"); menu → edit budget, budget history. Past periods gated by premium (`premiumPopupPastBudgets`).
- **Category spending limits** (`lib/widgets/categoryLimits.dart`, `lib/pages/editBudgetLimitsPage.dart`, `CategoryBudgetLimits` table): per-category (and subcategory) limits inside a budget, absolute amount or percentage of budget (`isAbsoluteSpendingLimit`); "spending goals"/"saving goals" wording.
- **Budget history** (`lib/pages/pastBudgetsPage.dart`, `lib/widgets/budgetHistoryLineGraph.dart`): line graph of totals across past periods, per-period cards, "load more periods", average spent/saved, **watched categories** overlay (`watchedCategoriesOnBudget`) = category spending over time.
- **Edit budgets page** (`lib/pages/editBudgetPage.dart`): reorder, search, archive (unpins), duplicate, delete (optionally detaching added transactions).
- **Shared budgets** (`lib/struct/shareBudget.dart`, `lib/pages/sharedBudgetSettings.dart`, Firestore `budgets` collection): fully implemented (members, owner, per-member filters, sync queue) but **every entry point returns early unless `appStateSettings["sharedBudgets"] == true`**, whose default is `false` and is only togglable from the hidden debug page → effectively disabled/deprecated.
- **No rollover/carry-over** of unspent budget (grep `rollover|carry` = 0).

## 9. Wallets / Accounts and currencies

- **Model** (`Wallets`, `tables.dart:251-270`): `name`, `colour`, `iconName`, `currency`, `currencyFormat` (unused), `decimals` (default 2), `order`, `homePageWidgetDisplay` (which home widgets show it). Front-end calls them "Accounts" (README).
- **Create/edit** (`lib/pages/addWalletPage.dart`): name, colour, currency (`lib/widgets/currencyPicker.dart`), decimal precision, starting balance ("starting at"), shortcuts for merge account, correct total balance, transfer balance.
- **Manage** (`lib/pages/editWalletsPage.dart`): reorder, search, delete with "move transactions" (merge) or delete-all, `mergeWalletPopup`, set **primary account** (`PrimaryCurrencySetting`; primary currency = `selectedWalletPk`'s currency). `lib/pages/accountsPage.dart` is the accounts overview.
- **Balance correction** (`CorrectBalancePopup`, `addWalletPage.dart:707`): enter true balance → adjusting transaction in reserved category `"0"` (balance-correction category, `lib/struct/defaultCategories.dart:8`).
- **Transfers**: see §4; reachable from add-transaction tab, account editor, wallet page menu, app shortcut, Android widget.
- **Wallet detail / All Spending** (`lib/pages/walletDetailsPage.dart`, 3,004 lines): totals grid (net/account total, expense, income, lent, borrowed, upcoming, overdue), category pie with income/expense toggle, line graph, "current"/"history" tabs (history = per-period income/expense/net cards + history line graph, premium-locked via `FadeOutAndLockFeature`), filtered transaction list, "cumulative" vs "per-period" totals, period picker, filters; menu → edit account, correct balance, transfer, filters. With `wallet == null` it is the global **All Spending** page.
- **Net worth**: single figure from `watchTotalWithCountOfWallet(isIncome: null)` over all or pinned wallets; no per-wallet "exclude from net worth" flag; no net-worth-over-time chart.
- **Exchange rates** (`lib/struct/currencyFunctions.dart:14-39`): fetched from `https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.min.json`, cached in `cachedCurrencyExchange`; **custom rate overrides** and custom currencies in `lib/pages/exchangeRatesPage.dart` (`customCurrencyAmounts`, `customCurrencies`); currency metadata from `assets/static/generated/currencies.json`; fallback rate `1`. Settings: `showCurrencyLabel` (append code to account names), `showAccountLabelTagInTransactionEntry`, `accountColorfulAmountsWithArrows`.

## 10. Categories and associated titles

- **Model** (`Categories`, `tables.dart:337-373`): `name`, `colour`, `iconName`, `emojiIconName`, `income`, `order`, `mainCategoryPk` (subcategory parent), `methodAdded`. No `archived` column.
- **Create/edit** (`lib/pages/addCategoryPage.dart`): name, icon from a searchable grid of **277 PNG icons** (`assets/categories/`, 278 `IconForCategory` entries with search tags in `lib/struct/iconObjects.dart`) **or an emoji** (`UseEmoji`), colour (14 presets in `lib/colors.dart:283-300` + custom colour picker with hex entry; custom picker is premium-gated), income/expense tab, amount-colour option, attach to a main category (subcategory), icon suggestion popup.
- **Manage** (`lib/pages/editCategoriesPage.dart`): reorder, search (incl. subcategory names), delete with **move transactions / merge** (`mergeAndDeleteCategory`, `mergeAndDeleteSubCategory`), promote subcategory to main ("make-main-category"), `colorTintCategoryIcon` option.
- **Defaults** (`lib/struct/defaultCategories.dart`): 11 seeded categories (Dining, Groceries, Shopping, Transit, Entertainment, Bills & Fees, Gifts, Beauty, Work, Travel, Income) + reserved balance-correction category `"0"`.
- **Associated titles** (`AssociatedTitles` table; `lib/pages/editAssociatedTitlesPage.dart`, `addAssociatedTitlePage.dart`): title→category mapping (substring match, `isExactMatch` column), reorderable/searchable list, add/edit/delete; toggles `autoAddAssociatedTitles`, `askForTransactionTitle`, `askForTransactionNoteWithTitle`.

## 11. Analytics / charts (`fl_chart`)

- **Pie** (`lib/widgets/pieChart.dart`): budget page, home pie section, wallet/All Spending page; `PieChartOptions` (clear selection, view subcategories, edit spending goals).
- **Line** (`lib/widgets/lineGraph.dart`): budget daily/cumulative graph with past-period overlays; home spending graph; wallet detail graph; budget history graph; computed off-thread via `compute(calculatePoints)`.
- **Bar** (`lib/widgets/barGraph.dart`): defined but **unused** (no references).
- **Heatmap** (`homePageHeatmap.dart`): see §2.
- **Past-period comparison**: budget graph overlays + `PastBudgetsPage` + All Spending history cards. **Category over time**: watched categories on `PastBudgetsPage`.
- **Spending summary helper** (`lib/struct/spendingSummaryHelper.dart`): subcategory roll-ups indexed by main category.
- No net-worth-over-time graph; no transactions calendar view (only the heatmap and date pickers).

---

## 12. Notifications (`lib/struct/initializeNotifications.dart`, `notificationsGlobal.dart`, `lib/widgets/notificationsSettings.dart`, `lib/pages/notificationsPage.dart`)

- **Daily reminder to add transactions**: on/off (`notifications`, default true), time (`notificationHour`/`notificationMinute`, default 20:00), type `ReminderNotificationType { IfAppNotOpened, DayFromOpen, Everyday }`; 14 days scheduled ahead; 26 random localised messages; inexact scheduling (no exact-alarm permission).
- **Upcoming transaction notifications**: global toggle + per-transaction switch (`upcomingTransactionNotification`); scheduled up to 1 year ahead.
- **Tap payloads**: `addTransaction` → add page; `upcomingTransaction` → marks auto-pay and opens Scheduled page; `openTransaction?transactionPk=` → opens that transaction.
- **Permission handling**: request on Android/iOS; red status box linking to system settings when denied.
- **Not present**: over-budget/threshold notifications (grep `overBudget` → only UI colouring). No notifications on web; iOS plugin not initialised for foreground delivery.

## 13. Import / Export

- **CSV import** (`lib/widgets/importCSV.dart`): charset auto-detection, header-row guess, **column mapping sheet** for `date`, `amount`, `category`, `name`, `note`, `wallet` (`~None~` / `~Current Wallet~` options), custom `intl` date-format input with live preview, fallback to `getCommonDateFormats()` (`lib/struct/commonDateFormats.dart`), auto-creation of missing categories and accounts, Mint-style credit/debit sign handling, associated-title learning, `methodAdded = csv`. **No saved mapping templates**; a sample template CSV can be downloaded.
- **Google Sheets import**: share URL → `gviz/tq?tqx=out:csv` fetch (sheet must be publicly viewable); auto-import with mapping fallback; hosted template sheet link.
- **CSV export** (`lib/widgets/exportCSV.dart`): paid transactions only; columns `account, amount, currency, title, note, date, income, type, category name, subcategory name, color, icon, emoji, budget, objective`; account filter + all-time/date range.
- **Database export/import** (`lib/widgets/exportDB.dart`, `importDB.dart`): raw SQLite `.sql` file save/restore, also offered by the DB-corrupted recovery popup.
- **Not present**: JSON export (JSON only as app-link *input*), PDF/report export.

## 14. Sync and backup (`lib/widgets/accountAndBackup.dart`, `lib/struct/syncClient.dart`)

- **Google sign-in** with Drive `appdata` scope (+ optional file scope for attachments, Gmail scopes for email parsing); iOS shows a disclaimer first; backup-reminder popup every 7th launch when not signed in.
- **Backups** to Drive's hidden `appDataFolder`, named `db-v<schema>-<device>.sqlite`; auto-backup when `autoBackups` (default on) and `autoBackupsFrequency` days elapsed (default 3; choices 1/2/3/7/10/14); `backupLimit` default 20 (10/15/20/30 UI only visible with `showBackupLimit` debug flag); manage sheet lists backups with age, download to device, delete, restore (overwrites DB, resets locale, restarts).
- **Cross-device sync**: each device uploads one `sync-<clientID>.sqlite`; on sync the app downloads other devices' files newer than last-synced timestamp, pulls rows changed since then (wallets, categories, budgets, limits, transactions, titles, scanner templates, objectives) plus `DeleteLogs` tombstones, and applies them last-write-wins by `dateTimeModified` (`processSyncLogs`, `tables.dart:3601`). Triggered on launch (`runAllCloudFunctions`), pull-to-refresh (`lib/widgets/pullDownToRefreshSync.dart`), sidebar sync button, and optionally on every change with a 5 s debounce (`syncEveryChange`, web-only toggle). Master toggle `backupSync`.
- **Web**: DB in localStorage-backed path; downloads via anchor element.

## 15. Security

- **Biometric/app lock** (`lib/struct/initializeBiometrics.dart`, `requireAuth`): gates the whole app at cold start via `local_auth` with `biometricOnly: false` (device PIN/pattern fallback allowed); not re-prompted on resume; disabled on web; escape hatch after backup restore. No app-specific PIN/passcode, no encryption at rest.

## 16. Themes, appearance, formatting, language

- **Theme mode**: system / light / dark / **black** (true-black, only with Material You; `forceFullDarkBackground`) (`_ThemeSettingsDropdownState`, `lib/pages/settingsPage.dart`; `lib/colors.dart`).
- **Material You** toggle, **system accent colour** (`accentSystemColor`) or **custom accent colour** (`accentColor`, default `#1B447A`); iOS "colorful interface" switch.
- **Fonts**: Avenir (default), DMSans, Metropolis, RobotoCondensed, Inconsolata, Platform; Inter fallback (`pubspec.yaml`, `openFontPicker`).
- **Style**: `increaseTextContrast`, `outlinedIcons` (restart), `forceSmallHeader`, `appAnimations` (all/minimal), `numberCountUpAnimation`, `disableShadows`, `batterySaver`, haptic toggles (`numberPadHapticFeedback`, `savingHapticFeedback`, `closeNavigationHapticFeedback`, `tabNavigationHapticFeedback`).
- **Number formatting** (`convertToMoney`, `lib/functions.dart:170`): per-wallet decimals; zero cents dropped automatically; `shortNumberFormat` compact ("1.2K"); custom delimiter/decimal/symbol-first (`customNumberFormat`, `numberFormatDelimiter`, `numberFormatDecimal`, `numberFormatCurrencyFirst`); currency code appended when no symbol; `percentagePrecision` 0/1/2; `use24HourFormat` system/12/24; `firstDayOfWeek` locale/Sunday/Monday.
- **Localisation** (`lib/struct/languageMap.dart`, `easy_localization`): 48 locales in `supportedLocales` (49 JSON files in `assets/translations/generated/` incl. `none.json`), generated from a public Google Sheet by `assets/translations/generate-translations.py`; in-app language picker with "System"; non-English locales see major-changes-only changelog.
- **Widgets settings**: `widgetTheme`, `widgetOpacity` (Android home-screen widgets).
- **No** app-wide text-size/UI-scale setting, no "close on back"/gesture settings.

## 17. Tools: Bill splitter (`lib/pages/billSplitter.dart`)

Items with cost, people, even split or per-person percentages, a persisted **multiplier** (for tax), People page, Summary page (who owes whom), **"Generate Loan Transactions"** creating credit/debt transactions (choose who you are, date, title, subcategory), clear/reset. Exposed from Settings ("Tools & extras") and optionally as a More-page tile (`showBillSplitterShortcut`).

## 18. Automation and integrations

- **App shortcuts** (`lib/struct/quickActions.dart`, `quick_actions`): "add transaction", "transfer" (if tab enabled and >1 wallet), one shortcut per budget.
- **Android home-screen widgets** (`lib/widgets/util/checkWidgetLaunch.dart`, `android/app/src/main/kotlin/com/example/budget/*WidgetProvider.kt`): Transaction Shortcut (1×1), Transfer Shortcut, Net Total (2×1), Net Total Wide; theme/opacity configurable. **No iOS widget extension.**
- **App links** (`lib/widgets/util/appLinks.dart`, `app_links`): HTTPS App Links `https://cashewapp.web.app/addTransaction` (silent create + snackbar) and `/addTransactionRoute` (opens pre-filled page); **not a `cashew://` scheme**. Params: `amount`, `title|name`, `note|notes`, `date|dateCreated`, `category|categoryPk`, `subcategory|subcategoryPk`, `wallet|account|walletPk`, `JSON` (batch `{"transactions":[...]}`), `messageToParse` (debug). Missing category → associated-title match → category picker with summary table. Web uses `Uri.base`.
- **Notification-listener auto-transactions** (`lib/pages/autoTransactionsPageEmail.dart`, `notification_listener_service`, Android): parses bank/app notifications against `ScannerTemplates` (contains / title-before-after / amount-before-after / default category) and opens a pre-filled add page. Reachable only when `notificationScanningDebug` is on (debug page). English-only strings.
- **Gmail receipt parsing** (`AutoTransactionsPageEmail`, `lib/pages/addEmailTemplate.dart`, `ScannerTemplates` table): scans last N emails via Gmail API, creates transactions (`methodAdded = email`), marks emails read. Gated by `emailScanning` (default false, dangerous-debug-flag only, "Not verified by Google") → effectively disabled in release.
- **Add from notification**: daily reminder tap opens add page; upcoming notification tap opens Scheduled page.
- **Firebase Firestore**: shared budgets (disabled) and anonymous **feedback** collection.

## 19. Onboarding, help, feedback, about, changelog

- **Onboarding** (`lib/pages/onBoardingPage.dart`): 3 pages: intro (+ "preview demo" data button), create first budget + choose primary currency, Google sign-in or continue without; re-openable from About.
- **Help/FAQ**: links to `https://cashewapp.web.app/faq.html` (More page overflow, About, import errors) when `showFAQAndHelpLink`; `showExtraInfoText` subtitles; various one-time tips (`canShowTransactionActionButtonTip`, `allSpendingPageTip`, `autoLoginDisabledOnWebTip`).
- **Feedback/rating** (`lib/widgets/ratingPopup.dart`): stars + text + optional email → Firestore; ≥4 stars triggers `in_app_review`; home-page rating box every 13th launch.
- **About** (`lib/pages/aboutPage.dart`): version, team credits, deep-linking docs, graphics/tool credits, translator credits grid, GitHub, FAQ, feedback, changelog, view intro, privacy policy, licences, delete all data; long-press app name → **Debug page** (`lib/pages/debugPage.dart`, ~35 flags + maintenance actions: redo migration, fix polarity, vacuum DB, force sync, view delete logs, test notification, preview data, random transactions, app-link tester).
- **Changelog** (`lib/widgets/showChangelog.dart`, `lib/pages/detailedChangelogPage.dart`): giant string with `< version` headers, `(A)`/`(i)` platform markers, shown on launch after updates (`lastLoginVersion`), "major changes" cards, full detailed page.

## 20. Data management

- **Delete all data** (`deleteAllDataFlow`, `aboutPage.dart:755`): two confirmations; option to also erase synced data and cloud backups.
- **Merge/move on delete** for accounts and categories; **detach or delete** transactions on budget/goal delete.
- **Restore deleted transactions** via Activity log (last 50).
- **Bulk delete/duplicate/edit** via multi-select (§5). **No "restore default settings"** action (defaults are only applied per missing key on load).
- `previewDemo` mode seeds sample data (`lib/database/generatePreviewData.dart`).

## 21. Monetization (`lib/pages/premiumPage.dart`)

- Free app with optional **Cashew Pro** via `in_app_purchase`: `cashew.pro.monthly`, `cashew.pro.yearly`, lifetime `cashew.pro.life` (iOS) / `cashew.pro.lifetime` (Android). Marketed perks: support the developer, unlimited budgets & goals, past budget periods, unlimited colour picker.
- **Gates**: second budget (`premiumPopupBudgets`), second goal per type (`premiumPopupObjectives`), past budget periods/history (`premiumPopupPastBudgets`, `FadeOutAndLockFeature` on All Spending history), custom colour picker. Soft nag after >5 transactions at most once/day (`premiumPopupAddTransaction`, "not an enforced feature").
- **"Continue for free"**: `FreePremiumMessage` with a 26-second countdown unlocks the paywall permanently (`premiumPopupFreeSeen`). Enforcement is local (`purchaseID` in settings, restored via `restorePurchases()`); disabled on web and debug builds. No donation link.

## 22. DB schema summary (`lib/database/tables.dart`)

Tables: `Wallets`, `Transactions`, `Categories`, `CategoryBudgetLimits`, `AssociatedTitles`, `Budgets`, `AppSettings`, `ScannerTemplates`, `DeleteLogs`, `Objectives`. Key enums: `TransactionSpecialType { upcoming, subscription, repetitive, credit, debt }`, `BudgetReoccurence { custom, daily, weekly, monthly, yearly }`, `ObjectiveType { goal, loan }`, `PaidStatus { paid, notPaid, skipped }`, `MethodAdded { email, shared, csv, preview, appLink }`, `HomePageWidgetDisplay { WalletSwitcher, WalletList, NetWorth, AllSpendingSummary, PieChart }`, `BudgetTransactionFilters {…}`. Transactions carry `pairedTransactionFk`, `originalDateDue`, `periodLength/reoccurrence/endDate`, `type`, `paid`, `skipPaid`, `createdAnotherFutureTransaction`, `upcomingTransactionNotification`, `sharedReferenceBudgetPk`, `objectiveFk`, `objectiveLoanFk`, `budgetFksExclude`. Note: `paid` is inverted for credit/debt (true = still outstanding). See `CASHEW_DATA_MODEL.md` for the full schema.

---

## 23. Things Cashew notably does NOT do (verified by grep over `lib/`)

- **No bank/account aggregation**: no Plaid/Open Banking/OFX/QIF; `bank` only appears in icon names, onboarding copy and a quick-action label.
- **No receipt OCR / image recognition**: no `ocr`, `tesseract`, `ml_kit`; photos are only uploaded to Drive as note links.
- **No AI/ML features**: no `openai|gpt|machine learning`.
- **No SMS parsing** (grep `sms` = 0; Android notification-listener parsing exists but is debug-gated).
- **No multi-user / household sharing in practice**: shared budgets code exists but is hard-disabled behind a debug flag; no Apple sign-in.
- **No tags/labels**: `Labels` table is commented-out dead code; "tag" hits are UI chips (`TransactionEntryTag`).
- **No split transactions** (one transaction → multiple categories); "split" refers to the bill splitter and string ops.
- **No envelope/rollover budgeting** (`rollover|carry` = 0).
- **No investments/stocks/crypto tracking, no tax features** (only icon names).
- **No PDF/report generation, no JSON export.**
- **No recurring-transaction auto-creation without user opening the app**: occurrences are created when paid/auto-paid on launch.
- **No over-budget or threshold notifications**; only daily reminders and upcoming-transaction alerts.
- **No app-specific PIN/passcode and no encryption at rest**; only OS biometric/credential lock at cold start.
- **No cloud providers other than Google Drive** (`icloud|dropbox|onedrive|webdav` = 0).
- **No iOS home-screen widgets** (Android only); **no desktop builds**.
- **No transactions calendar view**, **no net-worth-over-time chart**, **no bar charts in use**.
- **No "add another" / rapid-entry mode**, no bulk mark-paid.
- **No location/geotagging** of transactions, no attachments stored locally or in DB.
- **No saved CSV import templates/mappings.**
- **No ads**, no server-side entitlement checks.

## 24. Discrepancies between README and code

- README advertises "Import Google Sheets": implemented only as a public-share-URL → CSV fetch, not via the Sheets API.
- README's "Google Login" is for Drive backup/sync; it is not an account system and does not gate any data.
- README mentions notifications for "budget goals": the code has no budget-based notifications.
- `Wallets.currencyFormat` column exists but is never read outside migrations.
- `lib/widgets/watchAllSettings.dart` is an empty file; `lib/widgets/barGraph.dart` is unused.

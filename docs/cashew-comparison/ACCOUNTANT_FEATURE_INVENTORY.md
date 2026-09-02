# The Accountant: Feature Inventory (code-backed)

App: `the_accountant/`, Flutter, `version: 3.0.0+21`, Riverpod + Drift (SQLite, money stored as integer cents), Firebase (Auth/FCM/Analytics/Crashlytics). Backend: `the-accountant-backend/`, .NET 10, EF Core/PostgreSQL, Hangfire, routes `/api/v1/<Controller>`. Docs read: `the_accountant/CLAUDE.md`, `README.md`, `STORE_SETUP.md`, `docs/IOS_APP_STORE_CHECKLIST.md`, `docs/subscription/*.md` (Play/App Store/RTDN/testing setup guides only; no feature docs).

Note: CLAUDE.md/README describe "Gemini API" AI and a FastAPI backend; both are stale. AI runs server-side through a self-hosted OpenAI-compatible gateway ("Freeway"), OCR is on-device ML Kit, and the backend is ASP.NET Core.

---

## 1. App shell, navigation, home/dashboard

**Shell**: `lib/shared/widgets/main_navigation_container.dart`, `lib/shared/widgets/custom_bottom_nav_bar.dart`, `lib/app/app.dart`
- 5 fixed tabs in an `IndexedStack`: Home (dashboard), Activity (transaction list), AI (premium-gated chat), Insights (reports), Settings. Tablet (shortest side ≥600, `lib/core/utils/responsive.dart`) swaps the bottom bar for a `NavigationRail`. Tabs are not reorderable/hideable.
- App bar: screen title + notification bell with unread badge (99+ cap) → Notification Inbox. Floating `SyncStatusBanner` ("Syncing…"/"Synced"; silent on failure).
- FAB (add transaction) visible on Home and Activity tabs only.
- Plain `MaterialApp` named routes (no go_router): `/post-signup-onboarding, /signin, /signup, /profile, /dashboard, /categories, /exchange-rates, /premium, /support, /settings/profile, /settings/privacy-security, /settings/notifications, /settings/regional`.
- In-app update check via `in_app_update` (Android). One shared animated gradient `AppBackground` behind every screen.

**Dashboard**: `lib/features/dashboard/widgets/responsive_financial_overview.dart`, `wallet_cards_section.dart`, `providers/financial_data_provider.dart`, `balance_visibility_provider.dart`
Sections, in hard-coded order: (1) time-of-day greeting (static text, no name); (2) swipeable wallet cards with per-wallet eye toggle that masks the balance (`****`, persisted per wallet in SharedPreferences); (3) Income / Expenses stat cards for the current month → `TransactionTypeScreen`; (4) Credit & Debt (net) and Subscriptions (monthly cost) cards → their screens; (5) one fl_chart line chart "Spending Overview" (uses whatever timeframe the Reports provider currently holds); (6) Recent Transactions (5) with "View All"; (7) Budget Progress bars with "Manage". Pull-to-refresh. Tablet = 2-column layout.
- NOT present: section reorder/hide/customization, aggregate total-balance card (a `HeroBalanceCard` widget exists unused), upcoming items on home, quick-action grid (fully commented out, `responsive_financial_overview.dart:426-545`), global hide-all-balances (`toggleAllVisibility()` never called).

---

## 2. Transactions

**Add/Edit**: `lib/features/transactions/screens/add_transaction_screen.dart` (single scrolling form; `showAddTransactionScreen()` accepts prefill amount/title/type)

| Field / control | Status |
|---|---|
| Title | YES, required for income/expense, optional for transfer; typing shows up to 4 previously used titles (`title_usage_provider.dart`, DB `searchTitleUsages`); tapping fills title **and the category it was last filed under**, then opens amount sheet |
| Amount | YES: big tappable display opens a numeric entry sheet (`calculator_bottom_sheet.dart` is misnamed: plain text field, **no arithmetic calculator**) |
| Category / subcategory | YES: `category_picker_sheet.dart` grid; parents show child-count badge, tap drills into children (1 level); "New" tile creates a category inline |
| Wallet | YES: chips `Name (CUR)`; currency inherited from wallet (no per-transaction currency field) |
| Date + time | YES: `compact_date_time_picker.dart` (native date ±5y, 12h time picker) |
| Notes | YES, multiline |
| Expense / Income / Transfer | YES: 3-way chips; locked while editing; Transfer chip only shown if ≥2 wallets share a currency |
| Special type | YES: Default / Upcoming / Subscription / Repetitive chips (`special_type_selector.dart` extension); enum also has credit/debt |
| Loan type | YES: No loan / Lent Money / Borrowed Money (`loan_type_chips.dart`); direction forced (lent=expense, borrowed=income) |
| Recurrence | YES for Subscription/Repetitive: daily/weekly/monthly/yearly, "Every N" (1–365), optional end date. NO occurrence-count limit |
| Paid state | Derived only (`upcoming` starts unpaid); no user toggle on the form |
| Payment method | YES chip row, but hidden when none exist, and **no UI anywhere creates payment methods** (`addPaymentMethod` only in provider; free limit 5 is unreachable) |
| Budget link / Objective link | YES chip rows (objective row always empty; see §6) |
| Transfer fee | YES (create only): fee amount + "deducted from" wallet; stored as a third expense row linked by `feeForTransactionId` (`transfer_service.dart`) |
| Receipt scan | PARTIAL: AppBar "Scan" (premium) prefills amount+title only; `receiptImageUrl` column exists but is never written; **no attachments stored** |
| Tags, location, per-transaction currency, quick-add mode, duplicate, "save & add another" | NOT FOUND |
| Delete (edit mode) | YES, with confirm |

Save side-effects (`providers/transaction_provider.dart`): wallet balance update, reminder scheduling for upcoming/credit/debt, large-transaction notification, recurring config create/update/delete reconciliation, transfer paired-row update.

**List / search / filters**: `screens/transaction_list_screen.dart`, `transaction_type_screen.dart`, `widgets/month_strip.dart`
- Month strip + swipeable month pages (auto-extends ±12 months). Grouped by day with Today/Yesterday headers, newest first. Search over title/notes/category/payment method; filter sheet: type (All/Income/Expense) and single category; "Clear all". Shimmer loading, contextual empty states.
- `TransactionTypeScreen` (income or expense only) adds a month summary card (total, count, average) and pull-to-refresh, excludes transfer legs.
- NOT FOUND: wallet/date-range/amount/paid filters, user sort, swipe actions, multi-select/bulk actions, pagination (whole table loaded in memory).

**Detail / actions**: `lib/shared/widgets/transaction_card.dart`
- No detail screen: tap → edit form. Long-press → sheet with Edit / Delete (confirm; soft delete; transfers cascade both legs + fee). No duplicate, share, mark-paid from list, or undo.

**Transfers**: `services/transfer_service.dart`, `providers/transfer_provider.dart`
- Two paired rows (expense + income) under the system "Transfer" category, atomic with balance recompute; same-currency only (cross-currency explicitly throws `ArgumentError` and the UI prevents it); optional fee row; edit updates both legs (fee not editable); integrity validator + reconciler (`TransferIntegrity`). Excluded from income/expense/budget analytics (`lib/core/domain/transaction_policy.dart`).

**Upcoming**: `screens/upcoming_transactions_screen.dart`, `providers/upcoming_provider.dart`
- Tabs Upcoming (n) / Overdue (n), summary card (hard-coded `$`), per-row due wording, **Mark as Paid** (with Undo) and **Skip**; pull-to-refresh. **Unreachable in the shipped UI**: the only navigation is in commented-out dashboard code.

**Subscriptions ("Recurring")**: `lib/features/subscriptions/screens/subscription_dashboard_screen.dart`, `widgets/edit_subscription_bottom_sheet.dart`, `providers/subscription_dashboard_provider.dart`
- Summary: monthly recurring cost (normalised daily/weekly/monthly/yearly), yearly projection, Active/Paused/Total counts. Lists both subscription and repetitive items; per card Pause/Resume and Cancel (syncable tombstone); tap → edit sheet (title, amount, frequency, period, end date, wallet). FAB → add transaction. No per-subscription reminder toggle; subscription rows are excluded from due-date reminders.

**Recurring engine**: `lib/features/recurring/services/recurring_service.dart`, `providers/recurring_provider.dart`
- Generates instances on app open (`account_store_provider.dart:210`) and in the hourly WorkManager task; catch-up loop; deterministic `occurrenceKey` (`<configId>@<utcDate>`) with unique index for multi-device dedupe; end-date deactivation; end-of-month clamping. Editing a series never retro-edits generated rows.

**Credit / Debt**: `lib/features/credit_debt/screens/credit_debt_screen.dart`, `providers/credit_debt_provider.dart`
- Tabs All / Credit / Debt, "unpaid only" toggle, summary (net outstanding, overdue badge, lifetime lent/borrowed + outstanding). Per card: outstanding amount, progress bar "Paid X / Y", **Record Payment** (partial payments as real repayment transactions), **Settled** (with Undo via compensating reversal). Due date = transaction date; overdue flag. No counterparty/person field (title is the only identifier); loans created only from the add-transaction loan chips.

---

## 3. Wallets ("Accounts")

`lib/features/wallets/screens/wallet_management_screen.dart`, `widgets/add_wallet_form.dart`, `screens/create_first_wallet_screen.dart`, `providers/wallet_provider.dart`, `lib/core/services/wallet_balance_service.dart`, `lib/data/models/wallet.dart`
- Types: Cash, Bank Account, Credit Card (credit limit + billing cycle day; card shows Outstanding/Available/usage bar), Subscription. Type immutable after creation.
- Fields: name, currency (searchable picker with fiat/crypto toggle), initial balance, icon (40), colour (24 presets + hex), set default, use-decimals per wallet.
- Drag-to-reorder (`SliverReorderableList`, synced `orderIndex`), set default, edit (bottom sheet), delete (cascades soft-delete of its transactions). Header sums all wallets **without currency conversion** (acknowledged in comment).
- Free limit 3 wallets (`UpgradeLimitDialog`).
- NOT FOUND: archive wallet, exclude-from-total, per-wallet detail/transaction page.

## 4. Categories

`lib/features/categories/widgets/add_category_form.dart`, `widgets/category_list_item.dart`, `screens/category_management_screen.dart`, `providers/category_provider.dart`, `lib/core/domain/default_categories.dart`, `lib/core/services/category_initialization_service.dart`, `category_reconciliation_service.dart`, `lib/core/utils/icon_registry.dart`
- 31 defaults (18 expense, 11 income, 2 system: Transfer, Balance Correction) identified by stable `defaultKey` slugs for cross-device merge. Defaults cannot be deleted.
- Create/edit via sheet: name, parent ("Part of", one level of subcategories), 14 colours, 18 icons. Direction (income/expense) is no longer asked; categories are one flat list.
- Free limit 10 custom categories.
- `CategoryManagementScreen` (route `/categories`) is only pushed from dead code; effectively unreachable; real management happens inline from the picker.
- Reconciliation flow for pre-slug duplicates surfaced in Sync settings (`category_reconciliation_card.dart`).
- NOT FOUND: category reorder UI (column exists, no query orders by it), per-category spending limits (only budgets).

## 5. Budgets

`lib/features/budgets/screens/add_budget_screen.dart`, `budget_list_screen.dart`, `providers/budget_provider.dart`, `budget_notification_provider.dart`, `lib/shared/widgets/budget_progress.dart`
- Create: name, amount (hard-coded `$`), one expense category chip (from `AppConstants.defaultCategories`, **stores the category name as the id**: "Using name as ID for demo"), period Weekly/Monthly only, start/end date. Writes the legacy `limit` column.
- List: progress cards (colour by %); dashboard and Reports show budget-vs-actual bars. Free limit 3 active.
- Alerts: hourly in-app timer fires a warning at threshold, but compares raw cents to dollar limits (~100× error, `budget_notification_provider.dart:65`).
- NOT FOUND: edit/delete from UI (methods exist), detail view, charts, history/past periods, rollover, multi-category/wallet scope, income budgets, archive/pin (schema has all of these unused).

## 6. Objectives / Goals

`lib/features/objectives/providers/objectives_provider.dart`, `services/objectives_service.dart`, `lib/data/models/objective.dart`
- Full service layer: goal vs loan type, target, wallet, dates, pin/archive, progress %, daily target, projected completion, free limit 2.
- **No screen exists.** `createObjective` is never called from UI; the only surface is the "Objective" chip row in add-transaction, which is hidden when empty (always). Commented dashboard code says "goals/objectives screen coming soon".

## 7. Reports / analytics / export

`lib/features/reports/screens/reports_screen.dart`, `providers/reports_provider.dart`, `lib/features/settings/screens/export_screen.dart`, `services/pdf_export_service.dart`, `lib/core/services/financial_calculation_service.dart`
- Timeframe Week (free) / Month / Year (premium); report type Expenses / Income / Categories (line vs pie; "Income" reuses the expense series). Financial summary (spent/earned/net with the same growth % on all three), category breakdown bars (top 5 + Other, subcategories as "Parent · Child", always current month), Budget vs Actual bars. Entry to "Spending Insights" (§8).
- Export: CSV free; PDF report premium (summary, category/wallet breakdown, full transaction table). Date range picker + quick chips; include Categories/Wallets toggles; delivery only via OS share sheet.
- NOT FOUND: bar chart, net worth, heatmap/calendar, period comparison, income-vs-expense chart, JSON/Excel export.

## 8. AI features

- **Receipt scanning** (`lib/features/ai/services/ocr_service.dart`, `screens/receipt_scanner_screen.dart`): on-device Google ML Kit text recognition, camera or gallery; extracts merchant + total (date parsed but unused, items always empty, barcode/labeling never invoked); review card → prefill add-transaction. Premium (`PremiumGate(receiptOcr)`). Not Gemini.
- **Spending Insights / Monthly summary** (`monthly_summary_service.dart`, `monthly_summary_screen.dart`): deterministic local math + templated sentences (income, expenses, net, trend vs last month, top 3 categories, savings-rate advice). Displays raw category UUIDs and hard-coded `$`. Premium (`aiInsights`).
- **AI chat** (`lib/features/ai_assistant/*`): thin client over backend `/api/v1/ai-chat/*`; multi-conversation history with rename/delete; 4 canned quick prompts; retry/fallback banners. Sends only text; no client-side financial context, no tool actions. Premium (whole AI tab gated; backend 403 `PREMIUM_REQUIRED`). Backend model: "Freeway" OpenAI-compatible gateway at `freeway.pranta.dev`, `FREEWAY_MODEL=free`, 1024 max tokens, 20-message history, 200-word system prompt (`src/TheAccountant.Infrastructure/Services/AiService.cs`). **No quotas** client or server side (only 429 pass-through).
- **Auto-categorization** (`category_assignment_service.dart`): keyword scorer, **unreferenced dead code**; `smartCategorization` premium id never gated. Backend `/AssociatedTitles/suggest` is premium-gated but is SQL matching, not AI. The real behaviour users get is title-history suggestions (§2).

## 9. Notifications and background

`lib/core/services/notification_service.dart`, `daily_reminder_scheduler.dart`, `background_task_service.dart`, `background_notification_helper.dart`, `notification_action_handler.dart`, `reminder_scheduler_service.dart`, `subscription_expiry_checker.dart`, `fcm_registration_service.dart`, `lib/features/notifications/*`, `lib/features/settings/screens/notifications_screen.dart`
- Types: daily reminder (local zonedSchedule at user time, default 19:00), budget warning (hourly in-app timer, 24h cooldown), recurring processed, upcoming due (≤5), overdue loans (≤3), per-transaction due reminder (WorkManager one-off with 1h/1d/3d/1w offset), large transaction, subscription-expiry (1–7 days), upcoming recurring config, FCM push (server types incl. Promotional).
- WorkManager periodic every 1 hour (`main.dart`): recurrence generation + reminders, per-account store aware. Notification actions: Snooze 1d / Snooze 1w / Skip (background isolate handler). Notification tap navigation is not implemented (handlers log only).
- Inbox: server-backed history, infinite scroll, mark read / mark all read, date grouping.
- Preferences (offline-first, synced to backend): daily reminder + time, budget alerts + threshold slider 50–95%, large-transaction alerts + threshold, recurring reminders + offset, subscription-expiry, promotional (last two stored but not read locally). Debug section (permission status, timezone, pending count, test notification) ships to users. No quiet hours.

## 10. Authentication and accounts

`lib/features/authentication/*`, `lib/core/services/backend_auth_service.dart`, `google_sign_in_service.dart`, `apple_sign_in_service.dart`, `secure_token_storage.dart`, `local_store_manager.dart`, `account_bootstrap_service.dart`
- Email/password (register, login, forgot-password 6-digit code, change/set password), Google (Firebase → backend JWT), Apple (iOS/macOS). Account linking when a social email already has a password account. **No guest/anonymous mode**: sign-in is mandatory; offline continuation exists only after sign-in.
- Profile: display name only; photo upload is "coming soon" in two places. Account deletion = external Google Form. Per-account SQLite files with ownership guard (`db_<userId>.sqlite`), JWT/refresh in secure storage, cache-first session restore.

## 11. Sync / backup / import

`lib/core/services/sync/sync_service.dart` (~2000 lines), `lib/core/providers/sync_provider.dart`, `lib/features/settings/screens/sync_settings_screen.dart`
- Premium-only bidirectional sync: push in 400-row chunks, pull in dependency order with parent checks, cursor held on failures, per-record conflicts, category-reconciliation questions, JWT-vs-store ownership check, balance recompute after pull. Auto every 15 min foregrounded + on resume + on reconnect; manual Sync Now; "Restore from Cloud" hard mirror (atomic, rollback on failure).
- NOT FOUND: local file backup/restore (JSON), Google Drive, CSV/any import (no `file_picker`).

## 12. Security

`lib/core/services/biometric_service.dart`, `lib/features/settings/screens/lock_screen.dart`, `privacy_security_screen.dart`
- Biometric lock (local_auth) with auto-lock timeout (Immediately/1/5/15/30 min/Never); lock screen has no fallback. **No PIN/passcode.** Clear Cache; Clear All Data (type DELETE). Per-wallet balance masking only.

## 13. Premium / monetization

`lib/features/premium/*`, `lib/data/models/premium_features.dart`, `STORE_SETUP.md`
- Products (unified IDs): `accountant_premium_monthly` $2.99, `accountant_premium_yearly` $19.99, `accountant_premium_lifetime` $49.99 (fallback price table in `premium_screen.dart` disagrees: 1.49/9.99/29.99). All tiers unlock the same feature set.
- Free limits: 3 wallets, 10 custom categories, 3 active budgets, 2 objectives, 5 payment methods (objectives/payment-method limits throw without a catching dialog). Premium: cloud sync, AI chat, OCR, insights, Month/Year reports, PDF export, 5 premium themes, priority support flag. CSV export and unlimited transactions are free.
- IAP via `in_app_purchase` (`buyNonConsumable` for all three), server verification `POST /iap/verify`, `GET /iap/subscription-status`, Restore Purchases button, grace period parsed but never shown, no trial. Backend verifies Google Play (Android Publisher API + RTDN webhook) and Apple (verifyReceipt + ASSN v2 with root-CA chain check); daily Hangfire `subscription-validation` job. Entitlement cached in secure storage. `PremiumGate` copy says "One-time purchase • Lifetime access" while selling subscriptions.

## 14. Themes, formatting, localization

`lib/core/themes/*`, `lib/core/providers/theme_provider.dart`, `lib/features/settings/screens/theme_selection_screen.dart`, `regional_settings_screen.dart`, `exchange_rates_screen.dart`, `lib/core/services/currency_service.dart`, `lib/core/utils/*_formatter.dart`
- **Dark only** (`themeMode: ThemeMode.dark`; `lightTheme` defined but unselectable; no system option). 5 premium themes (Sapphire, Emerald, Ruby, Amethyst, Midnight). Theme screen reachable **only from onboarding page 4**, not from Settings. Fonts: Inter + JetBrains Mono (google_fonts). No AMOLED/accent/dynamic colour.
- Regional: default currency (live list from fawazahmed0 currency API, ~160 fiat + optional crypto), 5 date formats, 4 number formats (coupled thousands/decimal), preview card. Symbol always prefix. Decimals per wallet. No first-day-of-week or 24h option.
- Exchange rates: auto-fetch (USD base, 6h cache, jsDelivr + pages.dev fallback), manual override per currency with "Use API Rate" reset; persisted in `ExchangeRates` table and synced. Used for converted totals in `FinancialCalculationService`.
- **Localization: English only, hard-coded.** No `flutter_localizations`, no `.arb`, no `Locale(`. 1 language.

## 15. Onboarding / walkthrough / legal / support

- Intro (`lib/features/onboarding/onboarding_screen.dart`): 4 pages (balances, budgets, AI, themes) → Legal acceptance (`lib/features/legal/legal_acceptance_screen.dart`: bundled `assets/legal/privacy.md`, `terms.md`, checkbox) → sign in → post-signup onboarding (`post_signup_onboarding_screen.dart`: currency, first account incl. credit-card fields, summary). `CreateFirstWalletScreen` fallback; `StartupRecoveryScreen` for cloud-restore/entitlement/offline states (`lib/core/providers/startup_flow_provider.dart`).
- Walkthrough (`lib/features/walkthrough/walkthrough_service.dart`, tutorial_coach_mark): 6 spotlights (wallet cards, FAB, Home, Activity, AI, bell); replayable from Settings.
- Support: Contact Support screen (`contact_support_screen.dart`, subject+message → `POST /support`, premium priority, mailto fallback). Separate `lib/features/support/*` ticket UI is in-memory only and unreachable. Help & FAQ: 32 hard-coded Q&As (`help_screen.dart`). About: version, licenses, legal docs, developer link. Rate/Share links to Play Store.

## 16. Settings tree (`lib/features/settings/screens/settings_screen.dart`)

Searchable. Profile card → Profile Edit. ACCOUNT: Subscription, Sign Out. REGIONAL: Regional Settings (→ Exchange Rates). NOTIFICATIONS: Notification Settings. PRIVACY & SECURITY: Privacy & Security (biometric, auto-lock, password, clear cache, clear all data, legal docs, delete account form). DATA MANAGEMENT: Cloud Sync (PRO), Export Data. HELP & SUPPORT: Help & FAQ, Contact Support, Rate the App, Share, Replay App Tour. ABOUT. DEVELOPER (debug only): Test Crash. No theme/appearance entry.

## 17. Platform support

- Android is the shipping target: `minSdk 24`, `applicationId com.pranta.theaccountant`, permissions POST_NOTIFICATIONS / RECEIVE_BOOT_COMPLETED / SCHEDULE_EXACT_ALARM / USE_BIOMETRIC; only MAIN/LAUNCHER intent filter. iOS configured (Face ID, camera/photos, background fetch + remote-notification, Apple Sign-In entitlement, APNs production). `web/ windows/ linux/ macos/` are default Flutter scaffolds; `firebase_options.dart` throws for Linux; DB path and several plugins are mobile-only.
- NOT FOUND: home-screen widgets (`home_widget`), app shortcuts (`quick_actions`), deep/app links (`app_links`/`uni_links`, no VIEW intent filter; only Google OAuth URL scheme on iOS).

---

## Screen files (`lib/**/*screen*.dart` + screen-like top-level widgets)

```
lib/features/ai/screens/monthly_summary_screen.dart
lib/features/ai/screens/receipt_scanner_screen.dart
lib/features/ai_assistant/screens/ai_assistant_screen.dart
lib/features/authentication/presentation/screens/account_linking_screen.dart
lib/features/authentication/presentation/screens/forgot_password_screen.dart
lib/features/authentication/presentation/screens/sign_in_screen.dart
lib/features/authentication/presentation/screens/sign_up_screen.dart
lib/features/authentication/presentation/screens/user_profile_screen.dart
lib/features/budgets/screens/add_budget_screen.dart
lib/features/budgets/screens/budget_list_screen.dart
lib/features/categories/screens/category_management_screen.dart      (unreachable)
lib/features/credit_debt/screens/credit_debt_screen.dart
lib/features/legal/legal_acceptance_screen.dart
lib/features/legal/legal_document_viewer.dart
lib/features/notifications/screens/notification_inbox_screen.dart
lib/features/onboarding/onboarding_screen.dart
lib/features/onboarding/screens/post_signup_onboarding_screen.dart
lib/features/premium/screens/premium_screen.dart
lib/features/reports/screens/reports_screen.dart
lib/features/settings/screens/about_screen.dart
lib/features/settings/screens/contact_support_screen.dart
lib/features/settings/screens/exchange_rates_screen.dart
lib/features/settings/screens/export_screen.dart
lib/features/settings/screens/help_screen.dart
lib/features/settings/screens/lock_screen.dart
lib/features/settings/screens/notifications_screen.dart
lib/features/settings/screens/privacy_security_screen.dart
lib/features/settings/screens/profile_edit_screen.dart
lib/features/settings/screens/regional_settings_screen.dart
lib/features/settings/screens/settings_screen.dart
lib/features/settings/screens/sync_settings_screen.dart
lib/features/settings/screens/theme_selection_screen.dart              (only via intro page 4)
lib/features/startup/screens/startup_recovery_screen.dart
lib/features/subscriptions/screens/subscription_dashboard_screen.dart
lib/features/support/screens/support_screen.dart                       (unreachable, in-memory)
lib/features/transactions/screens/add_transaction_screen.dart
lib/features/transactions/screens/transaction_list_screen.dart
lib/features/transactions/screens/transaction_type_screen.dart
lib/features/transactions/screens/upcoming_transactions_screen.dart    (unreachable)
lib/features/wallets/screens/create_first_wallet_screen.dart
lib/features/wallets/screens/wallet_management_screen.dart
lib/features/dashboard/widgets/responsive_financial_overview.dart      (home tab)
lib/shared/widgets/main_navigation_container.dart                      (shell)
```

No objectives screen, no payment-method screen, no transaction detail screen, no wallet detail screen.

## Backend endpoints (`src/TheAccountant.Api/Controllers/*.cs`, prefix `/api/v1/`)

- **Auth**: POST register, login, refresh, logout, firebase, google, link-google, unlink-google, change-password, forgot-password, reset-password; GET/PUT me; GET providers. Rate limits 10/min (auth), 5/15min (password-reset).
- **ai-chat** (premium): GET conversations; GET conversations/{id}/messages; PUT conversations/{id}/title; DELETE conversations/{id}; POST message.
- **Ai** (premium): POST insights.
- **AssociatedTitles**: GET/POST, PUT/DELETE {id}; POST suggest (premium, SQL match).
- **Budgets / Categories (+ /with-subcategories, /{id}) / Objectives / PaymentMethods / Recurring / Wallets (+ /default, /{id})**: standard GET/POST/PUT/DELETE.
- **Transactions**: GET (filters walletId, categoryId, paymentMethodId, isIncome, transactionType, dates, min/maxAmount, search, specialType, isPaid), GET {id}, POST, POST bulk, PUT {id}, DELETE {id}.
- **Sync** (premium): GET status, POST update-status, GET pull?since, POST push (≤1000 changes).
- **Iap**: GET subscription-status, POST verify, POST restore, GET subscription-history, POST migrate-legacy.
- **Notifications**: GET/PUT preferences, GET history, POST {id}/read, GET unread-count, POST mark-all-read.
- **Devices**: POST register, DELETE {deviceId}, GET.
- **ExchangeRates**: GET, POST (per-user store; no server-side FX provider).
- **support**: POST (email; premium flagged priority).
- **Webhooks** (anonymous): POST google-play (RTDN), POST apple (ASSN v2), GET health.
- Minimal: GET /health, /, /support, /marketing, /hangfire, /scalar (dev).
- Hangfire jobs: device-cleanup (weekly), refresh-token-cleanup, soft-delete-cleanup (30-day retention), subscription-validation (daily). Reminder/budget/expiry jobs exist but are unscheduled (moved client-side). No server-side recurrence generation.

---

## Notable gaps (vs. common finance apps / Cashew)

| Cashew feature | The Accountant | Evidence |
|---|---|---|
| Subcategories | **YES** (one level) | `Categories.mainCategoryId`; parent chips in `add_category_form.dart:371-412`; drill-down picker `category_picker_sheet.dart:105-113`; Reports label "Parent · Child" |
| Transfers between accounts | **YES** (same currency only, with optional fee) | `transfer_service.dart`; cross-currency refused `_refuseCrossCurrency` |
| Multi-currency with exchange rates | **PARTIAL** | Per-wallet currency + API/manual rates + converted totals (`currency_service.dart`, `exchange_rates_screen.dart`, `financial_calculation_service.dart`), but no cross-currency transfers, wallet header sums unconverted, several screens hard-code `$` |
| CSV import | **NO** | No `file_picker`, no import code; CSV is export-only (`export_screen.dart`) |
| Associated-title auto categorization | **PARTIAL** | Title suggestions from usage history fill title + last category (`title_usage_provider.dart`, `add_transaction_screen.dart:1846-1977`); the dedicated `AssociatedTitles` table/DAO and backend `/AssociatedTitles/*` exist but no client UI manages rules; `CategoryAssignmentService` is dead code |
| Budget past periods / history | **NO** | Budgets are one fixed start–end window; no rollover, no period navigation (`budget_provider.dart`, `budget_list_screen.dart`) |
| Category spending limits | **NO** | Only budgets (single category); no per-category limit field |
| Home page customization | **NO** | Section order hard-coded in `responsive_financial_overview.dart:153-236`; no reorder/hide preference |
| Heatmap / calendar view | **NO** | grep `heatmap|calendar_view|table_calendar` → 0 |
| Bill splitter | **NO** | grep `split|billSplit` → only string `.split()` |
| App lock | **PARTIAL** | Biometric + auto-lock timeout (`biometric_service.dart`, `lock_screen.dart`); no PIN/passcode fallback |
| Long-term loans with partial payments | **YES** | `paidAmount`, `recordPayment`, progress bar, settle/undo (`credit_debt_provider.dart:187-260`); no counterparty field, no interest/schedule |
| Objectives with goal progress | **PARTIAL (backend/data only)** | Complete service + progress math (`objectives_service.dart`) and backend CRUD, but **no screen**; unreachable from UI |
| Google Drive sync | **NO** | grep `googleapis|drive` → 0; only proprietary premium cloud sync |
| Home screen widgets | **NO** | No `home_widget`; no widget receivers in `AndroidManifest.xml` |
| 30+ languages | **NO** | English only; no `flutter_localizations`/`.arb`/`Locale(` |
| App shortcuts / deep links | **NO** | No `quick_actions`/`app_links`; only launcher intent filter |
| Light / system theme | **NO** | `ThemeMode.dark` forced in `app.dart:111` |
| Transaction attachments / receipt image storage | **NO** | `receiptImageUrl` never written; OCR only prefills text |
| Tags / labels, location, duplicate, bulk edit, swipe actions | **NO** | Not present in schema or UI |
| Payment methods management | **NO UI** | Provider + free limit exist; no create screen |
| Account deletion in-app | **NO** | External Google Form (`privacy_security_screen.dart:478`) |

**Other unreachable/dead surfaces worth knowing:** `UpcomingTransactionsScreen`, `CategoryManagementScreen`, `SupportScreen` (tickets), `ThemeSelectionScreen` (from Settings), dashboard quick actions, `PremiumFeatureGate`, `SummaryCard`, `HeroBalanceCard`, `CompactWalletForm`, backend `ClearChatHistoryCommand`.

**Correctness issues surfaced during the survey:** budget alert cents/dollars mismatch (`budget_notification_provider.dart:65`), budget category stored by name (`add_budget_screen.dart:39`), monthly summary shows category UUIDs (`monthly_summary_screen.dart:227`), Reports "Income" chart reuses expense data, hard-coded `$` in Upcoming/Subscriptions/Budgets/Insights summaries, two disagreeing price tables (`product_ids.dart` vs `premium_screen.dart:625-665`), stale README/CLAUDE.md (Gemini, FastAPI).

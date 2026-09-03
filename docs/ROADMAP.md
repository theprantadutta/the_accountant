# The Accountant — Implementation Roadmap

A phase-by-phase plan to close the gaps found in [`CASHEW_COMPARISON.md`](CASHEW_COMPARISON.md), keeping the Flutter app and the .NET backend in sync at every step.

Written 2 September 2026. Flutter app at 3.0.0+21, Drift schema 17. Backend on .NET 10, EF Core 10, PostgreSQL.

**Baseline at start of work:** Flutter analyze clean, 348 tests passing. Backend builds clean, 34 unit tests passing. Both repos on `master` with clean working trees.

---

## The rule that governs every phase

The sync protocol has **no version negotiation**. There is no version field, header, or handshake anywhere. That creates a hard, asymmetric constraint:

- A push naming a table the server does not allow returns **HTTP 400 and rejects the entire batch**. The allow-list is a closed set of seven tables.
- A pull containing a table the client does not know is **silently dropped, and the cursor advances past it**. Those rows are never re-fetched.

So: **the server always ships first**, and every new field is **appended with a default** on both sides. A new synced table means server deploy, then client release, and old clients permanently miss that table's rows until they update.

Three more standing rules, drawn from how the code already works:

1. **Push payloads are PascalCase with integer enums. Pull payloads are snake_case with string enums.** The push handler deserializes with `PropertyNameCaseInsensitive` only, which does not strip underscores, so a snake_case key silently binds to nothing.
2. **Money is integer minor units everywhere.** Convert to major units only at the display boundary, through the existing formatting extension.
3. **Every write goes through the sync-status contract.** An edit must never downgrade a pending create. Use the `markEdited` helper or its SQL form, never a hard-coded status.

---

## Phase 0 — Sync contract repair

**Status: done**, except the pull cap noted at 0.5. Backend commit `03ff62e`, client commit `54d4169`. Flutter analyze clean and 351 tests passing; backend builds clean with 40 unit tests passing.

Nothing else was safe until this landed. These are live data-corruption and sync-brick bugs, not feature gaps. Shipped in two steps: backend first, then client.

### 0.1 Budget period ordinals disagree (data corruption)

The client sends period as an integer using the table `daily=0, weekly=1, biweekly=2, monthly=3, yearly=4, custom=5`. The server enum is `Weekly=0, Monthly=1, Yearly=2, Custom=3`, cast unchecked from the wire value.

Today, on every synced account:

| User picked | Wire | Stored on server |
|---|---|---|
| Weekly | 1 | `Monthly` |
| Monthly | 3 | `Custom` |
| Yearly | 4 | the literal string `"4"` |

The round trip inverts the same table, so the app looks correct while the stored value is wrong. The scheduled budget-check job reads the stored value and therefore computes the wrong period window for every budget, falling through its default branch for the undefined ones.

**Fix.** Give the server enum explicit values matching the client's wire table, and add the two members the client already emits:

```csharp
public enum BudgetPeriod
{
    Daily = 0, Weekly = 1, BiWeekly = 2, Monthly = 3, Yearly = 4, Custom = 5
}
```

The column stores the enum as a string, so renumbering is storage-safe for future writes but leaves existing rows holding the wrong word. A one-shot data migration must rewrite them, in a single pass with a `CASE` so no row is remapped twice. Follow the style of the existing migration that repairs data ahead of a constraint change.

Then teach the budget-check job about `PeriodLength`, `Daily` and `BiWeekly`.

### 0.2 A null scope array bricks the client's pull

The server declares the two budget scope columns as nullable, and the API serializer omits null values entirely. The client writes the pulled value straight into a column that is NOT NULL with a default of `'[]'`. A missing key means writing null, which throws. A throw during apply means the cursor is not advanced. The account's sync then retries the same failing batch forever.

Any budget created through the REST endpoint, which defaults both arrays to null, is enough to trigger it.

**Fix, both sides.**

- Client: coalesce on read, `data['WalletIds'] ?? '[]'`. Do the same for every non-nullable column fed from a pulled key. This is the defensive half and must ship even after the server is fixed, because old rows already exist.
- Server: give both properties a non-null default of `"[]"` so the key is always emitted.

Add a regression test using the existing fake sync server that pulls a budget with the scope keys absent and asserts the cursor still advances.

### 0.3 Client-only columns are lost on device change

These columns exist on the client, are never sent, and silently vanish on reinstall or second device:

| Column | Verdict |
|---|---|
| Payment method `type`, `lastFourDigits`, `institution` | **Add to the server.** A user's card last-4 and bank should survive a reinstall. |
| Wallet `useDecimals` | **Add to the server.** It is a per-wallet display choice the user set deliberately. |
| Budget `categoryId`, `limit` | **Do not add.** Both are legacy and are deleted in Phase 1. |
| Transaction `type`, `paymentMethod`, `isRecurring`, `recurrencePattern`; category `type` | **Do not add.** All deprecated; drop them in Phase 1. |

### 0.4 Two tables are advertised as syncable but are not

The sync-status endpoint reports nine tables including exchange rates and associated titles. Both are absent from the push allow-list, so pushing one returns 400 for the whole batch, and absent from pull entirely. Their data is lost on device change while the status endpoint claims otherwise.

**Fix now:** remove both from the status endpoint's table list, so the client is told the truth. **Fix later:** associated titles become genuinely syncable in Phase 3 when the rules editor is built, and exchange rates in Phase 4.

### 0.5 Guard rails so this class of bug cannot recur

- **Client:** add a `default` arm to the pull dispatch switch that logs and refuses to advance the cursor on an unknown table, instead of silently dropping it.
- **Server:** add a push-handler test that builds `data` from snake_case keys and asserts the request is rejected rather than silently zeroing every field. Every current test builds PascalCase objects, so the real client's casing is untested.
- **Server: cap the pull response. Deferred, not done.** It currently materialises every changed row for a user with no limit, so a first sync loads an entire account into memory in one response. Push is already capped at 1000 and the client chunks at 400. Capping it correctly needs paging on both sides: the cursor is a timestamp, so truncating without a watermark would advance it past rows that were never sent and lose them permanently. That means a `has_more` flag and a client that loops. It is a memory and latency risk rather than a correctness bug, and the sync path currently works, so it was left out of a change set whose whole purpose was to stop corruption. Do it as its own piece of work with its own tests.
- **Both:** add a test asserting the six enum wire tables match. Five are correct today and only budget period is broken; the test stops the next one drifting.

### 0.6 Reclaim recurring config rows

Recurring configs are not soft-deletable. Deleting one sets a flag, pull never emits a delete for them, and the cleanup job does not cover them, so deactivated rows accumulate forever. Add them to the cleanup job.

**Phase 0 exit criteria:** both test suites green; a pulled budget with absent scope keys applies cleanly; period round-trips through the server storing the correct word; the status endpoint lists only genuinely synced tables.

---

## Phase 1 — Budgets

**Status: done.** Client commits `a1a249c`, `93cdee0`, `b226781`, `e99b1a7`, `14349bf`; backend commits `03ff62e`, `c053f37`, `6a93866`. Flutter analyze clean with 387 tests passing; backend clean with 45.

Everything in this phase shipped:

- Schema 18 dropped the two legacy columns after folding their data in, resolving a stored category name back to a real id where possible and recording it where not. Schema 19 added the per-category caps table.
- One engine replaced all four spend calculations. Windows anchor on the budget's own start date and honour an interval.
- The provider was rewritten: create, edit, delete, archive and pin all work.
- The create/edit form uses real categories, all six periods, an interval, wallet scope and income budgets.
- The list has actions; the detail screen has period navigation, a cumulative graph with the previous period behind it, category breakdown, caps and recent periods.
- Alerts have the right units and filter, the timer starts, and being over reads differently from being close.
- Beyond Cashew: rollover, a pace marker, per-category caps expressed as a share of the budget, and an overspend forecast that counts scheduled transactions as commitments rather than guesses.

The rest of this section is the original plan, kept for the detail.

The feature was not merely weak, it was non-functional. Rewritten end to end on the schema that already existed.

### What is actually broken

1. **Creating a budget throws.** The insert omits `amount`, which is required during insert. Nothing in the app writes that column except the sync layer and one migration.
2. **Every in-feature spend calculation returns zero.** Two of them filter on `transaction.type == 'expense'`. That column is deprecated and never written, so every row holds `'regular'` and nothing matches.
3. **The alert compares cents to dollars**, a 100× error, and would fire far too early if the filter above were fixed.
4. **The category is stored by name, not id.** The form writes the literal string `'Food & Dining'` into the id column, sourced from a hard-coded constant list rather than the user's real categories. Every lookup misses, so the dashboard labels every budget "All Categories" in grey.
5. **The scope arrays are written and synced but read by nothing.** The legacy single-category column is the only scope that affects any number, and it is neither pushed nor applied. A sync round trip therefore converts a scoped budget into an unscoped one, silently changing its meaning.
6. **The list drops every budget with no end date** while the dashboard keeps them, so the two screens disagree about which budgets exist.
7. **There is no edit or delete UI.** The methods exist with zero call sites.
8. **The alert timer never starts.** Nothing watches the provider, so the notifier is never constructed.
9. **Four independent spend implementations exist**, only two of which use the shared eligibility policy.

### 1.1 Data model

Delete the legacy columns, add what the rewrite needs. One Drift migration to schema 18, one EF migration.

| Change | Client | Server |
|---|---|---|
| Drop `limit`, `categoryId` | migration 18 | already absent |
| Add `periodLength` int, default 1 | migration 18 | new column, DTO field appended with default 1 |
| Add `rollover` bool, default false | migration 18 | new column, DTO field appended |
| New table for per-category limits | migration 18 | new entity, config, both `DbSet`s, migration, sync bucket |

The per-category limit table carries budget id, category id, amount in cents, and a percent flag. It needs a unique index on the pair filtered to live rows, and it depends on both budgets and categories, so on the server it applies after the phase that stages those, using the same pending-ids technique the budget scope validator already uses. Adding it to the push allow-list is the gating step: **the server must deploy before any client pushes one.**

### 1.2 One computation, not four

Write a single budget engine and delete the other three implementations.

- A period resolver mapping any date to its budget window, honouring `periodLength` so "every two weeks" works.
- Spend computed through the shared eligibility policy, honouring the scope arrays with subcategory expansion, wallet scope, and direction.
- Everything in cents until display.

The dashboard, the list, the detail screen, the reports tab, and the alert all consume this one engine.

### 1.3 Screens

- **Create and edit**, sharing one form, built on the app's design system rather than raw Material. Real categories from the category provider, multi-select with an exclude list, wallet scope, income budgets, period with interval, colour, pin, archive.
- **Detail**, with period navigation through past windows, category breakdown, a daily and cumulative graph with the previous period faded behind, pace text, and per-category limits.
- **List**, with edit, delete, archive, and pin reachable.
- **History**, totals across past periods with an average.

### 1.4 Alerts

Fix the units, use the shared policy, watch the provider so the timer actually starts, keep the existing 24-hour cooldown, and add an "exceeded" alert distinct from the warning. The notification plumbing already exists and is better than Cashew's, which has no budget alerts at all.

### 1.5 Beyond Cashew

- **Rollover** of unspent amount into the next period, opt-in per budget.
- **Forecast**: "at this pace you will finish the month over by X", using the upcoming and recurring instances the engine already knows about. Cashew cannot do this because it only materialises a recurrence when the user pays the previous one.

**Exit criteria:** a budget can be created, edited, archived and deleted; spend is correct and identical on every surface; scope survives a sync round trip; alerts fire at the right threshold; tests cover the engine, the period resolver, and the sync round trip.

---

## Phase 2 — Objectives, and screens that exist but cannot be reached

**Status: done.** Client commits `d91b5c9`, `c61faed`, and the goal planner. No backend work was needed. Flutter analyze clean with 401 tests passing.

Done: goals have list, detail and create/edit screens; progress goes through the shared policy, counting transfers deliberately where budgets do not; the upcoming, category management and theme screens were given entry points in Settings; the theme choice persists; payment methods gained the screen they never had; pinned goals appear on the dashboard; the dead support ticket screen was removed; and a planner says how many payments of what size finish a goal.

The rest of this section is the original plan, kept for the detail.


### 2.1 Objectives

The service layer is complete and the backend entity needs no changes at all. There is simply no screen. Meanwhile the in-app help already documents an "Objectives section", and the picker in the add-transaction form hides itself when the list is empty, which it always is.

Progress is also wrong: it sums raw amounts ignoring direction, paid state, and transfers. Route it through the shared policy.

Build the list, detail, and create/edit screens. Add the goal to the navigation and the dashboard. Add an installments helper that computes either the payment count or the per-payment amount, as Cashew does. Then go past Cashew with contribution rules, such as rounding up or a percentage of income, and a completion notification.

### 2.2 Wire up what is already written

| Screen | Today | Fix |
|---|---|---|
| Upcoming transactions | Complete, reachable only from commented-out code | Add to the dashboard and navigation |
| Category management | Complete, pushed only from dead code | Reach it from Settings |
| Theme selection | Reachable only from intro slide 4 | Add a Settings entry |
| Support tickets | In-memory only, unreachable | Delete it; the contact form is the real one |

### 2.3 Payment methods

The table, provider and free-tier limit all exist, but nothing can create one, so the chip row is always hidden. Either build a small management screen or remove the feature. Given the backend already stores them, build the screen.

---

## Phase 3 — The transaction workbench

**Status: done**, except windowed loading. Client commits `5879904`, `caf1f15`, `ef71cbf`, `3fcdd22`, `f1dab17`; backend commit `482dbde`. Flutter analyze clean with 447 tests passing; backend clean with 45.

Done: filters on accounts, several categories, direction, paid state, kind, amount range, date range and transfer visibility; search that reads amounts and month names; multi-select with bulk delete, recategorise, move account, re-date, mark paid and duplicate; a transaction detail screen; recently deleted with restore; and a naming-rules editor whose rules now sync.

**Deferred: windowed loading.** The list still loads the whole table into memory. It is a scaling concern rather than a correctness one, and it wants its own change with its own measurements rather than being bolted onto a set of behaviour changes.

The rest of this section is the original plan, kept for the detail.


The daily-use surface, and the widest everyday gap against Cashew.

- **Filters**: wallets, multiple categories, subcategories, date range, amount range, paid status, special type, budget, objective, transfer visibility. Persisted between sessions.
- **Search** that parses amounts and month names, as Cashew's does, not just substrings.
- **Multi-select** with bulk delete, category, wallet, date, budget and objective changes, plus **bulk mark paid**, which Cashew lacks.
- **Duplicate**, from the detail screen and in bulk.
- **A transaction detail screen**. Today tapping a row opens the edit form and long-press offers only edit and delete.
- **Recently deleted with restore**, built on the soft-delete column. Cashew keeps this list in shared preferences, capped at 50; ours can be real.
- **Swipe actions**, which Cashew does not have at all.
- **Windowed loading.** The list currently loads the whole table into memory.
- **Associated titles editor**, making the existing table and its backend endpoints real, and adding it to sync.

---

## Phase 4 — Wallets and multi-currency

**Status: done**, except exchange-rate sync. Client commits `796876f`, `8a63207`, `d2041d2`, `69fbac7`; backend commit `cb63764`. Flutter analyze clean with 479 tests passing; backend clean with 50.

Done: cross-currency transfers, with each leg carrying its own amount, what the other side received, and the rate; a wallet detail screen; the total across accounts converted rather than added raw; archive and exclude-from-total; correct-balance recorded as a transaction; merge one account into another; and the blind-delta balance path replaced by a recompute plus a startup drift check.

**Deferred: exchange rates into sync.** These carry a unique key on (user, from, to) rather than only an id, so two devices that each create an override for the same pair produce different ids for one row — and pulling the other device's version collides with the local unique index. That is the same shape as the category reconciliation problem, which took a whole flow to solve properly, and a half-built version would wedge sync rather than merely miss a feature. The data at stake is small: only the custom overrides are the user's, and the API rates are a cache each device refetches anyway. Worth doing on its own, with the natural-key merge designed deliberately.

The rest of this section is the original plan, kept for the detail.


- **Wallet detail page** and an all-accounts spending view. Cashew's is one of its best screens; we have none.
- **Cross-currency transfers.** Currently refused outright on the client. The server additionally requires both legs to have equal amounts, in a static check that cannot see wallet currencies. Both sides change together: store the rate and the counter amount on the transfer, and relax the equality check to compare against the counter amount when the wallets differ.
- **Correct balance** action, posting to the balance-correction category that already exists but has no UI.
- **Merge wallets**, moving and converting transactions.
- **Archive and exclude-from-net-worth** flags, new on both sides.
- **Fix the unconverted header total** on wallet management, which sums mixed currencies.
- **Credit-card statement cycles**, using the billing-cycle day that is currently stored and unused. Neither app has this.
- **Balance integrity.** Keep the stored balance as a cache, funnel every mutation through one path inside a single transaction, delete the blind-delta path, and add a startup check that recomputes and logs any mismatch. That gives Cashew's always-correct derived balance without its per-render cost.
- **Exchange rates** become genuinely synced.

---

## Phase 5 — Data portability

**Status: done.** Client commits `56e2346`, `9782bb5`. No backend work was needed. Flutter analyze clean with 605 tests passing.

Done: a backup is one JSON file holding every row, dumped at the column level with plain SQL so a file written today survives later schema versions — an unknown column is dropped and a new one takes its default. The sync cursor and the store's owner binding stay behind, so a file cannot claim a device it does not own or tell a fresh phone it had already pulled changes it was never present for. Restoring runs in one transaction and refuses a file from a newer build outright. Drive backups sit in a folder of their own in the user's Drive, on an interval with a retained count, pruned only after a new copy lands; the scheduled run never prompts, so a lapsed permission records why it skipped. CSV import guesses the encoding, the delimiter, the header, the date format and the decimal separator, shows every guess against the user's own rows before writing anything, reports unreadable lines by line number rather than dropping them, skips rows already on file so an overlapping statement cannot double a balance, and saves the mapping under the bank's name for next time.

Three decisions worth recording. Restored live rows are queued as `pendingCreate`, never `pendingUpdate` — the server treats a create for a row it already holds as an accepted no-op, whereas an update for a row it has never seen is answered "not found" for ever and the record is stranded on the device; the cost is that a restore does not undo a cloud-side edit to a row the server still has, for which "Restore from cloud" is the tool. Drive is reached through its REST endpoints rather than the generated `googleapis` package, because five calls are needed and the generated client would add megabytes describing the rest of Drive. The scope is `drive.file`, not `drive.appdata`: per-file access exposes only files this app made, so the listing can search broadly with no risk of reading the user's own documents, the backups stay somewhere the user can find and copy without the app, and — unlike `drive.appdata`, which Google classifies as sensitive — it needs no verification review to publish. And an account named in an imported file is matched but never created: an account has a currency and an opening balance a CSV does not know.

Two things found on the way and fixed: `clearAllData` never removed category budget limits, so a cloud restore left stale caps behind; and nothing invalidated the notifiers after a restore, so every screen went on showing records that no longer existed until the app was killed.

**Before Drive backups work**, two things must be done in the Google Cloud console: enable the **Google Drive API**, and add the scope `https://www.googleapis.com/auth/drive.file` under **Data Access**. That scope is non-sensitive, so publishing needs no verification review — which is the reason it was chosen over `drive.appdata`.

### What it was

- **Local backup and restore**, free. Sync is premium, so a free user currently has no way to get their data out and back. This is a trust feature.
- **Google Drive backup**, modelled on Cashew: backups in the hidden app-data folder (built instead as a visible folder — see above), an automatic interval with a retained count, and a manage view to download, delete or restore. Cashew names each file after the schema version and device, which is worth copying so a restore can refuse a file newer than the app reading it. We are not copying its sync: it merges whole database files by modification time, and our delta protocol is better than that.
- **CSV import** with charset and header detection, a column mapping sheet, and a date-format field with live preview. Beyond Cashew: **saved mapping templates per bank**.

Import must be purely client-side. The existing bulk endpoint mutates wallet balances, which contradicts the sync contract where balance is client-authoritative, and it validates only the wallet, silently dropping rows and returning 500 on a bad reference. Routing an import through it would double-count every balance.

---

## Phase 6 — Presentation

- **Light and system themes.** The light theme is already defined but unselectable: the app pins dark mode, both theme slots receive the same object, and the choice is never persisted. Wire the settings column that already exists, add a System option, and put the picker in Settings.
- **Localization.** English only, hard-coded, with no scaffolding on either side. Start now, before more screens are written in hard-coded English: add the Flutter localization packages and resource files, extract existing strings, then translate. Bangla and English first.
- Server-side strings also need a plan: notification bodies, email templates, the built-in category names, and sync conflict reasons all reach users as English prose. The conflict DTO already says clients must branch on the code and never on the reason text, but the client displays the reason directly. Fix that contract as part of this work.
- **Number and date formatting**: first day of week, 24-hour time, symbol position.

---

## Phase 7 — Reach

- **Heatmap** calendar of daily net.
- **Home layout editor**, with section order and visibility. Cashew has fourteen reorderable sections; we have seven fixed.
- **App shortcuts and deep links.** Cheap, high daily value.
- **Home screen widgets** for Android and iOS. Cashew has Android only, so iOS is a clear differentiator.
- **Contacts**, giving loans a counterparty and unlocking a people view with per-person running balances. This is how we beat Cashew's "difference only" loans, which are keyed by a sentinel amount of −1 behind a disabled feature flag.
- **Bill splitter** that generates a tracked loan per person.
- **Loan schedules** with interest and instalments. Neither app has these.
- **Tags** and **split transactions**. Neither app has these either.
- **Attachments.** There is no file storage in the backend today, no object storage configured, and no upload endpoint. The receipt URL column is a bare string the client fills with a local path. This needs storage, upload and download endpoints with ownership checks, size and rate limits, and a blob sweep paired with the existing 30-day hard-delete job, or every deleted row orphans a file.

---

## Ordering summary

| Phase | Backend work | Ships |
|---|---|---|
| 0 | Enum fix, data migration, null defaults, status endpoint, cleanup job, guards | Server, then client |
| 1 | Period length, rollover, category limits table | Server, then client |
| 2 | None | Client only — **done** |
| 3 | Associated titles into sync | Server, then client |
| 4 | Transfer validation, wallet flags, exchange rates into sync | Server, then client |
| 5 | None | Client only — **done** |
| 6 | Locale handling, conflict code contract | Either order |
| 7 | Contacts, tags, splits, attachments, storage | Server, then client |

Phases 2 and 5 are client-only and can run in parallel with any backend work.

---

## Open questions

These change what gets built and are worth answering before the later phases.

1. ~~**Guest mode.**~~ **Decided: no guest mode.** Sign-in stays mandatory. Do not add a local-only or anonymous mode.
2. ~~**Free-tier backup.**~~ **Decided: yes, and modelled on Cashew.** Phase 5 builds local backup plus Google Drive backup and restore, close to the way Cashew does it: automatic backups on an interval and a managed list to download, delete or restore from. It departs from Cashew on one point — the backups go in a visible folder rather than the hidden app-data one, so they outlive the app and so the scope needs no verification review. Cashew's cross-device merge is not the target; we already have delta sync for that.
3. **Recurring confirmation.** Should new subscriptions post automatically, as now, or ask first, as Cashew does, with the other available as a setting?
4. **Long-term loans.** A separate concept like Cashew's, or is a per-contact running balance enough?
5. **Web.** Cashew ships a progressive web app. Several of our plugins are mobile-only. Is web a target?
6. **Languages.** Bangla and English first, or a different pair?

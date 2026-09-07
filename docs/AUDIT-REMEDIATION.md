# Remediation plan — audit of 6 September 2026

Working document for the sixteen findings in `AUDIT-2026-09-06.md`. Each entry
records what is actually wrong, why it happens, and the fix that was chosen —
including the ones where a simpler fix was rejected and why.

Seven findings were independently re-confirmed by direct inspection before this
plan was written; the rest are taken on the auditor's reproductions, which were
detailed enough to locate the defect in the source in every case checked.

**All seventeen were addressed; two follow-up reviews then found ten and five
more.** Six of
the original fixes were incomplete or introduced a new defect; those are
recorded in `AUDIT-REMEDIATION-2026-09-07.md` at the repository root, and the
five the review after that found are in `AUDIT-SECOND-REMEDIATION-2026-09-07.md`.
All are now fixed and pinned by tests.

Read those documents alongside this one. A green suite here was not the same
thing as a correct one, and twice a fix of mine was itself the next defect —
the pending-row pull guard added for one review's finding is what the next
review found wedging every conflict. The habit that actually caught things was
testing in the shape production runs in: the rate table as the downloader
writes it, a push interrupted where a user would interrupt it, a batch split
across chunks.

**The pattern worth naming.** Almost every P1 is an *interaction* between two
features that are each well covered on their own: restore × sync, merge ×
transfers, edit × currency, reconciliation × caps, bulk-move × currency. The
suite had 715 passing tests and caught none of them. Every fix below therefore
owes a test that crosses the boundary it slipped through, not another test
inside one feature.

---

## Order of work

| # | Finding | Severity | Status |
|---|---|---|---|
| 1 | [Fresh installs lack the cap uniqueness index](#15) | P2 → done first | ☑ |
| 2 | [Restore leaves the cached sync cursor](#1) | P1 | ☑ |
| 3 | [Restore through sync strands or re-deletes rows](#2) | P1 | ☑ |
| 4 | [Local restore: stale balances, half a transfer](#3) | P1 | ☑ |
| 5 | [Wallet merge breaks transfers](#4) | P1 | ☑ |
| 6 | [Editing a transfer rewrites its amount](#5) | P1 | ☑ |
| 7 | [Bulk move across currencies](#8) | P1 | ☑ |
| 8 | [Budget engine and heatmap mix currencies](#9) | P1 | ☑ |
| 9 | [Category caps cannot converge](#6) | P1 | ☑ |
| 10 | [Reconciliation orphans caps](#7) | P1 | ☑ |
| 11 | [Cross-currency transfer unreachable in the form](#10) | P2 | ☑ |
| 12 | [Naming rules never consulted](#11) | P2 | ☑ |
| 13 | [CSV dedupe eats real repeats](#12) | P2 | ☑ |
| 14 | [Rollover discards carry beyond 24 periods](#13) | P2 | ☑ |
| 15 | [Month-end window arithmetic drifts](#14) | P2 | ☑ |
| 16 | [Payment-method details do not sync](#16) | P2 | ☑ |
| 17 | Correct the roadmap's completion labels | — | ☑ |

`#15` is pulled to the front: a fresh install can already hold duplicate caps,
and fixing cap convergence or reconciliation on top of two different schemas
means doing the work twice.

---

<a name="15"></a>
## 1. Fresh installs never create the cap uniqueness index — audit #15

**Confirmed.** `idx_category_budget_limits_pair` appears exactly once in the
codebase, at `app_database.dart:713`, inside `_migrateToV19`. It is a *partial*
unique index (`WHERE deleted_at IS NULL`), so it is not expressible as a Drift
`@TableIndex` and is absent from `allSchemaEntities`. `onCreate` only creates
declared entities, so a database created fresh at schema 23 has no such index.

**Consequence.** Two installs of the same build enforce different constraints.
A fresh install can hold two live caps for one `(budget, category)` pair, after
which `setCategoryLimit`'s `getSingleOrNull` throws — the screen breaks and stays
broken. An upgraded install rejects the second insert instead.

**Fix.** Install the index from `beforeOpen`, which already hosts
`_installSyncStatusGuards()` and runs on every open regardless of whether the
database was created or upgraded. `CREATE UNIQUE INDEX IF NOT EXISTS` is
idempotent. De-duplicate first — a fresh install that already accumulated
duplicates would otherwise fail to open for ever, which is the worst possible
outcome. Keep the most recently updated row of each pair.

Harden `setCategoryLimit` to tolerate duplicates rather than throw, so a store
that somehow holds them degrades instead of breaking.

---

<a name="1"></a>
## 2. Restore clears the stored cursor but not the live one — audit #1

**Confirmed.** `sync_service.dart:228` reads the persisted cursor only when
`!_lastSyncLoaded`. After the first sync the value lives in memory.
`BackupService.restore()` deletes the database row; the running `SyncService`
never notices. `reloadAllData` invalidates data providers, not the sync service.

**Consequence.** The next sync asks for changes since a moment the restored rows
were never part of, so anything the server holds from before that point is never
pulled — and the sync reports success and writes a *new* cursor, so restarting
the app does not repair it. Silent, permanent data omission.

**Fix.** Delete the cache. `_lastSyncAt`/`_lastSyncLoaded` exist only to avoid
one indexed local read per sync, which is nothing beside the network round trip
that follows it. Reading the cursor from the database at the point of use makes
the desync impossible by construction rather than by remembering to call a
reset — which is the same class of mistake as the one being fixed.

Also refuse to restore while a sync is in flight, and force the restored state
through a full pull.

---

<a name="2"></a>
## 3. Restoring a deleted transaction strands it or loses it — audit #2

**Confirmed, and the root cause is earlier than the audit places it.**

`softDeleteTransaction` writes `pendingDelete` unconditionally. For a row that
was `pendingCreate` — created and deleted before it ever reached the server —
that overwrite *destroys the only evidence* that the server has never seen it.
`restoreTransaction` then maps `pendingDelete → pendingUpdate`, and the server
answers "not found" to that for ever. This is exactly the stranding failure the
doc comment on `SyncStatus.markEdited` describes at length, walked into by two
methods written afterwards.

`serverId` cannot rescue it: the column exists but the sync service never writes
it, so it is null for every row.

The second half is server-side. A push that updates a tombstoned row is accepted
without clearing `DeletedAt`, so the row stays deleted in the cloud and the next
pull deletes the local copy again.

**Fix, both sides.**

*Client:* restore sets `pendingCreate`, never `pendingUpdate` — the same
reasoning already written down for backup restore. A create for a row the server
holds is an accepted no-op; an update for a row it does not hold is fatal and
permanent. The asymmetry decides it.

*Server:* a create or update for a soft-deleted row clears `DeletedAt` when the
incoming `UpdatedAt` is newer than the stored one. Resurrection has to be
explicit and last-writer-wins, consistent with the rest of the conflict model.
Without this the client change alone still leaves the row deleted in the cloud.

---

<a name="3"></a>
## 4. Local restore leaves balances stale and can restore half a transfer — audit #3

**Confirmed by reading.** `restoreTransaction` clears one tombstone and touches
nothing else. The screen then invalidates providers, which re-read *stored*
balances — and the stored balance was decremented when the row was deleted.

A transfer is two rows plus an optional fee (`feeForTransactionId`). Restoring
the leg the user happened to tap leaves its partner deleted, which fails
`TransferIntegrity` and is rejected by the server.

**Fix.** A domain operation that restores the whole group — the row, its
`pairedTransactionId` partner, and any row whose `feeForTransactionId` points at
either — inside one database transaction, then recalculates every affected
wallet balance. The screen calls that instead of the raw database method.

---

<a name="4"></a>
## 5. Merging wallets produces transfers the server rejects — audit #4

`mergeInto` moves each live source row's `walletId` independently.

Two defects follow. A transfer between the source and the destination ends with
both legs on one wallet, violating the distinct-wallet invariant — the wallet
rows sync while the transaction edits are refused. And in a cross-currency merge
the moved leg's amount is rewritten without touching the partner's
`counterAmount` or the pair's `fxRate`, so the pair now disagrees about how much
crossed.

**Fix.** Treat transfers as pairs.

- A transfer whose two legs both end up in the destination is deleted, both legs
  and any fee together. It nets to zero within one account, so removing it does
  not move the balance, and a transfer from an account to itself has no meaning.
  Report the count rather than doing it silently.
- A transfer to a third wallet keeps its partner; when the moved leg's amount is
  converted, the partner's `counterAmount` and the shared `fxRate` are rewritten
  to match.

~~Recurring configurations that name the source wallet are repointed in the same
operation.~~ **Not done, because there is nothing to do:** a recurring config
names a base transaction, not a wallet, and that transaction moves with
everything else. The instruction was written from a wrong assumption about the
schema and is struck through rather than deleted, so the next reader does not
re-derive it.

---

<a name="5"></a>
## 6. Editing a transfer's notes rewrites its historical amount — audit #5

**Confirmed by reading.** `updateTransfer` calls `_resolveConversion(...)`
unconditionally, passing `receivedAmount` — which the provider and UI never
supply. With no explicit figure the helper fetches *today's* rate and rewrites
the income leg. Changing a note re-prices a transfer that happened months ago.

**Fix.** Re-resolve only when the conversion can actually have changed: the
amount, an explicit received amount, or either wallet was edited. Otherwise
carry the stored `amount`, `counterAmount` and `fxRate` through untouched. A
historical rate is a record of what happened, not a derived value.

---

<a name="8"></a>
## 7. Bulk account move silently reinterprets the amount — audit #8

The bulk picker offers every account and forwards only `walletId`. A USD 100
expense moved to a BDT account becomes BDT 100, and the balance recalculation
then applies the wrong figure faithfully.

**Fix.** Offer only accounts in the currency the selected rows already sit in.
When a selection spans currencies, say so and offer nothing rather than picking
one. Converting silently is not an option: the amount is what the user recorded.

---

<a name="9"></a>
## 8. Budgets and the heatmap add different currencies together — audit #9

Both sum raw minor units with no wallet lookup, and both label the result in the
default currency. `DailyNetCalendar.build` has no currency awareness at all —
this one is new in the phase-7 work and was written that way from the start.

**Fix.** Convert to the display currency before aggregating, using the existing
`CurrencyService`. A budget's currency is the currency of its scoped wallets
when they agree, and the default otherwise. Where no rate is known, exclude the
amount and say so rather than adding it as though it were the same money — the
same rule the cross-currency transfer already follows.

---

<a name="6"></a>
## 9. Two devices setting the same cap cannot converge — audit #6

The server enforces one live row per `(budget_id, category_id)` but makes creates
idempotent by row id. Two offline devices generate different UUIDs for the same
logical cap; the second push hits a database uniqueness violation with no
resolution path, and on a client with the partial index the winning row cannot
be pulled either. The cursor stops advancing — the account's sync wedges.

**Fix.** Resolve by the natural key on the server, following the precedent
already in the codebase for categories (`SyncCategoryResolutionResult`): when a
create collides with a live row for the same pair, adopt the existing row, return
its canonical id against the requested one, and let the client re-key. Apply the
incoming value when its `UpdatedAt` is newer, so the two devices converge on the
later edit rather than on whoever pushed first.

A deterministic id derived from the pair was considered and rejected: it would
require re-keying every existing cap, which is the same migration problem in a
worse place.

---

<a name="7"></a>
## 10. Category reconciliation orphans caps — audit #7

**Confirmed:** `_absorbCategoryInner` contains no reference to
`categoryBudgetLimits`. It moves transactions, subcategories, budget scopes and
associated titles, then removes the losing category — leaving any cap pointing
at an id that no longer exists, permanently unpushable.

**Fix.** Repoint caps during absorption, and resolve the collision when both
categories already cap the same budget: keep the survivor's row, delete the
loser's, and take the larger limit so a cap never silently tightens.

Also mark repointed associated titles as edited. That table syncs now; the
reconciliation code predates it and only rewrites the category id, so the change
never reaches the server.

---

<a name="10"></a>
## 11. Cross-currency transfers are unreachable in the form — audit #10

The service and the backend support them; both wallet pickers still filter to a
single currency, and there is no received-amount field. The feature exists and
cannot be used.

**Fix.** Drop the currency filters, show a received-amount field when the two
wallets differ, and pass it through the provider. Replace the widget tests that
still assert the old exclusion — they pass today and are pinning the wrong
behaviour.

---

<a name="11"></a>
## 12. Naming rules are stored and synced but never read — audit #11

**Confirmed:** nothing in the add-transaction path consults the rules. The form
suggests categories from `titleUsageSearchProvider`, which reads transaction
history only. A rule the user writes cannot change anything.

**Fix.** Consult the rules when a title is entered, exact match before contains,
falling back to history. Editing a rule updates it by id; the present
title-keyed upsert creates a second rule whenever the title is what changed.

---

<a name="12"></a>
## 13. CSV import discards genuine repeat purchases — audit #12

The fingerprint set is seeded from existing rows *and* added to as the file is
read, so two real coffees of the same amount on one day collapse into one — even
on a first import into an empty ledger. I chose this deliberately and wrote a
test asserting it; the test's name says "not both dropped" while its assertion
says one was. That contradiction was a signal I ignored.

**Fix.** Match multiplicities, not membership: count how many rows already carry
each signature, count how many the file carries, and import the difference. Two
coffees in the file and none on record imports two. Two in the file and two on
record imports none. Re-importing an overlapping statement stays safe, which was
the actual goal.

---

<a name="13"></a>
## 14. Rollover silently discards carry older than 24 periods — audit #13

**Confirmed:** the loop starts at `windows - _maxRolloverLookback` with
`carried = 0`. The comment reads "Bounded so a budget started years ago cannot
make this unbounded work" — cost was reasoned about, correctness was not. A
daily budget begins losing earned headroom after 24 days.

**Fix.** Remove the bound and remove the reason for it. The cost was one spend
query per window; fetch the scoped transactions once from the budget's start and
bucket them by window index in memory, which is a single query regardless of how
many windows there are. The limit then has nothing left to protect.

---

<a name="14"></a>
## 15. Month-end windows drift and cannot be walked backwards — audit #14

Stepping forward clamps 31 January to 28 February, and the next step is taken
from the clamped day, so every later window drifts away from the anchor.
Stepping back from 28 February gives 28 January, which precedes the budget's
start, so the history navigator refuses to move. The backend resolver shares the
approach.

**Fix.** Derive every boundary from the original anchor and a period index —
`anchor + n × period` — never from the previous window's clamped value. Clamping
becomes a display detail of one window rather than an accumulating error, and
the operation becomes reversible because the index is.

---

<a name="16"></a>
## 16. Payment-method details never reach the cloud — audit #16

The form collects type, last four digits and institution; the push mapper sends
name, icon and default only, and the backend entity has nowhere to put them. A
second device or a cloud restore loses what the user was asked to type. Roadmap
item 0.3 listed this and it was not done.

**Fix.** Additive column on the backend entity plus migration, the fields
through both sync DTOs, and the client mapper on both sides. Server first, as
the protocol requires. A two-device round-trip test.

---

## 17. Roadmap labels

Several phases are marked done that are not. The labels were written by the same
hand that wrote the code and were not checked against the feature list. Revise
them against this audit, and state the deferrals plainly rather than as
parentheses.

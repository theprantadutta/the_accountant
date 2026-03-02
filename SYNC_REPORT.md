# Sync System Report — The Accountant

## Overview

The Accountant uses a **local-first, push-then-pull** synchronization system. All data lives in a local Drift (SQLite) database and is optionally synced to a .NET backend via REST API. **Sync is gated behind a Premium subscription** — free users never sync.

---

## Architecture

### Frontend (Flutter)

| File | Role |
|------|------|
| `lib/core/services/sync/sync_service.dart` | Core sync engine — pushes local changes, pulls remote changes, applies them to local DB |
| `lib/core/services/sync/sync_models.dart` | DTOs: `SyncChange`, `SyncPushRequest/Response`, `SyncPullResponse`, `SyncConflict`, `SyncResult` |
| `lib/core/providers/sync_provider.dart` | Riverpod provider: `SyncNotifier` exposes `syncAll()`, `triggerAutoSync()`, `startPeriodicSync()` |
| `lib/data/models/sync_state.dart` | Drift table `SyncStates` for tracking per-table sync metadata (not actively used — see Issues) |
| `lib/core/services/api_service.dart` | HTTP client (Dio) with JWT auth, token refresh interceptors |
| `lib/features/authentication/presentation/widgets/auth_wrapper.dart` | Lifecycle triggers for sync |

### Backend (.NET)

| File | Role |
|------|------|
| `SyncController.cs` | 4 endpoints under `/api/v1/sync/` — all require `[Authorize]` + `[PremiumRequired]` |
| `PushChangesCommandHandler.cs` | Applies client changes to server DB, handles wallet balance adjustments, concurrency retries |
| `PullChangesQueryHandler.cs` | Returns all entities modified since a given timestamp |
| `GetSyncStatusQueryHandler.cs` | Returns per-table `SyncLog` entries (last sync time, server version) |
| `UpdateSyncStatusCommandHandler.cs` | Updates per-table sync metadata |
| `SyncDtos.cs` | Shared DTOs: `SyncChange`, `SyncPushRequest/Response`, `SyncPullResponse`, `SyncConflict` |
| `SyncLog.cs` | Domain entity tracking per-user, per-table sync metadata |
| `SyncLogConfiguration.cs` | EF Core config — unique index on `(UserId, TableName)` |

---

## What Gets Synced

7 entity types are synced bidirectionally:

| Entity | Push | Pull | Soft Delete |
|--------|------|------|-------------|
| Transactions | yes | yes | `deletedAt` timestamp |
| Wallets | yes | yes | `deletedAt` timestamp |
| Categories | yes | yes | `deletedAt` timestamp |
| Budgets | yes | yes | `deletedAt` timestamp |
| Objectives | yes | yes | `deletedAt` timestamp |
| Payment Methods | yes | yes | `deletedAt` timestamp |
| Recurring Configs | yes | yes | `isActive = false` (no `deletedAt`) |

**Not synced but have `syncStatus` column**: `ExchangeRates`, `AssociatedTitles` — these have the tracking column in the local DB but the `SyncService` does not collect or push their changes. The backend `GetSyncStatusQueryHandler` lists them in `SyncableTables` but they have no push/pull handler.

---

## Sync Flow

### Step-by-step

```
1. syncAll() called
2. Premium check → reject if not premium
3. Connectivity check → reject if offline
4. Auth check → reject if no JWT token
5. PUSH phase:
   a. Query local DB for all records with syncStatus > 0
      (pendingCreate=1, pendingUpdate=2, pendingDelete=3)
   b. Build SyncChange list with operation + full entity data
   c. POST /sync/push → server applies each change
   d. Mark all pushed records as syncStatus = 0 (synced) locally
6. PULL phase:
   a. GET /sync/pull?since={lastSyncAt}
   b. Server returns all entities modified since that timestamp
   c. For each returned change, upsert into local DB with syncStatus=0
   d. Update _lastSyncAt in memory
7. Refresh all Riverpod data providers (wallets, categories, transactions, etc.)
```

### Push (Client → Server)

The client serializes entities to **PascalCase** JSON maps (e.g., `WalletId`, `Amount`, `IsIncome`). The backend deserializes with `PropertyNameCaseInsensitive = true`.

For each change, the backend:
- **Create**: Checks if entity already exists (idempotent — skips if yes), inserts, adjusts wallet balance for transactions
- **Update**: Loads existing entity, applies last-write-wins check (`entity.UpdatedAt > data.UpdatedAt` → skip), reverses old wallet balance effect, applies new values, applies new balance effect
- **Delete**: Sets `DeletedAt = DateTime.UtcNow` (or `IsActive = false` for recurring configs), reverses wallet balance

After all changes, `SaveChangesAsync` is called with up to **3 retries** for `DbUpdateConcurrencyException` (reloads wallet entries between attempts).

### Pull (Server → Client)

The server queries all entities where `UpdatedAt > since` for the authenticated user. The operation is determined dynamically:
- `DeletedAt != null` → `"delete"`
- `CreatedAt > since` → `"create"`
- Otherwise → `"update"`

The client normalizes **snake_case** keys from the server JSON to **PascalCase** before applying. For each change it does an upsert: if the entity ID exists locally, update it; otherwise, insert it. All applied records get `syncStatus = 0` (synced).

---

## When Sync Happens

| Trigger | Location | Mechanism |
|---------|----------|-----------|
| **App startup** | `auth_wrapper.dart:115` | `triggerAutoSync()` called in `_runStartupChecks()` |
| **App resume** (foreground) | `auth_wrapper.dart:69` | `triggerAutoSync()` in `didChangeAppLifecycleState(resumed)` |
| **Periodic timer** | `sync_provider.dart:91` | `startPeriodicSync()` → every **15 minutes** |
| **App pause** (background) | `auth_wrapper.dart:72` | `stopPeriodicSync()` — timer cancelled |
| **User logout** | `auth_wrapper.dart:134` | `stopPeriodicSync()` — timer cancelled |

There is **no manual sync button** in the UI currently — sync is entirely automatic.

There is **no sync triggered after individual CRUD operations** (e.g., creating a transaction doesn't immediately sync — it waits for the next auto-sync cycle).

---

## Conflict Resolution

### Strategy: Last-Write-Wins (LWW)

On the **backend push handler**, for updates:
```csharp
if (data.UpdatedAt != default && entity.UpdatedAt > data.UpdatedAt)
    return true; // Server version is newer, silently skip client change
```

This means:
- If the server entity is **newer** than the client's version → client change is discarded (silently succeeds)
- If the client entity is **newer** → client change is applied
- If `UpdatedAt` is `default` (zero) → client change always applies (no timestamp check)

### Concurrency Handling

The push handler wraps `SaveChangesAsync` in a retry loop (max 3 attempts) for `DbUpdateConcurrencyException`. On conflict, it reloads wallet entities and retries. This handles concurrent balance modifications.

### Conflict Reporting

Conflicts (entity not found, access denied, exceptions) are returned in the `SyncPushResponse.Conflicts` list. The client logs the conflict count but **does not surface conflicts to the user** or attempt resolution.

---

## Authentication

- **JWT Bearer tokens** stored in `FlutterSecureStorage`
- Automatic token refresh via Dio interceptor when token is expiring soon
- On 401: attempts one token refresh using refresh token, retries the request, then triggers logout if refresh fails
- Backend uses `[Authorize]` attribute + `ICurrentUserService.UserId` extracted from JWT claims
- All sync endpoints additionally require `[PremiumRequired]` filter

---

## Local DB Sync Tracking

Every syncable table has an `IntColumn syncStatus` with default `0`:

```dart
class SyncStatus {
  static const int synced = 0;          // No pending changes
  static const int pendingCreate = 1;   // New record, not yet pushed
  static const int pendingUpdate = 2;   // Modified record, not yet pushed
  static const int pendingDelete = 3;   // Deleted record, not yet pushed
  static const int conflict = 4;        // Conflict detected (unused)
}
```

Records are queried for push via `syncStatus > 0`. After successful push, all pending records across all tables are bulk-updated to `syncStatus = 0`.

The app also has a `resetAllSyncStatuses()` method that clears all pending statuses across all tables — used during data reset operations.

---

## Issues and Concerns

### 1. `_lastSyncAt` is in-memory only — lost on app restart
The `SyncService._lastSyncAt` field is a non-persisted instance variable. Every time the app restarts, it's `null`, meaning the first pull after restart fetches **all data from the server since the beginning of time** (`DateTime.MinValue`). This causes unnecessary data transfer. The `SyncStates` Drift table exists for this purpose but is **never read or written to** by `SyncService`.

### 2. Push marks ALL pending records as synced before confirming per-record success
`_markPushedRecordsAsSynced()` bulk-updates every record with `syncStatus > 0` to `synced`, regardless of whether individual records had conflicts. If the server returns conflicts for some records, those are still marked as synced locally and their changes are silently lost.

### 3. `ExchangeRates` and `AssociatedTitles` have sync columns but no sync implementation
These tables have `syncStatus` columns and are listed in the backend's `SyncableTables`, but the `SyncService` doesn't collect their pending changes for push, and the `PullChangesQueryHandler` doesn't query them.

### 4. No sync after individual CRUD operations
Creating/updating/deleting a transaction, wallet, etc. only sets `syncStatus` locally. The actual sync only happens on the next auto-sync cycle (up to 15 minutes later, or on next app resume). If the user makes changes and immediately switches devices, those changes won't be on the server yet.

### 5. `conflict = 4` status is defined but never used
The `SyncStatus.conflict` value (4) is defined in the constants but nothing ever sets a record to this status. Conflict resolution on the server silently drops the client change and the client marks it as synced anyway.

### 6. Pull response key casing mismatch relies on fragile normalization
The backend serializes with `snake_case` (via `JsonNamingPolicy.SnakeCaseLower`), but the pull apply methods expect PascalCase keys. The `_normalizeKeys()` helper converts snake_case to PascalCase, but the `SyncChange.fromJson()` factory also handles multiple casing variants with fallback chains (`json['table_name'] ?? json['tableName'] ?? json['TableName']`). This works but is brittle — a backend naming policy change could break deserialization silently.

### 7. Backend wallet balance manipulation during sync lacks safeguards
When the push handler processes transaction creates/updates/deletes, it directly modifies `Wallet.Balance` in memory. If multiple transactions for the same wallet are pushed in one batch, balance changes compound within the same `SaveChangesAsync` call. The concurrency retry only reloads wallets for transactions specifically, not for other entity types.

### 8. No UI feedback for sync status
The `SyncNotifier` exposes state via a Riverpod provider and there's an `isSyncingProvider`, but there doesn't appear to be any UI widget displaying sync status, last sync time, or errors to the user. Sync failures are silently caught by `triggerAutoSync()`.

### 9. Backend `SyncLog` version tracking is unused
The `SyncLog` entity has a `LastServerVersion` field and the `currentVersions` in `SyncPullResponse` simply returns row counts. The version numbers aren't used for incremental sync — the client only uses timestamps. The `UpdateSyncStatus` endpoint exists but the client never calls it.

### 10. Full-table scan on every pull
`PullChangesQueryHandler` queries all 7 tables on every pull, even if nothing changed. For large datasets this could be slow. There's no short-circuit if nothing has been modified since the last sync.

---

## Summary

The sync system is **structurally complete** — push and pull cover all major entities, auth is handled, conflict resolution exists (LWW), and lifecycle triggers automate the process. However, the implementation has several gaps around **reliability** (in-memory-only timestamps, bulk sync-status marking ignoring conflicts) and **efficiency** (full pulls on restart, no per-table change detection). The missing persistence of `_lastSyncAt` is the most impactful issue, as it causes full data pulls on every app restart.

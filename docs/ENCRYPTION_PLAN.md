# Encryption plan

Goal: users' financial data is unreadable to anyone but them — on the phone, in
backups, and on our server — with an opt-in passphrase for users who want the
server itself locked out. Ships as **5.0.0** (major: old versions must update
to keep syncing).

## Decisions (from the user, 1 Nov 2026)

- **Passphrase is opt-in.** Default users get encryption with a key the server
  holds (protects against a leaked database or backup file). Users who opt in
  get a passphrase + recovery code and the server keeps only wrapped copies.
  The opt-in screen must explain in detail what changes if they opt in, what
  happens if they don't, and that losing both passphrase and recovery code
  means the data is gone for good. Never enable it without explicit consent.
- **Synced data is encrypted for everyone who syncs** (sync is Premium-only, so
  this is a small group). One code path.
- **Server-side reminders move to the phone** (credit-card bills, plan/EMI
  reminders). Settings must say plainly that if you don't open the app
  regularly you may not get every reminder on time.
- **AI chat history is stored encrypted.** AI requests themselves still send a
  readable financial summary to the server and the model — a disclosed
  exception, not hidden.
- **Old app versions must update to sync.** The server rejects sync from
  builds older than 5.0.0 with a clear "update to keep syncing" response.

## Phase 1 — done (4.4.x)

- Local stores encrypted at rest (SQLite3MultipleCiphers, device-only key in
  the keystore). `lib/data/datasources/local/store_encryption.dart`.
- Android cloud backup / device transfer disabled for app data.
- Backups sealed with the account data key (AES-256-GCM).
  `lib/features/backup/domain/backup_seal.dart`, backend
  `GET /api/v1/encryption/key`.
- Financial details in SharedPreferences sealed. `lib/core/services/sealed_prefs.dart`.

## Phase 2 — status (1 Nov 2026)

Built and pushed; backend deployed to production:
- A. Passphrase + recovery code — backend + app (Privacy & security →
  Passphrase protection), 10 languages.
- B. Encrypted sync — `lib/core/services/sync/sync_sealer.dart`; server
  `EncryptedData` columns; one-time re-upload of existing rows on first 5.0 sync.
- C. Card/plan reminders on the phone
  (`lib/features/notifications/services/bill_reminders.dart`) with a Settings
  note; server jobs skip sealed rows. AI chat encrypted at rest on the server
  (`ENCRYPTION_AT_REST_KEY`).
- Version 5.0.0+38.

Still to do before/at release:
- After 5.0 is live on the stores, set `Sync__MinimumAppVersion=5.0.0` on the
  server.
- Privacy policy + store listing + Data safety / App Privacy wording for E2EE.
- Optional: remove the legacy REST CRUD controllers on the server.

Lesson: the real server sends snake_case keys (`encrypted_data`); the fake
sync server in tests echoes PascalCase. A sealer bug that only matched camel
case passed every test and was caught on a phone against production. Test new
sync fields against the real naming.

## Phase 2 — stages

### A. Opt-in passphrase + recovery code
- Backend `User`: `WrappedDataKey`, `WrappedDataKeyRecovery`, `KdfSalt`,
  `KdfParams` (JSON), `PassphraseEnabledAt`. Enabling stores the wrapped copies
  and nulls `DataKey` in the same write.
- `GET /encryption/key` returns either `{ key }` or
  `{ protected: true, wrappedKey, wrappedKeyRecovery, kdfSalt, kdfParams }`.
- `POST /encryption/passphrase` (enable / change / new recovery code),
  `DELETE /encryption/passphrase` (turn off: client returns the plain key).
- Client: Argon2id (run off the UI isolate), AES-256-GCM wrap. Client refuses
  KDF params below its floor so a server can't weaken them. Verify the wrap
  unwraps locally before sending. Unlock prompt on a device without the cached
  key; recovery code path; change passphrase; turn off.
- UI: Privacy & security → "Passphrase protection" with the detailed
  explanation, set/confirm passphrase, show recovery code, confirm saved.

### B. Encrypted sync
- Every synced table gets an encrypted payload column; financial fields
  (amounts, titles, notes, names, provider, reference, symbol, price, …) travel
  only inside it. Plaintext metadata stays: ids, `UpdatedAt`/`DeletedAt`,
  type, income flag, paid flags, special type, dates needed for sync, foreign
  keys, `DefaultKey`, currency.
- Server checks that read values move to the client: transfer-pair amounts,
  title length, legacy category name matching, investment name trim.
  `OccurrenceKey` dedupe stays (it's not financial).
- Minimum client version on `/sync/*` (5.0.0).
- One-time re-upload of every row encrypted; plaintext columns wiped once the
  account has re-uploaded.

### C. Server features that read amounts
- Card and plan reminders → local notifications; Settings note about missed
  reminders. Remove `CardReminderJob`, `PlanReminderJob`, dormant
  `BudgetCheckJob`.
- Remove the legacy REST CRUD controllers (sync replaced them).
- `NotificationHistory` bodies with amounts: stop writing them server-side.
- AI chat history stored encrypted (client-side key).

### D. Release 5.0.0
- Privacy policy and store data-safety/App Privacy updates; store listing
  mentions encryption.

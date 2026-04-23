# Subscription Testing Guide

End-to-end procedures for verifying the subscription flow works in sandbox.

## Dev environment

**Backend:**
```bash
cd the-accountant-backend/src/TheAccountant.Api
dotnet run
# Listening on http://localhost:8002
```

**Frontend** (`.env` pointing at dev URL):
```bash
cd the_accountant
flutter run
```

The Dio client prepends `/api/v1` automatically (`api_service.dart:53`), so
IAP calls to `/iap/verify` hit `http://localhost:8002/api/v1/iap/verify`.

## Pre-flight: confirm endpoint reachability

With a valid JWT in the secure storage, the app should be able to call:

```bash
# Replace <JWT> with a real access token from the app's secure storage
curl -H "Authorization: Bearer <JWT>" \
  http://localhost:8002/api/v1/iap/subscription-status
```

Expected response (free user):
```json
{
  "tier": "free",
  "expires_at": null,
  "is_premium": false,
  "product_id": null,
  "platform": null,
  "grace_period_ends_at": null,
  "is_in_grace_period": false,
  "days_until_grace_period_ends": 0
}
```

**Gotcha:** all fields are snake_case. The frontend was previously reading
camelCase and silently failing. If you see `is_premium` returning `true` but
the app still treats the user as free, check `iap_service.dart` hasn't
regressed.

## Android sandbox testing

### Setup

1. Complete `google-play-setup.md` (products created + license testers added).
2. Sign in as a license tester on your physical Android device.
3. Build a signed release AAB with the tester device's signing key:
   ```bash
   flutter build appbundle --release
   ```
4. Upload to Internal Testing track in Play Console.
5. Visit the opt-in link from Play Console on the test device → install.

### Purchase test — Yearly subscription

1. Open app → navigate to a premium feature (e.g., AI Chat) → paywall appears.
2. Tap **Yearly**.
3. Google purchase sheet: payment method shows "Test card, always approves."
4. Tap **Subscribe** → "Purchase successful" → app returns to prior screen.
5. **DB check** (in psql against `the_accountant` DB):
   ```sql
   SELECT id, subscription_tier, subscription_expires_at,
          iap_product_id, iap_purchase_token, iap_platform,
          grace_period_ends_at
   FROM users
   WHERE id = '<your user ID>';
   ```
   Expected:
   - `subscription_tier = 'premium_yearly'`
   - `subscription_expires_at ≈ now() + 365 days`
   - `iap_product_id = 'com.pranta.the_accountant.premium.yearly'`
   - `iap_purchase_token` populated (long opaque string)
   - `iap_platform = 'android'`
   - `grace_period_ends_at IS NULL`
6. **Audit check:**
   ```sql
   SELECT event_type, verification_status, created_at
   FROM subscription_events
   WHERE user_id = '<your user ID>'
   ORDER BY created_at DESC
   LIMIT 5;
   ```
   Should show at least one row with `event_type = 'purchased'` and
   `verification_status = 'verified'`.
7. **Log check** (backend stdout):
   ```
   [INFO] Verifying purchase for user ..., product com.pranta.the_accountant.premium.yearly, platform android
   [INFO] Subscription verification for com...yearly: Valid=True, ExpiryTime=..., PaymentState=1
   [INFO] Acknowledged subscription purchase com.pranta.the_accountant.premium.yearly
   [INFO] Purchase verified successfully for user ..., product com...yearly
   ```
8. **State propagation check** in the app: navigate to Settings → premium status
   should show "Premium Yearly". Restart the app → status persists (loaded from
   SharedPreferences by `PremiumNotifier._loadPersistedPremiumStatus`).

### Lifetime purchase test

Same as above, but tap **Lifetime**. Expected DB state:
- `subscription_tier = 'premium_lifetime'`
- `subscription_expires_at IS NULL` (never expires)
- `iap_product_id = 'com.pranta.the_accountant.premium.lifetime'`

## iOS sandbox testing

### Setup

1. Complete `app-store-setup.md` (products + sandbox tester created).
2. On the iOS device: **Settings → App Store → Sandbox Account** → sign in as
   the sandbox tester.
3. Build and run from Xcode (release or debug both work in sandbox):
   ```bash
   flutter build ios --release
   open ios/Runner.xcworkspace  # archive + deploy to device
   ```

### Purchase test

Same flow as Android. Key differences:

- Apple sandbox accelerates subscription renewals: 1 month = 5 real minutes,
  1 year = 1 hour. Useful for testing renewal ASSN v2 payloads.
- Backend log trail (from `AppleStoreKitVerificationService`):
  ```
  [INFO] Apple verification for com...yearly: Valid=True, Expiry=..., Subscription=True, TxnId=...
  ```
- `iap_platform = 'ios'`
- `apple_original_transaction_id` populated on the `users` row (used by
  `AppleWebhookService` to match ASSN v2 notifications to users).

## RTDN simulation (Google Play)

To test webhook handling without waiting for a real lifecycle event, publish a
fake message to the RTDN topic:

```bash
# Construct a fake RTDN payload (base64-encoded JSON)
PAYLOAD=$(echo -n '{
  "version": "1.0",
  "packageName": "com.pranta.the_accountant",
  "eventTimeMillis": "'$(date +%s)'000",
  "subscriptionNotification": {
    "version": "1.0",
    "notificationType": 3,
    "purchaseToken": "<real purchase token from users.iap_purchase_token>",
    "subscriptionId": "com.pranta.the_accountant.premium.yearly"
  }
}' | base64)

gcloud pubsub topics publish play-rtdn \
  --project=the-accountant-prod \
  --message="{\"message\":{\"data\":\"$PAYLOAD\"},\"subscription\":\"test\"}"
```

`notificationType = 3` is `SUBSCRIPTION_CANCELED`. Full list in Google's RTDN docs.

Expected:
- Backend logs: `Received Google Play webhook notification`
- `SubscriptionEvents` gets a new row with `event_type = 'subscription.canceled'`
- User's `subscription_tier` stays `premium_yearly` until `expires_at`
  (cancel != revoke — user keeps access until the period they paid for ends).

## Forced expiry test

Simulate a user whose subscription ran out:

```sql
UPDATE users
SET subscription_expires_at = now() - interval '1 day'
WHERE id = '<your user ID>';
```

Now hit a `[PremiumRequired]` endpoint — should return 403:
```bash
curl -H "Authorization: Bearer <JWT>" \
  http://localhost:8002/api/v1/sync/pull?since=2024-01-01
# 403 Forbidden { "detail": "Premium subscription required", "code": "PREMIUM_REQUIRED" }
```

## Grace period test

Simulate a user whose payment failed but is still in the 3-day grace window:

```sql
UPDATE users
SET subscription_expires_at = now() - interval '1 day',
    grace_period_ends_at = now() + interval '2 days'
WHERE id = '<your user ID>';
```

`[PremiumRequired]` endpoints should still return 200 (the `User.IsPremium`
computed property checks `IsInGracePeriod`).

After 2 days (or forcing `grace_period_ends_at` to be in the past):
- `IsInGracePeriod` returns false
- `IsPremium` returns false
- Endpoints return 403

## Restore purchases test

Scenario: user buys Premium on phone A, installs the app on phone B, signs in.

1. On phone B, open the app → paywall still shows (because B's local state is empty).
2. Tap **Restore Purchases**.
3. Frontend calls `iap.restorePurchases()` → purchase stream fires with the existing
   purchase → `iap_service.dart` sends it to `/iap/verify` as a restored purchase.
4. Backend finds the existing `iap_purchase_token` on a different user row →
   either binds it to the current user or errors (depending on your restore policy
   in `RestorePurchaseCommandHandler`).
5. After success, paywall closes + app state flips to premium.

## Snake_case regression smoke test

Temporarily add logging to `iap_service.dart`:

```dart
_logger.d('IAP /verify response: ${response.data}');
_logger.d('IAP /subscription-status response: ${response.data}');
```

After a purchase, the logged response should show snake_case fields like
`is_premium`, `new_tier`, `expires_at`, `grace_period_ends_at`. If you see
camelCase keys, the backend's `Program.cs:119` naming policy has been reverted.
If you see both, something's double-converting — fix the config, not the reader.

## Common pitfalls

| Symptom | Fix |
|---|---|
| Products load empty on paywall | Tester not on Internal Testing track; wait 6-24h after product creation; check device has Play Store account matching tester account |
| Purchase succeeds but app stays locked | Check `PremiumIapSyncProvider` is mounted in `app.dart` and listening |
| `is_premium: true` returned but UI stays on free tier | `premium_sync_provider.dart` not updating `premiumProvider` — check Riverpod DevTools state |
| Backend returns 401 on IAP endpoints | JWT expired; token refresh should auto-fire, but check `ApiService` 401 interceptor logs |
| Google Play auto-refunds purchase after 3 days | `AcknowledgeAsync` didn't fire — check backend logs for "Acknowledged subscription purchase" after each verify |
| iOS purchase on TestFlight (not sandbox) charges real money | TestFlight uses production IAP, not sandbox. Use Xcode-signed dev/release builds on a device signed into a sandbox tester account for free testing. |

# Real-Time Developer Notifications (RTDN) — Setup

RTDN lets Google Play and Apple push subscription lifecycle events (renewals,
cancellations, grace periods, refunds) to our backend, so we don't have to poll.

**Backend endpoints (already implemented):**
- Google Play RTDN: `POST /api/v1/webhooks/google-play?token=<WebhookToken>`
- Apple ASSN v2: `POST /api/v1/webhooks/apple`
- Health check: `GET /api/v1/webhooks/health`

Controllers: `src/TheAccountant.Api/Controllers/WebhooksController.cs`
Handlers: `WebhookService.cs` (Google), `AppleWebhookService.cs` (Apple).

---

## Part A — Google Play RTDN via Pub/Sub

Google Play pushes RTDN messages into a Cloud Pub/Sub topic; Pub/Sub then pushes
to our webhook.

### A.1 — Enable Pub/Sub API

In the GCP project linked to your Play Console:

```bash
gcloud services enable pubsub.googleapis.com --project=the-accountant-prod
```

### A.2 — Create the topic

```bash
gcloud pubsub topics create play-rtdn --project=the-accountant-prod
```

Full topic name: `projects/the-accountant-prod/topics/play-rtdn`

### A.3 — Grant Google Play permission to publish

Google Play publishes as a reserved service account. Grant it the `Pub/Sub Publisher`
role on the topic:

```bash
gcloud pubsub topics add-iam-policy-binding play-rtdn \
  --member="serviceAccount:google-play-developer-notifications@system.gserviceaccount.com" \
  --role="roles/pubsub.publisher" \
  --project=the-accountant-prod
```

### A.4 — Generate the webhook token

Generate a random 32-character secret:

```bash
openssl rand -base64 32
```

Set it in backend config:

```json
{ "GooglePlay": { "WebhookToken": "<the-generated-secret>" } }
```

The `WebhookService.VerifyWebhookToken` method uses `FixedTimeEquals` to check this.

### A.5 — Create the push subscription

```bash
gcloud pubsub subscriptions create play-rtdn-push \
  --topic=play-rtdn \
  --push-endpoint="https://accountant.pranta.dev/api/v1/webhooks/google-play?token=<WEBHOOK_TOKEN>" \
  --ack-deadline=60 \
  --project=the-accountant-prod
```

(Optional but recommended) Enable OIDC authentication on the push subscription so
only legitimate Pub/Sub pushes are accepted:

```bash
# Create an invoker service account
gcloud iam service-accounts create play-webhook-invoker \
  --display-name="Play Webhook Invoker" \
  --project=the-accountant-prod

# Grant it Pub/Sub invoker role
gcloud pubsub subscriptions add-iam-policy-binding play-rtdn-push \
  --member="serviceAccount:play-webhook-invoker@the-accountant-prod.iam.gserviceaccount.com" \
  --role="roles/pubsub.subscriber"

# Enable OIDC on the subscription
gcloud pubsub subscriptions update play-rtdn-push \
  --push-auth-service-account=play-webhook-invoker@the-accountant-prod.iam.gserviceaccount.com
```

### A.6 — Wire the topic to Play Console

1. Play Console → your app → **Monetize → Monetization setup**.
2. Scroll to **Real-time developer notifications**.
3. **Topic name:** `projects/the-accountant-prod/topics/play-rtdn`
4. Click **Send test notification** → should return `200 OK` with
   `"Message: test received"` in the Play Console UI.
5. Check backend logs — you should see `Received Google Play webhook notification`.

### A.7 — Verification

```bash
curl -s https://accountant.pranta.dev/api/v1/webhooks/health | jq
```

Expected response:

```json
{
  "status": "healthy",
  "endpoints": {
    "googlePlay": "/api/v1/webhooks/google-play",
    "apple": "/api/v1/webhooks/apple"
  }
}
```

---

## Part B — Apple App Store Server Notifications V2 (ASSN v2)

Apple sends signed JWS (JSON Web Signature) notifications to our webhook.
`AppleWebhookService` already validates the x5c certificate chain against Apple's
root CA.

### B.1 — Register the URLs in App Store Connect

1. App Store Connect → your app → **App Information**.
2. Scroll to **App Store Server Notifications → V2**.
3. **Production Server URL:** `https://accountant.pranta.dev/api/v1/webhooks/apple`
4. **Sandbox Server URL:** `https://accountant.pranta.dev/api/v1/webhooks/apple`
   (same URL — `AppleWebhookService` auto-detects the environment from the signed payload).
5. Save.

### B.2 — Populate the Apple config

The webhook endpoint itself is unauthenticated (the signed JWS is the authentication),
but to **decode** notifications we need Apple's public key (pulled from the JWS x5c
chain) and to **query** transaction status we need the API key from `app-store-setup.md`:

```json
{
  "Apple": {
    "KeyId": "<from App Store Connect Keys tab>",
    "IssuerId": "<from the Issuer ID at top of Keys tab>",
    "PrivateKey": "<contents of the .p8 file>",
    "BundleId": "com.pranta.theAccountant",
    "Environment": "Production",
    "SharedSecret": "<for v1 /verifyReceipt, from app's App Information>"
  }
}
```

### B.3 — Send a test notification

1. App Store Connect → App Information → **App Store Server Notifications** section.
2. Click **Request a Test Notification** (both production and sandbox buttons available).
3. Backend should log `Received Apple App Store webhook notification` and write a
   `SubscriptionEvents` row with `EventType = "apple.test"` or similar.

---

## Part C — Google Play Developer API service account

This is **separate** from RTDN. It's the service account that
`GooglePlayVerificationService` uses to call Google's Android Publisher API to
verify purchase tokens and acknowledge purchases.

### C.1 — Create the service account

```bash
gcloud iam service-accounts create play-verification \
  --display-name="Play Developer API Verification" \
  --project=the-accountant-prod

gcloud iam service-accounts keys create play-verification-key.json \
  --iam-account=play-verification@the-accountant-prod.iam.gserviceaccount.com
```

### C.2 — Link in Play Console

1. Play Console → **Setup → API access**.
2. If not already linked, **Link Google Cloud project** → choose `the-accountant-prod`.
3. Find the service account row for `play-verification@...`.
4. Click **Grant access** → select these permissions:
   - **View financial data, orders, and cancellation survey responses**
   - **Manage orders and subscriptions**
5. **Invite user → Send invitation**.

### C.3 — Deploy the key

Mount the JSON key at the path referenced by `GooglePlay:ServiceAccountKeyPath`
in `appsettings.json`:

```json
{
  "GooglePlay": {
    "ServiceAccountKeyPath": "/etc/the-accountant/google-play-service-account.json",
    "PackageName": "com.pranta.the_accountant"
  }
}
```

Alternatively, inline the JSON content in `GooglePlay:ServiceAccountJson`
(useful for container environments with secret env vars).

---

## Part D — Verification checklist

Run these after completing Parts A–C:

### D.1 — Webhook reachability

```bash
curl -X POST \
  "https://accountant.pranta.dev/api/v1/webhooks/google-play?token=<WebhookToken>" \
  -H "Content-Type: application/json" \
  -d '{"message":{"data":"eyJ2ZXJzaW9uIjoiMS4wIn0="},"subscription":"test"}'
```

Expected: `200 OK` with `{"success":true,...}`.

### D.2 — Play Console test notification

Play Console → Monetization setup → **Send test notification** → check backend logs.

### D.3 — Apple test notification

App Store Connect → App Information → **Request a Test Notification** → check
`SubscriptionEvents` table for new row.

### D.4 — Real purchase end-to-end

Follow `testing-guide.md` to make a real sandbox purchase. Within 5 seconds of
purchase completion:

- `Users` row: `subscription_tier`, `subscription_expires_at`, `iap_purchase_token` all populated.
- `SubscriptionEvents` row: `EventType = "purchase.verified"`.

Cancel the subscription in Play Console → within 30s RTDN should fire →
`SubscriptionEvents` row: `EventType = "subscription.canceled"`.

### D.5 — Grace period simulation

Force a payment failure in Play Console sandbox (cancel the test card) → within
minutes RTDN should fire with `SUBSCRIPTION_IN_GRACE_PERIOD` → backend sets
`GracePeriodEndsAt` → `[PremiumRequired]` endpoints still return 200 until grace
period ends.

---

## Troubleshooting

| Symptom | Diagnosis |
|---|---|
| RTDN test notification returns 403 from our backend | `WebhookToken` mismatch — regenerate and update both Play Console push subscription URL and `appsettings.json` |
| RTDN test returns 200 but no DB row | Webhook reached but processing failed — check logs for "Processing Google Play notification" errors |
| Apple test notification times out | Our server didn't respond within 10s — check Kestrel timeout, DB connection pool |
| Verification works but acknowledgement fails (purchases auto-refund after 3 days) | Service account lacks "Manage orders and subscriptions" permission — fix in Play Console API access |
| 401 on verification API calls | Service account key expired or permissions not propagated yet (wait 10-15 min after granting) |

# App Store Connect — Subscription Setup

Step-by-step setup for The Accountant's in-app products in App Store Connect.

## Prerequisites

- [ ] Apple Developer Program membership ($99/year)
- [ ] App Store Connect app record created with bundle ID **`com.pranta.theaccountant`**
  (note the camelCase — this differs from the Android package name by design)
- [ ] Paid apps agreement signed under **Agreements, Tax, and Banking** → **Paid Apps**
- [ ] Banking information + tax forms completed

## Canonical product IDs

Same as Play Store — the frontend uses identical product IDs on both platforms:

| Name | Product ID | Type |
|---|---|---|
| Monthly | `accountant_premium_monthly` | Auto-renewable subscription |
| Yearly | `accountant_premium_yearly` | Auto-renewable subscription |
| Lifetime | `accountant_premium_lifetime` | Non-consumable |

## 1. Create the subscription group

Monthly and yearly must live in the **same subscription group** so users can upgrade/downgrade between them.

1. App Store Connect → your app → **Features → In-App Purchases** (left sidebar).
2. **Subscription Groups → Create**.
3. **Reference name:** `premium_access`
4. **Localized display name (English):** `Premium Access`
5. Save.

## 2. Create the Monthly auto-renewable subscription

1. Features → In-App Purchases → **Create → Auto-Renewable Subscription**.
2. **Reference name:** `Premium Monthly`
3. **Product ID:** `accountant_premium_monthly`
4. **Subscription Group:** `premium_access`
5. **Subscription duration:** 1 month
6. **Price schedule:** Create a new price schedule → Price tier matching **$2.99 USD** → apply to all territories.
7. **Localizations (English) → Display name:** `Premium Monthly`
8. **Localizations (English) → Description:**
   > Unlock AI insights, receipt OCR, unlimited wallets, cloud sync, and premium themes. Automatically renews monthly.
9. **App review screenshot:** upload a 1024×1024 PNG of the paywall screen.
10. **Review notes:** `Subscription unlocks premium features listed in the paywall screen. Verify with any sandbox tester account.`
11. Save as **Ready to Submit**.

## 3. Create the Yearly auto-renewable subscription

Repeat section 2 with:

- **Reference name:** `Premium Yearly`
- **Product ID:** `accountant_premium_yearly`
- **Same subscription group:** `premium_access`
- **Subscription duration:** 1 year
- **Price tier:** matching **$19.99 USD**
- **Description:** `Save 44% vs. monthly. Automatically renews yearly.`
- In the group's **Subscription Level:** set Yearly to a **higher level** than Monthly so Apple offers it as the upgrade path.

## 4. Create the Lifetime non-consumable purchase

1. Features → In-App Purchases → **Create → Non-Consumable**.
2. **Reference name:** `Premium Lifetime`
3. **Product ID:** `accountant_premium_lifetime`
4. **Price tier:** matching **$49.99 USD**.
5. **Description:** `One-time purchase. Permanent Premium access — never renews, never expires.`
6. Upload review screenshot + notes.
7. Save as **Ready to Submit**.

## 5. Introductory offers

Required to match the Play Store's free trial offers.

### Monthly — 7-day free trial

1. Open the Monthly subscription → scroll to **Subscription Prices → Introductory Offer**.
2. **Create Introductory Offer**.
3. **Type:** Free
4. **Duration:** 1 week
5. **Countries:** All eligible
6. **Eligible customers:** New subscribers only
7. Save.

### Yearly — 14-day free trial

Repeat with:
- **Duration:** 2 weeks
- All other settings same as monthly.

## 6. Sandbox testers

Required to test purchases without real charges.

1. App Store Connect → **Users and Access → Sandbox → Testers**.
2. **Add** → fill in a unique email (doesn't need to be a real address, just memorable — you'll create an Apple ID from it for the sandbox).
3. First name, last name, password, country, and date of birth.
4. Save. Apple does **not** send a verification email — the account is ready immediately.
5. On the iOS test device: **Settings → App Store → Sandbox Account** → sign in with this tester email.

## 7. App Store Server API key (for ASSN v2 + receipt validation)

Used by the backend's `AppleWebhookService` to validate signed ASSN v2 notifications and (if using v2 API) to query transaction status.

1. App Store Connect → **Users and Access → Keys → In-App Purchase → Generate API Key**.
2. Name: `the-accountant-prod-inapp`
3. Download the `.p8` file (**you can only download this once**).
4. Note the **Key ID** (shown in the Keys list, e.g. `XXXXXXXXXX`).
5. Note the **Issuer ID** (shown at top of the Keys page, e.g. `57246542-xxxx-xxxx-xxxx-xxxxxxxxxxxx`).

### Backend configuration

Set these values in `appsettings.json` (or better, environment variables):

```json
{
  "Apple": {
    "KeyId": "<Key ID>",
    "IssuerId": "<Issuer ID>",
    "PrivateKey": "<contents of the .p8 file, including BEGIN/END lines>",
    "BundleId": "com.pranta.theaccountant",
    "Environment": "Production"
  }
}
```

For the older **v1 `/verifyReceipt`** endpoint used by `AppleStoreKitVerificationService`, you also need the app's **Shared Secret**:

1. App Store Connect → app → **App Information → App-Specific Shared Secret → Generate**.
2. Add to `appsettings.json`:
   ```json
   "Apple": { "SharedSecret": "<the generated secret>" }
   ```

## 8. Submission flow

iOS is stricter than Android. Before going live:

- All three products must be **Ready to Submit**.
- The first app binary to include IAP must be **submitted for review** with the products attached.
- After first approval, subsequent product changes can be updated independently.

## Troubleshooting

- **"Cannot connect to iTunes Store"** during purchase → sandbox tester not signed in at the iOS **Settings** level (not just within the app).
- **Product not found** in the paywall → product is still in "Waiting for Review" or not linked to the current bundle ID.
- **Purchase goes through but backend rejects** → check `Apple:SharedSecret` is set; check `AppleStoreKitVerificationService` logs; prod/sandbox fallback on status 21007 should trigger automatically.
- **ASSN v2 test notifications time out** → confirm webhook endpoint `https://theaccountant.pranta.dev/api/v1/webhooks/apple` is publicly reachable and responds 200 within 10s.

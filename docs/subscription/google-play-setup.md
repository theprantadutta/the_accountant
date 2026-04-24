# Google Play Store — Subscription Setup

Step-by-step setup for The Accountant's in-app products in Google Play Console.

## Prerequisites

- [ ] Google Play Console developer account (https://play.google.com/console)
- [ ] App record created with package name **`com.pranta.theaccountant`**
- [ ] Merchant account created and linked under **Setup → Payments profile**
- [ ] At least one signed AAB uploaded to **Testing → Internal testing** track
  (Play Console requires this before IAP products can be configured)
- [ ] Paid apps agreement signed under **Agreements, tax, and banking**

## Canonical product IDs

| Name | Product ID | Type |
|---|---|---|
| Monthly | `accountant_premium_monthly` | Auto-renewing subscription |
| Yearly | `accountant_premium_yearly` | Auto-renewing subscription |
| Lifetime | `accountant_premium_lifetime` | One-time managed product |

These IDs are hard-coded in:
- Frontend: `lib/features/premium/constants/product_ids.dart`
- Backend: `VerifyPurchaseCommandHandler.ProductTierMapping`, `GooglePlayVerificationService.{Subscription,OneTime}ProductIds`

**Do not change them without updating both sides.**

## 1. Create the Monthly subscription

1. Play Console → your app → **Monetize → Products → Subscriptions → Create subscription**.
2. **Product ID:** `accountant_premium_monthly`
3. **Name:** `Premium Monthly`
4. **Description:** `Unlock AI insights, receipt OCR, unlimited wallets, cloud sync, and premium themes.`
5. **Benefits (bullets, optional but recommended):**
   - Unlimited wallets, categories, budgets, and objectives
   - AI-powered receipt scanning with OCR
   - Gemini AI chat assistant for financial advice
   - Cloud sync across devices
   - Advanced reports and data export
6. Click **Save**, then in the created product click **Add base plan**.

### Base plan: `monthly-autorenewing`

- **Base plan ID:** `monthly-autorenewing`
- **Billing period:** 1 month
- **Auto-renewing:** yes
- **Price:** $2.99 USD (use Price Setting, apply to all countries)
- **Grace period:** 3 days (matches backend `Subscription:GracePeriodDays`)
- **Account hold:** 30 days
- **Resubscribe:** enabled
- **Save** the base plan.

### Offer: `monthly-intro-7day-free` (optional but recommended)

- In the base plan → **Add offer**.
- **Offer ID:** `monthly-intro-7day-free`
- **Eligibility:** "Developer-determined" → choose "New customer acquisition"
- **Phase 1 (free trial):** 7 days
- **Save** and **Activate**.

## 2. Create the Yearly subscription

Repeat section 1 with:

- **Product ID:** `accountant_premium_yearly`
- **Name:** `Premium Yearly`
- **Description:** `Save 44% with annual billing. All Premium features included.`
- **Base plan ID:** `yearly-autorenewing`, billing period 1 year, price $19.99
- **Offer ID:** `yearly-intro-14day-free`, 14-day free trial
- In the subscription's general settings, **tag as "Best value"** — this renders a highlight badge in the Play purchase sheet.

## 3. Create the Lifetime one-time purchase

1. Play Console → **Monetize → Products → In-app products → Create product**.
2. **Product ID:** `accountant_premium_lifetime`
3. **Name:** `Premium Lifetime`
4. **Description:** `One-time purchase for lifetime Premium access. Never expires.`
5. **Price:** $49.99 USD
6. **Status:** Active.

## 4. Activate all products

Each product has its own Activate toggle — subscription base plans and offers must be activated separately. Verify all three products and both base plans/offers are **Active** (not "Draft").

## 5. License testers

Required so sandbox testers can make test purchases without being charged.

1. Play Console → **Setup → License testing**.
2. Add Gmail accounts that will install the app via the Internal Testing track.
3. Set **License response** to `RESPOND_NORMALLY`.
4. Save.

## 6. Upload app signing key SHA-1

Without this, Play Console will reject in-app purchase attempts with "authentication failed."

1. Play Console → **Setup → App integrity → App signing**.
2. Confirm Play App Signing is enabled (should be by default for new apps).
3. Copy the **SHA-1 certificate fingerprint** into Firebase Console (Settings → Your apps → SHA certificate fingerprints). This is required for Firebase Auth to work in release builds.

## 7. Test the full purchase flow

See `testing-guide.md` for the end-to-end procedure. Short version:

1. Upload a signed AAB to the Internal Testing track.
2. Invite a license tester to the Internal Testing list.
3. On a physical device signed into the tester's Google account, install from the internal-testing opt-in URL.
4. Open the app → paywall → tap Yearly → Google purchase sheet should appear.
5. Use the test payment method (no real charge for license testers).
6. Backend should log `Purchase verified successfully` and the user's `subscription_tier` should flip to `premium_yearly`.

## Troubleshooting

- **"Item unavailable" on purchase attempt** → product not active, or tester not on the internal-testing track, or app version on device is older than the one with the IAP code.
- **"Purchase authentication failed"** → app is not signed with the correct key, or SHA-1 not registered.
- **Products show but pricing missing** → wait up to 24h after creation for Google's pricing cache to propagate.
- **Backend rejects valid purchase** → check `GOOGLE_PLAY_SERVICE_ACCOUNT_KEY_PATH` env var and that the service account has "View financial data" + "Manage orders and subscriptions" permissions (see `rtdn-setup.md` Part C).

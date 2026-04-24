# The Accountant - Store & Subscription Setup Guide

Complete setup instructions for Google Play, App Store, and backend configuration for premium subscriptions.

---

## 1. Product Configuration

### Subscription Plans

Product IDs are unified across both platforms (Google Play limits product IDs to 40 characters, so we use short flat names rather than reverse-DNS).

| Product | Product ID (both platforms) | Price | Type |
|---------|-----------------------------|-------|------|
| Monthly | `accountant_premium_monthly` | $2.99/month | Auto-renewable subscription |
| Yearly | `accountant_premium_yearly` | $19.99/year | Auto-renewable subscription |
| Lifetime | `accountant_premium_lifetime` | $49.99 | One-time purchase |

### Package/Bundle IDs
- **Android Package Name:** `com.pranta.theaccountant`
- **iOS Bundle ID:** `com.pranta.theAccountant`

### Premium Features (Unlocked at any tier)
- Cloud Sync
- AI Assistant
- Receipt OCR
- AI Insights
- Smart Categorization
- Advanced Reports
- Data Export
- Premium Themes
- Unlimited Wallets, Categories, Budgets, Objectives, Payment Methods
- Priority Support

### Free Tier Limits
- Max 3 Wallets
- Max 10 Custom Categories
- Max 3 Active Budgets
- Max 2 Active Objectives
- Max 5 Payment Methods

---

## 2. Google Play Console Setup

### Step 1: Create Subscription Products

1. Go to **Google Play Console** > Your App > **Monetize** > **Subscriptions**
2. Click **Create subscription**

#### Monthly Subscription
- **Product ID:** `accountant_premium_monthly`
- **Name:** The Accountant Premium Monthly
- **Description:** Unlock all premium features with a monthly subscription
- Create a **Base Plan**:
  - Billing period: **1 month**
  - Price: **$2.99**
  - Renewal type: **Auto-renewing**

#### Yearly Subscription
- **Product ID:** `accountant_premium_yearly`
- **Name:** The Accountant Premium Yearly
- **Description:** Save 44% with an annual subscription to all premium features
- Create a **Base Plan**:
  - Billing period: **1 year**
  - Price: **$19.99**
  - Renewal type: **Auto-renewing**

### Step 2: Create One-Time Product (Lifetime)

1. Go to **Monetize** > **In-app products**
2. Click **Create product**
- **Product ID:** `accountant_premium_lifetime`
- **Name:** The Accountant Premium Lifetime
- **Description:** Unlock all premium features forever with a one-time purchase
- **Price:** $49.99

### Step 3: Configure Grace Period

1. Go to **Monetize** > **Monetization setup**
2. Under **Grace period**, set to **3 days**
3. Under **Account hold** (optional), set to **30 days**

---

## 3. Google Cloud Console - Service Account

### Step 1: Create Service Account

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Select the project linked to your Google Play Console
3. Go to **IAM & Admin** > **Service Accounts**
4. Click **Create Service Account**
   - Name: `theaccountant-play-verify`
   - Description: "Service account for verifying Play Store purchases"
5. Click **Create and Continue** (skip role assignment)
6. Click **Done**

### Step 2: Create JSON Key

1. Click on the created service account
2. Go to **Keys** tab
3. Click **Add Key** > **Create new key**
4. Select **JSON** format
5. Download and save as `google-play-service-account.json`
6. Place this file in the backend's API project directory

### Step 3: Grant Play Console Access

1. Go to **Google Play Console** > **Setup** > **API access**
2. Click **Link** to link your Google Cloud project (if not already linked)
3. Find the service account `theaccountant-play-verify`
4. Click **Grant access**
5. Under **App permissions**, add your app
6. Under **Account permissions**, enable:
   - **View financial data, orders, and cancellation survey responses**
   - **Manage orders and subscriptions**
7. Click **Invite user**

---

## 4. RTDN (Real-Time Developer Notifications)

RTDN sends real-time subscription events (renewals, cancellations, payment failures) to your backend via Google Cloud Pub/Sub.

### Step 1: Enable Cloud Pub/Sub API

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Navigate to **APIs & Services** > **Library**
3. Search for **Cloud Pub/Sub API**
4. Click **Enable**

### Step 2: Create Pub/Sub Topic

1. Go to **Pub/Sub** > **Topics**
2. Click **Create topic**
   - Topic ID: `theaccountant-play-rtdn`
   - Leave defaults
3. Click **Create**

### Step 3: Grant Google Play Publisher Access

1. Open the topic `theaccountant-play-rtdn`
2. Click **Show info panel** (or **Permissions** tab)
3. Click **Add principal**
   - New principal: `google-play-developer-notifications@system.gserviceaccount.com`
   - Role: **Pub/Sub Publisher**
4. Click **Save**

### Step 4: Generate Webhook Verification Token

Generate a secure random token (32+ hex characters):

```bash
openssl rand -hex 32
```

Save this token - you'll need it for both the Pub/Sub subscription and backend configuration.

### Step 5: Create Push Subscription

1. Go to **Pub/Sub** > **Subscriptions**
2. Click **Create subscription**
   - Subscription ID: `theaccountant-rtdn-push`
   - Select topic: `theaccountant-play-rtdn`
   - Delivery type: **Push**
   - Endpoint URL: `https://theaccountant.pranta.dev/api/v1/webhooks/google-play?token=YOUR_WEBHOOK_TOKEN`
   - Acknowledgement deadline: **20 seconds**
   - Message retention: **7 days**
3. Click **Create**

### Step 6: Configure RTDN in Play Console

1. Go to **Google Play Console** > **Monetize** > **Monetization setup**
2. Under **Real-time developer notifications**:
   - Topic name: `projects/YOUR_GCP_PROJECT_ID/topics/theaccountant-play-rtdn`
3. Click **Save changes**
4. Click **Send test notification** to verify the setup

### Step 7: Verify Setup

After sending the test notification, check your backend logs for:
```
Received Google Play webhook notification
Received test notification from Google Play
```

---

## 5. iOS App Store Connect Setup

### Step 1: Create Subscription Group

1. Go to [App Store Connect](https://appstoreconnect.apple.com) > Your App
2. Navigate to **Subscriptions** tab
3. Click **+** to create a subscription group
   - Group Name: **The Accountant Premium**

### Step 2: Create Subscription Products

Within the "The Accountant Premium" group, create:

#### Monthly
- **Reference Name:** Premium Monthly
- **Product ID:** `accountant_premium_monthly`
- **Duration:** 1 Month
- **Price:** $2.99 (Tier based on region)
- Add localization: Display Name, Description

#### Yearly
- **Reference Name:** Premium Yearly
- **Product ID:** `accountant_premium_yearly`
- **Duration:** 1 Year
- **Price:** $19.99
- Add localization

### Step 3: Create In-App Purchase (Lifetime)

1. Go to **In-App Purchases** tab
2. Click **+** > **Non-Consumable**
- **Reference Name:** Premium Lifetime
- **Product ID:** `accountant_premium_lifetime`
- **Price:** $49.99
- Add localization

### Step 4: Configure App Store Server Notifications V2

1. Go to **General** > **App Information**
2. Under **App Store Server Notifications**:
   - Production Server URL: `https://theaccountant.pranta.dev/api/v1/webhooks/apple`
   - Sandbox Server URL: `https://theaccountant.pranta.dev/api/v1/webhooks/apple`
   - Version: **Version 2**
3. Click **Save**

### Step 5: Create App Store Connect API Key

1. Go to **Users and Access** > **Integrations** > **App Store Connect API**
2. Click **Generate API Key**
   - Name: `theaccountant-subscription-api`
   - Access: **Admin**
3. Download the `.p8` private key file
4. Note down:
   - **Key ID** (shown in the key list)
   - **Issuer ID** (shown at the top of the page)
   - **Private Key** contents (from the .p8 file)

---

## 6. Backend Environment Variables

Add these to your backend `.env` file or deployment environment:

```env
# Google Play
GOOGLE_PLAY_SERVICE_ACCOUNT_KEY_PATH=google-play-service-account.json
GOOGLE_PLAY_PACKAGE_NAME=com.pranta.theaccountant
GOOGLE_PLAY_PUBSUB_VERIFICATION_TOKEN=<your-32-char-hex-token>

# Apple App Store
APPLE_KEY_ID=<your-app-store-connect-key-id>
APPLE_ISSUER_ID=<your-issuer-id>
APPLE_PRIVATE_KEY=<contents-of-p8-file-as-single-line>
APPLE_BUNDLE_ID=com.pranta.theAccountant
APPLE_ENVIRONMENT=Production

# Subscription
GRACE_PERIOD_DAYS=3
```

### Configuration in appsettings.json (alternative)

These can also be configured in `appsettings.json`:

```json
{
  "GooglePlay": {
    "ServiceAccountKeyPath": "google-play-service-account.json",
    "PackageName": "com.pranta.theaccountant",
    "WebhookToken": "<your-webhook-token>"
  },
  "Apple": {
    "KeyId": "<key-id>",
    "IssuerId": "<issuer-id>",
    "PrivateKey": "<p8-contents>",
    "BundleId": "com.pranta.theAccountant",
    "Environment": "Production"
  },
  "Subscription": {
    "GracePeriodDays": 3
  }
}
```

---

## 7. API Endpoints

### Subscription Management

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/api/v1/iap/subscription-status` | Yes | Get current subscription status |
| POST | `/api/v1/iap/verify` | Yes | Verify a purchase from client |
| POST | `/api/v1/iap/restore` | Yes | Restore previous purchases |
| GET | `/api/v1/iap/subscription-history` | Yes | Get subscription event history |
| POST | `/api/v1/iap/migrate-legacy` | Yes | Migrate legacy purchases to Lifetime |

### Webhook Endpoints

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/api/v1/webhooks/google-play?token=X` | Token | Google Play RTDN notifications |
| POST | `/api/v1/webhooks/apple` | None | App Store Server Notifications V2 |
| GET | `/api/v1/webhooks/health` | None | Health check |

### Subscription Status Response

Backend serializes responses as snake_case (`Program.cs:119`):

```json
{
  "tier": "premium_monthly",
  "expires_at": "2026-04-26T00:00:00Z",
  "is_premium": true,
  "product_id": "accountant_premium_monthly",
  "platform": "android",
  "grace_period_ends_at": null,
  "is_in_grace_period": false,
  "days_until_grace_period_ends": 0
}
```

---

## 8. Testing Guide

### Google Play Testing

#### License Testing (Free purchases)

1. Go to **Google Play Console** > **Setup** > **License testing**
2. Add test email addresses
3. Set license test response to **RESPOND_NORMALLY**

#### Internal Testing Track

1. Go to **Testing** > **Internal testing**
2. Create a new release
3. Upload your signed APK/AAB
4. Add testers by email
5. Share the opt-in link with testers

#### Test Purchases

- Test users on the license testing list get free purchases
- Subscriptions auto-renew on an accelerated schedule (5 min for monthly)
- Use `adb logcat | grep -i billing` to debug

### iOS Testing

#### Sandbox Testing

1. Go to **App Store Connect** > **Users and Access** > **Sandbox** > **Testers**
2. Create sandbox tester accounts
3. On device: **Settings** > **App Store** > **Sandbox Account** > Sign in
4. Subscriptions auto-renew on accelerated schedule

### Testing Webhook Flow

1. Make a test purchase
2. Check backend logs for `/api/v1/iap/verify` call
3. Verify user subscription was updated in the database
4. Wait for RTDN webhook (or use Play Console "Send test notification")
5. Check backend logs for webhook processing

---

## 9. Troubleshooting

### Products Not Found
- Ensure products are in **Active** state in Play Console / App Store Connect
- Verify product IDs match exactly (case-sensitive)
- App must be uploaded to at least internal testing track
- Wait up to 24 hours for products to propagate

### Webhook Not Receiving Notifications
- Verify the Pub/Sub push subscription endpoint is correct
- Check that the webhook token matches between Pub/Sub URL and backend config
- Ensure the backend is accessible at the configured HTTPS URL
- Check Pub/Sub subscription for undelivered messages
- Verify `google-play-developer-notifications@system.gserviceaccount.com` has Publisher role

### Purchase Verification Failing
- Check that `google-play-service-account.json` exists and is readable
- Verify the service account has proper Play Console permissions
- Check backend logs for specific API error codes
- Ensure the package name matches in all configurations

### Grace Period Not Working
- Verify `Subscription:GracePeriodDays` is set in backend config
- Check that the `grace_period_ends_at` column exists in the database
- Run the database migration: `dotnet ef database update`
- Verify the `SubscriptionExpiryJob` is running (check Hangfire dashboard)

### iOS Webhook Issues
- Ensure App Store Server Notifications is set to **Version 2**
- Verify both Production and Sandbox URLs are configured
- Check that the Apple API key has Admin access
- The `APPLE_PRIVATE_KEY` should be the p8 file contents on a single line (replace newlines with `\n`)

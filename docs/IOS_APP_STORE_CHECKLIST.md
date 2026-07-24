# iOS App Store Submission Checklist — The Accountant

This is the end-to-end checklist to get **The Accountant** onto the App Store
(the app already ships on Google Play). It is split into:

1. ✅ **Code / config already applied** in this repo
2. 🔧 **Manual steps** you must do in Xcode, Apple Developer, Firebase, and
   App Store Connect (these cannot be done from code)

**Canonical iOS Bundle ID:** `com.pranta.theaccountant` (all lowercase — this
matches the Xcode project, `GoogleService-Info.plist`, and `firebase_options.dart`).
Use this exact string everywhere: App Store Connect, Apple Developer App ID, and
the backend's `Apple:BundleId`. Do **not** use `com.pranta.theAccountant`.

---

## 1. ✅ Already applied in this repo

| Change | File |
|--------|------|
| Camera / photo-library / add-to-library purpose strings | `ios/Runner/Info.plist` |
| `ITSAppUsesNonExemptEncryption = false` (skips export-compliance prompt) | `ios/Runner/Info.plist` |
| Google Sign-In URL scheme (`CFBundleURLTypes` = reversed client ID) | `ios/Runner/Info.plist` |
| Deployment target bumped 13.0 → 15.5 (required by ML Kit pods) | `project.pbxproj`, `AppFrameworkInfo.plist` |
| `Podfile` created with `platform :ios, '15.5'` + post-install pin | `ios/Podfile` |
| `Runner.entitlements` with `aps-environment` + `com.apple.developer.applesignin` | `ios/Runner/Runner.entitlements` |
| `CODE_SIGN_ENTITLEMENTS` wired into all 3 Runner build configs | `project.pbxproj` |
| Sign in with Apple service | `lib/core/services/apple_sign_in_service.dart` |
| `signInWithApple()` auth flow | `lib/features/authentication/providers/auth_provider.dart` |
| "Continue with Apple" button (iOS/macOS only) | `.../screens/sign_in_screen.dart` |
| `sign_in_with_apple` dependency | `pubspec.yaml` |
| Bundle-ID casing fixed to lowercase in docs + backend | `STORE_SETUP.md`, backend `appsettings.json`, `AppleWebhookService.cs` |

> Note: `aps-environment` is set to `development` in the entitlements file. Xcode
> automatically swaps this to `production` when you Archive for App Store
> distribution using a distribution provisioning profile — no change needed.

---

## 2. 🔧 Apple Developer Portal (developer.apple.com → Certificates, IDs & Profiles)

- [ ] **App ID** exists for `com.pranta.theaccountant` (create under *Identifiers*).
- [ ] Enable these **capabilities** on the App ID:
  - [ ] **Push Notifications**
  - [ ] **Sign in with Apple** (set as **primary** App ID)
- [ ] **Create an APNs Auth Key** (*Keys* → **+** → enable *Apple Push
      Notifications service (APNs)*). Download the `.p8`, note the **Key ID** and
      your **Team ID**. (Used by Firebase, section 4.)
- [ ] Membership in the **Apple Developer Program** ($99/yr) is active.

## 3. 🔧 Xcode (open `ios/Runner.xcworkspace`, NOT the .xcodeproj)

- [ ] Select the **Runner** target → **Signing & Capabilities**.
  - [ ] Set your **Team** (this fills `DEVELOPMENT_TEAM`, currently blank).
  - [ ] Keep **Automatically manage signing** on.
  - [ ] Confirm **Push Notifications** capability is listed (from entitlements).
  - [ ] Confirm **Sign in with Apple** capability is listed (from entitlements).
  - [ ] Confirm **Bundle Identifier** shows `com.pranta.theaccountant`.
- [ ] Verify the app icon set is complete (1024×1024 marketing icon is present).
- [ ] From the terminal, install pods:
  ```bash
  cd ios && pod install --repo-update
  ```

## 4. 🔧 Firebase Console (project: `the-accountant-8dadf`)

- [ ] **Authentication → Sign-in method → Apple**: enable the provider.
  - For iOS-only usage you just enable it; for web/Android you'd also set a
    Services ID + key, but this app gates Apple sign-in to iOS/macOS.
- [ ] **Project Settings → Cloud Messaging → Apple app configuration**: upload
      the **APNs Auth Key** (`.p8` from section 2) with its **Key ID** and
      **Team ID**. Without this, `firebase_messaging` push will not deliver on iOS.
- [ ] Confirm an **iOS app** entry exists with bundle ID `com.pranta.theaccountant`
      and that `ios/Runner/GoogleService-Info.plist` matches it (it does today).

## 5. 🔧 App Store Connect (appstoreconnect.apple.com)

- [ ] **Create the app record**: My Apps → **+** → New App.
  - Platform: iOS · Bundle ID: `com.pranta.theaccountant` · SKU: your choice.
- [ ] **In-App Purchases / Subscriptions** — create these (IDs must match the app
      and Google Play exactly; see `STORE_SETUP.md` §5):
  - [ ] Subscription group **The Accountant Premium**
  - [ ] `accountant_premium_monthly` — auto-renewable, 1 month, $2.99
  - [ ] `accountant_premium_yearly` — auto-renewable, 1 year, $19.99
  - [ ] `accountant_premium_lifetime` — non-consumable, $49.99
  - [ ] Add a localized display name + description + review screenshot to each.
- [ ] **App Store Server Notifications V2** → set Production + Sandbox URL to
      `https://theaccountant.pranta.dev/api/v1/webhooks/apple` (see `STORE_SETUP.md` §5.4).
- [ ] **App Store Connect API key** (Admin) for subscription server API — see
      `STORE_SETUP.md` §5.5; feed Key ID / Issuer ID / `.p8` into the backend.
- [ ] **App Privacy** ("nutrition label") — REQUIRED. Declare data collected:
  - Financial info (transactions), Contact info (email), Identifiers (user ID),
    Usage/Diagnostics (Firebase Analytics + Crashlytics). Map each to purpose and
    whether it's linked to the user.
- [ ] **Export compliance**: because `ITSAppUsesNonExemptEncryption = false` is in
      Info.plist, you won't be prompted per-build. (App uses only standard HTTPS.)
- [ ] **Sign in with Apple present** — the login screen now offers it alongside
      Google, satisfying **Guideline 4.8**.
- [ ] **Restore Purchases** — ensure the paywall exposes a visible "Restore
      Purchases" action (required for subscriptions/non-consumables).

## 6. 🔧 Backend configuration (see `STORE_SETUP.md` §6)

- [ ] Set Apple env vars / `appsettings` — all already use lowercase bundle ID now:
  - `Apple:BundleId = com.pranta.theaccountant`
  - `Apple:KeyId`, `Apple:IssuerId`, `Apple:PrivateKey` (from §5 API key)
  - `Apple:Environment = Production`
- [ ] Verify the Apple webhook endpoint is reachable and returns 200 on the
      health check.

## 7. 🔧 Build, test, and upload

- [ ] Provide the real `.env` (not committed) — `GEMINI_API_KEY`,
      `GOOGLE_WEB_CLIENT_ID`, `API_BASE_URL_PROD`.
- [ ] Bump the build number for each upload (currently `version: 1.2.0+17` in
      `pubspec.yaml`; App Store requires a unique build number per upload).
- [ ] Build a release archive:
  ```bash
  flutter build ipa --release
  ```
  Then open `build/ios/archive/Runner.xcarchive` in Xcode Organizer, or upload
  via `xcrun altool` / Transporter.
- [ ] **TestFlight**: install on a real device and verify:
  - [ ] Google Sign-In returns to the app (URL scheme).
  - [ ] Sign in with Apple completes and reaches the backend.
  - [ ] Camera + photo library work in the receipt scanner (no crash).
  - [ ] Push notification received (send a test from Firebase).
  - [ ] A sandbox IAP purchase + **Restore Purchases** both succeed.
- [ ] **Screenshots** for App Store listing (required sizes). This app ships
      **Universal (iPhone + iPad)**, so BOTH are mandatory:
  - [ ] 6.9" / 6.7" iPhone (e.g. iPhone 16 Pro Max)
  - [ ] 13" iPad (e.g. iPad Pro 13") — capture in the iPad simulator
  - [ ] Verify each iPad screenshot shows the centered, constrained layout (see
        "iPad support" below) — not stretched content.

## 8. 📱 iPad support (Universal app)

The app is submitted as **Universal** (device family `1,2`, all iPad icons and
orientations present). To avoid the "stretched phone app" look Apple flags on
iPad, a responsive layer was added:

- `lib/core/utils/responsive.dart` — `isTablet(context)` + `Breakpoints`
  (`tablet = 600`, `contentMaxWidth = 640`) and an `AdaptiveWidth` widget.
- `lib/app/app.dart` — the `MaterialApp.builder` now wraps every screen in
  `AdaptiveWidth`, so on iPad/desktop all content (screens, bottom sheets,
  dialogs) is **centered within a 640pt column** while the ambient gradient
  background stays full-bleed. On iPhone it's a no-op (screen is narrower).
- Fixed two raw-`MediaQuery.width` sizing bugs that would overflow/stretch on
  iPad: the dashboard budget bar (`responsive_financial_overview.dart`, now a
  `FractionallySizedBox`) and AI chat bubbles (`ai_assistant_screen.dart`,
  capped at 460 on tablet).

**Verify on the iPad simulator before submitting:**
- [ ] Dashboard, auth, settings, and add/edit forms are centered (not stretched).
- [ ] Rotate to landscape — layout still reads well (all orientations enabled).
- [ ] Bottom sheets / dialogs are centered and comfortably sized.
- [ ] Split View / Slide Over multitasking behaves (or set `UIRequiresFullScreen`
      in `Info.plist` if you prefer to opt out of multitasking).

> Tunable: raise `Breakpoints.contentMaxWidth` in `responsive.dart` if you want a
> wider content column on large iPads. The grid pickers (icon/color/category)
> use fixed `crossAxisCount`; they look fine inside the 640 column but could be
> switched to `SliverGridDelegateWithMaxCrossAxisExtent` later for extra polish.

### Notes
- The **macOS** target still uses `com.pranta.theAccountant.RunnerTests` in
  `macos/Runner.xcodeproj/project.pbxproj`. That's the desktop test target and is
  irrelevant to the iOS App Store — left untouched. Reconcile it only if/when you
  ship the macOS build.

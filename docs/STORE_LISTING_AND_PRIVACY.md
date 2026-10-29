# Store listing & privacy labels — how to keep them up to date

Instructions for a future Claude Code session (usually on the Mac, where the
iOS release is built). Read this before touching Google Play Console or
App Store Connect.

Last full update: **29 Oct 2026** (Android 4.4.0 build 35, iOS live version 4.2.0).

---

## 1. Source of truth

The store text lives in `docs/store_listing/<locale>.json`. Each file has three keys:

| Key | Google Play field | Limit | App Store field |
|---|---|---|---|
| `title` | App name | 30 | Name (30) |
| `short` | Short description | 80 | Subtitle is only **30**, so write a separate one |
| `full` | Full description | 4000 | Description (4000) |

Locales: `en`, `bn-BD`, `hi-IN`, `de-DE`, `fr-FR`, `pt-PT`, `ms`, `fa`, `sw`, `am`.
These are the same languages the app ships in (`lib/l10n/app_*.arb`).

**Rule:** edit the JSON first, then copy it into the consoles. Never edit only
the console, or the next session overwrites your change from a stale file.
Check limits with Python `len()`, not by eye.

## 2. Every claim must be true in the code

The old listing said "neon/glassmorphic design", "no tracking", "40+
currencies", and "unlimited wallets with Premium". All four were false. Before
changing the text, check each claim against the code:

- **Currencies:** count the ISO list in `lib/core/services/currency_service.dart`. About 161 today, so the text says "160+".
- **Free vs Premium:** `lib/data/models/premium_features.dart`.
  - The free tier has **no caps** on wallets, categories, budgets, goals or payment methods.
  - Google Drive backup and CSV import/export are **free**.
  - Premium adds cloud sync, more AI, PDF reports and 5 themes.
- **Themes:** `lib/core/themes/sunrise/sunrise_accent.dart`. There are 6 accents: Sunrise is free, the other 5 are premium.
- **Prices:** `lib/features/premium/constants/product_ids.dart`. Yearly "save about 44%" is $19.99 vs 12 × $2.99.
- **AI quota:** `lib/features/ai_assistant/models/ai_quota.dart`. 10 free a month, plus rewarded-ad credits.
- **Design:** the "Sunrise" system has warm gradients, soft cards, and light and dark mode. Never write "neon" or "glassmorphic".
- **Don't claim** "no tracking", "encrypted backups", "priority support" or home-screen widgets. None of these exist.
- **Never** mention Cashew anywhere.

## 3. Google Play Console

App: *The Accountant: Money Manager*. Developer id `7767660740826235740`, app id `4974858725143724828`.

**Store listing:** Grow users → Store presence → Main store listing.
1. Use the language chip at the top, or **Next language**, to switch locale.
2. Paste the title, short and full text for each locale.
3. Click **Save as draft**.

When scripting the fields, set the values with the native value setter, fire
`input` and `change` events, and check that the language chip shows the
intended locale before writing.

**Data safety:** Policy → App content → Data safety. Current declarations:

| Data type | Collected | Shared | Purpose | Source |
|---|---|---|---|---|
| Name, email, user IDs | yes | – | app functionality, account | Google/Apple sign-in, backend |
| Purchase history, other financial info | yes | – | app functionality | IAP, cloud sync of transactions |
| Approximate location | yes | yes | analytics, advertising | AdMob (IP-derived) |
| App interactions | yes | yes | analytics, advertising | Firebase Analytics, AdMob |
| Other user-generated content | yes (optional) | – | app functionality | AI assistant chat sent to backend |
| Crash logs, diagnostics, other performance | yes | – | (as already declared) | Crashlytics |
| Device or other IDs | yes | yes | app functionality, analytics, advertising | FCM token, Analytics id, ad id |

Not declared, on purpose:
- **Photos:** receipt OCR runs on-device with ML Kit (`lib/features/ai/services/ocr_service.dart`).
- **Audio:** voice entry uses the platform speech recognizer.

Clicking **Save** puts the change into *Publishing overview*. The user sends
everything for review themselves. **Never press "Send for review".**

**Releases:** Production track. Bump `version:` in `pubspec.yaml` (minor bump
plus build number), then run `flutter build appbundle --release`. The AAB is
about 140 MB, too big for the browser upload tool, so the user uploads it.

## 4. App Store Connect (iOS)

App id `6794265000`, bundle `com.pranta.theaccountant`.
See also `docs/IOS_APP_STORE_CHECKLIST.md`.

**App Privacy:** Distribution → App Privacy. Changes go live immediately when
you click *Publish* on each data type; no app version is needed. As of
29 Oct 2026 it declares:

- **Linked to the user:**
  - name and email (app functionality)
  - other financial info and purchases (app functionality)
  - user ID (app functionality, analytics, third-party advertising)
  - other user content: the AI chat (app functionality)
- **Not linked to the user:**
  - device ID (app functionality, analytics, third-party advertising)
  - coarse location (app functionality, third-party advertising)
  - product interaction (app functionality, third-party advertising, analytics)
  - advertising data (third-party advertising, analytics)
  - crash data (app functionality)
  - performance data and other diagnostic data (analytics, app functionality)
- **Tracking:** "No" for every type. The app has no App Tracking Transparency prompt (no `NSUserTrackingUsageDescription`), so the advertising ID (IDFA) isn't used.
  - If ATT is ever added, Device ID (and probably Advertising Data) must switch to "used for tracking".

### ⚠️ Still to do on iOS: the description

The live iOS version (4.2.0) still has the **old** description. Apple only lets
you edit the description, keywords and screenshots on a **new version**. So
when the next iOS version is created (the **+** next to "iOS App"):

1. Paste `docs/store_listing/en.json` → `full` into *Description*.
2. **Subtitle:** max 30 characters. Write one, e.g. "Budgets, loans & AI insights" (28). Don't reuse `short`; it's too long.
3. **Promotional text:** max 170 characters, editable any time, even without a new version. Use a one-line pitch.
4. **Keywords:** max 100 characters, comma-separated, no spaces. Don't repeat words already in the name.
5. **Localizations:** add each language Apple supports.
   - Hindi, German, French, Portuguese (Portugal) and Malay are available.
   - Check whether Bangla, Persian, Swahili and Amharic are offered (they weren't, last we knew), and skip any that aren't.
   - Paste the matching JSON (`title` → Name, `full` → Description).
6. **Screenshots:** check they show the current Sunrise design.
   - Google Play's screenshots (orange, Sunrise) are current.
   - Compare the iOS screenshots against them.
7. Leave the actual "Submit for Review" to the user.

## 5. When to redo this

Update the listing **and** both privacy forms whenever:
- a new SDK that sends data off the device is added (check `pubspec.yaml`: analytics, ads, crash, attribution and so on);
- a feature starts sending something new to the backend;
- free/premium limits, prices, the theme count or the language list change;
- a headline feature ships, so add it to the description.

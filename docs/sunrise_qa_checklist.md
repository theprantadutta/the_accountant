# Sunrise redesign: QA checklist

Device: Samsung Galaxy A24 (Android 14), debug build against the local API,
test account `testpremium@theaccountant.app`. "Light" means checked on the
device in Sunrise Light; "Dark" is the dark-mode pass.

Legend: ✅ checked and fine · 🔧 fixed during QA, then re-checked · ⏳ not yet checked

## Launch

| Item | Light | Dark | Notes |
|---|---|---|---|
| Launcher icon (adaptive + monochrome) | ✅ | ✅ | One icon for both modes |
| Native splash (Android 12+ and legacy) | ✅ | ✅ | Same orange ground in both modes |
| Splash → intro hand-off | 🔧 | ⏳ | First intro frame is pixel-matched to the native splash |
| Intro (sunburst, orbiting icons, coins, status steps, money tip) | 🔧 | n/a | Fixed ground in both modes; orbit no longer clips the wordmark |
| Notification icon (status bar, FCM default) | ✅ | ✅ | `ic_stat_notify` |

## Tabs

| Screen | Light | Dark | Notes |
|---|---|---|---|
| Today | 🔧 | ⏳ | Status bar now matches the other tabs (content stops under it) |
| Wallets | 🔧 | ⏳ | Amounts right-aligned |
| Add transaction + amount keypad | 🔧 | ⏳ | |
| Stats | ✅ | ⏳ | |
| More | ✅ | ⏳ | |

## Pushed screens

| Screen | Light | Dark | Notes |
|---|---|---|---|
| Transaction detail | 🔧 | ⏳ | Rebuilt: gradient hero, grouped details, action sheet |
| Wallet detail | 🔧 | ⏳ | Rebuilt: hero in the wallet's colour, stat cards, category rows |
| Add wallet sheet | 🔧 | ⏳ | |
| Appearance | 🔧 | ⏳ | Accent cards are mini app previews |
| Regional settings / exchange rates | ✅ | ⏳ | |
| Notification settings | 🔧 | ⏳ | Info banner on the accent tint |
| Home layout | ✅ | ⏳ | |
| Categories | 🔧 | ⏳ | Overflow fixed |
| AI assistant | ✅ | ⏳ | |
| Goals list / goal detail / new goal | ✅ | ⏳ | |
| Budgets list / budget detail / new budget | 🔧 | ⏳ | Pace bar track visible at zero spend; segmented buttons restyled |
| Upcoming & overdue | ✅ | ⏳ | |
| Payment methods | 🔧 | ⏳ | Grouped card |
| Naming rules | 🔧 | ⏳ | Grouped card |
| Cloud sync | 🔧 | ⏳ | |
| Backup & restore | 🔧 | ⏳ | |
| Export data | 🔧 | ⏳ | |
| Import a statement | 🔧 | ⏳ | Sunrise button, accent banner |
| Recently deleted | ✅ | ⏳ | |
| Contact support | 🔧 | ⏳ | Premium note readable |
| About | ✅ | ⏳ | |
| Privacy & security / Help | ✅ | ⏳ | |
| Edit profile | 🔧 | ⏳ | Premium badge readable; back button labelled |
| Notification inbox | ✅ | ⏳ | |
| Premium / paywall (3 tiers) | ✅ | ⏳ | |

## Signed-out flows

Not walked on the device yet: doing so means signing out of the test account.

| Screen | Light | Dark |
|---|---|---|
| Sign in | ✅ | ⏳ |
| Sign up | ⏳ | ⏳ |
| Forgot password | ⏳ | ⏳ |
| Onboarding / post-signup onboarding / first wallet | ⏳ | ⏳ |
| Lock screen | ⏳ | ⏳ |

## Automated

- `flutter analyze`: clean.
- `flutter test`: 956 passed.
- `flutter build apk --release`: builds (161 MB universal APK; the size is the
  three ABIs plus ML Kit OCR, not the redesign. The Play bundle splits it).

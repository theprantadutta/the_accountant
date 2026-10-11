# Sunrise migration plan

The source of truth is `design_handoff_sunrise_redesign/` at the repo root. It is gitignored: only the assets the app ships with are copied into `assets/`. This document records how the existing app maps onto that design.

**Ground rule: this is a visual redesign.** Every route, provider, DB call, premium gate, purchase flow, l10n string and analytics event keeps working.

---

## 1. Where the code is today

| Concern | Today | Consequence |
|---|---|---|
| Colours | `AppColors.*`: static getters over a mutable global `AppPalette`, with about 2,200 call sites. Only 7 reads of `Theme.of`. | A token swap must go through the palette, or most of the app ignores it. |
| Premium themes | `premium_themes.dart` builds five standalone `ThemeData`s (seeded, Roboto). | **Broken:** widgets read `AppColors`, which stays on the dark palette, so a premium theme only recolours the few widgets that read `ThemeData`. They also force dark mode. |
| Fonts | `google_fonts`: Inter, plus JetBrains Mono for figures. | Fetched at runtime. Replace with bundled Lexend. |
| Background | `AppBackground`: indigo orbs, painted once in `MaterialApp.builder`, behind transparent scaffolds. | Replaced by `SunriseBackground`, painted per screen (tall wash on tab roots, short wash on pushed screens). |
| Shell | `MainNavigationContainer`: IndexedStack of Home / Activity / AI / Insights / Settings, a custom bar, `NeoFAB` on two tabs, a NavigationRail on tablets. | New tab set: see §3. |
| Routing | Plain `Navigator`, about 63 `MaterialPageRoute` pushes and a few named routes. | Unchanged. Only the destinations of the shell tabs move. |
| Logo | A Material icon in a gradient box in the app. Old purple launcher webps. No splash config. | Replaced everywhere: see §6. |

## 2. Screen inventory

Legend: **M** = mocked (match the screenshot), **R** = restyle with the system.

### Shell and tab roots
| Screen | File | Mock |
|---|---|---|
| Shell / tab bar | `shared/widgets/main_navigation_container.dart`, `custom_bottom_nav_bar.dart` | M (bar in every root shot) |
| Today (was Home) | `features/dashboard/widgets/responsive_financial_overview.dart` | M 01 |
| Wallets (was reached via Home) | `features/wallets/screens/wallet_management_screen.dart` | M 05 |
| Stats (was Insights) | `features/reports/screens/reports_screen.dart` | M 04 |
| More (was Settings) | `features/settings/screens/settings_screen.dart` | M 06 |

### Pushed screens
| Screen | File | Mock |
|---|---|---|
| Activity | `transactions/screens/transaction_list_screen.dart` | M 02 |
| Add / edit transaction (expense, income, transfer) | `transactions/screens/add_transaction_screen.dart` | M 03 |
| AI Assistant (locked and unlocked) | `ai_assistant/screens/ai_assistant_screen.dart`, `premium/widgets/premium_gate.dart` | M 07 |
| Premium | `premium/screens/premium_screen.dart` | M 08 |
| Appearance | `settings/screens/theme_selection_screen.dart` | M 09 |
| Privacy & security | `settings/screens/privacy_security_screen.dart` | M 10 |
| Help & FAQ | `settings/screens/help_screen.dart` | M 11 |
| Transaction detail | `transactions/screens/transaction_detail_screen.dart` | R |
| Income-only / expense-only list | `transactions/screens/transaction_type_screen.dart` | R (Activity look) |
| Upcoming | `transactions/screens/upcoming_transactions_screen.dart` | R |
| Payment methods, title rules, recently deleted | `transactions/screens/*` | R |
| Wallet detail, create first wallet | `wallets/screens/*` | R |
| Budgets list / detail / add | `budgets/screens/*` | R |
| Goals list / detail / add | `objectives/screens/*` | R |
| Lend & borrow | `credit_debt/screens/credit_debt_screen.dart` | R |
| Subscriptions | `subscriptions/screens/subscription_dashboard_screen.dart` | R |
| Categories | `categories/screens/category_management_screen.dart` | R |
| Notification inbox | `notifications/screens/notification_inbox_screen.dart` | R |
| Receipt scanner, monthly summary | `ai/screens/*` | R |
| Home layout | `dashboard/screens/home_layout_screen.dart` | R |
| Profile edit, regional, exchange rates, notifications, sync, export, backup, import, about, contact support | `settings/…`, `backup/…`, `import/…` | R |
| Legal acceptance, legal viewer | `legal/…` | R |
| Onboarding, post-signup onboarding | `onboarding/…` | R |
| Sign in / up / forgot password / account linking / user profile | `authentication/presentation/screens/*` | R |
| Startup recovery, lock screen, auth loading (in-app splash) | `startup/…`, `settings/screens/lock_screen.dart`, `auth_wrapper.dart` | R / splash |

### Dialogs → `SunriseDialog`, or `SunriseBottomSheet` where the spec says so
- **Shared helpers:** `confirmation_dialog.dart` (confirm and loading), `destructive_confirmation_dialog.dart` (destructive confirm becomes a **bottom sheet** per the spec), `change_password_dialog.dart`, `upgrade_limit_dialog.dart`.
- **Inline dialogs:**
  - ai_assistant: rename and delete conversation
  - user_profile: sign out
  - backup: frequency and keep-count
  - budget_detail: category cap
  - category_management: delete
  - credit_debt: record payment
  - import: outcome and template
  - about: developer
  - exchange_rates: edit rate
  - export: PDF upgrade
  - notifications: threshold and offset
  - category_reconciliation_card
  - startup_recovery: offline warning
  - subscription_dashboard: cancel
  - add_transaction: scan upgrade and delete
  - payment_methods: edit
  - title_rules: edit
  - transaction_list: move-to-account and mixed currency
  - wallet_detail: correct balance and merge
  - wallet_management: delete
  - transaction_card: delete

### Bottom sheets → `SunriseBottomSheet` (top radius 32, base colour, 40×5 grab handle)
- **Shared:** `blurred_bottom_sheet.dart`, `permission_priming_sheet.dart`, color / currency / icon pickers, transaction_card options.
- **Transactions:** calculator, category picker, filter.
- **Others:** edit subscription, notification primer.
- **Inline sheets:**
  - AI conversations
  - profile photo
  - budget actions
  - add and edit category
  - dashboard edit-wallet
  - notification detail
  - goal actions
  - auto-lock picker
  - regional pickers
  - transaction-type filter
  - wallet add / edit / options
  - add-wallet icon and colour pickers

### Snackbars, loading and empty states
- **Snackbars:** one helper set (`showSunriseSnack(context, message, tone: success | error | info)`) plus a `SnackBarThemeData` in the theme. The 33 direct `showSnackBar` callers pick up the theme automatically. Callers that set their own colours are cleaned up as their screens are restyled.
- **Loading:** shimmer skeletons are re-tinted to warm tokens. Raw `CircularProgressIndicator`s pick up the accent colour from the theme.
- **Empty states:** one shared `EmptyState` widget replaces the private `_Empty*` builders.

## 3. New navigation

| Tab | Root | Notes |
|---|---|---|
| **Today** | Restyled `ResponsiveFinancialOverview` | Bell → notification inbox (keeps its badge). "All activity" → Activity. |
| **Wallets** | Restyled `WalletManagementScreen` as a tab root (still pushable from elsewhere) | Default wallet as a gradient card, other wallets as rows, dashed add row, **Planning** group. |
| **Add** | Not a page: opens `showAddTransactionScreen` (slide-up modal) | Replaces `NeoFAB`. |
| **Stats** | Restyled `ReportsScreen` | Week / Month / Year. Month and Year are locked for free users, as today. |
| **More** | Restyled `SettingsScreen` | Every existing entry is kept, regrouped under the mock's section headers. |

**Where the old tabs and entry points go:**
- **Activity:** pushed from Today ("All activity" and the stat cards) and from deep links. `AppDestination` tab targets are remapped: activity is pushed rather than switched to.
- **AI Assistant:** no longer a tab. Reached from:
  - an "Ask your money coach" card on Today
  - an insights card on Stats (which already holds the "spending insights" entry)
  - a row in More
  - the AI deep link
  The gate and paywall are unchanged.
- **Wallets → Planning:** Upcoming, Lend & borrow, Goals and Transfer between wallets (from the mock), plus **Budgets** and **Subscriptions**. Those two lived in Home's quick links and in Settings › Money; Planning is their natural home. They also stay in More, so nothing loses a path.
- **Home layout (section reorder/hide):** kept. The four mocked Today blocks (greeting, net worth, stat cards, today list) map onto the existing `HomeSection`s greeting / accounts / quickStats / recentTransactions. The remaining sections (spending chart, budgets, goals, quick links) render below them in Sunrise style, in the user's saved order.
- **Walkthrough (`tutorial_coach_mark`):** its target keys move to the new tab bar items. Steps that pointed at the removed AI tab point at the Today AI card instead.
- **Launcher shortcuts:** unchanged behaviour. The Android shortcut icons, which don't currently exist in `res/`, are added as part of the icon work.
- **Tablet:** a Sunrise-styled `NavigationRail` with the same five destinations, Add as a gradient button, and content capped at about 600 wide and centred.

## 4. Foundation

- `lib/core/themes/sunrise/`:
  - `sunrise_colors.dart`: a `ThemeExtension` with a real per-field `Color.lerp`, plus light and dark instances
  - `sunrise_accents.dart`: the accent sets
  - `sunrise_tokens.dart`: radius, spacing, shadows, gradients and type scale
  - `sunrise_theme.dart`: builds the Material 3 `ThemeData` and `ColorScheme`
- **Font:** `assets/fonts/Lexend-VariableFont_wght.ttf`, registered as family `Lexend`. If variable weights misbehave on a target, fall back to static 300–600. `google_fonts` is removed once nothing imports it. Figures use `FontFeature.tabularFigures()` where amounts line up.
- **Icons:** `material_symbols_icons` (`Symbols.*`, rounded). Outline by default; `fill: 1` for the active tab and for emphasis.
- **Legacy bridge:** `AppPalette.light/dark` are re-derived **from the Sunrise tokens** (and the active accent), with the same field names. The 2,200 `AppColors.*` call sites therefore repaint in Sunrise on day one and follow both premium themes and light/dark. `AppColors.primaryGradient` and its siblings become getters on the active accent's gradient. As screens are rebuilt they move to `context.sunrise` (the extension). The bridge lets the work be incremental without ever showing a half-old look.
- `AppBackground` (indigo orbs) is retired. Each screen paints `SunriseBackground(tall: tabRoot)`.
- **Shared widgets** in `lib/shared/widgets/sunrise/`:
  - `SunriseBackground`, `SunriseGlass`, `SunriseTabBar`, `LargeTitleHeader`, `PushHeader`
  - `SunriseCard`, `GradientCard`, `StatCard` (the old one is replaced)
  - `TransactionTile`, `DayGroupCard`
  - `SettingsGroup`, `SettingsRow` (chevron, value, toggle and destructive variants)
  - `SunriseChip`, `SunriseSegmented` (with an on-gradient variant), `SunriseToggle`, `SunriseSearchField`
  - `CategoryTile`, `SunriseButton` (primary, secondary, destructive), `SunriseIconButton`
  - `SunriseBottomSheet`, `SunriseDialog`, `EmptyState`, `Pressable` (0.97 scale over 120ms)
  - Existing `GlassCard`, `NeoButton`, `NeoTextField` and `settings_tile.dart` are reimplemented on top of these. Their call sites look right before each screen is touched, and those primitives are deleted once unused.

## 5. Premium themes

**The fix:** a theme is now **mode × accent**.
- **Mode:** System / Light / Dark, from the "Match system" toggle plus the light and dark cards.
- **Accent:** Sunrise (the free default) or Sapphire, Emerald, Ruby, Amethyst or Graphite (premium).

**What an accent swaps:** only `gradient` (sunrise / short / header / orb / bar highlight), `accent`, `accentText`, the wash stops (`washTop`, `washMid`, `washShortTop`), `barIdle`, `tintOrange`/`tintPeach` and the selected-category shadow tint. Neutrals, ink, surfaces, positive and negative never change, so contrast is preserved. Each accent defines light and dark values; dark values are lighter tints, the same way Sunrise uses `#FB923C` and `#FDBA74`.

**Because both `SunriseColors` and the legacy `AppPalette` are derived from mode × accent, a premium theme recolours the whole app**, which is what was broken.

| Accent | Gradient (light) | Accent / accent text (light) | Accent / accent text (dark) |
|---|---|---|---|
| Sunrise | `#F59E0B → #F97316 → #F43F5E` | `#EA580C` / `#C2410C` | `#FB923C` / `#FDBA74` |
| Sapphire | `#38BDF8 → #2563EB → #1E3A8A` | `#2563EB` / `#1D4ED8` | `#60A5FA` / `#93C5FD` |
| Emerald | `#6EE7B7 → #10B981 → #047857` | `#059669` / `#047857` | `#34D399` / `#6EE7B7` |
| Ruby | `#FDA4AF → #E11D48 → #881337` | `#E11D48` / `#BE123C` | `#FB7185` / `#FDA4AF` |
| Amethyst | `#C4B5FD → #7C3AED → #4C1D95` | `#7C3AED` / `#6D28D9` | `#A78BFA` / `#C4B5FD` |
| Graphite | `#D1D5DB → #6B7280 → #1F2937` | `#4B5563` / `#374151` | `#9CA3AF` / `#D1D5DB` |

Graphite replaces the old "Midnight". All values are checked for 4.5:1 text contrast in the QA pass.

**Persistence and migration:** new keys `theme_mode` and `theme_accent`. On first launch the legacy key `selected_theme` migrates:
- `System`, `Light`, `Dark` → mode
- a premium name → that accent with mode Dark (keeping the look the user had)
- `Midnight` → Graphite

**Gating is unchanged:** `premium_provider` still calls `unlockPremiumThemes` / `lockPremiumThemes`. Locking resets the **accent** to Sunrise and keeps the mode. The "Appearance" row in More shows "Sunrise Light", "Sapphire Dark" and so on.

## 6. Logo, icons and splash

- `flutter_launcher_icons` (dev):
  - Android adaptive: foreground and background 432 px, plus monochrome for themed icons
  - iOS: `app-icon-square-1024.png`
  - web: icons and favicon
- `flutter_native_splash` (dev):
  - Light: `#F97316` with the white glyph (Android 12+: `android12-splash-glyph-white-288.png`)
  - Dark: `#140D0A` with the gradient glyph
  - iOS: the full frame
- **Flutter intro** (replaces `AuthLoadingScreen`'s visuals): Concept A in light, Concept C in dark.
  - The glyph rises 24 px and fades in over 0–400 ms; the glow scales from 0.6 to 1.
  - The wordmark fades and slides over 250–600 ms.
  - At ≥700 ms, *once auth has resolved*, the glow crossfades into Today.
  - It never blocks: if auth resolves late, the intro just holds its last frame. The total animation is under about 1.2 s.
- **In-app marks:** the gradient-box wallet icon is replaced with `glyph-*.png`, shown in the auth brand header and the About screen.
- `assets/logo.png` (old, unused) is deleted, and the old launcher webps are regenerated. Verification: grep for `logo.png`, `ic_launcher_foreground.webp` and `#7233EB`.

## 7. AI assistant: findings from ai-persona

ai-persona (`G:/Personal/MyProjects/ai-persona`, `lib/screens/chat/chat_screen.dart`) **does not stream either**. Each turn is one request and one response, and the "streaming" is a 20 ms typewriter on the client. The Accountant's backend (`/ai-chat/message`, a Gemini proxy) is also request/response, so **no backend change**.

**Patterns to borrow:**
1. A reversed `ListView.builder` with `ValueKey(message.id)`. It pins to the bottom with no auto-scroll code, and puts day dividers between messages from different days.
2. A **one-shot reveal token**. Only the newly arrived AI message animates, with a typewriter reveal that is markdown-safe (selection is off while it animates), so rebuilds never re-animate old bubbles.
3. **Typing dots:** three dots driven by one controller, staggered with `Interval`s.
4. **Starter chips**, derived deterministically from the user's own data (top spending category, nearest budget, upcoming bills) with fixed fallbacks. At most three; the first is filled and the rest are outlined. Shown only while the conversation is empty.
5. **Composer:** grows from 52 to 132 px, send is enabled only when the trimmed text is non-empty, and the gradient send button turns muted when disabled.
6. **Long-press** a bubble → a `SunriseBottomSheet` with Copy, plus haptics on send, chip and long-press.
7. The existing `isAiFallback` and error-type contract maps to a styled banner.

**Gaps in ai-persona that we fix here:**
- **Per-message failed state with Retry**, which resends the *same user text*. ai-persona's retry only resends the greeting.
- Sending is blocked while a reply is pending, shown by the disabled send state rather than a snackbar.

**Bubbles:**
- User: ink colour, radius 18 18 4 18
- AI: surface colour, radius 18 18 18 4
- Input: a frosted pill with a gradient send button

The conversation list, rename and delete features stay, reached through a `PushHeader` action.

## 8. Risks

- **Size:** about 80k lines and about 60 screens. Mitigated by the legacy palette bridge, so everything is on-brand from the first commit, and by small per-screen commits.
- **Widget tests** with finders tied to old widgets: `NeoButton`, `Icons.arrow_back_rounded`, `PopupMenuButton`, and the text `'What was it for?'`. These are updated alongside the screens they cover, and **keys are kept**.
- **Variable font on Android:** some engines ignore `wght` axes for weights set through `FontWeight`. Weights are set with `FontVariation('wght', …)` as well, with a fallback to static files.
- **Theme change animation:** a real `SunriseColors.lerp` plus `AnimatedTheme`. The `AppColors` bridge snaps rather than lerps; acceptable, and it shrinks as screens migrate.
- **No RTL locale** exists (en and bn only). New widgets use directional insets and alignment anyway.
- **iOS release build can't be produced on this Windows machine.** The iOS icons, splash and Info.plist are generated and committed, but must be built on a Mac.
- **Bangla strings** run longer than English. Covered by ellipsis and `FittedBox` on amounts, plus a pass at text scale 1.3 at 360 dp.
- **Paywall:** the mock shows only lifetime, but the app sells monthly, yearly and lifetime. **Decision:** keep all three tiers in a compact picker above the CTA. The CTA label follows the selected tier and uses real store prices. The section is hidden when the store returns nothing, as today.

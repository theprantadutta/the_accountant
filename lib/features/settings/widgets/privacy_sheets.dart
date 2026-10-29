import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/privacy_provider.dart';
import 'package:the_accountant/features/settings/screens/privacy_security_screen.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// What each way of opening is called.
String privacyStartLabel(PrivacyStart s, L10n l10n) => switch (s) {
  PrivacyStart.hidden => l10n.privacyStartHidden,
  PrivacyStart.shown => l10n.privacyStartShown,
  PrivacyStart.remember => l10n.privacyStartRemember,
};

/// Pick how balances and totals look each time the app opens.
Future<void> choosePrivacyStart(BuildContext context, WidgetRef ref) async {
  final current = ref.read(privacyProvider).start;
  final picked = await showSunriseSheet<PrivacyStart>(
    context: context,
    builder: (sheet) {
      final l10n = L10n.of(sheet);
      String describe(PrivacyStart s) => switch (s) {
        PrivacyStart.hidden => l10n.privacyStartHiddenSub,
        PrivacyStart.shown => l10n.privacyStartShownSub,
        PrivacyStart.remember => l10n.privacyStartRememberSub,
      };
      IconData icon(PrivacyStart s) => switch (s) {
        PrivacyStart.hidden => Symbols.visibility_off_rounded,
        PrivacyStart.shown => Symbols.visibility_rounded,
        PrivacyStart.remember => Symbols.history_rounded,
      };
      return SunriseBottomSheet(
        title: l10n.privacyStartTitle,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final s in PrivacyStart.values)
              SheetAction(
                key: Key('privacy_start_${s.name}'),
                icon: icon(s),
                label: privacyStartLabel(s, l10n),
                subtitle: describe(s),
                selected: s == current,
                onTap: () => Navigator.pop(sheet, s),
              ),
          ],
        ),
      );
    },
  );
  if (picked != null) {
    await ref.read(privacyProvider.notifier).setStart(picked);
  }
}

/// Says once that balances can now be hidden, and how. Shown to everybody,
/// new installs and people updating alike, since everybody now opens to
/// hidden amounts and should know why.
class PrivacyIntro {
  const PrivacyIntro._();

  static const String seenKey = 'privacy_intro_seen';

  /// Shows the note unless it has been shown already. Returns whether it did.
  static Future<bool> maybeShow(BuildContext context, WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(seenKey) ?? false) return false;
    await prefs.setBool(seenKey, true);
    if (!context.mounted) return false;

    final openSettings = await showSunriseSheet<bool>(
      context: context,
      builder: (sheet) {
        final l10n = L10n.of(sheet);
        final c = sheet.sunrise;
        return SunriseBottomSheet(
          actions: [
            SunriseButton(
              key: const Key('privacy_intro_ok'),
              label: l10n.privacyIntroOk,
              height: 54,
              onPressed: () => Navigator.pop(sheet, false),
            ),
            SunriseButton.secondary(
              key: const Key('privacy_intro_settings'),
              label: l10n.privacyIntroSettings,
              icon: Symbols.tune_rounded,
              onPressed: () => Navigator.pop(sheet, true),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconTile(
                icon: Symbols.visibility_off_rounded,
                color: c.accent,
                background: c.tintOrange,
                size: 52,
                radius: 16,
                iconSize: 26,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.privacyIntroTitle,
                style: SunriseType.section.copyWith(color: c.ink, fontSize: 21),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.privacyIntroBody,
                style: SunriseType.body.copyWith(color: c.body, height: 1.45),
              ),
            ],
          ),
        );
      },
    );
    if ((openSettings ?? false) && context.mounted) {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const PrivacySecurityScreen()));
    }
    return true;
  }
}

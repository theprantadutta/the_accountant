import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/features/encryption/screens/passphrase_screen.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Says once, from 5.0, that the user's data is now encrypted, and offers the
/// optional passphrase.
///
/// It only offers. "Set a passphrase" opens the passphrase screen, which
/// explains what changes either way and asks for explicit agreement before
/// anything is turned on; "Not now" changes nothing.
class EncryptionIntro {
  const EncryptionIntro._();

  static const String seenKey = 'encryption_intro_seen_v5';

  /// Shows the note unless it has been shown already. Returns whether it did.
  static Future<bool> maybeShow(BuildContext context, WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(seenKey) ?? false) return false;
    await prefs.setBool(seenKey, true);
    if (!context.mounted) return false;

    final setUp = await showSunriseSheet<bool>(
      context: context,
      builder: (sheet) {
        final l10n = L10n.of(sheet);
        final c = sheet.sunrise;
        return SunriseBottomSheet(
          actions: [
            SunriseButton(
              key: const Key('encryption_intro_set_up'),
              label: l10n.encIntroSetUp,
              icon: Symbols.key_rounded,
              height: 54,
              onPressed: () => Navigator.pop(sheet, true),
            ),
            SunriseButton.secondary(
              key: const Key('encryption_intro_not_now'),
              label: l10n.encIntroNotNow,
              onPressed: () => Navigator.pop(sheet, false),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconTile(
                icon: Symbols.lock_rounded,
                color: c.positive,
                background: c.tintGreen,
                size: 52,
                radius: 16,
                iconSize: 26,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.encIntroTitle,
                style: SunriseType.section.copyWith(color: c.ink, fontSize: 21),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.encIntroBody,
                style: SunriseType.body.copyWith(color: c.body, height: 1.45),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.encIntroPassphrase,
                style: SunriseType.body.copyWith(color: c.body, height: 1.45),
              ),
            ],
          ),
        );
      },
    );
    if ((setUp ?? false) && context.mounted) {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const PassphraseScreen()));
    }
    return true;
  }
}

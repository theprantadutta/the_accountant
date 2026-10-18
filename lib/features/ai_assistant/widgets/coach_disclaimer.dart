import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// What the money coach is, said once before anyone relies on it.
///
/// An AI can be wrong with complete confidence, and it reads real money. So
/// before the first question this says plainly that answers can be wrong,
/// what leaves the phone to produce them, that nothing changes without the
/// user's OK, and where to report a bad answer.
abstract final class CoachDisclaimer {
  static const _seenKey = 'coach_disclaimer_seen_v1';

  /// Shows the notice unless it has been accepted on this install.
  static Future<void> showIfNeeded(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_seenKey) ?? false) return;
      if (!context.mounted) return;
      await show(context);
      await prefs.setBool(_seenKey, true);
    } catch (_) {
      // Storage unavailable: better to show it again next time than never.
    }
  }

  static Future<void> show(BuildContext context) => showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialog) => const _DisclaimerDialog(),
  );
}

class _DisclaimerDialog extends StatelessWidget {
  const _DisclaimerDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;

    final points = [
      (Symbols.psychology_alt_rounded, l10n.aiDisclaimerMistakes),
      (Symbols.cloud_sync_rounded, l10n.aiDisclaimerData),
      (Symbols.verified_user_rounded, l10n.aiDisclaimerChanges),
      (Symbols.flag_rounded, l10n.aiDisclaimerReport),
    ];

    return Dialog(
      backgroundColor: c.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SunriseRadius.hero),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconTile(
                icon: Symbols.auto_awesome_rounded,
                color: c.accent,
                background: c.tintOrange,
                size: 52,
                radius: 16,
                iconSize: 26,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.aiDisclaimerTitle,
                style: SunriseType.section.copyWith(color: c.ink, fontSize: 20),
              ),
              const SizedBox(height: 14),
              for (final (icon, text) in points)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, size: 20, color: c.accent),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          text,
                          style: SunriseType.body.copyWith(
                            color: c.body,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              SunriseButton(
                label: l10n.aiDisclaimerAccept,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

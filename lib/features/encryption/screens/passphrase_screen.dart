import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/features/backup/services/account_data_key.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

final accountDataKeyProvider = Provider<AccountDataKey>(
  (ref) => const AccountDataKey(),
);

/// Whether the account is protected, and whether this phone holds the key.
final keyStatusProvider = FutureProvider.autoDispose<KeyStatus>(
  (ref) => ref.watch(accountDataKeyProvider).status(),
);

/// The shortest passphrase accepted. Length matters far more than symbols.
const int kMinPassphraseLength = 10;

/// Opt-in passphrase protection: explains exactly what changes either way,
/// and never turns anything on without the user's explicit agreement.
class PassphraseScreen extends ConsumerWidget {
  const PassphraseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final status = ref.watch(keyStatusProvider);
    return SunrisePushPage(
      title: l10n.ppTitle,
      children: [
        status.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          ),
          // Offline the screen cannot know whether a passphrase is set, so it
          // says plainly what to do rather than show a raw error.
          error: (e, _) => _ErrorCard(
            message: e is AccountDataKeyUnavailable && e.unreachable
                ? l10n.ppNeedsConnection
                : '$e',
            onRetry: () => ref.invalidate(keyStatusProvider),
          ),
          data: (s) => !s.protected
              ? const _Explainer()
              : s.unlockedHere
              ? const _ProtectedHere()
              : const _LockedHere(),
        ),
      ],
    );
  }
}

class _Explainer extends ConsumerWidget {
  const _Explainer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.ppIntro,
          style: SunriseType.body.copyWith(color: c.ink, height: 1.45),
        ),
        const SizedBox(height: 16),
        _PointsCard(
          key: const Key('pp_without'),
          title: l10n.ppWithoutTitle,
          icon: Symbols.lock_open_rounded,
          color: c.muted,
          points: [
            l10n.ppWithout1,
            l10n.ppWithout2,
            l10n.ppWithout3,
            l10n.ppWithout4,
          ],
        ),
        const SizedBox(height: 12),
        _PointsCard(
          key: const Key('pp_with'),
          title: l10n.ppWithTitle,
          icon: Symbols.lock_rounded,
          color: c.positive,
          points: [l10n.ppWith1, l10n.ppWith2, l10n.ppWith3, l10n.ppWith4],
        ),
        const SizedBox(height: 12),
        _PointsCard(
          key: const Key('pp_catch'),
          title: l10n.ppCatchTitle,
          icon: Symbols.warning_rounded,
          color: c.negative,
          points: [l10n.ppCatchBody],
        ),
        const SizedBox(height: 12),
        Text(
          l10n.ppAiNote,
          style: SunriseType.caption.copyWith(color: c.muted, height: 1.4),
        ),
        const SizedBox(height: 20),
        SunriseButton(
          key: const Key('pp_set'),
          label: l10n.ppSetButton,
          icon: Symbols.key_rounded,
          onPressed: () => _turnOn(context, ref),
        ),
      ],
    );
  }

  Future<void> _turnOn(BuildContext context, WidgetRef ref) async {
    final passphrase = await _askNewPassphrase(context, requireConsent: true);
    if (passphrase == null || !context.mounted) return;
    final code = await _withProgress(
      context,
      () => ref.read(accountDataKeyProvider).enableProtection(passphrase),
      issuesCode: true,
    );
    if (code == null || !context.mounted) return;
    await _showRecoveryCode(context, code);
    ref.invalidate(keyStatusProvider);
    if (context.mounted) _toast(context, L10n.of(context).ppTurnedOn);
  }
}

class _ProtectedHere extends ConsumerWidget {
  const _ProtectedHere();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final keys = ref.read(accountDataKeyProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PointsCard(
          key: const Key('pp_on'),
          title: l10n.ppOnTitle,
          icon: Symbols.verified_user_rounded,
          color: c.positive,
          points: [l10n.ppOnBody, l10n.ppCatchBody],
        ),
        const SizedBox(height: 16),
        SettingsGroup(
          children: [
            SettingsRow(
              key: const Key('pp_change'),
              icon: Symbols.password_rounded,
              iconColor: c.accent,
              iconBackground: c.tintOrange,
              title: l10n.ppChange,
              onTap: () async {
                final passphrase = await _askNewPassphrase(context);
                if (passphrase == null || !context.mounted) return;
                final ok = await _withProgress(
                  context,
                  () => keys.changePassphrase(passphrase).then((_) => true),
                );
                if (ok == true && context.mounted) {
                  _toast(context, l10n.ppChanged);
                }
              },
            ),
            SettingsRow(
              key: const Key('pp_new_code'),
              icon: Symbols.key_rounded,
              iconColor: c.accent,
              iconBackground: c.tintOrange,
              title: l10n.ppNewCode,
              subtitle: l10n.ppNewCodeWarn,
              onTap: () async {
                final go = await showSunriseConfirm(
                  context: context,
                  title: l10n.ppNewCode,
                  message: l10n.ppNewCodeWarn,
                  confirmLabel: l10n.ppNewCode,
                );
                if (!go || !context.mounted) return;
                final code = await _withProgress(
                  context,
                  keys.newRecoveryCode,
                  issuesCode: true,
                );
                if (code != null && context.mounted) {
                  await _showRecoveryCode(context, code);
                }
              },
            ),
            SettingsRow(
              key: const Key('pp_turn_off'),
              icon: Symbols.lock_open_rounded,
              title: l10n.ppTurnOff,
              destructive: true,
              onTap: () async {
                final go = await showSunriseConfirm(
                  context: context,
                  title: l10n.ppTurnOff,
                  message: l10n.ppTurnOffBody,
                  confirmLabel: l10n.ppTurnOff,
                  destructive: true,
                );
                if (!go || !context.mounted) return;
                final ok = await _withProgress(
                  context,
                  () => keys.disableProtection().then((_) => true),
                );
                if (ok == true && context.mounted) {
                  ref.invalidate(keyStatusProvider);
                  _toast(context, l10n.ppTurnedOff);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _LockedHere extends ConsumerWidget {
  const _LockedHere();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PointsCard(
          key: const Key('pp_locked'),
          title: l10n.ppLockedTitle,
          icon: Symbols.lock_rounded,
          color: c.accent,
          points: [l10n.ppLockedBody],
        ),
        const SizedBox(height: 20),
        SunriseButton(
          key: const Key('pp_unlock'),
          label: l10n.ppUnlock,
          icon: Symbols.lock_open_rounded,
          onPressed: () async {
            if (await showUnlockSheet(context, ref) && context.mounted) {
              ref.invalidate(keyStatusProvider);
            }
          },
        ),
      ],
    );
  }
}

/// Ask for the passphrase (or the recovery code) and unlock this phone.
/// True once unlocked.
Future<bool> showUnlockSheet(BuildContext context, WidgetRef ref) async {
  final keys = ref.read(accountDataKeyProvider);
  final l10n = L10n.of(context);
  final unlocked = await showSecretSheet(
    context,
    title: l10n.ppLockedTitle,
    subtitle: l10n.ppLockedBody,
    attempt: (secret, isRecoveryCode) => isRecoveryCode
        ? keys.unlockWithRecoveryCode(secret)
        : keys.unlockWithPassphrase(secret),
  );
  if (unlocked && context.mounted) {
    _toast(context, L10n.of(context).ppUnlocked);
  }
  return unlocked;
}

/// Asks for the passphrase, or the recovery code, until [attempt] accepts
/// one or the user gives up. True when it was accepted.
///
/// Used to unlock this device, and to open a backup that carries its own
/// locked key.
Future<bool> showSecretSheet(
  BuildContext context, {
  required String title,
  required String subtitle,
  required Future<bool> Function(String secret, bool isRecoveryCode) attempt,
}) async {
  final accepted = await showSunriseSheet<bool>(
    context: context,
    builder: (_) =>
        _UnlockSheet(title: title, subtitle: subtitle, attempt: attempt),
  );
  return accepted == true;
}

class _UnlockSheet extends StatefulWidget {
  const _UnlockSheet({
    required this.title,
    required this.subtitle,
    required this.attempt,
  });

  final String title;
  final String subtitle;
  final Future<bool> Function(String secret, bool isRecoveryCode) attempt;

  @override
  State<_UnlockSheet> createState() => _UnlockSheetState();
}

class _UnlockSheetState extends State<_UnlockSheet> {
  final _controller = TextEditingController();
  bool _recovery = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = L10n.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final ok = await widget.attempt(_controller.text, _recovery);
      if (!mounted) return;
      if (ok) {
        Navigator.of(context).pop(true);
      } else {
        setState(
          () => _error = _recovery
              ? l10n.ppWrongRecovery
              : l10n.ppWrongPassphrase,
        );
      }
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    // SunriseBottomSheet already makes room for the keyboard; doing it
    // here too hid the fields behind it.
    return SunriseBottomSheet(
      title: widget.title,
      subtitle: widget.subtitle,
      actions: [
        SunriseButton(
          key: const Key('pp_unlock_submit'),
          label: l10n.ppUnlock,
          height: 54,
          loading: _busy,
          onPressed: _busy ? null : _submit,
        ),
        SunriseButton.secondary(
          key: const Key('pp_unlock_switch'),
          label: _recovery ? l10n.ppUsePassphrase : l10n.ppUseRecovery,
          onPressed: _busy
              ? null
              : () => setState(() {
                  _recovery = !_recovery;
                  _error = null;
                  _controller.clear();
                }),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SunriseTextField(
            key: const Key('pp_unlock_field'),
            controller: _controller,
            label: _recovery ? l10n.ppRecoveryLabel : l10n.ppPassphraseLabel,
            obscureText: !_recovery,
            autofocus: true,
            textCapitalization: _recovery
                ? TextCapitalization.characters
                : TextCapitalization.none,
            onSubmitted: (_) => _busy ? null : _submit(),
          ),
          if (_busy) ...[
            const SizedBox(height: 10),
            Text(
              l10n.ppWorking,
              style: SunriseType.caption.copyWith(color: c.muted),
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(
              _error!,
              key: const Key('pp_unlock_error'),
              style: SunriseType.caption.copyWith(color: c.negative),
            ),
          ],
        ],
      ),
    );
  }
}

/// Ask for a new passphrase twice. With [requireConsent], the user must also
/// tick that they understand what losing it means. Null when cancelled.
Future<String?> _askNewPassphrase(
  BuildContext context, {
  bool requireConsent = false,
}) => showSunriseSheet<String>(
  context: context,
  builder: (_) => _NewPassphraseSheet(requireConsent: requireConsent),
);

class _NewPassphraseSheet extends StatefulWidget {
  const _NewPassphraseSheet({required this.requireConsent});

  final bool requireConsent;

  @override
  State<_NewPassphraseSheet> createState() => _NewPassphraseSheetState();
}

class _NewPassphraseSheetState extends State<_NewPassphraseSheet> {
  final _first = TextEditingController();
  final _second = TextEditingController();
  bool _agreed = false;
  String? _error;

  @override
  void dispose() {
    _first.dispose();
    _second.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = L10n.of(context);
    final first = _first.text.trim();
    if (first.length < kMinPassphraseLength) {
      setState(() => _error = l10n.ppTooShort);
      return;
    }
    if (first != _second.text.trim()) {
      setState(() => _error = l10n.ppMismatch);
      return;
    }
    Navigator.of(context).pop(first);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final canSubmit = !widget.requireConsent || _agreed;
    // SunriseBottomSheet already makes room for the keyboard; doing it
    // here too hid the fields behind it.
    return SunriseBottomSheet(
      title: l10n.ppSetTitle,
      subtitle: l10n.ppSetHint,
      actions: [
        SunriseButton(
          key: const Key('pp_new_submit'),
          label: widget.requireConsent ? l10n.ppTurnOn : l10n.ppChange,
          height: 54,
          onPressed: canSubmit ? _submit : null,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SunriseTextField(
            key: const Key('pp_new_first'),
            controller: _first,
            label: l10n.ppPassphraseLabel,
            obscureText: true,
            autofocus: true,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 10),
          SunriseTextField(
            key: const Key('pp_new_second'),
            controller: _second,
            label: l10n.ppConfirmLabel,
            obscureText: true,
            onSubmitted: (_) => canSubmit ? _submit() : null,
          ),
          if (widget.requireConsent) ...[
            const SizedBox(height: 12),
            Material(
              type: MaterialType.transparency,
              child: CheckboxListTile(
                key: const Key('pp_consent'),
                value: _agreed,
                onChanged: (v) => setState(() => _agreed = v ?? false),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  l10n.ppUnderstand,
                  style: SunriseType.caption.copyWith(
                    color: c.ink,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              key: const Key('pp_new_error'),
              style: SunriseType.caption.copyWith(color: c.negative),
            ),
          ],
        ],
      ),
    );
  }
}

/// Show the recovery code until the user confirms they have saved it.
Future<void> _showRecoveryCode(BuildContext context, String code) =>
    showSunriseSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => _RecoveryCodeSheet(code: code),
    );

class _RecoveryCodeSheet extends StatefulWidget {
  const _RecoveryCodeSheet({required this.code});

  final String code;

  @override
  State<_RecoveryCodeSheet> createState() => _RecoveryCodeSheetState();
}

class _RecoveryCodeSheetState extends State<_RecoveryCodeSheet> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return SunriseBottomSheet(
      title: l10n.ppRecoveryTitle,
      subtitle: l10n.ppRecoveryBody,
      actions: [
        SunriseButton(
          key: const Key('pp_code_done'),
          label: l10n.ppDone,
          height: 54,
          onPressed: _saved ? () => Navigator.of(context).pop() : null,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SunriseCard(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              widget.code,
              key: const Key('pp_code'),
              textAlign: TextAlign.center,
              style: SunriseType.rowTitle.copyWith(
                color: c.ink,
                fontFeatures: const [FontFeature.tabularFigures()],
                letterSpacing: 1.2,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            child: TextButton.icon(
              key: const Key('pp_code_copy'),
              icon: const Icon(Symbols.content_copy_rounded, size: 18),
              label: Text(l10n.ppCopy),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: widget.code));
                if (context.mounted) _toast(context, l10n.ppCopied);
              },
            ),
          ),
          Material(
            type: MaterialType.transparency,
            child: CheckboxListTile(
              key: const Key('pp_code_saved'),
              value: _saved,
              onChanged: (v) => setState(() => _saved = v ?? false),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                l10n.ppSavedIt,
                style: SunriseType.caption.copyWith(color: c.ink, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A card with a heading and a short list of plain statements.
class _PointsCard extends StatelessWidget {
  const _PointsCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.points,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<String> points;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return SunriseCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: SunriseType.rowTitle.copyWith(color: c.ink),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final point in points)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 7, right: 10),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      point,
                      style: SunriseType.body.copyWith(
                        color: c.ink,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return SunriseCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(message, style: SunriseType.body.copyWith(color: c.ink)),
          const SizedBox(height: 12),
          SunriseButton.secondary(
            label: MaterialLocalizations.of(
              context,
            ).refreshIndicatorSemanticLabel,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}

/// Run slow key work behind a blocking progress sheet. Null when it failed,
/// after telling the user why.
///
/// [issuesCode] marks work that sends a new recovery code to the server. If
/// the reply is lost the server may have saved it anyway, and the old code
/// (or no code) is what the user has; they are told to repeat it until a
/// code is actually shown.
Future<T?> _withProgress<T>(
  BuildContext context,
  Future<T> Function() work, {
  bool issuesCode = false,
}) async {
  final l10n = L10n.of(context);
  final navigator = Navigator.of(context, rootNavigator: true);
  showSunriseSheet<void>(
    context: context,
    isDismissible: false,
    enableDrag: false,
    builder: (sheet) => PopScope(
      canPop: false,
      child: SunriseBottomSheet(
        title: l10n.ppTitle,
        child: Row(
          children: [
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(l10n.ppWorking)),
          ],
        ),
      ),
    ),
  );
  try {
    final result = await work();
    navigator.pop();
    return result;
  } catch (e) {
    navigator.pop();
    final uncertain =
        issuesCode &&
        e is ApiException &&
        (e.isNetworkError || e.isServerError);
    if (context.mounted) {
      _toast(context, uncertain ? '$e ${l10n.ppMaybeSaved}' : '$e', bad: true);
    }
    return null;
  }
}

void _toast(BuildContext context, String message, {bool bad = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bad ? context.sunrise.negative : null,
      ),
    );
}

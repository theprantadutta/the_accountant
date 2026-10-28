import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/utils/color_utils.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/core/utils/time_formatter.dart';
import 'package:the_accountant/features/ads/reward_flow.dart';
import 'package:the_accountant/features/ads/rewarded_ads.dart';
import 'package:the_accountant/features/ai_assistant/providers/ai_quota_provider.dart';
import 'package:the_accountant/features/ai_assistant/services/ai_api.dart';
import 'package:the_accountant/features/ai_assistant/services/finance_context_builder.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/features/transactions/widgets/transaction_type_header.dart'
    show TransactionTypeSelection;
import 'package:the_accountant/features/voice_log/services/voice_log_service.dart';
import 'package:the_accountant/features/voice_log/widgets/voice_orb.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Say transactions instead of typing them.
///
/// Speech becomes text on the phone, the AI turns the text into adds, changes
/// and removals, and every one is shown as a card to check before anything is
/// saved. Returns what was saved, so the caller can offer Undo.
Future<VoiceSaveResult?> showVoiceLogSheet(BuildContext context) =>
    showSunriseSheet<VoiceSaveResult>(
      context: context,
      builder: (_) => const _VoiceLogSheet(),
    );

enum _Phase { idle, listening, typing, thinking, review, saving, done, error }

class _VoiceLogSheet extends ConsumerStatefulWidget {
  const _VoiceLogSheet();

  @override
  ConsumerState<_VoiceLogSheet> createState() => _VoiceLogSheetState();
}

class _VoiceLogSheetState extends ConsumerState<_VoiceLogSheet> {
  final SpeechToText _speech = SpeechToText();
  final TextEditingController _typed = TextEditingController();

  _Phase _phase = _Phase.idle;
  bool _speechReady = false;
  bool _sending = false;

  /// What the recognizer has heard so far.
  String _words = '';

  /// The voice's loudness, 0 to 1, scaled to what this phone reports.
  double _level = 0;
  double _quietest = 0;
  double _loudest = 1;

  /// What was sent, kept for "Try again" and for editing.
  String _said = '';
  List<VoiceDraft> _drafts = [];
  String? _aiMessage;
  String? _error;

  /// Whether [_error] is about the microphone rather than the connection.
  bool _micProblem = false;

  @override
  void initState() {
    super.initState();
    // Starts listening straight away: the user tapped the mic to talk.
    WidgetsBinding.instance.addPostFrameCallback((_) => _listen());
  }

  @override
  void dispose() {
    _speech.cancel();
    _typed.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------- speech

  Future<void> _listen() async {
    final l10n = L10n.of(context);
    HapticFeedback.mediumImpact();
    if (!_speechReady) {
      try {
        _speechReady = await _speech.initialize(
          onStatus: _onStatus,
          onError: _onError,
        );
      } catch (_) {
        _speechReady = false;
      }
    }
    if (!mounted) return;
    if (!_speechReady) {
      final allowed = await _speech.hasPermission;
      if (!mounted) return;
      setState(() {
        _phase = _Phase.error;
        _error = allowed ? l10n.voiceUnavailable : l10n.voiceMicOff;
        _micProblem = true;
      });
      return;
    }

    setState(() {
      _phase = _Phase.listening;
      _words = '';
      _level = 0;
      _error = null;
    });
    await _speech.listen(
      onResult: _onResult,
      onSoundLevelChange: _onLevel,
      listenOptions: SpeechListenOptions(
        listenFor: const Duration(seconds: 60),
        pauseFor: const Duration(seconds: 3),
        localeId: await _localeId(),
        partialResults: true,
        listenMode: ListenMode.dictation,
        cancelOnError: true,
      ),
    );
  }

  /// Bengali when the app is in Bengali and the phone can hear it; otherwise
  /// the phone's own language.
  Future<String?> _localeId() async {
    if (FinanceContextBuilder.languageOf(ref.read) != 'bn') return null;
    final locales = await _speech.locales();
    return locales
        .where((l) => l.localeId.toLowerCase().startsWith('bn'))
        .firstOrNull
        ?.localeId;
  }

  void _onResult(SpeechRecognitionResult result) {
    if (!mounted) return;
    setState(() => _words = result.recognizedWords);
    if (result.finalResult) _finishListening();
  }

  void _onLevel(double raw) {
    // Phones report very different ranges, so scale to what this one has
    // shown so far.
    _quietest = raw < _quietest ? raw : _quietest;
    _loudest = raw > _loudest ? raw : _loudest;
    final span = _loudest - _quietest;
    if (mounted && span > 0) {
      setState(() => _level = ((raw - _quietest) / span).clamp(0, 1));
    }
  }

  void _onStatus(String status) {
    if (status == SpeechToText.doneStatus ||
        status == SpeechToText.notListeningStatus) {
      _finishListening();
    }
  }

  void _onError(SpeechRecognitionError error) {
    if (!mounted || _phase != _Phase.listening) return;
    final l10n = L10n.of(context);
    if (_words.trim().isNotEmpty) {
      _finishListening();
      return;
    }
    setState(() {
      _phase = _Phase.idle;
      _level = 0;
      _error = l10n.voiceNoSpeech;
    });
  }

  void _finishListening() {
    if (!mounted || _phase != _Phase.listening) return;
    final words = _words.trim();
    if (words.isEmpty) {
      setState(() {
        _phase = _Phase.idle;
        _level = 0;
        _error = L10n.of(context).voiceNoSpeech;
      });
      return;
    }
    _send(words);
  }

  Future<void> _stop() async {
    HapticFeedback.lightImpact();
    await _speech.stop();
    _finishListening();
  }

  /// An example, put in the box to send as it is or change first.
  void _useExample(String example) {
    HapticFeedback.selectionClick();
    _speech.cancel();
    _typed.text = example;
    _typed.selection = TextSelection.collapsed(offset: example.length);
    setState(() {
      _phase = _Phase.typing;
      _error = null;
    });
  }

  void _typeInstead() {
    _speech.cancel();
    setState(() {
      _phase = _Phase.typing;
      _error = null;
      if (_typed.text.isEmpty) _typed.text = _words.isNotEmpty ? _words : _said;
    });
  }

  // ------------------------------------------------------------------- AI

  Future<void> _send(String text) async {
    if (_sending || text.trim().isEmpty) return;
    FocusManager.instance.primaryFocus?.unfocus();

    if (!ref.read(aiQuotaProvider).hasCallsLeft) {
      final earned = await earnWithAd(context, ref, RewardKind.aiCall);
      if (!mounted) return;
      if (!earned) {
        setState(() => _phase = _Phase.typing);
        _typed.text = text;
        return;
      }
    }

    _sending = true;
    setState(() {
      _micProblem = false;
      _said = text.trim();
      _phase = _Phase.thinking;
      _error = null;
    });
    try {
      final (drafts, message) = await ref
          .read(voiceLogServiceProvider)
          .interpret(_said);
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      setState(() {
        _drafts = drafts;
        _aiMessage = message;
        _phase = _Phase.review;
      });
    } on AiException catch (e) {
      if (mounted) {
        setState(() {
          _phase = _Phase.error;
          _error = e.message;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _phase = _Phase.error;
          _error = L10n.of(context).voiceSomethingWrong;
        });
      }
    } finally {
      _sending = false;
      ref.read(aiQuotaProvider.notifier).refresh();
    }
  }

  // ----------------------------------------------------------------- save

  int get _toSave => _drafts.where((d) => d.included && d.ready).length;

  Future<void> _save() async {
    if (_toSave == 0) return;
    HapticFeedback.mediumImpact();
    setState(() => _phase = _Phase.saving);
    final result = await ref.read(voiceLogServiceProvider).save(_drafts);
    if (!mounted) return;
    HapticFeedback.heavyImpact();
    setState(() => _phase = _Phase.done);
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (mounted) Navigator.pop(context, result);
  }

  /// Hand a new transaction to the add screen, filled in, for the user to
  /// finish there: an amount they did not say, or anything else to adjust.
  Future<void> _openInAddScreen(VoiceDraft draft) async {
    final a = draft.action;
    setState(() => draft.included = false);
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddTransactionScreen(
          initialType: a.isIncome == true
              ? TransactionTypeSelection.income
              : TransactionTypeSelection.expense,
          prefillAmount: a.amount,
          prefillTitle: a.title,
          prefillCategoryName: a.category,
          prefillDate: a.date,
          prefillNote: a.note,
        ),
      ),
    );
    if (!mounted) return;
    // Saved there, so it is done; backed out, it stays here, unticked.
    if (saved == true) setState(() => _drafts.remove(draft));
  }

  // ------------------------------------------------------------------- UI

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final media = MediaQuery.of(context);
    return Container(
      height: media.size.height * .9,
      decoration: BoxDecoration(
        borderRadius: SunriseRadius.sheetTop,
        color: c.base,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [c.washTop, c.washMid, c.base],
          stops: const [0, .28, .62],
        ),
      ),
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: c.chevron.withValues(alpha: .6),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            _header(context),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 380),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, a) => FadeTransition(
                  opacity: a,
                  child: SlideTransition(
                    position: Tween(
                      begin: const Offset(0, .04),
                      end: Offset.zero,
                    ).animate(a),
                    child: child,
                  ),
                ),
                child: KeyedSubtree(
                  key: ValueKey(switch (_phase) {
                    _Phase.idle || _Phase.listening => 'talk',
                    _Phase.saving || _Phase.done => 'done',
                    final p => p.name,
                  }),
                  child: switch (_phase) {
                    _Phase.idle || _Phase.listening => _talkView(context),
                    _Phase.typing => _typeView(context),
                    _Phase.thinking => _thinkingView(context),
                    _Phase.review => _reviewView(context),
                    _Phase.saving || _Phase.done => _doneView(context),
                    _Phase.error => _errorView(context),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final quota = ref.watch(aiQuotaProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 12, 0),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (r) => c.gradient.createShader(r),
            child: const Icon(
              Symbols.graphic_eq_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.voiceTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: SunriseType.section.copyWith(color: c.ink, fontSize: 22),
            ),
          ),
          SunrisePill(
            icon: quota.unlimited
                ? Symbols.all_inclusive_rounded
                : Symbols.bolt_rounded,
            label: quota.unlimited
                ? l10n.voiceUnlimited
                : l10n.aiQuotaLeft(quota.remaining ?? 0),
            color: c.accentText,
            background: c.tintOrange,
          ),
          const SizedBox(width: 4),
          SunriseIconButton(
            icon: Symbols.close_rounded,
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  /// The orb, what has been heard, examples, and the controls.
  Widget _talkView(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final listening = _phase == _Phase.listening;
    final heard = _words.trim();
    return Column(
      children: [
        const Spacer(flex: 2),
        GestureDetector(
          onTap: listening ? _stop : _listen,
          child: VoiceOrb(
            mode: listening ? VoiceOrbMode.listening : VoiceOrbMode.idle,
            level: _level,
            size: 220,
            icon: listening ? null : Symbols.mic_rounded,
          ),
        ),
        const SizedBox(height: 18),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: Text(
            _error ?? (listening ? l10n.voiceListening : l10n.voiceTapToTalk),
            key: ValueKey(_error ?? listening),
            textAlign: TextAlign.center,
            style: SunriseType.label.copyWith(
              color: _error != null ? c.negative : c.muted,
              fontSize: 15,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 18, 28, 0),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: heard.isEmpty
                ? const SizedBox(width: double.infinity)
                : Text(
                    heard,
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: SunriseType.section.copyWith(
                      color: c.ink,
                      fontSize: 22,
                      height: 1.35,
                    ),
                  ),
          ),
        ),
        const Spacer(flex: 2),
        if (heard.isEmpty) _examples(context),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _RoundControl(
                icon: Symbols.keyboard_rounded,
                label: l10n.voiceTypeInstead,
                onTap: _typeInstead,
              ),
              _MicButton(
                listening: listening,
                onTap: listening ? _stop : _listen,
              ),
              _RoundControl(
                icon: Symbols.arrow_upward_rounded,
                label: l10n.voiceSend,
                onTap: heard.isEmpty ? null : _stop,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// A few things to say, for anyone who has not tried it before.
  Widget _examples(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final examples = [
      l10n.voiceExample1,
      l10n.voiceExample2,
      l10n.voiceExample3,
      l10n.voiceExample4,
    ];
    return Column(
      children: [
        Text(
          l10n.voiceTrySaying.toUpperCase(),
          style: SunriseType.label.copyWith(
            color: c.subtle,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: .8,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              for (var i = 0; i < examples.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                _Stagger(
                  index: i,
                  child: Pressable(
                    onTap: () => _useExample(examples[i]),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: c.surface,
                        borderRadius: BorderRadius.circular(SunriseRadius.chip),
                        border: Border.all(color: c.tabBarBorder),
                      ),
                      child: Text(
                        '“${examples[i]}”',
                        style: SunriseType.label.copyWith(
                          color: c.body,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _typeView(BuildContext context) {
    final l10n = L10n.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SunriseTextField(
            controller: _typed,
            hint: l10n.voiceTypeHint,
            icon: Symbols.edit_note_rounded,
            autofocus: true,
            minLines: 3,
            maxLines: 6,
            maxLength: 600,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.send,
            onSubmitted: _send,
          ),
          const SizedBox(height: 12),
          _examples(context),
          const Spacer(),
          Row(
            children: [
              SunriseButton.secondary(
                label: l10n.voiceSpeakInstead,
                icon: Symbols.mic_rounded,
                expand: false,
                height: 54,
                onPressed: _listen,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _typed,
                  builder: (context, value, _) => SunriseButton(
                    label: l10n.voiceSend,
                    icon: Symbols.auto_awesome_rounded,
                    height: 54,
                    onPressed: value.text.trim().isEmpty
                        ? null
                        : () => _send(value.text),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _thinkingView(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return Column(
      children: [
        const Spacer(flex: 2),
        const VoiceOrb(mode: VoiceOrbMode.thinking, size: 180),
        const SizedBox(height: 22),
        _Shimmer(
          child: Text(
            l10n.voiceThinking,
            style: SunriseType.section.copyWith(color: c.ink, fontSize: 18),
          ),
        ),
        const SizedBox(height: 18),
        _SaidBubble(text: _said),
        const Spacer(flex: 3),
      ],
    );
  }

  Widget _reviewView(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final toSave = _toSave;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            children: [
              _SaidBubble(
                text: _said,
                onEdit: () {
                  _typed.text = _said;
                  setState(() => _phase = _Phase.typing);
                },
              ),
              if (_aiMessage != null) ...[
                const SizedBox(height: 12),
                _Stagger(index: 0, child: _AiNote(text: _aiMessage!)),
              ],
              const SizedBox(height: 18),
              if (_drafts.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 10),
                  child: Text(
                    l10n.voiceReady(_drafts.where((d) => d.ready).length),
                    style: SunriseType.label.copyWith(
                      color: c.muted,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .8,
                    ),
                  ),
                ),
              for (var i = 0; i < _drafts.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _Stagger(
                    index: i + 1,
                    child: _DraftCard(
                      draft: _drafts[i],
                      onToggle: _drafts[i].ready
                          ? () {
                              HapticFeedback.selectionClick();
                              setState(
                                () =>
                                    _drafts[i].included = !_drafts[i].included,
                              );
                            }
                          : null,
                      onFillIn: _drafts[i].action.op == VoiceLogOp.add
                          ? () => _openInAddScreen(_drafts[i])
                          : null,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Row(
            children: [
              SunriseButton.secondary(
                label: l10n.voiceTryAgain,
                icon: Symbols.mic_rounded,
                expand: false,
                height: 56,
                onPressed: _listen,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SunriseButton(
                  label: l10n.voiceSaveCount(toSave),
                  icon: toSave == 0 ? null : Symbols.check_rounded,
                  height: 56,
                  onPressed: toSave == 0 ? null : _save,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _doneView(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final done = _phase == _Phase.done;
    return Column(
      children: [
        const Spacer(flex: 2),
        VoiceOrb(
          mode: done ? VoiceOrbMode.done : VoiceOrbMode.thinking,
          size: 180,
          icon: done ? Symbols.check_rounded : null,
        ),
        const SizedBox(height: 22),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            done ? l10n.voiceSaved(_toSave) : l10n.voiceSaving,
            key: ValueKey(done),
            style: SunriseType.section.copyWith(color: c.ink, fontSize: 20),
          ),
        ),
        const Spacer(flex: 3),
      ],
    );
  }

  Widget _errorView(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
      child: Column(
        children: [
          const Spacer(flex: 2),
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: c.tintRose,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _micProblem ? Symbols.mic_off_rounded : Symbols.cloud_off_rounded,
              color: c.negative,
              size: 38,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            _error ?? l10n.voiceSomethingWrong,
            textAlign: TextAlign.center,
            style: SunriseType.body.copyWith(color: c.ink, fontSize: 16),
          ),
          const Spacer(flex: 3),
          Row(
            children: [
              Expanded(
                child: SunriseButton.secondary(
                  label: l10n.voiceTypeInstead,
                  icon: Symbols.keyboard_rounded,
                  onPressed: _typeInstead,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SunriseButton(
                  label: l10n.voiceTryAgain,
                  icon: Symbols.refresh_rounded,
                  height: 52,
                  onPressed: _said.isNotEmpty && _drafts.isEmpty
                      ? () => _send(_said)
                      : _listen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------ pieces

/// The big talk button: a gradient circle that becomes a stop square.
class _MicButton extends StatelessWidget {
  const _MicButton({required this.listening, required this.onTap});

  final bool listening;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final l10n = L10n.of(context);
    return Semantics(
      button: true,
      label: listening ? l10n.voiceStop : l10n.voiceTapToTalk,
      child: Pressable(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            gradient: c.gradient,
            shape: BoxShape.circle,
            boxShadow: c.gradientShadow,
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, a) =>
                  ScaleTransition(scale: a, child: child),
              child: listening
                  ? Container(
                      key: const ValueKey('stop'),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    )
                  : const Icon(
                      Symbols.mic_rounded,
                      key: ValueKey('mic'),
                      color: Colors.white,
                      size: 34,
                      fill: 1,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A small round control with its name under it.
class _RoundControl extends StatelessWidget {
  const _RoundControl({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: onTap == null ? .35 : 1,
      child: Pressable(
        onTap: onTap,
        child: SizedBox(
          width: 84,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: c.surface,
                  shape: BoxShape.circle,
                  boxShadow: c.cardShadow,
                ),
                child: Icon(icon, color: c.ink, size: 24),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: SunriseType.label.copyWith(color: c.muted, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// What the user said, as a quote, with a way to change it.
class _SaidBubble extends StatelessWidget {
  const _SaidBubble({required this.text, this.onEdit});

  final String text;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final l10n = L10n.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        decoration: BoxDecoration(
          gradient: c.softStrip,
          borderRadius: SunriseRadius.cardAll,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                Symbols.format_quote_rounded,
                size: 20,
                color: c.accent,
                fill: 1,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: SunriseType.body.copyWith(
                  color: c.ink,
                  fontSize: 15.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            if (onEdit != null)
              Pressable(
                onTap: onEdit,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    l10n.voiceEdit,
                    style: SunriseType.label.copyWith(
                      color: c.accentText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Something the AI could not settle on its own.
class _AiNote extends StatelessWidget {
  const _AiNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.tintAmber,
        borderRadius: SunriseRadius.cardAll,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Symbols.auto_awesome_rounded,
            color: c.accent,
            size: 20,
            fill: 1,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: SunriseType.body.copyWith(color: c.ink, fontSize: 14.5),
            ),
          ),
        ],
      ),
    );
  }
}

/// One add, change or removal, as it will be saved.
class _DraftCard extends ConsumerWidget {
  const _DraftCard({required this.draft, this.onToggle, this.onFillIn});

  final VoiceDraft draft;
  final VoidCallback? onToggle;
  final VoidCallback? onFillIn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.sunrise;
    final l10n = L10n.of(context);
    final preview = draft.plan.preview;
    final op = draft.action.op;
    final ready = draft.ready;
    final on = draft.included && ready;

    final (Color tone, Color tint, IconData badge, String kind) = !ready
        ? (c.accent, c.tintAmber, Symbols.help_rounded, l10n.voiceNeedsYou)
        : switch (op) {
            VoiceLogOp.add => (
              c.positive,
              c.tintGreen,
              Symbols.add_rounded,
              l10n.voiceNew,
            ),
            VoiceLogOp.update => (
              c.accent,
              c.tintOrange,
              Symbols.edit_rounded,
              l10n.voiceChange,
            ),
            VoiceLogOp.delete => (
              c.negative,
              c.tintRose,
              Symbols.delete_rounded,
              l10n.voiceRemove,
            ),
          };

    final categories = ref.watch(categoryProvider).categories;
    final categoryName = preview?.category ?? draft.action.category;
    final category = categories
        .where((x) => x.name == categoryName)
        .firstOrNull;
    final dateFormat = ref.watch(dateFormatSettingProvider);
    final numberFormat = ref.watch(numberFormatSettingProvider);
    final useDecimals = ref.watch(defaultDecimalProvider);

    final title =
        preview?.title ?? draft.action.title ?? categoryName ?? l10n.voiceNew;
    final amount = preview == null
        ? (draft.action.amount == null
              ? null
              : (draft.action.amount! * 100).round().formatCurrency(
                  '',
                  useDecimals: useDecimals,
                  numberFormat: numberFormat,
                ))
        : preview.amount.formatCurrency(
            preview.currency,
            useDecimals: useDecimals,
            numberFormat: numberFormat,
          );
    final isIncome = preview?.isIncome ?? draft.action.isIncome ?? false;
    final when = preview?.date;

    final meta = [
      ?categoryName,
      ?preview?.account,
      if (when != null)
        '${AppDateFormatter.formatRelativeDate(when, dateFormat, l10n: l10n)}'
            ' · ${AppTimeFormatter.of(context, when)}',
    ].join(' · ');

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 220),
      opacity: on || !ready ? 1 : .5,
      child: Pressable(
        onTap: onToggle,
        child: Container(
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: SunriseRadius.cardAll,
            boxShadow: c.cardShadow,
            border: Border.all(
              color: on ? tone.withValues(alpha: .35) : Colors.transparent,
              width: 1.4,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // The kind, as a coloured edge.
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [tone, tone.withValues(alpha: .35)],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _CategoryIcon(
                              iconName: category?.iconName,
                              color: category == null
                                  ? tone
                                  : ColorUtils.hexToColor(category.colorCode),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _KindBadge(
                                    icon: badge,
                                    label: kind,
                                    color: tone,
                                    background: tint,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: SunriseType.rowTitle.copyWith(
                                      color: c.ink,
                                      fontSize: 16.5,
                                      decoration: op == VoiceLogOp.delete
                                          ? TextDecoration.lineThrough
                                          : null,
                                      decorationColor: c.negative,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (amount != null)
                                  Text(
                                    '${isIncome ? '+' : '−'}$amount',
                                    style: SunriseType.amount.copyWith(
                                      color: isIncome ? c.positive : c.ink,
                                      fontSize: 17,
                                      decoration: op == VoiceLogOp.delete
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                const SizedBox(height: 6),
                                if (ready) _Check(on: on, color: tone),
                              ],
                            ),
                          ],
                        ),
                        if (meta.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            meta,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: SunriseType.caption.copyWith(
                              color: c.subtle,
                              fontSize: 13,
                            ),
                          ),
                        ],
                        if (preview != null && preview.changes.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          for (final MapEntry(:key, value: (from, to))
                              in preview.changes.entries)
                            _ChangeRow(
                              label: _fieldLabel(key, l10n),
                              from: from,
                              to: to,
                            ),
                        ],
                        if (!ready) ...[
                          const SizedBox(height: 10),
                          Text(
                            draft.action.op == VoiceLogOp.add &&
                                    draft.action.amount == null
                                ? l10n.voiceNeedsAmount
                                : draft.problem ?? '',
                            style: SunriseType.caption.copyWith(
                              color: c.body,
                              fontSize: 13,
                            ),
                          ),
                        ],
                        if (onFillIn != null) ...[
                          const SizedBox(height: 10),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Pressable(
                              onTap: onFillIn,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Symbols.tune_rounded,
                                    size: 16,
                                    color: c.accentText,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    ready ? l10n.voiceAdjust : l10n.voiceFillIn,
                                    style: SunriseType.label.copyWith(
                                      color: c.accentText,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _fieldLabel(String key, L10n l10n) => switch (key) {
    'amount' => l10n.aiActionAmount,
    'kind' => l10n.aiActionKind,
    'title' => l10n.aiActionTitle,
    'category' => l10n.aiActionCategory,
    'account' => l10n.aiActionAccount,
    'date' => l10n.aiActionDate,
    'time' => l10n.voiceTime,
    'notes' => l10n.aiActionNotes,
    _ => key,
  };
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({required this.iconName, required this.color});

  final String? iconName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final emoji = IconRegistry.emojiOf(iconName);
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(SunriseRadius.iconTile),
      ),
      alignment: Alignment.center,
      child: emoji != null
          ? Text(emoji, style: const TextStyle(fontSize: 22))
          : Icon(
              iconName == null
                  ? Symbols.receipt_long_rounded
                  : IconRegistry.getIcon(iconName!),
              color: color,
              size: 22,
            ),
    );
  }
}

class _KindBadge extends StatelessWidget {
  const _KindBadge({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(6, 2, 9, 2),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(SunriseRadius.chip),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color, weight: 700),
        const SizedBox(width: 3),
        Text(
          label.toUpperCase(),
          style: SunriseType.label.copyWith(
            color: color,
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
            letterSpacing: .7,
          ),
        ),
      ],
    ),
  );
}

/// "Amount  ৳100 → ৳120", the old value struck through.
class _ChangeRow extends StatelessWidget {
  const _ChangeRow({required this.label, required this.from, required this.to});

  final String label;
  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          SizedBox(
            width: 82,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: SunriseType.caption.copyWith(color: c.subtle),
            ),
          ),
          Flexible(
            child: Text(
              from.isEmpty ? '—' : from,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: SunriseType.label.copyWith(
                color: c.subtle,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              Symbols.arrow_forward_rounded,
              size: 14,
              color: c.accent,
            ),
          ),
          Flexible(
            child: Text(
              to,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: SunriseType.label.copyWith(
                color: c.ink,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Whether a card will be saved: a ring that fills with a tick.
class _Check extends StatelessWidget {
  const _Check({required this.on, required this.color});

  final bool on;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: on ? color : Colors.transparent,
        border: Border.all(color: on ? color : c.chevron, width: 2),
      ),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        scale: on ? 1 : 0,
        child: const Icon(
          Symbols.check_rounded,
          size: 16,
          color: Colors.white,
          weight: 700,
        ),
      ),
    );
  }
}

/// Brings its child in a moment after the one before it: rising, fading in,
/// settling from slightly small.
class _Stagger extends StatefulWidget {
  const _Stagger({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<_Stagger> createState() => _StaggerState();
}

class _StaggerState extends State<_Stagger>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 460),
  );
  Timer? _delay;

  @override
  void initState() {
    super.initState();
    _delay = Timer(
      Duration(milliseconds: 70 * widget.index.clamp(0, 10)),
      () => mounted ? _c.forward() : null,
    );
  }

  @override
  void dispose() {
    _delay?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final a = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    return FadeTransition(
      opacity: a,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, .18),
          end: Offset.zero,
        ).animate(a),
        child: ScaleTransition(
          scale: Tween(begin: .96, end: 1.0).animate(a),
          child: widget.child,
        ),
      ),
    );
  }
}

/// A light passing over its child, for "working it out".
class _Shimmer extends StatefulWidget {
  const _Shimmer({required this.child});

  final Widget child;

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) => ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (rect) => LinearGradient(
          colors: [c.ink, c.gradientMid, c.ink],
          stops: const [0, .5, 1],
          transform: _Slide(_c.value),
        ).createShader(rect),
        child: child,
      ),
      child: widget.child,
    );
  }
}

class _Slide extends GradientTransform {
  const _Slide(this.t);
  final double t;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * (t * 2 - 1), 0, 0);
}

/// The Today screen's button: a small glowing orb with a mic.
class VoiceLogButton extends StatefulWidget {
  const VoiceLogButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<VoiceLogButton> createState() => _VoiceLogButtonState();
}

class _VoiceLogButtonState extends State<VoiceLogButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final l10n = L10n.of(context);
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return Semantics(
      button: true,
      label: l10n.voiceButton,
      child: Tooltip(
        message: l10n.voiceButton,
        child: Pressable(
          onTap: () {
            HapticFeedback.mediumImpact();
            widget.onTap();
          },
          child: SizedBox.square(
            dimension: 48,
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (context, child) {
                final p = reduceMotion ? 0.0 : _pulse.value;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // A ring that breathes out, inviting a tap.
                    Container(
                      width: 44 + 10 * p,
                      height: 44 + 10 * p,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: c.gradientMid.withValues(alpha: .5 * (1 - p)),
                          width: 2,
                        ),
                      ),
                    ),
                    child!,
                  ],
                );
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: c.orbGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: c.glow.withValues(alpha: .55),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Symbols.mic_rounded,
                  color: Colors.white,
                  size: 22,
                  fill: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Opens the voice sheet and, once something is saved, says so with Undo.
Future<void> startVoiceLog(BuildContext context, WidgetRef ref) async {
  // Taken before the sheet opens: saving reloads the Today screen, and the
  // button this came from may be rebuilt by the time the sheet closes.
  final l10n = L10n.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final service = ref.read(voiceLogServiceProvider);
  final result = await showVoiceLogSheet(context);
  if (result == null || result.saved == 0) return;
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(l10n.voiceSaved(result.saved)),
      duration: const Duration(seconds: 6),
      action: SnackBarAction(
        label: l10n.voiceUndo,
        onPressed: () async {
          await service.undo(result);
          messenger.showSnackBar(SnackBar(content: Text(l10n.voiceUndone)));
        },
      ),
    ),
  );
}

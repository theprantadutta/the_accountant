import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/features/ai/screens/receipt_scanner_screen.dart';
import 'package:the_accountant/features/ai_assistant/models/chat_message.dart';
import 'package:the_accountant/features/ai_assistant/models/conversation.dart';
import 'package:the_accountant/features/ai_assistant/providers/ai_chat_provider.dart';
import 'package:the_accountant/features/ai_assistant/providers/ai_quota_provider.dart';
import 'package:the_accountant/features/ai_assistant/widgets/coach_action_card.dart';
import 'package:the_accountant/features/ai_assistant/widgets/coach_disclaimer.dart';
import 'package:the_accountant/features/settings/screens/contact_support_screen.dart';
import 'package:the_accountant/features/ads/reward_flow.dart';
import 'package:the_accountant/features/ads/rewarded_ads.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';
import 'package:the_accountant/features/dashboard/providers/financial_data_provider.dart';
import 'package:the_accountant/features/premium/utils/paywall_utils.dart';
import 'package:the_accountant/features/transactions/providers/upcoming_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// The coach is open to everyone now: Premium is unlimited, others spend a
/// small daily allowance that rewarded ads can extend. Kept as its own name so
/// the screens that open it need not change.
class AIAssistantScreenGated extends StatelessWidget {
  const AIAssistantScreenGated({super.key});

  @override
  Widget build(BuildContext context) => const AIAssistantScreen();
}

/// The money coach chat.
///
/// Patterns borrowed from the ai-persona app: a reversed list that stays
/// pinned to the newest message without scroll code, a one-shot reveal so only
/// a freshly arrived reply animates (rebuilds never replay old ones), three
/// staggered typing dots on one controller, starter prompts drawn from the
/// user's own data, a growing composer whose send button wakes up only for
/// real text, and long-press to copy. Replies stream in as they are written
/// and end with follow-up questions to tap. A failed reply offers Retry right
/// on the message, and Retry resends the same question.
class AIAssistantScreen extends ConsumerStatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  ConsumerState<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends ConsumerState<AIAssistantScreen>
    with SingleTickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  /// The list is built bottom-up, so offset 0 is the newest message.
  final _scroll = ScrollController();
  late final AnimationController _dots = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      final can = _textController.text.trim().isNotEmpty;
      if (can != _canSend) setState(() => _canSend = can);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(aiChatProvider.notifier).init();
      CoachDisclaimer.showIfNeeded(context);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _scroll.dispose();
    _dots.dispose();
    super.dispose();
  }

  Future<void> _send([String? preset]) async {
    final text = (preset ?? _textController.text).trim();
    if (text.isEmpty || ref.read(aiChatProvider).isLoading) return;
    HapticFeedback.lightImpact();
    if (preset == null) _textController.clear();
    // The answer needs the room the keyboard takes.
    _focusNode.unfocus();
    _toBottom();
    await ref.read(aiChatProvider.notifier).sendMessage(text);
  }

  /// Brings the newest message into view, after the frame that added it.
  void _toBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients || _scroll.offset == 0) return;
      _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _newChat() {
    HapticFeedback.lightImpact();
    ref.read(aiChatProvider.notifier).newChat();
  }

  /// Out of free requests: offer the ad (or Premium), then send the question
  /// that was waiting.
  Future<void> _offerMore() async {
    final earned = await earnWithAd(context, ref, RewardKind.aiCall);
    if (!mounted) return;
    if (earned) await ref.read(aiChatProvider.notifier).sendPending();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final chat = ref.watch(aiChatProvider);
    final quota = ref.watch(aiQuotaProvider);

    // A question that hit the daily limit: offer the ad straight away.
    // A new message, every new piece of a reply, a tool at work or a change
    // to confirm: whatever just appeared at the bottom is what to look at.
    ref.listen(
      aiChatProvider.select(
        (s) => (
          s.messages.length,
          s.messages.lastOrNull?.text.length,
          s.toolStatus,
          s.pendingAction,
        ),
      ),
      (was, now) => _toBottom(),
    );

    ref.listen(aiChatProvider.select((s) => s.pendingQuestion), (was, now) {
      if (now != null && was == null) _offerMore();
    });

    if (chat.isLoading) {
      if (!_dots.isAnimating) _dots.repeat();
    } else if (_dots.isAnimating) {
      _dots.stop();
    }

    final started = chat.messages.any((m) => m.isFromUser);
    final visible = chat.messages.where((m) => !m.isWelcome).toList();

    return SunrisePushPage(
      title: l10n.aiAssistantTitle,
      actions: [
        SunriseIconButton(
          icon: Symbols.flag_rounded,
          tooltip: l10n.aiReport,
          onTap: () => _report(chat),
        ),
        SunriseIconButton(
          icon: Symbols.forum_rounded,
          tooltip: l10n.aiChats,
          onTap: () => _showConversations(chat),
        ),
        SunriseIconButton(
          icon: Symbols.edit_square_rounded,
          tooltip: l10n.aiNewChat,
          onTap: _newChat,
        ),
      ],
      body: Column(
        children: [
          Expanded(
            child: chat.isLoadingHistory
                ? const SunriseLoader()
                : !started
                ? _Welcome(onStarter: _send)
                : _messageList(visible, chat),
          ),
          if (chat.pendingQuestion != null)
            _OutOfRequests(
              question: chat.pendingQuestion!,
              canWatchAd: quota.canEarnAiCall,
              onWatchAd: _offerMore,
              onPremium: () => PaywallUtils.showPaywall(context),
              onDismiss: () => ref.read(aiChatProvider.notifier).dropPending(),
            )
          else if (!quota.unlimited)
            _QuotaLine(quota: quota.remaining ?? 0),
          if (chat.hasError && !started)
            _ErrorBanner(
              message: chat.errorMessage,
              onRetry: () =>
                  ref.read(aiChatProvider.notifier).retryLastMessage(),
              onDismiss: () => ref.read(aiChatProvider.notifier).clearError(),
            ),
          _Composer(
            controller: _textController,
            focusNode: _focusNode,
            hint: l10n.aiAskAnything,
            enabled: _canSend && !chat.isLoading && !chat.isLoadingHistory,
            onSend: () => _send(),
            sendLabel: l10n.aiSend,
            background: c.tabBar,
          ),
        ],
      ),
    );
  }

  /// Report a wrong answer or a bug, with the conversation attached so it
  /// can be looked into without asking the user to describe it again.
  void _report(AiChatState chat) {
    final l10n = L10n.of(context);
    final lastAnswer = chat.messages.reversed
        .where((m) => !m.isFromUser && !m.isWelcome && m.text.isNotEmpty)
        .firstOrNull
        ?.text;
    final lastQuestion = chat.messages.reversed
        .where((m) => m.isFromUser)
        .firstOrNull
        ?.text;
    String clip(String text) =>
        text.length > 800 ? '${text.substring(0, 800)}…' : text;
    final details = [
      'Money coach',
      if (chat.currentConversationId != null)
        'Conversation: ${chat.currentConversationId}',
      if (lastQuestion != null) 'Last question: ${clip(lastQuestion)}',
      if (lastAnswer != null) 'Last answer: ${clip(lastAnswer)}',
    ].join('\n');

    void open(String subject) => Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            ContactSupportScreen(subject: subject, details: details),
      ),
    );

    showSunriseSheet<void>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        title: l10n.aiReport,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SheetAction(
              icon: Symbols.report_rounded,
              label: l10n.aiReportWrongAnswer,
              subtitle: l10n.aiReportWrongAnswerHint,
              onTap: () {
                Navigator.pop(sheet);
                open(l10n.aiReportWrongAnswerSubject);
              },
            ),
            SheetAction(
              icon: Symbols.bug_report_rounded,
              label: l10n.aiReportBug,
              subtitle: l10n.aiReportBugHint,
              onTap: () {
                Navigator.pop(sheet);
                open(l10n.aiReportBugSubject);
              },
            ),
            SheetAction(
              icon: Symbols.info_rounded,
              label: l10n.aiAboutCoach,
              onTap: () {
                Navigator.pop(sheet);
                CoachDisclaimer.show(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageList(List<ChatMessage> messages, AiChatState chat) {
    final reversed = messages.reversed.toList();
    final lastId = messages.isEmpty ? null : messages.last.id;

    return ListView.builder(
      controller: _scroll,
      reverse: true,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(
        SunriseSpace.screenX,
        12,
        SunriseSpace.screenX,
        12,
      ),
      itemCount: reversed.length,
      itemBuilder: (context, i) {
        final m = reversed[i];
        // Reversed, so the next item down the list is the older message.
        final older = i + 1 < reversed.length ? reversed[i + 1] : null;
        final newDay =
            older == null || !DateUtils.isSameDay(older.timestamp, m.timestamp);
        final isLast = m.id == lastId;

        return Column(
          key: ValueKey(m.id),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (newDay) _DayDivider(date: m.timestamp),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              // A reply that has not produced its first words yet: a change
              // waiting to be confirmed, a tool at work, or the coach thinking.
              child: m.isStreaming && m.text.isEmpty
                  ? (chat.pendingAction != null
                        ? CoachActionCard(
                            action: chat.pendingAction!,
                            onConfirm: () => ref
                                .read(aiChatProvider.notifier)
                                .decideAction(true),
                            onCancel: () => ref
                                .read(aiChatProvider.notifier)
                                .decideAction(false),
                          )
                        : chat.toolStatus != null
                        ? CoachToolStatus(tool: chat.toolStatus!)
                        : _TypingDots(animation: _dots))
                  : _MessageBubble(
                      message: m,
                      showRetry: m.isAiFallback && isLast && !chat.isLoading,
                      onRetry: () =>
                          ref.read(aiChatProvider.notifier).retryLastMessage(),
                    ),
            ),
            if (isLast && !chat.isLoading && m.followUps.isNotEmpty)
              _FollowUps(questions: m.followUps, onTap: _send),
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------ chats sheet

  String _relativeTime(DateTime dt, L10n l10n) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return l10n.aiJustNow;
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return DateFormat(
      'MMM d',
      Localizations.localeOf(context).toString(),
    ).format(dt);
  }

  void _showConversations(AiChatState chat) {
    final l10n = L10n.of(context);
    showSunriseSheet<void>(
      context: context,
      builder: (sheet) => Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(aiChatProvider);
          final c = context.sunrise;
          return SunriseBottomSheet(
            title: l10n.aiChats,
            actions: [
              SunriseButton(
                label: l10n.aiNewChat,
                icon: Symbols.edit_square_rounded,
                height: 52,
                onPressed: () {
                  Navigator.pop(sheet);
                  _newChat();
                },
              ),
            ],
            child: state.conversations.isEmpty
                ? EmptyState(
                    compact: true,
                    icon: Symbols.forum_rounded,
                    title: l10n.aiNoConversationsYet,
                    message: l10n.aiStartChattingAndYourThreads,
                  )
                : Column(
                    children: [
                      for (final conv in state.conversations)
                        _ConversationRow(
                          conversation: conv,
                          selected: conv.id == state.currentConversationId,
                          when: _relativeTime(conv.lastMessageAt, l10n),
                          color: c.accent,
                          onTap: () {
                            Navigator.pop(sheet);
                            ref
                                .read(aiChatProvider.notifier)
                                .selectConversation(conv.id);
                          },
                          onRename: () => _rename(conv),
                          onDelete: () => _delete(conv),
                        ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Future<void> _rename(Conversation conv) async {
    final l10n = L10n.of(context);
    final controller = TextEditingController(text: conv.title);
    final newTitle = await showSunriseDialog<String>(
      context: context,
      builder: (ctx) => SunriseDialog(
        title: l10n.aiRenameChat,
        content: SunriseTextField(
          controller: controller,
          hint: l10n.aiChatName,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          SunriseButton(
            label: l10n.actionSave,
            height: 52,
            onPressed: () => Navigator.pop(ctx, controller.text),
          ),
          SunriseButton.secondary(
            label: l10n.actionCancel,
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
    controller.dispose();
    final trimmed = newTitle?.trim() ?? '';
    if (trimmed.isNotEmpty && trimmed != conv.title) {
      await ref
          .read(aiChatProvider.notifier)
          .renameConversation(conv.id, trimmed);
    }
  }

  Future<void> _delete(Conversation conv) async {
    final l10n = L10n.of(context);
    final ok = await showSunriseConfirm(
      context: context,
      title: l10n.aiDeleteChat,
      message: l10n.aiDeleteChatBody(conv.title),
      confirmLabel: l10n.actionDelete,
      destructive: true,
      icon: Symbols.delete_rounded,
    );
    if (ok) await ref.read(aiChatProvider.notifier).deleteConversation(conv.id);
  }
}

/// Before the first question: the orb, the pitch, starter prompts and the
/// receipt scanner.
class _Welcome extends ConsumerWidget {
  const _Welcome({required this.onStarter});

  final ValueChanged<String> onStarter;

  /// Up to three prompts drawn from the user's own data, then fixed ones. No
  /// model call is spent on suggestions.
  List<String> _starters(WidgetRef ref, L10n l10n) {
    final out = <String>[];
    final spending = ref.watch(categorySpendingProvider);
    if (spending.isNotEmpty) {
      final top = spending.entries.reduce((a, b) => a.value >= b.value ? a : b);
      out.add(l10n.aiStarterCategory(top.key));
    }
    if (ref.watch(budgetProvider).budgets.isNotEmpty) {
      out.add(l10n.aiStarterBudgets);
    }
    final upcoming = ref.watch(upcomingProvider);
    if (upcoming.upcomingTransactions.isNotEmpty ||
        upcoming.overdueTransactions.isNotEmpty) {
      out.add(l10n.aiStarterUpcoming);
    }
    for (final s in [
      l10n.aiStarterAnalyze,
      l10n.aiStarterBudgetTips,
      l10n.aiStarterSave,
    ]) {
      if (out.length >= 3) break;
      out.add(s);
    }
    return out.take(3).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final starters = _starters(ref, l10n);

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(
        SunriseSpace.screenX,
        8,
        SunriseSpace.screenX,
        16,
      ),
      children: [
        Center(
          child: Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: c.orbGradient,
              boxShadow: [
                BoxShadow(
                  color: c.gradientMid.withValues(alpha: .10),
                  spreadRadius: 14,
                ),
                BoxShadow(
                  color: c.gradientMid.withValues(alpha: .05),
                  spreadRadius: 30,
                ),
              ],
            ),
            child: Icon(
              Symbols.auto_awesome_rounded,
              size: 46,
              color: c.onFill,
              fill: 1,
            ),
          ),
        ),
        const SizedBox(height: 34),
        Text(
          l10n.aiCoachTitle,
          textAlign: TextAlign.center,
          style: SunriseType.heroTitle.copyWith(color: c.ink),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.aiCoachBody,
          textAlign: TextAlign.center,
          style: SunriseType.body.copyWith(color: c.muted),
        ),
        const SizedBox(height: 22),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 10,
          children: [
            for (var i = 0; i < starters.length; i++)
              SunriseChip(
                label: starters[i],
                selected: i == 0,
                outlined: i != 0,
                onTap: () => onStarter(starters[i]),
              ),
          ],
        ),
        const SizedBox(height: 22),
        SettingsGroup(
          children: [
            SettingsRow(
              icon: Symbols.document_scanner_rounded,
              iconColor: c.accent,
              iconBackground: c.tintOrange,
              title: l10n.aiScanAReceipt,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ReceiptScannerScreenGated(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// A chat bubble: ink for the user (18 18 4 18), surface for the coach
/// (18 18 18 4).
class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.fromUser,
    required this.child,
    this.error = false,
  });

  final bool fromUser;
  final bool error;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    const r = Radius.circular(18);
    const tail = Radius.circular(4);
    final maxWidth = MediaQuery.sizeOf(context).width * (fromUser ? .78 : .86);
    return Align(
      alignment: fromUser
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth.clamp(0, 520)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: fromUser ? c.chipActiveBg : (error ? c.tintRose : c.surface),
            borderRadius: BorderRadiusDirectional.only(
              topStart: r,
              topEnd: r,
              bottomStart: fromUser ? r : tail,
              bottomEnd: fromUser ? tail : r,
            ),
            boxShadow: fromUser ? null : c.cardShadow,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _BubbleText extends StatelessWidget {
  const _BubbleText(this.text, {required this.fromUser});

  final String text;
  final bool fromUser;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    if (fromUser) {
      return Text(
        text,
        style: SunriseType.body.copyWith(color: c.chipActiveFg, height: 1.4),
      );
    }
    final base = SunriseType.body.copyWith(color: c.ink, height: 1.45);
    return MarkdownBody(
      data: text,
      softLineBreak: true,
      styleSheet: MarkdownStyleSheet(
        p: base,
        strong: base.copyWith(fontWeight: FontWeight.w600),
        em: base.copyWith(fontStyle: FontStyle.italic),
        listBullet: base,
        h1: SunriseType.section.copyWith(color: c.ink),
        h2: SunriseType.section.copyWith(color: c.ink, fontSize: 17),
        h3: SunriseType.rowTitle.copyWith(color: c.ink),
        code: base.copyWith(
          fontSize: 13,
          backgroundColor: c.tintPeach,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        codeblockDecoration: BoxDecoration(
          color: c.tintPeach,
          borderRadius: BorderRadius.circular(10),
        ),
        blockquoteDecoration: BoxDecoration(
          border: BorderDirectional(
            start: BorderSide(color: c.accent, width: 3),
          ),
        ),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(top: BorderSide(color: c.divider)),
        ),
        a: base.copyWith(color: c.accentText),
      ),
    );
  }
}

/// One message, with long-press to copy and Retry on a failed reply.
class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.showRetry,
    required this.onRetry,
  });

  final ChatMessage message;
  final bool showRetry;
  final VoidCallback onRetry;

  void _actions(BuildContext context) {
    final l10n = L10n.of(context);
    showSunriseSheet<void>(
      context: context,
      builder: (sheet) => SunriseBottomSheet(
        child: SheetAction(
          icon: Symbols.content_copy_rounded,
          label: l10n.aiCopy,
          onTap: () {
            Clipboard.setData(ClipboardData(text: message.text));
            Navigator.pop(sheet);
            showSunriseSnack(context, l10n.aiCopied, tone: SnackTone.success);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final fromUser = message.isFromUser;
    final text = _BubbleText(
      message.isStreaming ? _balanced(message.text) : message.text,
      fromUser: fromUser,
    );

    return Column(
      crossAxisAlignment: fromUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onLongPress: message.isStreaming
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  _actions(context);
                },
          child: _Bubble(
            fromUser: fromUser,
            error: message.isAiFallback,
            child: text,
          ),
        ),
        if (showRetry) ...[
          const SizedBox(height: 8),
          SunriseChip(
            label: l10n.aiRetry,
            icon: Symbols.refresh_rounded,
            selected: true,
            onTap: onRetry,
          ),
        ] else if (!fromUser && message.isAiFallback)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 6, top: 4),
            child: Text(
              l10n.aiErrorTitle,
              style: SunriseType.caption.copyWith(color: c.negative),
            ),
          ),
      ],
    );
  }
}

/// Closes any bold or italic marker a half-written reply left open, so a
/// streaming answer never shows raw asterisks.
String _balanced(String partial) {
  var out = partial;
  if ('**'.allMatches(out).length.isOdd) out = '$out**';
  final singles = out.replaceAll('**', '');
  if ('*'.allMatches(singles).length.isOdd) out = '$out*';
  return out;
}

/// Three dots fading in turn, all driven by one controller.
class _TypingDots extends StatelessWidget {
  const _TypingDots({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Semantics(
      label: L10n.of(context).aiTyping,
      child: _Bubble(
        fromUser: false,
        child: SizedBox(
          width: 44,
          height: 18,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < 3; i++)
                FadeTransition(
                  opacity: Tween(begin: .25, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Interval(
                        i * .2,
                        .6 + i * .2,
                        curve: Curves.easeInOut,
                      ),
                    ),
                  ),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: c.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayDivider extends StatelessWidget {
  const _DayDivider({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final label = DateUtils.isSameDay(date, DateTime.now())
        ? L10n.of(context).activityToday
        : DateFormat(
            'EEE d MMM',
            Localizations.localeOf(context).toString(),
          ).format(date);
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 2),
      child: Center(
        child: Text(
          label,
          style: SunriseType.caption.copyWith(color: c.subtle),
        ),
      ),
    );
  }
}

/// The frosted pill composer with the gradient send button.
class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.enabled,
    required this.onSend,
    required this.sendLabel,
    required this.background,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final bool enabled;
  final VoidCallback onSend;
  final String sendLabel;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        SunriseSpace.screenX - 4,
        6,
        SunriseSpace.screenX - 4,
        (bottom > 0 ? bottom : 12) + 4,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: c.cardShadow,
        ),
        child: SunriseGlass(
          color: background,
          radius: BorderRadius.circular(28),
          border: Border.all(color: c.tabBarBorder),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 6, 6, 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 44,
                      maxHeight: 132,
                    ),
                    child: Align(
                      heightFactor: 1,
                      alignment: AlignmentDirectional.centerStart,
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) {
                          if (enabled) onSend();
                        },
                        style: SunriseType.body.copyWith(color: c.ink),
                        decoration: InputDecoration(
                          hintText: hint,
                          filled: false,
                          isDense: true,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Semantics(
                  button: true,
                  enabled: enabled,
                  label: sendLabel,
                  child: Pressable(
                    onTap: enabled ? onSend : null,
                    child: AnimatedContainer(
                      duration: SunriseMotion.press,
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: enabled ? c.gradient : null,
                        color: enabled ? null : c.toggleOff,
                        boxShadow: enabled ? c.selectedShadow : null,
                      ),
                      child: Icon(
                        Symbols.arrow_upward_rounded,
                        color: enabled ? c.onFill : c.faint,
                        weight: 600,
                      ),
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
}

/// A failure before the conversation started (loading history, say).
class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({
    required this.message,
    required this.onRetry,
    required this.onDismiss,
  });

  final String? message;
  final VoidCallback onRetry;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SunriseSpace.screenX),
      child: SunriseCard(
        color: c.tintRose,
        shadow: false,
        padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
        child: Row(
          children: [
            Icon(Symbols.cloud_off_rounded, color: c.negative, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message ?? l10n.aiErrorTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: SunriseType.label.copyWith(color: c.ink),
              ),
            ),
            TextButton(onPressed: onRetry, child: Text(l10n.aiRetry)),
            IconButton(
              tooltip: l10n.aiDismiss,
              onPressed: onDismiss,
              icon: Icon(Symbols.close_rounded, color: c.subtle, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationRow extends StatelessWidget {
  const _ConversationRow({
    required this.conversation,
    required this.selected,
    required this.when,
    required this.color,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
  });

  final Conversation conversation;
  final bool selected;
  final String when;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            IconTile(
              icon: Symbols.chat_bubble_rounded,
              color: color,
              background: selected ? c.tintPeach : c.tintOrange,
              fill: selected ? 1 : 0,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: SunriseType.rowTitle.copyWith(
                      color: c.ink,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  Text(
                    when,
                    style: SunriseType.caption.copyWith(color: c.subtle),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(Symbols.more_vert_rounded, color: c.chevron),
              onSelected: (v) => v == 'rename' ? onRename() : onDelete(),
              itemBuilder: (_) => [
                PopupMenuItem(value: 'rename', child: Text(l10n.aiRename)),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    l10n.actionDelete,
                    style: TextStyle(color: c.negative),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// The coach's suggested next questions, as chips under its latest reply.
class _FollowUps extends StatelessWidget {
  const _FollowUps({required this.questions, required this.onTap});

  final List<String> questions;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final q in questions)
          SunriseChip(
            label: q,
            selected: false,
            icon: Symbols.subdirectory_arrow_right_rounded,
            onTap: () => onTap(q),
          ),
      ],
    ),
  );
}

/// "2 free AI requests left today" above the composer, for free users.
class _QuotaLine extends StatelessWidget {
  const _QuotaLine({required this.quota});

  final int quota;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        SunriseSpace.screenX,
        4,
        SunriseSpace.screenX,
        2,
      ),
      child: Row(
        children: [
          Icon(Symbols.bolt_rounded, size: 16, color: c.accent, fill: 1),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              l10n.aiQuotaLeft(quota),
              style: SunriseType.caption.copyWith(color: c.muted),
            ),
          ),
          GestureDetector(
            onTap: () => PaywallUtils.showPaywall(context),
            child: Text(
              l10n.aiQuotaPremiumUnlimited,
              style: SunriseType.caption.copyWith(
                color: c.accentText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown when a question hit the daily limit: what happened, the ad, and
/// Premium as the no-ads way out.
class _OutOfRequests extends StatelessWidget {
  const _OutOfRequests({
    required this.question,
    required this.canWatchAd,
    required this.onWatchAd,
    required this.onPremium,
    required this.onDismiss,
  });

  final String question;
  final bool canWatchAd;
  final VoidCallback onWatchAd;
  final VoidCallback onPremium;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        SunriseSpace.screenX,
        6,
        SunriseSpace.screenX,
        6,
      ),
      child: SunriseCard(
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Symbols.hourglass_bottom_rounded,
                  color: c.accent,
                  fill: 1,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.aiOutOfRequestsTitle,
                    style: SunriseType.rowTitle.copyWith(color: c.ink),
                  ),
                ),
                SunriseIconButton(
                  icon: Symbols.close_rounded,
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  size: 32,
                  iconSize: 18,
                  background: Colors.transparent,
                  onTap: onDismiss,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                canWatchAd
                    ? l10n.aiOutOfRequestsBody
                    : l10n.adMonthlyCapReached,
                style: SunriseType.caption.copyWith(color: c.muted),
              ),
            ),
            const SizedBox(height: 10),
            // Stacked, so each label has the full width on a narrow phone
            // and in longer languages. Premium leads: it is the real answer
            // to running out, and an ad is the stopgap.
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SunriseButton(
                    label: l10n.adGetPremium,
                    icon: Symbols.workspace_premium_rounded,
                    height: 46,
                    onPressed: onPremium,
                  ),
                  if (canWatchAd) ...[
                    const SizedBox(height: 8),
                    SunriseButton(
                      label: l10n.adWatch,
                      icon: Symbols.play_circle_rounded,
                      style: SunriseButtonStyle.secondary,
                      height: 46,
                      onPressed: onWatchAd,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

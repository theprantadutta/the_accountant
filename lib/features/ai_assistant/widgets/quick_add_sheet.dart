import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/features/ads/reward_flow.dart';
import 'package:the_accountant/features/ads/rewarded_ads.dart';
import 'package:the_accountant/features/ai_assistant/providers/ai_quota_provider.dart';
import 'package:the_accountant/features/ai_assistant/services/ai_api.dart';
import 'package:the_accountant/features/ai_assistant/services/finance_context_builder.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// "Describe it" for the add screen: the user writes a line like
/// "lunch 250 yesterday from bKash" and the AI turns it into a draft
/// (title, amount, type, date, category, account) for them to check.
///
/// One AI request. With none left it offers an ad first, and says Premium
/// has no limit.
Future<QuickAddDraft?> showQuickAddSheet(BuildContext context) =>
    showSunriseSheet<QuickAddDraft>(
      context: context,
      builder: (_) => const _QuickAddSheet(),
    );

class _QuickAddSheet extends ConsumerStatefulWidget {
  const _QuickAddSheet();

  @override
  ConsumerState<_QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends ConsumerState<_QuickAddSheet> {
  final _text = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _fill() async {
    final text = _text.text.trim();
    if (text.isEmpty || _busy) return;

    if (!ref.read(aiQuotaProvider).hasCallsLeft) {
      final earned = await earnWithAd(context, ref, RewardKind.aiCall);
      if (!earned || !mounted) return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final categories = ref
          .read(categoryProvider)
          .selectable
          .map((c) => c.name)
          .toList();
      final wallets = ref
          .read(selectableWalletsProvider)
          .map((w) => w.name)
          .toList();
      final draft = await ref
          .read(aiApiProvider)
          .quickAdd(
            text: text,
            categories: categories,
            wallets: wallets,
            currency: ref.read(defaultCurrencyProvider),
            language: FinanceContextBuilder.languageOf(ref.read),
          );
      if (mounted) Navigator.pop(context, draft);
    } on AiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
      ref.read(aiQuotaProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final quota = ref.watch(aiQuotaProvider);

    return SunriseBottomSheet(
      title: l10n.quickAddTitle,
      subtitle: l10n.quickAddSubtitle,
      actions: [
        SunriseButton(
          label: l10n.quickAddFill,
          icon: Symbols.auto_awesome_rounded,
          loading: _busy,
          onPressed: _busy ? null : _fill,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SunriseTextField(
            controller: _text,
            hint: l10n.quickAddHint,
            icon: Symbols.edit_note_rounded,
            autofocus: true,
            maxLines: 3,
            minLines: 1,
            maxLength: 300,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _fill(),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: SunriseType.caption.copyWith(color: c.negative),
            ),
          ],
          if (!quota.unlimited) ...[
            const SizedBox(height: 8),
            Text(
              (quota.remaining ?? 0) > 0
                  ? l10n.aiQuotaLeft(quota.remaining ?? 0)
                  : l10n.aiOutOfRequestsTitle,
              style: SunriseType.caption.copyWith(color: c.muted),
            ),
          ],
        ],
      ),
    );
  }
}

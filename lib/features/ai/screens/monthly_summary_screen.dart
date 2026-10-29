import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/features/ads/reward_flow.dart';
import 'package:the_accountant/features/ads/rewarded_ads.dart';
import 'package:the_accountant/features/ai_assistant/providers/ai_quota_provider.dart';
import 'package:the_accountant/features/ai_assistant/services/ai_api.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/ai/services/monthly_review_cache.dart';
import 'package:the_accountant/features/ai_assistant/services/finance_context_builder.dart';
import 'package:the_accountant/features/premium/utils/paywall_utils.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sensitive.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Kept under its old name for the screen that opens it. The numbers are free
/// for everyone; the AI write-up spends one request (Premium: unlimited).
class MonthlySummaryScreenGated extends StatelessWidget {
  final DateTime month;

  const MonthlySummaryScreenGated({super.key, required this.month});

  @override
  Widget build(BuildContext context) => MonthlySummaryScreen(month: month);
}

/// This month against last month: the totals and the categories that moved,
/// worked out on the device, and a short AI review of what stood out.
///
/// The old screen called a string template "AI insights", labelled categories
/// by their raw ids and printed every amount in dollars. The figures now come
/// from the same snapshot the coach sees, in the user's own currency.
class MonthlySummaryScreen extends ConsumerStatefulWidget {
  final DateTime month;

  const MonthlySummaryScreen({super.key, required this.month});

  @override
  ConsumerState<MonthlySummaryScreen> createState() =>
      _MonthlySummaryScreenState();
}

class _MonthlySummaryScreenState extends ConsumerState<MonthlySummaryScreen> {
  Map<String, dynamic>? _snapshot;
  String? _review;

  /// The saved review was written before the transactions last changed.
  bool _outdated = false;

  /// What the transactions look like now, to tell whether a saved review is
  /// still current and to save a new one against.
  String? _fingerprint;
  bool _writing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final snapshot = await FinanceContextBuilder(ref.read).build();
    if (!mounted) return;
    // The review is written only when asked for. Writing it on every visit,
    // as it did for Premium, spent an AI call each time the screen was opened
    // just to look at the totals. One already written is shown again, and
    // offered for updating only once the transactions have changed.
    final fp = await MonthlyReviewCache.fingerprint(
      ref.read(databaseProvider),
      month: widget.month,
      language: snapshot['language'] as String? ?? '',
      currency: snapshot['currency'] as String? ?? '',
    );
    final saved = await MonthlyReviewCache.read(widget.month, fp);
    if (!mounted) return;
    setState(() {
      _snapshot = snapshot;
      _fingerprint = fp;
      _review = saved?.text;
      _outdated = saved != null && !saved.upToDate;
    });
  }

  Future<void> _write() async {
    final snapshot = _snapshot;
    if (snapshot == null || _writing) return;

    if (!ref.read(aiQuotaProvider).hasCallsLeft) {
      final earned = await earnWithAd(context, ref, RewardKind.aiCall);
      if (!earned || !mounted) return;
    }

    setState(() {
      _writing = true;
      _error = null;
    });
    try {
      final text = await ref.read(aiApiProvider).monthlySummary(snapshot);
      if (_fingerprint != null) {
        await MonthlyReviewCache.save(widget.month, _fingerprint!, text);
      }
      if (mounted) {
        setState(() {
          _review = text;
          _outdated = false;
        });
      }
    } on AiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _writing = false);
      ref.read(aiQuotaProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final snapshot = _snapshot;
    final locale = Localizations.localeOf(context).toString();

    return SunrisePushPage(
      title: DateFormat.yMMMM(locale).format(widget.month),
      subtitle: l10n.summaryTitle,
      onRefresh: _load,
      children: snapshot == null
          ? const [SizedBox(height: 120), Center(child: SunriseLoader())]
          : [
              _Totals(snapshot: snapshot),
              const SizedBox(height: SunriseSpace.section),
              _ReviewCard(
                review: _review,
                outdated: _outdated,
                writing: _writing,
                error: _error,
                onWrite: _write,
              ),
              const SizedBox(height: SunriseSpace.section),
              _Categories(snapshot: snapshot),
            ],
    );
  }
}

String _money(num value, String currency) =>
    ((value * 100).round()).formatCurrency(currency, useDecimals: true);

class _Totals extends StatelessWidget {
  const _Totals({required this.snapshot});

  final Map<String, dynamic> snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final currency = snapshot['currency'] as String;
    final now = snapshot['this_month'] as Map<String, dynamic>;
    final last = snapshot['last_month'] as Map<String, dynamic>;
    final income = (now['income'] as num).toDouble();
    final spent = (now['expense'] as num).toDouble();
    final lastSpent = (last['expense'] as num).toDouble();
    final change = lastSpent <= 0
        ? null
        : (spent - lastSpent) / lastSpent * 100;

    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.summarySpent.toUpperCase(),
            style: SunriseType.overline.copyWith(
              color: c.onFill.withValues(alpha: .8),
            ),
          ),
          const SizedBox(height: 4),
          Sensitive(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                _money(spent, currency),
                style: SunriseType.amountHero.copyWith(color: c.onFill),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Sensitive(
                child: SunrisePill(
                  icon: Symbols.south_west_rounded,
                  label: l10n.summaryEarned(_money(income, currency)),
                  color: c.onFill,
                  background: c.onFill.withValues(alpha: .22),
                ),
              ),
              if (change != null)
                SunrisePill(
                  icon: change <= 0
                      ? Symbols.trending_down_rounded
                      : Symbols.trending_up_rounded,
                  label: change <= 0
                      ? l10n.summaryLessThanLast(change.abs().round())
                      : l10n.summaryMoreThanLast(change.round()),
                  color: c.onFill,
                  background: c.onFill.withValues(alpha: .22),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends ConsumerWidget {
  const _ReviewCard({
    required this.review,
    required this.outdated,
    required this.writing,
    required this.error,
    required this.onWrite,
  });

  final String? review;
  final bool outdated;
  final bool writing;
  final String? error;
  final VoidCallback onWrite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final quota = ref.watch(aiQuotaProvider);
    final base = SunriseType.body.copyWith(color: c.ink, height: 1.45);

    return SunriseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconTile(
                icon: Symbols.auto_awesome_rounded,
                color: c.onFill,
                gradient: c.gradient,
                size: 36,
                fill: 1,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.summaryAiTitle,
                  style: SunriseType.rowTitle.copyWith(color: c.ink),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (writing)
            Row(
              children: [
                const SizedBox(width: 20, height: 20, child: SunriseLoader()),
                const SizedBox(width: 12),
                Text(
                  l10n.summaryWriting,
                  style: SunriseType.body.copyWith(color: c.muted),
                ),
              ],
            )
          else if (review != null) ...[
            Opacity(
              opacity: outdated ? .6 : 1,
              child: MarkdownBody(
                data: review!,
                styleSheet: MarkdownStyleSheet(
                  p: base,
                  strong: base.copyWith(fontWeight: FontWeight.w600),
                  listBullet: base,
                ),
              ),
            ),
            // Nothing to write again until the transactions change.
            if (outdated) ...[
              const SizedBox(height: 12),
              Text(
                l10n.summaryOutdated,
                style: SunriseType.caption.copyWith(color: c.muted),
              ),
              const SizedBox(height: 8),
              SunriseButton.secondary(
                key: const Key('summary_update'),
                label: quota.hasCallsLeft ? l10n.summaryUpdate : l10n.adWatch,
                icon: quota.hasCallsLeft
                    ? Symbols.refresh_rounded
                    : Symbols.play_circle_rounded,
                height: 44,
                onPressed: onWrite,
              ),
            ],
          ] else ...[
            Text(
              error ?? l10n.summaryAiBody,
              style: SunriseType.body.copyWith(
                color: error == null ? c.muted : c.negative,
              ),
            ),
            const SizedBox(height: 12),
            SunriseButton(
              label: quota.hasCallsLeft ? l10n.summaryWrite : l10n.adWatch,
              icon: quota.hasCallsLeft
                  ? Symbols.auto_awesome_rounded
                  : Symbols.play_circle_rounded,
              height: 48,
              onPressed: onWrite,
            ),
            if (!quota.unlimited) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => PaywallUtils.showPaywall(context),
                child: Text(
                  '${quota.hasCallsLeft ? l10n.aiQuotaLeft(quota.remaining ?? 0) : l10n.aiOutOfRequestsTitle} · ${l10n.aiQuotaPremiumUnlimited}',
                  style: SunriseType.caption.copyWith(color: c.muted),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _Categories extends StatelessWidget {
  const _Categories({required this.snapshot});

  final Map<String, dynamic> snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final currency = snapshot['currency'] as String;
    final categories = (snapshot['top_categories'] as List)
        .cast<Map<String, dynamic>>();

    if (categories.isEmpty) {
      return EmptyState(
        compact: true,
        icon: Symbols.category_rounded,
        title: l10n.summaryNoSpending,
      );
    }

    final top = (categories.first['amount'] as num).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(l10n.summaryByCategory),
        SunriseCard(
          child: Column(
            children: [
              for (final cat in categories)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: _CategoryRow(
                    name: cat['name'] as String,
                    amount: (cat['amount'] as num).toDouble(),
                    lastMonth: (cat['last_month'] as num?)?.toDouble() ?? 0,
                    share: top <= 0 ? 0 : (cat['amount'] as num) / top,
                    currency: currency,
                    accent: c.accent,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.name,
    required this.amount,
    required this.lastMonth,
    required this.share,
    required this.currency,
    required this.accent,
  });

  final String name;
  final double amount;
  final double lastMonth;
  final double share;
  final String currency;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final diff = lastMonth <= 0 ? null : amount - lastMonth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: SunriseType.rowTitle.copyWith(color: c.ink),
              ),
            ),
            Sensitive(
              child: Text(
                _money(amount, currency),
                style: SunriseType.amount.copyWith(color: c.ink),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: share.clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: c.toggleOff,
            color: accent,
          ),
        ),
        if (diff != null) ...[
          const SizedBox(height: 4),
          Sensitive(
            child: Text(
              '${diff <= 0 ? '−' : '+'}${_money(diff.abs(), currency)} · ${_money(lastMonth, currency)}',
              style: SunriseType.caption.copyWith(
                color: diff <= 0 ? c.positive : c.negative,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

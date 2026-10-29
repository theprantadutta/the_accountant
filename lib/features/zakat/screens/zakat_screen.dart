import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:the_accountant/features/investments/screens/investment_trade_screen.dart'
    show askAmount;
import 'package:the_accountant/features/plans/widgets/plan_labels.dart';
import 'package:the_accountant/features/zakat/domain/zakat_settings.dart';
import 'package:the_accountant/features/zakat/providers/zakat_provider.dart';
import 'package:the_accountant/features/zakat/screens/zakat_pay_screen.dart';
import 'package:the_accountant/features/zakat/services/zakat_service.dart';
import 'package:the_accountant/features/zakat/widgets/zakat_labels.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// What zakat is due on the user's wealth, what has been paid toward it, and
/// every figure the answer is made of.
///
/// Not everybody pays zakat, so the screen asks. Somebody who says they do
/// not gets a quiet page instead of an amount "due", and no reminders; the
/// calculator is one tap away for a look, without changing their answer.
class ZakatScreen extends ConsumerStatefulWidget {
  const ZakatScreen({super.key});

  @override
  ConsumerState<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends ConsumerState<ZakatScreen> {
  /// Looking at the figures while having said they do not pay zakat.
  bool _peeking = false;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final report = ref.watch(zakatReportProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.zakatTitle)),
      body: CappedBody(
        child: report.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (r) {
            final s = r.settings;
            if (s.optedOut && !_peeking) {
              return _NotPaying(onPeek: () => setState(() => _peeking = true));
            }
            final peek = s.optedOut;
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                SunriseSpace.screenX,
                8,
                SunriseSpace.screenX,
                40,
              ),
              children: [
                if (s.paysZakat == null) ...[
                  const _AskCard(),
                  const SizedBox(height: 20),
                ],
                if (peek) ...[
                  _PeekBanner(onDone: () => setState(() => _peeking = false)),
                  const SizedBox(height: 16),
                ],
                _DueCard(report: r, canPay: !peek),
                const SizedBox(height: 20),
                _NisabSection(report: r),
                const SizedBox(height: 20),
                _LinesSection(report: r),
                const SizedBox(height: 20),
                _TotalsCard(report: r),
                // Reminders are for people who pay it.
                if (!peek) ...[
                  const SizedBox(height: 20),
                  _YearSection(settings: s),
                ],
                const SizedBox(height: 16),
                Text(
                  l10n.zakatDisclaimer,
                  style: SunriseType.caption.copyWith(
                    color: context.sunrise.subtle,
                  ),
                ),
                if (s.paysZakat == true) ...[
                  const SizedBox(height: 20),
                  Center(
                    child: SunriseButton(
                      key: const Key('zakat_opt_out'),
                      label: l10n.zakatIDontPay,
                      style: SunriseButtonStyle.ghost,
                      expand: false,
                      height: 44,
                      onPressed: () => _optOut(context, ref),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

Future<void> _optOut(BuildContext context, WidgetRef ref) async {
  final l10n = L10n.of(context);
  final ok = await showSunriseConfirm(
    context: context,
    title: l10n.zakatOptOutTitle,
    message: l10n.zakatOptOutBody,
    confirmLabel: l10n.zakatIDontPay,
    icon: Symbols.volunteer_activism_rounded,
  );
  if (ok) await _change(ref, (s) => s.copyWith(paysZakat: false));
}

/// Asked once, at the top, until answered.
class _AskCard extends ConsumerWidget {
  const _AskCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return SunriseCard(
      key: const Key('zakat_ask'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.zakatAskTitle,
            style: SunriseType.section.copyWith(color: c.ink, fontSize: 18),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.zakatAskBody,
            style: SunriseType.body.copyWith(color: c.muted, height: 1.4),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SunriseButton(
                  key: const Key('zakat_i_pay'),
                  label: l10n.zakatIPay,
                  height: 48,
                  onPressed: () =>
                      _change(ref, (s) => s.copyWith(paysZakat: true)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SunriseButton.secondary(
                  key: const Key('zakat_i_dont_pay'),
                  label: l10n.zakatIDontPay,
                  height: 48,
                  onPressed: () =>
                      _change(ref, (s) => s.copyWith(paysZakat: false)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// What somebody who does not pay zakat sees: no amount due, and the way to
/// look anyway.
class _NotPaying extends ConsumerWidget {
  const _NotPaying({required this.onPeek});

  final VoidCallback onPeek;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return ListView(
      key: const Key('zakat_not_paying'),
      padding: const EdgeInsets.fromLTRB(
        SunriseSpace.screenX,
        40,
        SunriseSpace.screenX,
        40,
      ),
      children: [
        Center(
          child: IconTile(
            icon: Symbols.volunteer_activism_rounded,
            color: c.positive,
            background: c.tintGreen,
            size: 72,
            radius: 24,
            iconSize: 36,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.zakatOffTitle,
          textAlign: TextAlign.center,
          style: SunriseType.section.copyWith(color: c.ink, fontSize: 22),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.zakatOffBody,
          textAlign: TextAlign.center,
          style: SunriseType.body.copyWith(color: c.muted, height: 1.45),
        ),
        const SizedBox(height: 28),
        SunriseButton(
          key: const Key('zakat_peek'),
          label: l10n.zakatOffPeek,
          icon: Symbols.calculate_rounded,
          onPressed: onPeek,
        ),
        const SizedBox(height: 10),
        SunriseButton.secondary(
          key: const Key('zakat_opt_in'),
          label: l10n.zakatIPay,
          onPressed: () => _change(ref, (s) => s.copyWith(paysZakat: true)),
        ),
      ],
    );
  }
}

/// Over the figures while just looking, so nobody mistakes them for a bill.
class _PeekBanner extends ConsumerWidget {
  const _PeekBanner({required this.onDone});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return Container(
      key: const Key('zakat_peek_banner'),
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        color: c.tintGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Symbols.visibility_rounded, color: c.positive, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.zakatPeekBanner,
              style: SunriseType.label.copyWith(color: c.ink, height: 1.35),
            ),
          ),
          TextButton(
            onPressed: () async {
              await _change(ref, (s) => s.copyWith(paysZakat: true));
              onDone();
            },
            child: Text(l10n.zakatIPay),
          ),
        ],
      ),
    );
  }
}

Future<void> _change(WidgetRef ref, ZakatSettings Function(ZakatSettings) f) =>
    ref.read(zakatSettingsProvider.notifier).change(f);

/// The answer: what is due, what has been paid, and when.
class _DueCard extends ConsumerWidget {
  const _DueCard({required this.report, this.canPay = true});

  final ZakatReport report;

  /// Off while only looking: a "Pay" button would contradict the answer.
  final bool canPay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final f = PlanFormat(ref, context);
    final r = report;
    String money(int v) => f.money(v, r.currency);

    final status = switch (r.meetsNisab) {
      null => l10n.zakatNeedPrice,
      true => l10n.zakatAboveNisab(money(r.net)),
      false => l10n.zakatBelowNisab(money(r.shortfall)),
    };
    final days = r.daysUntilDue(DateTime.now());

    return SunriseCard(
      key: const Key('zakat_due'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.zakatDue,
            style: SunriseType.body.copyWith(color: c.muted, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            money(r.due),
            style: SunriseType.section.copyWith(color: c.ink, fontSize: 28),
          ),
          const SizedBox(height: 4),
          Text(
            status,
            style: SunriseType.caption.copyWith(
              color: r.meetsNisab == true ? c.positive : c.subtle,
            ),
          ),
          if (r.due > 0 || r.paid > 0) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _Figure(
                    label: l10n.zakatPaidSoFar,
                    value: money(r.paid),
                  ),
                ),
                Expanded(
                  child: _Figure(
                    label: l10n.zakatLeftToPay,
                    value: money(r.left),
                    emphasise: r.left > 0,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Text(
            r.nextDate == null
                ? l10n.zakatNoDate
                : l10n.zakatNextDate(days!, f.day(r.nextDate!)),
            style: SunriseType.caption.copyWith(color: c.muted),
          ),
          if (canPay) ...[
            const SizedBox(height: 14),
            SunriseButton(
              key: const Key('zakat_pay'),
              label: l10n.zakatPay,
              icon: Symbols.volunteer_activism_rounded,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ZakatPayScreen(report: r)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({
    required this.label,
    required this.value,
    this.emphasise = false,
  });

  final String label;
  final String value;
  final bool emphasise;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: SunriseType.caption.copyWith(color: c.subtle)),
        Text(
          value,
          style: SunriseType.label.copyWith(
            color: emphasise ? c.accent : c.ink,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// Gold or silver, the price of a gram, and the nisab they make.
class _NisabSection extends ConsumerWidget {
  const _NisabSection({required this.report});

  final ZakatReport report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final f = PlanFormat(ref, context);
    final r = report;
    return SettingsGroup(
      label: l10n.zakatNisab,
      footer: l10n.zakatBasisHint,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SunriseSegmented<NisabBasis>(
            key: const Key('zakat_basis'),
            options: [
              for (final b in NisabBasis.values)
                SegmentOption(b, b.label(l10n)),
            ],
            value: r.basis,
            onChanged: (b) => _change(ref, (s) => s.copyWith(basis: b)),
          ),
        ),
        SettingsRow(
          key: const Key('zakat_price'),
          icon: Symbols.sell_rounded,
          title: l10n.zakatPricePerGram(r.basis.label(l10n)),
          value: r.pricePerGram == 0
              ? l10n.cardNotSet
              : f.money(r.pricePerGram, r.currency),
          onTap: () async {
            final v = await askAmount(
              context,
              initial: r.pricePerGram,
              currency: r.currency,
            );
            if (v != null) await _change(ref, (s) => s.withPrice(v));
          },
        ),
        SettingsRow(
          icon: Symbols.balance_rounded,
          title: l10n.zakatNisab,
          subtitle: l10n.zakatNisabWeight(r.basis.gramsText),
          value: r.nisab == null
              ? l10n.cardNotSet
              : f.money(r.nisab!, r.currency),
          trailing: SettingsTrailing.none,
        ),
      ],
    );
  }
}

/// Every line of wealth and debt, each with its own switch.
class _LinesSection extends ConsumerWidget {
  const _LinesSection({required this.report});

  final ZakatReport report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final r = report;

    String? footer(ZakatGroup g) => switch (g) {
      ZakatGroup.otherAssets => l10n.zakatOtherAssetsNote,
      ZakatGroup.paid => l10n.zakatPaidNote,
      _ => null,
    };

    final groups = [
      for (final g in ZakatGroup.values)
        if (r.of(g).isNotEmpty) g,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final g in groups) ...[
          SettingsGroup(
            label: g.label(l10n),
            footer: footer(g),
            children: [
              for (final line in r.of(g))
                _LineRow(
                  line: line,
                  currency: r.currency,
                  title: g == ZakatGroup.paid ? g.label(l10n) : line.name,
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        if (r.of(ZakatGroup.metals).isEmpty) ...[
          Text(
            l10n.zakatNoMetals,
            style: SunriseType.caption.copyWith(color: context.sunrise.subtle),
          ),
          const SizedBox(height: 12),
        ],
        SunriseButton.secondary(
          key: const Key('zakat_add_amount'),
          label: l10n.zakatAddAmount,
          icon: Symbols.add_rounded,
          onPressed: () async {
            final item = await showSunriseSheet<ZakatManualItem>(
              context: context,
              builder: (_) => _ManualAmountSheet(currency: r.currency),
            );
            if (item == null) return;
            await _change(ref, (s) => s.copyWith(manual: [...s.manual, item]));
          },
        ),
      ],
    );
  }
}

class _LineRow extends ConsumerWidget {
  const _LineRow({
    required this.line,
    required this.currency,
    required this.title,
  });

  final ZakatLine line;
  final String currency;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final f = PlanFormat(ref, context);
    final converted = line.currency != currency;
    final manualId = line.group == ZakatGroup.manual
        ? line.key.substring(2)
        : null;

    return Padding(
      key: Key('zakat_line_${line.key}'),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          IconTile(
            icon: line.group.icon,
            color: line.deduct ? c.negative : c.accent,
            size: 36,
            radius: SunriseRadius.iconTileSm,
            iconSize: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.rowTitle.copyWith(
                    color: line.included ? c.ink : c.subtle,
                  ),
                ),
                Text(
                  '${line.deduct ? '−' : ''}${f.money(line.amount, currency)}'
                  '${converted ? ' · ${f.money(line.original, line.currency)}' : ''}',
                  style: SunriseType.caption.copyWith(color: c.subtle),
                ),
              ],
            ),
          ),
          if (manualId != null)
            IconButton(
              tooltip: l10n.actionDelete,
              icon: Icon(Symbols.delete_rounded, color: c.subtle, size: 20),
              onPressed: () => _change(
                ref,
                (s) => s.copyWith(
                  manual: [
                    for (final m in s.manual)
                      if (m.id != manualId) m,
                  ],
                ),
              ),
            ),
          SunriseToggle(
            value: line.included,
            semanticLabel: title,
            onChanged: (on) => _change(
              ref,
              (s) => s.withSwitch(
                line.key,
                on: on,
                byDefault: line.includedByDefault,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// An amount the app does not track, added by hand.
class _ManualAmountSheet extends ConsumerStatefulWidget {
  const _ManualAmountSheet({required this.currency});

  final String currency;

  @override
  ConsumerState<_ManualAmountSheet> createState() => _ManualAmountSheetState();
}

class _ManualAmountSheetState extends ConsumerState<_ManualAmountSheet> {
  final _label = TextEditingController();
  int _amount = 0;
  bool _deduct = false;

  @override
  void initState() {
    super.initState();
    _label.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _label.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final f = PlanFormat(ref, context);
    final ready = _label.text.trim().isNotEmpty && _amount > 0;
    return SunriseBottomSheet(
      title: l10n.zakatAddAmount,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SunriseTextField(
            key: const Key('zakat_manual_label'),
            controller: _label,
            label: l10n.zakatAmountLabel,
            hint: l10n.zakatAmountHint,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 12),
          SettingsGroup(
            children: [
              SettingsRow(
                key: const Key('zakat_manual_amount'),
                icon: Symbols.payments_rounded,
                title: l10n.aiActionAmount,
                value: _amount == 0
                    ? l10n.cardNotSet
                    : f.money(_amount, widget.currency),
                onTap: () async {
                  final v = await askAmount(
                    context,
                    initial: _amount,
                    currency: widget.currency,
                  );
                  if (v != null) setState(() => _amount = v);
                },
              ),
              SettingsRow.toggle(
                icon: Symbols.remove_circle_rounded,
                title: l10n.zakatAmountDeduct,
                value: _deduct,
                onChanged: (v) => setState(() => _deduct = v),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SunriseButton(
            key: const Key('zakat_manual_save'),
            label: l10n.actionAdd,
            onPressed: ready
                ? () => Navigator.of(context).pop(
                    ZakatManualItem(
                      id: const Uuid().v4(),
                      label: _label.text.trim(),
                      amount: _amount,
                      deduct: _deduct,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

/// Wealth, less debts, the net and 2.5% of it.
class _TotalsCard extends ConsumerWidget {
  const _TotalsCard({required this.report});

  final ZakatReport report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final f = PlanFormat(ref, context);
    final r = report;

    Widget row(String label, String value, {bool strong = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: SunriseType.body.copyWith(
                color: strong ? c.ink : c.muted,
                fontWeight: strong ? FontWeight.w700 : null,
              ),
            ),
          ),
          Text(
            value,
            style: SunriseType.label.copyWith(
              color: c.ink,
              fontWeight: strong ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );

    return SunriseCard(
      key: const Key('zakat_totals'),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          row(l10n.zakatWealth, f.money(r.wealth, r.currency)),
          row(l10n.zakatDeductions, '−${f.money(r.deductions, r.currency)}'),
          const Divider(height: 16),
          row(l10n.zakatNet, f.money(r.net, r.currency), strong: true),
          if (r.nisab != null)
            row(l10n.zakatNisab, f.money(r.nisab!, r.currency)),
          row(l10n.zakatRate, f.money(r.rateOfNet, r.currency)),
        ],
      ),
    );
  }
}

/// When the zakat year completes, and whether to be reminded.
class _YearSection extends ConsumerWidget {
  const _YearSection({required this.settings});

  final ZakatSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final f = PlanFormat(ref, context);
    final date = settings.zakatDate;
    return SettingsGroup(
      label: l10n.zakatYear,
      footer: l10n.zakatDateHint,
      children: [
        SettingsRow(
          key: const Key('zakat_date'),
          icon: Symbols.event_rounded,
          title: l10n.zakatDate,
          value: date == null ? l10n.cardNotSet : f.day(date),
          onTap: () async {
            final today = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: date ?? today,
              firstDate: DateTime(today.year - 3),
              lastDate: DateTime(today.year + 2, 12, 31),
            );
            if (picked != null) {
              await _change(ref, (s) => s.copyWith(zakatDate: picked));
            }
          },
        ),
        SettingsRow.toggle(
          key: const Key('zakat_remind'),
          icon: Symbols.notifications_rounded,
          title: l10n.zakatRemind,
          subtitle: l10n.zakatRemindHint,
          value: settings.remind,
          onChanged: date == null
              ? null
              : (v) => _change(ref, (s) => s.copyWith(remind: v)),
        ),
      ],
    );
  }
}

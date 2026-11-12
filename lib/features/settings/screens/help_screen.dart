import 'package:material_ui/material_ui.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';
import 'package:the_accountant/features/settings/screens/contact_support_screen.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final Set<int> _expandedItems = {};

  List<Map<String, String>> _faqItems(L10n l10n) => [
    {
      'section': l10n.settingsFaqSectionGettingStarted,
      'question': l10n.settingsFaq01Question,
      'answer': l10n.settingsFaq01Answer,
    },
    {
      'section': l10n.settingsFaqSectionGettingStarted,
      'question': l10n.settingsFaq02Question,
      'answer': l10n.settingsFaq02Answer,
    },
    {
      'section': l10n.settingsFaqSectionGettingStarted,
      'question': l10n.settingsFaq03Question,
      'answer': l10n.settingsFaq03Answer,
    },
    {
      'section': l10n.settingsFaqSectionTransactions,
      'question': l10n.settingsFaq04Question,
      'answer': l10n.settingsFaq04Answer,
    },
    {
      'section': l10n.settingsFaqSectionTransactions,
      'question': l10n.settingsFaq05Question,
      'answer': l10n.settingsFaq05Answer,
    },
    {
      'section': l10n.settingsFaqSectionTransactions,
      'question': l10n.settingsFaq06Question,
      'answer': l10n.settingsFaq06Answer,
    },
    {
      'section': l10n.settingsFaqSectionTransactions,
      'question': l10n.settingsFaq07Question,
      'answer': l10n.settingsFaq07Answer,
    },
    {
      'section': l10n.settingsFaqSectionTransactions,
      'question': l10n.settingsFaq08Question,
      'answer': l10n.settingsFaq08Answer,
    },
    {
      'section': l10n.settingsFaqSectionTransactions,
      'question': l10n.settingsFaq09Question,
      'answer': l10n.settingsFaq09Answer,
    },
    {
      'section': l10n.settingsFaqSectionWalletsCurrencies,
      'question': l10n.settingsFaq10Question,
      'answer': l10n.settingsFaq10Answer,
    },
    {
      'section': l10n.settingsFaqSectionWalletsCurrencies,
      'question': l10n.settingsFaq11Question,
      'answer': l10n.settingsFaq11Answer,
    },
    {
      'section': l10n.settingsFaqSectionWalletsCurrencies,
      'question': l10n.settingsFaq12Question,
      'answer': l10n.settingsFaq12Answer,
    },
    {
      'section': l10n.settingsFaqSectionWalletsCurrencies,
      'question': l10n.settingsFaq13Question,
      'answer': l10n.settingsFaq13Answer,
    },
    {
      'section': l10n.settingsFaqSectionWalletsCurrencies,
      'question': l10n.settingsFaq14Question,
      'answer': l10n.settingsFaq14Answer,
    },
    {
      'section': l10n.settingsFaqSectionWalletsCurrencies,
      'question': l10n.settingsFaq15Question,
      'answer': l10n.settingsFaq15Answer,
    },
    {
      'section': l10n.settingsFaqSectionBudgetsGoals,
      'question': l10n.settingsFaq16Question,
      'answer': l10n.settingsFaq16Answer,
    },
    {
      'section': l10n.settingsFaqSectionBudgetsGoals,
      'question': l10n.settingsFaq17Question,
      'answer': l10n.settingsFaq17Answer,
    },
    {
      'section': l10n.settingsFaqSectionBudgetsGoals,
      'question': l10n.settingsFaq18Question,
      'answer': l10n.settingsFaq18Answer,
    },
    {
      'section': l10n.settingsFaqSectionDataSync,
      'question': l10n.settingsFaq19Question,
      'answer': l10n.settingsFaq19Answer,
    },
    {
      'section': l10n.settingsFaqSectionDataSync,
      'question': l10n.settingsFaq20Question,
      'answer': l10n.settingsFaq20Answer,
    },
    {
      'section': l10n.settingsFaqSectionDataSync,
      'question': l10n.settingsFaq21Question,
      'answer': l10n.settingsFaq21Answer,
    },
    {
      'section': l10n.settingsFaqSectionPremiumAiFeatures,
      'question': l10n.settingsFaq22Question,
      'answer': l10n.settingsFaq22Answer,
    },
    {
      'section': l10n.settingsFaqSectionPremiumAiFeatures,
      'question': l10n.settingsFaq23Question,
      'answer': l10n.settingsFaq23Answer,
    },
    {
      'section': l10n.settingsFaqSectionPremiumAiFeatures,
      'question': l10n.settingsFaq24Question,
      'answer': l10n.settingsFaq24Answer,
    },
    {
      'section': l10n.settingsFaqSectionPremiumAiFeatures,
      'question': l10n.settingsFaq25Question,
      'answer': l10n.settingsFaq25Answer,
    },
    {
      'section': l10n.settingsFaqSectionPremiumAiFeatures,
      'question': l10n.settingsFaq26Question,
      'answer': l10n.settingsFaq26Answer,
    },
    {
      'section': l10n.settingsFaqSectionPremiumAiFeatures,
      'question': l10n.settingsFaq27Question,
      'answer': l10n.settingsFaq27Answer,
    },
    {
      'section': l10n.settingsFaqSectionPremiumAiFeatures,
      'question': l10n.settingsFaq28Question,
      'answer': l10n.settingsFaq28Answer,
    },
    {
      'section': l10n.settingsFaqSectionPremiumAiFeatures,
      'question': l10n.settingsFaq29Question,
      'answer': l10n.settingsFaq29Answer,
    },
    {
      'section': l10n.settingsFaqSectionPrivacySecurity,
      'question': l10n.settingsFaq30Question,
      'answer': l10n.settingsFaq30Answer,
    },
    {
      'section': l10n.settingsFaqSectionPrivacySecurity,
      'question': l10n.settingsFaq31Question,
      'answer': l10n.settingsFaq31Answer,
    },
  ];

  String _query = '';

  bool _matches(Map<String, String> item) {
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return item['question']!.toLowerCase().contains(q) ||
        item['answer']!.toLowerCase().contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final faqItems = _faqItems(l10n);
    final sectionOrder = <String>[];
    final sectionIndices = <String, List<int>>{};
    for (int i = 0; i < faqItems.length; i++) {
      final section = faqItems[i]['section']!;
      if (!sectionIndices.containsKey(section)) {
        sectionOrder.add(section);
        sectionIndices[section] = [];
      }
      sectionIndices[section]!.add(i);
    }
    final sections = <Widget>[];
    for (final section in sectionOrder) {
      final indices = sectionIndices[section]!
          .where((i) => _matches(faqItems[i]))
          .toList();
      if (indices.isEmpty) continue;
      sections
        ..add(SectionLabel(section))
        ..add(_buildSectionCard(faqItems, indices))
        ..add(const SizedBox(height: SunriseSpace.section));
    }

    return SunrisePushPage(
      title: l10n.settingsHelpFaq,
      children: [
        if (_query.isEmpty) ...[
          _buildQuickHelpSection(),
          const SizedBox(height: SunriseSpace.sectionTight),
        ],
        SunriseSearchField(
          hint: l10n.helpSearchQuestions,
          onChanged: (v) => setState(() => _query = v.trim()),
        ),
        const SizedBox(height: SunriseSpace.section),
        ...sections,
        if (sections.isEmpty)
          EmptyState(
            compact: true,
            icon: Symbols.search_off_rounded,
            title: l10n.settingsNoSettingsFound,
            message: l10n.settingsTryADifferentSearchTerm,
          ),
        _buildStillNeedHelpSection(),
      ],
    );
  }

  Widget _buildQuickHelpSection() {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final steps = [
      l10n.helpStepWallets,
      l10n.helpStepCategories,
      l10n.helpStepTrack,
    ];
    return GradientCard(
      radius: SunriseRadius.hero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Symbols.tips_and_updates_rounded, color: c.onFill, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.settingsGettingStarted,
                  style: SunriseType.section.copyWith(
                    color: c.onFill,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < steps.length; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 84),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: c.onFill.withValues(alpha: .18),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${i + 1}',
                          style: SunriseType.section.copyWith(color: c.onFill),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          steps[i],
                          textAlign: TextAlign.center,
                          style: SunriseType.label.copyWith(color: c.onFill),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    List<Map<String, String>> faqItems,
    List<int> indices,
  ) {
    final c = context.sunrise;
    return SunriseCard(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (var i = 0; i < indices.length; i++) ...[
            if (i > 0) Divider(height: 1, thickness: 1, color: c.divider),
            _buildFaqItem(indices[i], faqItems[indices[i]]),
          ],
        ],
      ),
    );
  }

  Widget _buildFaqItem(int index, Map<String, String> item) {
    final c = context.sunrise;
    final isExpanded = _expandedItems.contains(index);

    return Semantics(
      expanded: isExpanded,
      child: Pressable(
        scale: .99,
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() {
            if (!_expandedItems.remove(index)) _expandedItems.add(index);
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item['question']!,
                      style: SunriseType.rowTitle.copyWith(color: c.ink),
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedSwitcher(
                    duration: SunriseMotion.accordion,
                    transitionBuilder: (child, a) =>
                        RotationTransition(turns: a, child: child),
                    child: Icon(
                      isExpanded ? Symbols.remove_rounded : Symbols.add_rounded,
                      key: ValueKey(isExpanded),
                      color: isExpanded ? c.accent : c.chevron,
                      size: 22,
                    ),
                  ),
                ],
              ),
              AnimatedSize(
                duration: SunriseMotion.accordion,
                curve: Curves.easeOut,
                alignment: Alignment.topCenter,
                child: isExpanded
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          item['answer']!,
                          style: SunriseType.body.copyWith(
                            color: c.muted,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStillNeedHelpSection() {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return SunriseCard(
      padding: const EdgeInsets.all(SunriseSpace.hero),
      child: Column(
        children: [
          IconTile(
            icon: Symbols.support_agent_rounded,
            color: c.accent,
            background: c.tintOrange,
            size: 52,
            radius: 16,
            iconSize: 26,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.settingsStillNeedHelp,
            style: SunriseType.section.copyWith(color: c.ink),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.settingsOurSupportTeamIsHere,
            textAlign: TextAlign.center,
            style: SunriseType.body.copyWith(color: c.muted, fontSize: 14),
          ),
          const SizedBox(height: 16),
          SunriseButton(
            label: l10n.settingsContactSupport,
            icon: Symbols.mail_rounded,
            height: 52,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ContactSupportScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

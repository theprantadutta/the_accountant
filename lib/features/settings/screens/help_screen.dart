import 'package:flutter/material.dart';
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

  final List<Map<String, String>> _faqItems = [
    // Getting Started
    {
      'section': 'Getting Started',
      'question': 'How do I add a transaction?',
      'answer':
          'Tap the + button at the bottom of the home screen. Fill in the amount, select a category, choose a wallet, and optionally add notes. Tap Save to record your transaction.',
    },
    {
      'section': 'Getting Started',
      'question': 'What is the difference between wallets and categories?',
      'answer':
          'Wallets represent where your money is stored (e.g., Cash, Bank Account, Credit Card). Categories describe what the money was spent on or where it came from (e.g., Food, Salary, Entertainment).',
    },
    {
      'section': 'Getting Started',
      'question': 'How do I customize my date and number format?',
      'answer':
          'Go to Settings > Regional Settings. You can change your default currency, date format (e.g., DD/MM/YYYY or MM/DD/YYYY), and number format (e.g., 1,234.56 or 1.234,56). A live preview shows how your settings will look.',
    },

    // Transactions
    {
      'section': 'Transactions',
      'question': 'Can I track recurring transactions?',
      'answer':
          'Yes! When adding a transaction, enable the "Recurring" option. You can set it to repeat daily, weekly, monthly, or yearly. The app will automatically create these transactions for you.',
    },
    {
      'section': 'Transactions',
      'question': 'How do I transfer money between wallets?',
      'answer':
          'When adding a transaction, select "Transfer" as the type. Choose the source wallet, destination wallet, and enter the amount. The app will automatically deduct from one and add to the other.',
    },
    {
      'section': 'Transactions',
      'question': 'What are upcoming transactions?',
      'answer':
          "Upcoming transactions are future expenses or income you expect but haven't paid yet. They won't affect your wallet balance until you mark them as paid. You can find overdue and upcoming items in the transactions section.",
    },
    {
      'section': 'Transactions',
      'question': 'How do I track subscriptions?',
      'answer':
          'When adding a transaction, set the special type to Subscription. This marks it as a recurring service payment. You can view all your subscriptions in one place and track your monthly subscription spending.',
    },
    {
      'section': 'Transactions',
      'question': 'How does credit and debt tracking work?',
      'answer':
          "Use Credit to track money you've lent to someone, and Debt to track money you've borrowed. Each entry tracks the amount, who owes whom, and payment progress. You can record partial payments and mark debts as settled when fully repaid.",
    },
    {
      'section': 'Transactions',
      'question': 'Can I add notes or receipts to transactions?',
      'answer':
          'Yes! When adding or editing a transaction, you can type notes in the notes field. Premium users can also scan receipts using the AI-powered receipt scanner, which automatically extracts the amount and merchant details.',
    },

    // Wallets & Currencies
    {
      'section': 'Wallets & Currencies',
      'question': 'How do I manage multiple wallet accounts?',
      'answer':
          "The app supports four account types: Cash, Bank Account, Credit Card, and Subscription. To add a new account, go to 'Your Accounts' on the dashboard and tap 'Add Account'. Each account can have its own name, icon, color, and currency. Your first account is automatically set as the default. Credit card accounts also let you set a credit limit and billing cycle day so you can track available credit.",
    },
    {
      'section': 'Wallets & Currencies',
      'question': 'Can I use multiple currencies?',
      'answer':
          'Yes! Each wallet can have its own currency. The app supports automatic currency conversion using live exchange rates. You can also set custom exchange rates in Settings > Regional Settings.',
    },
    {
      'section': 'Wallets & Currencies',
      'question': 'How does currency conversion work?',
      'answer':
          'Each wallet can have a different currency, and the app automatically converts amounts using live exchange rates updated every few hours. You can also set custom exchange rates for any currency pair in Settings > Regional Settings. The app supports over 150 currencies with automatic rate fetching.',
    },
    {
      'section': 'Wallets & Currencies',
      'question': 'What happens if I delete a category with transactions?',
      'answer':
          'Those transactions will be moved to "Uncategorized". You can then reassign them to a different category or leave them uncategorized.',
    },
    {
      'section': 'Wallets & Currencies',
      'question': 'What are subcategories and how do I use them?',
      'answer':
          "You can create subcategories under any main category for more detailed tracking. For example, under 'Food', you could have 'Groceries', 'Restaurants', and 'Coffee'. Subcategories help you see exactly where your money goes.",
    },
    {
      'section': 'Wallets & Currencies',
      'question': 'What is a balance correction?',
      'answer':
          "A balance correction lets you adjust a wallet's balance when it doesn't match the actual amount. This creates a special transaction that brings your tracked balance in line with reality, without manually adding income or expense entries.",
    },

    // Budgets & Goals
    {
      'section': 'Budgets & Goals',
      'question': 'How do I set up a budget?',
      'answer':
          'Go to the Budgets tab and tap "Create Budget". Choose a name, set your spending limit, select the time period (weekly/monthly), and pick which categories to track. The app will alert you when you approach your limit.',
    },
    {
      'section': 'Budgets & Goals',
      'question': 'What are savings goals?',
      'answer':
          'Savings goals let you set a target amount you want to save. Create a goal in the Objectives section, set your target, and link transactions to track your progress. The app shows a progress bar and percentage toward your target.',
    },
    {
      'section': 'Budgets & Goals',
      'question': 'How do I track a loan?',
      'answer':
          "Create a Loan objective in the Objectives section with the total amount owed. As you make payments, link those transactions to the loan to track your repayment progress. The app shows how much you've paid and what remains.",
    },

    // Data & Sync
    {
      'section': 'Data & Sync',
      'question': 'How does Cloud Sync work?',
      'answer':
          "Cloud Sync keeps your data synchronized across devices. Go to Settings > Data Management > Cloud Sync to enable it. Sync runs automatically every 15 minutes and when you open the app. You can also tap 'Sync Now' for an immediate sync. This is a Premium feature.",
    },
    {
      'section': 'Data & Sync',
      'question': 'How do I export my data?',
      'answer':
          'Go to Settings > Data Management > Export Data. Choose a date range, select CSV (for spreadsheets) or PDF (for a formatted report), and tap Export. You can include or exclude category and wallet breakdowns. This is a Premium feature.',
    },
    {
      'section': 'Data & Sync',
      'question': 'What happens if I clear my data?',
      'answer':
          "Go to Settings > Privacy & Security. 'Clear Cache' removes temporary data and forces a re-sync without deleting your transactions. 'Clear All Data' permanently deletes everything — you'll need to type DELETE to confirm. This action cannot be undone.",
    },

    // Premium & AI Features
    {
      'section': 'Premium & AI Features',
      'question': 'What features are included in Premium?',
      'answer':
          'Premium unlocks: unlimited AI (the coach, monthly summaries, receipt reading and Describe it) with no ads, Cloud Sync, PDF reports, Premium Themes, and removes limits on wallets, categories, budgets, goals, and payment methods. You also get priority support.',
    },
    {
      'section': 'Premium & AI Features',
      'question': 'What are the free tier limits?',
      'answer':
          'Free users can create up to 3 wallets, 10 custom categories, 3 active budgets, 2 active goals/loans, and 5 payment methods. Upgrading to Premium removes all these limits.',
    },
    {
      'section': 'Premium & AI Features',
      'question': 'What can the AI Assistant do?',
      'answer':
          "The money coach answers questions about your own money: where it went, whether you are on track with your budgets and goals, which bills are coming, and how to spend less or save more. It sees a summary of your figures (totals, categories, budgets, goals, bills and recent transactions) so its answers use your real numbers, and it suggests follow-up questions after each reply. It gives general guidance, not professional financial advice. Your conversations are saved so you can pick up where you left off, and you can delete them at any time.",
    },
    {
      'section': 'Premium & AI Features',
      'question': 'How do AI Insights work?',
      'answer':
          'The monthly summary (Stats > Spending Insights) shows this month against last month: what you earned and spent, and how each category moved. Tap Write my summary and the AI picks out what stood out and suggests one thing to try. The numbers are free for everyone; the AI write-up uses one AI request.',
    },
    {
      'section': 'Premium & AI Features',
      'question': 'What is Smart Categorization?',
      'answer':
          "When you file a transaction by hand, the app remembers which category that title belongs to and picks it for you next time (you can see and edit these under Naming rules). For something new, tap the sparkle button on the add screen and Describe it: type something like 'lunch 250 yesterday from bKash' and the AI fills in the amount, date, category and account for you to check.",
    },
    {
      'section': 'Premium & AI Features',
      'question': 'How does the AI receipt scanner work?',
      'answer':
          'Take or pick a photo of a receipt. Your phone reads the text on the device and suggests the merchant and total. Tap Read with AI and the AI works out the real total, the date, each item and the right category, even on a messy receipt; only the text is sent, never the photo. You can review and edit before saving. Reading with AI uses one AI request.',
    },
    {
      'section': 'Premium & AI Features',
      'question': 'How many AI requests do I get, and what are the ads for?',
      'answer':
          'Everyone gets 10 free AI requests a month, and they come back on the 1st. If you want more, you can choose to watch a short ad for one extra request, up to 10 more a month. Ads can also unlock a 24-hour premium theme trial or a PDF export. An ad only ever plays after you tap a button and confirm; there are no banner ads and nothing appears on its own. Premium members get unlimited AI and everything else with no ads at all.',
    },
    {
      'section': 'Premium & AI Features',
      'question': 'How do I manage my Premium purchase?',
      'answer':
          'Premium purchases are managed through Google Play. Go to your Google Play subscription settings to view or manage your plan. Premium is available as a monthly, yearly, or one-time lifetime purchase.',
    },

    // Privacy & Security
    {
      'section': 'Privacy & Security',
      'question': 'How do I set up biometric lock?',
      'answer':
          'Go to Settings > Privacy & Security and enable Biometric Lock. Once enabled, you\'ll need your fingerprint or face to open the app. You can also configure an auto-lock timer so the app locks after a period of inactivity.',
    },
    {
      'section': 'Privacy & Security',
      'question': 'Is my financial data secure?',
      'answer':
          'Yes. All your data is stored locally on your device. If you enable Cloud Sync, your data is encrypted during transfer. We never share your financial data with third parties. You can review our Privacy Policy in Settings > About.',
    },
  ];

  late final List<String> _sectionOrder;
  late final Map<String, List<int>> _sectionIndices;

  @override
  void initState() {
    super.initState();
    _sectionOrder = [];
    _sectionIndices = {};
    for (int i = 0; i < _faqItems.length; i++) {
      final section = _faqItems[i]['section']!;
      if (!_sectionIndices.containsKey(section)) {
        _sectionOrder.add(section);
        _sectionIndices[section] = [];
      }
      _sectionIndices[section]!.add(i);
    }
  }

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
    final sections = <Widget>[];
    for (final section in _sectionOrder) {
      final indices = _sectionIndices[section]!
          .where((i) => _matches(_faqItems[i]))
          .toList();
      if (indices.isEmpty) continue;
      sections
        ..add(SectionLabel(section))
        ..add(_buildSectionCard(indices))
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

  Widget _buildSectionCard(List<int> indices) {
    final c = context.sunrise;
    return SunriseCard(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (var i = 0; i < indices.length; i++) ...[
            if (i > 0) Divider(height: 1, thickness: 1, color: c.divider),
            _buildFaqItem(indices[i], _faqItems[indices[i]]),
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

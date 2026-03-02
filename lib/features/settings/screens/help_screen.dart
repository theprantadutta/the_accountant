import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
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
          'Premium unlocks: Cloud Sync, AI Assistant, Receipt Scanner, AI Insights, Smart Categorization, Advanced Reports, Data Export, Premium Themes, and removes limits on wallets, categories, budgets, goals, and payment methods. You also get priority support.',
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
          "The AI Assistant is your personal financial advisor powered by AI. You can chat with it to analyze your spending patterns, get budget tips, find ways to save money, or ask for investment advice. It also offers quick action buttons for common questions like 'Analyze Spending' and 'Budget Tips'. Your conversation history is saved so you can pick up where you left off. This is a Premium feature.",
    },
    {
      'section': 'Premium & AI Features',
      'question': 'How do AI Insights work?',
      'answer':
          'AI Insights generates a monthly financial summary that includes your total income, expenses, net savings, and spending trends compared to the previous month. It highlights your top spending categories and provides personalized recommendations to improve your finances. Access it from the app navigation. This is a Premium feature.',
    },
    {
      'section': 'Premium & AI Features',
      'question': 'What is Smart Categorization?',
      'answer':
          "Smart Categorization automatically suggests a category when you add a transaction based on its title. For example, typing 'Starbucks' would suggest the Food category. The system learns from your transaction patterns to improve suggestions over time. This is a Premium feature.",
    },
    {
      'section': 'Premium & AI Features',
      'question': 'How does the AI receipt scanner work?',
      'answer':
          'The receipt scanner uses machine learning to read your receipts. Take a photo of your receipt, and the AI will automatically extract the amount, date, and merchant name. You can review and edit before saving. This feature requires Premium.',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Help & FAQ'),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          // Quick help section
          _buildQuickHelpSection(),
          SizedBox(height: AppSpacing.lg),

          // FAQ header
          Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.sm,
              bottom: AppSpacing.sm,
            ),
            child: Text(
              'FREQUENTLY ASKED QUESTIONS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
                letterSpacing: 1.2,
              ),
            ),
          ),

          // FAQ sections
          for (final section in _sectionOrder) ...[
            _buildSectionHeader(section),
            _buildSectionCard(_sectionIndices[section]!),
            SizedBox(height: AppSpacing.md),
          ],

          SizedBox(height: AppSpacing.sm),

          // Still need help section
          _buildStillNeedHelpSection(),
        ],
      ),
    );
  }

  Widget _buildQuickHelpSection() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppSpacing.borderRadiusLg,
      ),
      child: Column(
        children: [
          Icon(Icons.lightbulb_outline, size: 40, color: Colors.white),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Getting Started',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Start by adding your wallets, then create categories for your spending. After that, you can start tracking transactions!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.sm,
        bottom: AppSpacing.sm,
        top: AppSpacing.xs,
      ),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textMuted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSectionCard(List<int> indices) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: List.generate(indices.length * 2 - 1, (i) {
          if (i.isOdd) {
            return Divider(
              height: 1,
              thickness: 1,
              color: AppColors.divider,
            );
          }
          final itemIndex = indices[i ~/ 2];
          return _buildFaqItem(itemIndex, _faqItems[itemIndex]);
        }),
      ),
    );
  }

  Widget _buildFaqItem(int index, Map<String, String> item) {
    final isExpanded = _expandedItems.contains(index);

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          item['question']!,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        trailing: AnimatedRotation(
          turns: isExpanded ? 0.5 : 0,
          duration: const Duration(milliseconds: 200),
          child: Icon(Icons.expand_more, color: AppColors.textMuted),
        ),
        onExpansionChanged: (expanded) {
          HapticFeedback.selectionClick();
          setState(() {
            if (expanded) {
              _expandedItems.add(index);
            } else {
              _expandedItems.remove(index);
            }
          });
        },
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md,
            ),
            child: Text(
              item['answer']!,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStillNeedHelpSection() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Icon(Icons.help_outline, size: 40, color: AppColors.primaryAccent),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Still need help?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Our support team is here to help you',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          SizedBox(height: AppSpacing.md),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ContactSupportScreen(),
              ),
            ),
            icon: Icon(Icons.email_outlined),
            label: Text('Contact Support'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryAccent,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

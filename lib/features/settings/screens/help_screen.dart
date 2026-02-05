import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final Set<int> _expandedItems = {};

  final List<Map<String, String>> _faqItems = [
    {
      'question': 'How do I add a transaction?',
      'answer':
          'Tap the + button at the bottom of the home screen. Fill in the amount, select a category, choose a wallet, and optionally add notes. Tap Save to record your transaction.',
    },
    {
      'question': 'What is the difference between wallets and categories?',
      'answer':
          'Wallets represent where your money is stored (e.g., Cash, Bank Account, Credit Card). Categories describe what the money was spent on or where it came from (e.g., Food, Salary, Entertainment).',
    },
    {
      'question': 'How do I set up a budget?',
      'answer':
          'Go to the Budgets tab and tap "Create Budget". Choose a name, set your spending limit, select the time period (weekly/monthly), and pick which categories to track. The app will alert you when you approach your limit.',
    },
    {
      'question': 'Can I track recurring transactions?',
      'answer':
          'Yes! When adding a transaction, enable the "Recurring" option. You can set it to repeat daily, weekly, monthly, or yearly. The app will automatically create these transactions for you.',
    },
    {
      'question': 'How does the AI receipt scanner work?',
      'answer':
          'The receipt scanner uses machine learning to read your receipts. Take a photo of your receipt, and the AI will automatically extract the amount, date, and merchant name. You can review and edit before saving. This feature requires Premium.',
    },
    {
      'question': 'How do I backup my data?',
      'answer':
          'Go to Settings > Data Management > Backup & Restore. Connect your Google account to enable automatic backups to Google Drive. You can also manually trigger a backup anytime. Premium subscription required.',
    },
    {
      'question': 'Can I use multiple currencies?',
      'answer':
          'Yes! Each wallet can have its own currency. The app supports automatic currency conversion using live exchange rates. You can also set custom exchange rates in Settings > Regional > Exchange Rates.',
    },
    {
      'question': 'How do I transfer money between wallets?',
      'answer':
          'When adding a transaction, select "Transfer" as the type. Choose the source wallet, destination wallet, and enter the amount. The app will automatically deduct from one and add to the other.',
    },
    {
      'question': 'What happens if I delete a category with transactions?',
      'answer':
          'Those transactions will be moved to "Uncategorized". You can then reassign them to a different category or leave them uncategorized.',
    },
    {
      'question': 'How do I cancel my Premium subscription?',
      'answer':
          'Subscriptions are managed through Google Play or the App Store. Go to your device\'s subscription settings to manage or cancel your Premium subscription.',
    },
  ];

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

          // FAQ items
          Container(
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: AppSpacing.borderRadiusLg,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Column(
              children: List.generate(_faqItems.length * 2 - 1, (index) {
                if (index.isOdd) {
                  return Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.divider,
                  );
                }
                final itemIndex = index ~/ 2;
                return _buildFaqItem(itemIndex, _faqItems[itemIndex]);
              }),
            ),
          ),
          SizedBox(height: AppSpacing.lg),

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
            onPressed: _contactSupport,
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

  Future<void> _contactSupport() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@theaccountant.app',
      queryParameters: {'subject': 'The Accountant App - Help Request'},
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

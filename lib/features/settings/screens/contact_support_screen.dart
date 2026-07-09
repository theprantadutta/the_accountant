import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/shared/widgets/neo_button.dart';
import 'package:the_accountant/shared/widgets/neo_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupportScreen extends ConsumerStatefulWidget {
  const ContactSupportScreen({super.key});

  static const _email = 'prantadutta1997@gmail.com';

  @override
  ConsumerState<ContactSupportScreen> createState() =>
      _ContactSupportScreenState();
}

class _ContactSupportScreenState extends ConsumerState<ContactSupportScreen> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      _snack('Please describe your issue first', AppColors.error);
      return;
    }

    setState(() => _isSending = true);
    try {
      await ApiService().post(
        '/support',
        data: {'subject': _subjectController.text.trim(), 'message': message},
      );
      if (!mounted) return;
      _snack('Thanks! Your message has been sent.', AppColors.success);
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      _snack(
        "Couldn't send right now. Please try again or email us directly.",
        AppColors.error,
      );
      setState(() => _isSending = false);
    }
  }

  void _snack(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(premiumProvider).isPremium;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Contact Support'),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          _buildHero(),
          if (isPremium) ...[
            SizedBox(height: AppSpacing.md),
            _buildPriorityNote(),
          ],
          SizedBox(height: AppSpacing.lg),
          NeoTextField(
            controller: _subjectController,
            label: 'Subject',
            hint: "What's this about?",
            prefixIcon: Icons.subject,
            textCapitalization: TextCapitalization.sentences,
          ),
          SizedBox(height: AppSpacing.md),
          NeoTextField(
            controller: _messageController,
            label: 'Message',
            hint: 'Describe your question, issue, or feedback…',
            prefixIcon: Icons.chat_bubble_outline,
            maxLines: 6,
            minLines: 4,
            textCapitalization: TextCapitalization.sentences,
          ),
          SizedBox(height: AppSpacing.lg),
          NeoButton(
            label: 'Send message',
            leadingIcon: Icons.send_rounded,
            isExpanded: true,
            isLoading: _isSending,
            onPressed: _isSending ? null : _submit,
          ),
          SizedBox(height: AppSpacing.lg),
          _buildTipsCard(),
          SizedBox(height: AppSpacing.lg),
          _buildEmailFallback(),
          SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryAccent.withValues(alpha: 0.14),
            AppColors.neonPurple.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.22),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.support_agent,
              size: 26,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Get in touch',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            "Questions, bugs, or feedback — send it over and we'll get back to you.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityNote() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: Colors.amber.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          const Icon(Icons.bolt, color: Colors.amber, size: 20),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'As a Premium member, your request is flagged for priority.',
              style: TextStyle(color: Colors.amber.shade200, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primarySurface.withValues(alpha: 0.45),
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What to include',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          _buildBulletPoint('A clear description of your issue'),
          SizedBox(height: AppSpacing.xs),
          _buildBulletPoint("Steps to reproduce (if it's a bug)"),
          SizedBox(height: AppSpacing.xs),
          _buildBulletPoint('Your device model and Android version'),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Icon(Icons.circle, size: 6, color: AppColors.primaryAccent),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailFallback() {
    return Center(
      child: TextButton.icon(
        onPressed: _launchEmail,
        icon: Icon(Icons.email_outlined, size: 18, color: AppColors.textMuted),
        label: Text(
          'Prefer email? ${ContactSupportScreen._email}',
          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
      ),
    );
  }

  Future<void> _launchEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: ContactSupportScreen._email,
      queryParameters: {'subject': 'The Accountant App - Support Request'},
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Clipboard.setData(const ClipboardData(text: ContactSupportScreen._email));
      if (mounted) _snack('Email copied to clipboard', AppColors.info);
    }
  }
}

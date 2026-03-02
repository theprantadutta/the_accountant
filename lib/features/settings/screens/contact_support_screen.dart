import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  static const _email = 'prantadutta1997@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Contact Support'),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          _buildHeroSection(),
          SizedBox(height: AppSpacing.lg),
          _buildEmailCard(context),
          SizedBox(height: AppSpacing.md),
          _buildTipsCard(),
          SizedBox(height: AppSpacing.lg),
          _buildSendEmailButton(),
          SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppSpacing.borderRadiusLg,
      ),
      child: Column(
        children: [
          const Icon(Icons.mail_outline, size: 40, color: Colors.white),
          SizedBox(height: AppSpacing.sm),
          const Text(
            'Get in Touch',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            "Have questions, complaints, or running into problems? We'd love to hear from you.",
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

  Widget _buildEmailCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.email_outlined, color: AppColors.primaryAccent, size: 22),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: GestureDetector(
              onTap: () => _copyEmail(context),
              child: Text(
                _email,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy, color: AppColors.textMuted, size: 20),
            onPressed: () => _copyEmail(context),
            tooltip: 'Copy email',
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
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
          _buildBulletPoint('Steps to reproduce (if it\'s a bug)'),
          SizedBox(height: AppSpacing.xs),
          _buildBulletPoint('Your device model and Android version'),
          SizedBox(height: AppSpacing.xs),
          _buildBulletPoint('Screenshots if applicable'),
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
          child: Icon(
            Icons.circle,
            size: 6,
            color: AppColors.primaryAccent,
          ),
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

  Widget _buildSendEmailButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _sendEmail,
        icon: const Icon(Icons.email_outlined),
        label: const Text('Send Email'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryAccent,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusLg,
          ),
        ),
      ),
    );
  }

  void _copyEmail(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: _email));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _sendEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _email,
      queryParameters: {'subject': 'The Accountant App - Support Request'},
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

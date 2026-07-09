import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/features/legal/legal_document_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('About'),
      ),
      body: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          final version = snapshot.data?.version ?? '...';
          final build = snapshot.data?.buildNumber ?? '...';

          return ListView(
            padding: EdgeInsets.all(AppSpacing.md),
            children: [
              // App logo and name
              _buildAppHeader(),
              SizedBox(height: AppSpacing.xl),

              // Version info
              _buildInfoCard([
                _buildInfoRow('Version', version),
                _buildDivider(),
                _buildInfoRow('Build', build),
              ]),
              SizedBox(height: AppSpacing.md),

              // Links
              _buildInfoCard([
                _buildLinkTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  isExternal: false,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LegalDocumentViewer(
                        title: 'Privacy Policy',
                        assetPath: 'assets/legal/privacy.md',
                      ),
                    ),
                  ),
                ),
                _buildDivider(),
                _buildLinkTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  isExternal: false,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LegalDocumentViewer(
                        title: 'Terms of Service',
                        assetPath: 'assets/legal/terms.md',
                      ),
                    ),
                  ),
                ),
                _buildDivider(),
                _buildLinkTile(
                  icon: Icons.code,
                  title: 'Open Source Licenses',
                  isExternal: false,
                  onTap: () => _showLicenses(context, version),
                ),
              ]),
              SizedBox(height: AppSpacing.md),

              // Developer info
              _buildInfoCard([
                _buildLinkTile(
                  icon: Icons.person_outline,
                  title: 'Meet the Developer',
                  isExternal: false,
                  onTap: () => _showDeveloperDialog(context, version),
                ),
              ]),
              SizedBox(height: AppSpacing.xl),

              // Copyright
              Center(
                child: Text(
                  '\u00a9 ${DateTime.now().year} The Accountant\nAll rights reserved.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ),
              SizedBox(height: AppSpacing.lg),

              // Made with love
              Center(
                child: Text(
                  'Made with love for personal finance',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppHeader() {
    return Column(
      children: [
        // App icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryAccent.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.account_balance_wallet,
            size: 50,
            color: Colors.white,
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        const Text(
          'The Accountant',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          'Your Personal Finance Companion',
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.glassBorder),
      ),
      // Transparent Material so any tile ink is visible over the coloured card.
      child: Material(
        type: MaterialType.transparency,
        borderRadius: AppSpacing.borderRadiusLg,
        clipBehavior: Clip.antiAlias,
        child: Column(children: children),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isExternal = true,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryAccent, size: 22),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        isExternal ? Icons.open_in_new : Icons.chevron_right,
        color: AppColors.textMuted,
        size: 18,
      ),
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.divider,
      indent: 56,
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showLicenses(BuildContext context, String version) {
    showLicensePage(
      context: context,
      applicationName: 'The Accountant',
      applicationVersion: version,
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.account_balance_wallet,
          size: 32,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showDeveloperDialog(BuildContext context, String version) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.primarySurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.glassBorder),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primaryAccent,
                    size: 22,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'About The Accountant',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg),

              // App icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryAccent.withValues(alpha: 0.3),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  size: 36,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: AppSpacing.sm),

              // Version
              Text(
                'Version: $version',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              SizedBox(height: AppSpacing.md),

              // Description
              Text(
                'A personal finance app with a focus\non privacy and beautiful UI/UX.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              SizedBox(height: AppSpacing.lg),

              // Developer label
              Text(
                'Developed & Maintained By:',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: AppSpacing.sm),

              // Developer button
              GestureDetector(
                onTap: () => _launchUrl('https://pranta.dev'),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryAccent.withValues(alpha: 0.3),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.link, color: Colors.white, size: 18),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        'Pranta Dutta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.lg),

              // Copyright
              Text(
                '\u00a9 ${DateTime.now().year} Pranta Dutta. All rights reserved.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              SizedBox(height: AppSpacing.lg),

              // Close button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primaryElevated,
                    foregroundColor: AppColors.textPrimary,
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppColors.glassBorder),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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

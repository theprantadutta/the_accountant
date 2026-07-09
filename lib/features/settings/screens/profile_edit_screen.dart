import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/services/backend_auth_service.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/features/authentication/providers/auth_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/settings/widgets/confirmation_dialog.dart';
import 'package:the_accountant/shared/widgets/glass_card.dart';
import 'package:the_accountant/shared/widgets/neo_button.dart';
import 'package:the_accountant/shared/widgets/neo_text_field.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _initializeControllers(AuthState authState) {
    if (_nameController.text.isEmpty && authState.displayName != null) {
      _nameController.text = authState.displayName!;
    }
    if (_emailController.text.isEmpty && authState.userEmail != null) {
      _emailController.text = authState.userEmail!;
    }
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      showErrorSnackBar(context, 'Name cannot be empty');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final backendAuth = BackendAuthService();
      await backendAuth.updateProfile(displayName: _nameController.text.trim());

      if (mounted) {
        showSuccessSnackBar(context, 'Profile updated successfully');
        setState(() {
          _hasChanges = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, 'Failed to update profile');
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleBack() {
    if (_hasChanges) {
      _showUnsavedChangesDialog();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    _initializeControllers(authState);

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showUnsavedChangesDialog();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Edit Profile'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBack,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Column(
                  children: [
                    _buildProfileAvatar(authState),
                    SizedBox(height: AppSpacing.xl),
                    _buildProfileForm(authState),
                    SizedBox(height: AppSpacing.lg),
                    _buildAccountInfo(authState),
                  ],
                ),
              ),
            ),
            _buildSaveBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveBar() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.sm,
        ),
        child: NeoButton(
          label: _hasChanges ? 'Save changes' : 'Saved',
          leadingIcon: _hasChanges ? Icons.check_rounded : Icons.check_circle,
          isExpanded: true,
          isLoading: _isLoading,
          onPressed: _hasChanges && !_isLoading ? _saveProfile : null,
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(AuthState authState) {
    final hasPhoto =
        authState.photoUrl != null && authState.photoUrl!.isNotEmpty;

    return Column(
      children: [
        Stack(
          children: [
            // Gradient ring around a dark inset so any avatar photo pops.
            Container(
              width: 108,
              height: 108,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryAccent.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryDark,
                ),
                child: ClipOval(
                  child: hasPhoto
                      ? Image.network(
                          authState.photoUrl!,
                          fit: BoxFit.cover,
                          width: 102,
                          height: 102,
                          errorBuilder: (_, _, _) => const Center(
                            child: Icon(
                              Icons.person,
                              size: 52,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.person,
                            size: 52,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  showInfoSnackBar(context, 'Photo upload coming soon');
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryDark, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryAccent.withValues(alpha: 0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (authState.isPremium) ...[
          SizedBox(height: AppSpacing.md),
          _buildPremiumChip(authState),
        ],
      ],
    );
  }

  Widget _buildPremiumChip(AuthState authState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.workspace_premium, color: Colors.amber, size: 16),
          const SizedBox(width: 6),
          Text(
            _formatSubscriptionTier(authState.subscriptionTier),
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm(AuthState authState) {
    return GlassCard(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.person_outline, 'Personal Information'),
          SizedBox(height: AppSpacing.lg),
          NeoTextField(
            controller: _nameController,
            label: 'Display name',
            prefixIcon: Icons.badge_outlined,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              final changed = value.trim() != (authState.displayName ?? '');
              if (changed != _hasChanges) {
                setState(() => _hasChanges = changed);
              }
            },
          ),
          SizedBox(height: AppSpacing.md),
          NeoTextField(
            controller: _emailController,
            label: 'Email address',
            prefixIcon: Icons.email_outlined,
            enabled: false,
            suffixIcon: Icon(
              Icons.verified,
              color: AppColors.success,
              size: 20,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Your email is used to sign in and can’t be changed here.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo(AuthState authState) {
    return GlassCard(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.badge_outlined, 'Account Information'),
          SizedBox(height: AppSpacing.lg),
          _buildInfoRow(
            'Member Since',
            authState.createdAt != null
                ? AppDateFormatter.formatDate(
                    authState.createdAt!,
                    ref.watch(dateFormatSettingProvider),
                  )
                : 'Unknown',
            Icons.calendar_today_outlined,
          ),
          _divider(),
          _buildInfoRow(
            'Subscription',
            authState.isPremium
                ? _formatSubscriptionTier(authState.subscriptionTier)
                : 'Free',
            Icons.workspace_premium_outlined,
            valueColor: authState.isPremium ? Colors.amber : null,
          ),
          _divider(),
          _buildInfoRow(
            'User ID',
            authState.userId ?? 'Unknown',
            Icons.fingerprint,
            isSecondary: true,
            onCopy: authState.userId != null
                ? () {
                    Clipboard.setData(ClipboardData(text: authState.userId!));
                    HapticFeedback.lightImpact();
                    showInfoSnackBar(context, 'User ID copied');
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryAccent, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _divider() => Padding(
    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
    child: Divider(color: AppColors.divider, height: 1),
  );

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
    bool isSecondary = false,
    VoidCallback? onCopy,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryAccent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryAccent, size: 20),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color:
                      valueColor ??
                      (isSecondary
                          ? AppColors.textMuted
                          : AppColors.textPrimary),
                  fontSize: isSecondary ? 12 : 14,
                  fontWeight: isSecondary ? FontWeight.normal : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (onCopy != null)
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(
              Icons.copy_rounded,
              color: AppColors.textMuted,
              size: 18,
            ),
            onPressed: onCopy,
          ),
      ],
    );
  }

  String _formatSubscriptionTier(String tier) {
    switch (tier.toLowerCase()) {
      case 'premiummonthly':
        return 'Premium Monthly';
      case 'premiumyearly':
        return 'Premium Yearly';
      case 'premiumlifetime':
        return 'Premium Lifetime';
      default:
        return tier;
    }
  }

  Future<void> _showUnsavedChangesDialog() async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Unsaved Changes',
      message: 'You have unsaved changes. Are you sure you want to leave?',
      cancelText: 'Stay',
      confirmText: 'Leave',
      isDangerous: true,
    );

    if (confirmed == true && mounted) {
      Navigator.pop(context);
    }
  }
}

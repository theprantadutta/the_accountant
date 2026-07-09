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

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  late TextEditingController _nameController;
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _initializeControllers(AuthState authState) {
    if (_nameController.text.isEmpty && authState.displayName != null) {
      _nameController.text = authState.displayName!;
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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    _initializeControllers(authState);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_hasChanges) {
              _showUnsavedChangesDialog();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _isLoading ? null : _saveProfile,
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryAccent,
                      ),
                    )
                  : Text(
                      'Save',
                      style: TextStyle(
                        color: AppColors.primaryAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // Profile Avatar
            _buildProfileAvatar(authState),
            SizedBox(height: AppSpacing.xxl),

            // Profile Form
            _buildProfileForm(authState),
            SizedBox(height: AppSpacing.xxl),

            // Account Info
            _buildAccountInfo(authState),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(AuthState authState) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGlow.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: authState.photoUrl != null && authState.photoUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                      authState.photoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  )
                : const Icon(Icons.person, size: 60, color: Colors.white),
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
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm(AuthState authState) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.glassBorder),
      ),
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.lg),

          // Display Name
          _buildTextField(
            controller: _nameController,
            label: 'Display Name',
            icon: Icons.person_outline,
            onChanged: (value) {
              setState(() => _hasChanges = value != authState.displayName);
            },
          ),
          SizedBox(height: AppSpacing.md),

          // Email (read-only)
          _buildReadOnlyField(
            value: authState.userEmail ?? 'Not set',
            label: 'Email Address',
            icon: Icons.email_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: AppColors.textPrimary),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppColors.textMuted),
          prefixIcon: Icon(icon, color: AppColors.textMuted),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassWhite.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: Icon(icon, color: AppColors.textMuted),
          title: Text(
            label,
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          subtitle: Text(
            value,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountInfo(AuthState authState) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.glassBorder),
      ),
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Information',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
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
          SizedBox(height: AppSpacing.md),

          _buildInfoRow(
            'Subscription',
            authState.isPremium
                ? _formatSubscriptionTier(authState.subscriptionTier)
                : 'Free',
            Icons.workspace_premium_outlined,
            valueColor: authState.isPremium ? Colors.amber : null,
          ),
          SizedBox(height: AppSpacing.md),

          _buildInfoRow(
            'User ID',
            authState.userId ?? 'Unknown',
            Icons.fingerprint,
            isSecondary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
    bool isSecondary = false,
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
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
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

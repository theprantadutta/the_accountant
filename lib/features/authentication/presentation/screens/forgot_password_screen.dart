import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/services/backend_auth_service.dart';
import 'package:the_accountant/core/themes/app_animations.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/features/authentication/presentation/widgets/auth_background.dart';
import 'package:the_accountant/features/authentication/presentation/widgets/auth_brand_header.dart';
import 'package:the_accountant/shared/widgets/glass_card.dart';
import 'package:the_accountant/shared/widgets/neo_button.dart';
import 'package:the_accountant/shared/widgets/neo_text_field.dart';

/// Two-step password reset:
///   1. Enter email  -> backend emails a 6-digit code
///   2. Enter code + new password -> backend sets the new password
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.initialEmail});

  final String? initialEmail;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _authService = BackendAuthService();
  final _requestFormKey = GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  int _step = 0; // 0 = request code, 1 = reset password
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.initialEmail != null) {
      _emailController.text = widget.initialEmail!;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _requestCode() async {
    if (!_requestFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });
    HapticFeedback.mediumImpact();

    try {
      await _authService.forgotPassword(_emailController.text);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _step = 1;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = _clean(e);
      });
    }
  }

  Future<void> _resetPassword() async {
    if (!_resetFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });
    HapticFeedback.mediumImpact();

    try {
      await _authService.resetPassword(
        email: _emailController.text,
        code: _codeController.text,
        newPassword: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password reset successfully. Please sign in.',
            style: AppTypography.bodyMedium,
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusMd,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = _clean(e);
      });
    }
  }

  String _clean(Object e) => e
      .toString()
      .replaceFirst('Exception: ', '')
      .replaceFirst('Exception: ', '');

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              if (_step == 1) {
                setState(() {
                  _step = 0;
                  _error = null;
                });
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingScreen,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    kToolbarHeight -
                    48,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuthBrandHeader(
                      icon: _step == 0
                          ? Icons.lock_reset_rounded
                          : Icons.mark_email_read_rounded,
                      title: _step == 0
                          ? 'Forgot Password'
                          : 'Check Your Email',
                      subtitle: _step == 0
                          ? 'Enter your email and we\'ll send you a code to reset '
                                'your password.'
                          : 'We sent a 6-digit code to ${_emailController.text.trim()}. '
                                'Enter it below with your new password.',
                      showWordmark: false,
                    ),

                    AppSpacing.gapXxxl,

                    AnimatedSwitcher(
                      duration: AppAnimations.normal,
                      child: _step == 0
                          ? _buildRequestForm()
                          : _buildResetForm(),
                    ),

                    if (_error != null) ...[
                      AppSpacing.gapLg,
                      _buildErrorMessage(_error!),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestForm() {
    return GlassCard(
      key: const ValueKey('request'),
      padding: AppSpacing.paddingXl,
      enableBlur: true,
      blurAmount: 14,
      child: Form(
        key: _requestFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NeoTextField(
              controller: _emailController,
              label: 'Email Address',
              hint: 'Enter your email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _requestCode(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            AppSpacing.gapXl,
            NeoButton(
              label: 'Send Reset Code',
              onPressed: _isLoading ? null : _requestCode,
              isLoading: _isLoading,
              isExpanded: true,
              size: NeoButtonSize.large,
              trailingIcon: Icons.arrow_forward_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetForm() {
    return GlassCard(
      key: const ValueKey('reset'),
      padding: AppSpacing.paddingXl,
      enableBlur: true,
      blurAmount: 14,
      child: Form(
        key: _resetFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NeoTextField(
              controller: _codeController,
              label: 'Reset Code',
              hint: '6-digit code',
              prefixIcon: Icons.pin_outlined,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the code';
                }
                if (value.length != 6) {
                  return 'The code is 6 digits';
                }
                return null;
              },
            ),
            AppSpacing.gapMd,
            NeoTextField(
              controller: _passwordController,
              label: 'New Password',
              hint: 'Create a new password',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a new password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
            ),
            AppSpacing.gapMd,
            NeoTextField(
              controller: _confirmController,
              label: 'Confirm Password',
              hint: 'Re-enter your new password',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _resetPassword(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            AppSpacing.gapXl,
            NeoButton(
              label: 'Reset Password',
              onPressed: _isLoading ? null : _resetPassword,
              isLoading: _isLoading,
              isExpanded: true,
              size: NeoButtonSize.large,
            ),
            AppSpacing.gapSm,
            Center(
              child: TextButton(
                onPressed: _isLoading ? null : _requestCode,
                child: Text(
                  'Resend code',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primaryAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage(String error) {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: AppSpacing.iconSm,
          ),
          AppSpacing.gapHMd,
          Expanded(
            child: Text(
              error,
              style: AppTypography.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

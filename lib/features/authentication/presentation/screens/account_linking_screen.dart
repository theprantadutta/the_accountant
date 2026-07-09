import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_animations.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/features/authentication/presentation/widgets/auth_background.dart';
import 'package:the_accountant/features/authentication/presentation/widgets/auth_brand_header.dart';
import 'package:the_accountant/features/authentication/providers/auth_provider.dart';
import 'package:the_accountant/shared/widgets/glass_card.dart';
import 'package:the_accountant/shared/widgets/neo_button.dart';
import 'package:the_accountant/shared/widgets/neo_text_field.dart';

class AccountLinkingScreen extends ConsumerStatefulWidget {
  const AccountLinkingScreen({super.key});

  @override
  ConsumerState<AccountLinkingScreen> createState() =>
      _AccountLinkingScreenState();
}

class _AccountLinkingScreenState extends ConsumerState<AccountLinkingScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.long,
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _linkAccount() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authProvider.notifier)
          .linkGoogleAccount(_passwordController.text);
    }
    HapticFeedback.lightImpact();
  }

  void _cancel() {
    ref.read(authProvider.notifier).cancelLinking();
    HapticFeedback.lightImpact();
  }

  Widget _entrance({
    required double start,
    required double end,
    required Widget child,
  }) {
    final curved = CurvedAnimation(
      parent: _animationController,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.25),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingScreen,
            child: Form(
              key: _formKey,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      48,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _entrance(
                        start: 0.0,
                        end: 0.6,
                        child: const AuthBrandHeader(
                          icon: Icons.link_rounded,
                          title: 'Link Your Account',
                          subtitle:
                              'An account with this email already exists. '
                              'Enter your password to link your Google account.',
                          showWordmark: false,
                        ),
                      ),

                      AppSpacing.gapXxxl,

                      _entrance(
                        start: 0.3,
                        end: 0.8,
                        child: _buildForm(authState),
                      ),

                      AppSpacing.gapLg,

                      _entrance(
                        start: 0.5,
                        end: 1.0,
                        child: TextButton(
                          onPressed: authState.isLoading ? null : _cancel,
                          child: Text(
                            'Cancel',
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),

                      if (authState.error != null) ...[
                        AppSpacing.gapSm,
                        _buildErrorMessage(authState.error!),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(AuthState authState) {
    return GlassCard(
      padding: AppSpacing.paddingXl,
      enableBlur: true,
      blurAmount: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInfoBox(),
          AppSpacing.gapLg,
          NeoTextField(
            controller: _passwordController,
            label: 'Password',
            hint: 'Enter your password',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _linkAccount(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          AppSpacing.gapXl,
          NeoButton(
            label: 'Link Account',
            onPressed: authState.isLoading ? null : _linkAccount,
            isLoading: authState.isLoading,
            isExpanded: true,
            size: NeoButtonSize.large,
            leadingIcon: Icons.link_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: AppColors.info,
            size: AppSpacing.iconSm,
          ),
          AppSpacing.gapHMd,
          Expanded(
            child: Text(
              'After linking, you can use either email/password or Google to '
              'sign in.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
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

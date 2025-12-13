import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/authentication/providers/auth_provider.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/core/utils/animation_utils.dart';

class AccountLinkingScreen extends ConsumerStatefulWidget {
  const AccountLinkingScreen({super.key});

  @override
  ConsumerState<AccountLinkingScreen> createState() => _AccountLinkingScreenState();
}

class _AccountLinkingScreenState extends ConsumerState<AccountLinkingScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _linkAccount() {
    if (_formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).linkGoogleAccount(
        _passwordController.text,
      );
    }
    HapticFeedback.lightImpact();
  }

  void _cancel() {
    ref.read(authProvider.notifier).cancelLinking();
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Icon
                  AnimationUtils.scaleTransition(
                    animation: _fadeAnimation,
                    child: Center(
                      child: AppTheme.gradientContainer(
                        gradient: AppTheme.primaryGradient,
                        width: 100,
                        height: 100,
                        borderRadius: BorderRadius.circular(32),
                        child: const Icon(
                          Icons.link,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Title
                  AnimationUtils.slideTransition(
                    animation: _slideAnimation,
                    begin: const Offset(0, 0.5),
                    child: Column(
                      children: [
                        const Text(
                          'Link Your Account',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'An account with this email already exists. Enter your password to link your Google account.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Info Box
                  AnimationUtils.fadeTransition(
                    animation: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'After linking, you can use either email/password or Google to sign in.',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Password Field
                  AnimationUtils.slideTransition(
                    animation: AnimationUtils.createStaggeredAnimation(
                      controller: _animationController,
                      startFraction: 0.2,
                      endFraction: 0.5,
                    ),
                    begin: const Offset(0, 0.5),
                    child: AppTheme.glassmorphicContainer(
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Colors.white70,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(20),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Link Account Button
                  AnimationUtils.scaleTransition(
                    animation: AnimationUtils.createStaggeredAnimation(
                      controller: _animationController,
                      startFraction: 0.3,
                      endFraction: 0.6,
                    ),
                    child: AppTheme.gradientContainer(
                      gradient: AppTheme.primaryGradient,
                      height: 56,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: authState.isLoading ? null : _linkAccount,
                          child: Center(
                            child: authState.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Link Account',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Cancel Button
                  AnimationUtils.fadeTransition(
                    animation: _fadeAnimation,
                    child: TextButton(
                      onPressed: authState.isLoading ? null : _cancel,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  // Error Message
                  if (authState.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.3),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                authState.error!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

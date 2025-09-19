import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/authentication/presentation/screens/sign_up_screen.dart';
import 'package:the_accountant/features/authentication/providers/auth_provider.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/core/utils/animation_utils.dart';

import '../../../../shared/widgets/main_navigation_container.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late AnimationController _animationController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
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

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceOut,
    );

    _floatingAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authProvider.notifier)
          .signInWithEmailAndPassword(
            _emailController.text,
            _passwordController.text,
          );
    }
    HapticFeedback.lightImpact();
  }

  void _signInWithGoogle() {
    ref.read(authProvider.notifier).signInWithGoogle();
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Listen to authentication state changes
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated && next.user != null) {
        // Navigate to main app
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, _) =>
                const MainNavigationContainer(),
            transitionsBuilder: (context, animation, _, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });

    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // Floating App Icon
                  AnimatedBuilder(
                    animation: _floatingAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatingAnimation.value),
                        child: AnimationUtils.scaleTransition(
                          animation: _scaleAnimation,
                          child: Center(
                            child: AppTheme.gradientContainer(
                              gradient: AppTheme.primaryGradient,
                              width: 100,
                              height: 100,
                              borderRadius: BorderRadius.circular(32),
                              child: const Icon(
                                Icons.account_balance_wallet,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Welcome Text
                  AnimationUtils.slideTransition(
                    animation: _slideAnimation,
                    begin: const Offset(0, 0.5),
                    child: Column(
                      children: [
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to continue your financial journey',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Login Form
                  Expanded(
                    child: AnimationUtils.slideTransition(
                      animation: AnimationUtils.createStaggeredAnimation(
                        controller: _animationController,
                        startFraction: 0.1,
                        endFraction: 0.4,
                      ),
                      begin: const Offset(-1, 0),
                      child: AppTheme.glassmorphicContainer(
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: TextStyle(color: Colors.white70),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Colors.white70,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Password Field
                  AnimationUtils.slideTransition(
                    animation: AnimationUtils.createStaggeredAnimation(
                      controller: _animationController,
                      startFraction: 0.2,
                      endFraction: 0.5,
                    ),
                    begin: const Offset(1, 0),
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
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Sign In Button
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
                          onTap: authState.isLoading ? null : _signIn,
                          child: Center(
                            child: authState.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Sign In',
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

                  // Divider
                  AnimationUtils.fadeTransition(
                    animation: _fadeAnimation,
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Google Sign In Button
                  AnimationUtils.scaleTransition(
                    animation: AnimationUtils.createStaggeredAnimation(
                      controller: _animationController,
                      startFraction: 0.4,
                      endFraction: 0.7,
                    ),
                    child: AppTheme.glassmorphicContainer(
                      height: 56,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: authState.isLoading ? null : _signInWithGoogle,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.g_mobiledata,
                                color: Colors.red,
                                size: 28,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Continue with Google',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Sign Up Link
                  AnimationUtils.fadeTransition(
                    animation: _fadeAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, _) =>
                                    const SignUpScreen(),
                                transitionsBuilder:
                                    (context, animation, _, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1.0, 0.0),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      );
                                    },
                              ),
                            );
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Color(0xFF667eea),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Error Message
                  if (authState.error != null)
                    AnimationUtils.slideTransition(
                      animation: _slideAnimation,
                      begin: const Offset(0, 1),
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
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
                            const Icon(Icons.error_outline, color: Colors.red),
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

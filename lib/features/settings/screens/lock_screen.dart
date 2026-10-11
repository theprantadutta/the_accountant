import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/core/services/biometric_service.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

class LockScreen extends StatefulWidget {
  final VoidCallback onUnlocked;

  const LockScreen({super.key, required this.onUnlocked});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  bool _isAuthenticating = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Attempt authentication immediately on show
    WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
      _errorMessage = null;
    });

    try {
      final success = await BiometricService().authenticate();
      if (success) {
        widget.onUnlocked();
      } else {
        setState(() {
          _errorMessage = 'Authentication failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() => _isAuthenticating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: c.base,
        body: SunriseBackground(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SunriseSpace.screenX,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        gradient: c.gradient,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: c.glow,
                            blurRadius: 32,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Icon(
                        Symbols.lock_rounded,
                        size: 44,
                        fill: 1,
                        color: c.onFill,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      L10n.of(context).settingsAppLocked,
                      style: SunriseType.largeTitle.copyWith(color: c.ink),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      L10n.of(context).settingsUnlockToAccessTheAccountant,
                      textAlign: TextAlign.center,
                      style: SunriseType.body.copyWith(color: c.muted),
                    ),
                    const SizedBox(height: 40),
                    if (_errorMessage != null) ...[
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: SunriseType.label.copyWith(color: c.negative),
                      ),
                      const SizedBox(height: 20),
                    ],
                    SizedBox(
                      width: 240,
                      child: SunriseButton(
                        label: _isAuthenticating
                            ? 'Authenticating...'
                            : 'Unlock',
                        icon: Symbols.fingerprint_rounded,
                        loading: _isAuthenticating,
                        onPressed: _isAuthenticating ? null : _authenticate,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

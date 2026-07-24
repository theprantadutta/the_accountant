import 'package:flutter/material.dart';
import 'package:the_accountant/core/utils/responsive.dart';
import 'package:the_accountant/shared/widgets/app_background.dart';

/// Ambient, animated background for the authentication screens.
///
/// Thin alias over the shared [AppBackground], plus a max-width cap so the auth
/// content (forms, wordmark) stays a readable centered column on tablet/desktop
/// while the gradient behind it remains full-bleed.
class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      AppBackground(child: AdaptiveWidth(maxWidth: 500, child: child));
}

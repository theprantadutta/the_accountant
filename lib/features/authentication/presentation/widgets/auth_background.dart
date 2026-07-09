import 'package:flutter/material.dart';
import 'package:the_accountant/shared/widgets/app_background.dart';

/// Ambient, animated background for the authentication screens.
///
/// Thin alias over the shared [AppBackground] so the auth flow and the rest of
/// the app share one implementation.
class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => AppBackground(child: child);
}

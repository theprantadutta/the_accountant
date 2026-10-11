import 'package:flutter/material.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise_background.dart';

/// The backdrop behind every route: the short Sunrise wash on the base colour.
///
/// Mounted once in `MaterialApp.builder`. Scaffolds are transparent, so a
/// screen that has not painted its own wash still sits on Sunrise; tab roots
/// paint the tall wash over this. (It used to be drifting indigo orbs.)
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child, this.tall = false});

  final Widget child;
  final bool tall;

  @override
  Widget build(BuildContext context) =>
      SunriseBackground(tall: tall, child: child);
}

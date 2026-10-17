import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_colors.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_tokens.dart';
import 'package:the_accountant/shared/widgets/sunrise/headers.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise_background.dart';

/// Caps a phone-shaped column at [SunriseSpace.maxContentWidth] and centres
/// it, so tablets get a comfortable measure instead of stretched cards.
class SunriseContentWidth extends StatelessWidget {
  const SunriseContentWidth({
    super.key,
    required this.child,
    this.maxWidth = SunriseSpace.maxContentWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}

/// Keeps a screen's body at a phone's measure on a wide display, without
/// changing it anywhere else.
///
/// For screens built on a plain [Scaffold]. Their bodies were written for a
/// phone and stretched edge to edge on a tablet in landscape, stranding a
/// row's trailing icons a thousand points from its name. Unlike
/// [SunriseContentWidth] this passes tight constraints, so a body that sizes
/// itself to its parent lays out exactly as it does on a phone; and below
/// the cap it returns the body untouched.
class CappedBody extends StatelessWidget {
  const CappedBody({
    super.key,
    required this.child,
    this.maxWidth = SunriseSpace.maxContentWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth <= maxWidth) return child;
      return Center(
        child: SizedBox(
          width: maxWidth,
          height: constraints.maxHeight,
          child: child,
        ),
      );
    },
  );
}

/// A pushed screen: short wash, [PushHeader], scrolling body, optional sticky
/// bottom action over a fade.
///
/// [children] are laid out in a padded list. Pass [body] instead to take over
/// the area under the header entirely (lists with their own scrolling).
class SunrisePushPage extends StatelessWidget {
  const SunrisePushPage({
    super.key,
    required this.title,
    this.subtitle,
    this.children,
    this.body,
    this.actions = const [],
    this.bottom,
    this.close = false,
    this.onBack,
    this.padding = const EdgeInsets.fromLTRB(
      SunriseSpace.screenX,
      4,
      SunriseSpace.screenX,
      32,
    ),
    this.floatingActionButton,
    this.onRefresh,
    this.header,
  }) : assert(children != null || body != null);

  final String title;
  final String? subtitle;
  final List<Widget>? children;
  final Widget? body;
  final List<Widget> actions;

  /// Sticky content pinned to the bottom (usually a [SunriseButton]).
  final Widget? bottom;
  final bool close;
  final VoidCallback? onBack;
  final EdgeInsetsGeometry padding;
  final Widget? floatingActionButton;
  final Future<void> Function()? onRefresh;

  /// Replaces the [PushHeader] (rare: screens with a bespoke top).
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    Widget content =
        body ??
        ListView(
          padding: padding.add(
            EdgeInsets.only(bottom: bottom == null ? 0 : 96),
          ),
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: children!,
        );
    if (onRefresh != null && body == null) {
      content = RefreshIndicator(
        onRefresh: onRefresh!,
        color: c.accent,
        backgroundColor: c.surface,
        child: content,
      );
    }

    return SunriseBackground(
      tall: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: floatingActionButton,
        body: SafeArea(
          bottom: false,
          child: SunriseContentWidth(
            child: Stack(
              children: [
                Column(
                  children: [
                    header ??
                        PushHeader(
                          title: title,
                          subtitle: subtitle,
                          actions: actions,
                          close: close,
                          onBack: onBack,
                        ),
                    Expanded(child: content),
                  ],
                ),
                if (bottom != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: StickyBottom(child: bottom!),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A bottom action over a fade into the base colour.
class StickyBottom extends StatelessWidget {
  const StickyBottom({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final inset = MediaQuery.paddingOf(context).bottom;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [c.base.withValues(alpha: 0), c.base, c.base],
          stops: const [0, .35, 1],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          SunriseSpace.screenX,
          28,
          SunriseSpace.screenX,
          inset > 0 ? inset + 4 : 16,
        ),
        child: child,
      ),
    );
  }
}

/// A tab root: tall wash, safe top, content capped for tablets, with room at
/// the bottom for the floating tab bar.
class SunriseTabPage extends StatelessWidget {
  const SunriseTabPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => SunriseBackground(
    child: SafeArea(bottom: false, child: SunriseContentWidth(child: child)),
  );
}

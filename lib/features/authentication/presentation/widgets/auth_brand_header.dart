import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// The top of the auth screens: the app's rounded gradient tile (the wallet
/// glyph, or a screen-specific icon), the wordmark, then [title] and
/// [subtitle].
class AuthBrandHeader extends StatelessWidget {
  const AuthBrandHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.gradient,
    this.glowColor,
    this.floatingAnimation,
    this.showWordmark = true,
  });

  /// Drawn on the tile. The wallet icon draws the real logo glyph instead.
  final IconData icon;
  final String title;
  final String subtitle;

  /// Defaults to the brand gradient of the accent in force.
  final Gradient? gradient;
  final Color? glowColor;

  /// Optional vertical offset so the tile gently floats.
  final Animation<double>? floatingAnimation;

  final bool showWordmark;

  static final _logoIcons = {
    Icons.account_balance_wallet_rounded,
    Icons.account_balance_wallet,
    Icons.account_balance_wallet_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Column(
      children: [
        _logo(context),
        const SizedBox(height: 22),
        if (showWordmark) ...[
          Text(
            L10n.of(context).authTheAccountant.toUpperCase(),
            style: SunriseType.overline.copyWith(
              color: c.accentText,
              letterSpacing: 3,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          style: SunriseType.heroTitle.copyWith(color: c.ink),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: SunriseType.body.copyWith(color: c.muted),
        ),
      ],
    );
  }

  Widget _logo(BuildContext context) {
    final c = context.sunrise;
    final isLogo = _logoIcons.contains(icon);
    final tile = Container(
      width: 88,
      height: 88,
      padding: EdgeInsets.all(isLogo ? 18 : 0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: gradient ?? c.gradient,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 18),
            blurRadius: 36,
            spreadRadius: -12,
            color: (glowColor ?? c.glow).withValues(alpha: .7),
          ),
        ],
      ),
      child: isLogo
          ? Image.asset('assets/logo/glyph-white-256.png')
          : Icon(icon, size: 40, color: c.onFill, fill: 1),
    );

    if (floatingAnimation == null) return Center(child: tile);
    return Center(
      child: AnimatedBuilder(
        animation: floatingAnimation!,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, floatingAnimation!.value),
          child: child,
        ),
        child: tile,
      ),
    );
  }
}

/// A full-width provider button: "Continue with Google", "Continue with
/// Apple". Surface fill with a hairline, the logo, and the label.
class AuthProviderButton extends StatelessWidget {
  const AuthProviderButton({
    super.key,
    required this.logo,
    required this.label,
    required this.onPressed,
  });

  final Widget logo;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Pressable(
      onTap: onPressed,
      haptic: true,
      semanticLabel: label,
      child: AnimatedOpacity(
        duration: SunriseMotion.press,
        opacity: onPressed == null ? .5 : 1,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: c.isDark ? const Color(0xFF2B1F19) : c.surface,
            borderRadius: SunriseRadius.buttonAll,
            border: Border.all(
              color: c.isDark ? const Color(0x14FFFFFF) : c.tabBarBorder,
            ),
            boxShadow: c.isDark ? null : c.cardShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              logo,
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SunriseType.button.copyWith(color: c.ink),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "or continue with", between hairlines.
class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final line = Expanded(child: Container(height: 1, color: c.divider));
    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            label,
            style: SunriseType.label.copyWith(color: c.subtle),
          ),
        ),
        line,
      ],
    );
  }
}

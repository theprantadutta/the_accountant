import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// The settings tiles, now thin adapters over the Sunrise [SettingsRow] and
/// [SettingsGroup] so every settings-style screen shares one look.

/// Icon tile used in settings rows.
class SettingsIconBox extends StatelessWidget {
  const SettingsIconBox({super.key, required this.icon, this.color});

  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) => IconTile(
    icon: icon,
    color: color ?? context.sunrise.accent,
    size: 36,
    radius: SunriseRadius.iconTileSm,
    iconSize: 20,
  );
}

/// A row that opens another screen.
class SettingsNavigationTile extends StatelessWidget {
  const SettingsNavigationTile({
    super.key,
    required this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.trailing,
    this.showChevron = true,
  });

  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool showChevron;

  @override
  Widget build(BuildContext context) => SettingsRow(
    icon: icon,
    iconColor: iconColor,
    title: title,
    subtitle: subtitle,
    trailing: showChevron ? SettingsTrailing.chevron : SettingsTrailing.none,
    trailingWidget: trailing,
    onTap: () {
      HapticFeedback.selectionClick();
      onTap();
    },
  );
}

/// A row that performs an action in place. A negative [iconColor] reads as
/// destructive.
class SettingsActionTile extends StatelessWidget {
  const SettingsActionTile({
    super.key,
    required this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final destructive = iconColor != null && iconColor == AppColors.error;
    return SettingsRow(
      icon: icon,
      iconColor: destructive ? c.negative : iconColor,
      title: title,
      subtitle: subtitle,
      destructive: destructive,
      trailing: SettingsTrailing.none,
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
    );
  }
}

/// A row with a toggle.
class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => SettingsRow.toggle(
    icon: icon,
    iconColor: iconColor,
    title: title,
    subtitle: subtitle,
    value: value,
    onChanged: onChanged,
  );
}

/// A row with a slider underneath.
class SettingsSliderTile extends StatelessWidget {
  const SettingsSliderTile({
    super.key,
    required this.icon,
    this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
  });

  final IconData icon;
  final Color? iconColor;
  final String title;
  final String subtitle;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SettingsRow(
        icon: icon,
        iconColor: iconColor,
        title: title,
        subtitle: subtitle,
        trailing: SettingsTrailing.none,
      ),
      Padding(
        padding: const EdgeInsetsDirectional.only(start: 40, bottom: 6),
        child: Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ),
    ],
  );
}

/// A labelled card of settings rows.
class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, required this.title, required this.tiles});

  final String title;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: SunriseSpace.section),
    child: SettingsGroup(
      label: title,
      // The group draws its own hairlines.
      children: tiles.where((t) => t is! SettingsDivider).toList(),
    ),
  );
}

/// A hairline between settings rows.
class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, thickness: 1, color: context.sunrise.divider);
}

/// "PRO" on premium-only entries.
class PremiumBadge extends StatelessWidget {
  const PremiumBadge({super.key});

  @override
  Widget build(BuildContext context) => SunrisePill(
    label: L10n.of(context).settingsPro,
    gradient: context.sunrise.gradient,
    fontSize: 10,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
  );
}

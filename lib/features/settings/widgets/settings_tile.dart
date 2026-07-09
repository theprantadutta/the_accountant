import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';

/// Icon container used in all settings tiles
class SettingsIconBox extends StatelessWidget {
  const SettingsIconBox({super.key, required this.icon, this.color});

  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primaryAccent;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: effectiveColor, size: 22),
    );
  }
}

/// A navigation tile that opens another screen
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
  Widget build(BuildContext context) {
    return ListTile(
      leading: SettingsIconBox(icon: icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            )
          : null,
      trailing:
          trailing ??
          (showChevron
              ? Icon(Icons.chevron_right, color: AppColors.textMuted)
              : null),
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
    );
  }
}

/// An action tile that performs an action (no navigation indicator)
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
    return ListTile(
      leading: SettingsIconBox(icon: icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          color: iconColor ?? AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            )
          : null,
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
    );
  }
}

/// A tile with a toggle switch
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
  Widget build(BuildContext context) {
    return ListTile(
      leading: SettingsIconBox(icon: icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            )
          : null,
      trailing: Switch(
        value: value,
        onChanged: (newValue) {
          HapticFeedback.lightImpact();
          onChanged(newValue);
        },
        activeTrackColor: AppColors.primaryAccent.withValues(alpha: 0.5),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryAccent;
          }
          return AppColors.textMuted;
        }),
      ),
    );
  }
}

/// A tile with a slider control
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: SettingsIconBox(icon: icon, color: iconColor),
          title: Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 56,
            right: AppSpacing.md,
            bottom: AppSpacing.sm,
          ),
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.primaryAccent,
              inactiveTrackColor: AppColors.glassWhite,
              thumbColor: AppColors.primaryAccent,
              overlayColor: AppColors.primaryAccent.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

/// A card that groups settings tiles with a header
class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, required this.title, required this.tiles});

  final String title;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.sm,
            top: AppSpacing.lg,
            bottom: AppSpacing.sm,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: AppSpacing.borderRadiusLg,
            border: Border.all(color: AppColors.glassBorder),
          ),
          // Transparent Material in front of the decorated background so the
          // ListTiles' ink splashes are visible (and clipped to the rounded
          // corners) instead of being hidden by the Container's color.
          child: Material(
            type: MaterialType.transparency,
            borderRadius: AppSpacing.borderRadiusLg,
            clipBehavior: Clip.antiAlias,
            child: Column(children: _buildTilesWithDividers()),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTilesWithDividers() {
    final result = <Widget>[];
    for (var i = 0; i < tiles.length; i++) {
      result.add(tiles[i]);
      if (i < tiles.length - 1) {
        result.add(const SettingsDivider());
      }
    }
    return result;
  }
}

/// Divider used between settings tiles
class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.divider,
      indent: 56,
    );
  }
}

/// Premium badge shown on premium-only features
class PremiumBadge extends StatelessWidget {
  const PremiumBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'PRO',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

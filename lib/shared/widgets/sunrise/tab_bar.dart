import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_colors.dart';
import 'package:the_accountant/core/themes/sunrise/sunrise_tokens.dart';
import 'package:the_accountant/shared/widgets/sunrise/pressable.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise_background.dart';

/// One destination in the [SunriseTabBar].
class SunriseTabItem {
  const SunriseTabItem({
    required this.icon,
    required this.label,
    this.key,
    this.badge = false,
  });

  final IconData icon;
  final String label;

  /// For the walkthrough to point at.
  final GlobalKey? key;

  /// Show an unread dot.
  final bool badge;
}

/// The frosted five-slot tab bar: two tabs, the gradient Add pill, two tabs.
class SunriseTabBar extends StatelessWidget {
  const SunriseTabBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.onAdd,
    required this.addLabel,
    this.addKey,
  }) : assert(items.length == 4, 'two tabs either side of Add');

  final List<SunriseTabItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAdd;
  final String addLabel;
  final GlobalKey? addKey;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    final bottom = MediaQuery.paddingOf(context).bottom;
    return SunriseGlass(
      color: c.tabBar,
      border: Border(top: BorderSide(color: c.tabBarBorder)),
      child: Padding(
        padding: EdgeInsets.only(top: 8, bottom: bottom > 0 ? bottom : 10),
        child: SizedBox(
          height: 52,
          child: Row(
            children: [
              _tab(context, 0),
              _tab(context, 1),
              Expanded(child: _AddButton(onTap: onAdd, label: addLabel, key: addKey)),
              _tab(context, 2),
              _tab(context, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tab(BuildContext context, int i) {
    final c = context.sunrise;
    final item = items[i];
    final active = i == currentIndex;
    final color = active ? c.accent : c.faint;
    return Expanded(
      child: Semantics(
        selected: active,
        button: true,
        label: item.label,
        child: Pressable(
          key: item.key,
          onTap: () {
            HapticFeedback.selectionClick();
            onTap(i);
          },
          scale: .92,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(end: active ? 1 : 0),
                    duration: SunriseMotion.tab,
                    builder: (_, fill, _) => Icon(
                      item.icon,
                      size: 26,
                      color: color,
                      fill: fill,
                    ),
                  ),
                  if (item.badge)
                    PositionedDirectional(
                      top: 0,
                      end: -2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: c.negative,
                          shape: BoxShape.circle,
                          border: Border.all(color: c.base, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: SunriseType.tabLabel.copyWith(
                  color: color,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({super.key, required this.onTap, required this.label});

  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return Semantics(
      button: true,
      label: label,
      child: Pressable(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        scale: .92,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 30,
              decoration: BoxDecoration(
                gradient: c.gradient,
                borderRadius: BorderRadius.circular(10),
                boxShadow: c.selectedShadow,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Symbols.add_rounded,
                color: Colors.white,
                size: 22,
                weight: 600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: SunriseType.tabLabel.copyWith(color: c.faint),
            ),
          ],
        ),
      ),
    );
  }
}

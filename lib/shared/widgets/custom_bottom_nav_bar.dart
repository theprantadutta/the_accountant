import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/themes/app_animations.dart';

/// A modern floating bottom navigation bar with glassmorphic styling.
///
/// Features:
/// - Floating pill design (not attached to edges)
/// - Glass background with blur effect
/// - Active indicator with glowing pill
/// - Icons animate (scale + color) on selection
/// - Center button with special styling
/// - Subtle shadow and glow effects
class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavItem> items;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _controllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        duration: AppAnimations.fast,
        vsync: this,
      ),
    );

    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 1.15).animate(
        CurvedAnimation(parent: controller, curve: AppAnimations.spring),
      );
    }).toList();

    // Start animation for current index
    if (widget.currentIndex < _controllers.length) {
      _controllers[widget.currentIndex].forward();
    }
  }

  @override
  void didUpdateWidget(CustomBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      // Animate out old selection
      if (oldWidget.currentIndex < _controllers.length) {
        _controllers[oldWidget.currentIndex].reverse();
      }
      // Animate in new selection
      if (widget.currentIndex < _controllers.length) {
        _controllers[widget.currentIndex].forward();
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleTap(int index) {
    if (index != widget.currentIndex) {
      HapticFeedback.lightImpact();
      widget.onTap(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: AppSpacing.lg + MediaQuery.of(context).padding.bottom,
      ),
      child: ClipRRect(
        borderRadius: AppSpacing.borderRadiusXxxl,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primarySurface.withValues(alpha: 0.9),
                  AppColors.primarySurface.withValues(alpha: 0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: AppSpacing.borderRadiusXxxl,
              border: Border.all(
                color: AppColors.glassBorder,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withValues(alpha: 0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: AppColors.primaryAccent.withValues(alpha: 0.1),
                  blurRadius: 30,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(widget.items.length, (index) {
                final item = widget.items[index];
                final isSelected = widget.currentIndex == index;
                final isCenterItem = index == 2; // AI Assistant center button

                if (isCenterItem) {
                  return _buildCenterButton(item, index, isSelected);
                }

                return _buildNavItem(item, index, isSelected);
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(NavItem item, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => _handleTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        height: 72,
        child: AnimatedBuilder(
          animation: _scaleAnimations[index],
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon container with animated background
                AnimatedContainer(
                  duration: AppAnimations.fast,
                  curve: AppAnimations.easeOut,
                  width: 44,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              AppColors.primaryAccent.withValues(alpha: 0.3),
                              AppColors.primaryAccent.withValues(alpha: 0.1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                        : null,
                    borderRadius: AppSpacing.borderRadiusMd,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primaryGlow.withValues(alpha: 0.3),
                              blurRadius: 12,
                              spreadRadius: -2,
                            ),
                          ]
                        : null,
                  ),
                  child: Transform.scale(
                    scale: isSelected ? _scaleAnimations[index].value : 1.0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: AppAnimations.fast,
                          child: Icon(
                            isSelected ? item.activeIcon : item.icon,
                            key: ValueKey('nav_$index\_$isSelected'),
                            color: isSelected
                                ? AppColors.primaryAccent
                                : AppColors.textMuted,
                            size: AppSpacing.iconSm,
                          ),
                        ),
                        // Badge
                        if (item.badge != null)
                          Positioned(
                            right: 6,
                            top: 4,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              constraints: const BoxConstraints(
                                minWidth: 14,
                                minHeight: 14,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: AppSpacing.borderRadiusFull,
                                border: Border.all(
                                  color: AppColors.primarySurface,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                item.badge!,
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textPrimary,
                                  fontSize: 8,
                                  height: 1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                AppSpacing.gapXs,
                // Label
                AnimatedDefaultTextStyle(
                  duration: AppAnimations.fast,
                  curve: AppAnimations.easeOut,
                  style: AppTypography.labelSmall.copyWith(
                    color: isSelected
                        ? AppColors.primaryAccent
                        : AppColors.textMuted,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 10,
                  ),
                  child: Text(
                    item.label,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCenterButton(NavItem item, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => _handleTap(index),
      child: AnimatedBuilder(
        animation: _scaleAnimations[index],
        builder: (context, child) {
          return Transform.scale(
            scale: isSelected ? 1.0 : _scaleAnimations[index].value,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? AppColors.accentGradient
                    : AppColors.primaryGradient,
                borderRadius: AppSpacing.borderRadiusFull,
                boxShadow: [
                  BoxShadow(
                    color: (isSelected
                            ? AppColors.neonCyan
                            : AppColors.primaryAccent)
                        .withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  if (isSelected)
                    BoxShadow(
                      color: AppColors.neonCyan.withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: AppAnimations.fast,
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  key: ValueKey('center_$index\_$isSelected'),
                  color: AppColors.textPrimary,
                  size: AppSpacing.iconMd,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Navigation item model
class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String? badge;

  const NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.badge,
  });
}

/// Predefined navigation items
class NavItems {
  static const home = NavItem(
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
    label: 'Home',
  );

  static const transactions = NavItem(
    icon: Icons.swap_horiz_outlined,
    activeIcon: Icons.swap_horiz_rounded,
    label: 'Transactions',
  );

  static const aiAssistant = NavItem(
    icon: Icons.auto_awesome_outlined,
    activeIcon: Icons.auto_awesome,
    label: 'AI',
  );

  static const reports = NavItem(
    icon: Icons.bar_chart_outlined,
    activeIcon: Icons.bar_chart_rounded,
    label: 'Reports',
  );

  static const profile = NavItem(
    icon: Icons.person_outline_rounded,
    activeIcon: Icons.person_rounded,
    label: 'Profile',
  );

  static List<NavItem> get defaultItems => [
        home,
        transactions,
        aiAssistant,
        reports,
        profile,
      ];
}

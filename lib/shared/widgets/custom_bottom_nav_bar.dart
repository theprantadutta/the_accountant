import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_typography.dart';

/// A beautiful Material You (Material 3) style bottom navigation bar.
///
/// Features:
/// - Animated pill indicator that slides between items
/// - Icons transition from outline to filled on selection
/// - Always-visible labels with subtle styling
/// - Special prominent styling for AI button
/// - Smooth spring animations
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
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.currentIndex;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(CustomBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _previousIndex = oldWidget.currentIndex;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
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
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    final isAiSelected = widget.currentIndex == 2;

    return Container(
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        height: 80,
        child: Stack(
          children: [
            // Animated pill indicator (hidden when AI tab is selected)
            if (!isAiSelected)
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final itemWidth = screenWidth / widget.items.length;
                  const pillWidth = 64.0;

                  final previousX =
                      _previousIndex * itemWidth + (itemWidth - pillWidth) / 2;
                  final currentX =
                      widget.currentIndex * itemWidth +
                      (itemWidth - pillWidth) / 2;
                  final x =
                      previousX + (currentX - previousX) * _animation.value;

                  return Transform.translate(
                    offset: Offset(x, 12),
                    child: Container(
                      width: pillWidth,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primaryAccent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  );
                },
              ),
            // Navigation items
            Row(
              children: List.generate(widget.items.length, (index) {
                final item = widget.items[index];
                final isSelected = widget.currentIndex == index;
                final isAiButton = index == 2;

                return Expanded(
                  child: _NavItem(
                    item: item,
                    isSelected: isSelected,
                    isAiButton: isAiButton,
                    onTap: () => _handleTap(index),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual navigation item with Material You styling
class _NavItem extends StatelessWidget {
  final NavItem item;
  final bool isSelected;
  final bool isAiButton;
  final VoidCallback onTap;

  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.isAiButton,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // AI button has special colors
    final Color iconColor;
    final Color labelColor;

    if (isAiButton) {
      iconColor = isSelected ? Colors.white : AppColors.neonCyan;
      labelColor = AppColors.neonCyan;
    } else {
      iconColor = isSelected ? AppColors.primaryAccent : AppColors.textMuted;
      labelColor = isSelected ? AppColors.primaryAccent : AppColors.textMuted;
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container - AI button has special styling
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            width: isAiButton ? 48 : 32,
            height: 32,
            decoration: isAiButton
                ? BoxDecoration(
                    gradient: isSelected
                        ? AppColors.accentGradient
                        : LinearGradient(
                            colors: [
                              AppColors.neonCyan.withValues(alpha: 0.15),
                              AppColors.primaryAccent.withValues(alpha: 0.1),
                            ],
                          ),
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? null
                        : Border.all(
                            color: AppColors.neonCyan.withValues(alpha: 0.3),
                            width: 1,
                          ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.neonCyan.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  )
                : null,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Icon with animation
                AnimatedScale(
                  scale: isSelected ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(
                            begin: 0.8,
                            end: 1.0,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Icon(
                      isSelected ? item.activeIcon : item.icon,
                      key: ValueKey('${item.label}_$isSelected'),
                      color: iconColor,
                      size: 24,
                    ),
                  ),
                ),
                // Badge
                if (item.badge != null)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      constraints: const BoxConstraints(minWidth: 16),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primarySurface,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        item.badge!,
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                          fontSize: 9,
                          height: 1,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Label
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: AppTypography.labelSmall.copyWith(
              color: labelColor,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              letterSpacing: isSelected ? 0.1 : 0,
            ),
            child: Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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
    icon: Icons.receipt_long_outlined,
    activeIcon: Icons.receipt_long_rounded,
    label: 'Activity',
  );

  static const aiAssistant = NavItem(
    icon: Icons.auto_awesome_outlined,
    activeIcon: Icons.auto_awesome,
    label: 'AI',
  );

  static const reports = NavItem(
    icon: Icons.insights_outlined,
    activeIcon: Icons.insights_rounded,
    label: 'Insights',
  );

  static const settings = NavItem(
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings_rounded,
    label: 'Settings',
  );

  static List<NavItem> get defaultItems => [
    home,
    transactions,
    aiAssistant,
    reports,
    settings,
  ];
}

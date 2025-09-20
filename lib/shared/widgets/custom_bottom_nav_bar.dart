import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_accountant/core/themes/app_theme.dart';

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
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AppTheme.glassmorphicContainer(
        height: 72,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            children: List.generate(widget.items.length, (index) {
              final item = widget.items[index];
              final isSelected = widget.currentIndex == index;
              final isCenterItem = index == 2; // AI Assistant center button

              if (isCenterItem) {
                return _buildCenterButton(item, index, isSelected);
              }

              return Expanded(child: _buildNavItem(item, index, isSelected));
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(NavItem item, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: isSelected ? AppTheme.primaryGradient : null,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Icon
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: isSelected ? 1.05 : 1.0,
                        child: Icon(
                          isSelected ? item.activeIcon : item.icon,
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.6),
                          size: 16,
                        ),
                      );
                    },
                  ),

                  // Badge
                  if (item.badge != null)
                    Positioned(
                      right: -1,
                      top: -1,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        constraints: const BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          item.badge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 6,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 1),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.6),
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                height: 1.0,
              ),
              child: Text(
                item.label,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton(NavItem item, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Container(
        width: 56,
        height: 56,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: isSelected
              ? AppTheme.secondaryGradient
              : AppTheme.primaryGradient,
          boxShadow: [
            BoxShadow(
              color:
                  (isSelected
                          ? const Color(0xFF11998e)
                          : const Color(0xFF667eea))
                      .withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(item.icon, color: Colors.white, size: 24),
      ),
    );
  }
}

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

// Predefined navigation items
class NavItems {
  static const home = NavItem(
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
    label: 'Home',
  );

  static const transactions = NavItem(
    icon: Icons.swap_horiz_outlined,
    activeIcon: Icons.swap_horiz,
    label: 'Transactions',
  );

  static const aiAssistant = NavItem(
    icon: Icons.auto_awesome,
    activeIcon: Icons.auto_awesome,
    label: 'AI',
  );

  static const reports = NavItem(
    icon: Icons.bar_chart_outlined,
    activeIcon: Icons.bar_chart,
    label: 'Reports',
  );

  static const profile = NavItem(
    icon: Icons.person_outline,
    activeIcon: Icons.person,
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

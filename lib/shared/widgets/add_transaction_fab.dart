import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_theme.dart';

class AddTransactionFab extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isExtended;

  const AddTransactionFab({
    super.key,
    required this.onPressed,
    this.isExtended = false,
  });

  @override
  State<AddTransactionFab> createState() => _AddTransactionFabState();
}

class _AddTransactionFabState extends State<AddTransactionFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: AppTheme.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667eea).withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(28),
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: widget.onPressed,
              child: Padding(
                padding: widget.isExtended
                    ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                    : const EdgeInsets.all(16),
                child: widget.isExtended
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, color: Colors.white, size: 20),
                          const SizedBox(width: 6),
                          const Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

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
        return SizedBox(
          height: 56,
          child: FloatingActionButton(
            onPressed: widget.onPressed,
            child: widget.isExtended
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add),
                      const SizedBox(width: 8),
                      const Text('Add Transaction'),
                    ],
                  )
                : const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

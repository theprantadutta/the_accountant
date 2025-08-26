import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/ai/providers/category_assignment_provider.dart';

class CategorySuggestionWidget extends ConsumerStatefulWidget {
  final TextEditingController notesController;
  final Function(String) onCategorySelected;

  const CategorySuggestionWidget({
    super.key,
    required this.notesController,
    required this.onCategorySelected,
  });

  @override
  ConsumerState<CategorySuggestionWidget> createState() => _CategorySuggestionWidgetState();
}

class _CategorySuggestionWidgetState extends ConsumerState<CategorySuggestionWidget> {
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    // Add listener to the notes controller to trigger suggestions
    widget.notesController.addListener(_onNotesChanged);
  }

  @override
  void dispose() {
    widget.notesController.removeListener(_onNotesChanged);
    super.dispose();
  }

  void _onNotesChanged() {
    final text = widget.notesController.text.trim();
    if (text.length > 3) {
      // Only show suggestions if we have enough text
      setState(() {
        _showSuggestions = true;
      });
      
      // Get suggestions from the AI service
      ref.read(categoryAssignmentProvider.notifier).getSuggestions(text);
    } else {
      setState(() {
        _showSuggestions = false;
      });
    }
  }

  void _selectSuggestedCategory(String category) {
    widget.onCategorySelected(category);
    setState(() {
      _showSuggestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryAssignmentProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_showSuggestions && categoryState.suggestions.isNotEmpty) ...[
          const SizedBox(height: 8),
          const Text(
            'Suggested Categories:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categoryState.suggestions.map((suggestion) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(suggestion),
                    onPressed: () => _selectSuggestedCategory(suggestion),
                    backgroundColor: Colors.blue[100],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
        if (categoryState.isProcessing) ...[
          const SizedBox(height: 8),
          const Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 8),
              Text('Analyzing transaction...'),
            ],
          ),
        ],
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_animations.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/features/transactions/providers/title_suggestions_provider.dart';

/// Title input section for transaction creation.
/// Features smart suggestions from transaction history and auto-categorization.
class TitleInputSection extends ConsumerStatefulWidget {
  /// Callback when title changes
  final ValueChanged<String> onTitleChanged;

  /// Callback when notes change
  final ValueChanged<String>? onNotesChanged;

  /// Callback when a category is suggested based on title
  final void Function(CategorySuggestionResult)? onCategorySuggested;

  /// Initial title value
  final String? initialTitle;

  /// Initial notes value
  final String? initialNotes;

  /// Accent color for styling
  final Color? accentColor;

  /// Whether to show the notes field
  final bool showNotes;

  /// Whether to auto-focus the title field
  final bool autoFocus;

  const TitleInputSection({
    super.key,
    required this.onTitleChanged,
    this.onNotesChanged,
    this.onCategorySuggested,
    this.initialTitle,
    this.initialNotes,
    this.accentColor,
    this.showNotes = true,
    this.autoFocus = true,
  });

  @override
  ConsumerState<TitleInputSection> createState() => _TitleInputSectionState();
}

class _TitleInputSectionState extends ConsumerState<TitleInputSection> {
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  late FocusNode _titleFocusNode;
  bool _showSuggestions = false;
  String _lastSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _notesController = TextEditingController(text: widget.initialNotes);
    _titleFocusNode = FocusNode();

    _titleController.addListener(_onTitleChanged);
    _titleFocusNode.addListener(_onFocusChanged);

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _titleFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _titleFocusNode.removeListener(_onFocusChanged);
    _titleController.dispose();
    _notesController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _onTitleChanged() {
    final title = _titleController.text;
    widget.onTitleChanged(title);

    // Search for suggestions if title is long enough
    if (title.length >= 2 && title != _lastSearchQuery) {
      _lastSearchQuery = title;
      ref.read(titleSuggestionsProvider.notifier).searchTitles(title);

      // Check for category suggestion
      _checkCategorySuggestion(title);
    } else if (title.isEmpty) {
      ref.read(titleSuggestionsProvider.notifier).clearSearch();
    }
  }

  void _onFocusChanged() {
    setState(() {
      _showSuggestions = _titleFocusNode.hasFocus;
    });
  }

  Future<void> _checkCategorySuggestion(String title) async {
    if (widget.onCategorySuggested == null) return;

    // Auto-categorization ("Smart Categorization") is a Premium feature. Free
    // users still get title autocomplete, just not the category suggestion.
    if (!ref.read(premiumProvider).isPremium) return;

    final suggestion = await ref
        .read(titleSuggestionsProvider.notifier)
        .getCategorySuggestion(title);

    if (suggestion != null && mounted) {
      widget.onCategorySuggested!(suggestion);
    }
  }

  void _selectSuggestion(TitleSuggestion suggestion) {
    HapticFeedback.lightImpact();
    _titleController.text = suggestion.title;
    _titleController.selection = TextSelection.fromPosition(
      TextPosition(offset: suggestion.title.length),
    );
    widget.onTitleChanged(suggestion.title);

    // If suggestion has a category, notify parent
    if (suggestion.categoryId != null && widget.onCategorySuggested != null) {
      widget.onCategorySuggested!(
        CategorySuggestionResult(
          categoryId: suggestion.categoryId!,
          categoryName: suggestion.categoryName,
          categoryColor: suggestion.categoryColor,
          matchType: 'selected',
          confidence: 1.0,
        ),
      );
    }

    // Close suggestions
    setState(() {
      _showSuggestions = false;
    });
    ref.read(titleSuggestionsProvider.notifier).clearSearch();
    _titleFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.accentColor ?? AppColors.primaryAccent;
    final suggestionsState = ref.watch(titleSuggestionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Input
        _buildTitleInput(color),

        // Suggestions Dropdown
        if (_showSuggestions) ...[_buildSuggestions(suggestionsState, color)],

        // Recent Titles (when no search query)
        if (_showSuggestions &&
            _titleController.text.length < 2 &&
            suggestionsState.recentTitles.isNotEmpty) ...[
          AppSpacing.gapMd,
          _buildRecentTitles(suggestionsState, color),
        ],

        // Notes Input
        if (widget.showNotes) ...[AppSpacing.gapLg, _buildNotesInput(color)],
      ],
    );
  }

  Widget _buildTitleInput(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What is this transaction for?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.gapSm,
        TextField(
          controller: _titleController,
          focusNode: _titleFocusNode,
          style: TextStyle(fontSize: 18, color: AppColors.textPrimary),
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'e.g., Coffee, Groceries, Salary...',
            hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 18),
            filled: true,
            fillColor: AppColors.primarySurface,
            border: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusMd,
              borderSide: BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusMd,
              borderSide: BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusMd,
              borderSide: BorderSide(color: color, width: 2),
            ),
            contentPadding: AppSpacing.paddingLg,
            suffixIcon: _titleController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: AppColors.textMuted),
                    onPressed: () {
                      _titleController.clear();
                      widget.onTitleChanged('');
                      ref.read(titleSuggestionsProvider.notifier).clearSearch();
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestions(TitleSuggestionsState state, Color color) {
    if (state.searchResults.isEmpty) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: AppAnimations.fast,
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryElevated,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppSpacing.borderRadiusMd,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: state.searchResults.map((suggestion) {
            return _SuggestionTile(
              suggestion: suggestion,
              onTap: () => _selectSuggestion(suggestion),
              color: color,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRecentTitles(TitleSuggestionsState state, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        AppSpacing.gapSm,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: state.recentTitles.take(8).map((suggestion) {
            return _RecentTitleChip(
              suggestion: suggestion,
              onTap: () => _selectSuggestion(suggestion),
              color: color,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNotesInput(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes (optional)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        AppSpacing.gapSm,
        TextField(
          controller: _notesController,
          style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
          maxLines: 3,
          minLines: 1,
          textCapitalization: TextCapitalization.sentences,
          onChanged: widget.onNotesChanged,
          decoration: InputDecoration(
            hintText: 'Add any additional notes...',
            hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
            filled: true,
            fillColor: AppColors.primarySurface,
            border: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusMd,
              borderSide: BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusMd,
              borderSide: BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusMd,
              borderSide: BorderSide(color: color, width: 2),
            ),
            contentPadding: AppSpacing.paddingMd,
          ),
        ),
      ],
    );
  }
}

/// Suggestion tile in the dropdown.
class _SuggestionTile extends StatelessWidget {
  final TitleSuggestion suggestion;
  final VoidCallback onTap;
  final Color color;

  const _SuggestionTile({
    required this.suggestion,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.paddingMd,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.5)),
          ),
        ),
        child: Row(
          children: [
            // Category indicator
            if (suggestion.categoryColor != null)
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _parseColor(
                    suggestion.categoryColor!,
                  ).withValues(alpha: 0.2),
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
                child: Icon(
                  Icons.category,
                  size: 16,
                  color: _parseColor(suggestion.categoryColor!),
                ),
              )
            else
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
                child: Icon(
                  Icons.history,
                  size: 16,
                  color: AppColors.textMuted,
                ),
              ),
            AppSpacing.gapHMd,

            // Title and category
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (suggestion.categoryName != null)
                    Text(
                      suggestion.categoryName!,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),

            // Use count
            if (suggestion.useCount > 1)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: AppSpacing.borderRadiusFull,
                ),
                child: Text(
                  '${suggestion.useCount}x',
                  style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String colorCode) {
    try {
      if (colorCode.startsWith('#')) {
        return Color(int.parse(colorCode.substring(1), radix: 16) | 0xFF000000);
      }
      return Colors.grey;
    } catch (e) {
      return Colors.grey;
    }
  }
}

/// Recent title chip.
class _RecentTitleChip extends StatelessWidget {
  final TitleSuggestion suggestion;
  final VoidCallback onTap;
  final Color color;

  const _RecentTitleChip({
    required this.suggestion,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = suggestion.categoryColor != null
        ? _parseColor(suggestion.categoryColor!)
        : AppColors.primaryAccent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: chipColor.withValues(alpha: 0.1),
          borderRadius: AppSpacing.borderRadiusFull,
          border: Border.all(color: chipColor.withValues(alpha: 0.3)),
        ),
        child: Text(
          suggestion.title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: chipColor,
          ),
        ),
      ),
    );
  }

  Color _parseColor(String colorCode) {
    try {
      if (colorCode.startsWith('#')) {
        return Color(int.parse(colorCode.substring(1), radix: 16) | 0xFF000000);
      }
      return Colors.grey;
    } catch (e) {
      return Colors.grey;
    }
  }
}

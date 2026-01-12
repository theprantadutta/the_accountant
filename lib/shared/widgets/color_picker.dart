import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';

/// A widget for selecting a color from a preset palette
class ColorPicker extends StatelessWidget {
  final String? selectedColor;
  final ValueChanged<String> onColorSelected;
  final String? label;

  const ColorPicker({
    super.key,
    this.selectedColor,
    required this.onColorSelected,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = selectedColor != null
        ? WalletColors.parseColor(selectedColor!)
        : AppColors.primaryAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTypography.labelMedium),
          AppSpacing.gapSm,
        ],
        InkWell(
          onTap: () => _showColorPicker(context),
          borderRadius: AppSpacing.borderRadiusMd,
          child: Container(
            padding: AppSpacing.paddingMd,
            decoration: BoxDecoration(
              color: AppColors.glassWhite,
              borderRadius: AppSpacing.borderRadiusMd,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: effectiveColor,
                    borderRadius: AppSpacing.borderRadiusSm,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                ),
                AppSpacing.gapHMd,
                Expanded(
                  child: Text(
                    selectedColor != null ? 'Tap to change' : 'Select color',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showColorPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: _ColorPickerSheet(
          selectedColor: selectedColor,
          onColorSelected: (color) {
            onColorSelected(color);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class _ColorPickerSheet extends StatefulWidget {
  final String? selectedColor;
  final ValueChanged<String> onColorSelected;

  const _ColorPickerSheet({
    this.selectedColor,
    required this.onColorSelected,
  });

  @override
  State<_ColorPickerSheet> createState() => _ColorPickerSheetState();
}

class _ColorPickerSheetState extends State<_ColorPickerSheet> {
  late String? _selectedColor;
  final TextEditingController _hexController = TextEditingController();
  bool _showCustomInput = false;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor;
    if (_selectedColor != null) {
      _hexController.text = _selectedColor!.replaceFirst('#', '');
    }
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        gradient: AppColors.glassGradient,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.glassBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: AppSpacing.horizontalPadding(AppSpacing.md),
            child: Row(
              children: [
                Text('Select Color', style: AppTypography.titleLarge),
                const Spacer(),
                IconButton(
                  icon: Icon(_showCustomInput ? Icons.palette : Icons.edit),
                  onPressed: () =>
                      setState(() => _showCustomInput = !_showCustomInput),
                  tooltip: _showCustomInput ? 'Show palette' : 'Custom color',
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Custom hex input
          if (_showCustomInput) ...[
            Padding(
              padding: AppSpacing.paddingMd,
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _selectedColor != null
                          ? WalletColors.parseColor(_selectedColor!)
                          : Colors.grey,
                      borderRadius: AppSpacing.borderRadiusSm,
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                  ),
                  AppSpacing.gapHMd,
                  Expanded(
                    child: TextField(
                      controller: _hexController,
                      decoration: InputDecoration(
                        prefixText: '#',
                        hintText: '6366F1',
                        filled: true,
                        fillColor: AppColors.glassWhite,
                        border: OutlineInputBorder(
                          borderRadius: AppSpacing.borderRadiusMd,
                          borderSide: BorderSide.none,
                        ),
                      ),
                      maxLength: 6,
                      onChanged: (value) {
                        if (value.length == 6) {
                          final hex = '#$value';
                          if (WalletColors.isValidHex(hex)) {
                            setState(() => _selectedColor = hex);
                          }
                        }
                      },
                    ),
                  ),
                  AppSpacing.gapHMd,
                  ElevatedButton(
                    onPressed: _selectedColor != null
                        ? () => widget.onColorSelected(_selectedColor!)
                        : null,
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ),
          ],
          // Color palette
          Expanded(
            child: GridView.builder(
              padding: AppSpacing.paddingMd,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: WalletColors.presetColors.length,
              itemBuilder: (context, index) {
                final color = WalletColors.presetColors[index];
                final isSelected = _selectedColor?.toUpperCase() ==
                    color.toUpperCase();

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                      _hexController.text = color.replaceFirst('#', '');
                    });
                    widget.onColorSelected(color);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: WalletColors.parseColor(color),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.2),
                        width: isSelected ? 3 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: WalletColors.parseColor(color)
                                    .withValues(alpha: 0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 24)
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Inline color palette for compact layouts
class InlineColorPicker extends StatelessWidget {
  final String? selectedColor;
  final ValueChanged<String> onColorSelected;
  final int maxColors;

  const InlineColorPicker({
    super.key,
    this.selectedColor,
    required this.onColorSelected,
    this.maxColors = 8,
  });

  @override
  Widget build(BuildContext context) {
    final colors = WalletColors.presetColors.take(maxColors).toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colors.map((color) {
        final isSelected =
            selectedColor?.toUpperCase() == color.toUpperCase();
        return InkWell(
          onTap: () => onColorSelected(color),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: WalletColors.parseColor(color),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 2,
              ),
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : null,
          ),
        );
      }).toList(),
    );
  }
}

/// Predefined wallet colors
class WalletColors {
  static const List<String> presetColors = [
    // Primary colors
    '#6366F1', // Indigo (default)
    '#8B5CF6', // Violet
    '#A855F7', // Purple
    '#D946EF', // Fuchsia
    '#EC4899', // Pink
    '#F43F5E', // Rose
    // Warm colors
    '#EF4444', // Red
    '#F97316', // Orange
    '#F59E0B', // Amber
    '#EAB308', // Yellow
    '#84CC16', // Lime
    '#22C55E', // Green
    // Cool colors
    '#10B981', // Emerald
    '#14B8A6', // Teal
    '#06B6D4', // Cyan
    '#0EA5E9', // Sky
    '#3B82F6', // Blue
    '#6366F1', // Indigo
    // Neutral colors
    '#64748B', // Slate
    '#6B7280', // Gray
    '#71717A', // Zinc
    '#78716C', // Stone
    '#737373', // Neutral
    '#525252', // Dark Gray
  ];

  static Color parseColor(String hex) {
    try {
      final buffer = StringBuffer();
      if (hex.length == 6 || hex.length == 7) buffer.write('ff');
      buffer.write(hex.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return const Color(0xFF6366F1); // Default indigo
    }
  }

  static bool isValidHex(String hex) {
    final pattern = RegExp(r'^#?([A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$');
    return pattern.hasMatch(hex);
  }

  static String toHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }
}

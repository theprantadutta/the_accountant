import 'package:flutter/material.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/shared/widgets/sunrise/cards.dart';

/// The icon a stored icon name stands for, or its emoji when it is one.
///
/// For the places that draw a bare icon rather than an [IconTile].
class RegistryIcon extends StatelessWidget {
  const RegistryIcon(this.name, {super.key, this.size = 24, this.color});

  final String? name;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final emoji = IconRegistry.emojiOf(name);
    if (emoji != null) return EmojiGlyph(emoji, size: size);
    return Icon(IconRegistry.getIcon(name), size: size, color: color);
  }
}

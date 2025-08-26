import 'package:flutter/material.dart';

class ColorUtils {
  /// Convert a hex color string to Color object
  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Convert a Color object to hex string
  static String colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  /// Get a random color from a string
  static Color stringToColor(String str) {
    final hash = str.hashCode;
    final r = (hash >> 16) & 0xFF;
    final g = (hash >> 8) & 0xFF;
    final b = hash & 0xFF;
    return Color.fromARGB(255, r, g, b);
  }
}
import 'dart:io';
import 'package:flutter/foundation.dart';

/// SIMULATOR STUB of [OcrService] — contains NO Google ML Kit code.
///
/// Google ML Kit ships no arm64 iOS-simulator slice, so it cannot be linked for
/// Apple Silicon iOS 26+ simulators (which require arm64). This stub is swapped
/// in by `tools/simulator_mode.sh on` so the whole app builds and runs in the
/// simulator; only receipt OCR is disabled (it needs a real camera anyway).
///
/// Restore the real ML Kit implementation with: `tools/simulator_mode.sh off`.
class OcrService {
  OcrService();

  Future<String?> processImage(File imageFile) async {
    debugPrint('[OcrService stub] OCR is unavailable in the simulator build.');
    return null;
  }

  Future<ReceiptData?> extractReceiptData(File imageFile) async {
    debugPrint(
      '[OcrService stub] Receipt scanning is unavailable in the simulator build.',
    );
    return null;
  }

  void dispose() {}
}

class ReceiptData {
  final String merchant;
  final String? date;
  final double total;
  final List<ReceiptItem> items;
  final String? barcodeInfo;
  final List<String>? imageLabels;

  ReceiptData({
    required this.merchant,
    this.date,
    required this.total,
    required this.items,
    this.barcodeInfo,
    this.imageLabels,
  });
}

class ReceiptItem {
  final String name;
  final double price;

  ReceiptItem({required this.name, required this.price});
}

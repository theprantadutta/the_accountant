import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:flutter/foundation.dart';

class OcrService {
  late TextRecognizer _textRecognizer;
  late BarcodeScanner _barcodeScanner;
  late ImageLabeler _imageLabeler;

  OcrService() {
    // Initialize the text recognizer with correct options
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    // Initialize barcode scanner
    _barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.all]);

    // Initialize image labeler
    _imageLabeler = ImageLabeler(
      options: ImageLabelerOptions(confidenceThreshold: 0.7),
    );
  }

  /// Process an image file and extract text with enhanced processing
  Future<String?> processImage(File imageFile) async {
    try {
      // Create an input image from the file
      final inputImage = InputImage.fromFile(imageFile);

      // Process the image and get the text
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );

      // Extract the text with better formatting
      final text = _formatRecognizedText(recognizedText);

      return text;
    } catch (e) {
      debugPrint('Error processing image: $e');
      return null;
    }
  }

  /// Format recognized text for better readability
  String _formatRecognizedText(RecognizedText recognizedText) {
    final StringBuffer formattedText = StringBuffer();

    // Process text blocks in order
    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        formattedText.write('${line.text}\n');
      }
      formattedText.write('\n'); // Add paragraph break
    }

    return formattedText.toString().trim();
  }

  /// Scan barcodes in an image
  Future<List<Barcode>?> scanBarcodes(File imageFile) async {
    try {
      // Create an input image from the file
      final inputImage = InputImage.fromFile(imageFile);

      // Process the image and get barcodes
      final List<Barcode> barcodes = await _barcodeScanner.processImage(
        inputImage,
      );

      return barcodes;
    } catch (e) {
      debugPrint('Error scanning barcodes: $e');
      return null;
    }
  }

  /// Label objects in an image
  Future<List<ImageLabel>?> labelImage(File imageFile) async {
    try {
      // Create an input image from the file
      final inputImage = InputImage.fromFile(imageFile);

      // Process the image and get labels
      final List<ImageLabel> labels = await _imageLabeler.processImage(
        inputImage,
      );

      return labels;
    } catch (e) {
      debugPrint('Error labeling image: $e');
      return null;
    }
  }

  /// Process an image and extract structured receipt data (merchant + total).
  Future<ReceiptData?> extractReceiptData(File imageFile) async {
    try {
      final text = await processImage(imageFile);
      if (text == null || text.trim().isEmpty) return null;
      return _parseReceiptText(text);
    } catch (e) {
      debugPrint('Error extracting receipt data: $e');
      return null;
    }
  }

  /// Heuristic receipt parser. On-device ML Kit gives good raw text; the value
  /// is in picking the right merchant and total out of it:
  ///  - Total: the amount on a line labelled TOTAL / AMOUNT DUE / BALANCE DUE,
  ///    excluding SUBTOTAL / TAX / CHANGE / TENDER, and only counting amounts
  ///    that have cents (.dd) so transaction ids and quantities are ignored.
  ///  - Merchant: the first top line that reads like a name (letters, not an
  ///    address / phone / all-digits line).
  ReceiptData _parseReceiptText(String text) {
    final lines = text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    return ReceiptData(
      merchant: _extractMerchant(lines),
      date: _extractDate(text),
      total: _extractTotal(lines),
      items: const [],
    );
  }

  // Only amounts with cents (e.g. 12.34 or 1,234.56) — this alone filters out
  // transaction ids, quantities, phone numbers and barcodes.
  static final RegExp _amountRegex = RegExp(
    r'(\d{1,3}(?:,\d{3})+|\d+)\.(\d{2})(?!\d)',
  );

  /// The last cents-bearing amount on a line (amounts are usually right-aligned).
  double? _lastAmountIn(String line) {
    double? value;
    for (final m in _amountRegex.allMatches(line)) {
      final whole = (m.group(1) ?? '').replaceAll(',', '');
      value = double.tryParse('$whole.${m.group(2)}');
    }
    return value;
  }

  double _extractTotal(List<String> lines) {
    // Higher index = stronger signal it's the final total.
    const totalKeywords = [
      'total',
      'balance due',
      'amount due',
      'total due',
      'grand total',
    ];
    const excludeKeywords = [
      'subtotal',
      'sub total',
      'tax',
      'vat',
      'gst',
      'change',
      'tender',
      'cash',
      'card',
      'credit',
      'debit',
      'tip',
      'gratuity',
      'discount',
      'savings',
      'points',
      'balance forward',
      'previous',
    ];

    double? best;
    var bestRank = -1;

    for (var i = 0; i < lines.length; i++) {
      final lower = lines[i].toLowerCase();
      if (excludeKeywords.any(lower.contains)) continue;

      var rank = -1;
      for (var k = 0; k < totalKeywords.length; k++) {
        if (lower.contains(totalKeywords[k]) && k > rank) rank = k;
      }
      if (rank < 0) continue;

      // The amount may be on the keyword line, or (columnar receipts) the next.
      final amount =
          _lastAmountIn(lines[i]) ??
          (i + 1 < lines.length ? _lastAmountIn(lines[i + 1]) : null);
      if (amount == null) continue;

      if (rank > bestRank || (rank == bestRank && amount > (best ?? 0))) {
        best = amount;
        bestRank = rank;
      }
    }
    if (best != null) return best;

    // Fallback: the largest cents-bearing amount on the receipt.
    var max = 0.0;
    for (final line in lines) {
      final a = _lastAmountIn(line);
      if (a != null && a > max && a < 1000000) max = a;
    }
    return max;
  }

  String _extractMerchant(List<String> lines) {
    for (final line in lines.take(6)) {
      if (line.length < 3) continue;
      final lower = line.toLowerCase();
      if (lower.contains('receipt') ||
          lower.contains('www') ||
          lower.contains('.com') ||
          lower.contains('tel') ||
          lower.contains('phone') ||
          lower.contains('order') ||
          lower.contains('invoice')) {
        continue;
      }
      // Skip lines that are mostly digits/symbols (addresses, ids, phone nos).
      final letters = RegExp(r'[a-zA-Z]').allMatches(line).length;
      final digits = RegExp(r'\d').allMatches(line).length;
      if (letters < 3 || digits > letters) continue;

      return _tidyName(line);
    }
    return lines.isNotEmpty ? _tidyName(lines.first) : 'Receipt';
  }

  /// Title-case shouty ALL-CAPS names ("WALMART" -> "Walmart").
  String _tidyName(String name) {
    final trimmed = name.trim();
    if (trimmed != trimmed.toUpperCase()) return trimmed;
    return trimmed
        .split(RegExp(r'\s+'))
        .map(
          (w) =>
              w.isEmpty ? w : w[0].toUpperCase() + w.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  String? _extractDate(String text) {
    final match = RegExp(r'(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})').firstMatch(text);
    return match?.group(1);
  }

  /// Dispose of all recognizers
  void dispose() {
    _textRecognizer.close();
    _barcodeScanner.close();
    _imageLabeler.close();
  }
}

class ReceiptData {
  final String merchant;
  final String? date;
  final double total;
  final List<ReceiptItem> items;
  final String? barcodeInfo; // New field for barcode information
  final List<String>? imageLabels; // New field for image labels

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

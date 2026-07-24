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
  ///
  /// ML Kit gives good raw text; the value is picking the right fields out of it:
  ///  - Merchant: chosen by *text size* — the store name is almost always the
  ///    largest text near the top — which is far more reliable than line order.
  ///  - Total: the amount on a line labelled TOTAL / AMOUNT DUE / BALANCE DUE,
  ///    excluding SUBTOTAL / TAX / CHANGE / TENDER, counting only amounts with
  ///    cents (.dd) so transaction ids and quantities are ignored.
  Future<ReceiptData?> extractReceiptData(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognized = await _textRecognizer.processImage(inputImage);
      final text = _formatRecognizedText(recognized);
      if (text.trim().isEmpty) return null;

      final lines = text
          .split('\n')
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty)
          .toList();

      return ReceiptData(
        merchant: _extractMerchant(recognized, lines),
        date: _extractDate(text),
        total: _extractTotal(lines),
        items: const [],
      );
    } catch (e) {
      debugPrint('Error extracting receipt data: $e');
      return null;
    }
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

  // Field labels / boilerplate that are never the store name.
  static const _merchantSkip = [
    'receipt',
    'www',
    '.com',
    'tel',
    'phone',
    'order',
    'invoice',
    'trans',
    'store',
    'register',
    'cashier',
    'date',
    'reg no',
    'reg.',
    'vat',
    'item',
    'qty',
    'price',
    'amount',
    'sales',
    'associate',
    'total',
    'tendered',
    'change',
    'customer',
    'thank you',
  ];

  bool _looksLikeName(String line) {
    final t = line.trim();
    if (t.length < 3) return false;
    if (t.contains(':')) return false; // "Trans: 76", "Date: …" etc.
    final lower = t.toLowerCase();
    if (_merchantSkip.any(lower.contains)) return false;
    final letters = RegExp(r'[a-zA-Z]').allMatches(t).length;
    final digits = RegExp(r'\d').allMatches(t).length;
    return letters >= 3 && digits <= letters;
  }

  /// Merchant = the largest name-like text near the top of the receipt.
  String _extractMerchant(RecognizedText recognized, List<String> fallback) {
    var minTop = double.infinity;
    var maxBottom = 0.0;
    final candidates = <({String text, double height, double top})>[];

    for (final block in recognized.blocks) {
      for (final line in block.lines) {
        final box = line.boundingBox;
        if (box.top < minTop) minTop = box.top;
        if (box.bottom > maxBottom) maxBottom = box.bottom;
        if (_looksLikeName(line.text)) {
          candidates.add((
            text: line.text.trim(),
            height: box.height,
            top: box.top,
          ));
        }
      }
    }

    if (candidates.isEmpty) {
      for (final l in fallback.take(6)) {
        if (_looksLikeName(l)) return _tidyName(l);
      }
      return fallback.isNotEmpty ? _tidyName(fallback.first) : 'Receipt';
    }

    // Prefer candidates in the top ~45% of the text; fall back to all.
    final cutoff = minTop + (maxBottom - minTop) * 0.45;
    final top = candidates.where((c) => c.top <= cutoff).toList();
    final pool = top.isNotEmpty ? top : candidates;
    pool.sort((a, b) => b.height.compareTo(a.height)); // biggest text wins
    return _tidyName(pool.first.text);
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

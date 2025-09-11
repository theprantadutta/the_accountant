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

  /// Process an image file and extract structured receipt data with enhanced processing
  Future<ReceiptData?> extractReceiptData(File imageFile) async {
    try {
      // First get the raw text
      final text = await processImage(imageFile);

      if (text == null) {
        return null;
      }

      // Scan for barcodes
      final barcodes = await scanBarcodes(imageFile);

      // Label the image
      final labels = await labelImage(imageFile);

      // Parse the text to extract receipt data
      return _parseReceiptText(text, barcodes, labels);
    } catch (e) {
      debugPrint('Error extracting receipt data: $e');
      return null;
    }
  }

  /// Parse receipt text to extract structured data with enhanced processing
  ReceiptData _parseReceiptText(
    String text,
    List<Barcode>? barcodes,
    List<ImageLabel>? labels,
  ) {
    // This is a simplified parser - in a real implementation, you would use
    // more sophisticated NLP techniques to extract receipt data

    final lines = text.split('\n');
    double total = 0.0;
    final items = <ReceiptItem>[];
    String? date;
    String? merchant;

    // Look for total amount (common patterns)
    final totalRegex = RegExp(
      r'(?:total|amount due|balance)\s*:?\s*\$?(\d+\.?\d*)',
      caseSensitive: false,
    );
    final totalMatch = totalRegex.firstMatch(text);
    if (totalMatch != null) {
      total = double.tryParse(totalMatch.group(1) ?? '0') ?? 0.0;
    }

    // Look for date (common patterns)
    final dateRegex = RegExp(
      r'(\d{1,2}/\d{1,2}/\d{2,4}|\d{1,2}-\d{1,2}-\d{2,4})',
    );
    final dateMatch = dateRegex.firstMatch(text);
    if (dateMatch != null) {
      date = dateMatch.group(1);
    }

    // Look for merchant name (usually at the beginning)
    if (lines.isNotEmpty) {
      merchant = lines[0].trim();
    }

    // Look for line items (items with prices)
    final itemRegex = RegExp(r'(.+?)\s*\$?(\d+\.?\d*)$');
    for (final line in lines) {
      final itemMatch = itemRegex.firstMatch(line.trim());
      if (itemMatch != null) {
        final itemName = itemMatch.group(1)?.trim() ?? '';
        final itemPrice = double.tryParse(itemMatch.group(2) ?? '0') ?? 0.0;

        // Filter out lines that are likely not items (too short, or contain total/etc.)
        if (itemName.length > 3 &&
            !itemName.toLowerCase().contains('total') &&
            !itemName.toLowerCase().contains('subtotal') &&
            !itemName.toLowerCase().contains('tax')) {
          items.add(ReceiptItem(name: itemName, price: itemPrice));
        }
      }
    }

    // Enhance merchant detection using image labels
    if ((merchant == 'Unknown' || merchant == null) &&
        labels != null &&
        labels.isNotEmpty) {
      // Look for common merchant-related labels
      final merchantLabels = labels
          .where(
            (label) =>
                label.label.toLowerCase().contains('store') ||
                label.label.toLowerCase().contains('shop') ||
                label.label.toLowerCase().contains('market') ||
                label.label.toLowerCase().contains('restaurant'),
          )
          .toList();

      if (merchantLabels.isNotEmpty) {
        merchant = merchantLabels.first.label;
      }
    }

    // Add barcode information if available
    String? barcodeInfo;
    if (barcodes != null && barcodes.isNotEmpty) {
      // Extract barcode data
      final barcodeData = barcodes
          .map((b) => '${b.rawValue} (${b.format.name})')
          .join(', ');
      barcodeInfo = barcodeData;
    }

    return ReceiptData(
      merchant: merchant ?? 'Unknown',
      date: date,
      total: total,
      items: items,
      barcodeInfo: barcodeInfo, // Add barcode information
      imageLabels: labels
          ?.map(
            (l) => '${l.label} (${(l.confidence * 100).toStringAsFixed(1)}%)',
          )
          .toList(), // Add image labels
    );
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

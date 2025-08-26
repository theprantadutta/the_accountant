import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/ai/services/ocr_service.dart';

class OcrState {
  final bool isProcessing;
  final String? extractedText;
  final ReceiptData? receiptData;
  final String? errorMessage;

  OcrState({
    this.isProcessing = false,
    this.extractedText,
    this.receiptData,
    this.errorMessage,
  });

  OcrState copyWith({
    bool? isProcessing,
    String? extractedText,
    ReceiptData? receiptData,
    String? errorMessage,
  }) {
    return OcrState(
      isProcessing: isProcessing ?? this.isProcessing,
      extractedText: extractedText ?? this.extractedText,
      receiptData: receiptData ?? this.receiptData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class OcrNotifier extends StateNotifier<OcrState> {
  final OcrService _ocrService;

  OcrNotifier() : _ocrService = OcrService(), super(OcrState());

  /// Process an image file and extract text
  Future<void> processImage(File imageFile) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final text = await _ocrService.processImage(imageFile);
      
      if (text != null) {
        state = state.copyWith(
          isProcessing: false,
          extractedText: text,
        );
      } else {
        state = state.copyWith(
          isProcessing: false,
          errorMessage: 'Failed to extract text from image',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Extract structured receipt data from an image
  Future<void> extractReceiptData(File imageFile) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final receiptData = await _ocrService.extractReceiptData(imageFile);
      
      if (receiptData != null) {
        state = state.copyWith(
          isProcessing: false,
          receiptData: receiptData,
        );
      } else {
        state = state.copyWith(
          isProcessing: false,
          errorMessage: 'Failed to extract receipt data from image',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Clear the current state
  void clear() {
    state = state.copyWith(
      isProcessing: false,
      extractedText: null,
      receiptData: null,
      errorMessage: null,
    );
  }

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }
}

final ocrProvider = StateNotifierProvider<OcrNotifier, OcrState>((ref) {
  return OcrNotifier();
});
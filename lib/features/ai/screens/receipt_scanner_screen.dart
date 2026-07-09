import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/ai/providers/ocr_provider.dart';
import 'package:the_accountant/features/premium/widgets/premium_gate.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/features/transactions/widgets/transaction_type_header.dart';

/// Result returned from the scanner when opened in [returnResult] mode.
typedef ReceiptScanResult = ({double amount, String title});

/// Gated receipt scanner that requires premium subscription
class ReceiptScannerScreenGated extends ConsumerWidget {
  /// When true, the scanner returns the parsed data to the caller (via
  /// Navigator.pop) instead of opening a new add-transaction screen.
  final bool returnResult;

  const ReceiptScannerScreenGated({super.key, this.returnResult = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PremiumGate(
      featureId: PremiumFeatureIds.receiptOcr,
      featureName: 'Receipt Scanner',
      featureDescription:
          'Scan receipts and automatically extract transaction data using AI-powered OCR technology.',
      featureIcon: Icons.receipt_long,
      child: ReceiptScannerScreen(returnResult: returnResult),
    );
  }
}

class ReceiptScannerScreen extends ConsumerStatefulWidget {
  final bool returnResult;

  const ReceiptScannerScreen({super.key, this.returnResult = false});

  @override
  ConsumerState<ReceiptScannerScreen> createState() =>
      _ReceiptScannerScreenState();
}

class _ReceiptScannerScreenState extends ConsumerState<ReceiptScannerScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });

        // Process the image
        if (_selectedImage != null) {
          await ref
              .read(ocrProvider.notifier)
              .extractReceiptData(_selectedImage!);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });

        // Process the image
        if (_selectedImage != null) {
          await ref
              .read(ocrProvider.notifier)
              .extractReceiptData(_selectedImage!);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ocrState = ref.watch(ocrProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Receipt Scanner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image selection section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Scan Receipt',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Take Photo'),
                        ),
                        ElevatedButton.icon(
                          onPressed: _selectImageFromGallery,
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Select Image'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Selected image preview
            if (_selectedImage != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selected Image',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImage!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Processing indicator
            if (ocrState.isProcessing)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('Processing receipt...'),
                  ],
                ),
              ),

            // Error message
            if (ocrState.errorMessage != null)
              Card(
                color: Colors.red.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    ocrState.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Extracted receipt data
            if (ocrState.receiptData != null)
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Extracted Receipt Data',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('Merchant: ${ocrState.receiptData!.merchant}'),
                          if (ocrState.receiptData!.date != null)
                            Text('Date: ${ocrState.receiptData!.date}'),
                          Text(
                            'Total: \$${ocrState.receiptData!.total.toStringAsFixed(2)}',
                          ),

                          // Barcode information
                          if (ocrState.receiptData!.barcodeInfo != null) ...[
                            const SizedBox(height: 16),
                            const Text(
                              'Barcode Information:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(ocrState.receiptData!.barcodeInfo!),
                          ],

                          // Image labels
                          if (ocrState.receiptData!.imageLabels != null &&
                              ocrState
                                  .receiptData!
                                  .imageLabels!
                                  .isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Text(
                              'Image Labels:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: ocrState.receiptData!.imageLabels!.map((
                                label,
                              ) {
                                return Chip(
                                  label: Text(label),
                                  backgroundColor: Colors.blue[100],
                                );
                              }).toList(),
                            ),
                          ],

                          const SizedBox(height: 16),
                          const Text(
                            'Items:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ocrState.receiptData!.items.length,
                            itemBuilder: (context, index) {
                              final item = ocrState.receiptData!.items[index];
                              return ListTile(
                                title: Text(item.name),
                                trailing: Text(
                                  '\$${item.price.toStringAsFixed(2)}',
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              final receiptData = ocrState.receiptData!;
                              if (widget.returnResult) {
                                // Hand the parsed data back to the add screen.
                                Navigator.pop(context, (
                                  amount: receiptData.total,
                                  title: receiptData.merchant,
                                ));
                              } else {
                                showAddTransactionScreen(
                                  context,
                                  initialType: TransactionTypeSelection.expense,
                                  prefillAmount: receiptData.total,
                                  prefillTitle: receiptData.merchant,
                                );
                              }
                            },
                            child: const Text('Save as Transaction'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // Raw extracted text
            if (ocrState.extractedText != null && ocrState.receiptData == null)
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Extracted Text',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(ocrState.extractedText!),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

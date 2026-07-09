import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/features/ai/providers/ocr_provider.dart';
import 'package:the_accountant/features/premium/widgets/premium_gate.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/features/transactions/widgets/transaction_type_header.dart';
import 'package:the_accountant/shared/widgets/neo_button.dart';
import 'package:the_accountant/shared/widgets/neo_text_field.dart';

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
  final _merchantController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _merchantController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _capture(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source);
      if (picked == null) return;
      setState(() => _selectedImage = File(picked.path));
      await ref.read(ocrProvider.notifier).extractReceiptData(_selectedImage!);
    } catch (_) {
      if (!mounted) return;
      _snack(
        source == ImageSource.camera
            ? "Couldn't open the camera."
            : "Couldn't open the gallery.",
      );
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _save() {
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final title = _merchantController.text.trim();
    if (widget.returnResult) {
      Navigator.pop(context, (amount: amount, title: title));
    } else {
      showAddTransactionScreen(
        context,
        initialType: TransactionTypeSelection.expense,
        prefillAmount: amount,
        prefillTitle: title,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ocrState = ref.watch(ocrProvider);

    // Prefill the editable review fields once a fresh scan lands.
    ref.listen<OcrState>(ocrProvider, (previous, next) {
      final data = next.receiptData;
      if (data != null && !identical(data, previous?.receiptData)) {
        _merchantController.text = data.merchant;
        _amountController.text = data.total > 0
            ? data.total.toStringAsFixed(2)
            : '';
      }
    });

    final hasResult = ocrState.receiptData != null && !ocrState.isProcessing;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Scan Receipt'),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.xxl,
        ),
        children: [
          _buildCaptureCard(processing: ocrState.isProcessing),
          if (_selectedImage != null) ...[
            SizedBox(height: AppSpacing.md),
            _buildPreview(),
          ],
          if (ocrState.isProcessing) ...[
            SizedBox(height: AppSpacing.md),
            _buildProcessing(),
          ],
          if (ocrState.errorMessage != null && !ocrState.isProcessing) ...[
            SizedBox(height: AppSpacing.md),
            _buildError(ocrState.errorMessage!),
          ],
          if (hasResult) ...[SizedBox(height: AppSpacing.md), _buildReview()],
        ],
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primarySurface.withValues(alpha: 0.45),
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: child,
    );
  }

  Widget _buildCaptureCard({required bool processing}) {
    return _glassCard(
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryAccent.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.document_scanner_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            _selectedImage == null ? 'Scan a receipt' : 'Scan another',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            "Snap a photo or pick one — we'll read the merchant and total.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: NeoButton(
                  label: 'Camera',
                  leadingIcon: Icons.camera_alt_outlined,
                  isExpanded: true,
                  onPressed: processing
                      ? null
                      : () => _capture(ImageSource.camera),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: NeoButton(
                  label: 'Gallery',
                  leadingIcon: Icons.photo_library_outlined,
                  style: NeoButtonStyle.secondary,
                  isExpanded: true,
                  onPressed: processing
                      ? null
                      : () => _capture(ImageSource.gallery),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return ClipRRect(
      borderRadius: AppSpacing.borderRadiusLg,
      child: Stack(
        children: [
          Image.file(
            _selectedImage!,
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.glassBorder),
                borderRadius: AppSpacing.borderRadiusLg,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessing() {
    return _glassCard(
      child: Row(
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.primaryAccent,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Text(
            'Reading your receipt…',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 20),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: AppColors.error, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReview() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: AppColors.success,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Review & save',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            'We read this from your receipt — check it and edit anything before saving.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12.5),
          ),
          SizedBox(height: AppSpacing.lg),
          NeoTextField(
            controller: _merchantController,
            label: 'Merchant / title',
            prefixIcon: Icons.storefront_outlined,
            textCapitalization: TextCapitalization.words,
          ),
          SizedBox(height: AppSpacing.md),
          NeoTextField(
            controller: _amountController,
            label: 'Amount',
            hint: '0.00',
            prefixIcon: Icons.attach_money,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          NeoButton(
            label: 'Save as transaction',
            leadingIcon: Icons.check_rounded,
            isExpanded: true,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}

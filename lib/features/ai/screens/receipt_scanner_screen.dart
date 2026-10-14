import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/features/ads/reward_flow.dart';
import 'package:the_accountant/features/ads/rewarded_ads.dart';
import 'package:the_accountant/features/ai/providers/ocr_provider.dart';
import 'package:the_accountant/features/ai_assistant/providers/ai_quota_provider.dart';
import 'package:the_accountant/features/ai_assistant/services/ai_api.dart';
import 'package:the_accountant/features/ai_assistant/services/finance_context_builder.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/transactions/screens/add_transaction_screen.dart';
import 'package:the_accountant/features/transactions/widgets/transaction_type_header.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// What the scanner hands back in [ReceiptScannerScreen.returnResult] mode.
typedef ReceiptScanResult = ({
  double amount,
  String title,
  String? category,
  DateTime? date,
  String? note,
});

/// Kept under its old name for the screens that open it. The scanner is no
/// longer Premium-only: reading the photo happens on the device, and making
/// sense of it with AI spends one request from the daily allowance.
class ReceiptScannerScreenGated extends StatelessWidget {
  /// When true, the scanner returns the parsed data to the caller (via
  /// Navigator.pop) instead of opening a new add-transaction screen.
  final bool returnResult;

  const ReceiptScannerScreenGated({super.key, this.returnResult = false});

  @override
  Widget build(BuildContext context) =>
      ReceiptScannerScreen(returnResult: returnResult);
}

/// Photograph a receipt; the device reads the text and the AI turns it into a
/// transaction: merchant, total, date, line items and a category.
///
/// The on-device reading always runs and gives a rough draft (merchant and
/// total), so the scanner still works with no AI requests left. Premium users
/// get the AI reading straight away; free users choose to spend a request on
/// it, or watch an ad when they have none.
class ReceiptScannerScreen extends ConsumerStatefulWidget {
  final bool returnResult;

  const ReceiptScannerScreen({super.key, this.returnResult = false});

  @override
  ConsumerState<ReceiptScannerScreen> createState() =>
      _ReceiptScannerScreenState();
}

class _ReceiptScannerScreenState extends ConsumerState<ReceiptScannerScreen> {
  File? _image;
  final _picker = ImagePicker();
  final _merchant = TextEditingController();
  final _amount = TextEditingController();

  ReceiptReading? _ai;
  bool _aiBusy = false;
  String? _aiError;
  DateTime? _date;
  String? _category;

  @override
  void dispose() {
    _merchant.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _capture(ImageSource source) async {
    final l10n = L10n.of(context);
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 92);
      if (picked == null) return;
      setState(() {
        _image = File(picked.path);
        _ai = null;
        _aiError = null;
        _date = null;
        _category = null;
      });
      await ref.read(ocrProvider.notifier).extractReceiptData(_image!);
      if (!mounted) return;
      // Premium never has to think about it: read it properly at once.
      if (ref.read(aiQuotaProvider).unlimited) await _readWithAi();
    } catch (_) {
      if (!mounted) return;
      showSunriseSnack(
        context,
        source == ImageSource.camera ? l10n.ocrNoCamera : l10n.ocrNoGallery,
        tone: SnackTone.error,
      );
    }
  }

  Future<void> _readWithAi() async {
    final text = ref.read(ocrProvider).receiptData?.rawText ?? '';
    if (text.trim().isEmpty || _aiBusy) return;

    if (!ref.read(aiQuotaProvider).hasCallsLeft) {
      final earned = await earnWithAd(context, ref, RewardKind.aiCall);
      if (!earned || !mounted) return;
    }

    setState(() {
      _aiBusy = true;
      _aiError = null;
    });
    try {
      final categories = ref
          .read(categoryProvider)
          .categories
          .where((c) => c.type == 'expense')
          .map((c) => c.name)
          .toList();
      final reading = await ref
          .read(aiApiProvider)
          .readReceipt(
            ocrText: text,
            categories: categories,
            currency: ref.read(defaultCurrencyProvider),
            language: FinanceContextBuilder.languageOf(ref.read),
          );
      if (!mounted) return;
      setState(() {
        _ai = reading;
        _date = reading.date;
        _category = reading.category;
        if ((reading.merchant ?? '').isNotEmpty) {
          _merchant.text = reading.merchant!;
        }
        if (reading.total != null) {
          _amount.text = reading.total!.toStringAsFixed(2);
        }
      });
    } on AiException catch (e) {
      if (mounted) setState(() => _aiError = e.message);
    } finally {
      if (mounted) setState(() => _aiBusy = false);
      ref.read(aiQuotaProvider.notifier).refresh();
    }
  }

  void _save() {
    final result = (
      amount: double.tryParse(_amount.text.trim().replaceAll(',', '')) ?? 0,
      title: _merchant.text.trim(),
      category: _category,
      date: _date,
      note: _ai?.note,
    );
    if (widget.returnResult) {
      Navigator.pop(context, result);
    } else {
      showAddTransactionScreen(
        context,
        initialType: TransactionTypeSelection.expense,
        prefillAmount: result.amount,
        prefillTitle: result.title,
        prefillCategoryName: result.category,
        prefillDate: result.date,
        prefillNote: result.note,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final ocr = ref.watch(ocrProvider);

    // Prefill the editable fields once the on-device reading lands.
    ref.listen<OcrState>(ocrProvider, (previous, next) {
      final data = next.receiptData;
      if (data != null &&
          !identical(data, previous?.receiptData) &&
          _ai == null) {
        _merchant.text = data.merchant;
        _amount.text = data.total > 0 ? data.total.toStringAsFixed(2) : '';
      }
    });

    final hasDraft = ocr.receiptData != null && !ocr.isProcessing;

    return SunrisePushPage(
      title: l10n.aiScanReceipt,
      children: [
        _CaptureCard(
          hasImage: _image != null,
          busy: ocr.isProcessing || _aiBusy,
          onCamera: () => _capture(ImageSource.camera),
          onGallery: () => _capture(ImageSource.gallery),
        ),
        if (_image != null) ...[
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(SunriseRadius.card),
            child: Image.file(
              _image!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
        if (ocr.isProcessing || _aiBusy) ...[
          const SizedBox(height: 14),
          _Working(
            label: _aiBusy ? l10n.ocrReadingWithAi : l10n.aiReadingYourReceipt,
          ),
        ],
        if (ocr.errorMessage != null && !ocr.isProcessing) ...[
          const SizedBox(height: 14),
          _Notice(text: l10n.ocrNothingRead, negative: true),
        ],
        if (hasDraft && _ai == null && !_aiBusy) ...[
          const SizedBox(height: 14),
          _AiOffer(error: _aiError, onRead: _readWithAi),
        ],
        if (hasDraft && !_aiBusy) ...[
          const SizedBox(height: 14),
          _Review(
            merchant: _merchant,
            amount: _amount,
            date: _date,
            category: _category,
            reading: _ai,
            onSave: _save,
          ),
        ],
      ],
    );
  }
}

class _CaptureCard extends StatelessWidget {
  const _CaptureCard({
    required this.hasImage,
    required this.busy,
    required this.onCamera,
    required this.onGallery,
  });

  final bool hasImage;
  final bool busy;
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    return SunriseCard(
      child: Column(
        children: [
          IconTile(
            icon: Symbols.document_scanner_rounded,
            color: c.onFill,
            gradient: c.gradient,
            size: 56,
            fill: 1,
          ),
          const SizedBox(height: 14),
          Text(
            hasImage ? l10n.ocrScanAnother : l10n.ocrScanTitle,
            style: SunriseType.section.copyWith(color: c.ink),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.ocrScanBody,
            textAlign: TextAlign.center,
            style: SunriseType.body.copyWith(color: c.muted),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: SunriseButton(
                  label: l10n.aiCamera,
                  icon: Symbols.photo_camera_rounded,
                  height: 50,
                  onPressed: busy ? null : onCamera,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SunriseButton(
                  label: l10n.aiGallery,
                  icon: Symbols.photo_library_rounded,
                  style: SunriseButtonStyle.secondary,
                  height: 50,
                  onPressed: busy ? null : onGallery,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Working extends StatelessWidget {
  const _Working({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return SunriseCard(
      child: Row(
        children: [
          const SizedBox(width: 22, height: 22, child: SunriseLoader()),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label, style: SunriseType.label.copyWith(color: c.ink)),
          ),
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.text, this.negative = false});

  final String text;
  final bool negative;

  @override
  Widget build(BuildContext context) {
    final c = context.sunrise;
    return SunriseCard(
      shadow: false,
      color: negative ? c.tintRose : c.tintPeach,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(
            negative ? Symbols.error_rounded : Symbols.info_rounded,
            color: negative ? c.negative : c.accent,
            fill: 1,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: SunriseType.body.copyWith(color: c.body)),
          ),
        ],
      ),
    );
  }
}

/// Offers the AI reading to free users, saying what it costs.
class _AiOffer extends ConsumerWidget {
  const _AiOffer({required this.error, required this.onRead});

  final String? error;
  final VoidCallback onRead;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final quota = ref.watch(aiQuotaProvider);
    final left = quota.remaining ?? 0;

    return SunriseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Symbols.auto_awesome_rounded, color: c.accent, fill: 1),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.ocrAiOfferTitle,
                  style: SunriseType.rowTitle.copyWith(color: c.ink),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            error ?? l10n.ocrAiOfferBody,
            style: SunriseType.body.copyWith(
              color: error == null ? c.muted : c.negative,
            ),
          ),
          const SizedBox(height: 12),
          SunriseButton(
            label: quota.unlimited || left > 0
                ? l10n.ocrReadWithAi
                : l10n.adWatch,
            icon: quota.unlimited || left > 0
                ? Symbols.auto_awesome_rounded
                : Symbols.play_circle_rounded,
            height: 48,
            onPressed: onRead,
          ),
          if (!quota.unlimited) ...[
            const SizedBox(height: 8),
            Text(
              left > 0 ? l10n.aiQuotaLeft(left) : l10n.aiOutOfRequestsTitle,
              style: SunriseType.caption.copyWith(color: c.muted),
            ),
          ],
        ],
      ),
    );
  }
}

class _Review extends ConsumerWidget {
  const _Review({
    required this.merchant,
    required this.amount,
    required this.date,
    required this.category,
    required this.reading,
    required this.onSave,
  });

  final TextEditingController merchant;
  final TextEditingController amount;
  final DateTime? date;
  final String? category;
  final ReceiptReading? reading;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final items = reading?.items ?? const [];
    final locale = Localizations.localeOf(context).toString();

    return SunriseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Symbols.check_circle_rounded, color: c.positive, fill: 1),
              const SizedBox(width: 8),
              Text(
                l10n.aiReviewSave,
                style: SunriseType.rowTitle.copyWith(color: c.ink),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            reading != null ? l10n.ocrReadByAi : l10n.aiWeReadThisFromYour,
            style: SunriseType.caption.copyWith(color: c.muted),
          ),
          const SizedBox(height: 16),
          SunriseTextField(
            controller: merchant,
            label: l10n.aiMerchantTitle,
            icon: Symbols.storefront_rounded,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          SunriseTextField(
            controller: amount,
            label: l10n.filterAmount,
            hint: '0.00',
            icon: Symbols.payments_rounded,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
          ),
          if (date != null || category != null) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (date != null)
                  SunrisePill(
                    icon: Symbols.event_rounded,
                    label: DateFormat.yMMMd(locale).format(date!),
                  ),
                if (category != null)
                  SunrisePill(icon: Symbols.category_rounded, label: category!),
              ],
            ),
          ],
          if (items.isNotEmpty) ...[
            const SizedBox(height: 14),
            SectionLabel(l10n.ocrItems),
            for (final item in items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: SunriseType.body.copyWith(color: c.body),
                      ),
                    ),
                    if (item.amount != null)
                      Text(
                        item.amount!.toStringAsFixed(2),
                        style: SunriseType.label.copyWith(color: c.ink),
                      ),
                  ],
                ),
              ),
          ],
          if ((reading?.note ?? '').isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              reading!.note!,
              style: SunriseType.caption.copyWith(color: c.muted),
            ),
          ],
          const SizedBox(height: 18),
          SunriseButton(
            label: l10n.aiSaveAsTransaction,
            icon: Symbols.check_rounded,
            onPressed: onSave,
          ),
        ],
      ),
    );
  }
}

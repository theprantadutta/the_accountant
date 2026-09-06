import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/currency_provider.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/utils/color_utils.dart';
import 'package:the_accountant/core/utils/currency_formatter.dart';
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/features/objectives/providers/objectives_provider.dart';
import 'package:the_accountant/features/objectives/services/objectives_service.dart';
import 'package:the_accountant/features/premium/exceptions/premium_limit_exception.dart';
import 'package:the_accountant/features/premium/widgets/upgrade_limit_dialog.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/shared/widgets/color_picker.dart';
import 'package:the_accountant/shared/widgets/icon_picker.dart';

/// Create or edit a goal.
///
/// The app has had a complete objectives service, a database table, sync in
/// both directions and a picker on the transaction form for a long time, and
/// no way at all to make one — so the picker was always empty and the help
/// screen described a section that did not exist.
class AddObjectiveScreen extends ConsumerStatefulWidget {
  /// The goal being edited, or null to create one.
  final ObjectiveWithProgress? objective;

  const AddObjectiveScreen({super.key, this.objective});

  bool get isEditing => objective != null;

  @override
  ConsumerState<AddObjectiveScreen> createState() => _AddObjectiveScreenState();
}

class _AddObjectiveScreenState extends ConsumerState<AddObjectiveScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;

  late String _iconName;
  late String _color;
  late DateTime _startDate;
  DateTime? _endDate;
  late bool _isPinned;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final o = widget.objective?.objective;
    _nameController = TextEditingController(text: o?.name ?? '');
    _amountController = TextEditingController(
      text: o == null ? '' : (o.targetAmount / 100).toStringAsFixed(2),
    );
    _iconName = o?.iconName ?? 'flag';
    _color = o?.color ?? '#6366F1';
    _startDate = o?.startDate ?? _today();
    _endDate = o?.endDate;
    _isPinned = o?.isPinned ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(defaultCurrencyProvider);
    final dateFormat = ref.watch(dateFormatSettingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit goal' : 'New goal'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(L10n.of(context).actionSave),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.paddingLg,
          children: [
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: L10n.of(context).goalWhatAreYouSavingFor,
                hintText: L10n.of(context).goalNewLaptop,
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Give the goal a name'
                  : null,
            ),
            AppSpacing.gapLg,

            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: L10n.of(context).goalTarget,
                prefixText: '$currency ',
                border: const OutlineInputBorder(),
              ),
              validator: (v) {
                final cents = (v ?? '').toCentsOrNull();
                if (cents == null) return 'Enter an amount';
                if (cents <= 0) return 'The target must be more than zero';
                return null;
              },
            ),
            AppSpacing.gapXl,

            IconPicker(
              selectedIcon: _iconName,
              selectedColor: ColorUtils.hexToColor(_color),
              label: L10n.of(context).walletIcon,
              onIconSelected: (name) => setState(() => _iconName = name),
            ),
            AppSpacing.gapLg,
            ColorPicker(
              selectedColor: _color,
              label: L10n.of(context).goalColour,
              onColorSelected: (hex) => setState(() => _color = hex),
            ),
            AppSpacing.gapXl,

            Text(
              L10n.of(context).goalStarted,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.gapSm,
            _DateRow(
              label: AppDateFormatter.formatDate(_startDate, dateFormat),
              onTap: () => _pickDate(
                initial: _startDate,
                onPicked: (d) => setState(() => _startDate = d),
              ),
            ),
            AppSpacing.gapLg,
            Text(
              L10n.of(context).goalTargetDate,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.gapSm,
            _DateRow(
              label: _endDate == null
                  ? 'No deadline'
                  : AppDateFormatter.formatDate(_endDate!, dateFormat),
              onClear: _endDate == null
                  ? null
                  : () => setState(() => _endDate = null),
              onTap: () => _pickDate(
                initial: _endDate ?? _startDate,
                onPicked: (d) => setState(() => _endDate = d),
              ),
            ),
            AppSpacing.gapSm,
            Text(
              L10n.of(context).goalWithADateTheGoal,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            AppSpacing.gapXl,

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _isPinned,
              onChanged: (v) => setState(() => _isPinned = v),
              title: Text(L10n.of(context).goalShowOnTheHomeScreen),
            ),
            AppSpacing.gapXxl,
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate({
    required DateTime initial,
    required ValueChanged<DateTime> onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 20),
    );
    if (picked != null) onPicked(picked);
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final cents = _amountController.text.toCentsOrNull();
    if (cents == null) return;

    if (_endDate != null && !_endDate!.isAfter(_startDate)) {
      _showMessage('The target date has to come after the start date.');
      return;
    }

    setState(() => _saving = true);
    final notifier = ref.read(objectivesProvider.notifier);

    try {
      if (widget.isEditing) {
        await notifier.updateObjective(
          objectiveId: widget.objective!.objective.id,
          name: _nameController.text.trim(),
          targetAmount: cents,
          endDate: _endDate,
          iconName: _iconName,
          color: _color,
          isPinned: _isPinned,
        );
      } else {
        await notifier.createObjective(
          name: _nameController.text.trim(),
          targetAmount: cents,
          type: 'goal',
          startDate: _startDate,
          endDate: _endDate,
          iconName: _iconName,
          color: _color,
          isPinned: _isPinned,
        );
      }
      if (mounted) Navigator.pop(context);
    } on PremiumLimitException catch (e) {
      if (mounted) await UpgradeLimitDialog.showFromException(context, e);
    } catch (e) {
      if (mounted) _showMessage('Could not save the goal.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _DateRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _DateRow({required this.label, required this.onTap, this.onClear});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 16),
            const SizedBox(width: 10),
            Expanded(child: Text(label)),
            if (onClear != null)
              IconButton(
                icon: const Icon(Icons.clear, size: 18),
                onPressed: onClear,
                tooltip: L10n.of(context).goalClear,
              ),
          ],
        ),
      ),
    );
  }
}

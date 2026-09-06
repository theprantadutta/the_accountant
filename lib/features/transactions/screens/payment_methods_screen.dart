import 'package:flutter/material.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/features/premium/exceptions/premium_limit_exception.dart';
import 'package:the_accountant/features/premium/widgets/upgrade_limit_dialog.dart';
import 'package:the_accountant/features/settings/widgets/confirmation_dialog.dart';
import 'package:the_accountant/features/transactions/providers/payment_method_provider.dart';

/// The cards and accounts a transaction can be paid with.
///
/// The table, the provider and even a free-tier limit have all existed for a
/// long time; nothing in the app could create one. The chip row on the
/// transaction form hides itself when the list is empty, so the whole feature
/// was invisible and the limit unreachable.
class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  static const Map<String, ({String label, IconData icon})> _kinds = {
    'card': (label: 'Card', icon: Icons.credit_card),
    'bank': (label: 'Bank account', icon: Icons.account_balance),
    'cash': (label: 'Cash', icon: Icons.payments_outlined),
    'digital_wallet': (label: 'Digital wallet', icon: Icons.phone_iphone),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paymentMethodProvider);

    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).payTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context, ref),
        icon: const Icon(Icons.add),
        label: Text(L10n.of(context).actionAdd),
      ),
      body: state.isLoading && state.paymentMethods.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.paymentMethods.isEmpty
          ? _empty(context, ref)
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 96),
              itemCount: state.paymentMethods.length,
              itemBuilder: (context, index) {
                final method = state.paymentMethods[index];
                final kind = _kinds[method.type] ?? _kinds['card']!;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.glassWhite,
                    child: Icon(kind.icon, color: AppColors.textSecondary),
                  ),
                  title: Text(method.name),
                  subtitle: Text(
                    [
                      kind.label,
                      if (method.institution?.isNotEmpty ?? false)
                        method.institution!,
                      if (method.lastFourDigits?.isNotEmpty ?? false)
                        '···· ${method.lastFourDigits}',
                    ].join(' · '),
                  ),
                  trailing: method.isDefault
                      ? Chip(
                          label: Text(L10n.of(context).payDefault),
                          visualDensity: VisualDensity.compact,
                        )
                      : null,
                  onTap: () => _edit(context, ref, existing: method),
                  onLongPress: () => _delete(context, ref, method),
                );
              },
            ),
    );
  }

  Widget _empty(BuildContext context, WidgetRef ref) => Center(
    child: Padding(
      padding: AppSpacing.paddingXl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.glassWhite,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.credit_card,
              size: 40,
              color: AppColors.textMuted,
            ),
          ),
          AppSpacing.gapXl,
          Text(
            L10n.of(context).txNoPaymentMethods,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            'Add the cards and accounts you pay with, and you can pick one on '
            'a transaction.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          AppSpacing.gapXl,
          FilledButton.icon(
            onPressed: () => _edit(context, ref),
            icon: const Icon(Icons.add),
            label: Text(L10n.of(context).payAddOne),
          ),
        ],
      ),
    ),
  );

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref, {
    PaymentMethod? existing,
  }) async {
    final result = await showDialog<_MethodDraft>(
      context: context,
      builder: (context) => _MethodDialog(existing: existing),
    );
    if (result == null || !context.mounted) return;

    final notifier = ref.read(paymentMethodProvider.notifier);
    try {
      if (existing == null) {
        await notifier.addPaymentMethod(
          name: result.name,
          type: result.type,
          lastFourDigits: result.lastFour,
          institution: result.institution,
          isDefault: result.isDefault,
        );
      } else {
        await notifier.updatePaymentMethod(
          id: existing.id,
          name: result.name,
          type: result.type,
          lastFourDigits: result.lastFour,
          institution: result.institution,
          isDefault: result.isDefault,
        );
      }
    } on PremiumLimitException catch (e) {
      if (context.mounted) {
        await UpgradeLimitDialog.showFromException(context, e);
      }
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    PaymentMethod method,
  ) async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: L10n.of(context).payDeleteTitle(method.name),
      message:
          'Transactions already filed against it keep their record. They '
          'simply stop naming a payment method.',
      confirmText: L10n.of(context).actionDelete,
      isDangerous: true,
    );
    if (confirmed != true || !context.mounted) return;
    await ref
        .read(paymentMethodProvider.notifier)
        .deletePaymentMethod(method.id);
  }
}

typedef _MethodDraft = ({
  String name,
  String type,
  String? lastFour,
  String? institution,
  bool isDefault,
});

class _MethodDialog extends StatefulWidget {
  final PaymentMethod? existing;

  const _MethodDialog({this.existing});

  @override
  State<_MethodDialog> createState() => _MethodDialogState();
}

class _MethodDialogState extends State<_MethodDialog> {
  late final TextEditingController _name;
  late final TextEditingController _lastFour;
  late final TextEditingController _institution;
  late String _type;
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _lastFour = TextEditingController(text: e?.lastFourDigits ?? '');
    _institution = TextEditingController(text: e?.institution ?? '');
    _type = e?.type ?? 'card';
    _isDefault = e?.isDefault ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    _lastFour.dispose();
    _institution.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Only a card has a last four, and only a card or bank has an institution;
    // asking for either on cash is a question with no answer.
    final hasCardDetails = _type == 'card';
    final hasInstitution = _type == 'card' || _type == 'bank';

    return AlertDialog(
      title: Text(
        widget.existing == null ? 'New payment method' : 'Edit payment method',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: L10n.of(context).payName,
                hintText: L10n.of(context).payNameHint,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: InputDecoration(labelText: L10n.of(context).payKind),
              items: [
                for (final entry in PaymentMethodsScreen._kinds.entries)
                  DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value.label),
                  ),
              ],
              onChanged: (v) => setState(() => _type = v!),
            ),
            if (hasInstitution) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _institution,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: L10n.of(context).payBankOrIssuer,
                ),
              ),
            ],
            if (hasCardDetails) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _lastFour,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(
                  labelText: L10n.of(context).payLastFour,
                  counterText: '',
                ),
              ),
            ],
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _isDefault,
              onChanged: (v) => setState(() => _isDefault = v),
              title: Text(L10n.of(context).payUseByDefault),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(L10n.of(context).actionCancel),
        ),
        FilledButton(
          onPressed: () {
            final name = _name.text.trim();
            if (name.isEmpty) return;
            Navigator.pop(context, (
              name: name,
              type: _type,
              lastFour: hasCardDetails && _lastFour.text.trim().isNotEmpty
                  ? _lastFour.text.trim()
                  : null,
              institution: hasInstitution && _institution.text.trim().isNotEmpty
                  ? _institution.text.trim()
                  : null,
              isDefault: _isDefault,
            ));
          },
          child: Text(L10n.of(context).actionSave),
        ),
      ],
    );
  }
}

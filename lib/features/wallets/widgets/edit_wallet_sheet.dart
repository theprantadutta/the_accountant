import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/wallet.dart' show WalletType;
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/features/wallets/widgets/add_wallet_form.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Edit [wallet] in a sheet. The one way to edit an account, wherever it is
/// opened from, so the dashboard and the accounts screen save the same way.
Future<void> showEditWalletSheet(
  BuildContext context,
  WidgetRef ref,
  Wallet wallet,
) {
  final nameController = TextEditingController(text: wallet.name);
  final balanceController = TextEditingController(
    text: (wallet.balance / 100.0).toStringAsFixed(2),
  );
  final formKey = GlobalKey<FormState>();

  return showSunriseSheet<void>(
    context: context,
    builder: (sheetContext) => SunriseBottomSheet(
      child: AddWalletForm(
        formKey: formKey,
        nameController: nameController,
        balanceController: balanceController,
        initialCurrency: wallet.currency,
        initialIcon: wallet.iconName,
        initialColor: wallet.color,
        initialIsDefault: wallet.isDefault,
        initialUseDecimals: wallet.useDecimals,
        initialWalletType: wallet.walletType,
        initialCreditLimit: wallet.creditLimit == null
            ? null
            : wallet.creditLimit! / 100.0,
        initialBillingCycleDay: wallet.billingCycleDay,
        isEditing: true,
        onSubmit:
            ({
              required String currency,
              required String icon,
              required String color,
              required bool isDefault,
              required bool useDecimals,
              required WalletType walletType,
              required double? creditLimit,
              required int? billingCycleDay,
              required int? balance,
            }) async {
              final saved = L10n.of(context).walletAccountUpdatedSuccessfully;
              Navigator.pop(sheetContext);
              await ref
                  .read(walletProvider.notifier)
                  .saveEdits(
                    wallet: wallet,
                    name: nameController.text,
                    currency: currency,
                    iconName: icon,
                    color: color,
                    isDefault: isDefault,
                    useDecimals: useDecimals,
                    walletType: walletType,
                    creditLimit: creditLimit == null
                        ? null
                        : (creditLimit * 100).round(),
                    billingCycleDay: billingCycleDay,
                    balance: balance,
                  );
              if (context.mounted) {
                showSunriseSnack(context, saved, tone: SnackTone.success);
              }
            },
        onCancel: () => Navigator.pop(sheetContext),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/domain/transaction_policy.dart';
import 'package:the_accountant/features/plans/widgets/plan_labels.dart';
import 'package:the_accountant/features/split/providers/split_provider.dart';
import 'package:the_accountant/features/transactions/screens/transaction_detail_screen.dart';
import 'package:the_accountant/features/wallets/providers/wallet_provider.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Every part of the split a transaction belongs to, on its detail page.
///
/// A split is written as separate rows, so without this the user's share and
/// what each friend owes would only be found one at a time in different lists.
class SplitPartsCard extends ConsumerWidget {
  const SplitPartsCard({
    super.key,
    required this.splitId,
    required this.currentId,
  });

  final String splitId;

  /// The row whose page this is, which is not a link to itself.
  final String currentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final c = context.sunrise;
    final f = PlanFormat(ref, context);
    final parts = ref.watch(splitPartsProvider(splitId)).value ?? const [];
    if (parts.length < 2) return const SizedBox.shrink();
    final wallets = ref.watch(walletProvider).wallets;

    return Padding(
      padding: const EdgeInsets.only(bottom: SunriseSpace.section),
      child: SettingsGroup(
        label: l10n.splitPartOf,
        children: [
          for (final t in parts)
            SettingsRow(
              key: Key('split_part_${t.id}'),
              icon: TransactionPolicy.isCreditOrDebt(t)
                  ? Symbols.group_rounded
                  : Symbols.person_rounded,
              iconColor: t.id == currentId ? c.accent : c.muted,
              title: TransactionPolicy.isCreditOrDebt(t)
                  ? t.title
                  : l10n.splitYourShare,
              subtitle: TransactionPolicy.isCredit(t)
                  ? l10n.txLentMoney
                  : TransactionPolicy.isDebt(t)
                  ? l10n.txBorrowedMoney
                  : (t.title.isEmpty ? null : t.title),
              value: f.money(
                t.amount,
                wallets
                        .where((w) => w.id == t.walletId)
                        .firstOrNull
                        ?.currency ??
                    '',
              ),
              trailing: t.id == currentId
                  ? SettingsTrailing.none
                  : SettingsTrailing.chevron,
              onTap: t.id == currentId
                  ? null
                  : () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) =>
                            TransactionDetailScreen(transactionId: t.id),
                      ),
                    ),
            ),
        ],
      ),
    );
  }
}

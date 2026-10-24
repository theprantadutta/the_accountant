import 'package:flutter/material.dart';
import 'package:the_accountant/features/zakat/domain/zakat_settings.dart';
import 'package:the_accountant/features/zakat/services/zakat_service.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Names and icons for the parts of a zakat calculation, in one place.
extension ZakatGroupLabels on ZakatGroup {
  String label(L10n l10n) => switch (this) {
    ZakatGroup.cash => l10n.zakatGroupCash,
    ZakatGroup.deposits => l10n.zakatGroupDeposits,
    ZakatGroup.investments => l10n.zakatGroupInvestments,
    ZakatGroup.metals => l10n.zakatGroupMetals,
    ZakatGroup.lent => l10n.zakatGroupLent,
    ZakatGroup.otherAssets => l10n.zakatGroupOtherAssets,
    ZakatGroup.paid => l10n.zakatGroupPaid,
    ZakatGroup.manual => l10n.zakatGroupManual,
    ZakatGroup.borrowed => l10n.zakatGroupBorrowed,
    ZakatGroup.cards => l10n.zakatGroupCards,
  };

  IconData get icon => switch (this) {
    ZakatGroup.cash => Symbols.account_balance_wallet_rounded,
    ZakatGroup.deposits => Symbols.savings_rounded,
    ZakatGroup.investments => Symbols.trending_up_rounded,
    ZakatGroup.metals => Symbols.diamond_rounded,
    ZakatGroup.lent => Symbols.handshake_rounded,
    ZakatGroup.otherAssets => Symbols.home_work_rounded,
    ZakatGroup.paid => Symbols.volunteer_activism_rounded,
    ZakatGroup.manual => Symbols.edit_note_rounded,
    ZakatGroup.borrowed => Symbols.account_balance_rounded,
    ZakatGroup.cards => Symbols.credit_card_rounded,
  };
}

extension NisabBasisLabels on NisabBasis {
  String label(L10n l10n) => switch (this) {
    NisabBasis.gold => l10n.zakatBasisGold,
    NisabBasis.silver => l10n.zakatBasisSilver,
  };

  /// The weight as it is usually written, without trailing zeros.
  String get gramsText =>
      grams.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
}

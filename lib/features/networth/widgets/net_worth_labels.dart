import 'package:flutter/material.dart';
import 'package:the_accountant/features/networth/services/asset_service.dart';
import 'package:the_accountant/features/networth/services/net_worth_service.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart';

/// Names, icons and colours for the kinds of asset, in one place.
extension AssetKindLabels on AssetKind {
  String label(L10n l10n) => switch (this) {
    AssetKind.land => l10n.assetKindLand,
    AssetKind.home => l10n.assetKindHome,
    AssetKind.car => l10n.assetKindCar,
    AssetKind.gold => l10n.assetKindGold,
    AssetKind.other => l10n.assetKindOther,
  };

  String nameHint(L10n l10n) => switch (this) {
    AssetKind.land => l10n.assetNameHintLand,
    AssetKind.home => l10n.assetNameHintHome,
    AssetKind.car => l10n.assetNameHintCar,
    AssetKind.gold => l10n.assetNameHintGold,
    AssetKind.other => l10n.assetNameHintOther,
  };

  IconData get icon => switch (this) {
    AssetKind.land => Symbols.landscape_rounded,
    AssetKind.home => Symbols.home_rounded,
    AssetKind.car => Symbols.directions_car_rounded,
    AssetKind.gold => Symbols.diamond_rounded,
    AssetKind.other => Symbols.category_rounded,
  };

  Color get color => switch (this) {
    AssetKind.land => const Color(0xFF65A30D),
    AssetKind.home => const Color(0xFF0EA5E9),
    AssetKind.car => const Color(0xFF64748B),
    AssetKind.gold => const Color(0xFFCA8A04),
    AssetKind.other => const Color(0xFFA855F7),
  };
}

/// Names and icons for the lines of net worth.
extension NetWorthPartLabels on NetWorthPart {
  String label(L10n l10n) => switch (this) {
    NetWorthPart.cash => l10n.netWorthCash,
    NetWorthPart.cards => l10n.netWorthCards,
    NetWorthPart.deposits => l10n.netWorthDeposits,
    NetWorthPart.investments => l10n.investmentsTitle,
    NetWorthPart.assets => l10n.netWorthAssets,
    NetWorthPart.lent => l10n.netWorthLent,
    NetWorthPart.borrowed => l10n.netWorthBorrowed,
  };

  IconData get icon => switch (this) {
    NetWorthPart.cash => Symbols.account_balance_wallet_rounded,
    NetWorthPart.cards => Symbols.credit_card_rounded,
    NetWorthPart.deposits => Symbols.savings_rounded,
    NetWorthPart.investments => Symbols.trending_up_rounded,
    NetWorthPart.assets => Symbols.home_work_rounded,
    NetWorthPart.lent => Symbols.call_made_rounded,
    NetWorthPart.borrowed => Symbols.call_received_rounded,
  };

  Color get color => switch (this) {
    NetWorthPart.cash => const Color(0xFFEA580C),
    NetWorthPart.cards => const Color(0xFF7C3AED),
    NetWorthPart.deposits => const Color(0xFF0EA5E9),
    NetWorthPart.investments => const Color(0xFF2563EB),
    NetWorthPart.assets => const Color(0xFF65A30D),
    NetWorthPart.lent => const Color(0xFF059669),
    NetWorthPart.borrowed => const Color(0xFFDC2626),
  };
}

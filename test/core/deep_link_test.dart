import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/app_destination.dart';

/// Where a launcher shortcut sends someone.
///
/// Links are not accepted at all; a shortcut or a tapped notification is the
/// only way in, and both are written by the app itself.
void main() {
  group('launcher shortcuts', () {
    test('each one names its destination', () {
      expect(
        DeepLinkParser.forShortcut(DeepLinkParser.shortcutAddExpense),
        const DeepLink(AppDestination.addExpense),
      );
      expect(
        DeepLinkParser.forShortcut(DeepLinkParser.shortcutAddIncome),
        const DeepLink(AppDestination.addIncome),
      );
      expect(
        DeepLinkParser.forShortcut(DeepLinkParser.shortcutScanReceipt),
        const DeepLink(AppDestination.scanReceipt),
      );
      expect(
        DeepLinkParser.forShortcut(DeepLinkParser.shortcutTransactions),
        const DeepLink(AppDestination.transactions),
      );
    });

    test('one this build no longer has is ignored', () {
      // A shortcut already sitting on somebody's home screen outlives the
      // release that created it.
      expect(DeepLinkParser.forShortcut('removed_in_a_later_version'), isNull);
      expect(DeepLinkParser.forShortcut(''), isNull);
    });

    test('the ids are stable and distinct', () {
      const ids = [
        DeepLinkParser.shortcutAddExpense,
        DeepLinkParser.shortcutAddIncome,
        DeepLinkParser.shortcutScanReceipt,
        DeepLinkParser.shortcutTransactions,
      ];

      expect(ids.toSet(), hasLength(ids.length));
      expect(ids.every((id) => id.isNotEmpty), isTrue);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/domain/app_destination.dart';

/// Where an incoming link is allowed to send someone.
///
/// A link is untrusted input — anyone can put one in an email or a web page —
/// so the whole job here is to be total and narrow: name a place or name
/// nothing, never guess, and never treat somebody else's domain as ours.
void main() {
  DeepLink? parse(String uri) => DeepLinkParser.parse(Uri.parse(uri));

  group('the app own scheme', () {
    test('a bare link opens the dashboard', () {
      expect(
        parse('theaccountant://'),
        const DeepLink(AppDestination.dashboard),
      );
    });

    test('the first word lands in the host, not the path', () {
      // theaccountant://budgets parses with host 'budgets' and no segments,
      // which is the trap in custom-scheme links.
      expect(
        parse('theaccountant://budgets'),
        const DeepLink(AppDestination.budgets),
      );
      expect(
        parse('theaccountant://transactions'),
        const DeepLink(AppDestination.transactions),
      );
      expect(
        parse('theaccountant://reports'),
        const DeepLink(AppDestination.reports),
      );
      expect(
        parse('theaccountant://settings'),
        const DeepLink(AppDestination.settings),
      );
    });

    test('a two-part path is read as one', () {
      expect(
        parse('theaccountant://add/expense'),
        const DeepLink(AppDestination.addExpense),
      );
      expect(
        parse('theaccountant://add/income'),
        const DeepLink(AppDestination.addIncome),
      );
      expect(
        parse('theaccountant://add/transfer'),
        const DeepLink(AppDestination.addTransfer),
      );
    });

    test('the longer match wins', () {
      expect(
        parse('theaccountant://add'),
        const DeepLink(AppDestination.addExpense),
      );
      expect(
        parse('theaccountant://add/income'),
        const DeepLink(AppDestination.addIncome),
        reason: 'otherwise add/income would resolve as plain add',
      );
    });

    test('case does not matter in the path', () {
      expect(
        parse('theaccountant://Add/Income'),
        const DeepLink(AppDestination.addIncome),
      );
    });

    test('a trailing slash is not a different address', () {
      expect(
        parse('theaccountant://budgets/'),
        const DeepLink(AppDestination.budgets),
      );
    });
  });

  group('web links', () {
    test('the verified host opens the app', () {
      expect(
        parse('https://theaccountant.pranta.dev/budgets'),
        const DeepLink(AppDestination.budgets),
      );
      expect(
        parse('https://theaccountant.pranta.dev/'),
        const DeepLink(AppDestination.dashboard),
      );
    });

    test('a lookalike domain is not ours', () {
      // The whole point of matching the host exactly.
      expect(
        parse('https://theaccountant.pranta.dev.example.com/budgets'),
        isNull,
      );
      expect(parse('https://eviltheaccountant.pranta.dev/budgets'), isNull);
      expect(parse('https://pranta.dev/budgets'), isNull);
    });

    test('a subdomain is not ours either', () {
      expect(parse('https://api.theaccountant.pranta.dev/budgets'), isNull);
    });

    test('some other scheme entirely is refused', () {
      expect(parse('ftp://theaccountant.pranta.dev/budgets'), isNull);
      expect(parse('javascript:alert(1)'), isNull);
      expect(parse('file:///etc/passwd'), isNull);
    });
  });

  group('opening one transaction', () {
    test('the id is carried through', () {
      expect(
        parse('theaccountant://transaction/abc-123'),
        const DeepLink(AppDestination.transactionDetail, entityId: 'abc-123'),
      );
    });

    test('over https too', () {
      expect(
        parse('https://theaccountant.pranta.dev/transaction/abc-123'),
        const DeepLink(AppDestination.transactionDetail, entityId: 'abc-123'),
      );
    });

    test('without an id it names nothing', () {
      expect(parse('theaccountant://transaction'), isNull);
      expect(parse('theaccountant://transaction/'), isNull);
    });

    test('an extra segment is not silently ignored', () {
      expect(
        parse('theaccountant://transaction/abc/delete'),
        isNull,
        reason:
            'a link may name a place and never carry an instruction; reading '
            'only the part that is understood is how the rest gets obeyed by '
            'accident later',
      );
    });
  });

  group('an address the app does not know', () {
    test('is refused rather than guessed at', () {
      expect(parse('theaccountant://something-else'), isNull);
      expect(parse('theaccountant://settings/danger'), isNull);
      expect(parse('https://theaccountant.pranta.dev/nope'), isNull);
    });
  });

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

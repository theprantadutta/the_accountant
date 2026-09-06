import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/features/dashboard/domain/home_layout.dart';

/// Which blocks the home screen shows, and in what order.
///
/// Most of this is about one thing: a layout saved by an older build has to
/// survive the app changing underneath it. A stored order is a list of names,
/// and names come and go between releases.
void main() {
  group('the default', () {
    test('is every section, in the order the app declares them', () {
      expect(HomeLayout.initial.order, HomeSection.values);
      expect(HomeLayout.initial.hidden, isEmpty);
      expect(HomeLayout.initial.isDefault, isTrue);
    });

    test('nothing stored means the default', () {
      expect(HomeLayout.decode(null).isDefault, isTrue);
      expect(HomeLayout.decode('').isDefault, isTrue);
    });

    test('a damaged stored value means the default, not a broken home', () {
      expect(HomeLayout.decode('{{{').isDefault, isTrue);
      expect(HomeLayout.decode('[]').isDefault, isTrue);
      expect(HomeLayout.decode('{"order": []}').isDefault, isTrue);
    });
  });

  group('hiding a section', () {
    test('takes it out of what is drawn but not out of the order', () {
      final layout = HomeLayout.initial.toggle(HomeSection.goals);

      expect(layout.visible, isNot(contains(HomeSection.goals)));
      expect(
        layout.order,
        contains(HomeSection.goals),
        reason:
            'a hidden section still has a position, or unhiding it would put '
            'it somewhere the user did not leave it',
      );
      expect(layout.isVisible(HomeSection.goals), isFalse);
    });

    test('toggling twice puts it back where it was', () {
      final layout = HomeLayout.initial
          .toggle(HomeSection.budgets)
          .toggle(HomeSection.budgets);

      expect(layout.visible, HomeSection.values);
      expect(layout.isDefault, isTrue);
    });
  });

  group('moving a section', () {
    test('upward lands where it was dropped', () {
      final layout = HomeLayout.initial.move(3, 0);

      expect(layout.order.first, HomeSection.values[3]);
      expect(layout.order[1], HomeSection.values[0]);
    });

    test('downward lands where the framework says it should', () {
      // onReorderItem hands over an index into the list with the dragged item
      // already removed, so this is a plain insert. Correcting for the lift a
      // second time would leave it one place short.
      final layout = HomeLayout.initial.move(0, 3);

      expect(layout.order[3], HomeSection.values[0]);
      expect(layout.order.first, HomeSection.values[1]);
    });

    test('nothing is lost or duplicated', () {
      final layout = HomeLayout.initial.move(5, 1).move(0, 7).move(2, 2);

      expect(layout.order.toSet(), HomeSection.values.toSet());
      expect(layout.order, hasLength(HomeSection.values.length));
    });

    test('an index that makes no sense changes nothing', () {
      expect(HomeLayout.initial.move(-1, 2).order, HomeSection.values);
      expect(HomeLayout.initial.move(99, 2).order, HomeSection.values);
    });
  });

  group('surviving a new version', () {
    test('a layout saved before a section existed still shows it', () {
      // Exactly what an older install has: an order naming only the sections
      // that existed when it was written.
      final old = HomeLayout(
        order: const [
          HomeSection.greeting,
          HomeSection.accounts,
          HomeSection.quickStats,
        ],
      ).encode();

      final restored = HomeLayout.decode(old);

      expect(
        restored.order.toSet(),
        HomeSection.values.toSet(),
        reason:
            'silently dropping a new section makes the feature invisible to '
            'every existing user, and looks like a bug in the feature',
      );
      expect(restored.visible, contains(HomeSection.goals));
    });

    test('a new section lands where it was designed to, not at the end', () {
      // quickLinks sits between quickStats and spendingChart by design.
      final old = HomeLayout(
        order: const [
          HomeSection.greeting,
          HomeSection.quickStats,
          HomeSection.spendingChart,
        ],
      ).encode();

      final restored = HomeLayout.decode(old);
      final at = restored.order.indexOf(HomeSection.quickLinks);

      expect(at, greaterThan(restored.order.indexOf(HomeSection.quickStats)));
      expect(at, lessThan(restored.order.indexOf(HomeSection.spendingChart)));
    });

    test('the order the user did choose is respected', () {
      final old = HomeLayout(
        order: const [HomeSection.goals, HomeSection.greeting],
      ).encode();

      final restored = HomeLayout.decode(old);

      expect(restored.order.first, HomeSection.goals);
      expect(restored.order[1], HomeSection.greeting);
    });

    test('a section this build no longer has is dropped, not fatal', () {
      final restored = HomeLayout.decode(
        '{"order": ["greeting", "something_removed", "accounts"], '
        '"hidden": ["also_gone"]}',
      );

      expect(restored.order.toSet(), HomeSection.values.toSet());
      expect(restored.order.first, HomeSection.greeting);
      expect(restored.hidden, isEmpty);
    });

    test('a duplicated id in the stored order is only counted once', () {
      final restored = HomeLayout.decode(
        '{"order": ["greeting", "greeting", "accounts"]}',
      );

      expect(
        restored.order.where((s) => s == HomeSection.greeting),
        hasLength(1),
      );
    });
  });

  group('round trip', () {
    test('an arranged layout comes back as it went in', () {
      final layout = HomeLayout.initial
          .move(6, 0)
          .toggle(HomeSection.quickLinks)
          .toggle(HomeSection.spendingChart);

      final restored = HomeLayout.decode(layout.encode());

      expect(restored.order, layout.order);
      expect(restored.hidden, layout.hidden);
      expect(restored.visible, layout.visible);
    });

    test('every id is stable and distinct', () {
      // These are written to preferences; renaming one silently resets a
      // user's layout, and a collision merges two sections into one.
      final ids = HomeSection.values.map((s) => s.storedAs).toList();

      expect(ids.toSet(), hasLength(ids.length));
      expect(ids.every((id) => id.isNotEmpty), isTrue);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/utils/icon_registry.dart';
import 'package:the_accountant/shared/widgets/registry_icon.dart';
import 'package:the_accountant/shared/widgets/sunrise/cards.dart';
import 'package:the_accountant/shared/widgets/sunrise/category_tile.dart';

import '../helpers/localized_app.dart';

/// A category can wear an emoji instead of an icon.
///
/// It is stored in the icon name itself, so it needs nothing new in the
/// database or on the server — and every place a category is drawn shows it.
void main() {
  test('an emoji is stored in the icon name and read back from it', () {
    final name = IconRegistry.nameForEmoji('🍕');
    expect(name, 'emoji:🍕');
    expect(IconRegistry.emojiOf(name), '🍕');
    expect(IconRegistry.emojiOf('restaurant'), isNull);
    expect(IconRegistry.emojiOf(null), isNull);
  });

  testWidgets('the shared tiles draw the emoji instead of the icon', (
    tester,
  ) async {
    await tester.pumpWidget(
      localizedApp(
        home: Column(
          children: [
            const IconTile(
              icon: Icons.category,
              emoji: '🍕',
              color: Colors.red,
            ),
            const RegistryIcon('emoji:🎁'),
            const RegistryIcon('restaurant'),
            CategoryTile(
              icon: Icons.category,
              emoji: '🕌',
              label: 'Mosque',
              selected: false,
              onTap: () {},
            ),
          ],
        ),
      ),
    );

    expect(find.text('🍕'), findsOneWidget);
    expect(find.text('🎁'), findsOneWidget);
    expect(find.text('🕌'), findsOneWidget);
    expect(find.byIcon(Icons.restaurant), findsOneWidget);
    expect(find.byIcon(Icons.category), findsNothing);
  });
}

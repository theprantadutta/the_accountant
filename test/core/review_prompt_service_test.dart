import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/core/services/review_prompt_service.dart';

/// The rating is asked for only once the app has been used for real, and not
/// again for months: asking early or often is how apps end up with one-star
/// ratings, and store policy limits it anyway.
void main() {
  final start = DateTime(2026, 11, 1);

  bool due(int n, {int days = 10, DateTime? lastAsked}) =>
      ReviewPromptService.isDue(
        transactions: n,
        firstSeen: start,
        lastAsked: lastAsked,
        now: start.add(Duration(days: days)),
      );

  test('not before ten entries', () {
    expect(due(9), isFalse);
    expect(due(10), isTrue);
  });

  test('not in the first five days, however many entries', () {
    expect(due(40, days: 4), isFalse);
    expect(due(40, days: 5), isTrue);
  });

  test('once asked, not again for four months', () {
    final asked = start.add(const Duration(days: 6));
    expect(due(30, days: 60, lastAsked: asked), isFalse);
    expect(due(30, days: 127, lastAsked: asked), isTrue);
  });
}

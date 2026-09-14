import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// No widget may touch `ref` from `dispose()`.
///
/// Riverpod's `_assertNotDisposed` throws a plain `StateError` — it is not
/// wrapped in `assert`, so it fires in release builds exactly as it does in
/// debug. A single `ref.read` in a `dispose()` body therefore does not warn,
/// it crashes the app, every time that widget is torn down.
///
/// `MainNavigationContainer` did it to detach a listener, which meant signing
/// out — the ordinary way to dispose the app's whole shell — took the app down
/// with it. Three crash reports from one user before it was spotted, because
/// the crash looks like a framework message rather than anything to do with
/// the feature that introduced it.
///
/// The remedy is always the same, and the framework's own error message says
/// it: keep what you need in a field of the State. So this checks the rule
/// rather than any one instance of breaking it.
void main() {
  test('no dispose() reaches for ref', () {
    final offenders = <String>[];

    for (final file in Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        // Generated code is not hand-written and not ours to police.
        .where((f) => !f.path.endsWith('.g.dart'))) {
      final lines = file.readAsLinesSync();

      var inDispose = false;
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];

        if (RegExp(r'void\s+dispose\s*\(\s*\)').hasMatch(line)) {
          inDispose = true;
          continue;
        }
        if (!inDispose) continue;
        if (line.contains('super.dispose()')) {
          inDispose = false;
          continue;
        }

        // `ref` alone on a line counts: the crash that prompted this was a
        // chained call written across four lines, which a search for `ref.`
        // would have walked straight past.
        final usesRef = RegExp(r'(^|[^\w.])ref\s*$').hasMatch(line) ||
            RegExp(r'(^|[^\w.])ref\s*\.').hasMatch(line);
        if (usesRef) {
          offenders.add('${file.path}:${i + 1}: ${line.trim()}');
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'These read a provider from dispose(), which throws a StateError at '
          'runtime in release as well as debug.\n'
          'Hold what you need in a field of the State instead, assigned where '
          'the subscription is set up.\n\n'
          '${offenders.join('\n')}',
    );
  });
}

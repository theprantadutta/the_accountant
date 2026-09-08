import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/backup/providers/backup_provider.dart';
import 'package:the_accountant/features/backup/screens/backup_screen.dart';
import 'package:the_accountant/features/backup/services/drive_client.dart';

import '../helpers/localized_app.dart';
import '../helpers/test_database.dart';

/// What the Backup & Restore screen tells the user.
///
/// Connecting Drive changed nothing visible except the last row turning into
/// "Disconnect Google Drive" — which asks somebody to work out that it must
/// have worked from the absence of the button they just pressed. And the list
/// of backups was read once and never again, so a backup taken a moment ago
/// only appeared after the app was restarted, which reads exactly like a backup
/// that was not taken.
void main() {
  late AppDatabase db;
  late SharedPreferences prefs;

  setUp(() async {
    db = openTestDatabase();
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  tearDown(() => db.close());

  DriveBackupFile fileNamed(String name) => DriveBackupFile(
    id: name,
    name: name,
    createdAt: DateTime(2026, 5, 1),
    schemaVersion: 25,
  );

  /// Pumps the screen with Drive answering however the test wants.
  ///
  /// [listings] is consumed one entry per read, so a test can say what the
  /// second look at Drive returns as well as the first.
  Future<void> pump(
    WidgetTester tester, {
    required bool authorized,
    List<List<DriveBackupFile>> listings = const [[]],
  }) async {
    var reads = 0;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          sharedPreferencesProvider.overrideWithValue(prefs),
          driveAuthorizedProvider.overrideWith((ref) async => authorized),
          driveBackupsProvider.overrideWith((ref) async {
            if (!authorized) return const <DriveBackupFile>[];
            final index = reads < listings.length ? reads : listings.length - 1;
            reads++;
            return listings[index];
          }),
        ],
        child: localizedApp(home: const BackupScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// The Drive listing sits at the bottom of a lazily built list, so it is not
  /// in the tree at all until it is scrolled to.
  Future<void> scrollToDriveList(WidgetTester tester) async {
    await tester.scrollUntilVisible(
      find.text('BACKUPS IN DRIVE'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  group('after connecting', () {
    testWidgets('it says so, rather than leaving it to be inferred', (
      tester,
    ) async {
      await pump(tester, authorized: true);

      expect(find.text('Google Drive connected'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('drive-connected')),
        findsOneWidget,
        reason: 'the only sign it had worked was the connect button being '
            'replaced by a disconnect one',
      );
    });

    testWidgets('it names the folder the backups go to', (tester) async {
      await pump(tester, authorized: true);

      expect(
        find.textContaining(DriveBackupClient.folderName),
        findsWidgets,
        reason: 'somebody who wants to check their backups needs to know '
            'where in their Drive to look',
      );
    });

    testWidgets('none of that shows before connecting', (tester) async {
      await pump(tester, authorized: false);

      expect(find.byKey(const ValueKey('drive-connected')), findsNothing);
      expect(find.text('Google Drive connected'), findsNothing);
    });
  });

  group('the refresh button', () {
    testWidgets('is offered once Drive is connected', (tester) async {
      await pump(tester, authorized: true);
      await scrollToDriveList(tester);

      expect(find.byKey(const ValueKey('refresh-drive-backups')), findsOneWidget);
    });

    testWidgets('is not offered when there is nothing to refresh', (
      tester,
    ) async {
      await pump(tester, authorized: false);
      await scrollToDriveList(tester);

      expect(find.byKey(const ValueKey('refresh-drive-backups')), findsNothing);
    });

    testWidgets('picks up a backup that arrived since the screen opened', (
      tester,
    ) async {
      await pump(
        tester,
        authorized: true,
        listings: [
          const [],
          [fileNamed('accountant-backup-2026-05-01.json')],
        ],
      );

      await scrollToDriveList(tester);

      // A backup shows as a row with its own actions menu; an empty listing has
      // none. Asserted that way rather than on a formatted date, which follows
      // the user's own date setting.
      expect(find.byType(PopupMenuButton<String>), findsNothing);

      await tester.tap(find.byKey(const ValueKey('refresh-drive-backups')));
      await tester.pumpAndSettle();

      expect(
        find.byType(PopupMenuButton<String>),
        findsOneWidget,
        reason: 'Drive does not always list a file the instant it is written, '
            'and a backup can arrive from another device entirely — waiting '
            'for a restart is not an answer to either',
      );
    });
  });
}

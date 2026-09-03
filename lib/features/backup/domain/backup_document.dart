import 'dart:convert';

/// A backup is a snapshot of every row this device holds, plus enough about
/// where it came from to refuse to restore it somewhere it does not belong.
///
/// The rows are stored exactly as SQLite holds them — column name to raw value
/// — rather than as mapped model objects. That is deliberate. A backup taken
/// today may be restored by a build several schema versions later, and the
/// generated mappers only ever describe the schema of the build they were
/// generated from. Raw columns survive that gap: a column the reader no longer
/// knows about is dropped, and one it has gained takes its default.
class BackupDocument {
  /// The shape of this envelope, which is not the database schema version.
  ///
  /// Bumped only when the envelope itself changes, so a reader can tell
  /// "written by a newer app" apart from "written against a newer schema".
  static const int currentFormatVersion = 1;

  /// The oldest database schema whose rows this build can still place.
  ///
  /// Backups did not exist before schema 21, so nothing older can exist in the
  /// wild, and pretending otherwise would mean carrying data migrations that
  /// have never had a file to run against.
  static const int minimumSchemaVersion = 21;

  const BackupDocument({required this.metadata, required this.tables});

  final BackupMetadata metadata;

  /// Table name to its rows, each row a column-name to raw-value map.
  final Map<String, List<Map<String, Object?>>> tables;

  int get rowCount => tables.values.fold(0, (sum, rows) => sum + rows.length);

  Map<String, Object?> toJson() => {
    'format_version': currentFormatVersion,
    'metadata': metadata.toJson(),
    'tables': tables,
  };

  String encode() => const JsonEncoder.withIndent('  ').convert(toJson());

  /// Read a backup, refusing anything this build cannot honestly place.
  ///
  /// Every rejection here is a refusal to half-restore. Restoring is
  /// destructive — it replaces what is on the device — so a file that is only
  /// partly understood must not be attempted at all.
  factory BackupDocument.decode(String source) {
    final Object? raw;
    try {
      raw = jsonDecode(source);
    } on FormatException {
      throw const BackupFormatException(
        'This file is not a backup — it could not be read as JSON.',
      );
    }

    if (raw is! Map<String, Object?>) {
      throw const BackupFormatException(
        'This file is not a backup from The Accountant.',
      );
    }

    final formatVersion = raw['format_version'];
    if (formatVersion is! int) {
      throw const BackupFormatException(
        'This file is not a backup from The Accountant.',
      );
    }
    if (formatVersion > currentFormatVersion) {
      throw BackupFormatException(
        'This backup was written by a newer version of the app. Update The '
        'Accountant and try again.',
      );
    }

    final metadata = BackupMetadata.fromJson(raw['metadata']);

    if (metadata.schemaVersion < minimumSchemaVersion) {
      throw BackupFormatException(
        'This backup is from an older version of the app than this one can '
        'read (database ${metadata.schemaVersion}, oldest supported '
        '$minimumSchemaVersion).',
      );
    }

    final rawTables = raw['tables'];
    if (rawTables is! Map<String, Object?>) {
      throw const BackupFormatException('This backup has no data in it.');
    }

    final tables = <String, List<Map<String, Object?>>>{};
    for (final entry in rawTables.entries) {
      final rows = entry.value;
      if (rows is! List) {
        throw BackupFormatException(
          'The "${entry.key}" section of this backup is damaged.',
        );
      }
      tables[entry.key] = [
        for (final row in rows)
          if (row is Map<String, Object?>)
            row
          else
            throw BackupFormatException(
              'The "${entry.key}" section of this backup is damaged.',
            ),
      ];
    }

    return BackupDocument(metadata: metadata, tables: tables);
  }
}

/// Where a backup came from, and what it was taken against.
class BackupMetadata {
  const BackupMetadata({
    required this.schemaVersion,
    required this.createdAt,
    this.appVersion = '',
    this.device = '',
    this.ownerUserId,
    this.ownerEmail,
  });

  /// The database schema the rows were read from.
  ///
  /// Named in the filename too, so a restore can be refused before the file is
  /// even downloaded.
  final int schemaVersion;

  final DateTime createdAt;
  final String appVersion;

  /// Which device wrote it, so a list of backups is possible to tell apart.
  final String device;

  /// The signed-in account at the time, if any. Used to warn before restoring
  /// one person's records onto another person's device.
  final String? ownerUserId;
  final String? ownerEmail;

  Map<String, Object?> toJson() => {
    'schema_version': schemaVersion,
    'created_at': createdAt.toUtc().toIso8601String(),
    'app_version': appVersion,
    'device': device,
    if (ownerUserId != null) 'owner_user_id': ownerUserId,
    if (ownerEmail != null) 'owner_email': ownerEmail,
  };

  factory BackupMetadata.fromJson(Object? raw) {
    if (raw is! Map<String, Object?>) {
      throw const BackupFormatException(
        'This backup is missing the header that says what it is.',
      );
    }

    final schemaVersion = raw['schema_version'];
    if (schemaVersion is! int) {
      throw const BackupFormatException(
        'This backup does not say which database version it was taken from, '
        'so it cannot be restored safely.',
      );
    }

    final createdAt = DateTime.tryParse('${raw['created_at']}');
    if (createdAt == null) {
      throw const BackupFormatException(
        'This backup does not say when it was taken.',
      );
    }

    return BackupMetadata(
      schemaVersion: schemaVersion,
      createdAt: createdAt.toLocal(),
      appVersion: '${raw['app_version'] ?? ''}',
      device: '${raw['device'] ?? ''}',
      ownerUserId: raw['owner_user_id'] as String?,
      ownerEmail: raw['owner_email'] as String?,
    );
  }
}

/// A backup file that cannot be trusted, with a reason fit to show the user.
class BackupFormatException implements Exception {
  const BackupFormatException(this.message);

  final String message;

  @override
  String toString() => message;
}

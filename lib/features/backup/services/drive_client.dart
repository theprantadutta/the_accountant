import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Whatever can prove to Google that a request is being made by this user.
///
/// Kept behind an interface so the client below can be exercised without a
/// signed-in Google account, and so the sign-in plugin is not a dependency of
/// the transfer logic.
abstract class DriveAuthorization {
  /// Headers carrying an access token for the app-data scope, or null when the
  /// user has not granted it and [interactive] does not allow asking.
  ///
  /// An automatic backup passes false: waking up and throwing a Google consent
  /// screen at somebody who just opened the app is not acceptable, so a lapsed
  /// grant simply means the automatic run is skipped until they next press the
  /// button themselves.
  Future<Map<String, String>?> headers({bool interactive = false});
}

/// One backup file as Drive knows it.
class DriveBackupFile {
  const DriveBackupFile({
    required this.id,
    required this.name,
    required this.createdAt,
    this.sizeBytes,
    this.schemaVersion,
    this.device,
  });

  final String id;
  final String name;
  final DateTime createdAt;
  final int? sizeBytes;

  /// The database version the file was written against, read from the
  /// properties Drive stores alongside it.
  ///
  /// Knowing this before downloading is the point: a file from a newer build
  /// can be refused without spending the user's data on it.
  final int? schemaVersion;

  final String? device;

  factory DriveBackupFile.fromJson(Map<String, Object?> json) {
    final properties = json['appProperties'];
    final props = properties is Map ? properties : const {};
    return DriveBackupFile(
      id: '${json['id']}',
      name: '${json['name']}',
      createdAt:
          DateTime.tryParse('${json['createdTime']}')?.toLocal() ??
          DateTime.now(),
      sizeBytes: int.tryParse('${json['size']}'),
      schemaVersion: int.tryParse('${props['schemaVersion']}'),
      device: props['device'] as String?,
    );
  }
}

/// Something Drive would not do, phrased for a person rather than a log.
class DriveException implements Exception {
  const DriveException(this.message, {this.needsAuthorization = false});

  final String message;

  /// Whether the fix is for the user to grant access again, rather than to
  /// retry.
  final bool needsAuthorization;

  @override
  String toString() => message;
}

/// The slice of the Drive API this app actually uses.
///
/// Written directly against the REST endpoints rather than through the
/// generated `googleapis` package: four calls are needed, all of them simple,
/// and the generated client would add several megabytes of code describing the
/// rest of Drive to no purpose. It also means the transfer logic can be tested
/// against a stub HTTP client.
class DriveBackupClient {
  DriveBackupClient({
    required DriveAuthorization authorization,
    http.Client? httpClient,
    // A named parameter cannot be a private initializing formal, so the
    // lint's suggestion is not expressible here.
    // ignore: prefer_initializing_formals
  }) : _authorization = authorization,
       _http = httpClient ?? http.Client();

  final DriveAuthorization _authorization;
  final http.Client _http;

  /// Per-file access: this app can only ever see files it created itself.
  ///
  /// The user's existing documents are invisible to it — `files.list` under
  /// this scope returns nothing but our own backups, which is why the listing
  /// below can query broadly without any risk of reading somebody's private
  /// files.
  ///
  /// Chosen over `drive.appdata`, which hides the backups in a folder nobody
  /// can see. Two reasons. A backup the user cannot find, copy or delete
  /// without the app is a worse backup — the point of the feature is that
  /// their records outlive this app. And `drive.appdata` is classified
  /// sensitive, so shipping it would mean a Google verification review, while
  /// this scope is non-sensitive and needs none.
  static const String scope = 'https://www.googleapis.com/auth/drive.file';

  /// The folder backups are filed under, so they are somewhere obvious rather
  /// than loose in the root of the user's Drive.
  static const String folderName = 'The Accountant Backups';

  static const String _folderMimeType = 'application/vnd.google-apps.folder';
  static const String _base = 'https://www.googleapis.com/drive/v3';
  static const String _uploadBase =
      'https://www.googleapis.com/upload/drive/v3';
  static const String _fields = 'id,name,size,createdTime,appProperties';

  Future<Map<String, String>> _headers({required bool interactive}) async {
    final Map<String, String>? headers;
    try {
      headers = await _authorization.headers(interactive: interactive);
    } catch (e) {
      throw DriveException(
        'Google Drive could not be reached: $e',
        needsAuthorization: true,
      );
    }
    if (headers == null) {
      throw const DriveException(
        'The Accountant is not allowed to use Google Drive yet.',
        needsAuthorization: true,
      );
    }
    return headers;
  }

  /// The id of our folder, made on first use.
  ///
  /// Cached for the life of the client so a backup does not cost two extra
  /// round trips. Under this scope the search only ever sees folders this app
  /// created, so it cannot latch onto a folder of the user's that happens to
  /// share the name.
  String? _folderId;

  Future<String> _folder({required bool interactive}) async {
    final cached = _folderId;
    if (cached != null) return cached;

    final query = Uri.encodeQueryComponent(
      "mimeType = '$_folderMimeType' and name = '$folderName' "
      'and trashed = false',
    );
    final found = await _send(
      (headers) => _http.get(
        Uri.parse('$_base/files?q=$query&fields=files(id)&pageSize=1'),
        headers: headers,
      ),
      interactive: interactive,
    );

    final body = jsonDecode(found.body);
    final files = body is Map ? body['files'] : null;
    if (files is List && files.isNotEmpty && files.first is Map) {
      return _folderId = '${(files.first as Map)['id']}';
    }

    final created = await _send(
      (headers) => _http.post(
        Uri.parse('$_base/files?fields=id'),
        headers: {...headers, 'Content-Type': 'application/json'},
        body: jsonEncode({'name': folderName, 'mimeType': _folderMimeType}),
      ),
      interactive: interactive,
    );

    final decoded = jsonDecode(created.body);
    if (decoded is! Map || decoded['id'] == null) {
      throw const DriveException(
        'Google Drive would not make a folder to keep backups in.',
      );
    }
    return _folderId = '${decoded['id']}';
  }

  /// Every backup this app has stored, newest first.
  Future<List<DriveBackupFile>> list({bool interactive = false}) async {
    // Deliberately not restricted to the folder. This scope only exposes files
    // this app created, so the query is already narrow — and looking wider means
    // a backup the user has moved or filed somewhere of their own is still
    // found rather than silently vanishing from the list.
    final query = Uri.encodeQueryComponent(
      "mimeType = 'application/json' and trashed = false",
    );
    final response = await _send(
      (headers) => _http.get(
        Uri.parse(
          '$_base/files'
          '?q=$query'
          '&orderBy=createdTime desc'
          '&pageSize=100'
          '&fields=files($_fields)',
        ),
        headers: headers,
      ),
      interactive: interactive,
    );

    final body = jsonDecode(response.body);
    final files = body is Map ? body['files'] : null;
    if (files is! List) return const [];
    return [
      for (final file in files)
        if (file is Map<String, Object?>) DriveBackupFile.fromJson(file),
    ];
  }

  /// Store [content] under [name], and return the file that was created.
  Future<DriveBackupFile> upload({
    required String name,
    required String content,
    Map<String, String> properties = const {},
    bool interactive = true,
  }) async {
    const boundary = 'the-accountant-backup-boundary';
    final metadata = jsonEncode({
      'name': name,
      'parents': [await _folder(interactive: interactive)],
      'mimeType': 'application/json',
      if (properties.isNotEmpty) 'appProperties': properties,
    });

    final body =
        '--$boundary\r\n'
        'Content-Type: application/json; charset=UTF-8\r\n\r\n'
        '$metadata\r\n'
        '--$boundary\r\n'
        'Content-Type: application/json; charset=UTF-8\r\n\r\n'
        '$content\r\n'
        '--$boundary--';

    final response = await _send(
      (headers) => _http.post(
        Uri.parse('$_uploadBase/files?uploadType=multipart&fields=$_fields'),
        headers: {
          ...headers,
          'Content-Type': 'multipart/related; boundary=$boundary',
        },
        body: utf8.encode(body),
      ),
      interactive: interactive,
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, Object?>) {
      throw const DriveException(
        'Google Drive accepted the backup but did not say where it put it.',
      );
    }
    return DriveBackupFile.fromJson(decoded);
  }

  /// Read a backup back out of Drive.
  Future<String> download(String fileId, {bool interactive = true}) async {
    final response = await _send(
      (headers) => _http.get(
        Uri.parse('$_base/files/$fileId?alt=media'),
        headers: headers,
      ),
      interactive: interactive,
    );
    // Drive serves the bytes as stored; decoding explicitly keeps a backup with
    // non-ASCII names, notes or currencies from arriving as mojibake.
    return utf8.decode(response.bodyBytes);
  }

  /// Remove a backup for good.
  Future<void> delete(String fileId, {bool interactive = true}) async {
    await _send(
      (headers) =>
          _http.delete(Uri.parse('$_base/files/$fileId'), headers: headers),
      interactive: interactive,
    );
  }

  /// Run a request with credentials attached, and turn a refusal into
  /// something worth showing.
  Future<http.Response> _send(
    Future<http.Response> Function(Map<String, String> headers) request, {
    required bool interactive,
  }) async {
    final headers = await _headers(interactive: interactive);

    final http.Response response;
    try {
      response = await request(headers);
    } on SocketException {
      throw const DriveException(
        'No connection to Google Drive. Try again once you are online.',
      );
    } on http.ClientException catch (e) {
      throw DriveException('Google Drive could not be reached: ${e.message}');
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw const DriveException(
        'Google Drive turned the request down. Grant access again and retry.',
        needsAuthorization: true,
      );
    }
    if (response.statusCode == 404) {
      throw const DriveException('That backup is no longer in Google Drive.');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw DriveException(
        'Google Drive answered ${response.statusCode}. '
        '${_reason(response.body)}',
      );
    }
    return response;
  }

  static String _reason(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['error'] is Map) {
        final message = (decoded['error'] as Map)['message'];
        if (message is String && message.isNotEmpty) return message;
      }
    } catch (_) {
      // The body was not the error envelope; the status code has to speak for
      // itself.
    }
    return 'Try again in a moment.';
  }
}

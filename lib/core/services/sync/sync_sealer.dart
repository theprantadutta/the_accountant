import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/features/backup/services/account_data_key.dart';

/// Seals the financial fields of every synced row before it leaves the phone,
/// and opens them again when rows come back.
///
/// The server keeps what it needs to sync — ids, dates, flags, links, currency
/// — and gets placeholders where amounts, titles, notes and names were, plus
/// one `EncryptedData` blob: AES-256-GCM under the account data key, bound to
/// its table and row id so a blob cannot be moved onto another row. A row with
/// no blob (written by an older app) is used exactly as it arrives.
class SyncSealer {
  SyncSealer({Future<List<int>> Function()? key})
    : _key = key ?? const AccountDataKey().read;

  final Future<List<int>> Function() _key;
  static final AesGcm _cipher = AesGcm.with256bits();

  /// The push keys holding financial details, per table. Everything else is
  /// what sync itself runs on and stays readable.
  static const Map<String, Set<String>> sealedFields = {
    'transactions': {
      'Amount',
      'Title',
      'Notes',
      'PaidAmount',
      'Units',
      'FxRate',
      'CounterAmount',
      'ReceiptImageUrl',
    },
    'wallets': {'Name', 'Balance', 'OpeningBalance', 'CreditLimit'},
    'categories': {'Name'},
    'budgets': {'Name', 'Amount'},
    'associated_titles': {'Title'},
    'category_budget_limits': {'Amount'},
    'objectives': {'Name', 'TargetAmount'},
    'investments': {'Name', 'Symbol', 'Price', 'Notes'},
    'plans': {
      'Name',
      'Principal',
      'InstallmentAmount',
      'InterestRate',
      'MaturityAmount',
      'Provider',
      'Reference',
      'TaxRate',
      'Notes',
    },
    'payment_methods': {'Name', 'LastFourDigits', 'Institution'},
    'recurring_configs': {'Amount'},
  };

  static const String _payloadKey = 'EncryptedData';

  /// Seal every create and update in [changes]; deletes carry no data.
  Future<List<SyncChange>> sealAll(List<SyncChange> changes) async {
    if (!changes.any(_carriesData)) return changes;
    final key = SecretKey(await _key());
    return [
      for (final change in changes)
        _carriesData(change) ? await _seal(change, key) : change,
    ];
  }

  /// A pulled change with its sealed fields put back; unchanged when it
  /// carries none.
  Future<SyncChange> open(String table, SyncChange change) async {
    final data = change.data;
    if (data == null) return change;
    final payloadKey = data.keys.firstWhere(
      (k) => k.toLowerCase() == _payloadKey.toLowerCase(),
      orElse: () => '',
    );
    final sealed = payloadKey.isEmpty ? null : data[payloadKey];
    final opened = Map<String, dynamic>.of(data)..remove(payloadKey);
    if (sealed is! String || sealed.isEmpty) {
      return payloadKey.isEmpty ? change : _withData(change, opened);
    }

    final bytes = base64Decode(sealed);
    final box = SecretBox.fromConcatenation(
      bytes,
      nonceLength: _cipher.nonceLength,
      macLength: _cipher.macAlgorithm.macLength,
    );
    final clear = await _cipher.decrypt(
      box,
      secretKey: SecretKey(await _key()),
      aad: _aad(table, change.entityId),
    );
    final fields = jsonDecode(utf8.decode(clear)) as Map<String, dynamic>;
    for (final entry in fields.entries) {
      // The placeholder arrives under the server's casing; the real value
      // replaces it whatever the casing.
      opened.removeWhere((k, _) => k.toLowerCase() == entry.key.toLowerCase());
      opened[entry.key] = entry.value;
    }
    return _withData(change, opened);
  }

  static bool _carriesData(SyncChange c) =>
      c.data != null && c.operation != 'delete';

  Future<SyncChange> _seal(SyncChange change, SecretKey key) async {
    final fields = sealedFields[change.tableName];
    final data = change.data!;
    if (fields == null) return change;

    final secret = <String, dynamic>{};
    final visible = Map<String, dynamic>.of(data);
    for (final field in fields) {
      if (!data.containsKey(field)) continue;
      final value = data[field];
      secret[field] = value;
      visible[field] = _placeholder(value);
    }
    final box = await _cipher.encrypt(
      utf8.encode(jsonEncode(secret)),
      secretKey: key,
      aad: _aad(change.tableName, change.entityId),
    );
    visible[_payloadKey] = base64Encode(box.concatenation());
    return _withData(change, visible);
  }

  /// What the server sees instead of [value]: the same kind of thing, holding
  /// nothing. A missing value stays missing.
  static Object? _placeholder(Object? value) => switch (value) {
    null => null,
    num() => 0,
    String() => '',
    _ => null,
  };

  static List<int> _aad(String table, String id) =>
      utf8.encode('the-accountant/sync/v1|$table|$id');

  static SyncChange _withData(SyncChange c, Map<String, dynamic> data) =>
      SyncChange(
        tableName: c.tableName,
        entityId: c.entityId,
        operation: c.operation,
        data: data,
        sourceUpdatedAt: c.sourceUpdatedAt,
        sourceRevision: c.sourceRevision,
        resolution: c.resolution,
      );
}

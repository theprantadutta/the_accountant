import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:the_accountant/core/services/api_service.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';

/// Everything [SyncService] needs from the outside world.
///
/// Extracted so the sync protocol — dependency ordering, cursor advancement,
/// chunking, conflict handling, ownership checks — can be driven end to end in
/// tests against an in-memory server. [ApiService] is a singleton with a private
/// constructor and static `dotenv` configuration, so it cannot be substituted
/// directly; depending on this interface instead is what makes the two-device
/// integration tests possible at all.
abstract class SyncTransport {
  /// Whether the device currently has connectivity.
  Future<bool> isOnline();

  /// Whether an access token is available.
  Future<bool> hasToken();

  /// The raw access token, used to identify which account this sync is for.
  Future<String?> getToken();

  /// Upload one batch of changes.
  Future<SyncPushResponse> push(List<SyncChange> changes);

  /// Download every change since [since] (null = everything).
  Future<SyncPullResponse> pull(DateTime? since);
}

/// The production transport: the real HTTP API.
class ApiSyncTransport implements SyncTransport {
  final ApiService _apiService;

  ApiSyncTransport(this._apiService);

  /// Whether any network interface is up, from the platform's own record.
  ///
  /// This used to resolve google.com before every sync: a DNS round trip, on a
  /// phone often a slow one, spent proving something the sync request is about
  /// to prove anyway. A device that is genuinely offline is caught here at no
  /// cost, and one that only looks connected fails its first request quickly,
  /// which the sync reports as offline rather than as a fault.
  @override
  Future<bool> isOnline() async {
    try {
      final results = await Connectivity().checkConnectivity();
      return !results.contains(ConnectivityResult.none);
    } catch (_) {
      // No answer from the platform is not evidence of being offline; let the
      // request itself decide.
      return true;
    }
  }

  @override
  Future<bool> hasToken() => _apiService.hasToken();

  @override
  Future<String?> getToken() => _apiService.getToken();

  @override
  Future<SyncPushResponse> push(List<SyncChange> changes) async {
    final response = await _apiService.post(
      '/sync/push',
      data: SyncPushRequest(changes: changes).toJson(),
    );
    return SyncPushResponse.fromJson(response.data);
  }

  @override
  Future<SyncPullResponse> pull(DateTime? since) async {
    final queryParams = <String, dynamic>{};
    if (since != null) {
      queryParams['since'] = since.toUtc().toIso8601String();
    }
    final response = await _apiService.get(
      '/sync/pull',
      queryParameters: queryParams,
    );
    return SyncPullResponse.fromJson(response.data);
  }
}

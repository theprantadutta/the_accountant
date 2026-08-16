import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:the_accountant/core/services/secure_token_storage.dart';

/// Exception thrown when account linking is required
class AccountLinkingRequiredException implements Exception {
  final String message;
  final bool requiresLinking;

  AccountLinkingRequiredException(this.message, {this.requiresLinking = true});

  @override
  String toString() => message;
}

/// A failed API call, carrying the HTTP status alongside the message.
///
/// Callers used to receive only the message string, which made a rejected
/// password indistinguishable from a 500 or a 429 — every one of them fell
/// through to the same "an error occurred" text, so a total backend outage
/// looked exactly like a typo. [statusCode] is null when the request never got
/// a response at all (timeout, no connectivity, DNS).
///
/// [toString] deliberately returns the bare message so existing callers that
/// only read `e.toString()` keep behaving as before.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  /// The request never reached the server, or no response came back.
  bool get isNetworkError => statusCode == null;

  /// The server was reached and failed. Retrying later may well work.
  bool get isServerError => statusCode != null && statusCode! >= 500;

  /// Throttled by the auth rate limiter.
  bool get isRateLimited => statusCode == 429;

  @override
  String toString() => message;
}

/// Callback for handling unauthorized (401) responses globally
typedef UnauthorizedCallback = void Function();

/// API Service for communicating with The Accountant backend
class ApiService {
  // Backend API configuration
  // Uses kReleaseMode to automatically switch between dev and prod
  static final String _devUrl =
      dotenv.env['API_BASE_URL_DEV'] ?? 'http://localhost:8002';
  static final String _prodUrl =
      dotenv.env['API_BASE_URL_PROD'] ?? 'https://theaccountant.pranta.dev';
  static final String baseUrl = kReleaseMode ? _prodUrl : _devUrl;
  static const String apiV1 = '/api/v1';

  final Dio _dio = Dio();
  // Use platform-specific secure storage options
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    wOptions: WindowsOptions(),
  );
  final Logger _logger = Logger();

  /// Callback to be invoked when a 401 unauthorized response is received
  UnauthorizedCallback? onUnauthorized;

  /// The in-flight token refresh, if one is running. Concurrent callers await
  /// this instead of starting their own: two requests rotating the same refresh
  /// token makes the server treat the second one as a replay attack and kill the
  /// whole session, which is a self-inflicted logout.
  Completer<String?>? _refreshCompleter;

  /// Marks a request that has already been retried once after a refresh, so a
  /// persistent 401 can't bounce between retry and refresh forever.
  static const String _retriedExtraKey = 'auth_retry_attempted';

  /// Endpoints that must never trigger a token refresh or a refresh-driven
  /// logout: they either issue tokens or authenticate by other means.
  static bool _isAuthEndpoint(String path) =>
      path.contains('/auth/refresh') ||
      path.contains('/auth/login') ||
      path.contains('/auth/register') ||
      path.contains('/auth/firebase') ||
      path.contains('/auth/google') ||
      path.contains('/auth/link-google') ||
      path.contains('/auth/forgot-password') ||
      path.contains('/auth/reset-password');

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  ApiService._internal() {
    _dio.options = BaseOptions(
      baseUrl: baseUrl + apiV1,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Request interceptor to add JWT token and handle token refresh.
    // Deliberately not a QueuedInterceptorsWrapper: the 401 path retries through
    // this same Dio instance, which would re-enter the queue while the error
    // handler still holds it and deadlock. Concurrency is handled instead by
    // _refreshAccessToken, which is single-flight.
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Check if the token is expiring soon and refresh it. Safe to call
          // concurrently — _refreshAccessToken collapses callers onto one request.
          if (!_isAuthEndpoint(options.path) &&
              await SecureTokenStorage.isTokenExpiringSoon()) {
            _logger.i('Token expiring soon, attempting refresh...');
            await _refreshAccessToken();
          }

          final token = await getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            _logger.d('Token attached: ${token.substring(0, 20)}...');
          } else {
            _logger.w('No token available for request!');
          }
          _logger.d('REQUEST[${options.method}] => ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d('RESPONSE[${response.statusCode}] => ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) async {
          _logger.e('ERROR[${error.response?.statusCode}] => ${error.message}');
          if (error.response != null) {
            _logger.e('ERROR Response Data: ${error.response?.data}');
            _logger.e('ERROR Response Headers: ${error.response?.headers}');
          }

          // Handle 401 Unauthorized - but NOT for password verification errors
          final responseData = error.response?.data;
          final errorDetail = responseData is Map
              ? responseData['detail']
              : null;

          if (error.response?.statusCode == 401) {
            // Don't logout for password verification failures (e.g., during account linking)
            final isPasswordError = errorDetail == 'Incorrect password';
            final alreadyRetried =
                error.requestOptions.extra[_retriedExtraKey] == true;

            if (isPasswordError) {
              _logger.w(
                'Received 401 for incorrect password - NOT triggering logout',
              );
            } else if (!_isAuthEndpoint(error.requestOptions.path) &&
                !alreadyRetried) {
              _logger.w('Received 401 Unauthorized - attempting token refresh');

              // Collapses onto any refresh already running instead of starting a
              // second one. Previously this branch logged the user out outright
              // whenever a refresh was in flight, so any two concurrent requests
              // hitting an expired token ended the session.
              final newAccessToken = await _refreshAccessToken();

              if (newAccessToken != null) {
                final opts = error.requestOptions;
                opts.headers['Authorization'] = 'Bearer $newAccessToken';
                opts.extra[_retriedExtraKey] = true;

                try {
                  _logger.i('Token refreshed - retrying original request');
                  return handler.resolve(await _dio.fetch(opts));
                } catch (retryError) {
                  _logger.e('Retry after token refresh failed: $retryError');
                }
              }

              // No logout here on purpose. _refreshAccessToken has already torn
              // the session down if the refresh token itself was rejected; a null
              // after a transient failure just means "try again later".
            }
          }

          // Handle "User not found" error - user was deleted from backend
          if (errorDetail == 'User not found') {
            _logger.w('User not found in backend - triggering logout');
            await deleteToken();
            onUnauthorized?.call();
          }

          return handler.next(error);
        },
      ),
    );
  }

  // ============================================================================
  // Token Management
  // ============================================================================

  /// Refresh the access token, collapsing concurrent callers onto a single
  /// request. Returns the new access token, or null if it could not be
  /// refreshed — null does *not* imply the session ended, see [_performRefresh].
  Future<String?> _refreshAccessToken() {
    final inFlight = _refreshCompleter;
    if (inFlight != null) {
      _logger.d('Refresh already in flight - awaiting it');
      return inFlight.future;
    }

    final completer = Completer<String?>();
    _refreshCompleter = completer;

    // Clear the slot before completing so anyone woken by this future starts a
    // fresh attempt rather than latching onto a finished one.
    unawaited(
      _performRefresh().then(
        (token) {
          _refreshCompleter = null;
          completer.complete(token);
        },
        onError: (Object e, StackTrace s) {
          _logger.e('Unexpected error during token refresh: $e');
          _refreshCompleter = null;
          completer.complete(null);
        },
      ),
    );

    return completer.future;
  }

  Future<String?> _performRefresh() async {
    final refreshToken = await SecureTokenStorage.getRefreshToken();
    if (refreshToken == null) {
      _logger.w('No refresh token available - session cannot be restored');
      await _handleSessionRejected();
      return null;
    }

    _logger.i('Refreshing access token...');

    // Separate Dio instance so the refresh call doesn't re-enter the interceptor
    final refreshDio = Dio(
      BaseOptions(
        baseUrl: baseUrl + apiV1,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    try {
      final response = await refreshDio.post(
        '/auth/refresh',
        data: {'token': refreshToken},
      );

      final newAccessToken = response.data['access_token'] as String;
      await saveToken(newAccessToken);
      await SecureTokenStorage.storeRefreshToken(
        response.data['refresh_token'] as String,
      );
      await SecureTokenStorage.storeTokenExpiry(
        response.data['expires_in'] as int,
      );

      _logger.i('Token refresh successful');
      return newAccessToken;
    } on DioException catch (e) {
      final status = e.response?.statusCode;

      if (status == 401 || status == 403) {
        // Another flow may have rotated the token while this request was in
        // flight. If what's stored now differs from what we sent, that rotation
        // succeeded and the session is fine — use it instead of tearing down.
        final current = await SecureTokenStorage.getRefreshToken();
        if (current != null && current != refreshToken) {
          _logger.i(
            'Refresh rejected but token has since rotated - using current token',
          );
          return await getToken();
        }

        _logger.w('Refresh token rejected by server ($status) - session over');
        await _handleSessionRejected();
        return null;
      }

      // Offline, timeout, 5xx: transient. Keep the session — losing it because
      // one request died in a tunnel is worse than retrying on the next call.
      _logger.w(
        'Token refresh failed transiently (${e.type}) - keeping session: ${e.message}',
      );
      return null;
    }
  }

  /// The server rejected our refresh token outright: clear everything and
  /// hand off to the auth layer to show the sign-in screen.
  Future<void> _handleSessionRejected() async {
    _logger.w('Session rejected - clearing tokens and triggering logout');
    await deleteToken();
    await SecureTokenStorage.clearAllTokens();
    onUnauthorized?.call();
  }

  // Access-token storage is delegated to SecureTokenStorage so there is exactly
  // one place that knows the key.
  Future<void> saveToken(String token) async {
    _logger.i('saveToken called, token length: ${token.length}');
    await SecureTokenStorage.storeAccessToken(token);
    _logger.i('saveToken completed');
  }

  Future<String?> getToken() async {
    final token = await SecureTokenStorage.getAccessToken();
    _logger.d(
      'getToken called, result: ${token != null ? "exists (${token.length} chars)" : "null"}',
    );
    return token;
  }

  Future<void> deleteToken() async {
    _logger.w('deleteToken called');
    await SecureTokenStorage.clearAccessToken();
    await clearCachedUserInfo();
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    final has = token != null && token.isNotEmpty;
    _logger.d('hasToken: $has');
    return has;
  }

  // ============================================================================
  // User Info Caching (for offline auth persistence)
  // ============================================================================

  /// Save user info to secure storage for offline access
  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    _logger.i('Saving user info to cache');
    if (userInfo['id'] != null) {
      await _storage.write(key: 'cached_user_id', value: userInfo['id']);
    }
    if (userInfo['email'] != null) {
      await _storage.write(key: 'cached_user_email', value: userInfo['email']);
    }
    if (userInfo['display_name'] != null) {
      await _storage.write(
        key: 'cached_display_name',
        value: userInfo['display_name'],
      );
    }
    if (userInfo['photo_url'] != null) {
      await _storage.write(
        key: 'cached_photo_url',
        value: userInfo['photo_url'],
      );
    }
    if (userInfo['is_premium'] != null) {
      await _storage.write(
        key: 'cached_is_premium',
        value: userInfo['is_premium'].toString(),
      );
    }
    if (userInfo['subscription_tier'] != null) {
      await _storage.write(
        key: 'cached_subscription_tier',
        value: userInfo['subscription_tier'],
      );
    }
    if (userInfo['onboarding_completed'] != null) {
      await _storage.write(
        key: 'cached_onboarding_completed',
        value: userInfo['onboarding_completed'].toString(),
      );
    }
    _logger.i('User info cached successfully');
  }

  /// Get cached user info from secure storage
  Future<Map<String, dynamic>?> getCachedUserInfo() async {
    final userId = await _storage.read(key: 'cached_user_id');
    if (userId == null) {
      _logger.d('No cached user info found');
      return null;
    }

    final email = await _storage.read(key: 'cached_user_email');
    final displayName = await _storage.read(key: 'cached_display_name');
    final photoUrl = await _storage.read(key: 'cached_photo_url');
    final isPremiumStr = await _storage.read(key: 'cached_is_premium');
    final subscriptionTier = await _storage.read(
      key: 'cached_subscription_tier',
    );
    final onboardingCompletedStr = await _storage.read(
      key: 'cached_onboarding_completed',
    );

    _logger.d('Loaded cached user info for: $email');
    return {
      'id': userId,
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'is_premium': isPremiumStr == 'true',
      'subscription_tier': subscriptionTier ?? 'free',
      'onboarding_completed': onboardingCompletedStr == 'true',
    };
  }

  /// Clear cached user info
  Future<void> clearCachedUserInfo() async {
    _logger.i('Clearing cached user info');
    await _storage.delete(key: 'cached_user_id');
    await _storage.delete(key: 'cached_user_email');
    await _storage.delete(key: 'cached_display_name');
    await _storage.delete(key: 'cached_photo_url');
    await _storage.delete(key: 'cached_is_premium');
    await _storage.delete(key: 'cached_subscription_tier');
    await _storage.delete(key: 'cached_onboarding_completed');
  }

  // ============================================================================
  // Authentication Endpoints
  // ============================================================================

  /// Register new user
  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {'email': email, 'password': password},
      );

      // Save tokens
      await _saveAuthTokens(response.data);

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Login user
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      // Save tokens
      await _saveAuthTokens(response.data);

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Helper to save auth tokens from response
  Future<void> _saveAuthTokens(Map<String, dynamic> data) async {
    final accessToken = data['access_token'];
    final refreshToken = data['refresh_token'];
    final expiresIn = data['expires_in'];

    if (accessToken != null) {
      await saveToken(accessToken);
    }
    if (refreshToken != null) {
      await SecureTokenStorage.storeRefreshToken(refreshToken);
    }
    if (expiresIn != null) {
      await SecureTokenStorage.storeTokenExpiry(expiresIn as int);
    }
  }

  /// Get current user
  /// [timeout] overrides the default Dio timeout for this request.
  Future<Map<String, dynamic>> getCurrentUser({Duration? timeout}) async {
    try {
      final response = await _dio.get(
        '/auth/me',
        options: timeout != null
            ? Options(sendTimeout: timeout, receiveTimeout: timeout)
            : null,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Logout.
  ///
  /// Sends this device's refresh token so the server revokes only this session.
  /// Pass [allDevices] to sign out everywhere.
  Future<void> logout({bool allDevices = false}) async {
    try {
      final refreshToken = await SecureTokenStorage.getRefreshToken();
      await _dio.post(
        '/auth/logout',
        data: {'refresh_token': ?refreshToken, 'all_devices': allDevices},
      );
    } catch (e) {
      _logger.e('Logout error: $e');
    } finally {
      // Local teardown happens regardless: if the server call failed the user
      // still expects to be signed out on this device.
      await deleteToken();
      await SecureTokenStorage.clearAllTokens();
    }
  }

  /// Authenticate with Firebase token (Google Sign-In)
  Future<Map<String, dynamic>> authenticateWithFirebase(
    String firebaseToken,
  ) async {
    try {
      _logger.i('Authenticating with Firebase token...');
      _logger.d(
        'Firebase token (first 50 chars): ${firebaseToken.substring(0, firebaseToken.length > 50 ? 50 : firebaseToken.length)}...',
      );

      final response = await _dio.post(
        '/auth/firebase',
        data: {'firebase_token': firebaseToken},
      );

      _logger.i('Firebase authentication successful');

      // Save tokens
      await _saveAuthTokens(response.data);

      // Verify token was saved
      final savedToken = await getToken();
      _logger.i('Token saved and verified: ${savedToken != null}');

      return response.data;
    } on DioException catch (e) {
      _logger.e(
        'Firebase authentication failed with status: ${e.response?.statusCode}',
      );
      _logger.e('Error type: ${e.type}');
      _logger.e('Error message: ${e.message}');

      if (e.response != null) {
        _logger.e('Response data: ${e.response?.data}');
        _logger.e('Response headers: ${e.response?.headers}');
      }

      // Check if this is an account linking conflict (HTTP 409)
      if (e.response?.statusCode == 409) {
        // Return the error with conflict flag for handling
        throw AccountLinkingRequiredException(
          'An account with this email already exists. Please link your accounts.',
          requiresLinking: true,
        );
      }
      throw _handleError(e);
    }
  }

  /// Link Google account to existing account (requires password verification)
  /// Returns JWT token on success, logging the user in
  Future<Map<String, dynamic>> linkGoogleAccount({
    required String firebaseToken,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/link-google',
        data: {'firebase_token': firebaseToken, 'password': password},
      );

      // Save tokens - linking also logs the user in
      await _saveAuthTokens(response.data);

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Unlink Google account from current account
  Future<Map<String, dynamic>> unlinkGoogleAccount() async {
    try {
      final response = await _dio.post('/auth/unlink-google');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get linked authentication providers
  Future<Map<String, dynamic>> getAuthProviders() async {
    try {
      final response = await _dio.get('/auth/providers');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Change or set password
  Future<void> changePassword({
    String? currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.post(
        '/auth/change-password',
        // snake_case: the API serialises with JsonNamingPolicy.SnakeCaseLower, so
        // camelCase keys bind as null and every call fails validation.
        data: {
          'current_password': ?currentPassword,
          'new_password': newPassword,
          // Changing the password revokes every other session; identify this one
          // so the user isn't signed out of the device they're holding.
          'keep_session_refresh_token':
              ?await SecureTokenStorage.getRefreshToken(),
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Request a password-reset code to be emailed to the user.
  /// Always succeeds server-side (no account enumeration).
  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post('/auth/forgot-password', data: {'email': email});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Reset the password using the code emailed by [forgotPassword].
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      await _dio.post(
        '/auth/reset-password',
        data: {'email': email, 'code': code, 'new_password': newPassword},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ============================================================================
  // Generic HTTP Methods (for future backend services)
  // ============================================================================

  /// Generic GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Expose Dio instance for advanced usage (e.g., file downloads)
  Dio get dio => _dio;

  // ============================================================================
  // Error Handling
  // ============================================================================

  ApiException _handleError(DioException error) {
    final response = error.response;
    if (response != null) {
      final data = response.data;
      final detail = data is Map && data['detail'] != null
          ? data['detail'].toString()
          : 'Request failed (HTTP ${response.statusCode}).';
      return ApiException(detail, statusCode: response.statusCode);
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const ApiException(
        'Connection timeout. Please check your internet connection.',
      );
    }

    if (error.type == DioExceptionType.connectionError) {
      return const ApiException(
        'Cannot connect to server. Please check your internet connection.',
      );
    }

    return ApiException('An unexpected error occurred: ${error.message}');
  }
}

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

  /// Flag to prevent multiple simultaneous token refresh attempts
  bool _isRefreshing = false;

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

    // Request interceptor to add JWT token and handle token refresh
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Skip token refresh for auth endpoints
          final isAuthEndpoint =
              options.path.contains('/auth/refresh') ||
              options.path.contains('/auth/login') ||
              options.path.contains('/auth/register') ||
              options.path.contains('/auth/firebase');

          // Check if token is expiring soon and refresh it (unless we're already refreshing)
          if (!isAuthEndpoint && !_isRefreshing) {
            final isExpiringSoon =
                await SecureTokenStorage.isTokenExpiringSoon();
            if (isExpiringSoon) {
              _logger.i('Token expiring soon, attempting refresh...');
              await _refreshAccessToken();
            }
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

            // Skip retry for auth endpoints to avoid infinite loops
            final isAuthEndpoint =
                error.requestOptions.path.contains('/auth/refresh') ||
                error.requestOptions.path.contains('/auth/login') ||
                error.requestOptions.path.contains('/auth/register') ||
                error.requestOptions.path.contains('/auth/firebase');

            if (!isPasswordError && !isAuthEndpoint && !_isRefreshing) {
              // Try to refresh the token before logging out
              _logger.w(
                'Received 401 Unauthorized - attempting token refresh before logout',
              );

              final refreshToken = await SecureTokenStorage.getRefreshToken();
              if (refreshToken != null) {
                _isRefreshing = true;
                try {
                  final refreshDio = Dio(
                    BaseOptions(
                      baseUrl: baseUrl + apiV1,
                      headers: {'Content-Type': 'application/json'},
                    ),
                  );

                  final refreshResponse = await refreshDio.post(
                    '/auth/refresh',
                    data: {'token': refreshToken},
                  );

                  if (refreshResponse.statusCode == 200) {
                    // Token refresh successful, retry the original request
                    final newAccessToken = refreshResponse.data['access_token'];
                    final newRefreshToken =
                        refreshResponse.data['refresh_token'];
                    final expiresIn = refreshResponse.data['expires_in'] as int;

                    await saveToken(newAccessToken);
                    await SecureTokenStorage.storeRefreshToken(newRefreshToken);
                    await SecureTokenStorage.storeTokenExpiry(expiresIn);

                    _logger.i(
                      'Token refresh successful on 401 - retrying original request',
                    );

                    // Retry the original request with new token
                    final opts = error.requestOptions;
                    opts.headers['Authorization'] = 'Bearer $newAccessToken';

                    try {
                      final retryResponse = await _dio.fetch(opts);
                      _isRefreshing = false;
                      return handler.resolve(retryResponse);
                    } catch (retryError) {
                      _isRefreshing = false;
                      _logger.e(
                        'Retry after token refresh failed: $retryError',
                      );
                      // Fall through to logout
                    }
                  }
                } catch (refreshError) {
                  _logger.e('Token refresh on 401 failed: $refreshError');
                } finally {
                  _isRefreshing = false;
                }
              }

              // Token refresh failed or not available, logout
              _logger.w('Token refresh failed - triggering logout');
              await deleteToken();
              onUnauthorized?.call();
            } else if (!isPasswordError && !isAuthEndpoint) {
              // Already refreshing, just trigger logout
              _logger.w(
                'Received 401 while already refreshing - triggering logout',
              );
              await deleteToken();
              onUnauthorized?.call();
            } else if (isPasswordError) {
              _logger.w(
                'Received 401 for incorrect password - NOT triggering logout',
              );
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

  /// Refresh the access token using the refresh token
  Future<void> _refreshAccessToken() async {
    if (_isRefreshing) return;

    final refreshToken = await SecureTokenStorage.getRefreshToken();
    if (refreshToken == null) {
      _logger.w('No refresh token available - cannot refresh');
      return;
    }

    _isRefreshing = true;
    try {
      _logger.i('Refreshing access token...');

      // Use a separate Dio instance for refresh to avoid interceptor loops
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: baseUrl + apiV1,
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final response = await refreshDio.post(
        '/auth/refresh',
        data: {'token': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];
        final expiresIn = response.data['expires_in'] as int;

        await saveToken(newAccessToken);
        await SecureTokenStorage.storeRefreshToken(newRefreshToken);
        await SecureTokenStorage.storeTokenExpiry(expiresIn);

        _logger.i('Token refresh successful');
      } else {
        _logger.e('Token refresh failed with status: ${response.statusCode}');
        await _handleRefreshFailure();
      }
    } on DioException catch (e) {
      _logger.e('Token refresh failed: ${e.message}');
      await _handleRefreshFailure();
    } finally {
      _isRefreshing = false;
    }
  }

  /// Handle token refresh failure - clear tokens and trigger logout
  Future<void> _handleRefreshFailure() async {
    _logger.w('Token refresh failed - clearing tokens and triggering logout');
    await deleteToken();
    await SecureTokenStorage.clearAllTokens();
    onUnauthorized?.call();
  }

  Future<void> saveToken(String token) async {
    _logger.i('saveToken called, token length: ${token.length}');
    await _storage.write(key: 'auth_token', value: token);
    _logger.i('saveToken completed');
  }

  Future<String?> getToken() async {
    final token = await _storage.read(key: 'auth_token');
    _logger.d(
      'getToken called, result: ${token != null ? "exists (${token.length} chars)" : "null"}',
    );
    return token;
  }

  Future<void> deleteToken() async {
    _logger.w('deleteToken called');
    await _storage.delete(key: 'auth_token');
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
            ? Options(
                sendTimeout: timeout,
                receiveTimeout: timeout,
              )
            : null,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (e) {
      _logger.e('Logout error: $e');
    } finally {
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
      await _dio.post('/auth/change-password', data: {
        'currentPassword': ?currentPassword,
        'newPassword': newPassword,
      });
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

  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map && data.containsKey('detail')) {
        return data['detail'].toString();
      }
      return 'Error: ${error.response!.statusMessage}';
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'Cannot connect to server. Please check your internet connection.';
    }

    return 'An unexpected error occurred: ${error.message}';
  }
}

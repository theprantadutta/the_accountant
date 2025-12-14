import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

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
      dotenv.env['API_BASE_URL_PROD'] ?? 'https://accountant.pranta.dev';
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

    // Request interceptor to add JWT token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
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

            if (!isPasswordError) {
              _logger.w('Received 401 Unauthorized - triggering logout');
              await deleteToken();
              onUnauthorized?.call();
            } else {
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
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    final has = token != null && token.isNotEmpty;
    _logger.d('hasToken: $has');
    return has;
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

      // Save token
      final token = response.data['access_token'];
      await saveToken(token);

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

      // Save token
      final token = response.data['access_token'];
      await saveToken(token);

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get current user
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _dio.get('/auth/me');
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

      // Save token
      final token = response.data['access_token'];
      _logger.i('Saving JWT token: ${token?.substring(0, 20)}...');
      await saveToken(token);

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

      // Save token - linking also logs the user in
      final token = response.data['access_token'];
      if (token != null) {
        await saveToken(token);
      }

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

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' as getx;
import '../errors/app_exception.dart';
import '../../constants/app_constants.dart';
import '../../view/screens/auth/login.dart';
import 'api_endpoints.dart';

/// The single Dio instance for the whole app.
/// This is your axios instance — configured once, used everywhere.
///
/// Handles:
///   - Base URL
///   - Auth token injection (like axios request interceptor)
///   - Error normalization (like axios response interceptor)
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  static const _storage = FlutterSecureStorage();
  static const _tokenKey = StorageKeys.accessToken;

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  )
    .._addRequestInterceptor()
    .._addResponseInterceptor();

  // ── Public methods ──────────────────────────────────────────────────────────

  Future<Response> get(String path, {Map<String, dynamic>? query}) =>
      _dio.get(path, queryParameters: query);

  Future<Response> post(String path, {dynamic data}) =>
      _dio.post(path, data: data);

  Future<Response> patch(String path, {dynamic data}) =>
      _dio.patch(path, data: data);

  Future<Response> delete(String path) => _dio.delete(path);

  Future<Response> postFormData(String path, FormData formData) =>
      _dio.post(path, data: formData);

  Future<Response> patchFormData(String path, FormData formData) =>
      _dio.patch(path, data: formData);

  // ── Token helpers ───────────────────────────────────────────────────────────

  static Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  static Future<String?> getToken() => _storage.read(key: _tokenKey);

  static Future<void> clearToken() => _storage.delete(key: _tokenKey);
}

// ── Interceptors ──────────────────────────────────────────────────────────────
// Written as Dio extensions to keep ApiClient clean.

extension on Dio {
  /// Request interceptor — attaches Bearer token to every request.
  /// Equivalent to axios: config.headers.Authorization = `Bearer ${token}`
  void _addRequestInterceptor() {
    interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await ApiClient.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  /// Response interceptor — converts every non-2xx response into a
  /// typed AppException so services never deal with raw DioException.
  ///
  /// On 401: attempts a silent token refresh. If refresh succeeds the
  /// original request is retried transparently. If it fails the session
  /// is cleared and the user is sent to Login.
  void _addResponseInterceptor() {
    interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) async {
          // Attempt refresh only on 401 and only once (guard against loops
          // on the refresh endpoint itself or while a refresh is in-flight).
          if (e.response?.statusCode == 401 &&
              !_isRefreshing &&
              e.requestOptions.path != ApiEndpoints.refreshToken) {
            final storedRefreshToken = await ApiClient._storage
                .read(key: StorageKeys.refreshToken);

            if (storedRefreshToken != null) {
              _isRefreshing = true;
              bool refreshSucceeded = false;
              
              try {
                // Use a clean Dio so this interceptor is not triggered again.
                final refreshDio = Dio(BaseOptions(
                  baseUrl: ApiEndpoints.baseUrl,
                  headers: {'Content-Type': 'application/json'},
                ));
                final response = await refreshDio.post(
                  ApiEndpoints.refreshToken,
                  data: {'refreshToken': storedRefreshToken},
                );
                final newToken =
                    response.data['data']['accessToken'] as String;
                await ApiClient.saveToken(newToken);
                refreshSucceeded = true;

                // Retry the original request with the refreshed token.
                e.requestOptions.headers['Authorization'] =
                    'Bearer $newToken';
                _isRefreshing = false;
                
                try {
                  final retryResponse = await fetch(e.requestOptions);
                  return handler.resolve(retryResponse);
                } catch (retryError) {
                  // Token is valid but retry failed - let the error propagate normally
                  // Don't logout the user
                  final appException = _mapDioError(retryError as DioException);
                  return handler.reject(
                    DioException(
                      requestOptions: e.requestOptions,
                      response: (retryError as DioException).response,
                      type: DioExceptionType.unknown,
                      error: appException,
                    ),
                  );
                }
              } catch (refreshError) {
                _isRefreshing = false;
                
                // Check if it's a network error or auth error
                if (refreshError is DioException) {
                  final isNetworkError = refreshError.type == DioExceptionType.connectionError ||
                                        refreshError.type == DioExceptionType.connectionTimeout ||
                                        refreshError.type == DioExceptionType.receiveTimeout ||
                                        refreshError.type == DioExceptionType.sendTimeout;
                  
                  if (isNetworkError) {
                    // Network error - don't logout, just let the error propagate
                    refreshSucceeded = true; // Prevent logout
                  } else if (refreshError.response?.statusCode == 401 || refreshError.response?.statusCode == 403) {
                    // Auth error - refresh token is invalid
                    refreshSucceeded = false;
                  } else {
                    // Other error - keep user logged in
                    refreshSucceeded = true;
                  }
                } else {
                  // Unknown error type - keep user logged in to be safe
                  refreshSucceeded = true;
                }
              }
              
              // Only logout if refresh actually failed
              if (!refreshSucceeded) {
                await ApiClient._storage.deleteAll();
                try {
                  getx.Get.offAll(() => const Login());
                } catch (_) {}
              }
            } else {
              // No refresh token available
              await ApiClient._storage.deleteAll();
              try {
                getx.Get.offAll(() => const Login());
              } catch (_) {}
            }
          }

          // Throw AppException so services can catch it directly
          // This is caught by the try-catch in service methods
          final appException = _mapDioError(e);
          return handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              response: e.response,
              type: DioExceptionType.unknown,
              error: appException,
            ),
          );
        },
      ),
    );
  }

  static bool _isRefreshing = false;
}

/// Maps a raw DioException → typed AppException.
/// Reads the backend's { success: false, error: { code, message } } shape.
AppException _mapDioError(DioException e) {
  // No internet / timeout
  if (e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    return const NetworkException();
  }

  final response = e.response;
  if (response == null) return const NetworkException();

  // Try to read backend error shape
  final body = response.data;
  final message = (body is Map)
      ? (body['error']?['message'] ?? 'Something went wrong')
      : 'Something went wrong';

  return switch (response.statusCode) {
    400 => ValidationException(message),
    401 => AuthException(message),
    403 => ForbiddenException(message),
    404 => NotFoundException(message),
    409 => ConflictException(message),
    _   => ServerException(message),
  };
}

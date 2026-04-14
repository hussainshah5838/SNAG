import 'package:dio/dio.dart';
import '../core/errors/app_exception.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../core/utils/result.dart';
import '../models/user_model.dart';

/// All raw auth API calls live here.
/// This layer only talks to the network — no state, no UI logic.
///
/// React Native equivalent: your authService.ts / auth.api.ts file.
/// Backend equivalent: auth.repository.ts (just DB, no logic).
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final _client = ApiClient.instance;

  /// Helper to extract AppException from DioException
  static AppException _handleError(dynamic e) {
    if (e is DioException && e.error is AppException) {
      return e.error as AppException;
    }
    if (e is AppException) {
      return e;
    }
    return const NetworkException();
  }

  // ── Merchant Auth ───────────────────────────────────────────────────────────

  Future<Result<String>> merchantRegister({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final res = await _client.post(
        ApiEndpoints.merchantRegister,
        data: {
          'firstName':   firstName,
          'lastName':    lastName,
          'email':       email,
          'phoneNumber': phoneNumber,
          'password':    password,
        },
      );
      final message = res.data['data']['message'] as String;
      return Result.success(message);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── Client Auth ─────────────────────────────────────────────────────────────

  Future<Result<String>> clientRegister({
    required String userName,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    try {
      final res = await _client.post(
        ApiEndpoints.clientRegister,
        data: {
          'userName':    userName,
          'phoneNumber': phoneNumber,
          'email':       email,
          'password':    password,
        },
      );
      final message = res.data['data']['message'] as String;
      return Result.success(message);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── Shared ──────────────────────────────────────────────────────────────────

  /// Verify email OTP — works for both merchant and client.
  /// [isMerchant] decides which endpoint to hit.
  Future<Result<AuthResponse>> verifyEmail({
    required String email,
    required String code,
    required bool isMerchant,
  }) async {
    try {
      final endpoint = isMerchant
          ? ApiEndpoints.merchantVerifyEmail
          : ApiEndpoints.clientVerifyEmail;

      final res = await _client.post(endpoint, data: {
        'email': email,
        'code':  code,
      });

      final data = res.data['data'] as Map<String, dynamic>;
      final auth = AuthResponse.fromJson(data);

      // Persist token immediately after verify
      await ApiClient.saveToken(auth.accessToken);

      return Result.success(auth);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  Future<Result<String>> resendCode({
    required String email,
    required bool isMerchant,
  }) async {
    try {
      final endpoint = isMerchant
          ? ApiEndpoints.merchantResendCode
          : ApiEndpoints.clientResendCode;

      final res = await _client.post(endpoint, data: {'email': email});
      final message = res.data['data']['message'] as String;
      return Result.success(message);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  Future<Result<AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _client.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      final data = res.data['data'] as Map<String, dynamic>;
      final auth = AuthResponse.fromJson(data);

      await ApiClient.saveToken(auth.accessToken);

      return Result.success(auth);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── Password ────────────────────────────────────────────────────────────────

  Future<Result<String>> forgotPassword({required String email}) async {
    try {
      final res = await _client.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
      );
      final message = res.data['data']['message'] as String;
      return Result.success(message);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  Future<Result<String>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final res = await _client.post(
        ApiEndpoints.resetPassword,
        data: {
          'email':           email,
          'code':            code,
          'newPassword':     newPassword,
          'confirmPassword': confirmPassword,
        },
      );
      final message = res.data['data']['message'] as String;
      return Result.success(message);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  Future<Result<String>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final res = await _client.post(
        ApiEndpoints.changePassword,
        data: {
          'currentPassword': currentPassword,
          'newPassword':     newPassword,
          'confirmPassword': confirmPassword,
        },
      );
      final message = res.data['data']['message'] as String;
      return Result.success(message);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── Logout ──────────────────────────────────────────────────────────────────

  Future<Result<String>> logout({String? refreshToken}) async {
    try {
      final res = await _client.post(
        ApiEndpoints.logout,
        data: refreshToken != null ? {'refreshToken': refreshToken} : null,
      );
      await ApiClient.clearToken();
      final message = res.data['message'] as String? ?? 'Logged out successfully';
      return Result.success(message);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── Get Current User ────────────────────────────────────────────────────────

  Future<Result<UserModel>> getCurrentUser() async {
    try {
      final res = await _client.get('/auth/me');
      final user = UserModel.fromJson(res.data['data'] as Map<String, dynamic>);
      return Result.success(user);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── Delete Account ──────────────────────────────────────────────────────────

  Future<Result<String>> deleteAccount() async {
    try {
      final res = await _client.delete(ApiEndpoints.deleteAccount);
      await ApiClient.clearToken();
      final message = res.data['message'] as String? ?? 'Account deleted successfully';
      return Result.success(message);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }
}

// ── Response Models ───────────────────────────────────────────────────────────

/// Shape returned by login and verify-email endpoints.
/// { accessToken, refreshToken, user }
class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        accessToken:  json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        user:         UserModel.fromJson(json['user'] as Map<String, dynamic>),
      );
}

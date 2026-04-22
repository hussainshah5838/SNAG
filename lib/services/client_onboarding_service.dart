import 'dart:io';
import 'package:dio/dio.dart';
import '../core/errors/app_exception.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../core/utils/result.dart';

/// All client onboarding API calls.
/// Mirrors backend: modules/client/onboarding/
class ClientOnboardingService {
  ClientOnboardingService._();
  static final ClientOnboardingService instance = ClientOnboardingService._();

  final _client = ApiClient.instance;

  // ── Location ────────────────────────────────────────────────────────────────

  Future<Result<String>> saveLocation({
    required double lat,
    required double lng,
  }) async {
    try {
      final res = await _client.post(
        ApiEndpoints.clientLocation,
        data: {'lat': lat, 'lng': lng},
      );
      return Result.success(res.data['message'] as String? ?? 'Location saved');
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  // ── Interests ───────────────────────────────────────────────────────────────

  Future<Result<String>> saveInterests({
    required List<String> interests,
  }) async {
    try {
      final res = await _client.post(
        ApiEndpoints.clientInterests,
        data: {'interests': interests},
      );
      return Result.success(res.data['message'] as String? ?? 'Interests saved');
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  // ── Avatar ──────────────────────────────────────────────────────────────────

  Future<Result<String>> uploadAvatar({required File imageFile}) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });
      final res = await _client.postFormData(ApiEndpoints.clientAvatar, formData);
      return Result.success(res.data['message'] as String? ?? 'Avatar uploaded');
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  // ── Complete ─────────────────────────────────────────────────────────────────

  Future<Result<String>> completeOnboarding() async {
    try {
      final res = await _client.post(ApiEndpoints.clientComplete);
      return Result.success(res.data['message'] as String? ?? "You're all set");
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }
}

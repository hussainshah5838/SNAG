import 'dart:io';
import 'package:dio/dio.dart';
import '../core/errors/app_exception.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../core/utils/result.dart';
import '../models/profile_model.dart';

/// Client profile service - get, update interests, update avatar
/// This layer only talks to the network — no state, no UI logic.
class ClientProfileService {
  ClientProfileService._();
  static final ClientProfileService instance = ClientProfileService._();

  final _client = ApiClient.instance;

  // ── Get Profile ─────────────────────────────────────────────────────────────

  Future<Result<ProfileModel>> getProfile() async {
    try {
      print('🌐 [ProfileService] Calling GET ${ApiEndpoints.clientProfile}');
      final res = await _client.get(ApiEndpoints.clientProfile);
      print('✅ [ProfileService] Response received: ${res.statusCode}');
      print('📦 [ProfileService] Response data: ${res.data}');
      final profile = ProfileModel.fromJson(res.data['data'] as Map<String, dynamic>);
      print('✅ [ProfileService] Profile parsed: ${profile.email}');
      return Result.success(profile);
    } on AppException catch (e) {
      print('❌ [ProfileService] Error: ${e.message}');
      return Result.failure(e);
    } catch (e) {
      print('❌ [ProfileService] Unexpected error: $e');
      return Result.failure(const NetworkException());
    }
  }

  // ── Update Interests ────────────────────────────────────────────────────────

  Future<Result<ProfileModel>> updateInterests(List<String> interests) async {
    try {
      final res = await _client.patch(
        ApiEndpoints.clientProfile,
        data: {'interests': interests},
      );
      final profile = ProfileModel.fromJson(res.data['data'] as Map<String, dynamic>);
      return Result.success(profile);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  // ── Update Avatar ───────────────────────────────────────────────────────────

  Future<Result<ProfileModel>> updateAvatar(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final res = await _client.patch(
        ApiEndpoints.clientProfileAvatar,
        data: formData,
      );

      final profile = ProfileModel.fromJson(res.data['data'] as Map<String, dynamic>);
      return Result.success(profile);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }
}

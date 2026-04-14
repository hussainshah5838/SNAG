import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../core/utils/result.dart';
import '../core/errors/app_exception.dart';
import '../models/preferences_model.dart';

/// Service for client preferences operations
class PreferencesService {
  PreferencesService._();
  static final PreferencesService instance = PreferencesService._();

  final _client = ApiClient.instance;

  /// Get user preferences
  Future<Result<PreferencesModel>> getPreferences() async {
    try {
      print('🌐 [PreferencesService] Calling GET ${ApiEndpoints.clientPreferences}');
      final response = await _client.get(ApiEndpoints.clientPreferences);
      print('✅ [PreferencesService] Response received: ${response.statusCode}');
      print('📦 [PreferencesService] Response data: ${response.data}');
      final preferences = PreferencesModel.fromJson(response.data['data']);
      print('✅ [PreferencesService] Preferences parsed');
      return Result.success(preferences);
    } on AppException catch (e) {
      print('❌ [PreferencesService] Error: ${e.message}');
      return Result.failure(e);
    } catch (e) {
      print('❌ [PreferencesService] Unexpected error: $e');
      return Result.failure(const NetworkException());
    }
  }

  /// Update user preferences
  Future<Result<PreferencesModel>> updatePreferences(
    PreferencesModel preferences,
  ) async {
    try {
      final response = await _client.patch(
        ApiEndpoints.clientPreferences,
        data: preferences.toJson(),
      );
      final updated = PreferencesModel.fromJson(response.data['data']);
      return Result.success(updated);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }
}

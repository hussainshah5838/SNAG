import '../core/errors/app_exception.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../core/utils/result.dart';
import '../models/merchant_settings_model.dart';

/// Merchant settings API calls
/// Handles merchant notification preferences
class MerchantSettingsService {
  MerchantSettingsService._();
  static final MerchantSettingsService instance = MerchantSettingsService._();

  final _client = ApiClient.instance;

  /// Get merchant notification settings
  /// Creates default settings if not exists (upsert pattern)
  Future<Result<MerchantSettingsModel>> getSettings() async {
    try {
      final res = await _client.get(ApiEndpoints.merchantSettingsNotifications);
      final data = res.data['data'] as Map<String, dynamic>;
      final settings = MerchantSettingsModel.fromJson(data);
      return Result.success(settings);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  /// Update merchant notification settings
  Future<Result<MerchantSettingsModel>> updateSettings({
    EmailNotifications? email,
    PushNotifications? push,
    SmsNotifications? sms,
  }) async {
    try {
      final res = await _client.patch(
        ApiEndpoints.merchantSettingsNotifications,
        data: {
          'notifications': {
            if (email != null) 'email': email.toJson(),
            if (push != null) 'push': push.toJson(),
            if (sms != null) 'sms': sms.toJson(),
          },
        },
      );
      final data = res.data['data'] as Map<String, dynamic>;
      final settings = MerchantSettingsModel.fromJson(data);
      return Result.success(settings);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }
}

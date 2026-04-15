import 'package:get/get.dart';
import '../models/preferences_model.dart';
import '../services/preferences_service.dart';

/// Controller for client preferences
class ClientPreferencesController extends GetxController {
  static ClientPreferencesController get instance => Get.find<ClientPreferencesController>();

  final _service = PreferencesService.instance;

  final isLoading = false.obs;
  final errorMsg = ''.obs;
  final preferences = Rxn<PreferencesModel>();

  @override
  void onInit() {
    super.onInit();
    loadPreferences();
  }

  @override
  void onReady() {
    super.onReady();
  }

  /// Load user preferences
  Future<void> loadPreferences() async {
    try {
      isLoading.value = true;
      errorMsg.value = '';

      final result = await _service.getPreferences();

      result
          .onSuccess((data) {
        preferences.value = data;
      })
          .onFailure((e) {
        errorMsg.value = e.message;
      });
    } finally {
      isLoading.value = false;
    }
  }

  /// Update user preferences
  Future<bool> updatePreferences(PreferencesModel updatedPreferences) async {
    try {
      isLoading.value = true;
      errorMsg.value = '';

      final result = await _service.updatePreferences(updatedPreferences);

      result
          .onSuccess((data) {
        preferences.value = data;
        Get.snackbar(
          'Success',
          'Preferences updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      })
          .onFailure((e) {
        errorMsg.value = e.message;
        Get.snackbar(
          'Error',
          e.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      });

      return result.isSuccess;
    } finally {
      isLoading.value = false;
    }
  }

  // Getters for easy access
  NotificationPreferences get notifications =>
      preferences.value?.notifications ??
      const NotificationPreferences(email: true, push: true, sms: false);

  String get language => preferences.value?.language ?? 'en';
  String get distanceUnit => preferences.value?.distanceUnit ?? 'km';
  String get currency => preferences.value?.currency ?? 'USD';

  PrivacySettings get privacy =>
      preferences.value?.privacy ??
      const PrivacySettings(showProfile: true, shareLocation: true);
}

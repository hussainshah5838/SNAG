import 'dart:io';
import 'package:get/get.dart';
import '../models/profile_model.dart';
import '../services/client_profile_service.dart';

/// Controller for client profile management
class ClientProfileController extends GetxController {
  static ClientProfileController get instance => Get.find<ClientProfileController>();

  final _service = ClientProfileService.instance;

  final isLoading = false.obs;
  final errorMsg = ''.obs;
  final profile = Rxn<ProfileModel>();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  @override
  void onReady() {
    super.onReady();
  }

  /// Load user profile
  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      errorMsg.value = '';

      final result = await _service.getProfile();

      result
          .onSuccess((data) {
        profile.value = data;
      })
          .onFailure((e) {
        errorMsg.value = e.message;
      });
    } finally {
      isLoading.value = false;
    }
  }

  /// Update user interests
  Future<bool> updateInterests(List<String> interests) async {
    try {
      isLoading.value = true;
      errorMsg.value = '';

      final result = await _service.updateInterests(interests);

      result
          .onSuccess((data) {
        profile.value = data;
        Get.snackbar(
          'Success',
          'Interests updated successfully',
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

  /// Update user avatar
  Future<bool> updateAvatar(File imageFile) async {
    try {
      isLoading.value = true;
      errorMsg.value = '';

      final result = await _service.updateAvatar(imageFile);

      result
          .onSuccess((data) {
        profile.value = data;
        Get.snackbar(
          'Success',
          'Profile picture updated successfully',
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

  /// Get full name
  String get fullName {
    final name = profile.value != null
        ? '${profile.value!.firstName ?? ''} ${profile.value!.lastName ?? ''}'.trim()
        : '';
    return name;
  }

  /// Get email
  String get email {
    final emailValue = profile.value?.email ?? '';
    return emailValue;
  }

  /// Get avatar URL
  String? get avatarUrl {
    final url = profile.value?.avatarUrl;
    return url;
  }

  /// Get interests
  List<String> get interests => profile.value?.interests ?? [];
}

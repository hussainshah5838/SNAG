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
    print('🚀 [ClientProfileController] onInit called');
    loadProfile();
  }

  @override
  void onReady() {
    super.onReady();
    print('✅ [ClientProfileController] onReady called');
  }

  /// Load user profile
  Future<void> loadProfile() async {
    try {
      print('🔄 Loading profile...');
      isLoading.value = true;
      errorMsg.value = '';

      final result = await _service.getProfile();

      result
          .onSuccess((data) {
        print('✅ Profile loaded: ${data.firstName} ${data.lastName}, ${data.email}');
        print('📧 Email: ${data.email}');
        print('🖼️ Avatar: ${data.avatarUrl}');
        print('🎯 Interests: ${data.interests}');
        profile.value = data;
      })
          .onFailure((e) {
        print('❌ Profile load failed: ${e.message}');
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
    print('👤 Full name getter: "$name"');
    return name;
  }

  /// Get email
  String get email {
    final emailValue = profile.value?.email ?? '';
    print('📧 Email getter: "$emailValue"');
    return emailValue;
  }

  /// Get avatar URL
  String? get avatarUrl {
    final url = profile.value?.avatarUrl;
    print('🖼️ Avatar URL getter: "$url"');
    return url;
  }

  /// Get interests
  List<String> get interests => profile.value?.interests ?? [];
}

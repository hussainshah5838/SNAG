import 'dart:io';
import 'package:get/get.dart';
import '../services/merchant_onboarding_service.dart';

/// Merchant profile state + actions for settings/profile management.
/// Handles branch profile data (separate from user auth data).
class MerchantProfileController extends GetxController {
  static MerchantProfileController get instance =>
      Get.find<MerchantProfileController>();

  final _service = MerchantOnboardingService.instance;
  
  final isLoading = false.obs;
  final errorMsg = ''.obs;
  final branchProfile = Rxn<Map<String, dynamic>>();

  // Computed getters for easy access
  String? get branchName => branchProfile.value?['branchName'] as String?;
  String? get phoneNumber => branchProfile.value?['phoneNumber'] as String?;
  String? get branchAddress => branchProfile.value?['branchAddress'] as String?;
  String? get industry => branchProfile.value?['industry'] as String?;
  String? get logoUrl => branchProfile.value?['logoUrl'] as String?;
  List<String>? get subCategories => 
      (branchProfile.value?['subCategories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList();

  /// Fetch branch profile from backend
  Future<void> fetchBranchProfile() async {
    errorMsg.value = '';
    isLoading.value = true;
    
    try {
      final result = await _service.getBranchProfile();
      
      result
          .onSuccess((data) => branchProfile.value = data)
          .onFailure((e) => errorMsg.value = e.message);
    } finally {
      isLoading.value = false;
    }
  }

  /// Update branch profile
  Future<bool> updateBranchProfile({
    String? branchName,
    String? phoneNumber,
    String? branchAddress,
    String? industry,
    List<String>? subCategories,
    File? logoFile,
    String? role,
  }) async {
    errorMsg.value = '';
    isLoading.value = true;
    
    try {
      final result = await _service.editBranchProfile(
        branchName: branchName,
        phoneNumber: phoneNumber,
        branchAddress: branchAddress,
        industry: industry,
        subCategories: subCategories,
        logoFile: logoFile,
        role: role,
      );

      if (result.isSuccess) {
        // Refresh profile data after successful update
        await fetchBranchProfile();
        return true;
      } else {
        result.onFailure((e) {
          errorMsg.value = e.message;
        });
        return false;
      }
    } catch (e) {
      errorMsg.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}

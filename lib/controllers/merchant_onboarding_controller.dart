import 'dart:io';
import 'package:get/get.dart';
import '../services/merchant_onboarding_service.dart';

/// Merchant onboarding state + actions.
class MerchantOnboardingController extends GetxController {
  static MerchantOnboardingController get instance =>
      Get.find<MerchantOnboardingController>();

  final _service  = MerchantOnboardingService.instance;
  final isLoading        = false.obs;
  final isFetchingLocations = false.obs;
  final errorMsg         = ''.obs;
  final locations        = <Map<String, dynamic>>[].obs;

  /// Guarantees isLoading resets even on unexpected errors.
  Future<bool> _run(Future<bool> Function() action) async {
    errorMsg.value  = '';
    isLoading.value = true;
    try {
      return await action();
    } catch (e) {
      errorMsg.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveBranchProfile({
    required String branchName,
    required String phoneNumber,
    required String branchAddress,
    required String industry,
    required List<String> subCategories,
    File? logoFile,
  }) => _run(() async {
    final result = await _service.saveBranchProfile(
      branchName: branchName, phoneNumber: phoneNumber,
      branchAddress: branchAddress, industry: industry,
      subCategories: subCategories, logoFile: logoFile,
    );
    result.onFailure((e) => errorMsg.value = e.message);
    return result.isSuccess;
  });

  Future<bool> addLocation({
    required String address, required String state,
    required String country, required String branchAddress,
    required String locationType, required double lat, required double lng,
    File? bannerFile,
    String? phoneNumber,
    String? email,
  }) => _run(() async {
    final result = await _service.addLocation(
      address: address, state: state, country: country,
      branchAddress: branchAddress, locationType: locationType,
      lat: lat, lng: lng,
      bannerFile: bannerFile,
      phoneNumber: phoneNumber,
      email: email,
    );
    result.onFailure((e) => errorMsg.value = e.message);
    return result.isSuccess;
  });

  Future<bool> bulkUploadLocations({required File csvFile, String? notes}) =>
      _run(() async {
        final result = await _service.bulkUploadLocations(csvFile: csvFile, notes: notes);
        result.onFailure((e) => errorMsg.value = e.message);
        return result.isSuccess;
      });

  Future<void> fetchLocations() async {
    errorMsg.value  = '';
    isFetchingLocations.value = true;
    try {
      final result = await _service.getLocations();
      result
        .onSuccess((list) => locations.assignAll(list))
        .onFailure((e)    => errorMsg.value = e.message);
    } finally {
      isFetchingLocations.value = false;
    }
  }

  Future<bool> completeOnboarding() => _run(() async {
    final result = await _service.completeOnboarding();
    result.onFailure((e) => errorMsg.value = e.message);
    return result.isSuccess;
  });

  Future<bool> saveMerchantLocation({required double lat, required double lng}) =>
      _run(() async {
        final result = await _service.saveMerchantLocation(lat: lat, lng: lng);
        result.onFailure((e) => errorMsg.value = e.message);
        return result.isSuccess;
      });
}

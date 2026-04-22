import 'dart:io';
import 'package:get/get.dart';
import '../services/client_onboarding_service.dart';

/// Client onboarding state + actions.
class ClientOnboardingController extends GetxController {
  static ClientOnboardingController get instance =>
      Get.find<ClientOnboardingController>();

  final _service = ClientOnboardingService.instance;

  final isLoading = false.obs;
  final errorMsg  = ''.obs;

  /// Wraps every action — guarantees isLoading resets even on unexpected errors.
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

  Future<bool> saveLocation({required double lat, required double lng}) =>
      _run(() async {
        final result = await _service.saveLocation(lat: lat, lng: lng);
        result.onFailure((e) => errorMsg.value = e.message);
        return result.isSuccess;
      });

  Future<bool> saveInterests({required List<String> interests}) =>
      _run(() async {
        final result = await _service.saveInterests(interests: interests);
        result.onFailure((e) => errorMsg.value = e.message);
        return result.isSuccess;
      });

  Future<bool> uploadAvatar({required File imageFile}) =>
      _run(() async {
        final result = await _service.uploadAvatar(imageFile: imageFile);
        result.onFailure((e) => errorMsg.value = e.message);
        return result.isSuccess;
      });

  Future<bool> completeOnboarding() =>
      _run(() async {
        final result = await _service.completeOnboarding();
        result.onFailure((e) => errorMsg.value = e.message);
        return result.isSuccess;
      });
}

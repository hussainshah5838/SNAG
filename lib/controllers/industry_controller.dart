import 'package:get/get.dart';
import '../services/industry_service.dart';

/// Holds the industries list fetched from backend.
/// Shared between merchant onboarding and client discover offers screen.
///
/// Register once in main.dart → Get.put(IndustryController())
/// Access anywhere           → IndustryController.instance
class IndustryController extends GetxController {
  static IndustryController get instance => Get.find<IndustryController>();

  final _service = IndustryService.instance;

  // ── State ──────────────────────────────────────────────────────────────────

  final industries = <String>[].obs; // the fetched list
  final isLoading  = false.obs;
  final errorMsg   = ''.obs;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  /// Called automatically when controller is first created.
  /// Fetches industries once — cached for the whole session.
  @override
  void onInit() {
    super.onInit();
    fetchIndustries();
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> fetchIndustries() async {
    isLoading.value = true;
    errorMsg.value  = '';

    final result = await _service.getIndustries();

    result
      .onSuccess((list) => industries.assignAll(list))
      .onFailure((e)    => errorMsg.value = e.message);

    isLoading.value = false;
  }
}

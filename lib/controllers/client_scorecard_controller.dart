import 'package:get/get.dart';
import '../models/scorecard_model.dart';
import '../services/client_scorecard_service.dart';

/// Controller for client scorecard
class ClientScorecardController extends GetxController {
  static ClientScorecardController get instance => Get.find<ClientScorecardController>();

  final _service = ClientScorecardService.instance;

  final isLoading = false.obs;
  final errorMsg = ''.obs;
  final scorecard = Rxn<ScorecardModel>();

  @override
  void onInit() {
    super.onInit();
    loadScorecard();
  }

  @override
  void onReady() {
    super.onReady();
  }

  /// Load user scorecard
  Future<void> loadScorecard() async {
    try {
      isLoading.value = true;
      errorMsg.value = '';

      final result = await _service.getScorecard();

      result
          .onSuccess((data) => scorecard.value = data)
          .onFailure((e) => errorMsg.value = e.message);
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh scorecard data
  Future<void> refresh() => loadScorecard();

  // Getters for easy access
  int get offersRedeemed => scorecard.value?.offersRedeemed ?? 0;
  int get userScore => scorecard.value?.userScore ?? 0;
  int get avgMonthly => scorecard.value?.avgMonthly ?? 0;
  String get mostSnagged => scorecard.value?.mostSnagged ?? 'N/A';
  int get streakWeeks => scorecard.value?.streakWeeks ?? 0;
}

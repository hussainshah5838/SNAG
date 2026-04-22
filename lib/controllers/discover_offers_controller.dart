import 'package:get/get.dart';
import '../models/offer_model.dart';
import '../services/client_offers_service.dart';

/// Controller for discovering offers on map
class DiscoverOffersController extends GetxController {
  static DiscoverOffersController get instance => Get.find<DiscoverOffersController>();

  final _service = ClientOffersService.instance;

  final isLoading = false.obs;
  final errorMsg = ''.obs;
  final offers = <OfferModel>[].obs;
  
  // Filters
  final selectedCategory = Rxn<String>();
  final userLat = Rxn<double>();
  final userLng = Rxn<double>();
  final radiusKm = 10.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Don't load on init - wait for location or just load all
    loadOffersWithoutLocation();
  }

  /// Load all offers without location filter
  Future<void> loadOffersWithoutLocation() async {
    try {
      isLoading.value = true;
      errorMsg.value = '';

      final result = await _service.discoverOffers(
        category: selectedCategory.value,
      );

      result
          .onSuccess((data) {
        offers.value = data;
      })
          .onFailure((e) {
        errorMsg.value = e.message;
      });
    } finally {
      isLoading.value = false;
    }
  }

  /// Load offers with current filters
  Future<void> loadOffers() async {
    try {
      isLoading.value = true;
      errorMsg.value = '';

      final result = await _service.discoverOffers(
        lat: userLat.value,
        lng: userLng.value,
        radiusKm: radiusKm.value,
        category: selectedCategory.value,
      );

      result
          .onSuccess((data) {
        offers.value = data;
      })
          .onFailure((e) {
        errorMsg.value = e.message;
      });
    } finally {
      isLoading.value = false;
    }
  }

  /// Set category filter and reload
  void setCategory(String? category) {
    if (selectedCategory.value == category) {
      selectedCategory.value = null;
    } else {
      selectedCategory.value = category;
    }
    loadOffersWithoutLocation();
  }

  /// Set user location and reload
  void setLocation(double lat, double lng) {
    userLat.value = lat;
    userLng.value = lng;
    loadOffers();
  }

  /// Refresh offers
  Future<void> refresh() => loadOffersWithoutLocation();

  /// Group offers by merchant for map markers
  Map<String, List<OfferModel>> get offersByMerchant {
    final grouped = <String, List<OfferModel>>{};
    for (final offer in offers) {
      final merchantId = offer.merchant;
      if (!grouped.containsKey(merchantId)) {
        grouped[merchantId] = [];
      }
      grouped[merchantId]!.add(offer);
    }
    return grouped;
  }
}

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
    print('🚀 [DiscoverOffers] onInit called');
    // Don't load on init - wait for location or just load all
    loadOffersWithoutLocation();
  }

  /// Load all offers without location filter
  Future<void> loadOffersWithoutLocation() async {
    try {
      print('🔄 [DiscoverOffers] Loading ALL offers (no location filter)...');
      print('📋 [DiscoverOffers] Filters - category: ${selectedCategory.value}');
      
      isLoading.value = true;
      errorMsg.value = '';

      final result = await _service.discoverOffers(
        category: selectedCategory.value,
      );

      result
          .onSuccess((data) {
        print('✅ [DiscoverOffers] Loaded ${data.length} offers');
        offers.value = data;
      })
          .onFailure((e) {
        print('❌ [DiscoverOffers] Load failed: ${e.message}');
        errorMsg.value = e.message;
      });
    } finally {
      isLoading.value = false;
    }
  }

  /// Load offers with current filters
  Future<void> loadOffers() async {
    try {
      print('🔄 [DiscoverOffers] Loading offers...');
      print('📋 [DiscoverOffers] Filters - category: ${selectedCategory.value}, lat: ${userLat.value}, lng: ${userLng.value}');
      
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
        print('✅ [DiscoverOffers] Loaded ${data.length} offers');
        offers.value = data;
      })
          .onFailure((e) {
        print('❌ [DiscoverOffers] Load failed: ${e.message}');
        errorMsg.value = e.message;
      });
    } finally {
      isLoading.value = false;
    }
  }

  /// Set category filter and reload
  void setCategory(String? category) {
    print('🏷️ [DiscoverOffers] Setting category: $category');
    if (selectedCategory.value == category) {
      selectedCategory.value = null;
      print('🔄 [DiscoverOffers] Category unselected, showing all');
    } else {
      selectedCategory.value = category;
    }
    loadOffersWithoutLocation();
  }

  /// Set user location and reload
  void setLocation(double lat, double lng) {
    print('📍 [DiscoverOffers] Setting location: $lat, $lng');
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

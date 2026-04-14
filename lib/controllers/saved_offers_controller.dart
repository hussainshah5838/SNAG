import 'package:get/get.dart';
import '../models/offer_model.dart';
import '../services/client_offers_service.dart';

/// Controller for saved offers screen
class SavedOffersController extends GetxController {
  static SavedOffersController get instance => Get.find<SavedOffersController>();

  final _service = ClientOffersService.instance;

  final isLoading = false.obs;
  final errorMsg = ''.obs;
  final savedOffers = <OfferModel>[].obs;
  
  // Filters
  final selectedCategory = Rxn<String>();
  final searchKeyword = ''.obs;
  final selectedOfferType = Rxn<String>();
  final selectedBrand = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    print('🚀 [SavedOffersController] onInit called');
    loadSavedOffers();
  }

  /// Load saved offers with current filters
  Future<void> loadSavedOffers() async {
    try {
      print('🔄 [SavedOffers] Loading saved offers...');
      print('📋 [SavedOffers] Filters - category: ${selectedCategory.value}, keyword: ${searchKeyword.value}, type: ${selectedOfferType.value}');
      
      isLoading.value = true;
      errorMsg.value = '';

      final result = await _service.getSavedOffers(
        keyword: searchKeyword.value.isEmpty ? null : searchKeyword.value,
        offerType: selectedOfferType.value,
        category: selectedCategory.value,
        brand: selectedBrand.value,
      );

      result
          .onSuccess((data) {
        print('✅ [SavedOffers] Loaded ${data.length} saved offers');
        savedOffers.value = data;
      })
          .onFailure((e) {
        print('❌ [SavedOffers] Load failed: ${e.message}');
        errorMsg.value = e.message;
      });
    } finally {
      isLoading.value = false;
    }
  }

  /// Set category filter and reload
  void setCategory(String? category) {
    print('🏷️ [SavedOffers] Setting category: $category');
    // If same category is clicked, unselect it
    if (selectedCategory.value == category) {
      selectedCategory.value = null;
      print('🔄 [SavedOffers] Category unselected, showing all');
    } else {
      selectedCategory.value = category;
    }
    loadSavedOffers();
  }

  /// Set search keyword and reload
  void setSearchKeyword(String keyword) {
    print('🔍 [SavedOffers] Setting search keyword: $keyword');
    searchKeyword.value = keyword;
    loadSavedOffers();
  }

  /// Set offer type filter and reload
  void setOfferType(String? type) {
    print('📍 [SavedOffers] Setting offer type: $type');
    selectedOfferType.value = type;
    loadSavedOffers();
  }

  /// Set brand filter and reload
  void setBrand(String? brand) {
    print('🏪 [SavedOffers] Setting brand: $brand');
    selectedBrand.value = brand;
    loadSavedOffers();
  }

  /// Clear all filters
  void clearFilters() {
    print('🧹 [SavedOffers] Clearing all filters');
    selectedCategory.value = null;
    searchKeyword.value = '';
    selectedOfferType.value = null;
    selectedBrand.value = null;
    loadSavedOffers();
  }

  /// Unsave an offer
  Future<bool> unsaveOffer(String offerId) async {
    try {
      print('🗑️ [SavedOffers] Unsaving offer: $offerId');
      isLoading.value = true;

      final result = await _service.unsaveOffer(offerId);

      result
          .onSuccess((_) {
        print('✅ [SavedOffers] Offer unsaved successfully');
        // Remove from local list
        savedOffers.removeWhere((offer) => offer.id == offerId);
        Get.snackbar(
          'Success',
          'Offer removed from saved',
          snackPosition: SnackPosition.BOTTOM,
        );
      })
          .onFailure((e) {
        print('❌ [SavedOffers] Unsave failed: ${e.message}');
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

  /// Refresh saved offers
  Future<void> refresh() => loadSavedOffers();

  // Getters
  List<OfferModel> get filteredOffers => savedOffers;
  bool get hasFilters =>
      selectedCategory.value != null ||
      searchKeyword.value.isNotEmpty ||
      selectedOfferType.value != null ||
      selectedBrand.value != null;
}

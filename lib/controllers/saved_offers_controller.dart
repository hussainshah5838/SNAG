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
    loadSavedOffers();
  }

  /// Load saved offers with current filters
  Future<void> loadSavedOffers() async {
    try {
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
        savedOffers.value = data;
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
    // If same category is clicked, unselect it
    if (selectedCategory.value == category) {
      selectedCategory.value = null;
    } else {
      selectedCategory.value = category;
    }
    loadSavedOffers();
  }

  /// Set search keyword and reload
  void setSearchKeyword(String keyword) {
    searchKeyword.value = keyword;
    loadSavedOffers();
  }

  /// Set offer type filter and reload
  void setOfferType(String? type) {
    selectedOfferType.value = type;
    loadSavedOffers();
  }

  /// Set brand filter and reload
  void setBrand(String? brand) {
    selectedBrand.value = brand;
    loadSavedOffers();
  }

  /// Clear all filters
  void clearFilters() {
    selectedCategory.value = null;
    searchKeyword.value = '';
    selectedOfferType.value = null;
    selectedBrand.value = null;
    loadSavedOffers();
  }

  /// Unsave an offer
  Future<bool> unsaveOffer(String offerId) async {
    try {
      isLoading.value = true;

      final result = await _service.unsaveOffer(offerId);

      result
          .onSuccess((_) {
        // Remove from local list
        savedOffers.removeWhere((offer) => offer.id == offerId);
        Get.snackbar(
          'Success',
          'Offer removed from saved',
          snackPosition: SnackPosition.BOTTOM,
        );
      })
          .onFailure((e) {
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

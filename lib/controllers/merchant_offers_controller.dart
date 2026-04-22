import 'package:get/get.dart';

import '../services/merchant_offers_service.dart';

/// Merchant offers controller - manages dashboard stats and offer state
class MerchantOffersController extends GetxController {
  final _service = MerchantOffersService.instance;

  // ── Dashboard Stats ─────────────────────────────────────────────────────────
  final isLoadingStats = false.obs;
  
  // Offers section
  final activeOffers = 0.obs;
  final savedOffers = 0.obs;
  final expiredOffers = 0.obs;
  final draftedOffers = 0.obs;
  
  // Redemptions section
  final totalRedemptions = 0.obs;
  final redemptionsChange = 0.obs;
  
  // Impressions section
  final totalImpressions = 0.obs;
  final impressionsChange = 0.obs;
  
  // Locations section
  final totalBranches = 0.obs;
  final totalFeedback = 0.obs;
  
  final statsError = Rxn<String>();

  // ── Offers List ─────────────────────────────────────────────────────────────
  final isLoadingOffers = false.obs;
  final offers = <Map<String, dynamic>>[].obs;
  final offersError = Rxn<String>();

  // ── Single Offer ────────────────────────────────────────────────────────────
  final isLoadingOffer = false.obs;
  final currentOffer = Rxn<Map<String, dynamic>>();
  final offerError = Rxn<String>();

  /// Fetch dashboard stats from API
  Future<void> fetchDashboardStats() async {
    try {
      isLoadingStats.value = true;
      statsError.value = null;

      final result = await _service.getDashboardStats();

      result
          .onSuccess((data) {
            // Offers
            activeOffers.value = data['activeOffers'] as int? ?? 0;
            savedOffers.value = data['savedOffers'] as int? ?? 0;
            expiredOffers.value = data['expiredOffers'] as int? ?? 0;
            draftedOffers.value = data['draftedOffers'] as int? ?? 0;
            
            // Redemptions
            totalRedemptions.value = data['totalRedemptions'] as int? ?? 0;
            redemptionsChange.value = data['redemptionsChange'] as int? ?? 0;
            
            // Impressions
            totalImpressions.value = data['totalImpressions'] as int? ?? 0;
            impressionsChange.value = data['impressionsChange'] as int? ?? 0;
            
            // Locations
            totalBranches.value = data['totalBranches'] as int? ?? 0;
            totalFeedback.value = data['totalFeedback'] as int? ?? 0;
          })
          .onFailure((error) {
            statsError.value = error.message;
          });
    } finally {
      isLoadingStats.value = false;
    }
  }

  /// Fetch all offers with optional filters
  Future<void> fetchOffers({
    String? keyword,
    String? offerType,
    String? status,
    String? category,
    String? location,
    String? startDate,
    String? endDate,
  }) async {
    try {
      isLoadingOffers.value = true;
      offersError.value = null;

      final result = await _service.getOffers(
        keyword: keyword,
        offerType: offerType,
        status: status,
        category: category,
        location: location,
        startDate: startDate,
        endDate: endDate,
      );

      result
          .onSuccess((data) {
            offers.value = data;
          })
          .onFailure((error) {
            offersError.value = error.message;
          });
    } finally {
      isLoadingOffers.value = false;
    }
  }

  /// Fetch single offer by ID
  Future<void> fetchOfferById(String offerId) async {
    try {
      isLoadingOffer.value = true;
      offerError.value = null;

      final result = await _service.getOfferById(offerId);

      result
          .onSuccess((data) {
            currentOffer.value = data;
          })
          .onFailure((error) {
            offerError.value = error.message;
          });
    } finally {
      isLoadingOffer.value = false;
    }
  }

  /// Delete an offer
  Future<bool> deleteOffer(String offerId) async {
    try {
      final result = await _service.deleteOffer(offerId);
      
      bool success = false;
      result
          .onSuccess((message) {
            // Remove from local list
            offers.removeWhere((offer) => offer['_id'] == offerId);
            success = true;
          })
          .onFailure((error) {
            // Error deleting offer
          });
      
      return success;
    } catch (e) {
      return false;
    }
  }
}

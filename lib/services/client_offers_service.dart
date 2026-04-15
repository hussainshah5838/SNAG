import 'package:dio/dio.dart';
import '../core/errors/app_exception.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../core/utils/result.dart';
import '../models/offer_model.dart';

/// Client offers service - discover, save, snag, my offers
/// This layer only talks to the network — no state, no UI logic.
class ClientOffersService {
  ClientOffersService._();
  static final ClientOffersService instance = ClientOffersService._();

  final _client = ApiClient.instance;

  /// Helper to extract AppException from DioException
  static AppException _handleError(dynamic e) {
    if (e is DioException && e.error is AppException) {
      return e.error as AppException;
    }
    if (e is AppException) {
      return e;
    }
    return const NetworkException();
  }

  // ── Discover Offers ─────────────────────────────────────────────────────────

  /// Discover offers with filters (home map + search)
  Future<Result<List<OfferModel>>> discoverOffers({
    double? lat,
    double? lng,
    double? radiusKm,
    String? category,
    String? keyword,
    String? offerType,
    String? brand,
    String? startDate,
    String? endDate,
  }) async {
    try {
      print('🌐 [Service] Making API call to discover offers...');
      final queryParams = <String, dynamic>{};
      if (lat != null) queryParams['lat'] = lat;
      if (lng != null) queryParams['lng'] = lng;
      if (radiusKm != null) queryParams['radiusKm'] = radiusKm;
      if (category != null) queryParams['category'] = category;
      if (keyword != null) queryParams['keyword'] = keyword;
      if (offerType != null) queryParams['offerType'] = offerType;
      if (brand != null) queryParams['brand'] = brand;
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;

      final res = await _client.get(
        ApiEndpoints.clientOffers,
        query: queryParams,
      );

      print('✅ [Service] Got response: ${res.statusCode}');
      print('📦 [Service] Response data type: ${res.data.runtimeType}');
      print('📦 [Service] Response data: ${res.data}');

      final offers = (res.data['data'] as List<dynamic>)
          .map((json) => OfferModel.fromJson(json as Map<String, dynamic>))
          .toList();

      print('✅ [Service] Parsed ${offers.length} offers');
      return Result.success(offers);
    } catch (e, stackTrace) {
      print('❌ [Service] Error: $e');
      print('📍 [Service] Stack trace: $stackTrace');
      return Result.failure(_handleError(e));
    }
  }

  // ── Get Offer By ID ─────────────────────────────────────────────────────────

  Future<Result<OfferModel>> getOfferById(String offerId) async {
    try {
      final res = await _client.get(ApiEndpoints.clientOfferById(offerId));
      final offer = OfferModel.fromJson(res.data['data'] as Map<String, dynamic>);
      return Result.success(offer);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── Save / Unsave Offer ─────────────────────────────────────────────────────

  Future<Result<bool>> saveOffer(String offerId) async {
    try {
      await _client.post(ApiEndpoints.clientSaveOffer(offerId));
      return Result.success(true);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  Future<Result<bool>> unsaveOffer(String offerId) async {
    try {
      await _client.delete(ApiEndpoints.clientSaveOffer(offerId));
      return Result.success(false);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── Snag Offer ──────────────────────────────────────────────────────────────

  Future<Result<SnagOfferResponse>> snagOffer(String offerId) async {
    try {
      final res = await _client.post(ApiEndpoints.clientSnagOffer(offerId));
      final snag = SnagOfferResponse.fromJson(res.data['data'] as Map<String, dynamic>);
      return Result.success(snag);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── My Offers (Redemption History) ──────────────────────────────────────────

  Future<Result<List<RedemptionModel>>> getMyOffers({
    String? keyword,
    String? offerType,
    String? status,
    String? category,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (keyword != null) queryParams['keyword'] = keyword;
      if (offerType != null) queryParams['offerType'] = offerType;
      if (status != null) queryParams['status'] = status;
      if (category != null) queryParams['category'] = category;
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;

      final res = await _client.get(
        ApiEndpoints.clientMyOffers,
        query: queryParams,
      );

      final redemptions = (res.data['data'] as List<dynamic>)
          .map((json) => RedemptionModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Result.success(redemptions);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── Saved Offers ────────────────────────────────────────────────────────────

  Future<Result<List<OfferModel>>> getSavedOffers({
    String? keyword,
    String? offerType,
    String? category,
    String? brand,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (keyword != null) queryParams['keyword'] = keyword;
      if (offerType != null) queryParams['offerType'] = offerType;
      if (category != null) queryParams['category'] = category;
      if (brand != null) queryParams['brand'] = brand;

      final res = await _client.get(
        ApiEndpoints.clientSavedOffers,
        query: queryParams,
      );

      // Backend returns enriched offers directly (not SavedOffer documents)
      final offers = (res.data['data'] as List<dynamic>)
          .map((json) => OfferModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Result.success(offers);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }
}

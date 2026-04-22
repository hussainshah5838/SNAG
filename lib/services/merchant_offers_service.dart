import 'dart:io';
import 'package:dio/dio.dart';
import '../core/errors/app_exception.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../core/utils/result.dart';

/// Merchant offers service - CRUD operations for merchant offers
/// This layer only talks to the network — no state, no UI logic.
class MerchantOffersService {
  MerchantOffersService._();
  static final MerchantOffersService instance = MerchantOffersService._();

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

  // ── Get All Offers ──────────────────────────────────────────────────────────

  Future<Result<Map<String, dynamic>>> getDashboardStats() async {
    try {
      final res = await _client.get('/merchant/offers/dashboard-stats');
      return Result.success(res.data['data'] as Map<String, dynamic>);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  Future<Result<List<Map<String, dynamic>>>> getOffers({
    String? keyword,
    String? offerType,
    String? status,
    String? category,
    String? location,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (keyword != null) queryParams['keyword'] = keyword;
      if (offerType != null) queryParams['offerType'] = offerType;
      if (status != null) queryParams['status'] = status;
      if (category != null) queryParams['category'] = category;
      if (location != null) queryParams['location'] = location;
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;

      final res = await _client.get(
        '/merchant/offers',
        query: queryParams,
      );

      final offers = (res.data['data'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();

      return Result.success(offers);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── Get Merchant Locations ──────────────────────────────────────────────────

  Future<Result<List<Map<String, dynamic>>>> getMerchantLocations() async {
    try {
      final res = await _client.get('/merchant/offers/merchant-locations');
      final locations = (res.data['data'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      return Result.success(locations);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── Get Offer By ID ─────────────────────────────────────────────────────────

  Future<Result<Map<String, dynamic>>> getOfferById(String offerId) async {
    try {
      final res = await _client.get('/merchant/offers/$offerId');
      return Result.success(res.data['data'] as Map<String, dynamic>);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── Get Offer Stats ─────────────────────────────────────────────────────────

  Future<Result<Map<String, dynamic>>> getOfferStats(String offerId) async {
    try {
      final res = await _client.get(ApiEndpoints.merchantOfferStats(offerId));
      return Result.success(res.data['data'] as Map<String, dynamic>);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── Create Offer (Basic Info) ───────────────────────────────────────────────

  Future<Result<Map<String, dynamic>>> createOffer({
    required String title,
    required String description,
    required String offerType,
    required String termsAndConditions,
    required String startDate,
    required String endDate,
    List<String>? categories,
    String? status,
    int? redemptionLimit,
    File? bannerFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'description': description,
        'offerType': offerType,
        'termsAndConditions': termsAndConditions,
        'startDate': startDate,
        'endDate': endDate,
        if (status != null) 'status': status,
        if (redemptionLimit != null) 'redemptionLimit': redemptionLimit,
        if (bannerFile != null)
          'banner': await MultipartFile.fromFile(
            bannerFile.path,
            filename: bannerFile.path.split('/').last,
          ),
      });
      
      // Add categories as separate fields to ensure array format
      if (categories != null && categories.isNotEmpty) {
        for (var category in categories) {
          formData.fields.add(MapEntry('categories[]', category));
        }
      }

      final res = await _client.post('/merchant/offers', data: formData);
      return Result.success(res.data['data'] as Map<String, dynamic>);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── Update Scan Info ────────────────────────────────────────────────────────

  Future<Result<Map<String, dynamic>>> updateScanInfo({
    required String offerId,
    String? discountType,
    String? redemptionUrl,
    String? couponCode,
    int? redemptionLimit,
    File? qrCodeFile,
    File? barCodeFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        if (discountType != null) 'discountType': discountType,
        if (redemptionUrl != null) 'redemptionUrl': redemptionUrl,
        if (couponCode != null) 'couponCode': couponCode,
        if (redemptionLimit != null) 'redemptionLimit': redemptionLimit,
        if (qrCodeFile != null)
          'qrCode': await MultipartFile.fromFile(
            qrCodeFile.path,
            filename: qrCodeFile.path.split('/').last,
          ),
        if (barCodeFile != null)
          'barCode': await MultipartFile.fromFile(
            barCodeFile.path,
            filename: barCodeFile.path.split('/').last,
          ),
      });

      final res = await _client.patch('/merchant/offers/$offerId/scan', data: formData);
      return Result.success(res.data['data'] as Map<String, dynamic>);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── Update Location Info ────────────────────────────────────────────────────

  Future<Result<Map<String, dynamic>>> updateLocationInfo({
    required String offerId,
    required List<String> locationIds,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final res = await _client.patch(
        '/merchant/offers/$offerId/location',
        data: {
          'locationIds': locationIds,
          if (startDate != null) 'startDate': startDate,
          if (endDate != null) 'endDate': endDate,
        },
      );
      return Result.success(res.data['data'] as Map<String, dynamic>);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── Update Target Audience ──────────────────────────────────────────────────

  Future<Result<Map<String, dynamic>>> updateTargetAudience({
    required String offerId,
    List<String>? demographics,
    List<String>? interests,
    List<String>? behaviors,
    int? radiusKm,
  }) async {
    try {
      final res = await _client.patch(
        '/merchant/offers/$offerId/audience',
        data: {
          if (demographics != null) 'demographics': demographics,
          if (interests != null) 'interests': interests,
          if (behaviors != null) 'behaviors': behaviors,
          if (radiusKm != null) 'radiusKm': radiusKm,
        },
      );
      return Result.success(res.data['data'] as Map<String, dynamic>);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── Edit Offer ──────────────────────────────────────────────────────────────

  Future<Result<Map<String, dynamic>>> editOffer({
    required String offerId,
    String? title,
    String? description,
    String? offerType,
    String? status,
    List<String>? categories,
    String? termsAndConditions,
    String? startDate,
    String? endDate,
    int? redemptionLimit,
    List<String>? locationIds,
    List<String>? demographics,
    List<String>? interests,
    List<String>? behaviors,
    int? radiusKm,
    File? bannerFile,
    File? qrCodeFile,
    File? barCodeFile,
    String? discountType,
    String? redemptionUrl,
    String? couponCode,
  }) async {
    try {
      final formData = FormData.fromMap({
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (offerType != null) 'offerType': offerType,
        if (status != null) 'status': status,
        if (termsAndConditions != null) 'termsAndConditions': termsAndConditions,
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
        if (redemptionLimit != null) 'redemptionLimit': redemptionLimit,
        if (discountType != null) 'discountType': discountType,
        if (redemptionUrl != null) 'redemptionUrl': redemptionUrl,
        if (couponCode != null) 'couponCode': couponCode,
        if (bannerFile != null)
          'banner': await MultipartFile.fromFile(
            bannerFile.path,
            filename: bannerFile.path.split('/').last,
          ),
        if (qrCodeFile != null)
          'qrCode': await MultipartFile.fromFile(
            qrCodeFile.path,
            filename: qrCodeFile.path.split('/').last,
          ),
        if (barCodeFile != null)
          'barCode': await MultipartFile.fromFile(
            barCodeFile.path,
            filename: barCodeFile.path.split('/').last,
          ),
      });
      
      // Add array fields as separate entries to ensure array format
      if (categories != null) {
        for (var category in categories) {
          formData.fields.add(MapEntry('categories[]', category));
        }
      }
      
      if (locationIds != null) {
        for (var locationId in locationIds) {
          formData.fields.add(MapEntry('locationIds[]', locationId));
        }
      }
      
      if (demographics != null) {
        for (var demographic in demographics) {
          formData.fields.add(MapEntry('demographics[]', demographic));
        }
      }
      
      if (interests != null) {
        for (var interest in interests) {
          formData.fields.add(MapEntry('interests[]', interest));
        }
      }
      
      if (behaviors != null) {
        for (var behavior in behaviors) {
          formData.fields.add(MapEntry('behaviors[]', behavior));
        }
      }
      
      if (radiusKm != null) {
        formData.fields.add(MapEntry('radiusKm', radiusKm.toString()));
      }

      final res = await _client.patchFormData('/merchant/offers/$offerId', formData);
      return Result.success(res.data['data'] as Map<String, dynamic>);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── Delete Offer ────────────────────────────────────────────────────────────

  Future<Result<String>> deleteOffer(String offerId) async {
    try {
      final res = await _client.delete('/merchant/offers/$offerId');
      return Result.success(res.data['message'] as String? ?? 'Offer deleted');
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }
}

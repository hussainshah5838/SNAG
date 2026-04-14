import 'package:dio/dio.dart';
import '../core/errors/app_exception.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../core/utils/result.dart';

/// Merchant analytics service - get analytics data with filters
/// This layer only talks to the network — no state, no UI logic.
class MerchantAnalyticsService {
  MerchantAnalyticsService._();
  static final MerchantAnalyticsService instance = MerchantAnalyticsService._();

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

  // ── Get Home Stats ──────────────────────────────────────────────────────────

  /// Get home analytics with optional filters
  /// [offerType] - 'in-store' | 'online'
  /// [ageGroup] - age group filter
  /// [timeFilter] - 'today' | 'week' | 'month' | 'year' | 'custom'
  Future<Result<Map<String, dynamic>>> getHomeStats({
    String? offerType,
    String? ageGroup,
    String? timeFilter,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (offerType != null) queryParams['offerType'] = offerType;
      if (ageGroup != null) queryParams['ageGroup'] = ageGroup;
      if (timeFilter != null) queryParams['timeFilter'] = timeFilter;
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;

      final res = await _client.get(
        ApiEndpoints.merchantAnalyticsHome,
        query: queryParams,
      );

      return Result.success(res.data['data'] as Map<String, dynamic>);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── Get Summary Stats ───────────────────────────────────────────────────────

  /// Get summary analytics with optional filters.
  /// [locationId] — filter by a specific branch/location ID.
  ///
  /// TODO: locationType ('urban'|'suburban'|'rural') is validated by backend
  ///       but the Location model has no such field, so it does nothing yet.
  Future<Result<Map<String, dynamic>>> getSummaryStats({
    String? offerType,
    String? locationId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (offerType   != null) queryParams['offerType']   = offerType;
      if (locationId  != null) queryParams['locationId']  = locationId;
      if (startDate   != null) queryParams['startDate']   = startDate;
      if (endDate     != null) queryParams['endDate']      = endDate;

      final res = await _client.get(
        ApiEndpoints.merchantAnalyticsSummary,
        query: queryParams,
      );

      return Result.success(res.data['data'] as Map<String, dynamic>);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── Get Offers Analytics ────────────────────────────────────────────────────

  /// Get offers analytics with optional filters.
  /// [ageGroup]  — '18-24' | '25-34' | '35-44' | '45+'
  /// [offerType] — 'in-store' | 'online'
  /// [month]     — 1-12 (filter redemptions line chart by month)
  /// [offerId]   — filter performance section to a single offer
  ///
  /// TODO: industry filter (Retail/E-commerce/Food&Beverage/Travel) —
  ///       Offer/Location model has no industry field yet.
  /// TODO: locationType filter (Urban/Suburban/Rural) shown in UI —
  ///       Location model has no locationType field yet.
  /// TODO: userType filter (New/Returning) — User model has no
  ///       isNewUser flag; backend cannot distinguish new vs returning users.
  Future<Result<Map<String, dynamic>>> getOffersAnalytics({
    String? offerType,
    String? ageGroup,
    int?    month,
    String? offerId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (offerType != null) queryParams['offerType'] = offerType;
      if (ageGroup  != null) queryParams['ageGroup']  = ageGroup;
      if (month     != null) queryParams['month']      = month;
      if (offerId   != null) queryParams['offerId']    = offerId;
      if (startDate != null) queryParams['startDate']  = startDate;
      if (endDate   != null) queryParams['endDate']    = endDate;

      final res = await _client.get(
        ApiEndpoints.merchantAnalyticsOffers,
        query: queryParams,
      );

      return Result.success(res.data['data'] as Map<String, dynamic>);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  // ── Get Users Analytics ─────────────────────────────────────────────────────

  /// Get users analytics with optional filters.
  /// [ageGroup] — '18-24' | '25-34' | '35-44' | '45+'
  ///
  /// TODO: locationType filter (Urban/Suburban/Rural) shown in UI —
  ///       Location model has no locationType field yet.
  /// TODO: Age segmentation is derived from offer.targetAudience.demographics,
  ///       NOT from real user profiles (User model has no age/dateOfBirth field).
  /// TODO: Gender split in stacked chart is approximated (55%M / 45%F),
  ///       not from real user data (User model has no gender field).
  Future<Result<Map<String, dynamic>>> getUsersAnalytics({
    String? ageGroup,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (ageGroup  != null) queryParams['ageGroup']  = ageGroup;
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate   != null) queryParams['endDate']   = endDate;

      final res = await _client.get(
        ApiEndpoints.merchantAnalyticsUsers,
        query: queryParams,
      );

      return Result.success(res.data['data'] as Map<String, dynamic>);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }
}

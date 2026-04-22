import 'package:get/get.dart';
import '../services/merchant_analytics_service.dart';

/// Merchant analytics controller - manages state for all 3 analytics tabs.
class MerchantAnalyticsController extends GetxController {
  final _service = MerchantAnalyticsService.instance;

  // ── Loading / Error ─────────────────────────────────────────────────────────
  final isLoadingSummary      = false.obs;
  final isLoadingOffers       = false.obs;
  final isLoadingUsers        = false.obs;
  final summaryError          = Rxn<String>();
  final offersError           = Rxn<String>();
  final usersError            = Rxn<String>();

  // ── Summary Tab ─────────────────────────────────────────────────────────────
  // Pie chart
  final redemptionsByLocation = <Map<String, dynamic>>[].obs;
  final topBranchName         = ''.obs;
  final topBranchPercentage   = 0.obs;

  // Grid cards
  final activeOffers              = 0.obs;
  final savedOffers               = 0.obs;
  final expiredOffers             = 0.obs;
  final totalClicks               = 0.obs;
  final topBranch                 = ''.obs;
  final topBranchVsLastMonth      = 0.obs;
  final totalBranches             = 0.obs;
  final totalBranchesVsLastMonth  = 0.obs;

  // ── Offers Analytics Tab ────────────────────────────────────────────────────
  // Funnel stacked chart — each item: { x, y1, y2, y3, total }
  final funnelChart       = <Map<String, dynamic>>[].obs;
  final totalImpressions  = 0.obs;

  // Redemptions line chart — each item: { label, redemptions }
  final redemptionsByMonth        = <Map<String, dynamic>>[].obs;
  final currentMonthRedemptions   = 0.obs;
  final currentMonthLabel         = ''.obs;

  // Performance by segment — each item: { id, title, views, clicks, redemptions }
  final offerPerformance = <Map<String, dynamic>>[].obs;

  // ── Users Analytics Tab ─────────────────────────────────────────────────────
  // Stacked bar chart — each item: { x, y1, y2, y3 }
  // x values: 'M(18-24)', 'M(25-34)', 'M(35-44)', 'F(18-24)', 'F(25-34)', 'F(35-44)'
  final genderByAge = <Map<String, dynamic>>[].obs;

  // Pie chart — each item: { ageGroup, count, percentage }
  final ageSegmentation     = <Map<String, dynamic>>[].obs;
  final dominantAgeGroup    = ''.obs;
  final dominantPercentage  = 0.obs;

  // Grid cards
  final uniqueUsers               = 0.obs;
  final uniqueUsersVsLastMonth    = 0.obs;
  final repetitiveUsers           = 0.obs;
  final repetitiveUsersVsLastMonth = 0.obs;

  // ── Lifecycle ───────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchSummary();
    fetchOffersAnalytics();
    fetchUsersAnalytics();
  }

  // ── Fetch Summary ───────────────────────────────────────────────────────────

  /// Filters accepted by backend:
  ///   offerType: 'in-store' | 'online'
  ///   locationId: string  (specific branch ID)
  ///   startDate / endDate: ISO datetime strings
  ///
  /// TODO: locationType ('urban'|'suburban'|'rural') filter is in validation
  ///       but the Location model has no such field — backend will ignore it.
  Future<void> fetchSummary({String? locationId}) async {
    try {
      isLoadingSummary.value = true;
      summaryError.value     = null;

      final result = await _service.getSummaryStats(
        // TODO: wire up locationId from the Location dropdown once locations
        //       are loaded dynamically (currently hardcoded in UI)
      );

      result
        .onSuccess((data) {
          // Pie chart
          redemptionsByLocation.value =
              List<Map<String, dynamic>>.from(data['redemptionsByLocation'] ?? []);
          topBranchName.value       = data['topBranchName']       ?? '';
          topBranchPercentage.value = (data['topBranchPercentage'] ?? 0).toInt();

          // Grid cards
          activeOffers.value             = (data['activeOffers']             ?? 0).toInt();
          savedOffers.value              = (data['savedOffers']              ?? 0).toInt();
          expiredOffers.value            = (data['expiredOffers']            ?? 0).toInt();
          totalClicks.value              = (data['totalClicks']              ?? 0).toInt();
          topBranch.value                = data['topBranch']                 ?? '';
          topBranchVsLastMonth.value     = (data['topBranchVsLastMonth']     ?? 0).toInt();
          totalBranches.value            = (data['totalBranches']            ?? 0).toInt();
          totalBranchesVsLastMonth.value = (data['totalBranchesVsLastMonth'] ?? 0).toInt();
        })
        .onFailure((err) => summaryError.value = err.message);
    } finally {
      isLoadingSummary.value = false;
    }
  }

  // ── Fetch Offers Analytics ──────────────────────────────────────────────────

  /// Filters accepted by backend:
  ///   ageGroup: '18-24' | '25-34' | '35-44' | '45+'
  ///   offerType / userType / month / offerId
  ///
  /// TODO: 'Industry' filter (Retail, E-commerce, Food & Beverage, Travel) —
  ///       the Offer/Location model has no industry field yet.
  /// TODO: 'Location' type filter (Urban/Suburban/Rural) —
  ///       the Location model has no locationType field yet.
  /// TODO: 'Type' filter (New/Returning users) — User model has no
  ///       isNewUser flag; backend cannot distinguish new vs returning.
  Future<void> fetchOffersAnalytics({String? ageGroup, int? month}) async {
    try {
      isLoadingOffers.value = true;
      offersError.value     = null;

      final result = await _service.getOffersAnalytics(
        ageGroup:  ageGroup,
        // TODO: pass month filter once UI dropdown is connected
        // TODO: pass industry filter once backend model supports it
        // TODO: pass locationType filter once Location model has that field
      );

      result
        .onSuccess((data) {
          // Funnel stacked chart
          funnelChart.value      = List<Map<String, dynamic>>.from(data['funnelChart'] ?? []);
          totalImpressions.value = (data['totalImpressions'] ?? 0).toInt();

          // Line chart
          redemptionsByMonth.value      = List<Map<String, dynamic>>.from(data['redemptionsByMonth'] ?? []);
          currentMonthRedemptions.value = (data['currentMonthRedemptions'] ?? 0).toInt();
          currentMonthLabel.value       = data['currentMonthLabel'] ?? '';

          // Performance list
          offerPerformance.value = List<Map<String, dynamic>>.from(data['offerPerformance'] ?? []);
        })
        .onFailure((err) => offersError.value = err.message);
    } finally {
      isLoadingOffers.value = false;
    }
  }

  // ── Fetch Users Analytics ───────────────────────────────────────────────────

  /// Filters accepted by backend:
  ///   ageGroup: '18-24' | '25-34' | '35-44' | '45+'
  ///   locationType: 'urban' | 'suburban' | 'rural'
  ///
  /// TODO: 'Location' type filter (Urban/Suburban/Rural) shown in UI —
  ///       the Location model has no locationType field, so this does nothing yet.
  /// TODO: Age segmentation data comes from offer.targetAudience.demographics,
  ///       NOT from real user age data (User model has no age/dateOfBirth field).
  ///       Gender split is also approximated (55%M/45%F), not from real user data.
  Future<void> fetchUsersAnalytics() async {
    try {
      isLoadingUsers.value = true;
      usersError.value     = null;

      final result = await _service.getUsersAnalytics(
        // TODO: pass locationType filter once Location model has that field
      );

      result
        .onSuccess((data) {
          // Stacked bar chart
          genderByAge.value = List<Map<String, dynamic>>.from(data['genderByAge'] ?? []);

          // Pie chart
          ageSegmentation.value    = List<Map<String, dynamic>>.from(data['ageSegmentation'] ?? []);
          dominantAgeGroup.value   = data['dominantAgeGroup']   ?? '';
          dominantPercentage.value = (data['dominantPercentage'] ?? 0).toInt();

          // Grid cards
          uniqueUsers.value                = (data['uniqueUsers']                ?? 0).toInt();
          uniqueUsersVsLastMonth.value     = (data['uniqueUsersVsLastMonth']     ?? 0).toInt();
          repetitiveUsers.value            = (data['repetitiveUsers']            ?? 0).toInt();
          repetitiveUsersVsLastMonth.value = (data['repetitiveUsersVsLastMonth'] ?? 0).toInt();
        })
        .onFailure((err) => usersError.value = err.message);
    } finally {
      isLoadingUsers.value = false;
    }
  }
}

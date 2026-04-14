import '../../config/env.dart';

/// Single source of truth for every backend URL.
/// Never hardcode a path string anywhere else in the app.
///
/// React Native equivalent: your constants/api.ts or endpoints.ts file.
class ApiEndpoints {
  ApiEndpoints._(); // prevent instantiation

  // ── Base ────────────────────────────────────────────────────────────────────
  // Pulled from Env — set via --dart-define at build/run time.
  static String get baseUrl => Env.baseUrl;

  // ── Auth ────────────────────────────────────────────────────────────────────
  static const String merchantRegister    = '/auth/merchant/register';
  static const String merchantVerifyEmail = '/auth/merchant/verify-email';
  static const String merchantResendCode  = '/auth/merchant/resend-code';

  static const String clientRegister      = '/auth/client/register';
  static const String clientVerifyEmail   = '/auth/client/verify-email';
  static const String clientResendCode    = '/auth/client/resend-code';

  static const String login               = '/auth/login';
  static const String refreshToken        = '/auth/refresh-token';
  static const String logout              = '/auth/logout';
  static const String deleteAccount       = '/auth/account';
  static const String forgotPassword      = '/auth/forgot-password';
  static const String resetPassword       = '/auth/reset-password';
  static const String changePassword      = '/auth/change-password';

  // ── Merchant Onboarding ─────────────────────────────────────────────────────
  static const String merchantBranchProfile  = '/merchant/onboarding/branch-profile';
  static const String merchantLocations      = '/merchant/onboarding/locations';
  static String merchantLocationById(String id) => '/merchant/onboarding/locations/$id';
  static const String merchantBranchInfo     = '/merchant/onboarding/branch-info';
  static const String merchantBulkLocations  = '/merchant/onboarding/locations/bulk';
  static const String merchantMyLocation     = '/merchant/onboarding/my-location';
  static const String merchantComplete       = '/merchant/onboarding/complete';

  // ── Client Onboarding ───────────────────────────────────────────────────────
  static const String clientLocation         = '/client/onboarding/location';
  static const String clientInterests        = '/client/onboarding/interests';
  static const String clientAvatar           = '/client/onboarding/avatar';
  static const String clientComplete         = '/client/onboarding/complete';

  // ── Industries (public) ──────────────────────────────────────────────────────
  static const String industries             = '/industries';

  // ── Client Shipping Addresses ───────────────────────────────────────────────
  static const String shippingAddresses      = '/client/shipping-addresses';
  static String shippingAddressById(String id) => '/client/shipping-addresses/$id';
  static String setDefaultAddress(String id) => '/client/shipping-addresses/$id/set-default';

  // ── Client Preferences ──────────────────────────────────────────────────────
  static const String clientPreferences      = '/client/preferences';

  // ── Notifications ───────────────────────────────────────────────────────────
  static const String notifications          = '/notifications';
  static const String notificationsUnreadCount = '/notifications/unread-count';
  static String notificationMarkRead(String id) => '/notifications/$id/read';
  static String notificationMarkUnread(String id) => '/notifications/$id/unread';
  static const String notificationsMarkAllRead = '/notifications/mark-all-read';
  static String deleteNotification(String id) => '/notifications/$id';

  // ── Merchant Settings ───────────────────────────────────────────────────────
  static const String merchantSettingsNotifications = '/merchant/settings/notifications';

  // ── Merchant Offers Stats ───────────────────────────────────────────────────
  static String merchantOfferStats(String id) => '/merchant/offers/$id/stats';

  // ── Merchant Offers ─────────────────────────────────────────────────────────
  static const String merchantOffers           = '/merchant/offers';
  static const String merchantOfferLocations   = '/merchant/offers/merchant-locations';
  static String merchantOfferById(String id)   => '/merchant/offers/$id';
  static String merchantOfferScan(String id)   => '/merchant/offers/$id/scan';
  static String merchantOfferLocation(String id) => '/merchant/offers/$id/location';
  static String merchantOfferAudience(String id) => '/merchant/offers/$id/audience';

  // ── Merchant Analytics (with filters) ───────────────────────────────────────
  static const String merchantAnalyticsHome    = '/merchant/analytics/home';
  static const String merchantAnalyticsSummary = '/merchant/analytics/summary';
  static const String merchantAnalyticsOffers  = '/merchant/analytics/offers';
  static const String merchantAnalyticsUsers   = '/merchant/analytics/users';

  // ── Client Offers ───────────────────────────────────────────────────────────
  static const String clientOffers             = '/client/offers';
  static const String clientMyOffers           = '/client/offers/my-offers';
  static const String clientSavedOffers        = '/client/offers/saved';
  static String clientOfferById(String id)     => '/client/offers/$id';
  static String clientSaveOffer(String id)     => '/client/offers/$id/save';
  static String clientSnagOffer(String id)     => '/client/offers/$id/snag';

  // ── Client Profile ──────────────────────────────────────────────────────────
  static const String clientProfile            = '/client/profile';
  static const String clientProfileAvatar      = '/client/profile/avatar';

  // ── Client Feedback ─────────────────────────────────────────────────────────
  static const String clientFeedback           = '/client/feedback';

  // ── Client Scorecard ────────────────────────────────────────────────────────
  static const String clientScorecard          = '/client/scorecard';

  // ── Client Support ──────────────────────────────────────────────────────────
  static const String clientSupport            = '/client/support';
}

/// Single source of truth for app-wide constants.
/// Mirrors the backend's common/constants.ts.
///
/// If a role name changes on the backend, update it here —
/// everything else in the app picks it up automatically.

// ── User Roles ────────────────────────────────────────────────────────────────

class UserRoles {
  UserRoles._();

  static const String merchant = 'merchant';
  static const String client   = 'client';
}

// ── Client Interests ──────────────────────────────────────────────────────────
// Previously hardcoded here — now fetched from GET /industries at runtime.
// Use IndustryController.instance.industries to get the live list.
// This keeps merchant and client categories always in sync.

// ── Location Types ────────────────────────────────────────────────────────────

class LocationTypes {
  LocationTypes._();

  static const String main      = 'main';
  static const String franchise = 'franchise';
}

// ── Onboarding Steps ─────────────────────────────────────────────────────────

class MerchantOnboardingSteps {
  MerchantOnboardingSteps._();

  static const int registered    = 1;
  static const int emailVerified = 2;
  static const int branchProfile = 3;
  static const int locationAdded = 4;
  static const int branchInfo    = 5;
  static const int done          = 6;
}

class ClientOnboardingSteps {
  ClientOnboardingSteps._();

  static const int registered     = 1;
  static const int emailVerified  = 2;
  static const int locationSaved  = 3;
  static const int interestsSaved = 4;
  static const int avatarUploaded = 5;
  static const int done           = 6;
}

// ── Secure Storage Keys ───────────────────────────────────────────────────────

class StorageKeys {
  StorageKeys._();

  static const String accessToken  = 'access_token';
  static const String refreshToken = 'refresh_token';
}

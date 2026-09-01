/// Environment configuration.
///
/// The base URL is hardcoded here — one line to change when the backend moves.
/// Same approach as routeflex's dio_config.dart.
class Env {
  Env._();

  /// Backend base URL.
  static const String baseUrl = 'https://snag-backend-cesj.onrender.com/api/v1';

  /// Google Maps API key.
  /// Not read anywhere in Dart — the real keys live in the native configs:
  ///   iOS     → ios/Runner/Info.plist          (GMSApiKey)
  ///   Android → AndroidManifest.xml            (com.google.android.geo.API_KEY)
  static const String googleMapsApiKey = 'AIzaSyCyZpl3E54tU0Nq_feaRsLsEkdX1MhI7hU';

  /// Current environment name — useful for conditional logging etc.
  static const String environment = 'development';

  static bool get isDev  => environment == 'development';
  static bool get isProd => environment == 'production';
}

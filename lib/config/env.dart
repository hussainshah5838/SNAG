/// Environment configuration — Flutter equivalent of backend's config/index.ts.
///
/// Values are injected at build time via --dart-define flags.
/// Never hardcode URLs or secrets anywhere else in the app.
///
/// How to run:
///   Dev:   flutter run --dart-define=BASE_URL=http://10.0.2.2:3000/api/v1
///   Prod:  flutter run --dart-define=BASE_URL=https://api.snag.com/api/v1
///   With Google Maps: flutter run --dart-define=BASE_URL=http://192.168.2.108:3000/api/v1 --dart-define=GOOGLE_MAPS_API_KEY=your_key_here
///
/// In VS Code, add to .vscode/launch.json:
///   "args": [
///     "--dart-define=BASE_URL=http://192.168.2.108:3000/api/v1",
///     "--dart-define=GOOGLE_MAPS_API_KEY=AIzaSyCyZpl3E54tU0Nq_feaRsLsEkdX1MhI7hU"
///   ]

class Env {
  Env._();

  /// Backend base URL — injected at build time.
  /// Falls back to Android emulator localhost if not provided.
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://192.168.2.108:3000/api/v1',
  );

  /// Google Maps API Key — injected at build time.
  /// Required for Google Places autocomplete and maps features.
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: 'AIzaSyCyZpl3E54tU0Nq_feaRsLsEkdX1MhI7hU',
  );

  /// Current environment name — useful for conditional logging etc.
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  static bool get isDev  => environment == 'development';
  static bool get isProd => environment == 'production';
}

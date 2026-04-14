import 'package:get/get.dart';
import '../middleware/auth_middleware.dart';

/// App routes with role-based protection
/// 
/// Route naming convention:
/// - /login, /register - Guest routes
/// - /merchant/* - Merchant-only routes
/// - /client/* - Client-only routes
class AppRoutes {
  AppRoutes._();

  // ── Route Names ─────────────────────────────────────────────────────────────
  
  // Guest routes
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String chooseRole = '/choose-role';
  static const String merchantRegister = '/merchant/register';
  static const String clientRegister = '/client/register';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
} 
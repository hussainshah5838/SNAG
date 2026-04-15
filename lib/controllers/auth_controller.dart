import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../core/network/api_client.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/socket_service.dart';
import '../view/screens/auth/login.dart';
import '../view/screens/auth/sign_up/location_access.dart';
import '../view/screens/auth/sign_up/merchant_complete_profile/complete_profile.dart';
import '../view/screens/auth/sign_up/user_auth/discover_offers.dart';
import '../view/screens/auth/sign_up/user_auth/user_profile_image.dart';
import '../view/screens/bottom_nav_bar/merchant_nav_bar.dart';
import '../view/screens/bottom_nav_bar/user_nav_bar.dart';

/// Auth state + actions for the whole app with persistent storage.
///
/// Features:
/// - Role-based authentication (merchant/client)
/// - Secure token storage (access + refresh tokens)
/// - User data persistence
/// - Auto-login on app start
/// - Role-based navigation
///
/// React Native equivalent: AsyncStorage + AuthContext
class AuthController extends GetxController {
  // Singleton access from anywhere: AuthController.instance
  static AuthController get instance => Get.find<AuthController>();

  final _service = AuthService.instance;
  final _storage = const FlutterSecureStorage();

  // ── Storage Keys ────────────────────────────────────────────────────────────
  static const _userDataKey = 'user_data';
  static const _accessTokenKey = StorageKeys.accessToken;
  static const _refreshTokenKey = StorageKeys.refreshToken;

  // ── State ───────────────────────────────────────────────────────────────────
  final isLoading = false.obs;
  final errorMsg = ''.obs;
  final user = Rxn<UserModel>();

  // Holds email temporarily during OTP flow (register → verify)
  final pendingEmail = ''.obs;
  final pendingIsMerchant = false.obs;

  // ── Computed ────────────────────────────────────────────────────────────────
  bool get isLoggedIn => user.value != null;
  bool get isMerchant => user.value?.isMerchant ?? false;
  bool get isClient => user.value?.isClient ?? false;
  String? get userRole => user.value?.role;
  int get onboardingStep => user.value?.onboardingStep ?? 0;
  bool get isOnboardingComplete => 
      (isMerchant && onboardingStep >= MerchantOnboardingSteps.done) ||
      (isClient && onboardingStep >= ClientOnboardingSteps.done);

  // ── Lifecycle ───────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _initAuth();
  }

  /// Initialize auth state on app start
  /// Checks for stored tokens and user data, then syncs with backend
  Future<void> _initAuth() async {
    try {
      isLoading.value = true;
      
      // Try to load stored user data
      final userData = await _storage.read(key: _userDataKey);
      final accessToken = await _storage.read(key: _accessTokenKey);
      
      if (userData != null && accessToken != null) {
        // Restore user session from cache
        final userJson = jsonDecode(userData) as Map<String, dynamic>;
        user.value = UserModel.fromJson(userJson);
        
        // Fetch fresh user data from backend to sync onboarding step
        try {
          final result = await _service.getCurrentUser();
          
          result.onSuccess((freshUser) async {
            // Update if onboarding step changed
            if (freshUser.onboardingStep != user.value!.onboardingStep) {
              user.value = freshUser;
              
              // Update cache with fresh data
              await _storage.write(
                key: _userDataKey,
                value: jsonEncode(freshUser.toJson()),
              );
            }
          });
        } catch (e) {
          // Continue with cached data if sync fails
        }
      }
    } catch (e) {
      print('❌ Error restoring auth: $e');
      await _clearStoredAuth();
    } finally {
      isLoading.value = false;
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  void _clearError() => errorMsg.value = '';

  /// Wraps any async action: sets loading, clears error, catches failures
  Future<bool> _run(Future<void> Function() action) async {
    _clearError();
    isLoading.value = true;
    try {
      await action();
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Save user data and tokens to secure storage
  Future<void> _saveAuthData({
    required UserModel user,
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      // Save user data
      await _storage.write(
        key: _userDataKey,
        value: jsonEncode(user.toJson()),
      );
      
      // Save tokens (ApiClient also saves accessToken, but we save both here)
      await _storage.write(key: _accessTokenKey, value: accessToken);
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
      
      print('✅ Auth data saved to secure storage');
    } catch (e) {
      print('❌ Error saving auth data: $e');
    }
  }

  /// Clear all stored auth data
  Future<void> _clearStoredAuth() async {
    try {
      await _storage.delete(key: _userDataKey);
      await _storage.delete(key: _accessTokenKey);
      await _storage.delete(key: _refreshTokenKey);
      await ApiClient.clearToken();
      print('✅ Auth data cleared from secure storage');
    } catch (e) {
      print('❌ Error clearing auth data: $e');
    }
  }

  /// Navigate to appropriate screen based on user role and onboarding status
  void navigateAfterAuth() {
    if (user.value == null) return;

    final currentUser = user.value!;
    
    // Check onboarding status
    if (!isOnboardingComplete) {
      if (isMerchant) {
        _navigateToMerchantOnboarding(currentUser.onboardingStep);
      } else {
        _navigateToClientOnboarding(currentUser.onboardingStep);
      }
      return;
    }

    // Navigate to main app based on role
    if (isMerchant) {
      Get.offAll(() => MerchantNavBar());
    } else {
      Get.offAll(() => UserNavBar());
    }
  }

  void _navigateToMerchantOnboarding(int step) {
    // Import the screens at the top of the file
    switch (step) {
      case MerchantOnboardingSteps.emailVerified:
        Get.offAll(() => const CompleteProfile());
        break;
      case MerchantOnboardingSteps.branchProfile:
      case MerchantOnboardingSteps.locationAdded:
        // Continue from where they left off in CompleteProfile stepper
        Get.offAll(() => const CompleteProfile());
        break;
      default:
        Get.offAll(() => const CompleteProfile());
    }
  }

  void _navigateToClientOnboarding(int step) {
    // Import the screens at the top of the file
    switch (step) {
      case ClientOnboardingSteps.emailVerified:
        Get.offAll(() => const LocationAccess());
        break;
      case ClientOnboardingSteps.locationSaved:
        Get.offAll(() => const DiscoverOffers());
        break;
      case ClientOnboardingSteps.interestsSaved:
        Get.offAll(() => const UserProfileImage());
        break;
      default:
        Get.offAll(() => const LocationAccess());
    }
  }

  // ── Actions ─────────────────────────────────────────────────────────────────

  Future<bool> merchantRegister({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
  }) {
    return _run(() async {
      final result = await _service.merchantRegister(
        firstName:   firstName,
        lastName:    lastName,
        email:       email,
        phoneNumber: phoneNumber,
        password:    password,
      );

      result
          .onSuccess((_) {
        pendingEmail.value = email;
        pendingIsMerchant.value = true;
      })
          .onFailure((e) => errorMsg.value = e.message);

      if (result.isFailure) throw Exception();
    });
  }

  Future<bool> clientRegister({
    required String userName,
    required String phoneNumber,
    required String email,
    required String password,
  }) {
    return _run(() async {
      final result = await _service.clientRegister(
        userName: userName,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
      );

      result
          .onSuccess((_) {
        pendingEmail.value = email;
        pendingIsMerchant.value = false;
      })
          .onFailure((e) => errorMsg.value = e.message);

      if (result.isFailure) throw Exception();
    });
  }

  Future<bool> verifyEmail({required String code}) {
    return _run(() async {
      final result = await _service.verifyEmail(
        email: pendingEmail.value,
        code: code,
        isMerchant: pendingIsMerchant.value,
      );

      result
          .onSuccess((auth) async {
        user.value = auth.user;
        
        // Save auth data to secure storage
        await _saveAuthData(
          user: auth.user,
          accessToken: auth.accessToken,
          refreshToken: auth.refreshToken,
        );
        
        // Navigate based on role and onboarding status
        navigateAfterAuth();
      })
          .onFailure((e) => errorMsg.value = e.message);

      if (result.isFailure) throw Exception();
    });
  }

  Future<bool> resendCode() {
    return _run(() async {
      final result = await _service.resendCode(
        email: pendingEmail.value,
        isMerchant: pendingIsMerchant.value,
      );

      result.onFailure((e) => errorMsg.value = e.message);
      if (result.isFailure) throw Exception();
    });
  }

  Future<bool> login({
    required String email,
    required String password,
  }) {
    return _run(() async {
      final result = await _service.login(email: email, password: password);

      result
          .onSuccess((auth) async {
        user.value = auth.user;
        
        // Save auth data to secure storage
        await _saveAuthData(
          user: auth.user,
          accessToken: auth.accessToken,
          refreshToken: auth.refreshToken,
        );
        
        // Initialize Socket.IO connection for real-time notifications
        try {
          await SocketService.instance.connect();
          print('✅ Socket.IO initialized after login');
        } catch (e) {
          print('⚠️ Failed to initialize Socket.IO: $e');
          // Don't fail login if socket connection fails
        }
        
        // Navigate based on role and onboarding status
        navigateAfterAuth();
      })
          .onFailure((e) => errorMsg.value = e.message);

      if (result.isFailure) throw Exception();
    });
  }

  Future<bool> forgotPassword({required String email}) {
    return _run(() async {
      final result = await _service.forgotPassword(email: email);

      result
          .onSuccess((_) => pendingEmail.value = email)
          .onFailure((e) => errorMsg.value = e.message);

      if (result.isFailure) throw Exception();
    });
  }

  Future<bool> resetPassword({
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) {
    return _run(() async {
      final result = await _service.resetPassword(
        email: pendingEmail.value,
        code: code,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      result.onFailure((e) => errorMsg.value = e.message);
      if (result.isFailure) throw Exception();
    });
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    return _run(() async {
      final result = await _service.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      result.onFailure((e) => errorMsg.value = e.message);
      if (result.isFailure) throw Exception();
    });
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      
      // Read refresh token before clearing storage
      final refreshToken = await _storage.read(key: _refreshTokenKey);

      // Call backend logout endpoint so the refresh token is deleted from DB
      await _service.logout(refreshToken: refreshToken);
      
      // Disconnect Socket.IO
      try {
        SocketService.instance.disconnect();
        print('✅ Socket.IO disconnected on logout');
      } catch (e) {
        print('⚠️ Failed to disconnect Socket.IO: $e');
      }
      
      // Clear all stored data
      await _clearStoredAuth();
      
      // Clear user state
      user.value = null;
      pendingEmail.value = '';
      pendingIsMerchant.value = false;
      
      // Navigate to login
      Get.offAll(() => const Login());
      
      print('✅ Logged out successfully');
    } catch (e) {
      print('❌ Error during logout: $e');
      // Still clear local data even if backend call fails
      await _clearStoredAuth();
      user.value = null;
      Get.offAll(() => const Login());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      
      // Call backend delete account endpoint
      final result = await _service.deleteAccount();
      
      result
          .onSuccess((_) async {
        // Clear all stored data
        await _clearStoredAuth();
        
        // Clear user state
        user.value = null;
        pendingEmail.value = '';
        
        // Navigate to welcome/login
        Get.offAll(() => const Login());
        
        Get.snackbar(
          'Account Deleted',
          'Your account has been permanently deleted',
          snackPosition: SnackPosition.BOTTOM,
        );
      })
          .onFailure((e) {
        errorMsg.value = e.message;
        Get.snackbar(
          'Error',
          e.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    } finally {
      isLoading.value = false;
    }
  }

  /// Update user data in memory and storage (after onboarding steps)
  Future<void> updateUser(UserModel updatedUser) async {
    user.value = updatedUser;
    
    // Update stored user data
    await _storage.write(
      key: _userDataKey,
      value: jsonEncode(updatedUser.toJson()),
    );
  }

  /// Check if user has specific role
  bool hasRole(String role) => userRole == role;

  /// Check if user is authenticated and has completed onboarding
  bool get isFullyAuthenticated => isLoggedIn && isOnboardingComplete;
}

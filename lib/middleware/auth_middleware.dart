import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../controllers/auth_controller.dart';

/// Auth middleware for route protection
/// Checks if user is authenticated and has the required role
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    // If not logged in, redirect to login
    if (!authController.isLoggedIn) {
      return const RouteSettings(name: '/login');
    }

    return null;
  }
}

/// Middleware for merchant-only routes
class MerchantMiddleware extends GetMiddleware {
  @override
  int? get priority => 2;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    // Check if logged in
    if (!authController.isLoggedIn) {
      return const RouteSettings(name: '/login');
    }

    // Check if user is merchant
    if (!authController.isMerchant) {
      Get.snackbar(
        'Access Denied',
        'This area is for merchants only',
        snackPosition: SnackPosition.BOTTOM,
      );
      return const RouteSettings(name: '/client/home');
    }

    return null;
  }
}

/// Middleware for client-only routes
class ClientMiddleware extends GetMiddleware {
  @override
  int? get priority => 2;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    // Check if logged in
    if (!authController.isLoggedIn) {
      return const RouteSettings(name: '/login');
    }

    // Check if user is client
    if (!authController.isClient) {
      Get.snackbar(
        'Access Denied',
        'This area is for clients only',
        snackPosition: SnackPosition.BOTTOM,
      );
      return const RouteSettings(name: '/merchant/home');
    }

    return null;
  }
}

/// Middleware for onboarding completion check
class OnboardingMiddleware extends GetMiddleware {
  @override
  int? get priority => 3;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    // Check if logged in
    if (!authController.isLoggedIn) {
      return const RouteSettings(name: '/login');
    }

    // If onboarding not complete, redirect to appropriate onboarding screen
    if (!authController.isOnboardingComplete) {
      if (authController.isMerchant) {
        return const RouteSettings(name: '/merchant/onboarding/branch-profile');
      } else {
        return const RouteSettings(name: '/client/onboarding/location');
      }
    }

    return null;
  }
}

/// Middleware for guest-only routes (login, register)
/// Redirects to home if already logged in
class GuestMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    // If already logged in, redirect to appropriate home
    if (authController.isLoggedIn) {
      if (authController.isOnboardingComplete) {
        if (authController.isMerchant) {
          return const RouteSettings(name: '/merchant/home');
        } else {
          return const RouteSettings(name: '/client/home');
        }
      } else {
        // Redirect to onboarding
        if (authController.isMerchant) {
          return const RouteSettings(name: '/merchant/onboarding/branch-profile');
        } else {
          return const RouteSettings(name: '/client/onboarding/location');
        }
      }
    }

    return null;
  }
}

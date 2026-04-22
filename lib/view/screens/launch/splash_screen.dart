import 'dart:async';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/view/screens/auth/login.dart';
import 'package:snag/view/screens/launch/choose_user_type.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    splashScreenHandler();
  }

  void splashScreenHandler() async {
    // Wait for splash animation
    await Future.delayed(Duration(seconds: 3));

    final authController = AuthController.instance;

    // _initAuth() reads SecureStorage asynchronously — wait for it to finish
    // before checking isLoggedIn so we never send an authenticated user to Login.
    while (authController.isLoading.value) {
      await Future.delayed(Duration(milliseconds: 50));
    }

    if (authController.isLoggedIn) {
      authController.navigateAfterAuth();
    } else {
      Get.offAll(() => Login());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kSecondaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset(Assets.imagesLogo, height: 100)),
          SizedBox(height: 16),
          Center(child: Image.asset(Assets.imagesSnagIcon, height: 55)),
        ],
      ),
    );
  }
}

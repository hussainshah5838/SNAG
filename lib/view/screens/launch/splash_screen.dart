import 'dart:async';
import 'package:snag/constants/app_colors.dart';
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

  void splashScreenHandler() {
    Timer(Duration(seconds: 3), () => Get.offAll(() => Login()));
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

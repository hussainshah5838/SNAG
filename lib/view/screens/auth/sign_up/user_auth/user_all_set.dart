import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/client_onboarding_controller.dart';
import 'package:snag/view/screens/bottom_nav_bar/user_nav_bar.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class UserAllSet extends StatefulWidget {
  @override
  State<UserAllSet> createState() => UserAllSetState();
}

class UserAllSetState extends State<UserAllSet> {
  final _ctrl = ClientOnboardingController.instance;

  Future<void> _onGoHome() async {
    final success = await _ctrl.completeOnboarding();
    if (success) {
      Get.offAll(() => UserNavBar());
    } else {
      Get.snackbar('Error', _ctrl.errorMsg.value,
          backgroundColor: kRedColor, colorText: kPrimaryColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(Assets.imagesFreeChicken, height: 300),
                MyText(
                  textAlign: TextAlign.center,
                  text: "You're All Set!",
                  paddingTop: 40,
                  size: 28,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                MyText(
                  textAlign: TextAlign.center,
                  text: "Ready to snag the best offers! Explore offers, save favorites, and share with friends. Let's get your first snag!",
                  size: 16,
                  lineHeight: 1.5,
                  weight: FontWeight.w500,
                  color: kQuaternaryColor,
                ),
              ],
            ),
          ),
          Image.asset(
            Assets.imagesCelebration,
            height: Get.height,
            width: Get.width,
            fit: BoxFit.cover,
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: Obx(() => MyButton(
          buttonText: 'Go To Homepage',
          onTap: _ctrl.isLoading.value ? () {} : _onGoHome,
          customChild: _ctrl.isLoading.value
              ? SizedBox(
                  height: 22, width: 22,
                  child: CircularProgressIndicator(
                      color: kPrimaryColor, strokeWidth: 2.5),
                )
              : null,
        )),
      ),
    );
  }
}

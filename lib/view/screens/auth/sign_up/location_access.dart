import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/controller/user_controller.dart';
import 'package:snag/utils/global_instances.dart';
import 'package:snag/view/screens/auth/sign_up/user_auth/discover_offers.dart';
import 'package:snag/view/screens/auth/sign_up/merchant_complete_profile/complete_profile.dart';
import 'package:snag/view/screens/auth/sign_up/user_auth/u_more_info.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class LocationAccess extends StatelessWidget {
  const LocationAccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      appBar: simpleAppBar(leadingColor: kPrimaryColor),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [Image.asset(Assets.imagesLogo, height: 100)],
            ),
          ),
          Container(
            height: Get.height * 0.7,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                MyText(
                  text: 'Allow location access',
                  paddingTop: 8,
                  size: 24,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                MyText(
                  text:
                      UserController.instance.currentRole == UserRole.merchant
                          ? 'To help customers discover your offers, Snag needs permission to access your location while you use the app. We use your location to accurately tag your branches on the map, show your deals to customers nearby, and guide them with precise directions. Your location data is used only to improve the visibility of your business and is never sold to third parties. You can update your permission settings anytime in your device preferences.'
                          : 'Your location data is used to personalize your experience based on your selected interests and help you discover the best offers around you.\n\nYou have full control and can change your permission preferences anytime in your device settings.',
                  size: 16,
                  lineHeight: 1.5,
                  weight: FontWeight.w500,
                  color: kQuaternaryColor,
                  paddingBottom: 40,
                ),
                MyButton(
                  buttonText: 'Allow Location',
                  onTap: () {
                    chooseUserController.currentRole != UserRole.merchant
                        ? Get.to(() => UMoreInfo())
                        : Get.to(() => CompleteProfile());
                  },
                ),
                SizedBox(height: 12),
                MyButton(
                  bgColor: kQuinaryColor,
                  buttonText: 'Cancel',
                  onTap: () {
                    chooseUserController.currentRole != UserRole.merchant
                        ? Get.to(() => DiscoverOffers())
                        : Get.to(() => CompleteProfile());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/screens/bottom_nav_bar/merchant_nav_bar.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

class AllSet extends StatefulWidget {
  @override
  State<AllSet> createState() => AllSetState();
}

class AllSetState extends State<AllSet> {
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
                Image.asset(Assets.imagesAllSet, height: 300),
                MyText(
                  textAlign: TextAlign.center,
                  text: "You’re All Set!",
                  paddingTop: 40,
                  size: 28,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                MyText(
                  textAlign: TextAlign.center,
                  text:
                      "Ready to snag the best deals! Explore offers, save favorites, and share with friends. Let’s get your first snag!",
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
        child: MyButton(
          buttonText: 'Go To Homepage',
          onTap: () {
            Get.to(() => MerchantNavBar());
          },
        ),
      ),
    );
  }
}

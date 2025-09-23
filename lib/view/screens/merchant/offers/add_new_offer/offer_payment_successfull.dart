import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/screens/bottom_nav_bar/merchant_nav_bar.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

class OfferPaymentSuccessful extends StatefulWidget {
  @override
  State<OfferPaymentSuccessful> createState() => OfferPaymentSuccessfulState();
}

class OfferPaymentSuccessfulState extends State<OfferPaymentSuccessful> {
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
                  text: "Congratulations, Offer has been added!",
                  paddingTop: 40,
                  size: 28,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                MyText(
                  textAlign: TextAlign.center,
                  text:
                      "Your deal is live and ready to use. Enjoy your savings and don't forget to rate your experience!",
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

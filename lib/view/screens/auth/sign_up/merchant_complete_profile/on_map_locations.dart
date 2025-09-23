import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/main.dart';
import 'package:snag/view/screens/auth/sign_up/merchant_complete_profile/all_set.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class OnMapLocations extends StatelessWidget {
  const OnMapLocations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            Assets.imagesDummyMap,
            height: Get.height,
            width: Get.width,
            fit: BoxFit.cover,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              simpleAppBar(title: ''),
              Spacer(),
              Center(child: _Marker()),
              Spacer(),
              Padding(
                padding: AppSizes.DEFAULT,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(Assets.imagesCurrentLocation, height: 44),
                    SizedBox(height: 12),
                    Image.asset(Assets.imagesRecenter, height: 44),
                    SizedBox(height: 60),
                    MyButton(
                      buttonText: 'Next',
                      onTap: () {
                        Get.to(() => AllSet());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Marker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: kFillColor,
        border: Border.all(color: kBorderColor, width: 1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          CommonImageView(
            url: dummyImg,
            height: 32,
            width: 32,
            fit: BoxFit.cover,
            radius: 100,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: "KFC",
                  size: 12,
                  weight: FontWeight.w600,
                  paddingBottom: 2,
                ),
                MyText(text: "1 Deals", size: 10, color: kQuaternaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

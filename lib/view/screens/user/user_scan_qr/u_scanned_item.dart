import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/screens/user/user_scan_qr/u_payment_method.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UScannedItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: '',
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {},
              child: Image.asset(Assets.imagesMore, height: 24),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          Row(
            spacing: 12,
            children: [
              Image.asset(Assets.imagesKfc, height: 40),
              Expanded(
                child: MyText(
                  text: '“Save 15”',
                  size: 28,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
          MyText(
            paddingTop: 30,
            text: '“XYZ123”',
            size: 28,
            weight: FontWeight.w600,
            color: kSecondaryColor,
            paddingBottom: 30,
          ),
          Center(child: Image.asset(Assets.imagesQr, height: 200)),
          SizedBox(height: 28),
          Center(child: Image.asset(Assets.imagesBarCode, height: 118)),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: MyButton(
          buttonText: 'Next',
          onTap: () {
            Get.to(() => UPaymentMethod());
          },
        ),
      ),
    );
  }
}

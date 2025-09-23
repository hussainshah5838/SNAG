import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/screens/merchant/offers/add_new_offer/offer_payment_verification.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OfferPaymentMethod extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: ''),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          MyText(
            text: "Payment Methods",
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text: "Choose from available payment methods.",
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          ...List.generate(4, (index) {
            final List<Map<String, String>> details = [
              {'icon': Assets.imagesPaypal, 'value': 'Paypal'},
              {'icon': Assets.imagesApplePay, 'value': 'ApplePay'},
              {'icon': Assets.imagesGPay, 'value': 'G-Pay'},
              {'icon': Assets.imagesCreditCard, 'value': 'Credit Card'},
            ];
            return GestureDetector(
              onTap: () {
                Get.to(() => OfferPaymentVerification());
              },
              child: Container(
                height: 48,
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: kFillColor,
                  border: Border.all(color: kBorderColor, width: 1),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Image.asset(details[index]['icon']!, height: 24),
                    Expanded(
                      child: MyText(
                        paddingLeft: 10,
                        text: details[index]['value']!,
                        size: 16,
                        weight: FontWeight.w500,
                      ),
                    ),
                    Image.asset(Assets.imagesArrowNext, height: 20),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

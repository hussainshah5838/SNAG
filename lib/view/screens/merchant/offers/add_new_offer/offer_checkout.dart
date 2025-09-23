import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/screens/merchant/offers/add_new_offer/offer_payment_method.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OfferCheckOut extends StatelessWidget {
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
            text: "Checkout",
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text:
                "See the details carefully and move towards the payment screen",
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          ...List.generate(5, (index) {
            final List<Map<String, String>> details = [
              {
                'icon': Assets.imagesTtRounded,
                'value': 'Weekend Flash Deal — 15% Off',
              },
              {'icon': Assets.imagesTagRounded, 'value': 'Food & Drinks'},
              {
                'icon': Assets.imagesLocationType,
                'value': 'Dha6 Outlet, Gulberg, Downtown Outlet',
              },
              {
                'icon': Assets.imagesTime,
                'value': '9 August, 2025 - 21 August, 2025',
              },
              {'icon': Assets.imagesDollar, 'value': 'Offer Add Fee: \$36'},
            ];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(details[index]['icon']!, height: 28),
                  Expanded(
                    child: MyText(
                      paddingLeft: 10,
                      text: details[index]['value']!,
                      size: 16,
                      weight: FontWeight.w500,
                      paddingRight: 10,
                    ),
                  ),
                  if (index == 2)
                    Image.asset(Assets.imagesDirections, height: 24),
                ],
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: MyButton(
          buttonText: 'Next',
          onTap: () {
            Get.to(() => OfferPaymentMethod());
          },
        ),
      ),
    );
  }
}

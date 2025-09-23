import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BillingDetails extends StatefulWidget {
  @override
  State<BillingDetails> createState() => _BillingDetailsState();
}

class _BillingDetailsState extends State<BillingDetails> {
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
            text: "Billing Details",
            size: 22,
            weight: FontWeight.w700,
            paddingBottom: 4,
          ),
          MyText(
            text: "Monitor payouts, view earnings, and update payment details.",
            size: 15,
            color: kQuaternaryColor,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            paddingBottom: 30,
          ),

          ...List.generate(4, (index) {
            final List<Map<String, String>> details = [
              {'icon': Assets.imagesDollar, 'value': '\$1,250.00'},
              {'icon': Assets.imagesBank, 'value': 'Bank — HBL, ****5678'},
              {'icon': Assets.imagesTime, 'value': '9 August, 2025, 2:30 PM'},
              {'icon': Assets.imagesTenplus, 'value': '#SNAG-45210'},
            ];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Image.asset(details[index]['icon']!, height: 28),
                  Expanded(
                    child: MyText(
                      paddingLeft: 10,
                      text: details[index]['value']!,
                      size: 16,
                      weight: FontWeight.w500,
                    ),
                  ),
                  if (index == 0)
                    MyText(
                      text: "Paid",
                      size: 16,
                      weight: FontWeight.w600,
                      color: kGreenColor,
                    ),
                ],
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: MyButton(onTap: () {}, buttonText: 'Download CSV'),
      ),
    );
  }
}

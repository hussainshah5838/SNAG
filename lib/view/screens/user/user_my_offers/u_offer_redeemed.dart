import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_fonts.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UOfferRedeemed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: '',
        actions: [
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            constraints: BoxConstraints(minWidth: 48, maxWidth: 160),
            padding: EdgeInsets.zero,
            offset: Offset(0, 30),
            icon: Center(
              child: GestureDetector(
                onTap: () {},
                child: Image.asset(Assets.imagesMore, height: 28),
              ),
            ),
            onSelected: (value) {},
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    height: 30,
                    value: 'Save',
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontFamily: AppFonts.WORK_SANS,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    height: 30,
                    value: 'Share',
                    child: Text(
                      'Share',
                      style: TextStyle(
                        fontFamily: AppFonts.WORK_SANS,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    height: 30,
                    value: 'Send To Friends',
                    child: Text(
                      'Send To Friends',
                      style: TextStyle(
                        fontFamily: AppFonts.WORK_SANS,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
          ),

          SizedBox(width: 5),
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
                  text: 'Offer Redeemed',
                  size: 28,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
          MyText(
            paddingTop: 10,
            text: 'Show this screen to the merchant to redeem your offer.',
            size: 16,
            lineHeight: 1.5,
            color: kTertiaryColor,
            paddingBottom: 20,
          ),
          MyText(
            text: '“XYZ123”',
            size: 28,
            weight: FontWeight.w600,
            color: kSecondaryColor,
            paddingBottom: 30,
          ),
          Center(child: Image.asset(Assets.imagesQr, height: 200)),
          SizedBox(height: 28),
          Center(child: Image.asset(Assets.imagesBarCode, height: 118)),
          SizedBox(height: 20),
          ...List.generate(3, (index) {
            final List<Map<String, String>> details = [
              {
                'icon': Assets.imagesBank,
                'value':
                    'XYS Street,  123 lane, 34660, San Francisco Bay Area.',
              },
              {
                'icon': Assets.imagesTime,
                'value': '9 August, 2025 - 21 August, 2025',
              },
              {'icon': Assets.imagesLocationType, 'value': 'In-Store Offer'},
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
                  if (index == 0)
                    Image.asset(Assets.imagesDirections, height: 24),
                ],
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: MyButton(buttonText: 'Done', onTap: () {}),
      ),
    );
  }
}

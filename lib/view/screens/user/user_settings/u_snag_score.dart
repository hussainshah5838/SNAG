import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class USnagScore extends StatefulWidget {
  @override
  State<USnagScore> createState() => _USnagScoreState();
}

class _USnagScoreState extends State<USnagScore> {
  double _value = 100;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          MyText(
            text: 'Preferences',
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text:
                'Choose interests to find the best deals for you, from food to beauty.',
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: kFillColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kBorderColor, width: 1.0),
            ),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 2,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(text: 'Streak Goal:', size: 10),
                    MyText(
                      text: '3/4 Weeks',
                      size: 10,
                      weight: FontWeight.w700,
                    ),
                  ],
                ),
                Expanded(
                  child: FlutterSlider(
                    min: 0,
                    max: 100,
                    tooltip: FlutterSliderTooltip(disabled: true),
                    handler: FlutterSliderHandler(
                      decoration: BoxDecoration(),
                      child: Image.asset(Assets.imagesSliderThumb, height: 16),
                    ),
                    trackBar: FlutterSliderTrackBar(
                      activeTrackBarHeight: 8,
                      inactiveTrackBarHeight: 8,
                      activeTrackBar: BoxDecoration(
                        color: kLightBlueColor3,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      inactiveTrackBar: BoxDecoration(
                        color: kLightBlueColor4,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),

                    onDragging: (handlerIndex, lowerValue, upperValue) {
                      // setState(() {
                      //   _value = lowerValue;
                      // });
                    },
                    values: [_value],
                  ),
                ),
                Image.asset(Assets.imagesSnagGift, height: 22),
              ],
            ),
          ),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            padding: AppSizes.ZERO,
            physics: BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 120,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              final offers = [
                {
                  'icon': Assets.imagesOffersRedeem,
                  'title': 'Offers Redeemed',
                  'subtitle': '24',
                },
                {
                  'icon': Assets.imagesUserScore,
                  'title': 'User Score',
                  'subtitle': '4.6 Stars',
                },
                {
                  'icon': Assets.imagesAvgMonthly,
                  'title': 'Avg. Monthly',
                  'subtitle': '6',
                },
                {
                  'icon': Assets.imagesMostSnaged,
                  'title': 'Most Snagged',
                  'subtitle': 'KFC',
                },
              ];
              final offer = offers[index];
              return _ScoreCard(
                icon: offer['icon']!,
                title: offer['title']!,
                subTitle: '${offer['subtitle']}',
                onTap: () {},
                isSelected: false,
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: MyButton(
          buttonText: 'Done',
          onTap: () {
            Get.back();
          },
        ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subTitle;
  final VoidCallback onTap;
  final bool isSelected;

  const _ScoreCard({
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? kLightBlueColor : kFillColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? kSecondaryColor : kBorderColor,
            width: 1.0,
          ),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [Image.asset(icon, height: 28)]),
            MyText(
              paddingTop: 10,
              text: title,
              size: 14,
              color: kTertiaryColor,
              weight: FontWeight.w500,
            ),
            MyText(text: subTitle, size: 24, weight: FontWeight.w600),
          ],
        ),
      ),
    );
  }
}

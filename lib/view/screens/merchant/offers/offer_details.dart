import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_fonts.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/screens/merchant/offers/edit_offer.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OfferDetails extends StatefulWidget {
  @override
  State<OfferDetails> createState() => _OfferDetailsState();
}

class _OfferDetailsState extends State<OfferDetails> {
  int? selectedLabelIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> labels = ["Basic Info", "Redemptions", "Stats"];
    return Scaffold(
      appBar: simpleAppBar(
        title: '',
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {
                Get.to(() => EditOffer());
              },
              child: Image.asset(Assets.imagesEditIcon, height: 20),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          MyText(
            text: "Weekend Flash Deal — 15% Off",
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text:
                "Get 15% off your total bill this weekend only. Valid on all items, dine-in or takeaway. Not valid with other offers.",
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          SizedBox(
            height: 35,
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(width: 10);
              },
              padding: AppSizes.ZERO,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: labels.length,
              itemBuilder: (context, index) {
                final isSelected = selectedLabelIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedLabelIndex = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? kSecondaryColor : kLightBlueColor2,
                      border: Border.all(color: kBlueBorderColor),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: MyText(
                        text: labels[index],
                        size: 13,
                        weight: FontWeight.w500,
                        color: isSelected ? kPrimaryColor : kSecondaryColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          selectedLabelIndex == 0
              ? _basicInfo()
              : selectedLabelIndex == 1
              ? _redemption()
              : _stats(),
        ],
      ),
    );
  }

  Column _basicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 30),
        Center(
          child: CommonImageView(
            height: 250,
            width: 250,
            radius: 100,
            fit: BoxFit.cover,
            imagePath: Assets.imagesKfc,
          ),
        ),
        SizedBox(height: 20),
        ...List.generate(4, (index) {
          final List<Map<String, String>> details = [
            {
              'icon': Assets.imagesBank,
              'value': 'XYS Street,  123 lane, 34660, San Francisco Bay Area.',
            },
            {'icon': Assets.imagesDt, 'value': 'In-Store'},
            {
              'icon': Assets.imagesTime,
              'value': '9 August, 2025 - 21 August, 2025',
            },
            {'icon': Assets.imagesLocationType, 'value': 'Main Branch'},
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
    );
  }

  Column _redemption() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 30),
        Row(
          children: [
            MyText(
              text: 'Coupon Code: ',
              size: 16,
              weight: FontWeight.w500,
              color: Colors.black,
              paddingBottom: 30,
            ),
            MyText(
              text: '“XYZ123”',
              size: 24,
              weight: FontWeight.w600,
              color: Colors.black,
              paddingBottom: 30,
            ),
          ],
        ),
        Center(
          child: Image.asset(Assets.imagesQr, height: 180, color: Colors.black),
        ),
        SizedBox(height: 28),
        Center(
          child: Image.asset(
            Assets.imagesBarCode,
            height: 90,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Column _stats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 30),
        GridView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: AppSizes.ZERO,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 122,
          ),
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            final List<Map<String, dynamic>> stats = [
              {
                'icon': Assets.imagesViews,
                'percent': '32%',
                'percentColor': kGreenColor,
                'percentText': ' vs Last Month',
                'label': 'Views',
                'value': '150',
              },
              {
                'icon': Assets.imagesCtr,
                'percent': '40%',
                'percentColor': kGreenColor,
                'percentText': ' vs Last Month',
                'label': 'Clicks',
                'value': '40',
              },
              {
                'icon': Assets.imagesRedemptions,
                'percent': '20%',
                'percentColor': kGreenColor,
                'percentText': ' vs Last Month',
                'label': 'Redemptions',
                'value': '40',
              },
              {
                'icon': Assets.imagesTopBranch,
                'percent': '',
                'percentColor': kTertiaryColor,
                'percentText': '',
                'label': 'Top Branch',
                'value': 'Dha 6',
              },
            ];
            final stat = stats[index];
            return Container(
              decoration: BoxDecoration(
                color: kFillColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kBorderColor, width: 1.0),
              ),
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Image.asset(stat['icon'], height: 24, width: 24),
                      Expanded(
                        child: RichText(
                          textAlign: TextAlign.end,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: stat['percent'],
                                style: TextStyle(
                                  fontFamily: AppFonts.WORK_SANS,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: stat['percentColor'],
                                ),
                              ),
                              TextSpan(
                                text: stat['percentText'],
                                style: TextStyle(
                                  color: kTertiaryColor,
                                  fontFamily: AppFonts.WORK_SANS,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  MyText(
                    text: stat['label'],
                    size: 14,
                    weight: FontWeight.w500,
                    paddingBottom: 6,
                  ),
                  MyText(
                    text: stat['value'],
                    size: 24,
                    fontFamily: GoogleFonts.dmSans().fontFamily,
                    weight: FontWeight.w700,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

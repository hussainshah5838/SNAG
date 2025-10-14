import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_fonts.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/screens/user/user_my_offers/u_snag_it.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class USeeOfferDetails extends StatefulWidget {
  @override
  State<USeeOfferDetails> createState() => _USeeOfferDetailsState();
}

class _USeeOfferDetailsState extends State<USeeOfferDetails> {
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
          _basicInfo(),
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

  Column _snagIt() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
            margin: AppSizes.DEFAULT,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kFillColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: kBorderColor, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(Assets.imagesSnagIt, height: 48),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, right: 4),
                        child: Image.asset(Assets.imagesCloseIcon, height: 14),
                      ),
                    ),
                  ],
                ),
                MyText(
                  paddingTop: 16,
                  text: 'Snag this offer?',
                  size: 20,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                MyText(
                  text:
                      'Snagging this deal will lock it for use. Some offers can only be used once and may expire shortly after redemption. Make sure you’re ready to show this at the counter.',
                  size: 15,
                  lineHeight: 1.5,
                  weight: FontWeight.w500,
                  color: kQuaternaryColor,
                  paddingBottom: 24,
                ),
                MyButton(
                  height: 42,
                  buttonText: 'Confirm',
                  onTap: () {
                    Get.back();
                    // Get.to(() => USnagIt());
                  },
                ),
                SizedBox(height: 12),
                MyBorderButton(
                  borderColor: kGreyColor2,
                  height: 42,
                  buttonText: 'Cancel',
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

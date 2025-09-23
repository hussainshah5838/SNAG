import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/main.dart';
import 'package:snag/view/screens/merchant/settings/locations/edit_business_location.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LocationDetails extends StatefulWidget {
  @override
  State<LocationDetails> createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: '',
        actions: [
          Center(
            child: MyText(
              onTap: () {
                Get.to(() => EditBusinessLocation());
              },
              text: 'Edit',
              size: 16,
              weight: FontWeight.w600,
              paddingRight: 20,
              color: kQuaternaryColor,
            ),
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          MyText(
            text: "Downtown Outlet",
            paddingTop: 8,
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text: "23 Main Street, Downtown, Lahore, PK",
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          CommonImageView(
            height: 366,
            width: Get.width,
            radius: 12,
            fit: BoxFit.cover,
            url: dummyImg,
          ),
          SizedBox(height: 20),
          ...List.generate(3, (index) {
            final List<Map<String, String>> details = [
              {'icon': Assets.imagesContactNumber, 'value': '+923354288886'},
              {
                'icon': Assets.imagesTime,
                'value': 'Mon–Sun: 9:00 AM – 10:00 PM',
              },
              {'icon': Assets.imagesLocationType, 'value': 'Franchise'},
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
                      text: "5 Live Deals",
                      size: 16,
                      weight: FontWeight.w600,
                      color: kSecondaryColor,
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

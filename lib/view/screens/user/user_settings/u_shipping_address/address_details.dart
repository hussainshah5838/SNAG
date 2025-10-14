import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/main.dart';
import 'package:snag/view/screens/merchant/settings/locations/edit_business_location.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddressDetails extends StatefulWidget {
  @override
  State<AddressDetails> createState() => _AddressDetailsState();
}

class _AddressDetailsState extends State<AddressDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: '',
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {
                Get.dialog(_deleteBranch());
              },
              child: Image.asset(Assets.imagesTrash, height: 20),
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
            text: "Shipping Address",
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
          ...List.generate(2, (index) {
            final List<Map<String, String>> details = [
              {
                'icon': Assets.imagesContactNumber,
                'value': 'John Doe, john.doe@email.com, +1 234 567 8901',
              },
              {
                'icon': Assets.imagesLocationType,
                'value': 'Home Address, 45 Dummy Road, Test City, PK',
              },
            ];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(details[index]['icon']!, height: 28),
                  Expanded(
                    child: MyText(
                      paddingLeft: 16,
                      text: details[index]['value']!,
                      size: 16,
                      weight: FontWeight.w500,
                    ),
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

Column _deleteBranch() {
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
                  Image.asset(Assets.imagesDeleteProfile, height: 48),
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
                text: 'Delete Address?',
                size: 20,
                weight: FontWeight.w600,
                paddingBottom: 8,
              ),
              MyText(
                text:
                    'Are you sure you want to remove this address? Any active discounts linked to this address may stop working for customers.',
                size: 15,
                lineHeight: 1.5,
                weight: FontWeight.w500,
                color: kQuaternaryColor,
                paddingBottom: 24,
              ),

              MyButton(
                height: 42,
                buttonText: 'Delete',
                onTap: () {
                  Get.back();
                  // Add your logout logic here
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

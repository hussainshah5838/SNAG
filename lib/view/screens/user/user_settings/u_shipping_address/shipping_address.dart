import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/main.dart';
import 'package:snag/view/screens/merchant/settings/locations/add_new_business_location.dart';
import 'package:snag/view/screens/merchant/settings/locations/business_location_details.dart';
import 'package:snag/view/screens/user/user_settings/u_shipping_address/add_new_address.dart';
import 'package:snag/view/screens/user/user_settings/u_shipping_address/address_details.dart';
import 'package:snag/view/screens/user/user_settings/u_shipping_address/address_contact_info.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ShippingAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: '',
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {
                Get.to(() => AddNewAddress());
              },
              child: Image.asset(Assets.imagesAddIcon, height: 32),
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
            text: "Shipping Addresses",
            paddingTop: 8,
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text: 'Add, edit, and manage all your addresses.',
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          ListView.builder(
            padding: AppSizes.ZERO,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, i) {
              final List<Map<String, String>> users = [
                {
                  "name": "Harvest Haven Store",
                  "distance": "Street 123, Riverside Plaza, California",
                },
                {
                  "name": "Urban Roots Market Store",
                  "distance": "Street 3A3, Sunnyvale Park, California",
                },
                {
                  "name": "Fresh Finds Store",
                  "distance": "Street 3C, Cedar Hill Station, NYC",
                },
                {
                  "name": "Nature's Market Store",
                  "distance": "Street 1Z, Maplewood Avenue, Florida",
                },
              ];
              return GestureDetector(
                onTap: () {
                  Get.to(() => AddressDetails());
                },
                child: _LocationTile(user: users[i], isSelected: false),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  const _LocationTile({required this.user, required this.isSelected});

  final Map<String, String> user;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected ? kLightBlueColor : kFillColor,
        border: Border.all(
          color: isSelected ? kSecondaryColor : kBorderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          CommonImageView(
            url: dummyImg,
            height: 38,
            width: 38,
            fit: BoxFit.cover,
            radius: 100,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: user["name"] as String,
                  size: 15,
                  weight: FontWeight.w600,
                  paddingBottom: 4,
                ),
                MyText(
                  text: '${user["distance"]}',
                  size: 12,
                  color: kQuaternaryColor,
                ),
              ],
            ),
          ),
          Image.asset(Assets.imagesArrowNext, height: 24),
        ],
      ),
    );
  }
}

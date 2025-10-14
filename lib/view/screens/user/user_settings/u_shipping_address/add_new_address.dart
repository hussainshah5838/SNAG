import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/screens/merchant/settings/locations/bulk_locations_upload.dart';
import 'package:snag/view/screens/merchant/settings/locations/business_location_info.dart';
import 'package:snag/view/screens/user/user_settings/u_shipping_address/address_contact_info.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddNewAddress extends StatefulWidget {
  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  String _address = "Lahore MM, Alam Road";
  String _state = "Sydney";
  String _country = "Australia";
  String? _latitude = "32737.832838.23328328";
  String? _longitude = "32737.832838.23328328";
  String _locationType = "Franchise";

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
            text: "New Shipping Address",
            paddingTop: 8,
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text:
                "Enter your shipping address details including country, state.",
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),

          CustomDropDown(
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesLoc, height: 20)],
            ),
            labelText: 'Address',
            hint: 'Select Address',
            isMandatory: true,
            items: ['Lahore MM, Alam Road', 'Other Address'],
            selectedValue: _address,
            onChanged: (val) => setState(() => _address = val),
          ),
          // State (dropdown)
          CustomDropDown(
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesCountryIcon, height: 20)],
            ),
            labelText: 'State',
            hint: 'Select State',
            isMandatory: true,
            items: ['Sydney', 'Other State'],
            selectedValue: _state,
            onChanged: (val) => setState(() => _state = val),
          ),
          // Country (dropdown)
          CustomDropDown(
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesCountryIcon, height: 20)],
            ),
            labelText: 'Country',
            hint: 'Select Country',
            isMandatory: true,
            items: ['Australia', 'Other Country'],
            selectedValue: _country,
            onChanged: (val) => setState(() => _country = val),
          ),
          // Latitude (editable)
          MyTextField(
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesLat, height: 20)],
            ),
            labelText: 'Latitude',
            hintText: _latitude,
            isMandatory: true,
            onChanged: (val) => setState(() => _latitude = val),
          ),
          // Longitude (editable)
          MyTextField(
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesLong, height: 20)],
            ),
            labelText: 'Longitude',
            hintText: _longitude,
            isMandatory: true,
            onChanged: (val) => setState(() => _longitude = val),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: MyButton(
          buttonText: 'Next',
          onTap: () {
            Get.to(() => AddressContactInfo());
          },
        ),
      ),
    );
  }
}

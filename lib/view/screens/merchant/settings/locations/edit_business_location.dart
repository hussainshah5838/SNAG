import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditBusinessLocation extends StatefulWidget {
  @override
  State<EditBusinessLocation> createState() => _EditBusinessLocationState();
}

class _EditBusinessLocationState extends State<EditBusinessLocation> {
  String _address = "Lahore MM, Alam Road";
  String _state = "Sydney";
  String _country = "Australia";
  String? _latitude = "32737.832838.23328328";
  String? _longitude = "32737.832838.23328328";
  String _selectedRole = 'Owner/Admin';
  String _contactName = "Owner/Admin";

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
            text: "Edit Location",
            paddingTop: 8,
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text:
                "Edit a location to your profile with different details of branch.",
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
          // Location Type (dropdown)
          CustomDropDown(
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesName, height: 20)],
            ),
            labelText: 'Role',
            hint: 'Select Role',
            isMandatory: true,
            items: ['Owner/Admin', 'Manager', 'Staff', 'Other'],
            selectedValue: _selectedRole,
            onChanged: (val) => setState(() => _selectedRole = val),
          ),
          MyTextField(
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesProof, height: 20)],
            ),
            suffix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesUpload, height: 16)],
            ),
            isReadOnly: true,
            onTap: () {},
            labelText: 'Upload Banner/Image',
            hintText: 'weekend_flash_deal_banner.jpg',
            isMandatory: true,
          ),
          MyTextField(
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesPhone, height: 20)],
            ),
            labelText: 'Location Phone Number',
            hintText: '+971 322 323 2323',
            isMandatory: true,
            onChanged: (val) {},
          ),
          MyTextField(
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesEmail, height: 20)],
            ),
            labelText: 'Location Email',
            hintText: 'Anthonyjack@gmail.com',
            isMandatory: true,
            onChanged: (val) {},
          ),
          CustomDropDown(
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesName, height: 20)],
            ),
            labelText: 'Location Contact Name',
            hint: 'Select Contact Name',
            isMandatory: true,
            items: ['Owner/Admin', 'Manager', 'Staff', 'Other'],
            selectedValue: _contactName,
            onChanged: (val) => setState(() => _contactName = val),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: MyButton(buttonText: 'Save Details', onTap: () {}),
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
                text: 'Delete Branch?',
                size: 20,
                weight: FontWeight.w600,
                paddingBottom: 8,
              ),
              MyText(
                text:
                    'Are you sure you want to remove this branch? Any active discounts linked to this branch may stop working for customers.',
                size: 15,
                lineHeight: 1.5,
                weight: FontWeight.w500,
                color: kQuaternaryColor,
                paddingBottom: 24,
              ),

              MyButton(
                height: 42,
                buttonText: 'Delete Branch',
                onTap: () {
                  Get.back();
                  // Add your logout logic here
                },
              ),
              SizedBox(height: 12),
              MyBorderButton(
                buttonColor: kGreyColor2,
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

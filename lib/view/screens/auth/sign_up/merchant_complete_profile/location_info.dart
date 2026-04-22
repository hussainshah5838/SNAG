import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:flutter/material.dart';

class LocationInfo extends StatefulWidget {
  @override
  State<LocationInfo> createState() => LocationInfoState();
}

class LocationInfoState extends State<LocationInfo> {
  // String _contactName = "Owner/Admin"; // Commented out - backend doesn't require contactName

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: AppSizes.DEFAULT,
      physics: BouncingScrollPhysics(),
      children: [
        MyText(
          text: "Location Info",
          paddingTop: 8,
          size: 24,
          weight: FontWeight.w600,
          paddingBottom: 8,
        ),
        MyText(
          text:
              "Manage your company's info, logo, contact details, and settings.",
          size: 16,
          lineHeight: 1.5,
          weight: FontWeight.w500,
          color: kQuaternaryColor,
          paddingBottom: 30,
        ),
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesPhone, height: 20)],
          ),
          labelText: 'Phone Number',
          hintText: '+971 322 323 2323',
          isMandatory: true,
          onChanged: (val) {},
        ),
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesEmail, height: 20)],
          ),
          labelText: 'Email',
          hintText: 'Anthonyjack@gmail.com',
          isMandatory: true,
          onChanged: (val) {},
        ),
        // Contact Name dropdown commented out - backend doesn't require it
        // CustomDropDown(
        //   prefix: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [Image.asset(Assets.imagesName, height: 20)],
        //   ),
        //   labelText: 'Contact Name',
        //   hint: 'Select Contact Name',
        //   isMandatory: true,
        //   items: ['Owner/Admin', 'Manager', 'Staff', 'Other'],
        //   selectedValue: _contactName,
        //   onChanged: (val) => setState(() => _contactName = val),
        // ),
      ],
    );
  }
}

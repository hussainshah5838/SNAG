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
class BusinessLocationInfo extends StatefulWidget {
  @override
  State<BusinessLocationInfo> createState() => _BusinessLocationInfoState();
}

class _BusinessLocationInfoState extends State<BusinessLocationInfo> {
  String _contactName = "Owner/Admin";
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
          CustomDropDown(
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesName, height: 20)],
            ),
            labelText: 'Contact Name',
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
        child: MyButton(buttonText: 'Add', onTap: () {}),
      ),
    );
  }
}

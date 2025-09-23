import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

class BusinessProfile extends StatefulWidget {
  @override
  State<BusinessProfile> createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {
  String _selectedIndustry = 'Food & Beverages';
  String _selectedSubCategory = 'Fast Food';
  String _selectedRole = 'Owner/Admin';

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: AppSizes.DEFAULT,
      physics: BouncingScrollPhysics(),
      children: [
        MyText(
          text: 'Business Profile',
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

        // Company Name
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesCompany, height: 20)],
          ),
          labelText: 'Company Name',
          hintText: 'StarBaksh',
          isMandatory: true,
        ),
        // Phone Number
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesPhone, height: 20)],
          ),
          labelText: 'Phone Number',
          hintText: '+971 0432323332',
          isMandatory: true,
        ),
        // Company Address
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesLoc, height: 20)],
          ),
          labelText: 'Company Address',
          hintText: '12 street, Block B, Sydney, Australia',
          isMandatory: true,
        ),
        // Upload Logo (ideally should be an image picker)
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
          labelText: 'Upload Logo',
          hintText: 'logo.png',
          isMandatory: true,
        ),
        // Industry
        CustomDropDown(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesFood, height: 20)],
          ),
          labelText: 'Industry',
          hint: 'Select Industry',
          isMandatory: true,
          items: ['Food & Beverages', 'Retail', 'Technology', 'Other'],
          selectedValue: _selectedIndustry,
          onChanged: (val) => setState(() => _selectedIndustry = val),
        ),
        // Sub Category
        CustomDropDown(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesGps, height: 20)],
          ),
          labelText: 'Sub Category',
          hint: 'Select Sub Category',
          isMandatory: true,
          items: ['Fast Food', 'Coffee', 'Bakery', 'Other'],
          selectedValue: _selectedSubCategory,
          onChanged: (val) => setState(() => _selectedSubCategory = val),
        ),
        // Role
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
      ],
    );
  }
}

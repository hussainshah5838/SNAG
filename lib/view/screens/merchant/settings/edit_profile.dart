import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/main.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/custom_check_box_widget.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class EditProfile extends StatefulWidget {
  EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String _selectedIndustry = 'Food & Beverages';
  String _selectedSubCategory = 'Fast Food';
  String _selectedRole = 'Owner/Admin';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: ''),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CommonImageView(
                  url: dummyImg,
                  height: 140,
                  width: 140,
                  radius: 100,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 5,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        isScrollControlled: true,
                        builder: (context) {
                          Widget imageRow({
                            required String asset,
                            required String title,
                            required VoidCallback onTap,
                          }) {
                            return GestureDetector(
                              onTap: onTap,
                              child: Row(
                                children: [
                                  Image.asset(asset, height: 24),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: MyText(
                                      text: title,
                                      size: 16,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return Container(
                            height: 240,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 35,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: Image.asset(
                                    Assets.imagesHandle,
                                    width: 40,
                                  ),
                                ),
                                SizedBox(height: 13),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      Assets.imagesCloseIcon,
                                      height: 14,
                                      color: Colors.transparent,
                                    ),
                                    MyText(
                                      text: 'Upload',
                                      size: 20,
                                      weight: FontWeight.w600,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Image.asset(
                                        Assets.imagesCloseIcon,
                                        height: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                imageRow(
                                  asset: Assets.imagesUploadFile,
                                  title: 'Upload From Files',
                                  onTap: () {
                                    // Handle gallery upload
                                    Get.back();
                                  },
                                ),
                                SizedBox(height: 30),
                                imageRow(
                                  asset: Assets.imagesGallery,
                                  title: 'Upload From Gallery',
                                  onTap: () {
                                    // Handle gallery upload
                                    Get.back();
                                  },
                                ),
                                SizedBox(height: 20),
                                imageRow(
                                  asset: Assets.imagesTakePhoto,
                                  title: 'Take a Photo',
                                  onTap: () {
                                    // Handle camera capture
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Image.asset(Assets.imagesEdit, height: 28),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25),
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
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: AppSizes.DEFAULT,
          child: MyButton(buttonText: 'Save Details', onTap: () {}),
        ),
      ),
    );
  }
}

class _DeleteDialog extends StatelessWidget {
  const _DeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
                  text: 'Delete your profile?',
                  size: 20,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                MyText(
                  text:
                      'If you delete your profile, all your data and connections will be permanently removed. This can’t be undone.',
                  size: 15,
                  lineHeight: 1.5,
                  weight: FontWeight.w500,
                  color: kQuaternaryColor,
                  paddingBottom: 24,
                ),
                ...List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        CustomCheckBox(
                          isRadio: true,
                          unSelectedColor: kSecondaryColor,
                          isActive: index == 0,
                          onTap: () {},
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: MyText(
                            text:
                                [
                                  "Everything’s fine — no issues",
                                  "They’re making me uncomfortable",
                                  "They’re being rude or abusive",
                                  "I’d like to report this chat",
                                ][index],
                            size: 15,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                SizedBox(height: 10),
                MyButton(
                  height: 42,
                  buttonText: 'Delete',
                  onTap: () {
                    Get.back();
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

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
class UContactSupport extends StatelessWidget {
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
            text: 'Contact Support',
            paddingTop: 8,
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text: 'Have a question? Let us know. Our team will respond soon.',
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          MyTextField(
            labelText: 'Email Address',
            hintText: 'Enter your email address',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesEmail, height: 20)],
            ),
          ),
          MyTextField(
            labelText: 'Phone Number',
            hintText: 'Enter your phone number',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesPhone, height: 20)],
            ),
          ),
          CustomDropDown(
            labelText: 'What can we help with?',
            hint: 'Task Query',
            items: ['Task Query'],
            selectedValue: 'Task Query',
            onChanged: (v) {},
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesName, height: 20)],
            ),
          ),

          MyTextField(
            labelText: 'Message',
            hintText: 'Describe your issue in detail...',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesGps, height: 20)],
            ),
          ),
          MyTextField(
            labelText: 'Attachment (Optional)',
            hintText: 'Proof.png',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesProof, height: 20)],
            ),
            suffix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesUpload, height: 18)],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyButton(buttonText: 'Submit Request', onTap: () {}),
            SizedBox(height: 12),
            MyBorderButton(
              textColor: kRedColor,

              buttonText: 'Delete Account',
              onTap: () {
                Get.dialog(_deleteAccount());
              },
              borderColor: kRedColor,
            ),
          ],
        ),
      ),
    );
  }

  Column _deleteAccount() {
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
                  text: 'Delete Your Profile?',
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
}

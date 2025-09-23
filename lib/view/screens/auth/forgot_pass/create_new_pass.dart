import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class CreateNewPass extends StatelessWidget {
  const CreateNewPass({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(leadingColor: kPrimaryColor),
      backgroundColor: kSecondaryColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Image.asset(Assets.imagesLogo, height: 100),
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: _CreateNewPass()),
        ],
      ),
    );
  }
}

class _CreateNewPass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.5,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          MyText(
            text: 'Create a New Password',
            paddingTop: 8,
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text: 'Enter your new password below to secure your account.',
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),

          MyTextField(
            labelText: 'New Password',
            hintText: '*********',
            suffix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesVisibility, height: 20)],
            ),
          ),
          MyTextField(
            marginBottom: 30,
            labelText: 'Confirm Password',
            hintText: '*********',
            suffix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesVisibility, height: 20)],
            ),
          ),
          MyButton(
            buttonText: 'Reset Password',
            onTap: () {
              Get.offAll(() => Login());
            },
          ),
        ],
      ),
    );
  }
}

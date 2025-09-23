import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/screens/auth/forgot_pass/create_new_pass.dart';
import 'package:snag/view/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class ForgotPass extends StatelessWidget {
  const ForgotPass({super.key});

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
          Align(
            alignment: Alignment.bottomCenter,
            child: _ForgotPassBottomSheet(),
          ),
        ],
      ),
    );
  }
}

class _ForgotPassBottomSheet extends StatelessWidget {
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
            text: 'Forgot Your Password?',
            paddingTop: 8,
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text:
                'Don\'t worry, it happens. Enter your email and we\'ll send you a link to reset it.',
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          MyTextField(
            marginBottom: 30,
            labelText: 'Email',
            hintText: 'example@email.com',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesEmail, height: 20)],
            ),
          ),
          MyButton(
            buttonText: 'Send Reset Link',
            onTap: () {
              Get.to(() => CreateNewPass());
            },
          ),
          SizedBox(height: 25),
          Center(
            child: Wrap(
              children: [
                MyText(text: 'Remember Password? ', size: 16),
                MyText(
                  onTap: () {
                    Get.offAll(() => Login());
                  },
                  text: 'Login',
                  weight: FontWeight.w600,
                  color: kSecondaryColor,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

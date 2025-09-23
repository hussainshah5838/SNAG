import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/screens/auth/login.dart';
import 'package:snag/view/screens/auth/sign_up/otp_verification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/view/widget/custom_check_box_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class USignUp extends StatefulWidget {
  const USignUp({super.key});

  @override
  State<USignUp> createState() => _USignUpState();
}

class _USignUpState extends State<USignUp> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Get.bottomSheet(
        _SignUpBottomSheet(),
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        clipBehavior: Clip.antiAlias,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            SizedBox(height: 80),
            Center(child: Image.asset(Assets.imagesLogo, height: 100)),
          ],
        ),
      ),
    );
  }
}

class _SignUpBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.72,
      margin: EdgeInsets.only(top: 60),
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
            text: 'Let’s get some details in',
            paddingTop: 8,
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text:
                'Create your profile, share your world, & start connecting with people.',
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          MyTextField(
            labelText: 'User Name',
            hintText: 'Write your user name',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesName, height: 20)],
            ),
          ),

          MyTextField(
            labelText: 'Phone Number',
            hintText: 'Enter your number',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesPhone, height: 20)],
            ),
          ),
          MyTextField(
            labelText: 'Email',
            hintText: 'Enter your email',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesEmail, height: 20)],
            ),
          ),
          MyTextField(
            marginBottom: 20,
            labelText: 'Password',
            hintText: '*********',
            suffix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesVisibility, height: 20)],
            ),
          ),
          Row(
            children: [
              CustomCheckBox(isActive: false, onTap: () {}),
              Expanded(
                child: MyText(
                  paddingLeft: 10,
                  text: 'Agree to all terms and conditions',
                  size: 16,
                  color: kSenaryColor,
                  weight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          MyButton(
            buttonText: 'Send Code',
            onTap: () {
              Get.to(() => OTPVerification());
            },
          ),
          SizedBox(height: 25),
          Center(
            child: Wrap(
              children: [
                MyText(text: 'Already have an account? ', size: 16),
                MyText(
                  onTap: () {
                    Get.offAll(() => Login());
                  },
                  text: 'Login',
                  weight: FontWeight.w600,
                  color: kQuaternaryColor,
                  size: 16,
                ),
              ],
            ),
          ),
          SizedBox(height: 120),
        ],
      ),
    );
  }
}

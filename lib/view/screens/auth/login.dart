import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controller/user_controller.dart';
import 'package:snag/utils/global_instances.dart';
import 'package:snag/view/screens/auth/forgot_pass/forgot_pass.dart';
import 'package:snag/view/screens/auth/sign_up/user_auth/u_signup.dart';
import 'package:snag/view/screens/auth/sign_up/sign_up.dart';
import 'package:snag/view/screens/bottom_nav_bar/merchant_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/view/screens/bottom_nav_bar/user_nav_bar.dart';
import 'package:snag/view/screens/launch/choose_user_type.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        haveLeading: false,
        // leadingColor: kPrimaryColor,
        // onLeadingTap: () => Get.to(() => ChooseUserType()),
      ),
      backgroundColor: kSecondaryColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Image.asset(Assets.imagesLogo, height: 100),
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: _LoginBottomSheet()),
        ],
      ),
    );
  }
}

class _LoginBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 60),
      height: Get.height * 0.65,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          MyText(
            text: 'Let\'s snag you in...',
            paddingTop: 8,
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text: 'Discover offers around you - quick, safe and easy!',
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          MyTextField(
            labelText: 'Enter your email',
            hintText: 'example@email.com',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesEmail, height: 20)],
            ),
          ),
          MyTextField(
            marginBottom: 16,
            labelText: 'Password',
            hintText: '*********',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesName, height: 20)],
            ),
            suffix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesVisibility, height: 20)],
            ),
          ),
          MyText(
            onTap: () {
              Get.to(() => ForgotPass());
            },
            textAlign: TextAlign.end,
            text: 'Forgot Password?',
            weight: FontWeight.w600,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          MyButton(
            buttonText: 'Continue',
            onTap: () {
              chooseUserController.currentRole == UserRole.merchant
                  ? Get.to(() => MerchantNavBar())
                  : Get.to(() => UserNavBar());
            },
          ),
          SizedBox(height: 25),
          Center(
            child: Wrap(
              children: [
                MyText(text: 'Don\'t have an account? ', size: 16),
                MyText(
                  onTap: () {
                    chooseUserController.currentRole != UserRole.merchant
                        ? Get.to(() => USignUp())
                        : Get.to(() => SignUp());
                  },
                  text: 'Sign Up',
                  weight: FontWeight.w600,
                  color: kQuaternaryColor,
                  size: 16,
                ),
              ],
            ),
          ),
          MyText(
            text: 'OR',
            size: 12,
            color: kQuaternaryColor,
            paddingTop: 16,
            paddingBottom: 16,
            textAlign: TextAlign.center,
          ),
          Center(
            child: Wrap(
              children: [
                MyText(text: 'Continue as ', size: 16),
                Obx(
                  () => MyText(
                    text:
                        (UserController.instance.currentRole ==
                                    UserRole.merchant
                                ? 'User'
                                : 'Merchant')
                            .toUpperCase(),
                    onTap: () {
                      if (UserController.instance.currentRole ==
                          UserRole.merchant) {
                        UserController.instance.selectRole(UserRole.user);
                      } else {
                        UserController.instance.selectRole(UserRole.merchant);
                      }
                    },
                    decoration: TextDecoration.underline,
                    weight: FontWeight.w600,
                    color: kSecondaryColor,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/auth_controller.dart';
import 'package:snag/view/screens/auth/forgot_pass/forgot_pass_otp.dart';
import 'package:snag/view/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final _emailController = TextEditingController();
  final _auth = AuthController.instance;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onSendResetLink() async {
    if (_emailController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your email',
          backgroundColor: kRedColor, colorText: kPrimaryColor);
      return;
    }

    final success = await _auth.forgotPassword(email: _emailController.text.trim());

    if (success) {
      Get.to(() => const ForgotPassOTP());
    } else {
      Get.snackbar('Error', _auth.errorMsg.value,
          backgroundColor: kRedColor, colorText: kPrimaryColor);
    }
  }

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
            child: _ForgotPassBottomSheet(
              emailController: _emailController,
              onSendResetLink: _onSendResetLink,
              authController: _auth,
            ),
          ),
        ],
      ),
    );
  }
}

class _ForgotPassBottomSheet extends StatelessWidget {
  final TextEditingController emailController;
  final VoidCallback onSendResetLink;
  final AuthController authController;

  const _ForgotPassBottomSheet({
    required this.emailController,
    required this.onSendResetLink,
    required this.authController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.5,
      decoration: const BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: const BouncingScrollPhysics(),
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
                'Don\'t worry, it happens. Enter your email and we\'ll send you a code to reset it.',
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          MyTextField(
            controller: emailController,
            marginBottom: 30,
            labelText: 'Email',
            hintText: 'example@email.com',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesEmail, height: 20)],
            ),
          ),
          Obx(() => authController.isLoading.value
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              : MyButton(
                  buttonText: 'Send Reset Code',
                  onTap: onSendResetLink,
                )),
          const SizedBox(height: 25),
          Center(
            child: Wrap(
              children: [
                MyText(text: 'Remember Password? ', size: 16),
                MyText(
                  onTap: () => Get.offAll(() => const Login()),
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

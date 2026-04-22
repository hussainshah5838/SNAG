import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/auth_controller.dart';
import 'package:snag/view/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class CreateNewPass extends StatefulWidget {
  final String code;
  
  const CreateNewPass({super.key, required this.code});

  @override
  State<CreateNewPass> createState() => _CreateNewPassState();
}

class _CreateNewPassState extends State<CreateNewPass> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _auth = AuthController.instance;
  var _obscureNewPassword = true;
  var _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onResetPassword() async {
    if (_newPasswordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields',
          backgroundColor: kRedColor, colorText: kPrimaryColor);
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match',
          backgroundColor: kRedColor, colorText: kPrimaryColor);
      return;
    }

    final success = await _auth.resetPassword(
      code: widget.code,
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    if (success) {
      Get.offAll(() => const Login());
      Get.snackbar('Success', 'Password reset successfully',
          backgroundColor: kGreenColor, colorText: kPrimaryColor);
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
            child: _CreateNewPassBottomSheet(
              newPasswordController: _newPasswordController,
              confirmPasswordController: _confirmPasswordController,
              obscureNewPassword: _obscureNewPassword,
              obscureConfirmPassword: _obscureConfirmPassword,
              onToggleNewPassword: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
              onToggleConfirmPassword: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              onResetPassword: _onResetPassword,
              authController: _auth,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateNewPassBottomSheet extends StatelessWidget {
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool obscureNewPassword;
  final bool obscureConfirmPassword;
  final VoidCallback onToggleNewPassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onResetPassword;
  final AuthController authController;

  const _CreateNewPassBottomSheet({
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.obscureNewPassword,
    required this.obscureConfirmPassword,
    required this.onToggleNewPassword,
    required this.onToggleConfirmPassword,
    required this.onResetPassword,
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
            controller: newPasswordController,
            labelText: 'New Password',
            hintText: '*********',
            isObSecure: obscureNewPassword,
            suffix: GestureDetector(
              onTap: onToggleNewPassword,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset(Assets.imagesVisibility, height: 20)],
              ),
            ),
          ),
          MyTextField(
            controller: confirmPasswordController,
            marginBottom: 30,
            labelText: 'Confirm Password',
            hintText: '*********',
            isObSecure: obscureConfirmPassword,
            suffix: GestureDetector(
              onTap: onToggleConfirmPassword,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset(Assets.imagesVisibility, height: 20)],
              ),
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
                  buttonText: 'Reset Password',
                  onTap: onResetPassword,
                )),
        ],
      ),
    );
  }
}

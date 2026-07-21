import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/auth_controller.dart';
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

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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

// Changed to StatefulWidget to hold TextEditingControllers + terms state
class _SignUpBottomSheet extends StatefulWidget {
  @override
  State<_SignUpBottomSheet> createState() => _SignUpBottomSheetState();
}

class _SignUpBottomSheetState extends State<_SignUpBottomSheet> {
  // Controllers to read field values on submit
  final _firstNameController = TextEditingController();
  final _lastNameController  = TextEditingController();
  final _emailController     = TextEditingController();
  final _phoneController     = TextEditingController();
  final _passwordController  = TextEditingController();

  bool _termsAccepted = false;
  bool _obscurePassword = true;

  final _auth = AuthController.instance;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSendCode() async {
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Please fill in all fields',
              style: TextStyle(color: kPrimaryColor)),
          backgroundColor: kRedColor,
        ),
      );
      return;
    }
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Please accept the terms and conditions',
              style: TextStyle(color: kPrimaryColor)),
          backgroundColor: kRedColor,
        ),
      );
      return;
    }

    final success = await _auth.merchantRegister(
      firstName:   _firstNameController.text.trim(),
      lastName:    _lastNameController.text.trim(),
      email:       _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      password:    _passwordController.text,
    );

    if (success) {
      Get.to(() => OTPVerification());
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${_auth.errorMsg.value}',
              style: TextStyle(color: kPrimaryColor)),
          backgroundColor: kRedColor,
        ),
      );
    }
  }

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
            text: "Let's get some details in",
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
            controller: _firstNameController,
            labelText: 'First Name',
            hintText: 'Write your first name',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesName, height: 20)],
            ),
          ),
          MyTextField(
            controller: _lastNameController,
            labelText: 'Last Name',
            hintText: 'Write your last name',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesName, height: 20)],
            ),
          ),
          MyTextField(
            controller: _emailController,
            labelText: 'Enter your email',
            hintText: 'example@email.com',
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesEmail, height: 20)],
            ),
          ),
          MyTextField(
            controller: _phoneController,
            labelText: 'Contact',
            hintText: 'Enter your number',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesPhone, height: 20)],
            ),
          ),
          MyTextField(
            controller: _passwordController,
            marginBottom: 20,
            labelText: 'Password',
            hintText: '*********',
            isObSecure: _obscurePassword,
            suffix: GestureDetector(
              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset(Assets.imagesVisibility, height: 20)],
              ),
            ),
          ),
          Row(
            children: [
              CustomCheckBox(
                isActive: _termsAccepted,
                onTap: () => setState(() => _termsAccepted = !_termsAccepted),
              ),
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
          Obx(() => MyButton(
            buttonText: 'Send Code',
            onTap: _auth.isLoading.value ? () {} : _onSendCode,
            customChild: _auth.isLoading.value
                ? SizedBox(
                    height: 22, width: 22,
                    child: CircularProgressIndicator(
                        color: kPrimaryColor, strokeWidth: 2.5),
                  )
                : null,
          )),
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

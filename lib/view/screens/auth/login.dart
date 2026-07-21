import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/auth_controller.dart';
import 'package:snag/controllers/user_controller.dart';
import 'package:snag/view/screens/auth/forgot_pass/forgot_pass.dart';
import 'package:snag/view/screens/auth/sign_up/sign_up.dart';
import 'package:snag/view/screens/auth/sign_up/user_auth/u_signup.dart';
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
  final _authController = AuthController.instance;
  final _userController = UserController.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _authController.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!success && _authController.errorMsg.value.isNotEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login Failed: ${_authController.errorMsg.value}',
            style: TextStyle(color: Colors.red.shade900),
          ),
          backgroundColor: Colors.red.shade100,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(haveLeading: false),
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
          Align(
            alignment: Alignment.bottomCenter,
            child: _LoginBottomSheet(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
              obscurePassword: _obscurePassword,
              onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
              onLogin: _handleLogin,
              authController: _authController,
              userController: _userController,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginBottomSheet extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;
  final AuthController authController;
  final UserController userController;

  const _LoginBottomSheet({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onLogin,
    required this.authController,
    required this.userController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      height: Get.height * 0.65,
      decoration: const BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          padding: AppSizes.DEFAULT,
          physics: const BouncingScrollPhysics(),
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
              controller: emailController,
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
              controller: passwordController,
              marginBottom: 16,
              labelText: 'Password',
              hintText: '*********',
              isObSecure: obscurePassword,
              prefix: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset(Assets.imagesName, height: 20)],
              ),
              suffix: GestureDetector(
                onTap: onTogglePassword,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.imagesVisibility,
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
            MyText(
              onTap: () => Get.to(() => const ForgotPass()),
              textAlign: TextAlign.end,
              text: 'Forgot Password?',
              weight: FontWeight.w600,
              color: kQuaternaryColor,
              paddingBottom: 30,
            ),
            Obx(() => authController.isLoading.value
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : MyButton(
                    buttonText: 'Continue',
                    onTap: onLogin,
                  )),
            const SizedBox(height: 25),
            Center(
              child: Wrap(
                children: [
                  MyText(text: 'Don\'t have an account? ', size: 16),
                  MyText(
                    onTap: () {
                      userController.currentRole != UserRole.merchant
                          ? Get.to(() => const USignUp())
                          : Get.to(() => const SignUp());
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
                      text: (userController.currentRole == UserRole.merchant
                              ? 'User'
                              : 'Merchant')
                          .toUpperCase(),
                      onTap: () {
                        if (userController.currentRole == UserRole.merchant) {
                          userController.selectRole(UserRole.user);
                        } else {
                          userController.selectRole(UserRole.merchant);
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
      ),
    );
  }
}

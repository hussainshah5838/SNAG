import 'package:snag/constants/app_fonts.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/view/screens/auth/sign_up/location_access.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:pinput/pinput.dart';

class OTPVerification extends StatelessWidget {
  const OTPVerification({super.key});

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
          Align(alignment: Alignment.bottomCenter, child: _OTPBottomSheet()),
        ],
      ),
    );
  }
}

class _OTPBottomSheet extends StatefulWidget {
  @override
  State<_OTPBottomSheet> createState() => _OTPBottomSheetState();
}

class _OTPBottomSheetState extends State<_OTPBottomSheet> {
  final TextEditingController pinController = TextEditingController();
  String pinStatus = '';

  Color getPinTextColor() {
    switch (pinStatus) {
      case 'invalid':
        return Color(0xFFF73434);
      default:
        return kTertiaryColor;
    }
  }

  void onPinChanged(String value) {
    setState(() {
      if (value.length == 5 && value != '12345') {
        pinStatus = 'invalid';
      } else {
        pinStatus = '';
      }
    });
  }

  void onVerify() {
    if (pinController.text == '12345') {
      Get.to(() => LocationAccess());
    } else {
      setState(() {
        pinStatus = 'invalid';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final PinTheme pinTheme = PinTheme(
      width: 62,
      height: 72,
      margin: EdgeInsets.zero,
      textStyle: TextStyle(
        fontSize: 24,
        height: 0.0,
        fontWeight: FontWeight.w600,
        fontFamily: AppFonts.WORK_SANS,
        color: getPinTextColor(),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1.0,
          color: pinStatus == 'invalid' ? Color(0xFFF73434) : kBorderColor,
        ),
        color: Color(0xffFCFCFC),
      ),
    );

    return Container(
      height: Get.height * 0.5,
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
            text: 'Verify it\'s you',
            paddingTop: 8,
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text: 'Enter the 5-digit code we sent to your phone/email.',
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          Pinput(
            length: 5,
            controller: pinController,
            onChanged: onPinChanged,
            pinContentAlignment: Alignment.center,
            defaultPinTheme: pinTheme,
            focusedPinTheme: pinTheme,
            submittedPinTheme: pinTheme,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            onCompleted: onPinChanged,
          ),
          if (pinStatus == 'invalid')
            MyText(
              textAlign: TextAlign.end,
              text: 'Wrong Code, Try Again',
              color: Color(0xFFF73434),
              size: 16,
              weight: FontWeight.w600,
              paddingTop: 10,
            ),
          SizedBox(height: 50),
          MyButton(buttonText: 'Verify & Continue', onTap: onVerify),
          SizedBox(height: 30),
          Center(
            child: Wrap(
              children: [
                MyText(text: '00:30 Sec - ', size: 16, weight: FontWeight.w500),
                MyText(
                  onTap: () {},
                  text: 'Resend Code',
                  weight: FontWeight.w600,
                  color: kAmberColor,
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

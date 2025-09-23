import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_fonts.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/screens/user/user_scan_qr/u_payment_successfull.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable

class UPaymentVerification extends StatefulWidget {
  @override
  State<UPaymentVerification> createState() => _UPaymentVerificationState();
}

class _UPaymentVerificationState extends State<UPaymentVerification> {
  String pinStatus = '';
  final TextEditingController pinController = TextEditingController();

  Color getPinTextColor(String pinStatus) {
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
        color: getPinTextColor(pinStatus),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1.0,
          color: pinStatus == 'invalid' ? Color(0xFFF73434) : kBorderColor,
        ),
        color: kFillColor,
      ),
    );

    return Scaffold(
      appBar: simpleAppBar(title: ''),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          MyText(
            text: "Payment Verification",
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text: "Enter the 5-digit code we sent to your phone/email.",
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
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: MyButton(
          buttonText: 'Done',
          onTap: () {
            Get.to(() => UPaymentSuccessful());
          },
        ),
      ),
    );
  }
}

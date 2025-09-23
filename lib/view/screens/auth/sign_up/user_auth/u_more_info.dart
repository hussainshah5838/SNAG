import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/screens/auth/login.dart';
import 'package:snag/view/screens/auth/sign_up/merchant_complete_profile/discover_offers.dart';
import 'package:snag/view/screens/auth/sign_up/otp_verification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/view/widget/custom_check_box_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';

class UMoreInfo extends StatefulWidget {
  const UMoreInfo({super.key});

  @override
  State<UMoreInfo> createState() => _UMoreInfoState();
}

class _UMoreInfoState extends State<UMoreInfo> {
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

class _SignUpBottomSheet extends StatefulWidget {
  @override
  State<_SignUpBottomSheet> createState() => _SignUpBottomSheetState();
}

class _SignUpBottomSheetState extends State<_SignUpBottomSheet> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedGender = 'Prefer not to say';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
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
            text: 'Let’s get some details in',
            paddingTop: 8,
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text:
                'Tell us a bit more about yourself to personalize your experience.',
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          MyTextField(
            labelText: 'First Name',
            hintText: 'First Name',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesName, height: 20)],
            ),
            onChanged: (v) {},
            controller: _firstNameController,
          ),

          MyTextField(
            labelText: 'Last Name',
            hintText: 'Last Name',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesName, height: 20)],
            ),
            onChanged: (v) {},
            controller: _lastNameController,
          ),
          MyTextField(
            labelText: 'Shipping Address',
            hintText: 'Enter shipping address',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesLoc, height: 20)],
            ),
            controller: _addressController,
            onChanged: (v) {},
          ),
          MyTextField(
            labelText: 'Phone Number',
            hintText: 'Enter your number',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesPhone, height: 20)],
            ),
            controller: _phoneController,
            onChanged: (v) {},
          ),
          GestureDetector(
            onTap: _pickDate,
            child: MyTextField(
              isReadOnly: true,
              labelText: 'Birthday',
              hintText:
                  _selectedDate == null
                      ? 'MM/DD/YYYY'
                      : '${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.year}',
              prefix: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset(Assets.imagesCalendar, height: 20)],
              ),
            ),
          ),
          CustomDropDown(
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesName, height: 20)],
            ),
            labelText: 'Gender',
            hint: 'Select gender',
            isMandatory: true,
            items: ['Male', 'Female', 'Other', 'Prefer not to say'],
            selectedValue: _selectedGender,
            onChanged: (v) => setState(() => _selectedGender = v),
          ),

          SizedBox(height: 16),
          MyButton(
            buttonText: 'Continue',
            onTap: () {
              Get.to(
                () => DiscoverOffers(),
                // arguments: {
                //   'firstName': _firstNameController.text.trim(),
                //   'lastName': _lastNameController.text.trim(),
                //   'address': _addressController.text.trim(),
                //   'phone': _phoneController.text.trim(),
                //   'dob': _selectedDate?.toIso8601String(),
                //   'gender': _selectedGender,
                // },
              );
            },
          ),
        ],
      ),
    );
  }
}

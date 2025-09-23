import 'package:snag/view/screens/auth/sign_up/merchant_complete_profile/bulk_upload_locations.dart';
import 'package:snag/view/screens/auth/sign_up/merchant_complete_profile/link_your_franchise.dart';
import 'package:snag/view/screens/auth/sign_up/merchant_complete_profile/add_location.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/view/screens/auth/sign_up/merchant_complete_profile/business_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/screens/auth/sign_up/merchant_complete_profile/location_info.dart';
import 'package:snag/view/screens/auth/sign_up/merchant_complete_profile/locations.dart';
import 'package:snag/view/screens/auth/sign_up/merchant_complete_profile/on_map_locations.dart';
import 'package:snag/view/widget/my_button_widget.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  int _currentStep = 0;

  // List of step widgets
  final List<Widget> _steps = [
    BusinessProfile(),
    AddLocation(),
    LinkYourFranchise(),
    LocationInfo(),
    BulkUploadLocations(),
    Locations(),
  ];

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      Get.to(() => OnMapLocations());
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: GestureDetector(
                onTap: _previousStep,
                child: Image.asset(Assets.imagesArrowBack, height: 16),
              ),
            ),
          ],
        ),
        title: Row(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            _steps.length,
            (index) => Container(
              width: index == _currentStep ? 8 : 6,
              height: index == _currentStep ? 8 : 6,
              decoration: BoxDecoration(
                color:
                    index == _currentStep
                        ? kTertiaryColor
                        : kTertiaryColor.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
      body: _steps[_currentStep],
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: AppSizes.DEFAULT,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              if (_currentStep == 5)
                MyBorderButton(buttonText: 'Add Location', onTap: () {}),
              MyButton(
                buttonText:
                    _currentStep == 2
                        ? 'Select & Continue'
                        : _currentStep == 5
                        ? 'Done'
                        : 'Next',
                onTap: _nextStep,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

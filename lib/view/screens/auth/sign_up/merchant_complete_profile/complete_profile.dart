import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/merchant_onboarding_controller.dart';
import 'package:snag/view/screens/auth/sign_up/merchant_complete_profile/add_location.dart';
import 'package:snag/view/screens/auth/sign_up/merchant_complete_profile/all_set.dart';
import 'package:snag/view/screens/auth/sign_up/merchant_complete_profile/bulk_upload_locations.dart';
import 'package:snag/view/screens/auth/sign_up/merchant_complete_profile/business_profile.dart';
// import 'package:snag/view/screens/auth/sign_up/merchant_complete_profile/link_your_franchise.dart';
import 'package:snag/view/screens/auth/sign_up/merchant_complete_profile/location_info.dart';
import 'package:snag/view/screens/auth/sign_up/merchant_complete_profile/locations.dart';
import 'package:snag/view/widget/my_button_widget.dart';

/// Stepper for merchant onboarding.
///
/// Steps:
///   0 — Business Profile   → POST /merchant/onboarding/branch-profile
///   1 — Add Location       → POST /merchant/onboarding/locations
///   2 — Bulk Upload        → POST /merchant/onboarding/locations/bulk
///   3 — Location Info      → (shown after add location, no separate API — part of branch-info)
///   4 — Locations list     → GET  /merchant/onboarding/locations
///   5 — All Set            → POST /merchant/onboarding/complete
///
/// LinkYourFranchise step is commented out — no backend API yet.
class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  int _currentStep = 0;

  final _businessProfileKey = GlobalKey<BusinessProfileState>();
  final _addLocationKey     = GlobalKey<AddLocationState>();
  final _bulkUploadKey      = GlobalKey<BulkUploadLocationsState>();

  final _ctrl = MerchantOnboardingController.instance;

  late final List<Widget> _steps = [
    BusinessProfile(key: _businessProfileKey),   // step 0
    AddLocation(key: _addLocationKey),            // step 1
    BulkUploadLocations(key: _bulkUploadKey),     // step 2
    LocationInfo(),                                   // step 3
    Locations(),                                      // step 4
    AllSet(),                                         // step 5 — has its own button
    // LinkYourFranchise(),                           // commented out — no backend yet
  ];

  Future<void> _nextStep() async {
    switch (_currentStep) {
      // ── Step 0: Business Profile ──────────────────────────────────────────
      case 0:
        final data = _businessProfileKey.currentState?.getFormData();
        if (data == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill in all required fields')),
          );
          return;
        }
        final ok = await _ctrl.saveBranchProfile(
          branchName:    data['branchName'],
          phoneNumber:   data['phoneNumber'],
          branchAddress: data['branchAddress'],
          industry:      data['industry'],
          subCategories: data['subCategories'],
          logoFile:      data['logoFile'],
        );
        if (!ok) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_ctrl.errorMsg.value)),
          );
          return;
        }

      // ── Step 1: Add Location ──────────────────────────────────────────────
      case 1:
        final data = _addLocationKey.currentState?.getFormData();
        if (data == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill in all required fields')),
          );
          return;
        }
        final ok1 = await _ctrl.addLocation(
          address:       data['address'],
          state:         data['state'],
          country:       data['country'],
          branchAddress: data['branchAddress'],
          locationType:  data['locationType'],
          lat:           data['lat'],
          lng:           data['lng'],
          bannerFile:    data['bannerFile'],
          phoneNumber:   data['phoneNumber'],
          email:         data['email'],
        );
        if (!ok1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_ctrl.errorMsg.value)),
          );
          return;
        }

      // ── Step 2: Bulk Upload ───────────────────────────────────────────────
      case 2:
        final data = _bulkUploadKey.currentState?.getFormData();
        if (data == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unable to process bulk upload')),
          );
          return;
        }
        
        // Skip if no CSV file was uploaded
        if (data['skipped'] == true) {
          // Just move to next step without API call
          break;
        }
        
        final ok2 = await _ctrl.bulkUploadLocations(
          csvFile: data['csvFile'],
          notes:   data['notes'],
        );
        if (!ok2) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_ctrl.errorMsg.value)),
          );
          return;
        }

      // ── Steps 3, 4: no API call on Next ───────────────────────────────────
      default:
        if (_currentStep == 3) {
          // Fetch locations when entering step 4
          _ctrl.fetchLocations();
        }
        break;
    }

    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    }
    // Step 5 (AllSet) has its own "Go To Homepage" button — no Next needed
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
    // AllSet screen manages its own bottom button
    final isLastStep = _currentStep == _steps.length - 1;

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
                color: index == _currentStep
                    ? kTertiaryColor
                    : kTertiaryColor.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentStep,
        children: _steps,
      ),
      // Hide bottom nav on AllSet — it has its own button
      bottomNavigationBar: isLastStep
          ? null
          : BottomAppBar(
              color: Colors.transparent,
              elevation: 0,
              child: Padding(
                padding: AppSizes.DEFAULT,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 12,
                  children: [
                    // "Add Location" border button on Locations step
                    if (_currentStep == 4)
                      MyBorderButton(
                        buttonText: 'Add Location',
                        onTap: () => setState(() => _currentStep = 1),
                      ),
                    // "Skip" button on Bulk Upload step
                    if (_currentStep == 2)
                      MyBorderButton(
                        buttonText: 'Skip',
                        onTap: () {
                          // Skip bulk upload and go to next step
                          setState(() => _currentStep++);
                        },
                      ),
                    Obx(() => MyButton(
                      buttonText: _currentStep == 4 ? 'Done' : 'Next',
                      onTap: _ctrl.isLoading.value ? () {} : _nextStep,
                      customChild: _ctrl.isLoading.value
                          ? SizedBox(
                              height: 22, width: 22,
                              child: CircularProgressIndicator(
                                  color: kPrimaryColor, strokeWidth: 2.5),
                            )
                          : null,
                    )),
                  ],
                ),
              ),
            ),
    );
  }
}

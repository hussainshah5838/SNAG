import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/add_offer_controller.dart';
import 'package:snag/view/screens/merchant/offers/offers.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TargetAudience extends StatefulWidget {
  @override
  State<TargetAudience> createState() => _TargetAudienceState();
}

class _TargetAudienceState extends State<TargetAudience> {
  // Find existing controller
  final controller = Get.find<AddOfferController>();
  
  final List<String> _demographics = ['18–24', '25–34', '35–44', '45–54', '55+'];
  final List<String> _interests = ['Coffee', 'Fast Food', 'Fitness', 'Shopping', 'Entertainment'];
  final List<String> _behaviors = ['Frequent Diners', 'Deal Seekers', 'High Spenders', 'First-time Visitors'];
  final List<String> _radiusOptions = ['1 km', '2 km', '5 km', '10 km', '20 km', '50 km'];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: ''),
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            padding: AppSizes.DEFAULT,
            physics: BouncingScrollPhysics(),
            children: [
              MyText(
                text: "Target Audience",
                size: 24,
                weight: FontWeight.w600,
                paddingBottom: 4,
              ),
              MyText(
                text: "Choose the right audience for your offer by considering location, interests, demographics, and behaviors.",
                size: 16,
                lineHeight: 1.5,
                weight: FontWeight.w500,
                color: kQuaternaryColor,
                paddingBottom: 16,
              ),
              
              // Error message - NO Obx wrapper
              if (controller.errorMessage.value != null)
                Container(
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          controller.errorMessage.value!,
                          style: TextStyle(color: Colors.red.shade900, fontSize: 14),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: () => controller.errorMessage.value = null,
                      ),
                    ],
                  ),
                ),
              
              SizedBox(height: 14),
              
              MultiDropDown(
                labelText: 'Demographics',
                hint: 'Select age group',
                isMandatory: false,
                items: _demographics,
                prefix: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Image.asset(Assets.imagesTag, height: 20)],
                ),
                selectedValues: controller.selectedDemographics,
                onTap: (value) {
                  if (controller.selectedDemographics.contains(value)) {
                    controller.selectedDemographics.remove(value);
                  } else {
                    controller.selectedDemographics.add(value);
                  }
                },
              ),
              MultiDropDown(
                labelText: 'Interests',
                hint: 'Select interests',
                isMandatory: false,
                items: _interests,
                prefix: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Image.asset(Assets.imagesInterests, height: 20)],
                ),
                selectedValues: controller.selectedInterests,
                onTap: (value) {
                  if (controller.selectedInterests.contains(value)) {
                    controller.selectedInterests.remove(value);
                  } else {
                    controller.selectedInterests.add(value);
                  }
                },
              ),
              MultiDropDown(
                labelText: 'Behavior',
                hint: 'Select behavior',
                isMandatory: false,
                items: _behaviors,
                prefix: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Image.asset(Assets.imagesFood, height: 20)],
                ),
                selectedValues: controller.selectedBehaviors,
                onTap: (value) {
                  if (controller.selectedBehaviors.contains(value)) {
                    controller.selectedBehaviors.remove(value);
                  } else {
                    controller.selectedBehaviors.add(value);
                  }
                },
              ),
              CustomDropDown(
                labelText: 'Radius (Km)',
                hint: 'Select radius...',
                items: ['Select radius...', ..._radiusOptions],
                selectedValue: controller.selectedRadiusKm.value != null
                    ? '${controller.selectedRadiusKm.value} km'
                    : 'Select radius...',
                prefix: Image.asset(Assets.imagesCountryIcon, height: 20),
                onChanged: (v) {
                  if (v != 'Select radius...') {
                    controller.selectedRadiusKm.value = int.parse(v.split(' ')[0]);
                  }
                },
              ),
            ],
          ),
          
          // Loading overlay - NO Obx wrapper, just check value directly
          if (controller.isLoading.value || controller.isSavingStep.value)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: MyButton(
          buttonText: 'Done',
          onTap: () async {
            // Save target audience
            final saved = await controller.saveCurrentStep();
            
            if (saved) {
              // Activate offer
              final activated = await controller.activateOffer();
              
              if (activated) {
                // Navigate back to offers list FIRST (before showing snackbar)
                Get.offAll(() => Offers());
                
                // Show success message AFTER navigation
                Future.delayed(Duration(milliseconds: 100), () {
                  Get.snackbar(
                    'Success',
                    'Offer created successfully!',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    duration: Duration(seconds: 2),
                  );
                });
              }
            }
          },
        ),
      ),
    );
  }
}

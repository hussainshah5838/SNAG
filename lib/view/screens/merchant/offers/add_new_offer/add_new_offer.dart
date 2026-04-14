import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/add_offer_controller.dart';
import 'package:snag/view/screens/merchant/offers/add_new_offer/target_audience.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddNewOffer extends StatefulWidget {
  @override
  State<AddNewOffer> createState() => _AddNewOfferState();
}

class _AddNewOfferState extends State<AddNewOffer> {
  // Get or create controller
  late final AddOfferController controller;
  final _imagePicker = ImagePicker();
  
  @override
  void initState() {
    super.initState();
    // Delete any existing controller and create fresh one
    Get.delete<AddOfferController>();
    controller = Get.put(AddOfferController());
    // Reset to ensure clean state
    controller.reset();
  }
  
  @override
  void dispose() {
    // Clean up controller when screen is disposed
    Get.delete<AddOfferController>();
    super.dispose();
  }
  
  final List<String> labels = ["Basic Info", "Scan Info", "Location Info"];
  final List<String> _categories = [
    'Food & Drink',
    'Shopping',
    'Beauty & Wellness',
    'Entertainment',
    'Services',
    'Health & Fitness',
  ];
  
  Future<void> _pickImage(String type) async {
    final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (type == 'banner') {
        controller.bannerFile.value = File(picked.path);
      } else if (type == 'qr') {
        controller.qrCodeFile.value = File(picked.path);
      } else if (type == 'barcode') {
        controller.barCodeFile.value = File(picked.path);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: simpleAppBar(title: ''),
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            padding: AppSizes.DEFAULT,
            physics: BouncingScrollPhysics(),
            children: [
              MyText(
                text: "Add New Offer",
                size: 24,
                weight: FontWeight.w600,
                paddingBottom: 4,
              ),
              MyText(
                text: "Set up a new offer to attract customers and boost redemptions",
                size: 16,
                lineHeight: 1.5,
                weight: FontWeight.w500,
                color: kQuaternaryColor,
                paddingBottom: 16,
              ),
              
              // Error message
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
              
              // Tabs
              SizedBox(
                height: 35,
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(width: 10),
                  padding: AppSizes.ZERO,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: labels.length,
                  itemBuilder: (context, index) {
                    final isSelected = controller.currentStep.value == index;
                    final isCompleted = controller.completedSteps.contains(index);
                    final isLocked = !isCompleted && index > controller.currentStep.value;
                    
                    return GestureDetector(
                      onTap: isLocked ? null : () {
                        controller.goToStep(index);
                      },
                      child: Opacity(
                        opacity: isLocked ? 0.5 : 1.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: isLocked
                                ? Colors.grey.shade200
                                : isSelected
                                    ? kSecondaryColor
                                    : kLightBlueColor2,
                            border: Border.all(
                              color: isLocked ? Colors.grey : kBlueBorderColor,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isCompleted)
                                Padding(
                                  padding: EdgeInsets.only(right: 4),
                                  child: Icon(
                                    Icons.check_circle,
                                    size: 14,
                                    color: Colors.green,
                                  ),
                                ),
                              MyText(
                                text: labels[index],
                                size: 13,
                                weight: FontWeight.w500,
                                color: isLocked
                                    ? Colors.grey
                                    : isSelected
                                        ? kPrimaryColor
                                        : kSecondaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Form content
              Builder(
                builder: (context) {
                  switch (controller.currentStep.value) {
                    case 0:
                      return _basicInfo();
                    case 1:
                      return _scanInfo();
                    case 2:
                      return _locationInfo();
                    default:
                      return _basicInfo();
                  }
                },
              ),
            ],
          ),
          
          // Loading overlay
          if (controller.isSavingStep.value)
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
          buttonText: controller.isSavingStep.value
              ? 'Saving...'
              : controller.currentStep.value == 2
                  ? 'Next to Target Audience'
                  : 'Next',
          onTap: controller.isSavingStep.value
              ? () {} // Disabled while saving
              : () async {
                  final currentStepBefore = controller.currentStep.value;
                  
                  await controller.goToNextStep();
                  
                  // Check if step changed (means validation passed)
                  if (controller.currentStep.value > currentStepBefore) {
                    // If we completed all 3 steps, go to target audience
                    if (controller.currentStep.value == 3) {
                      Get.to(() => TargetAudience());
                    }
                  }
                },
        ),
      ),
    ));
  }

  Column _basicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 30),
        MyTextField(
          controller: controller.titleController,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesTt, height: 20)],
          ),
          labelText: 'Discount Title',
          hintText: 'Weekend Flash Deal — 15% Off',
          isMandatory: true,
        ),
        MyTextField(
          controller: controller.descriptionController,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesTt, height: 20)],
          ),
          labelText: 'Description',
          hintText: 'Get 15% off your total bill this weekend only...',
          isMandatory: true,
        ),
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesProof, height: 20)],
          ),
          suffix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesUpload, height: 16)],
          ),
          labelText: 'Upload Banner/Image',
          hintText: controller.bannerFile.value?.path.split('/').last ?? 'Select image',
          isMandatory: false,
          isReadOnly: true,
          onTap: () => _pickImage('banner'),
        ),
        CustomDropDown(
          labelText: 'Offer Type',
          hint: 'Select offer type...',
          items: ['in-store', 'online'],
          selectedValue: controller.selectedOfferType.value,
          prefix: Image.asset(Assets.imagesTag, height: 20),
          onChanged: (v) => controller.selectedOfferType.value = v,
        ),
        MultiDropDown(
          labelText: 'Category / Tags',
          hint: 'E.g., Food & Drink, Shopping',
          isMandatory: false,
          items: _categories,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesTag, height: 20)],
          ),
          selectedValues: controller.selectedCategories,
          onTap: (String value) {
            if (controller.selectedCategories.contains(value)) {
              controller.selectedCategories.remove(value);
            } else {
              controller.selectedCategories.add(value);
            }
          },
        ),
        MyTextField(
          controller: controller.termsController,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Image.asset(Assets.imagesProof, height: 20)],
          ),
          maxLines: 4,
          labelText: 'Terms & Conditions',
          hintText: 'E.g., Valid for dine-in only. Not valid with other offers.',
          isMandatory: true,
        ),
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesCalendar, height: 20)],
          ),
          labelText: 'Start Date',
          hintText: controller.startDate.value?.toString().split(' ')[0] ?? 'Select date',
          isMandatory: true,
          isReadOnly: true,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 365)),
            );
            if (date != null) {
              controller.startDate.value = date;
            }
          },
        ),
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesCalendar, height: 20)],
          ),
          labelText: 'End Date',
          hintText: controller.endDate.value?.toString().split(' ')[0] ?? 'Select date',
          isMandatory: true,
          isReadOnly: true,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: controller.startDate.value ?? DateTime.now(),
              firstDate: controller.startDate.value ?? DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 365)),
            );
            if (date != null) {
              controller.endDate.value = date;
            }
          },
        ),
      ],
    );
  }

  Column _scanInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 30),
        CustomDropDown(
          labelText: 'Discount Type',
          hint: 'Select discount type',
          items: ['percentage', 'amount', 'buy_x_get_y'],
          selectedValue: controller.selectedDiscountType.value,
          prefix: Image.asset(Assets.imagesTag, height: 20),
          onChanged: (v) => controller.selectedDiscountType.value = v,
        ),
        MyTextField(
          controller: controller.redemptionUrlController,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesTag, height: 20)],
          ),
          labelText: 'Redemption URL',
          hintText: 'https://yourwebsite.com/redeem',
          isMandatory: false,
        ),
        MyTextField(
          controller: controller.couponCodeController,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesPoints, height: 20)],
          ),
          labelText: 'Coupon Code',
          hintText: 'SAVE15',
          isMandatory: false,
        ),
        MyTextField(
          controller: controller.redemptionLimitController,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesPoints, height: 20)],
          ),
          labelText: 'Redemption Limit',
          hintText: '100',
          isMandatory: false,
        ),
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesPoints, height: 20)],
          ),
          suffix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesUpload, height: 16)],
          ),
          labelText: 'QR Code',
          hintText: controller.qrCodeFile.value?.path.split('/').last ?? 'Select QR code',
          isMandatory: false,
          isReadOnly: true,
          onTap: () => _pickImage('qr'),
        ),
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesPoints, height: 20)],
          ),
          suffix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesUpload, height: 16)],
          ),
          labelText: 'Bar Code',
          hintText: controller.barCodeFile.value?.path.split('/').last ?? 'Select barcode',
          isMandatory: false,
          isReadOnly: true,
          onTap: () => _pickImage('barcode'),
        ),
      ],
    );
  }

  Column _locationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 30),
        if (controller.isLoadingLocations.value)
          Center(child: CircularProgressIndicator())
        else
          Builder(
            builder: (context) {
              final locationNames = controller.availableLocations
                  .map((loc) => loc['branchAddress'] as String? ?? 'Unknown')
                  .toList();
              
              if (locationNames.isEmpty) {
                return Column(
                  children: [
                    MyText(
                      text: 'No locations found. Please add a location first.',
                      size: 14,
                      color: Colors.red,
                    ),
                    SizedBox(height: 16),
                  ],
                );
              }
              
              return MultiDropDown(
            labelText: 'Branch / Outlet',
            hint: 'Select branch or outlet',
            isMandatory: true,
            items: locationNames,
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesTag, height: 20)],
            ),
            selectedValues: controller.selectedLocationIds
                .map((id) {
                  final loc = controller.availableLocations.firstWhere(
                    (l) => (l['_id'] ?? l['id']) == id,
                    orElse: () => {},
                  );
                  return loc['branchAddress'] as String? ?? '';
                })
                .where((name) => name.isNotEmpty)
                .toList(),
            onTap: (value) {
              // Find location ID by name
              final loc = controller.availableLocations.firstWhere(
                (l) => (l['branchAddress'] as String?) == value,
                orElse: () => {},
              );
              
              if (loc.isNotEmpty) {
                final locationId = loc['_id'] ?? loc['id'];
                if (controller.selectedLocationIds.contains(locationId)) {
                  controller.selectedLocationIds.remove(locationId);
                } else {
                  controller.selectedLocationIds.add(locationId);
                }
              }
            },
          );
        },
      ),
      ],
    );
  }
}

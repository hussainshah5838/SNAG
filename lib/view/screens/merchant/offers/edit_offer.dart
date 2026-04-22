import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/edit_offer_controller.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

class EditOffer extends StatefulWidget {
  @override
  State<EditOffer> createState() => _EditOfferState();
}

class _EditOfferState extends State<EditOffer> {
  final controller = Get.put(EditOfferController());
  final _picker = ImagePicker();
  
  int? selectedLabelIndex = 0;
  final List<String> labels = ["Basic Info", "Scan Info", "Location Info"];
  
  // Text controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final termsController = TextEditingController();
  final couponCodeController = TextEditingController();
  final redemptionUrlController = TextEditingController();
  final redemptionLimitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Get offerId from navigation arguments
    final offerId = Get.arguments as String?;
    if (offerId != null) {
      controller.loadOffer(offerId);
      controller.loadLocations();
      
      // Listen to controller changes and update text fields
      ever(controller.title, (value) => titleController.text = value);
      ever(controller.description, (value) => descriptionController.text = value);
      ever(controller.termsAndConditions, (value) => termsController.text = value);
      ever(controller.couponCode, (value) => couponCodeController.text = value ?? '');
      ever(controller.redemptionUrl, (value) => redemptionUrlController.text = value ?? '');
      ever(controller.redemptionLimit, (value) => redemptionLimitController.text = value?.toString() ?? '');
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    termsController.dispose();
    couponCodeController.dispose();
    redemptionUrlController.dispose();
    redemptionLimitController.dispose();
    Get.delete<EditOfferController>();
    super.dispose();
  }

  Future<void> _pickImage(String type) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      if (type == 'banner') {
        controller.bannerFile.value = file;
      } else if (type == 'qr') {
        controller.qrCodeFile.value = file;
      } else if (type == 'barcode') {
        controller.barCodeFile.value = file;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: '',
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {
                Get.dialog(_deleteDialog());
              },
              child: Image.asset(Assets.imagesTrash, height: 20),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.error.value != null) {
          return Center(
            child: MyText(
              text: 'Error: ${controller.error.value}',
              color: Colors.red,
            ),
          );
        }

        return ListView(
          shrinkWrap: true,
          padding: AppSizes.DEFAULT,
          physics: BouncingScrollPhysics(),
          children: [
            MyText(
              text: "Edit Offer",
              size: 24,
              weight: FontWeight.w600,
              paddingBottom: 4,
            ),
            MyText(
              text: "Edit your offer to attract customers and boost redemptions",
              size: 16,
              lineHeight: 1.5,
              weight: FontWeight.w500,
              color: kQuaternaryColor,
              paddingBottom: 30,
            ),
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
                  final isSelected = selectedLabelIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedLabelIndex = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? kSecondaryColor : kLightBlueColor2,
                        border: Border.all(color: kBlueBorderColor),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: MyText(
                          text: labels[index],
                          size: 13,
                          weight: FontWeight.w500,
                          color: isSelected ? kPrimaryColor : kSecondaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            selectedLabelIndex == 0
                ? _basicInfo()
                : selectedLabelIndex == 1
                ? _scanInfo()
                : _locationInfo(),
          ],
        );
      }),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: Obx(() {
          final isDraft = controller.status.value == 'draft';
          
          return isDraft
              ? Row(
                  children: [
                    Expanded(
                      child: MyButton(
                        buttonText: controller.isSaving.value ? 'Saving...' : 'Save as Draft',
                        bgColor: kFillColor,
                        textColor: kSecondaryColor,
                        onTap: controller.isSaving.value ? () {} : () async {
                          final success = await controller.saveOffer(publishNow: false);
                          if (success) {
                            Get.back(result: true);
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: MyButton(
                        buttonText: controller.isSaving.value ? 'Publishing...' : 'Publish Offer',
                        onTap: controller.isSaving.value ? () {} : () async {
                          final success = await controller.saveOffer(publishNow: true);
                          if (success) {
                            Get.back(result: true);
                          }
                        },
                      ),
                    ),
                  ],
                )
              : MyButton(
                  buttonText: controller.isSaving.value ? 'Saving...' : 'Save Changes',
                  onTap: controller.isSaving.value ? () {} : () async {
                    final success = await controller.saveOffer(publishNow: false);
                    if (success) {
                      Get.back(result: true);
                    }
                  },
                );
        }),
      ),
    );
  }

  Column _basicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 30),
        MyTextField(
          controller: titleController,
          onChanged: (v) => controller.title.value = v,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesTt, height: 20)],
          ),
          labelText: 'Offer Title',
          hintText: 'Weekend Flash Deal — 15% Off',
          isMandatory: true,
        ),
        MyTextField(
          controller: descriptionController,
          onChanged: (v) => controller.description.value = v,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesTt, height: 20)],
          ),
          labelText: 'Description',
          hintText: 'Describe your offer...',
          isMandatory: true,
        ),
        MyTextField(
          controller: termsController,
          onChanged: (v) => controller.termsAndConditions.value = v,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesProof, height: 20)],
          ),
          labelText: 'Terms and Conditions',
          hintText: 'Enter terms...',
          isMandatory: true,
        ),
        Obx(() => MyTextField(
          onTap: () => _pickImage('banner'),
          isReadOnly: true,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesProof, height: 20)],
          ),
          suffix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesUpload, height: 16)],
          ),
          labelText: 'Upload Banner/Image',
          hintText: controller.bannerFile.value != null 
              ? controller.bannerFile.value!.path.split('/').last
              : controller.bannerUrl.value != null
                  ? 'Current banner uploaded'
                  : 'Tap to upload',
          isMandatory: true,
        )),
        Obx(() => CustomDropDown(
          labelText: 'Offer Type',
          hint: 'Select offer type...',
          items: ['in-store', 'online'],
          selectedValue: controller.offerType.value,
          prefix: Image.asset(Assets.imagesTag, height: 20),
          onChanged: (v) => controller.offerType.value = v,
        )),
        Obx(() => MultiDropDown(
          labelText: 'Categories',
          hint: 'Select categories...',
          isMandatory: true,
          items: ['Shopping', 'Food & Drink', 'Entertainment', 'Beauty & Wellness', 'Services'],
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesTag, height: 20)],
          ),
          selectedValues: controller.categories.toList(),
          onTap: (value) {
            if (controller.categories.contains(value)) {
              controller.categories.remove(value);
            } else {
              controller.categories.add(value);
            }
          },
        )),
        Obx(() => CustomDropDown(
          labelText: 'Status',
          hint: 'Select status...',
          items: ['active', 'expired', 'scheduled', 'draft'],
          selectedValue: controller.status.value,
          prefix: Image.asset(Assets.imagesTag, height: 20),
          onChanged: (v) => controller.status.value = v,
        )),
      ],
    );
  }

  Column _scanInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 30),
        Obx(() => CustomDropDown(
          labelText: 'Discount Type',
          hint: 'Select discount type...',
          items: ['percentage', 'amount', 'buy-x-get-y'],
          selectedValue: controller.discountType.value ?? 'percentage',
          prefix: Image.asset(Assets.imagesTag, height: 20),
          onChanged: (v) => controller.discountType.value = v,
        )),
        MyTextField(
          controller: redemptionLimitController,
          onChanged: (v) => controller.redemptionLimit.value = int.tryParse(v),
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesPoints, height: 20)],
          ),
          labelText: 'Redemption Limit',
          hintText: '100',
          isMandatory: true,
        ),
        MyTextField(
          controller: couponCodeController,
          onChanged: (v) => controller.couponCode.value = v,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesPoints, height: 20)],
          ),
          labelText: 'Coupon Code',
          hintText: 'SAVE15',
          isMandatory: true,
        ),
        MyTextField(
          controller: redemptionUrlController,
          onChanged: (v) => controller.redemptionUrl.value = v,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesPoints, height: 20)],
          ),
          labelText: 'Redemption URL',
          hintText: 'https://example.com/redeem',
          isMandatory: true,
        ),
        Obx(() => MyTextField(
          onTap: () => _pickImage('qr'),
          isReadOnly: true,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesPoints, height: 20)],
          ),
          suffix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesUpload, height: 16)],
          ),
          labelText: 'QR Code',
          hintText: controller.qrCodeFile.value != null 
              ? controller.qrCodeFile.value!.path.split('/').last
              : controller.qrCodeUrl.value != null
                  ? 'Current QR code uploaded'
                  : 'Tap to upload',
          isMandatory: true,
        )),
        Obx(() => MyTextField(
          onTap: () => _pickImage('barcode'),
          isReadOnly: true,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesPoints, height: 20)],
          ),
          suffix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesUpload, height: 16)],
          ),
          labelText: 'Bar Code',
          hintText: controller.barCodeFile.value != null 
              ? controller.barCodeFile.value!.path.split('/').last
              : controller.barCodeUrl.value != null
                  ? 'Current barcode uploaded'
                  : 'Tap to upload',
          isMandatory: true,
        )),
      ],
    );
  }

  Column _locationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 30),
        Obx(() {
          final locations = controller.availableLocations
              .map((e) => e['branchAddress'] as String? ?? e['address'] as String? ?? 'Unknown Location')
              .toList();
          final selectedNames = controller.availableLocations
              .where((e) => controller.locationIds.contains(e['_id']))
              .map((e) => e['branchAddress'] as String? ?? e['address'] as String? ?? 'Unknown Location')
              .toList();
          
          return MultiDropDown(
            labelText: 'Branch / Outlet',
            hint: 'Select branch or outlet',
            isMandatory: true,
            items: locations,
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesTag, height: 20)],
            ),
            selectedValues: selectedNames,
            onTap: (value) {
              final location = controller.availableLocations.firstWhere(
                (e) => (e['branchAddress'] as String? ?? e['address'] as String? ?? 'Unknown Location') == value,
                orElse: () => {},
              );
              final locationId = location['_id'] as String?;
              if (locationId != null) {
                if (controller.locationIds.contains(locationId)) {
                  controller.locationIds.remove(locationId);
                } else {
                  controller.locationIds.add(locationId);
                }
              }
            },
          );
        }),
      ],
    );
  }

  Widget _deleteDialog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
            margin: AppSizes.DEFAULT,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kFillColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: kBorderColor, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(Assets.imagesDeleteProfile, height: 48),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, right: 4),
                        child: Image.asset(Assets.imagesCloseIcon, height: 14),
                      ),
                    ),
                  ],
                ),
                MyText(
                  paddingTop: 16,
                  text: 'Delete Offer?',
                  size: 20,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                MyText(
                  text: 'Are you sure you want to delete this offer? This action cannot be undone.',
                  size: 15,
                  lineHeight: 1.5,
                  weight: FontWeight.w500,
                  color: kQuaternaryColor,
                  paddingBottom: 24,
                ),
                MyButton(
                  height: 42,
                  buttonText: 'Delete Offer',
                  onTap: () async {
                    Get.back(); // Close dialog
                    final success = await controller.deleteOffer();
                    if (success) {
                      // Navigate back with 'deleted' signal
                      Get.back(result: 'deleted'); // Close edit screen
                    }
                  },
                ),
                SizedBox(height: 12),
                MyBorderButton(
                  borderColor: kGreyColor2,
                  height: 42,
                  buttonText: 'Cancel',
                  onTap: () => Get.back(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

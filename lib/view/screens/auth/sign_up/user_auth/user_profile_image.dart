import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/client_onboarding_controller.dart';
import 'package:snag/view/screens/auth/sign_up/user_auth/user_all_set.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class UserProfileImage extends StatefulWidget {
  const UserProfileImage({super.key});

  @override
  State<UserProfileImage> createState() => _UserProfileImageState();
}

class _UserProfileImageState extends State<UserProfileImage> {
  File? _imageFile;
  final _ctrl = ClientOnboardingController.instance;

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
    Get.back(); // close bottom sheet
  }

  Future<void> _onDone() async {
    if (_imageFile == null) {
      // No image selected — skip avatar, go to all set
      Get.to(() => UserAllSet());
      return;
    }

    final success = await _ctrl.uploadAvatar(imageFile: _imageFile!);
    if (success) {
      Get.to(() => UserAllSet());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_ctrl.errorMsg.value),
          backgroundColor: kRedColor,
        ),
      );
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        Widget imageRow({
          required String asset,
          required String title,
          required VoidCallback onTap,
        }) {
          return GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Image.asset(asset, height: 24),
                SizedBox(width: 12),
                Expanded(
                  child: MyText(text: title, size: 16, weight: FontWeight.w500),
                ),
              ],
            ),
          );
        }

        return Container(
          height: 240,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 35),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: Image.asset(Assets.imagesHandle, width: 40)),
              SizedBox(height: 13),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(Assets.imagesCloseIcon, height: 14, color: Colors.transparent),
                  MyText(text: 'Upload', size: 20, weight: FontWeight.w600),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Image.asset(Assets.imagesCloseIcon, height: 14),
                  ),
                ],
              ),
              SizedBox(height: 30),
              imageRow(
                asset: Assets.imagesUploadFile,
                title: 'Upload From Files',
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              SizedBox(height: 30),
              imageRow(
                asset: Assets.imagesGallery,
                title: 'Upload From Gallery',
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              SizedBox(height: 20),
              imageRow(
                asset: Assets.imagesTakePhoto,
                title: 'Take a Photo',
                onTap: () => _pickImage(ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        actions: [
          Center(
            child: MyText(
              text: 'Skip',
              size: 18,
              paddingRight: 20,
              color: kSecondaryColor,
              weight: FontWeight.w600,
              onTap: () => Get.to(() => UserAllSet()),
            ),
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          MyText(
            text: 'Profile Picture',
            paddingTop: 8,
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text: 'Add a photo so people can recognize you and connect instantly.',
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 80,
          ),
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Show picked image or placeholder
                ClipOval(
                  child: _imageFile != null
                      ? Image.file(_imageFile!,
                          height: 200, width: 200, fit: BoxFit.cover)
                      : Image.asset(Assets.imagesAvatar,
                          height: 200, width: 200, fit: BoxFit.cover),
                ),
                Positioned(
                  bottom: 10,
                  right: 20,
                  child: GestureDetector(
                    onTap: _showImagePicker,
                    child: Image.asset(Assets.imagesEdit, height: 32),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: Obx(() => MyButton(
          buttonText: 'Done',
          onTap: _ctrl.isLoading.value ? () {} : _onDone,
          customChild: _ctrl.isLoading.value
              ? SizedBox(
                  height: 22, width: 22,
                  child: CircularProgressIndicator(
                      color: kPrimaryColor, strokeWidth: 2.5),
                )
              : null,
        )),
      ),
    );
  }
}

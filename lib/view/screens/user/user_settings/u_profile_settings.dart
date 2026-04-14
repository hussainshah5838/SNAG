import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/client_profile_controller.dart';
import 'package:snag/main.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

class UProfileSettings extends StatefulWidget {
  const UProfileSettings({super.key});

  @override
  State<UProfileSettings> createState() => _UProfileSettingsState();
}

class _UProfileSettingsState extends State<UProfileSettings> {
  final ImagePicker _picker = ImagePicker();
  late final ClientProfileController _profileController;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<ClientProfileController>()) {
      _profileController = Get.put(ClientProfileController());
    } else {
      _profileController = ClientProfileController.instance;
      if (_profileController.profile.value == null && !_profileController.isLoading.value) {
        _profileController.loadProfile();
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        final File imageFile = File(image.path);
        await _profileController.updateAvatar(imageFile);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          MyText(
            text: 'Profile Settings',
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text: 'Edit your profile settings such as picture and preferences.',
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 80,
          ),
          Obx(() {
            final avatarUrl = _profileController.avatarUrl;
            final isLoading = _profileController.isLoading.value;

            return Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  if (isLoading)
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: kFillColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                    CommonImageView(
                      url: avatarUrl ?? dummyImg,
                      height: 200,
                      width: 200,
                      radius: 100,
                      fit: BoxFit.cover,
                    ),
                  Positioned(
                    bottom: 10,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
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
                                      child: MyText(
                                        text: title,
                                        size: 16,
                                        weight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return Container(
                              height: 240,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 35,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: Image.asset(
                                      Assets.imagesHandle,
                                      width: 40,
                                    ),
                                  ),
                                  SizedBox(height: 13),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                        Assets.imagesCloseIcon,
                                        height: 14,
                                        color: Colors.transparent,
                                      ),
                                      MyText(
                                        text: 'Upload',
                                        size: 20,
                                        weight: FontWeight.w600,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Image.asset(
                                          Assets.imagesCloseIcon,
                                          height: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30),
                                  imageRow(
                                    asset: Assets.imagesUploadFile,
                                    title: 'Upload From Files',
                                    onTap: () {
                                      Get.back();
                                      _pickImage(ImageSource.gallery);
                                    },
                                  ),
                                  SizedBox(height: 30),
                                  imageRow(
                                    asset: Assets.imagesGallery,
                                    title: 'Upload From Gallery',
                                    onTap: () {
                                      Get.back();
                                      _pickImage(ImageSource.gallery);
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  imageRow(
                                    asset: Assets.imagesTakePhoto,
                                    title: 'Take a Photo',
                                    onTap: () {
                                      Get.back();
                                      _pickImage(ImageSource.camera);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Image.asset(Assets.imagesEdit, height: 32),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: MyButton(
          buttonText: 'Done',
          onTap: () {
            Get.back();
          },
        ),
      ),
    );
  }
}

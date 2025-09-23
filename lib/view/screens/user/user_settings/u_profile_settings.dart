import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/main.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UProfileSettings extends StatelessWidget {
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
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CommonImageView(
                  url: dummyImg,
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
                                    // Handle gallery upload
                                    Get.back();
                                  },
                                ),
                                SizedBox(height: 30),
                                imageRow(
                                  asset: Assets.imagesGallery,
                                  title: 'Upload From Gallery',
                                  onTap: () {
                                    // Handle gallery upload
                                    Get.back();
                                  },
                                ),
                                SizedBox(height: 20),
                                imageRow(
                                  asset: Assets.imagesTakePhoto,
                                  title: 'Take a Photo',
                                  onTap: () {
                                    // Handle camera capture
                                    Get.back();
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
          ),
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

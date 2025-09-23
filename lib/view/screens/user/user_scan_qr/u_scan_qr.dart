import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/screens/user/user_scan_qr/u_scanned_item.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class UScanQr extends StatefulWidget {
  const UScanQr({super.key});

  @override
  State<UScanQr> createState() => _UScanQrState();
}

class _UScanQrState extends State<UScanQr> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            Assets.imagesDummyQr,
            height: Get.height,
            width: Get.width,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 55,
            right: 20,
            child: Image.asset(
              Assets.imagesSwitchCamera,
              height: 28,
              color: kPrimaryColor,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: AppSizes.DEFAULT,
              height: 66,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: kTertiaryColor.withValues(alpha: 0.18),
                    blurRadius: 12,
                    offset: Offset(1.7, 1.7),
                  ),
                ],
                color: kPrimaryColor,
                border: Border.all(width: 1.0, color: kBorderColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                        index == 1
                            ? showModalBottomSheet(
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
                                        },
                                      ),
                                      SizedBox(height: 30),
                                      imageRow(
                                        asset: Assets.imagesGallery,
                                        title: 'Upload From Gallery',
                                        onTap: () {
                                          Get.back();
                                          Get.to(() => UScannedItem());
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
                            )
                            : () {};
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: Image.asset(
                                index == 0
                                    ? Assets.imagesAutoFocus
                                    : index == 1
                                    ? Assets.imagesUpload
                                    : Assets.imagesFlash,
                                height: index == 1 ? 18 : 24,
                                color:
                                    _selectedIndex == index
                                        ? kSecondaryColor
                                        : kTertiaryColor,
                              ),
                            ),
                          ),
                          MyText(
                            paddingBottom: 8,
                            text:
                                index == 0
                                    ? 'Auto Focus'
                                    : index == 1
                                    ? 'Upload Image'
                                    : 'Flashlight On',
                            size: 12,
                            weight: FontWeight.w500,
                            color:
                                _selectedIndex == index
                                    ? kSecondaryColor
                                    : kTertiaryColor,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          Positioned(
            top: 1,
            right: 20,
            bottom: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: RotatedBox(
                quarterTurns: 3,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kTertiaryColor.withValues(alpha: 0.18),
                        blurRadius: 12,
                        offset: Offset(1.7, 1.7),
                      ),
                    ],
                    color: kPrimaryColor,
                    border: Border.all(color: kBorderColor),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  height: 50,
                  width: 300,
                  margin: AppSizes.ZERO,
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 2,
                            activeTrackColor: kSecondaryColor,
                            inactiveTrackColor: kLightBlueColor4,
                            trackShape: CustomTrackShape(),
                          ),
                          child: Slider(
                            value: _selectedIndex.toDouble(),
                            min: 0,
                            max: 100,
                            onChanged: (double value) {},
                            activeColor: kSecondaryColor,
                            inactiveColor: kTertiaryColor,
                          ),
                        ),
                      ),
                      Image.asset(Assets.imagesBrightness, height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

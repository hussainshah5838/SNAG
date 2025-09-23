import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({this.title, required this.child, this.height});

  final String? title;
  final Widget child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 55),
      height: height ?? Get.height * 0.5,
      width: Get.width,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: MyText(
                  text: title ?? '',
                  size: 16,
                  weight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Image.asset(Assets.imagesCloseIcon, height: 12),
              ),
            ],
          ),
          SizedBox(height: 24),
          Expanded(child: child),
        ],
      ),
    );
  }
}

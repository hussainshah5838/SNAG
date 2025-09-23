import 'package:flutter/material.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.icon,
    required this.title,
    this.subTitle,
    required this.buttonText,
    required this.onTap,
    this.iconSize,
    this.action,
    this.titleStyle,
    this.subTitleStyle,
  });

  final String icon;
  final String title;
  final String? subTitle;
  final String buttonText;
  final VoidCallback onTap;
  final double? iconSize;
  final Widget? action;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;

  @override
  Widget build(BuildContext context) {
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
              borderRadius: BorderRadius.circular(16),
              color: kPrimaryColor,
            ),
            child: Column(
              children: [
                Image.asset(icon, height: iconSize ?? 80),
                MyText(
                  paddingTop: 24,
                  textStyle: titleStyle ?? null,
                  textAlign: TextAlign.center,
                  text: title,
                  size: 24,
                  weight: FontWeight.w500,
                  paddingBottom: 4,
                ),
                if (subTitle!.isNotEmpty)
                  MyText(
                    textStyle: subTitleStyle ?? null,
                    textAlign: TextAlign.center,
                    text: subTitle ?? '',
                    color: kQuaternaryColor,
                    lineHeight: 1.5,
                    size: 13.50,
                    paddingBottom: 24,
                  ),
                action ?? MyButton(buttonText: buttonText, onTap: onTap),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomDialog2 extends StatelessWidget {
  final Widget child;
  final double? horizontalMargin, height;
  const CustomDialog2({
    super.key,
    required this.child,
    this.horizontalMargin = 32,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
            margin: AppSizes.DEFAULT,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: kPrimaryColor,
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}

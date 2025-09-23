import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import '../../constants/app_images.dart';

AppBar simpleAppBar({
  bool haveLeading = true,
  bool centerTitle = true,
  String? title,
  Color? bgColor,
  final Widget? leading,
  List<Widget>? actions,
  Color? leadingColor,
  Widget? titleWidget,
  VoidCallback? onLeadingTap,
}) {
  return AppBar(
    elevation: 0,
    backgroundColor: bgColor ?? Colors.transparent,
    automaticallyImplyLeading: false,
    centerTitle: centerTitle,
    titleSpacing: 0,
    leading:
        haveLeading
            ? leading ??
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: GestureDetector(
                        onTap: () {
                          if (onLeadingTap != null) {
                            onLeadingTap();
                          } else {
                            Get.back();
                          }
                        },
                        child: Image.asset(
                          Assets.imagesArrowBack,
                          height: 16,
                          color: leadingColor ?? null,
                        ),
                      ),
                    ),
                  ],
                )
            : null,
    title:
        titleWidget ??
        MyText(text: title ?? '', size: 16, weight: FontWeight.w600),
    actions: actions,
  );
}

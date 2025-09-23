import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_fonts.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/main.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UFeedback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: '',
        actions: [
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            constraints: BoxConstraints(minWidth: 48, maxWidth: 160),
            padding: EdgeInsets.zero,
            offset: Offset(0, 30),
            icon: Center(
              child: GestureDetector(
                onTap: () {},
                child: Image.asset(Assets.imagesMore, height: 28),
              ),
            ),
            onSelected: (value) {},
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    height: 30,
                    value: 'Share App',
                    child: Text(
                      'Share App',
                      style: TextStyle(
                        fontFamily: AppFonts.WORK_SANS,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    height: 30,
                    value: 'Send To Friends',
                    child: Text(
                      'Send To Friends',
                      style: TextStyle(
                        fontFamily: AppFonts.WORK_SANS,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
          ),

          SizedBox(width: 5),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          MyText(
            text: 'Tell us about your experience',
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text:
                'Congratulations, you have redeemed it, now tell about your experience.',
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          Center(
            child: CommonImageView(
              height: 200,
              width: 200,
              radius: 100,
              url: dummyImg,
              fit: BoxFit.cover,
              imagePath: Assets.imagesKfc,
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              Image.asset(Assets.imagesGood, height: 50),
              Image.asset(Assets.imagesBad, height: 50),
            ],
          ),
          SizedBox(height: 30),
          MyTextField(
            marginBottom: 30,
            labelText: 'Comment',
            hintText: 'Describe your experience',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesGps, height: 20)],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            MyBorderButton(buttonText: 'Share App', onTap: () {}),
            SizedBox(height: 12),
            MyButton(buttonText: 'Done', onTap: () {}),
          ],
        ),
      ),
    );
  }
}

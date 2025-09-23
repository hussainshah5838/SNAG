import 'package:expandable/expandable.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ContactSupport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: ''),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          MyText(
            text: 'Help & FAQ’s',
            paddingTop: 8,
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text: 'Have a question? Let us know. Our team will respond soon.',
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kFillColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 1.0, color: kBorderColor),
            ),
            child: Row(
              children: [
                Image.asset(
                  Assets.imagesEmailUs, // Replace with your image asset
                  height: 32,
                  width: 32,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: MyText(
                    text: 'Email us (Info@snag.com)',
                    size: 16,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _Faq(
            title: 'How do I add a new branch?',
            subTitle:
                'You can add a new branch from the Branches module in your dashboard.',
          ),
          _Faq(
            title:
                'What’s the difference between Store Offers and Online Offers?',
            subTitle:
                'Store Offers are available in physical locations, while Online Offers can be redeemed through the app or website.',
          ),
          _Faq(
            title: 'Can I manage multiple branches under one account?',
            subTitle:
                'Yes, you can manage multiple branches under a single account for easier administration.',
          ),
          _Faq(
            title: 'How do payouts work?',
            subTitle:
                'Payouts are processed according to your selected payment method and schedule. You can view details in your account dashboard.',
          ),

          _Faq(
            title: 'Lorem ipsum dolor iust amet?',
            subTitle: 'Lorem ipsum dolor iust amet?',
          ),
          _Faq(
            title: 'Lorem ipsum dolor iust amet?',
            subTitle: 'Lorem ipsum dolor iust amet?',
          ),
          _Faq(
            title: 'Lorem ipsum dolor iust amet?',
            subTitle: 'Lorem ipsum dolor iust amet?',
          ),
          _Faq(
            title: 'Lorem ipsum dolor iust amet?',
            subTitle: 'Lorem ipsum dolor iust amet?',
          ),
        ],
      ),
    );
  }
}

class _Faq extends StatefulWidget {
  const _Faq({required this.title, required this.subTitle});
  final String title;
  final String subTitle;

  @override
  State<_Faq> createState() => _FaqState();
}

class _FaqState extends State<_Faq> {
  late ExpandableController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ExpandableController(initialExpanded: false);
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kFillColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1.0, color: kBorderColor),
      ),
      child: ExpandableNotifier(
        controller: _controller,
        child: ScrollOnExpand(
          child: ExpandablePanel(
            controller: _controller,
            theme: ExpandableThemeData(tapHeaderToExpand: true, hasIcon: false),
            header: Container(
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: MyText(
                      text: widget.title,
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                  ),
                  Image.asset(
                    _controller.expanded
                        ? Assets.imagesShrink
                        : Assets.imagesExpand,
                    height: 24,
                  ),
                ],
              ),
            ),
            collapsed: SizedBox(),
            expanded: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 1,
                  color: kBorderColor,
                ),
                MyText(
                  text: widget.subTitle,
                  weight: FontWeight.w500,
                  color: kQuaternaryColor,
                  lineHeight: 1.5,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

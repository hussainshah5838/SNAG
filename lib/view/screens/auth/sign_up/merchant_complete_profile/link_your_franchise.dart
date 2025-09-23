import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/main.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

class LinkYourFranchise extends StatefulWidget {
  @override
  State<LinkYourFranchise> createState() => LinkYourFranchiseState();
}

class LinkYourFranchiseState extends State<LinkYourFranchise> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: AppSizes.DEFAULT,
      physics: BouncingScrollPhysics(),
      children: [
        MyText(
          text: 'Link Your Franchise',
          paddingTop: 8,
          size: 24,
          weight: FontWeight.w600,
          paddingBottom: 8,
        ),
        MyText(
          text:
              'This helps users and admins see the proper hierarchy of your business.',
          size: 16,
          lineHeight: 1.5,
          weight: FontWeight.w500,
          color: kQuaternaryColor,
          paddingBottom: 30,
        ),
        ListView.builder(
          padding: AppSizes.ZERO,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (context, i) {
            final user = {
              "name": "KFC NYC",
              "distance": "Street ${100 + i}, Riverside Plaza, California",
            };
            return GestureDetector(
              onTap: () => setState(() => _selectedIndex = i),
              child: _FranchiseTile(
                user: user,
                isSelected: _selectedIndex == i,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _FranchiseTile extends StatelessWidget {
  const _FranchiseTile({
    super.key,
    required this.user,
    required this.isSelected,
  });

  final Map<String, String> user;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected ? kLightBlueColor : kFillColor,
        border: Border.all(
          color: isSelected ? kSecondaryColor : kBorderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          CommonImageView(
            url: dummyImg,
            height: 38,
            width: 38,
            fit: BoxFit.cover,
            radius: 100,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: user["name"] as String,
                  size: 16,
                  weight: FontWeight.w500,
                  paddingBottom: 4,
                ),
                MyText(
                  text: '${user["distance"]}',
                  size: 12,
                  color: kQuaternaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

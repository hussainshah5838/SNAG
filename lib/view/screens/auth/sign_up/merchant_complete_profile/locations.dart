import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/main.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

class Locations extends StatefulWidget {
  @override
  State<Locations> createState() => LocationsState();
}

class LocationsState extends State<Locations> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: AppSizes.DEFAULT,
      physics: BouncingScrollPhysics(),
      children: [
        MyText(
          text: 'Locations',
          paddingTop: 8,
          size: 24,
          weight: FontWeight.w600,
          paddingBottom: 8,
        ),
        MyText(
          text:
              'See your current added locations, enter next or add more branches.',
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
          itemCount: 1,
          itemBuilder: (context, i) {
            final user = {
              "name": "Harvest Haven Store",
              "distance": "Street 123, Riverside Plaza, California",
            };
            return GestureDetector(
              onTap: () => setState(() => _selectedIndex = i),
              child: _LocationTile(user: user, isSelected: false),
            );
          },
        ),
      ],
    );
  }
}

class _LocationTile extends StatelessWidget {
  const _LocationTile({required this.user, required this.isSelected});

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
          Image.asset(Assets.imagesArrowNext, height: 24),
        ],
      ),
    );
  }
}

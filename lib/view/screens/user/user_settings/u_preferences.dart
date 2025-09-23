import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UPreferences extends StatefulWidget {
  @override
  State<UPreferences> createState() => _UPreferencesState();
}

class _UPreferencesState extends State<UPreferences> {
  Set<int> _selectedIndices = {0};

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
            text: 'Preferences',
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text:
                'Choose interests to find the best deals for you, from food to beauty.',
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: AppSizes.ZERO,
            physics: BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 80,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 6,
            itemBuilder: (BuildContext context, int index) {
              final offers = [
                {'icon': Assets.imagesRetail, 'title': 'Retail'},
                {'icon': Assets.imagesSports, 'title': 'Sports'},
                {'icon': Assets.imagesBeauty, 'title': 'Beauty'},
                {'icon': Assets.imagesFoodDrink, 'title': 'Food & Drinks'},
                {'icon': Assets.imagesHealth, 'title': 'Health'},
                {'icon': Assets.imagesServices, 'title': 'Services'},
              ];
              final offer = offers[index];
              return _OfferCard(
                icon: offer['icon']!,
                title: offer['title']!,
                onTap: () {
                  setState(() {
                    if (_selectedIndices.contains(index)) {
                      _selectedIndices.remove(index);
                    } else {
                      _selectedIndices.add(index);
                    }
                  });
                },
                isSelected: _selectedIndices.contains(index),
              );
            },
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

class _OfferCard extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  const _OfferCard({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? kLightBlueColor : kFillColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? kSecondaryColor : kBorderColor,
            width: 1.0,
          ),
        ),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Image.asset(
                  icon,
                  height: 24,
                  color: isSelected ? kSecondaryColor : null,
                ),
              ],
            ),
            const SizedBox(height: 6),
            MyText(
              text: title,
              size: 16,
              color: isSelected ? kSecondaryColor : kTertiaryColor,
              weight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}

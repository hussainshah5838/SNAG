import 'package:get/get.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/controllers/client_onboarding_controller.dart';
import 'package:snag/controllers/industry_controller.dart';
import 'package:snag/view/screens/auth/sign_up/user_auth/user_profile_image.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class DiscoverOffers extends StatefulWidget {
  const DiscoverOffers({super.key});

  @override
  State<DiscoverOffers> createState() => _DiscoverOffersState();
}

class _DiscoverOffersState extends State<DiscoverOffers> {
  final Set<int> _selectedIndices = {};

  final _ctrl         = ClientOnboardingController.instance;
  final _industryCtrl = IndustryController.instance;

  Future<void> _onNext() async {
    if (_selectedIndices.isEmpty) {
      Get.snackbar('Error', 'Please select at least one interest',
          backgroundColor: kRedColor, colorText: kPrimaryColor);
      return;
    }

    final selected = _selectedIndices
        .map((i) => _industryCtrl.industries[i])
        .toList();

    final success = await _ctrl.saveInterests(interests: selected);
    if (success) {
      Get.to(() => UserProfileImage());
    } else {
      Get.snackbar('Error', _ctrl.errorMsg.value,
          backgroundColor: kRedColor, colorText: kPrimaryColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(leadingColor: kPrimaryColor),
      backgroundColor: kSecondaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [Image.asset(Assets.imagesLogo, height: 100)],
            ),
          ),
          Container(
            height: Get.height * 0.7,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                MyText(
                  text: 'Skip',
                  paddingTop: 8,
                  size: 18,
                  textAlign: TextAlign.end,
                  color: kSecondaryColor,
                  weight: FontWeight.w600,
                  paddingBottom: 16,
                  onTap: () => Get.to(() => UserProfileImage()),
                ),
                MyText(
                  text: 'Discover Offers',
                  paddingTop: 8,
                  size: 24,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                MyText(
                  text:
                      'Choose interests to find the best offers for you, from food to beauty.',
                  size: 16,
                  lineHeight: 1.5,
                  weight: FontWeight.w500,
                  color: kQuaternaryColor,
                  paddingBottom: 30,
                ),
                Obx(() {
                  final industries = _industryCtrl.industries;
                  return GridView.builder(
                    shrinkWrap: true,
                    padding: AppSizes.ZERO,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 80,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: industries.length,
                    itemBuilder: (BuildContext context, int index) {
                      // Icon map — fallback to a default if industry not in map
                      final iconMap = {
                        'Retail':       Assets.imagesRetail,
                        'Sports':       Assets.imagesSports,
                        'Beauty':       Assets.imagesBeauty,
                        'Food & Drinks': Assets.imagesFoodDrink,
                        'Health':       Assets.imagesHealth,
                        'Services':     Assets.imagesServices,
                      };
                      final title = industries[index];
                      final icon  = iconMap[title] ?? Assets.imagesCategory;
                      return _OfferCard(
                        icon: icon,
                        title: title,
                        isSelected: _selectedIndices.contains(index),
                        onTap: () => setState(() {
                          _selectedIndices.contains(index)
                              ? _selectedIndices.remove(index)
                              : _selectedIndices.add(index);
                        }),
                      );
                    },
                  );
                }),
                SizedBox(height: 40),
                Obx(() => MyButton(
                  buttonText: 'Next',
                  onTap: _ctrl.isLoading.value ? () {} : _onNext,
                  customChild: _ctrl.isLoading.value
                      ? SizedBox(
                          height: 22, width: 22,
                          child: CircularProgressIndicator(
                              color: kPrimaryColor, strokeWidth: 2.5),
                        )
                      : null,
                )),
              ],
            ),
          ),
        ],
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

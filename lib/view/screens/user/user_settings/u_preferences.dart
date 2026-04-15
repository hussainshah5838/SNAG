import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/client_profile_controller.dart';
import 'package:snag/controllers/industry_controller.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

class UPreferences extends StatefulWidget {
  const UPreferences({super.key});

  @override
  State<UPreferences> createState() => _UPreferencesState();
}

class _UPreferencesState extends State<UPreferences> {
  Set<String> _selectedInterests = {};
  late final ClientProfileController _profileController;
  late final IndustryController _industryController;

  @override
  void initState() {
    super.initState();
    // Initialize profile controller
    if (!Get.isRegistered<ClientProfileController>()) {
      _profileController = Get.put(ClientProfileController());
    } else {
      _profileController = ClientProfileController.instance;
      if (_profileController.profile.value == null && !_profileController.isLoading.value) {
        _profileController.loadProfile();
      }
    }

    // Initialize industry controller
    if (!Get.isRegistered<IndustryController>()) {
      _industryController = Get.put(IndustryController());
    } else {
      _industryController = IndustryController.instance;
      if (_industryController.industries.isEmpty && !_industryController.isLoading.value) {
        _industryController.fetchIndustries();
      }
    }

    // Load current interests
    _selectedInterests = Set.from(_profileController.interests);
  }

  Future<void> _savePreferences() async {
    if (_selectedInterests.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select at least one interest',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final success = await _profileController.updateInterests(
      _selectedInterests.toList(),
    );

    if (success) {
      Get.back();
    }
  }

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
          Obx(() {
            final industries = _industryController.industries;
            final isLoading = _profileController.isLoading.value ||
                _industryController.isLoading.value;

            if (isLoading && industries.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }

            if (industries.isEmpty) {
              return Center(
                child: MyText(
                  text: 'No categories available',
                  size: 16,
                  color: kQuaternaryColor,
                ),
              );
            }

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
                final industry = industries[index];
                final isSelected = _selectedInterests.contains(industry);

                return _OfferCard(
                  icon: _getIconForIndustry(industry),
                  title: industry,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedInterests.remove(industry);
                      } else {
                        _selectedInterests.add(industry);
                      }
                    });
                  },
                  isSelected: isSelected,
                );
              },
            );
          }),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: Obx(() {
          final isLoading = _profileController.isLoading.value;
          return MyButton(
            buttonText: isLoading ? 'Saving...' : 'Done',
            onTap: isLoading ? () {} : () => _savePreferences(),
          );
        }),
      ),
    );
  }

  String _getIconForIndustry(String industry) {
    switch (industry.toLowerCase()) {
      case 'retail':
        return Assets.imagesRetail;
      case 'sports':
        return Assets.imagesSports;
      case 'beauty':
        return Assets.imagesBeauty;
      case 'food & drinks':
      case 'food & beverages':
        return Assets.imagesFoodDrink;
      case 'health':
        return Assets.imagesHealth;
      case 'services':
        return Assets.imagesServices;
      case 'technology':
        return Assets.imagesServices; // Use services icon for technology
      default:
        return Assets.imagesServices;
    }
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

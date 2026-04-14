import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/merchant_onboarding_controller.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class Locations extends StatefulWidget {
  @override
  State<Locations> createState() => LocationsState();
}

class LocationsState extends State<Locations> {
  final _ctrl = MerchantOnboardingController.instance;

  @override
  void initState() {
    super.initState();
    // fetchLocations is called from CompleteProfile when step 4 is reached
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_ctrl.isFetchingLocations.value) {
        return Center(child: CircularProgressIndicator(color: kSecondaryColor));
      }

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
            text: 'See your current added locations, enter next or add more branches.',
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          if (_ctrl.locations.isEmpty)
            MyText(
              text: 'No locations added yet.',
              size: 14,
              color: kQuaternaryColor,
              textAlign: TextAlign.center,
              paddingTop: 40,
            ),
          ...(_ctrl.locations.map((loc) => _LocationTile(location: loc))),
        ],
      );
    });
  }
}

class _LocationTile extends StatelessWidget {
  const _LocationTile({required this.location});
  final Map<String, dynamic> location;

  @override
  Widget build(BuildContext context) {
    final name    = location['branchAddress'] as String? ?? 'Branch';
    final address = location['address'] as String? ?? '';

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kFillColor,
        border: Border.all(color: kBorderColor, width: 1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: kLightBlueColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_on, color: kSecondaryColor, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(text: name, size: 16, weight: FontWeight.w500, paddingBottom: 4),
                MyText(text: address, size: 12, color: kQuaternaryColor),
              ],
            ),
          ),
          Image.asset(Assets.imagesArrowNext, height: 24),
        ],
      ),
    );
  }
}

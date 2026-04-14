import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/merchant_onboarding_controller.dart';
import 'package:snag/main.dart';
import 'package:snag/view/screens/merchant/settings/locations/add_new_business_location.dart';
import 'package:snag/view/screens/merchant/settings/locations/business_location_details.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

class BusinessLocations extends StatefulWidget {
  @override
  State<BusinessLocations> createState() => _BusinessLocationsState();
}

class _BusinessLocationsState extends State<BusinessLocations> {
  final _controller = Get.put(MerchantOnboardingController());

  @override
  void initState() {
    super.initState();
    _controller.fetchLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: '',
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {
                Get.to(() => AddNewBusinessLocation());
              },
              child: Image.asset(Assets.imagesAddIcon, height: 32),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Obx(() {
        final isLoading = _controller.isFetchingLocations.value;
        final locations = _controller.locations;
        final errorMsg = _controller.errorMsg.value;

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
              text: 'Add, edit, and manage all your locations.',
              size: 16,
              lineHeight: 1.5,
              weight: FontWeight.w500,
              color: kQuaternaryColor,
              paddingBottom: 30,
            ),
            if (isLoading)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: CircularProgressIndicator(color: kSecondaryColor),
                ),
              )
            else if (errorMsg.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: MyText(
                    text: errorMsg,
                    color: Colors.red,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else if (locations.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: MyText(
                    text: 'No locations added yet',
                    color: kQuaternaryColor,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ListView.builder(
                padding: AppSizes.ZERO,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: locations.length,
                itemBuilder: (context, i) {
                  final location = locations[i];
                  return GestureDetector(
                    onTap: () {
                      // Backend may return different field names for ID depending on the API
                      // _id: MongoDB default, id: some APIs, locationId: explicit field
                      final locationId = location['_id'] as String? ?? 
                                        location['id'] as String? ??
                                        location['locationId'] as String?;
                      if (locationId != null) {
                        Get.to(() => LocationDetails(locationId: locationId));
                      }
                    },
                    child: _LocationTile(location: location, isSelected: false),
                  );
                },
              ),
          ],
        );
      }),
    );
  }
}

class _LocationTile extends StatelessWidget {
  const _LocationTile({required this.location, required this.isSelected});

  final Map<String, dynamic> location;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final branchAddress = location['branchAddress'] as String? ?? 'No address';
    final address = location['address'] as String? ?? '';
    final state = location['state'] as String? ?? '';
    final country = location['country'] as String? ?? '';
    final bannerUrl = location['bannerUrl'] as String?;
    
    final fullAddress = address.isEmpty && state.isEmpty && country.isEmpty
        ? 'Address not available'
        : '$address${address.isNotEmpty ? ", " : ""}$state${state.isNotEmpty ? ", " : ""}$country';

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
            url: bannerUrl ?? dummyImg,
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
                  text: branchAddress,
                  size: 15,
                  weight: FontWeight.w600,
                  paddingBottom: 4,
                ),
                MyText(
                  text: fullAddress,
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

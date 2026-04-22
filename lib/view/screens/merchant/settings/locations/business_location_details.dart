import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/merchant_onboarding_controller.dart';
import 'package:snag/services/merchant_onboarding_service.dart';
import 'package:snag/main.dart';
import 'package:snag/view/screens/merchant/settings/locations/edit_business_location.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

class LocationDetails extends StatefulWidget {
  final String locationId;
  
  const LocationDetails({super.key, required this.locationId});

  @override
  State<LocationDetails> createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
  final _service = MerchantOnboardingService.instance;
  bool _isLoading = true;
  String _errorMsg = '';
  Map<String, dynamic>? _locationData;

  @override
  void initState() {
    super.initState();
    _fetchLocationDetails();
  }

  Future<void> _fetchLocationDetails() async {
    setState(() {
      _isLoading = true;
      _errorMsg = '';
    });

    final result = await _service.getLocationById(widget.locationId);
    
    result
        .onSuccess((data) {
          setState(() {
            _locationData = data;
            _isLoading = false;
          });
        })
        .onFailure((e) {
          setState(() {
            _errorMsg = e.message;
            _isLoading = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: '',
        actions: [
          Center(
            child: MyText(
              onTap: () {
                if (_locationData != null) {
                  Get.to(() => EditBusinessLocation(
                    locationId: widget.locationId,
                    locationData: _locationData!,
                  ));
                }
              },
              text: 'Edit',
              size: 16,
              weight: FontWeight.w600,
              paddingRight: 20,
              color: kQuaternaryColor,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: kSecondaryColor))
          : _errorMsg.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: AppSizes.DEFAULT,
                    child: MyText(
                      text: _errorMsg,
                      color: Colors.red,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : _locationData == null
                  ? Center(child: MyText(text: 'No data found'))
                  : ListView(
                      shrinkWrap: true,
                      padding: AppSizes.DEFAULT,
                      physics: BouncingScrollPhysics(),
                      children: [
                        MyText(
                          text: _locationData!['branchAddress'] as String? ?? 'No name',
                          paddingTop: 8,
                          size: 24,
                          weight: FontWeight.w600,
                          paddingBottom: 8,
                        ),
                        MyText(
                          text: '${_locationData!['address'] ?? 'N/A'}, ${_locationData!['state'] ?? 'N/A'}, ${_locationData!['country'] ?? 'N/A'}',
                          size: 16,
                          lineHeight: 1.5,
                          weight: FontWeight.w500,
                          color: kQuaternaryColor,
                          paddingBottom: 30,
                        ),
                        CommonImageView(
                          height: 366,
                          width: Get.width,
                          radius: 12,
                          fit: BoxFit.cover,
                          url: _locationData!['bannerUrl'] as String? ?? dummyImg,
                        ),
                        SizedBox(height: 20),
                        // Phone Number
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Image.asset(Assets.imagesContactNumber, height: 28),
                              Expanded(
                                child: MyText(
                                  paddingLeft: 10,
                                  text: _locationData!['branchInfo']?['phoneNumber'] as String? ?? 'N/A',
                                  size: 16,
                                  weight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Email
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Image.asset(Assets.imagesEmail, height: 28),
                              Expanded(
                                child: MyText(
                                  paddingLeft: 10,
                                  text: _locationData!['branchInfo']?['email'] as String? ?? 'N/A',
                                  size: 16,
                                  weight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Location Type
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Image.asset(Assets.imagesLocationType, height: 28),
                              Expanded(
                                child: MyText(
                                  paddingLeft: 10,
                                  text: (_locationData!['locationType'] as String? ?? 'N/A').toUpperCase(),
                                  size: 16,
                                  weight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
    );
  }
}

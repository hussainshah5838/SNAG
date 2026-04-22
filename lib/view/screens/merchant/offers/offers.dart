import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/merchant_offers_controller.dart';
import 'package:snag/main.dart';
import 'package:snag/view/screens/merchant/offers/add_new_offer/add_new_offer.dart';
import 'package:snag/view/screens/merchant/offers/offer_details.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/custom_bottom_sheet_widget.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

class Offers extends StatefulWidget {
  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  final controller = Get.put(MerchantOffersController());

  @override
  void initState() {
    super.initState();
    controller.fetchOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                try {
                  Get.to(() => AddNewOffer());
                } catch (e) {
                  // Handle navigation error
                }
              },
              child: Image.asset(Assets.imagesAddIcon, height: 32),
            ),
            SizedBox(width: 12),
            MyText(text: 'Add New Offer', size: 18, weight: FontWeight.w600),
          ],
        ),
      ),

      body: Obx(() {
        if (controller.isLoadingOffers.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.offersError.value != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(
                  text: 'Error: ${controller.offersError.value}',
                  color: Colors.red,
                ),
                SizedBox(height: 16),
                MyButton(
                  buttonText: 'Retry',
                  onTap: () => controller.fetchOffers(),
                ),
              ],
            ),
          );
        }

        return ListView(
          shrinkWrap: true,
          padding: AppSizes.DEFAULT,
          physics: BouncingScrollPhysics(),
          children: [
            MyText(
              text: 'Offers',
              size: 24,
              weight: FontWeight.w600,
              paddingBottom: 8,
            ),
            MyText(
              text: 'Create and manage special deals to attract more customers.',
              size: 16,
              lineHeight: 1.5,
              weight: FontWeight.w500,
              color: kQuaternaryColor,
              paddingBottom: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    try {
                      Get.bottomSheet(
                        _FilterBottomSheet(controller: controller),
                        isScrollControlled: true,
                      );
                    } catch (e) {
                      // Handle bottom sheet error
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: kSecondaryColor, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      spacing: 4,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(Assets.imagesFilterIcon, height: 16),
                        MyText(
                          text: 'Filters',
                          size: 16,
                          weight: FontWeight.w500,
                          color: kSecondaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            
            if (controller.offers.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: MyText(
                    text: 'No offers found. Create your first offer!',
                    size: 16,
                    color: kQuaternaryColor,
                  ),
                ),
              )
            else
              ListView.builder(
                padding: AppSizes.ZERO,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.offers.length,
                itemBuilder: (context, i) {
                  final offer = controller.offers[i];
                  return GestureDetector(
                    onTap: () async {
                      try {
                        final result = await Get.to(() => OfferDetails(), arguments: offer['_id']);
                        // Refresh list if offer was edited/deleted
                        if (result == true) {
                          controller.fetchOffers();
                        }
                      } catch (e) {
                        // Handle navigation error
                      }
                    },
                    child: _OfferTile(offer: offer, isSelected: false),
                  );
                },
              ),
          ],
        );
      }),
    );
  }
}

class _OfferTile extends StatelessWidget {
  const _OfferTile({required this.offer, required this.isSelected});

  final Map<String, dynamic> offer;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final title = offer['title'] as String? ?? 'Untitled Offer';
    final offerType = offer['offerType'] as String? ?? 'in-store';
    final bannerUrl = offer['bannerUrl'] as String?;
    final status = offer['status'] as String? ?? 'draft';
    final isDraft = status == 'draft';
    
    // Get first location name if available
    final locations = offer['locationIds'] as List<dynamic>?;
    String locationText = offerType == 'online' ? 'Online' : 'In-store';
    if (locations != null && locations.isNotEmpty) {
      final firstLocation = locations[0] as Map<String, dynamic>?;
      if (firstLocation != null) {
        final locationName = firstLocation['branchAddress'] as String? ?? firstLocation['address'] as String?;
        if (locationName != null) {
          locationText = '$locationName - ${offerType == 'online' ? 'Online' : 'In-store'}';
        }
      }
    }

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
                Row(
                  children: [
                    Expanded(
                      child: MyText(
                        text: title,
                        size: 15,
                        weight: FontWeight.w600,
                        paddingBottom: 4,
                      ),
                    ),
                    if (isDraft)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: MyText(
                          text: 'DRAFT',
                          size: 10,
                          weight: FontWeight.w600,
                          color: Colors.orange.shade700,
                        ),
                      ),
                  ],
                ),
                MyText(
                  text: locationText,
                  size: 12,
                  color: kQuaternaryColor,
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Image.asset(Assets.imagesMore, height: 24),
        ],
      ),
    );
  }
}

class _FilterBottomSheet extends StatefulWidget {
  final MerchantOffersController controller;

  const _FilterBottomSheet({required this.controller});

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  // Filter values
  String? _selectedOfferType;
  String? _selectedStatus;
  final _keywordController = TextEditingController();
  final _locationController = TextEditingController();
  final _merchantController = TextEditingController();
  final _dateRangeController = TextEditingController();
  
  // Multi-select lists
  List<String> _selectedKeywordsList = [];
  List<String> _selectedStatusesList = [];

  @override
  void dispose() {
    _keywordController.dispose();
    _locationController.dispose();
    _merchantController.dispose();
    _dateRangeController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    // Combine selected keywords into comma-separated string for category filter
    final categoryFilter = _selectedKeywordsList.isNotEmpty 
        ? _selectedKeywordsList.join(',') 
        : null;
    
    // Combine selected statuses
    final statusFilter = _selectedStatusesList.isNotEmpty 
        ? _selectedStatusesList.first 
        : null;
    
    widget.controller.fetchOffers(
      keyword: _keywordController.text.isNotEmpty ? _keywordController.text : null,
      location: _locationController.text.isNotEmpty ? _locationController.text : null,
      category: categoryFilter,
      offerType: _selectedOfferType,
      status: statusFilter,
      // TODO: Parse date range from _dateRangeController and pass startDate/endDate
    );
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _keywords = ['Buy 1 Get 1', 'Flash Deal', 'Discount %'];
    final List<String> _statuses = ['active', 'expired', 'scheduled', 'draft'];

    return CustomBottomSheet(
      title: 'Apply Filters',
      height: Get.height * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.ZERO,
              physics: BouncingScrollPhysics(),
              children: [
                MyTextField(
                  controller: _locationController,
                  labelText: 'Location',
                  hintText: 'Search city, area, or branch name...',
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(Assets.imagesLoc, height: 20)],
                  ),
                ),
                MyTextField(
                  controller: _merchantController,
                  labelText: 'Merchant / Brand Name',
                  hintText: 'Type merchant name...',
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(Assets.imagesMerchant, height: 20)],
                  ),
                ),
                MultiDropDown(
                  labelText: 'Keywords',
                  hint: 'Select offer type or category...',
                  isMandatory: false,
                  items: _keywords,
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(Assets.imagesKeywords, height: 20)],
                  ),
                  selectedValues: _selectedKeywordsList,
                  onTap: (String value) {
                    setState(() {
                      if (_selectedKeywordsList.contains(value)) {
                        _selectedKeywordsList.remove(value);
                      } else {
                        _selectedKeywordsList.add(value);
                      }
                    });
                  },
                ),
                CustomDropDown(
                  labelText: 'Offer Type',
                  hint: 'Select offer type or category...',
                  items: [
                    'All',
                    'in-store',
                    'online',
                  ],
                  selectedValue: _selectedOfferType ?? 'All',
                  prefix: Image.asset(Assets.imagesKeywords, height: 20),
                  onChanged: (v) {
                    setState(() {
                      _selectedOfferType = v == 'All' ? null : v;
                    });
                  },
                ),
                MultiDropDown(
                  labelText: 'Status',
                  hint: 'Select offer status e.g. Active, Expired',
                  isMandatory: false,
                  items: _statuses,
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(Assets.imagesTag, height: 20)],
                  ),
                  selectedValues: _selectedStatusesList,
                  onTap: (value) {
                    setState(() {
                      if (_selectedStatusesList.contains(value)) {
                        _selectedStatusesList.remove(value);
                      } else {
                        _selectedStatusesList.add(value);
                      }
                    });
                  },
                ),
                MyTextField(
                  controller: _dateRangeController,
                  labelText: 'Date Range',
                  hintText: 'Select start and end date...',
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(Assets.imagesCalendar, height: 20)],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: MyButton(
                  buttonText: 'Clear',
                  onTap: () {
                    setState(() {
                      _keywordController.clear();
                      _locationController.clear();
                      _merchantController.clear();
                      _dateRangeController.clear();
                      _selectedOfferType = null;
                      _selectedStatus = null;
                      _selectedKeywordsList.clear();
                      _selectedStatusesList.clear();
                    });
                    widget.controller.fetchOffers();
                    Get.back();
                  },
                  bgColor: kFillColor,
                  textColor: kSecondaryColor,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: MyButton(
                  buttonText: 'Apply',
                  onTap: _applyFilters,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/industry_controller.dart';
import 'package:snag/controllers/saved_offers_controller.dart';
import 'package:snag/main.dart';
import 'package:snag/view/screens/user/user_my_offers/u_offer_details.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/custom_bottom_sheet_widget.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UMyOffers extends StatefulWidget {
  @override
  State<UMyOffers> createState() => _UMyOffersState();
}

class _UMyOffersState extends State<UMyOffers> {
  SavedOffersController? _controller;
  IndustryController? _industryController;
  TextEditingController? _searchController;

  @override
  void initState() {
    super.initState();
    print('🚀 [MyOffers] initState called');
    
    _searchController = TextEditingController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🎯 [MyOffers] Getting controllers...');
      _controller = Get.put(SavedOffersController());
      _industryController = IndustryController.instance;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    print('🔍 [MyOffers] Search changed: $value');
    _controller?.setSearchKeyword(value);
  }

  void _onCategoryTap(String? category) {
    print('🏷️ [MyOffers] Category tapped: $category');
    _controller?.setCategory(category);
  }

  Future<void> _onRefresh() async {
    print('🔄 [MyOffers] Pull to refresh');
    await _controller?.refresh();
  }

  void _showUnsaveDialog(String offerId, String title) {
    Get.dialog(
      AlertDialog(
        title: Text('Remove Saved Offer'),
        content: Text('Are you sure you want to remove "$title" from saved offers?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await _controller?.unsaveOffer(offerId);
            },
            child: Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _industryController == null) {
      return Scaffold(
        appBar: simpleAppBar(title: '', haveLeading: false),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: simpleAppBar(
        title: '',
        haveLeading: false,
        titleWidget: Padding(
          padding: AppSizes.HORIZONTAL,
          child: MyTextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            labelText: 'Search',
            hintText: 'Search saved offers...',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesSearchIcon, height: 22)],
            ),
            suffix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      _FilterBottomSheet(controller: _controller!),
                      isScrollControlled: true,
                    );
                  },
                  child: Image.asset(Assets.imagesFilter, height: 22),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() => RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          shrinkWrap: true,
          padding: AppSizes.VERTICAL,
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            MyText(
              paddingLeft: 20,
              paddingRight: 20,
              text: "Saved Offers",
              size: 24,
              weight: FontWeight.w600,
              paddingBottom: 8,
            ),
            MyText(
              paddingLeft: 20,
              paddingRight: 20,
              text: "See your saved offers and get these deals now",
              size: 16,
              lineHeight: 1.5,
              weight: FontWeight.w500,
              color: kQuaternaryColor,
              paddingBottom: 30,
            ),
            
            // Category Tabs
            if (_industryController!.industries.isNotEmpty)
              SizedBox(
                height: 35,
                child: ListView(
                  padding: AppSizes.HORIZONTAL,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    _CategoryTab(
                      label: 'All',
                      isSelected: _controller!.selectedCategory.value == null,
                      onTap: () => _onCategoryTap(null),
                    ),
                    SizedBox(width: 10),
                    ..._industryController!.industries.map((industry) {
                      return Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: _CategoryTab(
                          label: industry,
                          isSelected: _controller!.selectedCategory.value == industry,
                          onTap: () => _onCategoryTap(industry),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            SizedBox(height: 14),

            // Loading State
            if (_controller!.isLoading.value)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ),
              ),

            // Error State
            if (!_controller!.isLoading.value && _controller!.errorMsg.value.isNotEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      SizedBox(height: 16),
                      MyText(
                        text: _controller!.errorMsg.value,
                        size: 14,
                        color: Colors.red,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: _onRefresh,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),

            // Empty State
            if (!_controller!.isLoading.value &&
                _controller!.errorMsg.value.isEmpty &&
                _controller!.filteredOffers.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Image.asset(Assets.imagesNoProfileFound, height: 120),
                      SizedBox(height: 16),
                      MyText(
                        text: 'No Saved Offers',
                        size: 18,
                        weight: FontWeight.w600,
                        paddingBottom: 8,
                      ),
                      MyText(
                        text: _controller!.hasFilters
                            ? 'No offers match your filters'
                            : 'Start saving offers to see them here',
                        size: 14,
                        color: kQuaternaryColor,
                        textAlign: TextAlign.center,
                      ),
                      if (_controller!.hasFilters) ...[
                        SizedBox(height: 16),
                        TextButton(
                          onPressed: () => _controller!.clearFilters(),
                          child: Text('Clear Filters'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

            // Offers List
            if (!_controller!.isLoading.value &&
                _controller!.errorMsg.value.isEmpty &&
                _controller!.filteredOffers.isNotEmpty)
              ListView.builder(
                padding: AppSizes.DEFAULT,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _controller!.filteredOffers.length,
                itemBuilder: (context, i) {
                  final offer = _controller!.filteredOffers[i];
                  return GestureDetector(
                    onTap: () {
                      print('🎯 [MyOffers] Navigating to offer: ${offer.id}');
                      Get.to(() => UOfferDetails(offer: offer));
                    },
                    child: _OfferTile(
                      offer: offer,
                      onUnsave: () => _showUnsaveDialog(offer.id, offer.title),
                    ),
                  );
                },
              ),
          ],
        ),
      )),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? kSecondaryColor : kLightBlueColor2,
          border: Border.all(color: kBlueBorderColor),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: MyText(
            text: label,
            size: 13,
            weight: FontWeight.w500,
            color: isSelected ? kPrimaryColor : kSecondaryColor,
          ),
        ),
      ),
    );
  }
}

class _OfferTile extends StatelessWidget {
  final dynamic offer;
  final VoidCallback onUnsave;

  const _OfferTile({
    required this.offer,
    required this.onUnsave,
  });

  @override
  Widget build(BuildContext context) {
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
          CommonImageView(
            url: offer.merchantLogo ?? dummyImg,
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
                  text: offer.title,
                  size: 15,
                  weight: FontWeight.w600,
                  paddingBottom: 4,
                ),
                MyText(
                  text: '${offer.merchantBrand ?? 'Merchant'} - "${offer.couponCode ?? 'No Code'}"',
                  size: 12,
                  color: kQuaternaryColor,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onUnsave,
            child: Image.asset(Assets.imagesMore, height: 24),
          ),
        ],
      ),
    );
  }
}

class _FilterBottomSheet extends StatefulWidget {
  final SavedOffersController controller;

  const _FilterBottomSheet({required this.controller});

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  List<String> _selectedStatusesList = [];
  List<String> _selectedKeywordsList = [];
  List<String> _selectedCategoriesList = [];

  @override
  Widget build(BuildContext context) {
    final List<String> _keywords = ['Buy 1 Get 1', 'Flash Deal', 'Discount %'];
    final List<String> _statuses = ['Active', 'Expired', 'Scheduled'];
    final List<String> _categories = ['Food', 'Clothing', 'Electronics'];

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
                MultiDropDown(
                  labelText: 'Offer Title / Keyword',
                  hint: 'Weekend Deal',
                  isMandatory: false,
                  items: _keywords,
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(Assets.imagesCity, height: 20)],
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
                  labelText: 'Offer Type ',
                  hint: 'Select offer type or category...',
                  items: ['Select offer type or category...', 'In Store'],
                  selectedValue: 'Select offer type or category...',
                  prefix: Image.asset(Assets.imagesTag, height: 20),
                  onChanged: (v) {},
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
                  labelText: 'Locations',
                  hintText: 'Add or Multi-select e.g. MM Alam, Gulberg, DHA',
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(Assets.imagesBankIcon, height: 20)],
                  ),
                ),

                MultiDropDown(
                  labelText: 'Category',
                  hint: 'Add or Multi-select e.g. Food, Clothing, Electronics',
                  isMandatory: false,
                  items: _categories,
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(Assets.imagesCity, height: 20)],
                  ),
                  selectedValues: _selectedCategoriesList,
                  onTap: (String value) {
                    setState(() {
                      if (_selectedCategoriesList.contains(value)) {
                        _selectedCategoriesList.remove(value);
                      } else {
                        _selectedCategoriesList.add(value);
                      }
                    });
                  },
                ),

                MyTextField(
                  labelText: 'Validity Date Range',
                  hintText: '17 July, 2025 - 17 August, 2025',
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(Assets.imagesCalendar, height: 20)],
                  ),
                ),
                MyTextField(
                  labelText: 'Redemption Count',
                  hintText: '20',
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(Assets.imagesRedCount, height: 20)],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          MyButton(buttonText: 'Done', onTap: () {
            Get.back();
          }),
        ],
      ),
    );
  }
}

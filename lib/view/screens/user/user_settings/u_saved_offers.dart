import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/industry_controller.dart';
import 'package:snag/controllers/saved_offers_controller.dart';
import 'package:snag/main.dart';
import 'package:snag/view/screens/merchant/offers/offer_details.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class USavedOffers extends StatefulWidget {
  const USavedOffers({Key? key}) : super(key: key);

  @override
  State<USavedOffers> createState() => _USavedOffersState();
}

class _USavedOffersState extends State<USavedOffers> {
  SavedOffersController? _controller;
  IndustryController? _industryController;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    print('🚀 [SavedOffers] initState called');
    
    _searchController = TextEditingController();
    
    // Initialize controllers after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🎯 [SavedOffers] Getting controllers...');
      _controller = Get.put(SavedOffersController());
      _industryController = IndustryController.instance;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    print('🔍 [SavedOffers] Search changed: $value');
    _controller?.setSearchKeyword(value);
  }

  void _onCategoryTap(String? category) {
    print('🏷️ [SavedOffers] Category tapped: $category');
    _controller?.setCategory(category);
  }

  Future<void> _onRefresh() async {
    print('🔄 [SavedOffers] Pull to refresh');
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
    return Scaffold(
      appBar: simpleAppBar(),
      body: Obx(() {
        if (_controller == null || _industryController == null) {
          return Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView(
            shrinkWrap: true,
            padding: AppSizes.DEFAULT,
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              // Header
              MyText(
                text: 'Saved Offers',
                size: 24,
                weight: FontWeight.w600,
                paddingBottom: 8,
              ),
              MyText(
                text: 'See your saved offers and get these deals now',
                size: 16,
                lineHeight: 1.5,
                weight: FontWeight.w500,
                color: kQuaternaryColor,
                paddingBottom: 20,
              ),

              // Search Bar
              Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: kFillColor,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: kBorderColor),
                ),
                child: Row(
                  children: [
                    Image.asset(Assets.imagesSearchIcon, height: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Search saved offers...',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                        child: Icon(Icons.clear, size: 20, color: kQuaternaryColor),
                      ),
                  ],
                ),
              ),

              // Category Tabs (Horizontal Scroll)
              if (_industryController != null && _industryController!.industries.isNotEmpty)
                Container(
                  height: 40,
                  margin: EdgeInsets.only(bottom: 20),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    children: [
                      // "All" tab
                      _CategoryTab(
                        label: 'All',
                        isSelected: _controller!.selectedCategory.value == null,
                        onTap: () => _onCategoryTap(null),
                      ),
                      SizedBox(width: 8),
                      // Industry tabs
                      ..._industryController!.industries.map((industry) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8),
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
                  padding: AppSizes.ZERO,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _controller!.filteredOffers.length,
                  itemBuilder: (context, i) {
                    final offer = _controller!.filteredOffers[i];
                    return GestureDetector(
                      onTap: () {
                        print('🎯 [SavedOffers] Navigating to offer: ${offer.id}');
                        Get.to(() => OfferDetails(), arguments: {'offerId': offer.id});
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
        );
      }),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: MyButton(
          buttonText: 'Go Back',
          onTap: () => Get.back(),
        ),
      ),
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kSecondaryColor : kFillColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? kSecondaryColor : kBorderColor,
            width: 1,
          ),
        ),
        child: Center(
          child: MyText(
            text: label,
            size: 14,
            weight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : kPrimaryColor,
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
          // Merchant Logo
          CommonImageView(
            url: offer.merchantLogo ?? dummyImg,
            height: 38,
            width: 38,
            fit: BoxFit.cover,
            radius: 100,
          ),
          SizedBox(width: 12),
          // Offer Info
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
          // Unsave Button
          GestureDetector(
            onTap: onUnsave,
            child: Image.asset(Assets.imagesMore, height: 24),
          ),
        ],
      ),
    );
  }
}

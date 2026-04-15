import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sheet/sheet.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/discover_offers_controller.dart';
import 'package:snag/controllers/industry_controller.dart';
import 'package:snag/main.dart';
import 'package:snag/view/screens/user/user_home/user_search.dart';
import 'package:snag/view/screens/user/user_my_offers/u_offer_details.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_bottom_sheet_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  DiscoverOffersController? _controller;
  IndustryController? _industryController;

  @override
  void initState() {
    super.initState();
    print('🚀 [UserHome] initState called');
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        print('🎯 [UserHome] Getting controllers...');
        
        // Check if controller already exists
        if (Get.isRegistered<DiscoverOffersController>()) {
          print('♻️ [UserHome] DiscoverOffersController already exists, using existing');
          _controller = DiscoverOffersController.instance;
          _controller!.refresh(); // Reload offers
        } else {
          print('🆕 [UserHome] Creating new DiscoverOffersController');
          _controller = Get.put(DiscoverOffersController());
          // Manually call load since onInit might not trigger
          print('📞 [UserHome] Manually calling loadOffersWithoutLocation');
          _controller!.loadOffersWithoutLocation();
        }
        
        print('✅ [UserHome] DiscoverOffersController ready');
        _industryController = IndustryController.instance;
        print('✅ [UserHome] IndustryController obtained');
        setState(() {});
      } catch (e) {
        print('❌ [UserHome] Error initializing controllers: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _industryController == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(() => Stack(
        children: [
          Image.asset(
            Assets.imagesDummyMap,
            height: Get.height,
            width: Get.width,
            fit: BoxFit.cover,
          ),
          Center(child: Image.asset(Assets.imagesCurrentLoc, height: 90)),
          Positioned(
            right: 20,
            bottom: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset(Assets.imagesRecenterIcon, height: 32),
                Image.asset(Assets.imagesDirections, height: 32),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 55, 20, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Expanded(
                  child: MyTextField(
                    marginBottom: 0,
                    hintText: 'Search place or address',
                    prefix: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Assets.imagesSearchIcon, height: 22),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => UserSearch());
                  },
                  child: Image.asset(Assets.imagesMenu, height: 48),
                ),
              ],
            ),
          ),
          
          // Category Tabs
          if (_industryController!.industries.isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: 120),
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
                    onTap: () => _controller!.setCategory(null),
                  ),
                  SizedBox(width: 10),
                  ..._industryController!.industries.map((industry) {
                    return Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: _CategoryTab(
                        label: industry,
                        isSelected: _controller!.selectedCategory.value == industry,
                        onTap: () => _controller!.setCategory(industry),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

          // Real Offer Markers
          ..._buildOfferMarkers(),

          Center(child: Image.asset(Assets.imagesCurrentLoc, height: 90)),

          Align(
            alignment: Alignment.bottomCenter,
            child: Sheet(
              maxExtent: Get.height * 0.8,
              initialExtent: 150,
              minExtent: 50,
              physics: BouncingSheetPhysics(),
              child: _Sponsored(),
            ),
          ),
        ],
      )),
    );
  }

  List<Widget> _buildOfferMarkers() {
    print('🗺️ [UserHome] Building markers...');
    print('🗺️ [UserHome] isLoading: ${_controller!.isLoading.value}');
    print('🗺️ [UserHome] offers count: ${_controller!.offers.length}');
    
    if (_controller!.isLoading.value || _controller!.offers.isEmpty) {
      print('🗺️ [UserHome] No markers to show');
      return [];
    }

    final markers = <Widget>[];
    final grouped = _controller!.offersByMerchant;
    
    print('🗺️ [UserHome] Grouped by ${grouped.length} merchants');
    
    // Position markers in a grid pattern
    int index = 0;
    final positions = [
      {'top': 175.0, 'right': 50.0},
      {'top': 240.0, 'left': 20.0},
      {'top': 260.0, 'right': 10.0},
      {'top': 320.0, 'left': 10.0},
      {'top': 400.0, 'left': 30.0},
      {'top': 360.0, 'right': 10.0},
      {'top': 440.0, 'right': 30.0},
      {'top': 480.0, 'left': 20.0},
    ];

    grouped.forEach((merchantId, offers) {
      if (index >= positions.length) return;
      
      final position = positions[index];
      final firstOffer = offers.first;
      final offerCount = offers.length;
      
      print('🗺️ [UserHome] Marker $index: ${firstOffer.merchantBrand} - ${firstOffer.title}');
      
      markers.add(
        Positioned(
          top: position['top'],
          left: position['left'],
          right: position['right'],
          child: _Marker(
            title: firstOffer.merchantBrand ?? 'Merchant',
            image: firstOffer.merchantLogo ?? Assets.imagesKfc,
            description: '$offerCount Offer${offerCount > 1 ? 's' : ''}',
            offers: offers,
          ),
        ),
      );
      index++;
    });

    print('🗺️ [UserHome] Built ${markers.length} markers');
    return markers;
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

class _Marker extends StatelessWidget {
  const _Marker({
    required this.title,
    required this.image,
    required this.description,
    required this.offers,
  });
  final String title;
  final String image;
  final String description;
  final List<dynamic> offers;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          _ViewSponsorDetails(
            title: title,
            image: image,
            offers: offers,
          ),
          isScrollControlled: true,
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 44,
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: kBorderColor, width: 1),
              boxShadow: [
                BoxShadow(
                  color: kTertiaryColor.withValues(alpha: .16),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonImageView(
                  height: 24,
                  width: 24,
                  radius: 100,
                  fit: BoxFit.cover,
                  url: image,
                ),
                SizedBox(width: 6),
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: title,
                        size: 12,
                        weight: FontWeight.w600,
                        paddingBottom: 2,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                      MyText(
                        text: description,
                        size: 10,
                        color: kQuaternaryColor,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Sponsored extends StatefulWidget {
  const _Sponsored({Key? key}) : super(key: key);

  @override
  State<_Sponsored> createState() => _SponsoredState();
}

class _SponsoredState extends State<_Sponsored> {
  late final List<Map<String, String>> _mapTypes;
  late final List<PageController> _pageControllers;

  @override
  void initState() {
    super.initState();
    _mapTypes = [
      {'title': 'H & M', 'image': Assets.imagesHn},
      {'title': 'KFC', 'image': Assets.imagesKfcBanner},
      {'title': 'Burger King', 'image': Assets.imagesBurger},
    ];
    _pageControllers = List.generate(_mapTypes.length, (_) => PageController());
  }

  @override
  void dispose() {
    for (final c in _pageControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.8,
      width: Get.width,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.transparent.withValues(alpha: .16),
            blurRadius: 16,
            offset: Offset(0, -8),
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            text: 'Sponsored',
            size: 16,
            weight: FontWeight.w600,
            paddingBottom: 16,
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(height: 20);
              },
              shrinkWrap: true,
              itemCount: _mapTypes.length,
              padding: AppSizes.ZERO,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _headingRow(
                      title: _mapTypes[index]['title'],
                      onMore: () {
                        Get.bottomSheet(
                          _ViewSponsorDetails(
                            title: _mapTypes[index]['title']!,
                            image: '${_mapTypes[index]['image']}',
                            offers: [], // Empty for sponsored section
                          ),
                          isScrollControlled: true,
                        );
                      },
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      height: 140,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            PageView.builder(
                              itemCount: 3,
                              physics: BouncingScrollPhysics(),
                              controller: _pageControllers[index],
                              itemBuilder: (context, pageIndex) {
                                final images = [
                                  _mapTypes[index]['image']!,
                                  Assets.imagesKfcBanner,
                                  Assets.imagesBurger,
                                ];
                                return Image.asset(
                                  images[pageIndex],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                );
                              },
                            ),
                            Positioned(
                              bottom: 8,
                              child: SmoothPageIndicator(
                                controller: _pageControllers[index],
                                count: 3,
                                effect: WormEffect(
                                  dotHeight: 8,
                                  dotWidth: 8,
                                  activeDotColor: kSecondaryColor,
                                  dotColor: kLightBlueColor2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Row _headingRow({String? title, VoidCallback? onMore}) {
    return Row(
      children: [
        Expanded(
          child: MyText(text: title ?? '', size: 20, weight: FontWeight.w600),
        ),
        MyText(
          onTap: onMore,
          text: 'View More',
          size: 14,
          paddingRight: 6,
          weight: FontWeight.w600,
          color: kSecondaryColor,
        ),
        Image.asset(Assets.imagesArrowNext, height: 20, color: kSecondaryColor),
      ],
    );
  }
}

class _ViewSponsorDetails extends StatelessWidget {
  final String title;
  final String image;
  final List<dynamic> offers;

  const _ViewSponsorDetails({
    super.key,
    required this.title,
    required this.image,
    required this.offers,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 55),
      height: Get.height * 0.9,
      width: Get.width,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CommonImageView(
                height: 32,
                width: 32,
                radius: 100,
                fit: BoxFit.cover,
                url: image,
              ),
              Expanded(
                child: MyText(
                  text: title,
                  size: 18,
                  weight: FontWeight.w600,
                  paddingLeft: 10,
                ),
              ),
              MyText(
                text: '4.8/5.0',
                size: 20,
                weight: FontWeight.w600,
                paddingRight: 4,
              ),
              Image.asset(Assets.imagesStarIcon, height: 20),
            ],
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: AppSizes.ZERO,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: offers.length,
              itemBuilder: (context, i) {
                final offer = offers[i];
                return _OfferTile(offer: offer);
              },
            ),
          ),
          SizedBox(height: 16),
          MyButton(
            buttonText: 'Close',
            onTap: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}

class _OfferTile extends StatelessWidget {
  const _OfferTile({required this.offer});

  final dynamic offer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('🎯 [OfferTile] Clicked on offer tile');
        print('🎯 [OfferTile] Offer type: ${offer.runtimeType}');
        print('🎯 [OfferTile] Offer title: ${offer.title}');
        Get.back(); // Close the merchant offers sheet
        Get.bottomSheet(
          UOfferDetails(offer: offer),
          isScrollControlled: true,
        );
      },
      child: Container(
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
            Image.asset(Assets.imagesMore, height: 24),
          ],
        ),
      ),
    );
  }
}

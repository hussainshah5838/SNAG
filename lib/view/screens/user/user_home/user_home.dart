import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/route_manager.dart';
import 'package:sheet/sheet.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
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
  final List<String> labels = [
    'Food & Drinks',
    'Health',
    'Shopping',
    'Services',
    'Beauty',
  ];
  int? selectedLabelIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
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
          Container(
            margin: EdgeInsets.only(top: 120),
            height: 35,
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(width: 10);
              },
              padding: AppSizes.HORIZONTAL,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: labels.length,
              itemBuilder: (context, index) {
                final isSelected = selectedLabelIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedLabelIndex = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? kSecondaryColor : kLightBlueColor2,
                      border: Border.all(color: kBlueBorderColor),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: MyText(
                        text: labels[index],
                        size: 13,
                        weight: FontWeight.w500,
                        color: isSelected ? kPrimaryColor : kSecondaryColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned(
            top: 175,
            right: 50,
            child: _Marker(
              title: 'KFC',
              image: Assets.imagesKfc,
              description: '3 Offers',
            ),
          ),
          Positioned(
            top: 240,
            left: 20,
            child: _Marker(
              title: 'McDonalds',
              image: Assets.imagesMc,
              description: '4 Offers',
            ),
          ),
          Positioned(
            top: 260,
            right: 10,
            child: _Marker(
              title: 'Ralph Lauren',
              image: Assets.imagesRalph,
              description: '2 Offers',
            ),
          ),
          Positioned(
            top: 320,
            left: 10,
            child: _Marker(
              title: 'Siemens',
              image: Assets.imagesSiemens,
              description: '3 Offers',
            ),
          ),
          Positioned(
            top: 400,
            left: 30,
            child: _Marker(
              title: 'Marks & Spencers',
              image: Assets.imagesMark,
              description: '5 Offers',
            ),
          ),
          Positioned(
            top: 360,
            right: 10,
            child: _Marker(
              title: 'Target Store',
              image: Assets.imagesTarget,
              description: '1 Offer',
            ),
          ),
          Positioned(
            top: 440,
            right: 30,
            child: _Marker(
              title: 'Burger King',
              image: Assets.imagesBurgerKing,
              description: '1 Offer',
            ),
          ),
          Positioned(
            top: 480,
            left: 20,
            child: _Marker(
              title: 'Walmart',
              image: Assets.imagesWall,
              description: '2 Offers',
            ),
          ),

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
      ),
    );
  }
}

class _Marker extends StatelessWidget {
  const _Marker({
    required this.title,
    required this.image,
    required this.description,
  });
  final String title;
  final String image;
  final String description;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          _ViewSponsorDetails(title: title, image: image),
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
                  imagePath: image,
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
                                // Hardcoded images for demonstration
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

  const _ViewSponsorDetails({
    super.key,
    required this.title,
    required this.image,
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
                imagePath: image,
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
              itemCount: 5,
              itemBuilder: (context, i) {
                final List<Map<String, String>> users = [
                  {
                    "name": "Weekend Feast Special",
                    "distance": "City Bites - “SAVE15”",
                  },
                  {
                    "name": "Buy Three Burgers",
                    "distance": "Burger Haven - \"Taste of Happiness\"",
                  },
                  {
                    "name": "Buy 1 Get 1 Free Burger",
                    "distance": "Gourmet Market - “One11”",
                  },
                  {
                    "name": "Snack Happy Hour",
                    "distance": "Sunny Deli - “Happy99”",
                  },
                  {
                    "name": "Free Dessert with Purchase!",
                    "distance": "Chef's Corner - \"Eleven One\"",
                  },
                ];
                return GestureDetector(
                  onTap: () {
                    Get.bottomSheet(UOfferDetails(), isScrollControlled: true);
                  },
                  child: _OfferTile(user: users[i], isSelected: false),
                );
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
  const _OfferTile({required this.user, required this.isSelected});

  final Map<String, String> user;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
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
            url: dummyImg,
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
                  text: user["name"] as String,
                  size: 15,
                  weight: FontWeight.w600,
                  paddingBottom: 4,
                ),
                MyText(
                  text: '${user["distance"]}',
                  size: 12,
                  color: kQuaternaryColor,
                ),
              ],
            ),
          ),
          Image.asset(Assets.imagesMore, height: 24),
        ],
      ),
    );
  }
}

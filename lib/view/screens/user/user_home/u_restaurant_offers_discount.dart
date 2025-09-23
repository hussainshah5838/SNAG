import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
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
class URestaurantOffersDiscount extends StatefulWidget {
  final String image;
  final String title;

  const URestaurantOffersDiscount({
    super.key,
    required this.image,
    required this.title,
  });
  @override
  State<URestaurantOffersDiscount> createState() =>
      _URestaurantOffersDiscountState();
}

class _URestaurantOffersDiscountState extends State<URestaurantOffersDiscount> {
  int? selectedLabelIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> offerList = [
      {
        "image": Assets.imagesMc,
        "title": "Weekend Flash Discount",
        "deals": "Downtown Outlet - Instore",
      },
      {
        "image": Assets.imagesRalph,
        "title": "Purchase Three Coffees",
        "deals": "Java Junction - Instore",
      },
      {
        "image": Assets.imagesSiemens,
        "title": "Buy 1 Get 1 Free Coffee",
        "deals": "Friends Market - Instore",
      },
      {
        "image": Assets.imagesMark,
        "title": "Happy Hour",
        "deals": "California Market - Online",
      },
      {
        "image": Assets.imagesKfc,
        "title": "Coffee Free!",
        "deals": "Buddy's Bazaar - Online",
      },
      {
        "image": Assets.imagesTarget,
        "title": "New Customer Special",
        "deals": "Downtown Outlet - Online",
      },
      {
        "image": Assets.imagesBurgerKing,
        "title": "Purchase One Coffee",
        "deals": "Buddy's Bazaar - Online",
      },
    ];
    final List<String> labels = ['All', 'In-Store', 'Online'];
    return Scaffold(
      appBar: simpleAppBar(
        title: '',
        haveLeading: true,
        titleWidget: MyTextField(
          labelText: 'Location',
          hintText: 'Search city, area, or branch name...',
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
                    _FilterBottomSheet(),
                    isScrollControlled: true,
                  );
                },
                child: Image.asset(Assets.imagesFilter, height: 22),
              ),
            ],
          ),
        ),
        actions: [SizedBox(width: 20)],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.VERTICAL,
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(
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
          SizedBox(height: 30),
          Padding(
            padding: AppSizes.HORIZONTAL,
            child: Row(
              children: [
                CommonImageView(
                  height: 34,
                  width: 34,
                  radius: 100,
                  fit: BoxFit.cover,
                  imagePath: widget.image,
                ),
                Expanded(
                  child: MyText(
                    text: widget.title,
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
          ),
          SizedBox(height: 14),
          ListView.builder(
            padding: AppSizes.DEFAULT,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: offerList.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () {
                  Get.to(() => UOfferDetails());
                },
                child: _OfferTile(user: offerList[i], isSelected: false),
              );
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
                  text: user["title"] as String,
                  size: 15,
                  weight: FontWeight.w600,
                  paddingBottom: 4,
                ),
                MyText(
                  text: '${user["deals"]}',
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

class _FilterBottomSheet extends StatefulWidget {
  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  // Multi-select lists replacing previous single-value selections
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
          MyButton(buttonText: 'Done', onTap: () {}),
        ],
      ),
    );
  }
}

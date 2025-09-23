import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/screens/user/user_home/u_restaurant_offers_discount.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/custom_bottom_sheet_widget.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserSearch extends StatefulWidget {
  @override
  State<UserSearch> createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  int? selectedLabelIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> offerList = [
      {"image": Assets.imagesMc, "title": "McDonald's", "deals": "2 Deals"},
      {
        "image": Assets.imagesRalph,
        "title": "Ralph Lauren ",
        "deals": "1 Deals",
      },
      {"image": Assets.imagesSiemens, "title": "Siemens", "deals": "3 Deals"},
      {
        "image": Assets.imagesMark,
        "title": "Marks & Spencer",
        "deals": "4 Deals",
      },
      {"image": Assets.imagesKfc, "title": "KFC", "deals": "5 Deals"},
      {"image": Assets.imagesTarget, "title": "Target", "deals": "2 Deals"},
      {
        "image": Assets.imagesBurgerKing,
        "title": "Burger King",
        "deals": "6 Deals",
      },
    ];
    final List<String> labels = [
      'Food & Drinks',
      'Health',
      'Shopping',
      'Services',
      'Beauty',
    ];
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
          SizedBox(height: 14),
          ListView.builder(
            padding: AppSizes.DEFAULT,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: offerList.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () {
                  Get.to(
                    () => URestaurantOffersDiscount(
                      image: offerList[i]["image"]!,
                      title: offerList[i]["title"]!,
                    ),
                  );
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
            imagePath: user["image"] as String,
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
  List<String> _selectedBrandsList = [];
  List<String> _selectedKeywordsList = [];
  List<String> _selectedCategoriesList = [];

  @override
  Widget build(BuildContext context) {
    final List<String> _keywords = ['Buy 1 Get 1', 'Flash Deal', 'Discount %'];
    final List<String> _brands = ['KFC', 'McDonald\'s', 'Burger King'];
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
                  labelText: 'Brand',
                  hint: 'Enter favorite brands e.g. KFC',
                  isMandatory: false,
                  items: _brands,
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(Assets.imagesTag, height: 20)],
                  ),
                  selectedValues: _selectedBrandsList,
                  onTap: (value) {
                    setState(() {
                      if (_selectedBrandsList.contains(value)) {
                        _selectedBrandsList.remove(value);
                      } else {
                        _selectedBrandsList.add(value);
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
                CustomDropDown(
                  labelText: 'Radius',
                  hint: 'Enter radius e.g. 5KM',
                  items: ['Enter radius e.g. 5KM', '5 km', '10 km', '20 km'],
                  selectedValue: 'Enter radius e.g. 5KM',
                  prefix: Image.asset(Assets.imagesLoc, height: 20),
                  onChanged: (v) {},
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

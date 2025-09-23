import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/main.dart';
import 'package:snag/view/screens/user/user_my_offers/u_offer_details.dart';
import 'package:snag/view/screens/user/user_my_offers/u_see_offer_details.dart';
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
  int? selectedLabelIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> labels = [
      'Food & Drinks',
      'Health',
      'Shopping',
      'Services',
      'Beauty',
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: simpleAppBar(
        title: '',
        haveLeading: false,
        titleWidget: Padding(
          padding: AppSizes.HORIZONTAL,
          child: MyTextField(
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
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.VERTICAL,
        physics: BouncingScrollPhysics(),
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
                  Get.to(() => USeeOfferDetails());
                },
                child: _OfferTile(user: users[i], isSelected: false),
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

import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/main.dart';
import 'package:snag/view/screens/user/user_plan_meetups/user_add_new_meetup.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/custom_bottom_sheet_widget.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserPlanMeetups extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: GestureDetector(
                child: Image.asset(Assets.imagesAddIcon, height: 28),
                onTap: () {
                  Get.to(() => UserAddNewMeetup());
                },
              ),
            ),
          ],
        ),
        actions: [
          Center(child: Image.asset(Assets.imagesMore, height: 28)),
          SizedBox(width: 10),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          MyText(
            text: 'Plan Meetups',
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text:
                'Choose a location, set a purpose, and invite friends via email.',
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          ListView.builder(
            padding: AppSizes.ZERO,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, i) {
              final List<Map<String, String>> users = [
                {
                  "name": "Weekend Shopping Spree",
                  "distance": "Zara - Saturday, Aug 23 · 4:00 PM",
                },
                {
                  "name": "Office Team Dinner",
                  "distance": "KFC - Friday, Aug 29 · 8:30 PM",
                },
                {
                  "name": "Fitness & Brunch",
                  "distance": "Gold’s Gym - Sunday, Sep 7 · 10:00 AM",
                },
              ];
              return GestureDetector(
                onTap: () {},
                child: _MeetupTile(user: users[i], isSelected: false),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MeetupTile extends StatelessWidget {
  const _MeetupTile({required this.user, required this.isSelected});

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
          Stack(
            children: List.generate(
              3,
              (index) => Padding(
                padding: EdgeInsets.only(left: index * 12.0),
                child: CommonImageView(
                  url: dummyImg,
                  height: 38,
                  width: 38,
                  fit: BoxFit.cover,
                  radius: 100,
                ),
              ),
            ),
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

  @override
  Widget build(BuildContext context) {
    final List<String> _keywords = ['Buy 1 Get 1', 'Flash Deal', 'Discount %'];
    final List<String> _statuses = ['Active', 'Expired', 'Scheduled'];

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
                  labelText: 'Location',
                  hintText: 'Search city, area, or branch name...',
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(Assets.imagesLoc, height: 20)],
                  ),
                ),
                MyTextField(
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
                  labelText: 'Offer Type ',
                  hint: 'Select offer type or category...',
                  items: ['Select offer type or category...', 'In Store'],
                  selectedValue: 'Select offer type or category...',
                  prefix: Image.asset(Assets.imagesKeywords, height: 20),
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
          MyButton(buttonText: 'Done', onTap: () {}),
        ],
      ),
    );
  }
}

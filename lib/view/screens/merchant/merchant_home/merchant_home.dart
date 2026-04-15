import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_fonts.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/main.dart';
import 'package:snag/view/screens/notifications/user_notifications.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_bottom_sheet_widget.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:snag/controllers/merchant_offers_controller.dart';

class MerchantHome extends StatefulWidget {
  @override
  State<MerchantHome> createState() => _MerchantHomeState();
}

class _MerchantHomeState extends State<MerchantHome> {
  final controller = Get.put(MerchantOffersController());

  @override
  void initState() {
    super.initState();
    controller.fetchDashboardStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {
                Get.to(() => UserNotifications());
              },
              child: Image.asset(Assets.imagesNotifications, height: 24),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          MyText(
            text: 'Home',
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text:
                'Your business snapshot and shortcuts to manage what matters.',
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          Row(
            children: [
              Expanded(
                child: MyText(
                  text: 'Offers',
                  size: 20,
                  weight: FontWeight.w600,
                ),
              ),
              MyText(
                text: 'See All',
                size: 14,
                paddingRight: 6,
                weight: FontWeight.w600,
                color: kSecondaryColor,
              ),
              Image.asset(
                Assets.imagesArrowNext,
                height: 20,
                color: kSecondaryColor,
              ),
            ],
          ),
          SizedBox(height: 12),
          Obx(() {
            if (controller.isLoadingStats.value) {
              return Container(
                height: 254,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (controller.statsError.value != null) {
              return Container(
                height: 254,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      SizedBox(height: 12),
                      MyText(
                        text: 'Failed to load stats',
                        size: 14,
                        color: kQuaternaryColor,
                      ),
                      SizedBox(height: 8),
                      TextButton(
                        onPressed: controller.fetchDashboardStats,
                        child: MyText(
                          text: 'Retry',
                          size: 14,
                          color: kSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final List<Map<String, dynamic>> stats = [
              {
                'icon': Assets.imagesTotalRedemptions,
                'label': 'Active Offers',
                'value': controller.activeOffers.value.toString(),
              },
              {
                'icon': Assets.imagesSavedOffers,
                'label': 'Saved Offers',
                'value': controller.savedOffers.value.toString(),
              },
              {
                'icon': Assets.imagesExpiredOffers,
                'label': 'Expired Offers',
                'value': controller.expiredOffers.value.toString(),
              },
              {
                'icon': Assets.imagesDrafted,
                'label': 'Drafted Offers',
                'value': controller.draftedOffers.value.toString(),
              },
            ];

            return GridView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: AppSizes.ZERO,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 122,
              ),
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                final stat = stats[index];
                return Container(
                  decoration: BoxDecoration(
                    color: kFillColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kBorderColor, width: 1.0),
                  ),
                  padding: EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Image.asset(stat['icon'], height: 24, width: 24),
                        ],
                      ),
                      Spacer(),
                      MyText(
                        text: stat['label'],
                        size: 14,
                        weight: FontWeight.w500,
                        paddingBottom: 6,
                      ),
                      MyText(
                        text: stat['value'],
                        size: 24,
                        fontFamily: GoogleFonts.dmSans().fontFamily,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                );
              },
            );
          }),
          SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: MyText(
                  text: 'Redemptions',
                  size: 20,
                  weight: FontWeight.w600,
                ),
              ),
              MyText(
                text: 'See All',
                size: 14,
                paddingRight: 6,
                weight: FontWeight.w600,
                color: kSecondaryColor,
              ),
              Image.asset(
                Assets.imagesArrowNext,
                height: 20,
                color: kSecondaryColor,
              ),
            ],
          ),
          SizedBox(height: 12),
          Obx(() {
            final redemptionsChange = controller.redemptionsChange.value;
            final impressionsChange = controller.impressionsChange.value;
            
            final List<Map<String, dynamic>> stats = [
              {
                'icon': Assets.imagesTotalRedemptions,
                'percent': '${redemptionsChange.abs()}%',
                'percentColor': redemptionsChange >= 0 ? kGreenColor : Colors.red,
                'percentText': ' vs Last Month',
                'label': 'Total Redemptions',
                'value': controller.totalRedemptions.value.toString(),
              },
              {
                'icon': Assets.imagesDollar,
                'percent': '${impressionsChange.abs()}%',
                'percentColor': impressionsChange >= 0 ? kGreenColor : Colors.red,
                'percentText': ' vs Last Month',
                'label': 'Total Impressions',
                'value': controller.totalImpressions.value.toString(),
              },
            ];

            return GridView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: AppSizes.ZERO,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 122,
              ),
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                final stat = stats[index];
                return Container(
                  decoration: BoxDecoration(
                    color: kFillColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kBorderColor, width: 1.0),
                  ),
                  padding: EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Image.asset(stat['icon'], height: 24, width: 24),
                          Expanded(
                            child: RichText(
                              textAlign: TextAlign.end,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: stat['percent'],
                                    style: TextStyle(
                                      fontFamily: AppFonts.WORK_SANS,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: stat['percentColor'],
                                    ),
                                  ),
                                  TextSpan(
                                    text: stat['percentText'],
                                    style: TextStyle(
                                      color: kTertiaryColor,
                                      fontFamily: AppFonts.WORK_SANS,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      MyText(
                        text: stat['label'],
                        size: 12,
                        weight: FontWeight.w500,
                        paddingBottom: 6,
                      ),
                      MyText(
                        text: stat['value'],
                        size: 24,
                        fontFamily: GoogleFonts.dmSans().fontFamily,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                );
              },
            );
          }),

          SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: MyText(
                  text: 'Locations',
                  size: 20,
                  weight: FontWeight.w600,
                ),
              ),
              MyText(
                text: 'See All',
                size: 14,
                paddingRight: 6,
                weight: FontWeight.w600,
                color: kSecondaryColor,
              ),
              Image.asset(
                Assets.imagesArrowNext,
                height: 20,
                color: kSecondaryColor,
              ),
            ],
          ),
          SizedBox(height: 12),
          Obx(() {
            final List<Map<String, dynamic>> stats = [
              {
                'icon': Assets.imagesTotalBranches,
                'label': 'Total Branches',
                'value': controller.totalBranches.value.toString(),
              },
              {
                'icon': Assets.imagesFeedbackIcon,
                'label': 'Total Feedback',
                'value': controller.totalFeedback.value.toString(),
              },
            ];

            return GridView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: AppSizes.ZERO,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 122,
              ),
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                final stat = stats[index];
                return Container(
                  decoration: BoxDecoration(
                    color: kFillColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kBorderColor, width: 1.0),
                  ),
                  padding: EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Image.asset(stat['icon'], height: 24, width: 24),
                        ],
                      ),
                      Spacer(),
                      MyText(
                        text: stat['label'],
                        size: 12,
                        weight: FontWeight.w500,
                        paddingBottom: 6,
                      ),
                      MyText(
                        text: stat['value'],
                        size: 24,
                        fontFamily: GoogleFonts.dmSans().fontFamily,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                );
              },
            );
          }),
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

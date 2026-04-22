import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/merchant_analytics_controller.dart';
import 'package:snag/view/screens/merchant/analytics/offers_analytics.dart';
import 'package:snag/view/screens/merchant/analytics/summary.dart';
import 'package:snag/view/screens/merchant/analytics/users.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class Analytics extends StatefulWidget {
  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  int? selectedLabelIndex = 0;

  @override
  void initState() {
    super.initState();
    // Register controller; lazy: false so all 3 tabs fetch on screen open
    Get.put(MerchantAnalyticsController());
  }

  @override
  void dispose() {
    Get.delete<MerchantAnalyticsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> labels = ['Summary', 'Offers', 'Users'];
    return Scaffold(
      appBar: simpleAppBar(
        title: '',
        haveLeading: false,
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {},
              child: Image.asset(Assets.imagesDownload, height: 20),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: const BouncingScrollPhysics(),
        children: [
          MyText(
            text: "Analytics",
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text: "Monitor payouts, view earnings, and update payment details.",
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          SizedBox(
            height: 35,
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              padding: AppSizes.ZERO,
              physics: const BouncingScrollPhysics(),
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
                    padding: const EdgeInsets.symmetric(horizontal: 12),
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
          const SizedBox(height: 30),

          // Global filter chips are commented out — these map to:
          //   selectedFunnelIndex → offerType ('in-store'|'online'|'all')
          //   selectedAgeGroup    → ageGroup ('18-24'|'25-34'|'35-44'|'45+'|'all')
          //   selectedTimeFilter  → timeFilter ('month'|'day-of-week'|'time')
          // TODO: uncomment and wire to controller when global filters are needed.

          selectedLabelIndex == 0
              ? const Summary()
              : selectedLabelIndex == 1
              ? const OffersAnalytics()
              : const Users(),
        ],
      ),
    );
  }
}

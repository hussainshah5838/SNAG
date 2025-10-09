import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/screens/merchant/analytics/offers_analytics.dart';
import 'package:snag/view/screens/merchant/analytics/summary.dart';
import 'package:snag/view/screens/merchant/analytics/users.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Analytics extends StatefulWidget {
  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  int? selectedLabelIndex = 0;
  // Funnel/filter state
  int selectedFunnelIndex = 0; // 0: All, 1: In-Store, 2: Online
  String selectedAgeGroup = 'All';
  String selectedTimeFilter = 'Month';

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
          SizedBox(width: 20),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
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
              separatorBuilder: (context, index) {
                return SizedBox(width: 10);
              },
              padding: AppSizes.ZERO,
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

          // --- Filters: Funnel / Demographics / Time ---
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.stretch,
          //   children: [
          //     // Funnel chips
          //     Row(
          //       children: List.generate(3, (index) {
          //         final labels = ['All', 'In-Store', 'Online'];
          //         final isSelected = selectedFunnelIndex == index;
          //         return Expanded(
          //           child: GestureDetector(
          //             onTap: () {
          //               setState(() {
          //                 selectedFunnelIndex = index;
          //               });
          //             },
          //             child: Container(
          //               padding: EdgeInsets.symmetric(
          //                 horizontal: 12,
          //                 vertical: 8,
          //               ),
          //               decoration: BoxDecoration(
          //                 color:
          //                     isSelected ? kSecondaryColor : kLightBlueColor2,
          //                 border: Border.all(color: kBlueBorderColor),
          //                 borderRadius: BorderRadius.circular(50),
          //               ),
          //               child: MyText(
          //                 text: labels[index],
          //                 size: 13,
          //                 weight: FontWeight.w500,
          //                 color: isSelected ? kPrimaryColor : kSecondaryColor,
          //               ),
          //             ),
          //           ),
          //         );
          //       }),
          //     ),
          //     SizedBox(height: 12),
          //     // Demographics (Age) and Time filters
          //     Row(
          //       children: [
          //         Expanded(
          //           child: Container(
          //             height: 40,
          //             decoration: BoxDecoration(
          //               color: kLightBlueColor2,
          //               border: Border.all(color: kBlueBorderColor),
          //               borderRadius: BorderRadius.circular(8),
          //             ),
          //             child: Row(
          //               children: [
          //                 MyText(
          //                   text: 'Age: $selectedAgeGroup',
          //                   size: 13,
          //                   weight: FontWeight.w500,
          //                 ),
          //                 Expanded(
          //                   child: DropdownButtonHideUnderline(
          //                     child: DropdownButton<String>(
          //                       value: selectedAgeGroup,
          //                       items:
          //                           ['All', '18-24', '25-34', '35-44', '45+']
          //                               .map(
          //                                 (e) => DropdownMenuItem(
          //                                   value: e,
          //                                   child: MyText(text: e, size: 13),
          //                                 ),
          //                               )
          //                               .toList(),
          //                       onChanged: (v) {
          //                         if (v == null) return;
          //                         setState(() {
          //                           selectedAgeGroup = v;
          //                         });
          //                       },
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         Expanded(
          //           child: Container(
          //             height: 40,
          //             decoration: BoxDecoration(
          //               color: kLightBlueColor2,
          //               border: Border.all(color: kBlueBorderColor),
          //               borderRadius: BorderRadius.circular(8),
          //             ),
          //             child: Row(
          //               children: [
          //                 MyText(
          //                   text: selectedTimeFilter,
          //                   size: 13,
          //                   weight: FontWeight.w500,
          //                 ),
          //                 SizedBox(width: 8),
          //                 Expanded(
          //                   child: DropdownButtonHideUnderline(
          //                     child: DropdownButton<String>(
          //                       value: selectedTimeFilter,
          //                       items:
          //                           ['Month', 'Day of week', 'Time']
          //                               .map(
          //                                 (e) => DropdownMenuItem(
          //                                   value: e,
          //                                   child: MyText(text: e, size: 13),
          //                                 ),
          //                               )
          //                               .toList(),
          //                       onChanged: (v) {
          //                         if (v == null) return;
          //                         setState(() {
          //                           selectedTimeFilter = v;
          //                         });
          //                       },
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //     SizedBox(height: 20),
          //   ],
          // ),
          selectedLabelIndex == 0
              ? Summary()
              : selectedLabelIndex == 1
              ? OffersAnalytics()
              : Users(),
        ],
      ),
    );
  }
}

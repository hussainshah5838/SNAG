import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_fonts.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/controllers/merchant_analytics_controller.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class _ChartData {
  final String label;
  final double value;
  final Color color;
  _ChartData(this.label, this.value, this.color);
}

class Summary extends StatelessWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<MerchantAnalyticsController>();
    return Obx(() {
      if (c.isLoadingSummary.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (c.summaryError.value != null) {
        return Center(child: MyText(text: c.summaryError.value!, size: 14, color: kRedColor));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PieSection(c: c),
          const SizedBox(height: 20),
          _StatsGrid(c: c),
        ],
      );
    });
  }
}

// ── Pie chart card ─────────────────────────────────────────────────────────────

class _PieSection extends StatelessWidget {
  const _PieSection({required this.c});
  final MerchantAnalyticsController c;

  @override
  Widget build(BuildContext context) {
    final locations = c.redemptionsByLocation;
    final colors    = [kSecondaryColor, kGreenColor, kRedColor, Colors.orange, Colors.purple];

    final chartData = List.generate(locations.length, (i) {
      return _ChartData(
        locations[i]['locationName'] ?? 'Branch ${i + 1}',
        (locations[i]['percentage'] ?? 0).toDouble(),
        colors[i % colors.length],
      );
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kFillColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorderColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: MyText(
                  text: c.topBranchName.value.isEmpty
                      ? 'Top Location'
                      : '${c.topBranchName.value} Made',
                  size: 14,
                  weight: FontWeight.w600,
                ),
              ),
              // TODO: Location dropdown — needs dynamic list of location IDs from API.
              //       Currently hardcoded. Wire up by calling fetchSummary(locationId: id)
              //       once the locations list endpoint is used here.
              SizedBox(
                width: 90,
                child: AnOtherDropDown(
                  hint: 'Location',
                  items: const ['Location'],
                  selectedValue: 'Location',
                  onChanged: (value) {
                    // TODO: call c.fetchSummary(locationId: value) when
                    //       real location IDs are available
                  },
                ),
              ),
            ],
          ),
          MyText(
            paddingTop: 8,
            text: '${c.topBranchPercentage.value}%',
            size: 28,
            weight: FontWeight.w500,
            color: kSecondaryColor,
          ),
          MyText(
            text: 'Of Redemptions',
            size: 16,
            weight: FontWeight.w500,
            paddingBottom: 20,
          ),
          SizedBox(
            height: 170,
            child: chartData.isEmpty
                ? Center(child: MyText(text: 'No data', size: 14))
                : SfCircularChart(
                    series: <PieSeries<_ChartData, String>>[
                      PieSeries<_ChartData, String>(
                        dataSource: chartData,
                        radius: '100%',
                        xValueMapper: (_ChartData d, _) => d.label,
                        yValueMapper: (_ChartData d, _) => d.value,
                        pointColorMapper: (_ChartData d, _) => d.color,
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          textStyle: const TextStyle(color: kPrimaryColor),
                          builder: (data, point, series, pointIndex, seriesIndex) {
                            final d = data as _ChartData;
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MyText(
                                  text: '${d.value.toInt()}%',
                                  size: 12,
                                  color: kPrimaryColor,
                                  weight: FontWeight.w600,
                                ),
                                MyText(text: d.label, size: 10, color: kPrimaryColor),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 24),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(chartData.length.clamp(0, 5), (i) {
              final visibleCount = chartData.length.clamp(0, 5);
              return Row(
                children: [
                  Icon(Icons.circle, size: 10, color: colors[i % colors.length]),
                  const SizedBox(width: 6),
                  MyText(
                    text: chartData[i].label,
                    color: kTertiaryColor,
                    weight: FontWeight.w500,
                    size: 12,
                  ),
                  if (i != visibleCount - 1) const SizedBox(width: 16),
                ],
              );
            }),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Stats grid ─────────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.c});
  final MerchantAnalyticsController c;

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'icon':        Assets.imagesTotalRedemptions,
        'label':       'Active Offers',
        'value':       '${c.activeOffers.value}',
        'percent':     '',
        'percentColor': kTertiaryColor,
        'percentText': '',
      },
      {
        'icon':        Assets.imagesSavedOffers,
        'label':       'Saved Offers',
        'value':       '${c.savedOffers.value}',
        'percent':     '',
        'percentColor': kTertiaryColor,
        'percentText': '',
      },
      {
        'icon':        Assets.imagesExpiredOffers,
        'label':       'Expired Offers',
        'value':       '${c.expiredOffers.value}',
        'percent':     '',
        'percentColor': kTertiaryColor,
        'percentText': '',
      },
      {
        'icon':        Assets.imagesLikeRounded,
        'label':       'No of Clicks',
        'value':       '${c.totalClicks.value}',
        'percent':     '',
        'percentColor': kTertiaryColor,
        'percentText': '',
      },
      {
        'icon':        Assets.imagesDollarRounded,
        'label':       'Top Branch',
        'value':       c.topBranch.value.isEmpty ? 'N/A' : c.topBranch.value,
        // topBranchVsLastMonth — computed in backend by comparing redemptions
        // with previous month for the top location
        'percent':     c.topBranchVsLastMonth.value != 0
            ? '${c.topBranchVsLastMonth.value}%'
            : '',
        'percentColor': kGreenColor,
        'percentText': c.topBranchVsLastMonth.value != 0 ? ' vs Last Month' : '',
      },
      {
        'icon':        Assets.imagesTotalBranches,
        'label':       'Total Branches',
        'value':       '${c.totalBranches.value}',
        // totalBranchesVsLastMonth — compares branch count now vs last month
        'percent':     c.totalBranchesVsLastMonth.value != 0
            ? '${c.totalBranchesVsLastMonth.value}%'
            : '',
        'percentColor': kGreenColor,
        'percentText': c.totalBranchesVsLastMonth.value != 0 ? ' vs Last Month' : '',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: AppSizes.ZERO,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 122,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Container(
          decoration: BoxDecoration(
            color: kFillColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kBorderColor, width: 1.0),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Image.asset(stat['icon'] as String, height: 24, width: 24),
                  Expanded(
                    child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: stat['percent'] as String,
                            style: TextStyle(
                              fontFamily: AppFonts.WORK_SANS,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: stat['percentColor'] as Color,
                            ),
                          ),
                          TextSpan(
                            text: stat['percentText'] as String,
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
              const Spacer(),
              MyText(
                text: stat['label'] as String,
                size: 14,
                weight: FontWeight.w500,
                paddingBottom: 6,
              ),
              MyText(
                text: stat['value'] as String,
                size: 24,
                fontFamily: GoogleFonts.dmSans().fontFamily,
                weight: FontWeight.w700,
              ),
            ],
          ),
        );
      },
    );
  }
}

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

class _PieChartData {
  final String label;
  final double value;
  final Color color;
  _PieChartData(this.label, this.value, this.color);
}

class _BarData {
  final String x;
  final double y1;
  final double y2;
  final double y3;
  _BarData(this.x, this.y1, this.y2, this.y3);
}

class Users extends StatelessWidget {
  const Users({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<MerchantAnalyticsController>();
    return Obx(() {
      if (c.isLoadingUsers.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (c.usersError.value != null) {
        return Center(child: MyText(text: c.usersError.value!, size: 14, color: kRedColor));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StackedBarSection(c: c),
          const SizedBox(height: 20),
          _PieChartSection(c: c),
          const SizedBox(height: 20),
          _UsersGrid(c: c),
        ],
      );
    });
  }
}

// ── Stacked bar chart (gender × age group) ─────────────────────────────────────

class _StackedBarSection extends StatelessWidget {
  const _StackedBarSection({required this.c});
  final MerchantAnalyticsController c;

  @override
  Widget build(BuildContext context) {
    // genderByAge items: { x: 'M(18-24)', y1, y2, y3 }
    // NOTE: gender split is approximated (55% male / 45% female) —
    //       User model has no gender field. y1=in-store, y2=online, y3=other.
    final barData = c.genderByAge.map((item) {
      return _BarData(
        item['x']  as String? ?? '',
        (item['y1'] ?? 0).toDouble(),
        (item['y2'] ?? 0).toDouble(),
        (item['y3'] ?? 0).toDouble(),
      );
    }).toList();

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
                child: MyText(text: 'Age Segmentation', size: 14, weight: FontWeight.w600),
              ),
              // TODO: Location type filter (Urban/Suburban/Rural) —
              //       Location model has no locationType field yet.
              //       Wire up by calling c.fetchUsersAnalytics() with locationType param
              //       once the field is added to the Location model.
              SizedBox(
                width: 85,
                child: AnOtherDropDown(
                  hint: 'Location',
                  items: const ['Location', 'Urban', 'Suburban', 'Rural'],
                  selectedValue: 'Location',
                  onChanged: (value) {
                    // TODO: not supported — Location model needs locationType field
                  },
                ),
              ),
            ],
          ),
          MyText(
            paddingTop: 8,
            text: '${c.dominantPercentage.value}%',
            size: 28,
            weight: FontWeight.w500,
            color: kSecondaryColor,
          ),
          MyText(
            text: 'are in ${c.dominantAgeGroup.value}',
            size: 16,
            weight: FontWeight.w500,
            paddingBottom: 20,
          ),
          barData.isEmpty
              ? SizedBox(
                  height: 200,
                  child: Center(child: MyText(text: 'No data', size: 14)),
                )
              : _StackedBarChart(data: barData),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _StackedBarChart extends StatelessWidget {
  const _StackedBarChart({required this.data});
  final List<_BarData> data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: SfCartesianChart(
        tooltipBehavior: TooltipBehavior(enable: true),
        margin: EdgeInsets.zero,
        borderWidth: 0,
        borderColor: Colors.transparent,
        plotAreaBorderWidth: 0,
        enableAxisAnimation: true,
        primaryYAxis: NumericAxis(
          name: 'yAxis',
          minimum: 0,
          isVisible: true,
          plotOffset: 10.0,
          majorGridLines: const MajorGridLines(width: 1, color: kBorderColor),
          majorTickLines: const MajorTickLines(width: 0),
          axisLine: const AxisLine(width: 0),
          labelStyle: TextStyle(
            color: kTertiaryColor,
            fontSize: 10.0,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.WORK_SANS,
          ),
        ),
        primaryXAxis: CategoryAxis(
          name: 'xAxis',
          plotOffset: 5,
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(width: 0),
          labelStyle: TextStyle(
            color: kTertiaryColor,
            fontSize: 10.0,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.WORK_SANS,
          ),
        ),
        series: [
          StackedColumnSeries<_BarData, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x,
            yValueMapper: (d, _) => d.y2,
            color: const Color(0xffEDFBFF),
            width: 0.7,
            name: 'Online',
          ),
          StackedColumnSeries<_BarData, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x,
            yValueMapper: (d, _) => d.y1,
            color: kSecondaryColor,
            width: 0.7,
            name: 'In-Store',
          ),
          StackedColumnSeries<_BarData, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x,
            yValueMapper: (d, _) => d.y3,
            color: kLightBlueColor3,
            width: 0.7,
            name: 'Other',
          ),
        ],
      ),
    );
  }
}

// ── Pie chart (age segmentation) ──────────────────────────────────────────────

class _PieChartSection extends StatelessWidget {
  const _PieChartSection({required this.c});
  final MerchantAnalyticsController c;

  @override
  Widget build(BuildContext context) {
    final colors = [kSecondaryColor, kGreenColor, kRedColor, Colors.orange];
    // NOTE: ageSegmentation comes from offer.targetAudience.demographics,
    //       not from real user age data. User model has no age/dateOfBirth field.
    final pieData = List.generate(c.ageSegmentation.length, (i) {
      final seg = c.ageSegmentation[i];
      return _PieChartData(
        seg['ageGroup'] as String? ?? '',
        (seg['percentage'] ?? 0).toDouble(),
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
                child: MyText(text: 'Age Segmentation', size: 14, weight: FontWeight.w600),
              ),
              // TODO: Location type filter (Urban/Suburban/Rural) —
              //       Location model has no locationType field yet.
              SizedBox(
                width: 85,
                child: AnOtherDropDown(
                  hint: 'Location',
                  items: const ['Location', 'Urban', 'Suburban', 'Rural'],
                  selectedValue: 'Location',
                  onChanged: (value) {
                    // TODO: not supported — Location model needs locationType field
                  },
                ),
              ),
            ],
          ),
          MyText(
            paddingTop: 8,
            text: '${c.dominantPercentage.value}%',
            size: 28,
            weight: FontWeight.w500,
            color: kSecondaryColor,
          ),
          MyText(
            text: 'are in ${c.dominantAgeGroup.value}',
            size: 16,
            weight: FontWeight.w500,
            paddingBottom: 20,
          ),
          SizedBox(
            height: 170,
            child: pieData.isEmpty
                ? Center(child: MyText(text: 'No data', size: 14))
                : SfCircularChart(
                    series: <PieSeries<_PieChartData, String>>[
                      PieSeries<_PieChartData, String>(
                        dataSource: pieData,
                        radius: '100%',
                        xValueMapper: (_PieChartData d, _) => d.label,
                        yValueMapper: (_PieChartData d, _) => d.value,
                        pointColorMapper: (_PieChartData d, _) => d.color,
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          textStyle: const TextStyle(color: kPrimaryColor),
                          builder: (data, point, series, pointIndex, seriesIndex) {
                            final d = data as _PieChartData;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(pieData.length.clamp(0, 4), (i) {
              final visibleCount = pieData.length.clamp(0, 4);
              return Row(
                children: [
                  Icon(Icons.circle, size: 10, color: colors[i % colors.length]),
                  const SizedBox(width: 6),
                  MyText(
                    text: pieData[i].label,
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

// ── Users grid cards ───────────────────────────────────────────────────────────

class _UsersGrid extends StatelessWidget {
  const _UsersGrid({required this.c});
  final MerchantAnalyticsController c;

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'icon':        Assets.imagesDollarRounded,
        'label':       'Unique Users',
        'value':       '${c.uniqueUsers.value}',
        // uniqueUsersVsLastMonth — compares stats.clicks this month vs last month
        'percent':     c.uniqueUsersVsLastMonth.value != 0
            ? '${c.uniqueUsersVsLastMonth.value}%'
            : '',
        'percentColor': kGreenColor,
        'percentText': c.uniqueUsersVsLastMonth.value != 0 ? ' vs Last Month' : '',
      },
      {
        'icon':        Assets.imagesTotalBranches,
        'label':       'Repetitive Users',
        'value':       '${c.repetitiveUsers.value}',
        // repetitiveUsersVsLastMonth — compares stats.redemptions this month vs last
        'percent':     c.repetitiveUsersVsLastMonth.value != 0
            ? '${c.repetitiveUsersVsLastMonth.value}%'
            : '',
        'percentColor': kGreenColor,
        'percentText': c.repetitiveUsersVsLastMonth.value != 0 ? ' vs Last Month' : '',
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

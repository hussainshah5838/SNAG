import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_fonts.dart';
import 'package:snag/controllers/merchant_analytics_controller.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class _LineChartData {
  final String label;
  final double value;
  _LineChartData(this.label, this.value);
}

class _FunnelData {
  final String x;
  final double y1;
  final double y2;
  final double y3;
  _FunnelData(this.x, this.y1, this.y2, this.y3);
}

class OffersAnalytics extends StatelessWidget {
  const OffersAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<MerchantAnalyticsController>();
    return Obx(() {
      if (c.isLoadingOffers.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (c.offersError.value != null) {
        return Center(child: MyText(text: c.offersError.value!, size: 14, color: kRedColor));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FunnelSection(c: c),
          const SizedBox(height: 20),
          _RedemptionsSection(c: c),
          const SizedBox(height: 20),
          _PerformanceSection(c: c),
        ],
      );
    });
  }
}

// ── Funnel chart ───────────────────────────────────────────────────────────────

class _FunnelSection extends StatelessWidget {
  const _FunnelSection({required this.c});
  final MerchantAnalyticsController c;

  @override
  Widget build(BuildContext context) {
    // funnelChart items: { x, y1 (in-store), y2 (online), y3 (other), total }
    final data = c.funnelChart.map((item) {
      return _FunnelData(
        item['x']  as String? ?? '',
        (item['y1'] ?? 0).toDouble(),
        (item['y2'] ?? 0).toDouble(),
        (item['y3'] ?? 0).toDouble(),
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kFillColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorderColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            spacing: 4,
            children: [
              Expanded(
                child: MyText(text: 'Funnel Report', size: 13, weight: FontWeight.w600),
              ),
              // TODO: Age filter — backend accepts ageGroup ('18-24'|'25-34'|'35-44'|'45+')
              //       Wire up by calling c.fetchOffersAnalytics(ageGroup: value)
              SizedBox(
                width: 55,
                child: AnOtherDropDown(
                  hint: 'Age',
                  items: const ['Age', '18-24', '25-34', '35-44'],
                  selectedValue: 'Age',
                  onChanged: (value) {
                    // TODO: c.fetchOffersAnalytics(ageGroup: value == 'Age' ? null : value)
                  },
                ),
              ),
              // TODO: Type filter (New/Returning) — User model has no isNewUser flag.
              //       Backend cannot distinguish new vs returning users yet.
              SizedBox(
                width: 60,
                child: AnOtherDropDown(
                  hint: 'Type',
                  items: const ['Type', 'New', 'Returning'],
                  selectedValue: 'Type',
                  onChanged: (value) {
                    // TODO: not supported by backend — User model needs isNewUser field
                  },
                ),
              ),
              // TODO: Month filter — backend accepts month (1-12).
              //       Wire up by calling c.fetchOffersAnalytics(month: monthIndex)
              SizedBox(
                width: 70,
                child: AnOtherDropDown(
                  hint: 'Month',
                  items: const ['Month', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                  selectedValue: 'Month',
                  onChanged: (value) {
                    // TODO: c.fetchOffersAnalytics(month: monthIndex)
                  },
                ),
              ),
            ],
          ),
          MyText(
            paddingTop: 8,
            text: '${c.totalImpressions.value}',
            size: 28,
            weight: FontWeight.w500,
            color: kSecondaryColor,
          ),
          MyText(
            text: 'In Impressions',
            size: 16,
            weight: FontWeight.w500,
            paddingBottom: 20,
          ),
          // Stacked chart: y1=in-store, y2=online, y3=other
          // NOTE: 'Impressions' uses stats.views and 'Visits' uses stats.clicks
          //       because the Offer model only has views/clicks/redemptions.
          //       Impressions and visits are not tracked separately yet.
          data.isEmpty
              ? SizedBox(
                  height: 200,
                  child: Center(child: MyText(text: 'No data', size: 14)),
                )
              : _FunnelChart(data: data),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _FunnelChart extends StatelessWidget {
  const _FunnelChart({required this.data});
  final List<_FunnelData> data;

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
          StackedColumnSeries<_FunnelData, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x,
            yValueMapper: (d, _) => d.y1,
            color: kSecondaryColor,
            width: 0.7,
            name: 'In-Store',
          ),
          StackedColumnSeries<_FunnelData, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x,
            yValueMapper: (d, _) => d.y3,
            color: kLightBlueColor3,
            width: 0.7,
            name: 'Other',
          ),
          StackedColumnSeries<_FunnelData, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.x,
            yValueMapper: (d, _) => d.y2,
            color: const Color(0xffEDFBFF),
            width: 0.7,
            name: 'Online',
          ),
        ],
      ),
    );
  }
}

// ── Redemptions line chart ─────────────────────────────────────────────────────

class _RedemptionsSection extends StatefulWidget {
  const _RedemptionsSection({required this.c});
  final MerchantAnalyticsController c;

  @override
  State<_RedemptionsSection> createState() => _RedemptionsSectionState();
}

class _RedemptionsSectionState extends State<_RedemptionsSection> {
  int _selectedIndex = -1; // -1 = no override, show all months from API

  @override
  Widget build(BuildContext context) {
    final c = widget.c;
    final months = c.redemptionsByMonth;

    final chartData = months.map((m) {
      return _LineChartData(
        m['label'] as String? ?? '',
        (m['redemptions'] ?? 0).toDouble(),
      );
    }).toList();

    // Month tabs shown below chart (Jan..Jul or whatever backend returns)
    final monthLabels = months.map((m) => m['label'] as String? ?? '').toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kFillColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorderColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            spacing: 4,
            children: [
              Expanded(
                child: MyText(text: 'Redemptions', size: 13, weight: FontWeight.w600),
              ),
              // TODO: Industry filter (Retail/E-commerce/Food&Beverage/Travel) —
              //       Offer and Location models have no industry field yet.
              SizedBox(
                width: 90,
                child: AnOtherDropDown(
                  hint: 'Industry',
                  items: const ['Industry', 'Retail', 'E-commerce', 'Food & Beverage', 'Travel'],
                  selectedValue: 'Industry',
                  onChanged: (value) {
                    // TODO: not supported — Offer/Location model needs industry field
                  },
                ),
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
            text: '${c.currentMonthRedemptions.value}',
            size: 28,
            weight: FontWeight.w500,
            color: kSecondaryColor,
          ),
          MyText(
            text: 'are in ${c.currentMonthLabel.value}',
            size: 16,
            weight: FontWeight.w500,
            paddingBottom: 20,
          ),
          SizedBox(
            height: 220,
            child: chartData.isEmpty
                ? Center(child: MyText(text: 'No data', size: 14))
                : _LineChartWidget(data: chartData, monthLabels: monthLabels, selectedIndex: _selectedIndex, onMonthTap: (i) {
                    setState(() => _selectedIndex = i);
                  }),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _LineChartWidget extends StatelessWidget {
  const _LineChartWidget({
    required this.data,
    required this.monthLabels,
    required this.selectedIndex,
    required this.onMonthTap,
  });
  final List<_LineChartData> data;
  final List<String> monthLabels;
  final int selectedIndex;
  final void Function(int) onMonthTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SfCartesianChart(
            tooltipBehavior: TooltipBehavior(enable: true),
            margin: EdgeInsets.zero,
            borderWidth: 0,
            borderColor: Colors.transparent,
            plotAreaBorderWidth: 0,
            enableAxisAnimation: true,
            primaryXAxis: CategoryAxis(
              isVisible: false,
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(width: 0),
              axisLine: const AxisLine(width: 0),
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              isVisible: false,
              majorGridLines: const MajorGridLines(width: 1, color: kBorderColor),
              axisLine: const AxisLine(width: 0),
            ),
            series: [
              LineSeries<_LineChartData, String>(
                name: 'Redemptions',
                dataSource: data,
                xValueMapper: (d, _) => d.label,
                yValueMapper: (d, _) => d.value,
                color: kSecondaryColor,
                width: 2,
                markerSettings: const MarkerSettings(
                  isVisible: true,
                  color: kSecondaryColor,
                  borderWidth: 2,
                  borderColor: kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(monthLabels.length, (i) {
            return GestureDetector(
              onTap: () => onMonthTap(i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: selectedIndex == i ? kLightBlueColor2 : Colors.transparent,
                ),
                child: MyText(
                  text: monthLabels[i],
                  size: 10,
                  weight: FontWeight.w500,
                  color: selectedIndex == i ? kSecondaryColor : kTertiaryColor,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ── Performance by segment ─────────────────────────────────────────────────────

class _PerformanceSection extends StatelessWidget {
  const _PerformanceSection({required this.c});
  final MerchantAnalyticsController c;

  @override
  Widget build(BuildContext context) {
    final offers = c.offerPerformance;

    return Container(
      padding: const EdgeInsets.all(12),
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
                  text: 'Performance By Segment',
                  size: 14,
                  weight: FontWeight.w600,
                ),
              ),
              // TODO: Offer dropdown — needs list of offer titles+IDs from API.
              //       Wire up by calling c.fetchOffersAnalytics(offerId: id)
              //       once the offers list is loaded here.
              SizedBox(
                width: 70,
                child: AnOtherDropDown(
                  hint: 'Offer',
                  items: const ['Offer'],
                  selectedValue: 'Offer',
                  onChanged: (value) {
                    // TODO: c.fetchOffersAnalytics(offerId: selectedOfferId)
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (offers.isEmpty)
            Center(child: MyText(text: 'No offers data', size: 14))
          else
            ...List.generate(offers.length, (i) {
              final offer = offers[i];
              final title       = offer['title']       as String? ?? 'Offer';
              final views       = offer['views']       ?? 0;
              final clicks      = offer['clicks']      ?? 0;
              final redemptions = offer['redemptions'] ?? 0;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MyText(
                    paddingTop: 4,
                    text: title,
                    size: 14,
                    color: kTertiaryColor,
                    weight: FontWeight.w500,
                    paddingBottom: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatItem(label: 'Total\nViews',       value: '$views'),
                      _StatItem(label: 'Total\nClicks',      value: '$clicks'),
                      _StatItem(label: 'Total\nRedemptions', value: '$redemptions'),
                    ],
                  ),
                  if (i != offers.length - 1)
                    Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      color: kBorderColor,
                    ),
                ],
              );
            }),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: label,
            size: 11,
            lineHeight: 1.5,
            color: kQuaternaryColor,
            paddingBottom: 6,
          ),
          MyText(
            text: value,
            size: 20,
            weight: FontWeight.w500,
            fontFamily: GoogleFonts.dmSans().fontFamily,
          ),
        ],
      ),
    );
  }
}

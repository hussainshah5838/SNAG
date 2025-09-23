import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_fonts.dart';
import 'package:snag/constants/app_images.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class _LineChartData {
  final String label;
  final double value;
  _LineChartData(this.label, this.value);
}

class OffersAnalytics extends StatelessWidget {
  const OffersAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(16),
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
                      text: 'Funnel Report',
                      size: 14,
                      weight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 80,
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      height: 32,
                      decoration: BoxDecoration(
                        color: kLightBlueColor2,
                        border: Border.all(color: kBlueBorderColor),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: MyText(
                              paddingLeft: 4,
                              text: 'Gender',
                              size: 12,
                              weight: FontWeight.w600,
                              color: kSecondaryColor,
                            ),
                          ),
                          Image.asset(
                            Assets.imagesDropdown,
                            height: 16,
                            color: kSecondaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 90,
                      height: 32,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: kLightBlueColor2,
                        border: Border.all(color: kBlueBorderColor),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: MyText(
                              paddingLeft: 4,
                              text: 'Industry',
                              size: 12,
                              weight: FontWeight.w600,
                              color: kSecondaryColor,
                            ),
                          ),
                          Image.asset(
                            Assets.imagesDropdown,
                            height: 16,
                            color: kSecondaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              MyText(
                paddingTop: 8,
                text: '2250',
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
              _Chart(),
              SizedBox(height: 8),
            ],
          ),
        ),
        SizedBox(height: 20),

        Container(
          padding: EdgeInsets.all(16),
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
                      text: 'Redemptions',
                      size: 14,
                      weight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 90,
                      height: 32,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: kLightBlueColor2,
                        border: Border.all(color: kBlueBorderColor),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: MyText(
                              paddingLeft: 4,
                              text: 'Industry',
                              size: 12,
                              weight: FontWeight.w600,
                              color: kSecondaryColor,
                            ),
                          ),
                          Image.asset(
                            Assets.imagesDropdown,
                            height: 16,
                            color: kSecondaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 85,
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      height: 32,
                      decoration: BoxDecoration(
                        color: kLightBlueColor2,
                        border: Border.all(color: kBlueBorderColor),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: MyText(
                              paddingLeft: 4,
                              text: 'Location',
                              size: 12,
                              weight: FontWeight.w600,
                              color: kSecondaryColor,
                            ),
                          ),
                          Image.asset(
                            Assets.imagesDropdown,
                            height: 16,
                            color: kSecondaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              MyText(
                paddingTop: 8,
                text: '230',
                size: 28,
                weight: FontWeight.w500,
                color: kSecondaryColor,
              ),
              MyText(
                text: 'are in Feb',
                size: 16,
                weight: FontWeight.w500,
                paddingBottom: 20,
              ),
              SizedBox(height: 220, child: _LineChart()),
              SizedBox(height: 8),
            ],
          ),
        ),
        SizedBox(height: 20),

        Container(
          padding: EdgeInsets.all(16),
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

                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 70,
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      height: 32,
                      decoration: BoxDecoration(
                        color: kLightBlueColor2,
                        border: Border.all(color: kBlueBorderColor),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: MyText(
                              paddingLeft: 4,
                              text: 'Offer',
                              size: 12,
                              weight: FontWeight.w600,
                              color: kSecondaryColor,
                            ),
                          ),
                          Image.asset(
                            Assets.imagesDropdown,
                            height: 16,
                            color: kSecondaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              MyText(
                paddingTop: 12,
                text: 'BOGO Pizza for Limited Time!',
                size: 14,
                color: kTertiaryColor,
                weight: FontWeight.w500,
                paddingBottom: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(3, (index) {
                  final stats = [
                    {'label': 'Total\nViews', 'value': '6,200'},
                    {'label': 'Total\nClicks', 'value': '590'},
                    {'label': 'Total\nRedemptions', 'value': '120'},
                  ];
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: stats[index]['label']!,
                          size: 11,
                          lineHeight: 1.5,
                          color: kQuaternaryColor,
                          paddingBottom: 6,
                        ),
                        MyText(
                          text: stats[index]['value']!,
                          size: 20,
                          weight: FontWeight.w500,
                        ),
                      ],
                    ),
                  );
                }),
              ),
              Container(
                height: 1,
                margin: EdgeInsets.symmetric(vertical: 12),
                color: kBorderColor,
              ),
              MyText(
                text: 'Get One Free Pizza – Today Only!',
                size: 14,
                color: kTertiaryColor,
                weight: FontWeight.w500,
                paddingBottom: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(3, (index) {
                  final stats = [
                    {'label': 'Total\nViews', 'value': '4,800'},
                    {'label': 'Total\nClicks', 'value': '410'},
                    {'label': 'Total\nRedemptions', 'value': '85'},
                  ];
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: stats[index]['label']!,
                          size: 11,
                          lineHeight: 1.5,
                          color: kQuaternaryColor,
                          paddingBottom: 6,
                        ),
                        MyText(
                          text: stats[index]['value']!,
                          size: 20,
                          weight: FontWeight.w500,
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Chart extends StatelessWidget {
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
          maximum: 2500,
          minimum: 0,
          interval: 500,
          isVisible: true,
          plotOffset: 10.0,
          majorGridLines: MajorGridLines(width: 1, color: kBorderColor),
          majorTickLines: MajorTickLines(width: 0),
          axisLine: AxisLine(width: 0),
          opposedPosition: false,
          labelStyle: TextStyle(
            color: kTertiaryColor,
            fontSize: 10.0,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.WORK_SANS,
          ),
        ),
        primaryXAxis: CategoryAxis(
          name: 'xAxis',
          maximum: 4,
          plotOffset: 5,
          majorGridLines: MajorGridLines(width: 0),
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(width: 0),
          labelStyle: TextStyle(
            color: kTertiaryColor,
            fontSize: 10.0,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.WORK_SANS,
          ),
        ),
        series: graphData(),
      ),
    );
  }

  List<StackedColumnSeries<ChartData, String>> graphData() {
    final List<ChartData> _dataSource = [
      ChartData(x: 'Impressions', y1: 1350, y2: 400, y3: 200),
      ChartData(x: 'Views', y1: 800, y2: 300, y3: 150),
      ChartData(x: 'Clicks', y1: 500, y2: 200, y3: 100),
      ChartData(x: 'Visits', y1: 1250, y2: 350, y3: 180),
      ChartData(x: 'Redemptions', y1: 950, y2: 320, y3: 140),
    ];
    return [
      StackedColumnSeries<ChartData, String>(
        dataSource: _dataSource,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y1,
        color: kSecondaryColor,
        width: 0.7,
        spacing: 0,
        name: 'A',
      ),
      StackedColumnSeries<ChartData, String>(
        dataSource: _dataSource,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y3,
        color: kLightBlueColor3,
        width: 0.7,
        spacing: 0,
        name: 'C',
      ),
      StackedColumnSeries<ChartData, String>(
        dataSource: _dataSource,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y2,
        color: Color(0xffEDFBFF),
        width: 0.7,
        spacing: 0,
        name: 'B',
      ),
    ];
  }
}

class ChartData {
  final String x;
  final double y1;
  final double y2;
  final double y3;

  ChartData({
    required this.x,
    required this.y1,
    required this.y2,
    required this.y3,
  });
}

class _LineChart extends StatefulWidget {
  @override
  State<_LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<_LineChart> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<_LineChartData> data = [
      _LineChartData('Jan', 120),
      _LineChartData('Feb', 230),
      _LineChartData('Mar', 180),
      _LineChartData('Apr', 260),
      _LineChartData('May', 210),
      _LineChartData('Jun', 300),
    ];
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
              labelPlacement: LabelPlacement.onTicks,
              majorGridLines: MajorGridLines(width: 0),
              majorTickLines: MajorTickLines(width: 0),
              axisLine: AxisLine(width: 0),
              labelStyle: TextStyle(
                color: kTertiaryColor,
                fontSize: 10.0,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.WORK_SANS,
              ),
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              interval: 50,
              isVisible: false,
              majorGridLines: MajorGridLines(width: 1, color: kBorderColor),
              axisLine: AxisLine(width: 0),
              labelStyle: TextStyle(
                color: kTertiaryColor,
                fontSize: 10.0,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.WORK_SANS,
              ),
            ),
            series: _getLineSeries(data),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentIndex = index;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color:
                      currentIndex == index
                          ? kLightBlueColor2
                          : Colors.transparent,
                ),
                child: Center(
                  child: MyText(
                    text: months[index],
                    size: 10,
                    weight: FontWeight.w500,
                    color:
                        currentIndex == index
                            ? kSecondaryColor
                            : kTertiaryColor,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  List<CartesianSeries<dynamic, dynamic>> _getLineSeries(
    List<_LineChartData> data,
  ) {
    return [
      LineSeries<_LineChartData, String>(
        name: 'Redemptions',
        dataSource: data,
        xValueMapper: (_LineChartData d, _) => d.label,
        yValueMapper: (_LineChartData d, _) => d.value,
        color: kSecondaryColor,
        width: 2,
        markerSettings: MarkerSettings(
          isVisible: true,
          color: kSecondaryColor,
          borderWidth: 2,
          borderColor: kPrimaryColor,
        ),
        dataLabelSettings: DataLabelSettings(isVisible: false),
        enableTooltip: true,
        dashArray: <double>[0, 0],
      ),
    ];
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_fonts.dart';
import 'package:snag/constants/app_images.dart';
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

class Users extends StatelessWidget {
  const Users({super.key});

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
                      text: 'Age Segmentation',
                      size: 14,
                      weight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 85,
                    child: AnOtherDropDown(
                      hint: 'Location',
                      items: ['Location', 'Urban', 'Suburban', 'Rural'],
                      selectedValue: 'Location',
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              MyText(
                paddingTop: 8,
                text: '50%',
                size: 28,
                weight: FontWeight.w500,
                color: kSecondaryColor,
              ),
              MyText(
                text: 'are in 18-25',
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
                      text: 'Age Segmentation',
                      size: 14,
                      weight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 85,
                    child: AnOtherDropDown(
                      hint: 'Location',
                      items: ['Location', 'Urban', 'Suburban', 'Rural'],
                      selectedValue: 'Location',
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              MyText(
                paddingTop: 8,
                text: '50%',
                size: 28,
                weight: FontWeight.w500,
                color: kSecondaryColor,
              ),
              MyText(
                text: 'are in 18-25',
                size: 16,
                weight: FontWeight.w500,
                paddingBottom: 20,
              ),
              SizedBox(
                height: 170,
                child: SfCircularChart(
                  series: <PieSeries<_PieChartData, String>>[
                    PieSeries<_PieChartData, String>(
                      dataSource: [
                        _PieChartData('', 30, kSecondaryColor),
                        _PieChartData('', 45, kGreenColor),
                        _PieChartData('', 25, kRedColor),
                      ],
                      radius: '100%',

                      xValueMapper: (_PieChartData data, _) => data.label,
                      yValueMapper: (_PieChartData data, _) => data.value,
                      pointColorMapper: (_PieChartData data, _) => data.color,
                      dataLabelMapper:
                          (_PieChartData data, _) => '${data.value}%',
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(color: kPrimaryColor),
                        builder: (
                          data,
                          point,
                          series,
                          pointIndex,
                          seriesIndex,
                        ) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MyText(
                                text: '${data.value.toInt()}%',
                                size: 12,
                                color: kPrimaryColor,
                                weight: FontWeight.w600,
                              ),
                              MyText(
                                text: data.label,
                                size: 10,
                                color: kPrimaryColor,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color:
                            index == 0
                                ? kGreenColor
                                : index == 1
                                ? kSecondaryColor
                                : kRedColor,
                      ),
                      SizedBox(width: 6),
                      MyText(
                        text:
                            index == 0
                                ? '18-25'
                                : index == 1
                                ? '26-35'
                                : '36-45',
                        color: kTertiaryColor,
                        weight: FontWeight.w500,
                        size: 12,
                      ),
                      if (index != 2) SizedBox(width: 16),
                    ],
                  );
                }),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        SizedBox(height: 20),

        GridView.builder(
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
            final List<Map<String, dynamic>> stats = [
              {
                'icon': Assets.imagesDollarRounded,
                'percent': '32%',
                'percentColor': kGreenColor,
                'percentText': ' vs Last Month',
                'label': 'Unique Users',
                'value': '5900',
              },
              {
                'icon': Assets.imagesTotalBranches,
                'percent': '20%',
                'percentColor': kGreenColor,
                'percentText': ' vs Last Month',
                'label': 'Repetitive Users',
                'value': '6000',
              },
            ];
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
          maximum: 5,
          minimum: 1,
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
      ChartData(x: 'M(18–24)', y1: 1350, y2: 400, y3: 200),
      ChartData(x: 'M(25–34)', y1: 800, y2: 300, y3: 150),
      ChartData(x: 'M(35–44)', y1: 500, y2: 200, y3: 100),
      ChartData(x: 'F(18–24)', y1: 1250, y2: 350, y3: 180),
      ChartData(x: 'F(25–34)', y1: 950, y2: 320, y3: 140),
      ChartData(x: 'F(35–44)', y1: 650, y2: 210, y3: 90),
    ];
    return [
      StackedColumnSeries<ChartData, String>(
        dataSource: _dataSource,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y2,
        color: Color(0xffEDFBFF),
        width: 0.7,
        spacing: 0,
        name: 'B',
      ),
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

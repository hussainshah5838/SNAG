import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_fonts.dart';
import 'package:snag/constants/app_images.dart';
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
                      text: 'DHA6 Location Made',
                      size: 14,
                      weight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 95,
                      height: 32,
                      decoration: BoxDecoration(
                        color: kLightBlueColor2,
                        border: Border.all(color: kBlueBorderColor),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        spacing: 4,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyText(
                            paddingLeft: 2,
                            text: 'Location',
                            size: 12,
                            weight: FontWeight.w600,
                            color: kSecondaryColor,
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
                text: '50%',
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
                child: SfCircularChart(
                  series: <PieSeries<_ChartData, String>>[
                    PieSeries<_ChartData, String>(
                      dataSource: [
                        _ChartData('', 30, kSecondaryColor),
                        _ChartData('', 45, kGreenColor),
                        _ChartData('', 25, kRedColor),
                      ],
                      radius: '100%',

                      xValueMapper: (_ChartData data, _) => data.label,
                      yValueMapper: (_ChartData data, _) => data.value,
                      pointColorMapper: (_ChartData data, _) => data.color,
                      dataLabelMapper: (_ChartData data, _) => '${data.value}%',
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
                                ? 'Dha 6'
                                : index == 1
                                ? 'Downtown'
                                : 'Gulberg',
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
          itemCount: 6,
          itemBuilder: (BuildContext context, int index) {
            final List<Map<String, dynamic>> stats = [
              {
                'icon': Assets.imagesTotalRedemptions,
                'percent': '',
                'percentColor': kTertiaryColor,
                'percentText': '',
                'label': 'Active Offers',
                'value': '5',
              },
              {
                'icon': Assets.imagesSavedOffers,
                'percent': '',
                'percentColor': kTertiaryColor,
                'percentText': '',
                'label': 'Saved Offers',
                'value': '12',
              },
              {
                'icon': Assets.imagesExpiredOffers,
                'percent': '',
                'percentColor': kTertiaryColor,
                'percentText': '',
                'label': 'Expired Offers',
                'value': '12',
              },
              {
                'icon': Assets.imagesLikeRounded,
                'percent': '',
                'percentColor': kTertiaryColor,
                'percentText': '',
                'label': 'No of Clicks',
                'value': '9,900',
              },
              {
                'icon': Assets.imagesDollarRounded,
                'percent': '32%',
                'percentColor': kGreenColor,
                'percentText': ' vs Last Month',
                'label': 'Top Branch',
                'value': 'Dha 6',
              },
              {
                'icon': Assets.imagesTotalBranches,
                'percent': '20%',
                'percentColor': kGreenColor,
                'percentText': ' vs Last Month',
                'label': 'Total Branches',
                'value': '3',
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

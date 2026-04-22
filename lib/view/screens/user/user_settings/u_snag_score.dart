import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/client_scorecard_controller.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

class USnagScore extends StatefulWidget {
  const USnagScore({super.key});

  @override
  State<USnagScore> createState() => _USnagScoreState();
}

class _USnagScoreState extends State<USnagScore> {
  late final ClientScorecardController _scorecardController;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<ClientScorecardController>()) {
      _scorecardController = Get.put(ClientScorecardController());
    } else {
      _scorecardController = ClientScorecardController.instance;
      if (_scorecardController.scorecard.value == null && !_scorecardController.isLoading.value) {
        _scorecardController.loadScorecard();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(),
      body: Obx(() {
        final isLoading = _scorecardController.isLoading.value;
        final streakWeeks = _scorecardController.streakWeeks;
        final offersRedeemed = _scorecardController.offersRedeemed;
        final userScore = _scorecardController.userScore;
        final avgMonthly = _scorecardController.avgMonthly;
        final mostSnagged = _scorecardController.mostSnagged;

        // Calculate streak progress (out of 4 weeks goal)
        final streakGoal = 4;
        final streakProgress = (streakWeeks / streakGoal * 100).clamp(0.0, 100.0).toDouble();

        if (isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
          shrinkWrap: true,
          padding: AppSizes.DEFAULT,
          physics: BouncingScrollPhysics(),
          children: [
            MyText(
              text: 'Snag Scorecard',
              size: 24,
              weight: FontWeight.w600,
              paddingBottom: 8,
            ),
            MyText(
              text:
                  'Track your progress and see how you\'re doing with your Snag activity.',
              size: 16,
              lineHeight: 1.5,
              weight: FontWeight.w500,
              color: kQuaternaryColor,
              paddingBottom: 30,
            ),
            Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: kFillColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kBorderColor, width: 1.0),
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 2,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(text: 'Streak Goal:', size: 10),
                      MyText(
                        text: '$streakWeeks/$streakGoal Weeks',
                        size: 10,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                  Expanded(
                    child: FlutterSlider(
                      min: 0,
                      max: 100,
                      values: [streakProgress],
                      disabled: true,
                      tooltip: FlutterSliderTooltip(disabled: true),
                      handler: FlutterSliderHandler(
                        decoration: BoxDecoration(),
                        child: Image.asset(Assets.imagesSliderThumb, height: 16),
                      ),
                      trackBar: FlutterSliderTrackBar(
                        activeTrackBarHeight: 8,
                        inactiveTrackBarHeight: 8,
                        activeTrackBar: BoxDecoration(
                          color: kLightBlueColor3,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        inactiveTrackBar: BoxDecoration(
                          color: kLightBlueColor4,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                  Image.asset(Assets.imagesSnagGift, height: 22),
                ],
              ),
            ),
            SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              padding: AppSizes.ZERO,
              physics: BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 120,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                final cards = [
                  {
                    'icon': Assets.imagesOffersRedeem,
                    'title': 'Offers Redeemed',
                    'subtitle': '$offersRedeemed',
                  },
                  {
                    'icon': Assets.imagesUserScore,
                    'title': 'User Score',
                    'subtitle': '$userScore',
                  },
                  {
                    'icon': Assets.imagesAvgMonthly,
                    'title': 'Avg. Monthly',
                    'subtitle': '$avgMonthly',
                  },
                  {
                    'icon': Assets.imagesMostSnaged,
                    'title': 'Most Snagged',
                    'subtitle': mostSnagged,
                  },
                ];
                final card = cards[index];
                return _ScoreCard(
                  icon: card['icon']!,
                  title: card['title']!,
                  subTitle: '${card['subtitle']}',
                  onTap: () {},
                  isSelected: false,
                );
              },
            ),
          ],
        );
      }),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: MyButton(
          buttonText: 'Done',
          onTap: () {
            Get.back();
          },
        ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subTitle;
  final VoidCallback onTap;
  final bool isSelected;

  const _ScoreCard({
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? kLightBlueColor : kFillColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? kSecondaryColor : kBorderColor,
            width: 1.0,
          ),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [Image.asset(icon, height: 28)]),
            MyText(
              paddingTop: 10,
              text: title,
              size: 14,
              color: kTertiaryColor,
              weight: FontWeight.w500,
            ),
            MyText(text: subTitle, size: 24, weight: FontWeight.w600),
          ],
        ),
      ),
    );
  }
}

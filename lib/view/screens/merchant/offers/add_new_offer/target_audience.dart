import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/screens/merchant/offers/add_new_offer/offer_checkout.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TargetAudience extends StatefulWidget {
  @override
  State<TargetAudience> createState() => _TargetAudienceState();
}

class _TargetAudienceState extends State<TargetAudience> {
  String _selectedRadius = 'Select radius...';
  final List<String> _demographics = ['18–24', '25–34', '35–44'];
  final List<String> _interests = ['Coffee', 'Fast Food', 'Fitness'];
  final List<String> _behaviors = [
    'Frequent Diners',
    'Deal Seekers',
    'High Spenders',
  ];
  List<String> _selectedDemographicsList = [];
  List<String> _selectedInterestsList = [];
  List<String> _selectedBehaviorsList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: ''),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          MyText(
            text: "Target Audience",
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 4,
          ),
          MyText(
            text:
                "Choose the right audience for your offer by considering location, interests, demographics, and behaviors.",
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          MultiDropDown(
            labelText: 'Demographics',
            hint: 'Select age group',
            isMandatory: false,
            items: _demographics,
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesTag, height: 20)],
            ),
            selectedValues: _selectedDemographicsList,
            onTap: (value) {
              setState(() {
                if (_selectedDemographicsList.contains(value)) {
                  _selectedDemographicsList.remove(value);
                } else {
                  _selectedDemographicsList.add(value);
                }
              });
            },
          ),
          MultiDropDown(
            labelText: 'Interests',
            hint: 'Select interests',
            isMandatory: false,
            items: _interests,
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesInterests, height: 20)],
            ),
            selectedValues: _selectedInterestsList,
            onTap: (value) {
              setState(() {
                if (_selectedInterestsList.contains(value)) {
                  _selectedInterestsList.remove(value);
                } else {
                  _selectedInterestsList.add(value);
                }
              });
            },
          ),
          MultiDropDown(
            labelText: 'Behavior',
            hint: 'Select behavior',
            isMandatory: false,
            items: _behaviors,
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesFood, height: 20)],
            ),
            selectedValues: _selectedBehaviorsList,
            onTap: (value) {
              setState(() {
                if (_selectedBehaviorsList.contains(value)) {
                  _selectedBehaviorsList.remove(value);
                } else {
                  _selectedBehaviorsList.add(value);
                }
              });
            },
          ),
          CustomDropDown(
            labelText: 'Radius (Km)',
            hint: 'Select radius...',
            items: [
              'Select radius...',
              '1 km',
              '2 km',
              '5 km',
              '10 km',
              '20 km',
              '50 km',
            ],
            selectedValue: _selectedRadius,
            prefix: Image.asset(Assets.imagesCountryIcon, height: 20),
            onChanged: (v) => setState(() => _selectedRadius = v),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: MyButton(
          buttonText: 'Next',
          onTap: () {
            Get.to(() => OfferCheckOut());
          },
        ),
      ),
    );
  }
}

import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserAddNewMeetup extends StatelessWidget {
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
            text: 'Add New Meetup',
            paddingTop: 8,
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text:
                'Bring people together with Snag. We’ll keep it simple and organized for you.',
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          MyTextField(
            labelText: 'Meetup Title',
            hintText: 'e.g., Weekend Shopping Spree',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesTt, height: 20)],
            ),
          ),
          MyTextField(
            maxLines: 2,
            labelText: 'Message to friends',
            hintText: 'e.g., Catching up with friends, planning an event',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesGps, height: 20)],
            ),
          ),
          MyTextField(
            labelText: 'Location',
            hintText: 'Search or enter a location',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesLoc, height: 20)],
            ),
            suffix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesMap, height: 20)],
            ),
          ),
          MyTextField(
            labelText: 'Date',
            hintText: 'Select date',
            isReadOnly: true,
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesDate, height: 16)],
            ),

            onTap: () async {},
          ),
          MyTextField(
            labelText: 'Time',
            hintText: 'Select time',
            isReadOnly: true,
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesClock, height: 20)],
            ),
            suffix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesStopWatch, height: 20)],
            ),
            onTap: () async {
              // Implement time picker logic here
            },
          ),
          MyTextField(
            labelText: 'Invite Participants',
            hintText: 'Invite by adding Email',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesParticipants, height: 20)],
            ),
            suffix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesLink, height: 20)],
            ),
          ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children:
                ['maherkashan7@gmail.com', 'Mudit456@gmail.com']
                    .map(
                      (value) => GestureDetector(
                        onTap: () {
                          // Handle remove participant logic here
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: kLightBlueColor2,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: kSecondaryColor),
                          ),
                          child: MyText(
                            paddingLeft: 4,
                            paddingRight: 4,
                            text: value,
                            size: 10,
                            color: kSecondaryColor,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: MyButton(buttonText: 'Add', onTap: () {}),
      ),
    );
  }
}

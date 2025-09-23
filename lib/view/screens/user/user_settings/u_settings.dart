import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/main.dart';
import 'package:snag/view/screens/user/user_settings/u_contact_support.dart';
import 'package:snag/view/screens/user/user_settings/u_preferences.dart';
import 'package:snag/view/screens/user/user_settings/u_profile_settings.dart';
import 'package:snag/view/screens/user/user_settings/u_saved_offers.dart';
import 'package:snag/view/screens/user/user_settings/u_snag_score.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class USettings extends StatefulWidget {
  const USettings({super.key});

  @override
  State<USettings> createState() => _USettingsState();
}

class _USettingsState extends State<USettings> {
  Set<int> selectedIndices = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 55),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kFillColor,
              border: Border.all(color: kBorderColor, width: 1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              children: [
                CommonImageView(
                  url: dummyImg,
                  height: 48,
                  width: 48,
                  fit: BoxFit.cover,
                  radius: 100,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: "Kashan Ali",
                        size: 16,
                        weight: FontWeight.w500,
                        paddingBottom: 4,
                      ),
                      MyText(
                        text: "kashan7@gmail.com",
                        size: 14,
                        maxLines: 2,
                        weight: FontWeight.w500,
                        textOverflow: TextOverflow.ellipsis,
                        color: kSecondaryColor,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                MyText(
                  onTap: () {
                    Get.to(() => UProfileSettings());
                  },
                  text: "Edit",
                  size: 14,
                  color: kSecondaryColor,
                  weight: FontWeight.w600,
                  paddingRight: 8,
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                MyText(
                  paddingTop: 12,
                  text: 'Account Settings',
                  size: 16,
                  weight: FontWeight.w600,
                  paddingBottom: 16,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  padding: AppSizes.ZERO,
                  physics: BouncingScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    final List<Map<String, dynamic>> settingsOptions = [
                      {
                        "title": "Saved Offers",
                        "image": Assets.imagesSavedOffersIcon,
                      },
                      {
                        "title": "Notifications",
                        "image": Assets.imagesNotificationSettings,
                      },
                    ];
                    return GestureDetector(
                      onTap: () {
                        switch (index) {
                          case 0:
                            Get.to(() => USavedOffers());
                            break;
                          case 1:
                            break;
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: kFillColor,
                          border: Border.all(color: kBorderColor, width: 1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              settingsOptions[index]["image"],
                              height: 36,
                              width: 36,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: MyText(
                                text: settingsOptions[index]["title"],
                                size: 16,
                                weight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 16),
                            Image.asset(Assets.imagesArrowNext, height: 24),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                MyText(
                  paddingTop: 12,
                  text: 'Activity & Preferences',
                  size: 16,
                  weight: FontWeight.w600,
                  paddingBottom: 16,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  padding: AppSizes.ZERO,
                  physics: BouncingScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final List<Map<String, dynamic>> settingsOptions = [
                      {"title": "Preferences", "image": Assets.imagesSnagScore},
                      {
                        "title": "Snag Scorecard",
                        "image": Assets.imagesSnagScore,
                      },
                      {
                        "title": "Delete Account",
                        "image": Assets.imagesDeleteAccount,
                      },
                      {"title": "Share Us", "image": Assets.imagesShareUsIcon},
                      {"title": "Rate Us", "image": Assets.imagesRateUsIcon},
                    ];
                    return GestureDetector(
                      onTap: () {
                        switch (index) {
                          case 0:
                            Get.to(() => UPreferences());
                            break;
                          case 1:
                            Get.to(() => USnagScore());
                            break;
                          case 2:
                            Get.dialog(_deleteAccount());
                            break;
                          case 3:
                            Get.dialog(_shareAppDialog());
                            break;
                          case 4:
                            Get.dialog(_feedbackDialog());
                            break;
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: kFillColor,
                          border: Border.all(color: kBorderColor, width: 1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              settingsOptions[index]["image"],
                              height: 36,
                              width: 36,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: MyText(
                                text: settingsOptions[index]["title"],
                                size: 16,
                                weight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 16),
                            Image.asset(Assets.imagesArrowNext, height: 24),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                MyText(
                  paddingTop: 12,
                  text: 'Support & Exit',
                  size: 16,
                  weight: FontWeight.w600,
                  paddingBottom: 16,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  padding: AppSizes.ZERO,
                  physics: BouncingScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    final List<Map<String, dynamic>> settingsOptions = [
                      {"title": "Support", "image": Assets.imagesSupport},
                      {"title": "Log out", "image": Assets.imagesLogoutIcon},
                    ];
                    return GestureDetector(
                      onTap: () {
                        switch (index) {
                          case 0:
                            Get.to(() => UContactSupport());
                            break;
                          case 1:
                            Get.dialog(_logoutDialog());
                            break;
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: kFillColor,
                          border: Border.all(color: kBorderColor, width: 1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              settingsOptions[index]["image"],
                              height: 36,
                              width: 36,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: MyText(
                                text: settingsOptions[index]["title"],
                                size: 16,
                                weight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 16),
                            Image.asset(Assets.imagesArrowNext, height: 24),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _shareAppDialog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
            margin: AppSizes.DEFAULT,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kFillColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: kBorderColor, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Image.asset(Assets.imagesSpreadLove, height: 52)],
                ),
                MyText(
                  textAlign: TextAlign.center,
                  paddingTop: 16,
                  text: 'Spread the word!',
                  size: 20,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                MyText(
                  text:
                      'Love using Snag? Share it with your friends and colleagues to help them save time too!',
                  size: 14,
                  lineHeight: 1.5,
                  weight: FontWeight.w500,
                  color: kQuaternaryColor,
                  textAlign: TextAlign.center,
                  paddingBottom: 24,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: MyTextField(
                        marginBottom: 0,
                        labelText: 'Share link',
                        hintText: 'https://www.snag.com/referral?user=Kashan!',
                      ),
                    ),
                    SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: Image.asset(Assets.imagesCopy, height: 20),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                MyButton(
                  height: 42,
                  buttonText: 'Share',
                  onTap: () {
                    Get.back();
                  },
                ),
                SizedBox(height: 12),
                MyBorderButton(
                  buttonColor: kGreyColor2,
                  height: 42,
                  buttonText: 'Cancel',
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column _feedbackDialog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
            margin: AppSizes.DEFAULT,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kFillColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: kBorderColor, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(Assets.imagesRateUs, height: 48),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, right: 4),
                        child: Image.asset(Assets.imagesCloseIcon, height: 14),
                      ),
                    ),
                  ],
                ),
                MyText(
                  paddingTop: 16,
                  text: 'We value your feedback!',
                  size: 20,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                MyText(
                  text:
                      'Enjoying Our App? Rate us on the app store and help us improve!',
                  size: 15,
                  lineHeight: 1.5,
                  weight: FontWeight.w500,
                  color: kQuaternaryColor,
                  paddingBottom: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: RatingBar(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 32,
                    glow: false,
                    itemPadding: EdgeInsets.only(right: 12),
                    onRatingUpdate: (rating) {
                      // Handle rating update if needed
                    },
                    ratingWidget: RatingWidget(
                      full: Image.asset(Assets.imagesStarFilled, height: 32),
                      half: Image.asset(Assets.imagesStarEmpty, height: 32),
                      empty: Image.asset(Assets.imagesStarEmpty, height: 32),
                    ),
                  ),
                ),
                MyButton(
                  height: 42,
                  buttonText: 'Rate Us Now',
                  onTap: () {
                    Get.back();
                    // Add your rate us logic here
                  },
                ),
                SizedBox(height: 12),
                MyBorderButton(
                  buttonColor: kGreyColor2,
                  height: 42,
                  buttonText: 'Cancel',
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column _logoutDialog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
            margin: AppSizes.DEFAULT,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kFillColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: kBorderColor, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(Assets.imagesConfirmLogout, height: 48),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, right: 4),
                        child: Image.asset(Assets.imagesCloseIcon, height: 14),
                      ),
                    ),
                  ],
                ),
                MyText(
                  paddingTop: 16,
                  text: 'Confirm logout?',
                  size: 20,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                MyText(
                  text:
                      'Are you sure you want to log out? Unsaved changes may be lost, but your data will remain secure.',
                  size: 15,
                  lineHeight: 1.5,
                  weight: FontWeight.w500,
                  color: kQuaternaryColor,
                  paddingBottom: 24,
                ),
                MyButton(
                  height: 42,
                  buttonText: 'Confirm',
                  onTap: () {
                    Get.back();
                    // Add your logout logic here
                  },
                ),
                SizedBox(height: 12),
                MyBorderButton(
                  buttonColor: kGreyColor2,
                  height: 42,
                  buttonText: 'Cancel',
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column _deleteAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
            margin: AppSizes.DEFAULT,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kFillColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: kBorderColor, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(Assets.imagesDeleteProfile, height: 48),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, right: 4),
                        child: Image.asset(Assets.imagesCloseIcon, height: 14),
                      ),
                    ),
                  ],
                ),
                MyText(
                  paddingTop: 16,
                  text: 'Delete Your Profile?',
                  size: 20,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                MyText(
                  text:
                      'If you delete your profile, all your data and connections will be permanently removed. This can’t be undone.',
                  size: 15,
                  lineHeight: 1.5,
                  weight: FontWeight.w500,
                  color: kQuaternaryColor,
                  paddingBottom: 24,
                ),
                MyButton(
                  height: 42,
                  buttonText: 'Delete',
                  onTap: () {
                    Get.back();
                    // Add your logout logic here
                  },
                ),
                SizedBox(height: 12),
                MyBorderButton(
                  buttonColor: kGreyColor2,
                  height: 42,
                  buttonText: 'Cancel',
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

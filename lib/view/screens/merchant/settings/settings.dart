import 'package:flutter/services.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_fonts.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/auth_controller.dart';
import 'package:snag/controllers/merchant_profile_controller.dart';
import 'package:snag/main.dart';
import 'package:snag/view/screens/merchant/billing_payments/billing_payments.dart';
import 'package:snag/view/screens/merchant/settings/faq.dart';
import 'package:snag/view/screens/merchant/settings/edit_profile.dart';
import 'package:snag/view/screens/merchant/settings/locations/business_locations.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Set<int> selectedIndices = {};
  final _authController = AuthController.instance;
  final _profileController = Get.put(MerchantProfileController());

  @override
  void initState() {
    super.initState();
    _profileController.fetchBranchProfile();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(() {
            final isLoading = _profileController.isLoading.value;
            final branchName = _profileController.branchName ?? 'Loading...';
            final email = _authController.user.value?.email ?? '';
            final logoUrl = _profileController.logoUrl;

            return Container(
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
                    url: logoUrl ?? dummyImg,
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
                          text: isLoading ? 'Loading...' : branchName,
                          size: 16,
                          weight: FontWeight.w500,
                          paddingBottom: 4,
                        ),
                        MyText(
                          text: email,
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
                      Get.to(() => EditProfile());
                    },
                    text: "Edit",
                    size: 14,
                    color: kSecondaryColor,
                    weight: FontWeight.w600,
                    paddingRight: 8,
                  ),
                ],
              ),
            );
          }),

          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                MyText(
                  paddingTop: 12,
                  text: 'Basic Info',
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
                        "title": "Locations",
                        "subtitle": "Your locations",
                        "image": Assets.imagesYourLocations,
                      },
                      {
                        "title": "Billing & Payments",
                        "subtitle": "Manage payments and billing.",
                        "image": Assets.imagesBillingPayments,
                      },
                    ];
                    return GestureDetector(
                      onTap: () {
                        switch (index) {
                          case 0:
                            Get.to(() => BusinessLocations());
                            break;
                          case 1:
                            Get.to(() => BillingPayments());
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  MyText(
                                    text: settingsOptions[index]["title"],
                                    size: 16,
                                    weight: FontWeight.w600,
                                    paddingBottom: 4,
                                  ),
                                  MyText(
                                    text: settingsOptions[index]["subtitle"],
                                    size: 14,
                                    color: kQuaternaryColor,
                                    weight: FontWeight.w500,
                                  ),
                                ],
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
                  text: 'Account Info',
                  size: 16,
                  weight: FontWeight.w600,
                  paddingBottom: 16,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  padding: AppSizes.ZERO,
                  physics: BouncingScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final List<Map<String, dynamic>> settingsOptions = [
                      {
                        "title": "Help & FAQ’s",
                        "subtitle": "Get help",
                        "image": Assets.imagesHelpAndFaq,
                      },
                      {
                        "title": "Delete Account",
                        "subtitle": "Close account",
                        "image": Assets.imagesDeleteAccount,
                      },
                      {
                        "title": "Logout",
                        "subtitle": "Sign out",
                        "image": Assets.imagesLogoutIcon,
                      },
                    ];
                    return GestureDetector(
                      onTap: () {
                        switch (index) {
                          case 0:
                            Get.to(() => Faq());
                            break;
                          case 1:
                            Get.dialog(_deleteAccount());
                            break;
                          case 2:
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  MyText(
                                    text: settingsOptions[index]["title"],
                                    size: 16,
                                    weight: FontWeight.w600,
                                    paddingBottom: 4,
                                  ),
                                  MyText(
                                    text: settingsOptions[index]["subtitle"],
                                    size: 14,
                                    color: kQuaternaryColor,
                                    weight: FontWeight.w500,
                                  ),
                                ],
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
                  text: 'Share Info',
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
                        "title": "Share Us",
                        "subtitle": "Invite others",
                        "image": Assets.imagesShareUsIcon,
                      },
                      {
                        "title": "Rate Us",
                        "subtitle": "Give feedback",
                        "image": Assets.imagesRateUsIcon,
                      },
                    ];
                    return GestureDetector(
                      onTap: () {
                        switch (index) {
                          case 0:
                            Get.dialog(_shareAppDialog());
                            break;
                          case 1:
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  MyText(
                                    text: settingsOptions[index]["title"],
                                    size: 16,
                                    weight: FontWeight.w600,
                                    paddingBottom: 4,
                                  ),
                                  MyText(
                                    text: settingsOptions[index]["subtitle"],
                                    size: 14,
                                    color: kQuaternaryColor,
                                    weight: FontWeight.w500,
                                  ),
                                ],
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
                        hintText: 'https://www.snag.com/referral?user=Kashan',
                      ),
                    ),
                    SizedBox(width: 12),
                    GestureDetector(
                      onTap: () async {
                        final link =
                            'https://www.snag.com/referral?user=Kashan';
                        final message =
                            'Hey check out this awesome app:\n$link';
                        await Clipboard.setData(ClipboardData(text: message));
                        // show confirmation
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Link copied to clipboard',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: AppFonts.WORK_SANS,
                              ),
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18),
                        child: Image.asset(Assets.imagesCopy, height: 20),
                      ),
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
                  borderColor: kGreyColor2,
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
                    initialRating: 5,
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
                  borderColor: kGreyColor2,
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
                  onTap: () async {
                    Get.back(); // Close dialog
                    await _authController.logout();
                  },
                ),
                SizedBox(height: 12),
                MyBorderButton(
                  borderColor: kGreyColor2,
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
                  onTap: () async {
                    Get.back(); // Close dialog
                    await _authController.deleteAccount();
                  },
                ),
                SizedBox(height: 12),
                MyBorderButton(
                  borderColor: kGreyColor2,
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

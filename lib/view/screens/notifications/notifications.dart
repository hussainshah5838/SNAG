import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> users = [
      {
        "name": "New Redemption Alert",
        "message":
            "Your offer ‘Weekend Flash Deal’ was just redeemed by a customer.",
      },
      {
        "name": "Offer Expiring",
        "message":
            "Your ‘Back to School Special’ ends in 24 hours. Extend or update it now to keep it live.",
      },
      {
        "name": "Payout Sent",
        "message":
            "Your payout of \$1,250.00 has been processed and should reach your account shortly.",
      },
      {
        "name": "Payment Details",
        "message":
            "Your payout failed because your bank details need an update. Please check your payout settings.",
      },
      {
        "name": "Location Details",
        "message":
            "Your ‘Downtown Outlet’ branch information was successfully updated.",
      },
      {
        "name": "New Feature",
        "message":
            "You can now duplicate offers faster. Try it from your Offers list!",
      },
      {
        "name": "Offer Expiring",
        "message":
            "Your ‘Back to School Special’ ends in 24 hours. Extend or update it now to keep it live.",
      },
    ];

    return Scaffold(
      appBar: simpleAppBar(),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          MyText(
            text: 'Notifications',
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text:
                'Stay updated on offers, redemptions, payouts, & account alerts.',
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: AppSizes.ZERO,
            physics: BouncingScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return NotificationUserTile(user: user);
            },
          ),
        ],
      ),
    );
  }
}

class NotificationUserTile extends StatelessWidget {
  final Map<String, dynamic> user;

  const NotificationUserTile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: kFillColor,
            border: Border.all(color: kBorderColor, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(Assets.imagesNAvatar, height: 32),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MyText(
                      text: user["name"] ?? "",
                      size: 16,
                      weight: FontWeight.w600,
                      paddingBottom: 4,
                    ),
                    if (user["message"] != null)
                      MyText(
                        text: user["message"] ?? "",
                        size: 14,
                        lineHeight: 1.5,
                        weight: FontWeight.w500,
                        color: kQuaternaryColor,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

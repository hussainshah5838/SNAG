import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

class UserNotifications extends StatelessWidget {
  const UserNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> users = [
      {
        "name": "You Snagged It!",
        "date": "20 May, 2025",
        "message":
            "Your 15% off at McCafe has been added to your Redemptions. Show it in-store to redeem.",
      },
      {
        "name": "New Offer!",
        "date": "20 May, 2025",
        "message":
            "Domino’s just dropped a 20% off deal near your location. Snag it before it’s gone!",
      },
      {
        "name": "Offer Expire",
        "date": "20 May, 2025",
        "message":
            "Your Starbucks deal ends in 2 hours. Don’t miss your chance to redeem it!",
      },
      {
        "name": "Offer Saved",
        "date": "20 May, 2025",
        "message":
            "We saved the KFC deal to your profile. You can snag it anytime before it expires.",
      },
      {
        "name": "You Referred a Friend!",
        "date": "20 May, 2025",
        "message":
            "Your friend just joined SNAG using your code. You’re one step closer to a reward!",
      },
      {
        "name": "Flash Deal Alert 🔥",
        "date": "20 May, 2025",
        "message":
            "Burger Lab just increased their discount to 30% — available for the next 60 minutes.",
      },
      {
        "name": "Redemption Alert",
        "date": "20 May, 2025",
        "message":
            "New redemption alert: John Doe just snagged your 10% Off Deal.",
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

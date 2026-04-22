import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/notification_controller.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final controller = Get.put(NotificationController());
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        if (!controller.isLoading.value && controller.hasMore.value) {
          controller.fetchNotifications(loadMore: true);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return DateFormat('MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        actions: [
          Obx(() => controller.unreadCount.value > 0
              ? Center(
                  child: GestureDetector(
                    onTap: () => controller.markAllAsRead(),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: MyText(
                        text: 'Mark all read',
                        size: 14,
                        weight: FontWeight.w600,
                        color: kSecondaryColor,
                      ),
                    ),
                  ),
                )
              : SizedBox()),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.error.value != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(text: 'Error: ${controller.error.value}', color: Colors.red),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchNotifications(),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }
        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Assets.imagesNAvatar, height: 120),
                SizedBox(height: 20),
                MyText(text: 'No notifications yet', size: 18, weight: FontWeight.w600),
                SizedBox(height: 8),
                MyText(text: 'We\'ll notify you when something arrives', size: 14, color: kQuaternaryColor),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchNotifications(),
          child: ListView(
            controller: _scrollController,
            padding: AppSizes.DEFAULT,
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(text: 'Notifications', size: 24, weight: FontWeight.w600, paddingBottom: 8),
                  if (controller.unreadCount.value > 0)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: kSecondaryColor, borderRadius: BorderRadius.circular(12)),
                      child: MyText(text: '${controller.unreadCount.value}', size: 14, weight: FontWeight.w600, color: kPrimaryColor),
                    ),
                ],
              ),
              MyText(
                text: 'Stay updated on offers, redemptions, payouts, & account alerts.',
                size: 16,
                lineHeight: 1.5,
                weight: FontWeight.w500,
                color: kQuaternaryColor,
                paddingBottom: 30,
              ),
              ListView.builder(
                shrinkWrap: true,
                padding: AppSizes.ZERO,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.notifications.length,
                itemBuilder: (context, index) {
                  final notification = controller.notifications[index];
                  return NotificationUserTile(
                    notification: notification,
                    formattedDate: _formatDate(notification.createdAt),
                    onTap: () async {
                      if (!notification.read) await controller.markAsRead(notification.id);
                    },
                    onDelete: () => controller.deleteNotification(notification.id),
                  );
                },
              ),
              if (controller.isLoading.value && controller.notifications.isNotEmpty)
                Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
            ],
          ),
        );
      }),
    );
  }
}

class NotificationUserTile extends StatelessWidget {
  final dynamic notification;
  final String formattedDate;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NotificationUserTile({
    Key? key,
    required this.notification,
    required this.formattedDate,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.read;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(notification.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
          child: Icon(Icons.delete, color: Colors.white),
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUnread ? kLightBlueColor : kFillColor,
              border: Border.all(color: isUnread ? kSecondaryColor : kBorderColor, width: isUnread ? 2 : 1),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: MyText(text: notification.title, size: 16, weight: FontWeight.w600, paddingBottom: 4)),
                          MyText(text: formattedDate, size: 12, color: kQuaternaryColor),
                        ],
                      ),
                      MyText(text: notification.message, size: 14, lineHeight: 1.5, weight: FontWeight.w500, color: kQuaternaryColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

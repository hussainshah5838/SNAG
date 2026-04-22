import 'package:get/get.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';
import '../services/socket_service.dart';

/// Notification controller - manages notifications state and real-time updates
class NotificationController extends GetxController {
  final _service = NotificationService.instance;
  final _socketService = SocketService.instance;

  // State
  final isLoading = false.obs;
  final notifications = <NotificationModel>[].obs;
  final unreadCount = 0.obs;
  final error = Rxn<String>();

  // Pagination
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Setup socket listeners
    _socketService.onNotificationReceived = _handleNewNotification;
    _socketService.onConnected = () {
      // Socket connected
    };
    _socketService.onDisconnected = () {
      // Socket disconnected
    };
    
    // Connect socket if not already connected
    if (!_socketService.isConnected) {
      _socketService.connect();
    }
    
    // Fetch initial notifications
    fetchNotifications();
    fetchUnreadCount();
  }

  @override
  void onClose() {
    // Don't disconnect socket here - it's shared across app
    super.onClose();
  }

  /// Handle new notification from Socket.IO
  void _handleNewNotification(Map<String, dynamic> data) {
    try {
      final notification = NotificationModel.fromJson(data);
      
      // Add to top of list
      notifications.insert(0, notification);
      
      // Increment unread count if not read
      if (!notification.read) {
        unreadCount.value++;
      }
      
      // Show snackbar
      Get.snackbar(
        notification.title,
        notification.message,
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      // Error parsing notification
    }
  }

  /// Fetch notifications with filters
  Future<void> fetchNotifications({
    String? type,
    bool? read,
    bool loadMore = false,
  }) async {
    try {
      if (loadMore) {
        if (!hasMore.value) return;
        currentPage.value++;
      } else {
        isLoading.value = true;
        currentPage.value = 1;
      }

      error.value = null;

      final result = await _service.getNotifications(
        type: type,
        read: read,
        page: currentPage.value,
        limit: 20,
      );

      result
          .onSuccess((data) {
            if (loadMore) {
              notifications.addAll(data.notifications);
            } else {
              notifications.value = data.notifications;
            }
            
            totalPages.value = data.totalPages;
            hasMore.value = currentPage.value < data.totalPages;
            unreadCount.value = data.unreadCount;
          })
          .onFailure((err) {
            error.value = err.message;
          });
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch unread count
  Future<void> fetchUnreadCount() async {
    final result = await _service.getUnreadCount();
    result.onSuccess((count) {
      unreadCount.value = count;
    });
  }

  /// Mark notification as read
  Future<void> markAsRead(String id) async {
    final result = await _service.markAsRead(id, read: true);
    
    result.onSuccess((updatedNotification) {
      // Update in list
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        final oldNotification = notifications[index];
        if (!oldNotification.read) {
          unreadCount.value--;
        }
        notifications[index] = updatedNotification;
      }
    });
  }

  /// Mark all as read
  Future<void> markAllAsRead() async {
    final result = await _service.markAllAsRead();
    
    result.onSuccess((count) {
      // Update all notifications in list
      notifications.value = notifications.map((n) {
        return NotificationModel(
          id: n.id,
          userId: n.userId,
          userType: n.userType,
          type: n.type,
          title: n.title,
          message: n.message,
          read: true,
          metadata: n.metadata,
          createdAt: n.createdAt,
        );
      }).toList();
      
      unreadCount.value = 0;
      Get.snackbar('Success', 'All notifications marked as read');
    });
  }

  /// Delete notification
  Future<void> deleteNotification(String id) async {
    final result = await _service.deleteNotification(id);
    
    result.onSuccess((message) {
      // Remove from list
      final notification = notifications.firstWhere((n) => n.id == id);
      if (!notification.read) {
        unreadCount.value--;
      }
      notifications.removeWhere((n) => n.id == id);
      
      Get.snackbar('Success', message);
    });
  }
}

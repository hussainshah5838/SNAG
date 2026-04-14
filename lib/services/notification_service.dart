import '../core/errors/app_exception.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../core/utils/result.dart';
import '../models/notification_model.dart';

/// Notification service - fetch and manage notifications
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _client = ApiClient.instance;

  // ── Get Notifications ───────────────────────────────────────────────────────

  /// Get paginated notifications with filters
  Future<Result<PaginatedNotificationsResponse>> getNotifications({
    String? type, // 'offer', 'redemption', 'system', 'all'
    bool? read,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      
      if (type != null) queryParams['type'] = type;
      if (read != null) queryParams['read'] = read;

      final res = await _client.get(
        ApiEndpoints.notifications,
        query: queryParams,
      );

      final data = PaginatedNotificationsResponse.fromJson(
        res.data['data'] as Map<String, dynamic>,
      );
      
      return Result.success(data);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  // ── Get Notification by ID ──────────────────────────────────────────────────

  /// Get single notification by ID
  Future<Result<NotificationModel>> getNotificationById(String id) async {
    try {
      final res = await _client.get('${ApiEndpoints.notifications}/$id');
      
      final data = NotificationModel.fromJson(
        res.data['data'] as Map<String, dynamic>,
      );
      
      return Result.success(data);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  // ── Mark as Read ────────────────────────────────────────────────────────────

  /// Mark notification as read/unread
  Future<Result<NotificationModel>> markAsRead(String id, {bool read = true}) async {
    try {
      final res = await _client.patch(
        '${ApiEndpoints.notifications}/$id/read',
        data: {'read': read},
      );

      final data = NotificationModel.fromJson(
        res.data['data'] as Map<String, dynamic>,
      );
      
      return Result.success(data);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  // ── Mark All as Read ────────────────────────────────────────────────────────

  /// Mark all notifications as read
  Future<Result<int>> markAllAsRead() async {
    try {
      final res = await _client.patch('${ApiEndpoints.notifications}/read-all');
      
      final count = res.data['data']['modifiedCount'] as int;
      
      return Result.success(count);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  // ── Delete Notification ─────────────────────────────────────────────────────

  /// Delete a notification
  Future<Result<String>> deleteNotification(String id) async {
    try {
      final res = await _client.delete('${ApiEndpoints.notifications}/$id');
      
      final message = res.data['message'] as String? ?? 'Notification deleted';
      
      return Result.success(message);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  // ── Get Unread Count ────────────────────────────────────────────────────────

  /// Get count of unread notifications
  Future<Result<int>> getUnreadCount() async {
    try {
      final res = await _client.get('${ApiEndpoints.notifications}/unread/count');
      
      final count = res.data['data']['count'] as int;
      
      return Result.success(count);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }
}

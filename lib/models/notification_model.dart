/// Notification model matching backend Notification schema
class NotificationModel {
  final String id;
  final String userId;
  final String userType; // 'merchant' | 'client'
  final String type; // 'offer' | 'redemption' | 'system'
  final String title;
  final String message;
  final bool read;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.userType,
    required this.type,
    required this.title,
    required this.message,
    required this.read,
    this.metadata,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      userType: json['userType'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      read: json['read'] as bool,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

/// Paginated notifications response
class PaginatedNotificationsResponse {
  final List<NotificationModel> notifications;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final int unreadCount;

  const PaginatedNotificationsResponse({
    required this.notifications,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.unreadCount,
  });

  factory PaginatedNotificationsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedNotificationsResponse(
      notifications: (json['notifications'] as List)
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
      totalPages: json['totalPages'] as int,
      unreadCount: json['unreadCount'] as int,
    );
  }
}

/// Merchant notification settings model matching backend MerchantSettings schema
class MerchantSettingsModel {
  final String id;
  final MerchantNotificationSettings notifications;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MerchantSettingsModel({
    required this.id,
    required this.notifications,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MerchantSettingsModel.fromJson(Map<String, dynamic> json) {
    return MerchantSettingsModel(
      id: json['_id'] as String,
      notifications: MerchantNotificationSettings.fromJson(
        json['notifications'] as Map<String, dynamic>,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications.toJson(),
    };
  }
}

class MerchantNotificationSettings {
  final EmailNotifications email;
  final PushNotifications push;
  final SmsNotifications sms;

  const MerchantNotificationSettings({
    required this.email,
    required this.push,
    required this.sms,
  });

  factory MerchantNotificationSettings.fromJson(Map<String, dynamic> json) {
    return MerchantNotificationSettings(
      email: EmailNotifications.fromJson(json['email'] as Map<String, dynamic>),
      push: PushNotifications.fromJson(json['push'] as Map<String, dynamic>),
      sms: SmsNotifications.fromJson(json['sms'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email.toJson(),
      'push': push.toJson(),
      'sms': sms.toJson(),
    };
  }
}

class EmailNotifications {
  final bool newRedemption;
  final bool offerExpiring;
  final bool weeklyReport;
  final bool systemUpdates;

  const EmailNotifications({
    required this.newRedemption,
    required this.offerExpiring,
    required this.weeklyReport,
    required this.systemUpdates,
  });

  factory EmailNotifications.fromJson(Map<String, dynamic> json) {
    return EmailNotifications(
      newRedemption: json['newRedemption'] as bool,
      offerExpiring: json['offerExpiring'] as bool,
      weeklyReport: json['weeklyReport'] as bool,
      systemUpdates: json['systemUpdates'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'newRedemption': newRedemption,
      'offerExpiring': offerExpiring,
      'weeklyReport': weeklyReport,
      'systemUpdates': systemUpdates,
    };
  }
}

class PushNotifications {
  final bool newRedemption;
  final bool offerExpiring;
  final bool lowStock;

  const PushNotifications({
    required this.newRedemption,
    required this.offerExpiring,
    required this.lowStock,
  });

  factory PushNotifications.fromJson(Map<String, dynamic> json) {
    return PushNotifications(
      newRedemption: json['newRedemption'] as bool,
      offerExpiring: json['offerExpiring'] as bool,
      lowStock: json['lowStock'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'newRedemption': newRedemption,
      'offerExpiring': offerExpiring,
      'lowStock': lowStock,
    };
  }
}

class SmsNotifications {
  final bool newRedemption;
  final bool criticalAlerts;

  const SmsNotifications({
    required this.newRedemption,
    required this.criticalAlerts,
  });

  factory SmsNotifications.fromJson(Map<String, dynamic> json) {
    return SmsNotifications(
      newRedemption: json['newRedemption'] as bool,
      criticalAlerts: json['criticalAlerts'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'newRedemption': newRedemption,
      'criticalAlerts': criticalAlerts,
    };
  }
}

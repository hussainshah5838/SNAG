/// Client preferences model matching backend Preferences schema
class PreferencesModel {
  final String id;
  final NotificationPreferences notifications;
  final String language;
  final String distanceUnit;
  final String currency;
  final PrivacySettings privacy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PreferencesModel({
    required this.id,
    required this.notifications,
    required this.language,
    required this.distanceUnit,
    required this.currency,
    required this.privacy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PreferencesModel.fromJson(Map<String, dynamic> json) {
    return PreferencesModel(
      id: json['_id'] as String,
      notifications: NotificationPreferences.fromJson(
        json['notifications'] as Map<String, dynamic>,
      ),
      language: json['language'] as String,
      distanceUnit: json['distanceUnit'] as String,
      currency: json['currency'] as String,
      privacy: PrivacySettings.fromJson(
        json['privacy'] as Map<String, dynamic>,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications.toJson(),
      'language': language,
      'distanceUnit': distanceUnit,
      'currency': currency,
      'privacy': privacy.toJson(),
    };
  }
}

class NotificationPreferences {
  final bool email;
  final bool push;
  final bool sms;

  const NotificationPreferences({
    required this.email,
    required this.push,
    required this.sms,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      email: json['email'] as bool,
      push: json['push'] as bool,
      sms: json['sms'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'push': push,
      'sms': sms,
    };
  }
}

class PrivacySettings {
  final bool showProfile;
  final bool shareLocation;

  const PrivacySettings({
    required this.showProfile,
    required this.shareLocation,
  });

  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return PrivacySettings(
      showProfile: json['showProfile'] as bool,
      shareLocation: json['shareLocation'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showProfile': showProfile,
      'shareLocation': shareLocation,
    };
  }
}

import '../constants/app_constants.dart';

/// Dart equivalent of the backend's IUser interface + UserResponse mapper.
/// Only contains fields the backend actually returns (never password etc).

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final bool isVerified;
  final int onboardingStep;

  // Client-only fields
  final String? userName;
  final String? phoneNumber;
  final String? avatarUrl;
  final List<String>? interests;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.isVerified,
    required this.onboardingStep,
    this.userName,
    this.phoneNumber,
    this.avatarUrl,
    this.interests,
  });

  /// Deserialize from backend JSON response.
  /// Equivalent to a TypeScript mapper / fromJSON factory.
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id:             json['id'] as String,
        firstName:      json['firstName'] as String,
        lastName:       json['lastName'] as String,
        email:          json['email'] as String,
        role:           json['role'] as String,
        isVerified:     json['isVerified'] as bool,
        onboardingStep: json['onboardingStep'] as int,
        userName:       json['userName'] as String?,
        phoneNumber:    json['phoneNumber'] as String?,
        avatarUrl:      json['avatarUrl'] as String?,
        interests:      (json['interests'] as List<dynamic>?)
                            ?.map((e) => e as String)
                            .toList(),
      );

  /// Serialize to JSON (useful for caching locally)
  Map<String, dynamic> toJson() => {
        'id':             id,
        'firstName':      firstName,
        'lastName':       lastName,
        'email':          email,
        'role':           role,
        'isVerified':     isVerified,
        'onboardingStep': onboardingStep,
        if (userName != null)    'userName':    userName,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
        if (avatarUrl != null)   'avatarUrl':   avatarUrl,
        if (interests != null)   'interests':   interests,
      };

  /// Convenience getter — uses UserRoles constants, never raw strings
  bool get isMerchant => role == UserRoles.merchant;
  bool get isClient   => role == UserRoles.client;
}

/// Client profile model
class ProfileModel {
  final String id;
  final String? firstName;
  final String? lastName;
  final String email;
  final String? userName;
  final String? phoneNumber;
  final List<String> interests;
  final String? avatarUrl;
  final LocationData? location;
  final DateTime createdAt;

  const ProfileModel({
    required this.id,
    this.firstName,
    this.lastName,
    required this.email,
    this.userName,
    this.phoneNumber,
    required this.interests,
    this.avatarUrl,
    this.location,
    required this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json['id'] as String,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        email: json['email'] as String,
        userName: json['userName'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
        interests: (json['interests'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        avatarUrl: json['avatarUrl'] as String?,
        location: json['location'] != null
            ? LocationData.fromJson(json['location'] as Map<String, dynamic>)
            : null,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'userName': userName,
        'phoneNumber': phoneNumber,
        'interests': interests,
        'avatarUrl': avatarUrl,
        'location': location?.toJson(),
        'createdAt': createdAt.toIso8601String(),
      };
}

/// Location data nested in profile
class LocationData {
  final String type;
  final List<double> coordinates;
  final String? address;

  const LocationData({
    required this.type,
    required this.coordinates,
    this.address,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    List<double> coords;
    if (json['coordinates'] != null) {
      // GeoJSON format: [lng, lat]
      coords = (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList();
    } else if (json['lat'] != null && json['lng'] != null) {
      // {lat, lng} format from backend
      coords = [(json['lng'] as num).toDouble(), (json['lat'] as num).toDouble()];
    } else {
      coords = [];
    }
    return LocationData(
      type: json['type'] as String? ?? 'Point',
      coordinates: coords,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
        'address': address,
      };
}

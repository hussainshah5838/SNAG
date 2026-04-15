/// Location of a merchant branch — populated from locationIds by backend
class OfferLocation {
  final String id;
  final double lat;
  final double lng;
  final String? address;

  const OfferLocation({
    required this.id,
    required this.lat,
    required this.lng,
    this.address,
  });

  factory OfferLocation.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'] as Map<String, dynamic>?;
    return OfferLocation(
      id: json['_id'] as String? ?? '',
      lat: (coords?['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (coords?['lng'] as num?)?.toDouble() ?? 0.0,
      address: json['branchAddress'] as String?,
    );
  }

  bool get isValid => lat != 0.0 || lng != 0.0;
}

/// Offer model matching backend Offer schema
class OfferModel {
  final String id;
  final String merchant;
  final String title;
  final String description;
  final String offerType; // 'in-store' | 'online'
  final String? category;
  final String? couponCode;
  final String? qrCodeUrl;
  final String? barCodeUrl;
  final DateTime startDate;
  final DateTime endDate;
  final int? redemptionLimit;
  final int redemptionCount;
  final List<String> locationIds;
  final List<OfferLocation> locations; // populated location objects with coordinates
  final String? merchantBrand;
  final String? merchantLogo;
  final bool isSaved; // Whether current user has saved this offer
  final bool hasRedeemed; // Whether current user has already snagged this offer
  final DateTime createdAt;
  final DateTime updatedAt;

  const OfferModel({
    required this.id,
    required this.merchant,
    required this.title,
    required this.description,
    required this.offerType,
    this.category,
    this.couponCode,
    this.qrCodeUrl,
    this.barCodeUrl,
    required this.startDate,
    required this.endDate,
    this.redemptionLimit,
    required this.redemptionCount,
    required this.locationIds,
    required this.locations,
    this.merchantBrand,
    this.merchantLogo,
    this.isSaved = false,
    this.hasRedeemed = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    try {
      return OfferModel(
        id: json['_id'] as String? ?? json['id'] as String,
        merchant: json['merchant'] is String 
            ? json['merchant'] as String
            : (json['merchant'] as Map<String, dynamic>)['_id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        offerType: json['offerType'] as String,
        category: json['category'] as String?,
        couponCode: json['couponCode'] as String?,
        qrCodeUrl: json['qrCodeUrl'] as String?,
        barCodeUrl: json['barCodeUrl'] as String?,
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: DateTime.parse(json['endDate'] as String),
        redemptionLimit: json['redemptionLimit'] as int?,
        redemptionCount: json['redemptionCount'] as int? ?? 0,
        locationIds: (json['locationIds'] as List<dynamic>?)
                ?.map((e) => e is String ? e : e['_id'] as String)
                .toList() ??
            [],
        locations: (json['locationIds'] as List<dynamic>?)
                ?.whereType<Map<String, dynamic>>()
                .map(OfferLocation.fromJson)
                .toList() ??
            [],
        merchantBrand: json['merchantBrand'] as String?,
        merchantLogo: json['merchantLogo'] as String?,
        isSaved: json['isSaved'] as bool? ?? false,
        hasRedeemed: json['hasRedeemed'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
    } catch (e, stackTrace) {
      print('❌ [OfferModel] Error parsing JSON: $e');
      print('📦 [OfferModel] JSON data: $json');
      print('📍 [OfferModel] Stack trace: $stackTrace');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'merchant': merchant,
        'title': title,
        'description': description,
        'offerType': offerType,
        'category': category,
        'couponCode': couponCode,
        'qrCodeUrl': qrCodeUrl,
        'barCodeUrl': barCodeUrl,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'redemptionLimit': redemptionLimit,
        'redemptionCount': redemptionCount,
        'locationIds': locationIds,
        'merchantBrand': merchantBrand,
        'merchantLogo': merchantLogo,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

/// Redemption model for snagged offers
class RedemptionModel {
  final String id;
  final String client;
  final String offerId;
  final String merchant;
  final String? couponCode;
  final String? qrCodeUrl;
  final String? barCodeUrl;
  final DateTime redeemedAt;
  final OfferModel? offer; // Populated offer details

  const RedemptionModel({
    required this.id,
    required this.client,
    required this.offerId,
    required this.merchant,
    this.couponCode,
    this.qrCodeUrl,
    this.barCodeUrl,
    required this.redeemedAt,
    this.offer,
  });

  factory RedemptionModel.fromJson(Map<String, dynamic> json) => RedemptionModel(
        id: json['_id'] as String? ?? json['id'] as String,
        client: json['client'] as String,
        offerId: json['offerId'] as String,
        merchant: json['merchant'] as String,
        couponCode: json['couponCode'] as String?,
        qrCodeUrl: json['qrCodeUrl'] as String?,
        barCodeUrl: json['barCodeUrl'] as String?,
        redeemedAt: DateTime.parse(json['redeemedAt'] as String),
        offer: json['offer'] != null
            ? OfferModel.fromJson(json['offer'] as Map<String, dynamic>)
            : null,
      );
}

/// Saved offer model
class SavedOfferModel {
  final String id;
  final String client;
  final String offerId;
  final DateTime savedAt;
  final OfferModel? offer; // Populated offer details

  const SavedOfferModel({
    required this.id,
    required this.client,
    required this.offerId,
    required this.savedAt,
    this.offer,
  });

  factory SavedOfferModel.fromJson(Map<String, dynamic> json) {
    // Backend now returns enriched offers directly (not nested in SavedOffer)
    // Check if this is a SavedOffer document or a direct offer
    if (json.containsKey('savedAt') && json.containsKey('offer')) {
      // This is a SavedOffer document
      return SavedOfferModel(
        id: json['_id'] as String? ?? json['id'] as String,
        client: json['client'] as String,
        offerId: json['offer'] is String 
            ? json['offer'] as String 
            : (json['offer'] as Map<String, dynamic>)['_id'] as String,
        savedAt: DateTime.parse(json['savedAt'] as String),
        offer: json['offer'] is Map<String, dynamic>
            ? OfferModel.fromJson(json['offer'] as Map<String, dynamic>)
            : null,
      );
    } else {
      // Backend returns enriched offer directly (new format)
      final offer = OfferModel.fromJson(json);
      return SavedOfferModel(
        id: offer.id,
        client: '', // Not provided in enriched format
        offerId: offer.id,
        savedAt: DateTime.now(), // Not provided in enriched format
        offer: offer,
      );
    }
  }
}

/// Response from snag offer endpoint
class SnagOfferResponse {
  final String redemptionId;
  final String offerId;
  final String title;
  final String? couponCode;
  final String? qrCodeUrl;
  final String? barCodeUrl;
  final DateTime redeemedAt;

  const SnagOfferResponse({
    required this.redemptionId,
    required this.offerId,
    required this.title,
    this.couponCode,
    this.qrCodeUrl,
    this.barCodeUrl,
    required this.redeemedAt,
  });

  factory SnagOfferResponse.fromJson(Map<String, dynamic> json) => SnagOfferResponse(
        redemptionId: json['redemptionId'] as String,
        offerId: json['offerId'] as String,
        title: json['title'] as String,
        couponCode: json['couponCode'] as String?,
        qrCodeUrl: json['qrCodeUrl'] as String?,
        barCodeUrl: json['barCodeUrl'] as String?,
        redeemedAt: DateTime.parse(json['redeemedAt'] as String),
      );
}

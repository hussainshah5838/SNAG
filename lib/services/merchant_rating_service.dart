import '../core/errors/app_exception.dart';
import '../core/network/api_client.dart';
import '../core/utils/result.dart';

/// Merchant rating service - submit ratings for merchants
class MerchantRatingService {
  MerchantRatingService._();
  static final MerchantRatingService instance = MerchantRatingService._();

  final _client = ApiClient.instance;

  /// Submit rating for a merchant
  /// [rating] should be 1-5 stars
  Future<Result<String>> submitRating({
    required String merchantId,
    required int rating,
    String? comment,
  }) async {
    try {
      final res = await _client.post(
        '/merchant/rating/$merchantId',
        data: {
          'rating': rating,
          if (comment != null && comment.isNotEmpty) 'comment': comment,
        },
      );

      final message = res.data['message'] as String? ?? 'Rating submitted successfully';
      return Result.success(message);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  /// Get merchant's average rating
  Future<Result<Map<String, dynamic>>> getMerchantRating(String merchantId) async {
    try {
      final res = await _client.get('/merchant/rating/$merchantId');
      
      final data = res.data['data'] as Map<String, dynamic>;
      return Result.success(data);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }
}

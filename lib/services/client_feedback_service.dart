import '../core/errors/app_exception.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../core/utils/result.dart';

/// Client feedback service - submit feedback for offers
/// This layer only talks to the network — no state, no UI logic.
class ClientFeedbackService {
  ClientFeedbackService._();
  static final ClientFeedbackService instance = ClientFeedbackService._();

  final _client = ApiClient.instance;

  // ── Submit Feedback ─────────────────────────────────────────────────────────

  /// Submit feedback for an offer
  /// [rating] should be 'good' or 'bad'
  Future<Result<String>> submitFeedback({
    required String offerId,
    required String rating,
    String? comment,
  }) async {
    try {
      final res = await _client.post(
        ApiEndpoints.clientFeedback,
        data: {
          'offerId': offerId,
          'rating': rating,
          if (comment != null) 'comment': comment,
        },
      );

      final message = res.data['message'] as String? ?? 'Feedback submitted';
      return Result.success(message);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }
}

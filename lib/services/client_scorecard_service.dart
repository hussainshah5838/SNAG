import '../core/errors/app_exception.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../core/utils/result.dart';
import '../models/scorecard_model.dart';

/// Client scorecard service - get user scorecard stats
/// This layer only talks to the network — no state, no UI logic.
class ClientScorecardService {
  ClientScorecardService._();
  static final ClientScorecardService instance = ClientScorecardService._();

  final _client = ApiClient.instance;

  // ── Get Scorecard ───────────────────────────────────────────────────────────

  Future<Result<ScorecardModel>> getScorecard() async {
    try {
      final res = await _client.get(ApiEndpoints.clientScorecard);
      final scorecard = ScorecardModel.fromJson(res.data['data'] as Map<String, dynamic>);
      return Result.success(scorecard);
    } on AppException catch (e) {
      return Result.failure(e);
    } catch (e) {
      print('❌ [ScorecardService] Unexpected error: $e');
      return Result.failure(const NetworkException());
    }
  }
}

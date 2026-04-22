import '../core/errors/app_exception.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../core/utils/result.dart';

/// Fetches the industry list from the backend.
/// Public endpoint — no token needed.
///
/// Both screens use this:
///   - Merchant branch profile  → industry dropdown
///   - Client discover offers   → interest selection cards
class IndustryService {
  IndustryService._();
  static final IndustryService instance = IndustryService._();

  final _client = ApiClient.instance;

  Future<Result<List<String>>> getIndustries() async {
    try {
      final res = await _client.get(ApiEndpoints.industries);
      final list = (res.data['data']['industries'] as List<dynamic>)
          .map((e) => e as String)
          .toList();
      return Result.success(list);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }
}

import '../core/errors/app_exception.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../core/utils/result.dart';

/// Client support service - submit support tickets
/// This layer only talks to the network — no state, no UI logic.
class ClientSupportService {
  ClientSupportService._();
  static final ClientSupportService instance = ClientSupportService._();

  final _client = ApiClient.instance;

  // ── Submit Support Ticket ───────────────────────────────────────────────────

  /// Submit a support ticket
  /// [subject] should be one of: 'technical', 'billing', 'general', 'feedback'
  Future<Result<String>> submitSupportTicket({
    required String email,
    required String phoneNumber,
    required String subject,
    required String message,
    String? attachmentUrl,
  }) async {
    try {
      final res = await _client.post(
        ApiEndpoints.clientSupport,
        data: {
          'email': email,
          'phoneNumber': phoneNumber,
          'subject': subject,
          'message': message,
          if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
        },
      );

      final responseMessage = res.data['message'] as String? ?? 'Support ticket submitted';
      return Result.success(responseMessage);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }
}

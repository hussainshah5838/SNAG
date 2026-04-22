/// Mirrors the backend's AppError class hierarchy.
/// Every API error gets converted into one of these typed exceptions
/// so the UI never has to parse raw error strings.
class AppException implements Exception {
  final String message;
  final int statusCode;
  final String code;

  const AppException({
    required this.message,
    required this.statusCode,
    required this.code,
  });

  @override
  String toString() => 'AppException($code): $message';
}

/// 400 — validation failed (Zod errors from backend)
class ValidationException extends AppException {
  const ValidationException(String message)
      : super(message: message, statusCode: 400, code: 'VALIDATION_ERROR');
}

/// 401 — wrong credentials, no token, expired token
class AuthException extends AppException {
  const AuthException(String message)
      : super(message: message, statusCode: 401, code: 'AUTH_ERROR');
}

/// 403 — correct token but wrong role
class ForbiddenException extends AppException {
  const ForbiddenException(String message)
      : super(message: message, statusCode: 403, code: 'FORBIDDEN_ERROR');
}

/// 404 — resource not found
class NotFoundException extends AppException {
  const NotFoundException(String message)
      : super(message: message, statusCode: 404, code: 'NOT_FOUND_ERROR');
}

/// 409 — conflict (e.g. email already in use)
class ConflictException extends AppException {
  const ConflictException(String message)
      : super(message: message, statusCode: 409, code: 'CONFLICT_ERROR');
}

/// 500 or network failures
class ServerException extends AppException {
  const ServerException(String message)
      : super(message: message, statusCode: 500, code: 'SERVER_ERROR');
}

/// No internet / connection timeout
class NetworkException extends AppException {
  const NetworkException()
      : super(
          message: 'No internet connection. Please check your network.',
          statusCode: 0,
          code: 'NETWORK_ERROR',
        );
}

import 'package:dio/dio.dart';
import 'package:dr_swift_diagnostics/core/errors/failures.dart';

Failure mapDioExceptionToFailure(DioException error) {
  final statusCode = error.response?.statusCode;
  final message = error.response?.data is Map
      ? (error.response!.data as Map)['message']?.toString()
      : null;

  return switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.connectionError =>
      Failure(
        message: 'Connection failed. Check your internet and try again.',
        type: FailureType.network,
        statusCode: statusCode,
      ),
    DioExceptionType.badResponse => Failure(
        message: message ?? _defaultMessageForStatus(statusCode),
        type: _failureTypeForStatus(statusCode),
        statusCode: statusCode,
      ),
    DioExceptionType.cancel => const Failure(
        message: 'Request was cancelled.',
        type: FailureType.unknown,
      ),
    _ => Failure(
        message: message ?? 'Something went wrong. Please try again.',
        type: FailureType.unknown,
        statusCode: statusCode,
      ),
  };
}

String _defaultMessageForStatus(int? statusCode) {
  if (statusCode == null) {
    return 'Something went wrong. Please try again.';
  }

  if (statusCode == 401) {
    return 'Session expired. Please sign in again.';
  }
  if (statusCode == 403) {
    return 'You do not have permission to perform this action.';
  }
  if (statusCode == 404) {
    return 'The requested resource was not found.';
  }
  if (statusCode >= 500 && statusCode < 600) {
    return 'Server error. Please try again later.';
  }
  return 'Something went wrong. Please try again.';
}

FailureType _failureTypeForStatus(int? statusCode) {
  if (statusCode == null) {
    return FailureType.unknown;
  }

  return switch (statusCode) {
    401 => FailureType.unauthorized,
    404 => FailureType.notFound,
    422 => FailureType.validation,
    >= 500 && < 600 => FailureType.server,
    _ => FailureType.unknown,
  };
}

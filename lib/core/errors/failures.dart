enum FailureType {
  network,
  unauthorized,
  notFound,
  validation,
  server,
  cache,
  unknown,
}

class Failure implements Exception {
  const Failure({
    required this.message,
    this.type = FailureType.unknown,
    this.statusCode,
  });

  final String message;
  final FailureType type;
  final int? statusCode;

  @override
  String toString() => 'Failure($type): $message';
}

class AppException implements Exception {
  const AppException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'AppException: $message';
}

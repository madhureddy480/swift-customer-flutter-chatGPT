import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    this.maxRetries = 2,
  }) : _dio = dio;

  final Dio _dio;
  final int maxRetries;

  static const _retryableMethods = {'GET', 'HEAD'};

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final shouldRetry = _shouldRetry(err);
    final retryCount = (err.requestOptions.extra['retryCount'] as int?) ?? 0;

    if (!shouldRetry || retryCount >= maxRetries) {
      handler.next(err);
      return;
    }

    await Future<void>.delayed(Duration(milliseconds: 300 * (retryCount + 1)));

    try {
      final response = await _dio.fetch<dynamic>(
        err.requestOptions.copyWith(
          extra: {
            ...err.requestOptions.extra,
            'retryCount': retryCount + 1,
          },
        ),
      );
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  bool _shouldRetry(DioException err) {
    if (!_retryableMethods.contains(err.requestOptions.method)) {
      return false;
    }

    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        err.response?.statusCode == 503;
  }
}

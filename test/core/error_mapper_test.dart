import 'package:dr_swift_diagnostics/core/errors/error_mapper.dart';
import 'package:dr_swift_diagnostics/core/errors/failures.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mapDioExceptionToFailure', () {
    test('maps 401 to unauthorized failure', () {
      final failure = mapDioExceptionToFailure(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 401,
          ),
        ),
      );

      expect(failure.type, FailureType.unauthorized);
      expect(failure.statusCode, 401);
    });

    test('maps connection error to network failure', () {
      final failure = mapDioExceptionToFailure(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(failure.type, FailureType.network);
    });
  });
}

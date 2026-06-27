import 'package:dio/dio.dart';
import 'package:dr_swift_diagnostics/core/config/app_config.dart';
import 'package:dr_swift_diagnostics/core/network/api_interceptor.dart';
import 'package:dr_swift_diagnostics/core/network/auth_interceptor.dart';
import 'package:dr_swift_diagnostics/core/network/retry_interceptor.dart';
import 'package:dr_swift_diagnostics/core/storage/token_storage.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  ApiClient({
    required AppConfig config,
    required TokenStorage tokenStorage,
    Dio? dio,
  }) : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: config.apiBaseUrl,
                connectTimeout: const Duration(seconds: 20),
                receiveTimeout: const Duration(seconds: 30),
                sendTimeout: const Duration(seconds: 30),
                headers: {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                },
              ),
            ) {
    _dio.interceptors.addAll([
      ApiInterceptor(),
      AuthInterceptor(tokenStorage: tokenStorage, dio: _dio),
      RetryInterceptor(dio: _dio),
      if (kDebugMode)
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
    ]);
  }

  final Dio _dio;

  Dio get dio => _dio;
}

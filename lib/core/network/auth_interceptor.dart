import 'package:dio/dio.dart';
import 'package:dr_swift_diagnostics/core/constants/api_paths.dart';
import 'package:dr_swift_diagnostics/core/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required TokenStorage tokenStorage,
    required Dio dio,
  })  : _tokenStorage = tokenStorage,
        _dio = dio;

  final TokenStorage _tokenStorage;
  final Dio _dio;

  static const _publicPaths = {
    ApiPaths.authExchange,
    ApiPaths.catalogCategories,
    ApiPaths.catalogTests,
    ApiPaths.catalogPackages,
  };

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isPublic = _publicPaths.any(options.path.startsWith);

    if (!isPublic) {
      final token = await _tokenStorage.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    final refreshed = await _refreshToken();
    if (!refreshed) {
      handler.next(err);
      return;
    }

    try {
      final response = await _retryRequest(err.requestOptions);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(extra: {'skipAuth': true}),
      );

      final data = response.data;
      final accessToken = data?['accessToken'] as String?;
      final newRefreshToken = data?['refreshToken'] as String?;

      if (accessToken == null) {
        return false;
      }

      await _tokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: newRefreshToken ?? refreshToken,
      );
      return true;
    } catch (_) {
      await _tokenStorage.clearTokens();
      return false;
    }
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions options) async {
    final accessToken = await _tokenStorage.readAccessToken();
    final headers = Map<String, dynamic>.from(options.headers);
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    return _dio.request<dynamic>(
      options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      options: Options(
        method: options.method,
        headers: headers,
        responseType: options.responseType,
        contentType: options.contentType,
        extra: options.extra,
      ),
    );
  }
}

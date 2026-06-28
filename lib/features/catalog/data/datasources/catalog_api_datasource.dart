import 'package:dio/dio.dart';
import 'package:dr_swift_diagnostics/core/constants/api_paths.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/models/catalog_models.dart';

/// Future HTTP datasource for DrSwift-CMS public catalog APIs.
///
/// Wire this when the mobile app points at CMS instead of bundled JSON.
/// Endpoints: `GET /api/v1/public/catalog`, `GET /api/v1/public/catalog/tests/{slug}`
class CatalogApiDataSource {
  CatalogApiDataSource(this._dio);

  final Dio _dio;

  static const catalogPath = ApiPaths.cmsCatalog;
  static const testBySlugPath = ApiPaths.cmsTestBySlug;

  Future<CatalogBundle> fetchCatalog() async {
    final response = await _dio.get<Map<String, dynamic>>(catalogPath);
    return CatalogBundle.fromJson(response.data ?? const {});
  }

  Future<CatalogTest> fetchTestBySlug(String slug) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$testBySlugPath/$slug',
    );
    final testJson = response.data?['test'] as Map<String, dynamic>? ?? const {};
    return CatalogTest.fromJson(testJson);
  }
}

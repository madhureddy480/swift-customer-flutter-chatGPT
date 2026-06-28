import 'package:dr_swift_diagnostics/features/catalog/data/datasources/catalog_api_datasource.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/datasources/catalog_asset_datasource.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/models/catalog_models.dart';

abstract interface class CatalogRepository {
  Future<CatalogBundle> getCatalog();
  Future<List<SymptomCategory>> getCategories();
  Future<List<CatalogProfile>> getProfiles();
  Future<CatalogTest?> getTestBySlug(String slug);
  Future<CatalogTest?> getTestByCode(String code);
}

class AssetCatalogRepository implements CatalogRepository {
  AssetCatalogRepository({CatalogAssetDataSource? dataSource})
      : _dataSource = dataSource ?? CatalogAssetDataSource();

  final CatalogAssetDataSource _dataSource;
  CatalogBundle? _cachedCatalog;
  List<SymptomCategory>? _cachedCategories;
  List<CatalogProfile>? _cachedProfiles;

  @override
  Future<CatalogBundle> getCatalog() async {
    return _cachedCatalog ??= await _dataSource.loadCatalog();
  }

  @override
  Future<List<SymptomCategory>> getCategories() async {
    return _cachedCategories ??= await _dataSource.loadCategories();
  }

  @override
  Future<List<CatalogProfile>> getProfiles() async {
    return _cachedProfiles ??= await _dataSource.loadProfiles();
  }

  @override
  Future<CatalogTest?> getTestBySlug(String slug) async {
    final catalog = await getCatalog();
    for (final test in catalog.tests) {
      if (test.slug == slug) return test;
    }
    return null;
  }

  @override
  Future<CatalogTest?> getTestByCode(String code) async {
    final catalog = await getCatalog();
    for (final test in catalog.tests) {
      if (test.attributes.internalCode == code) return test;
    }
    return null;
  }
}

class ApiCatalogRepository implements CatalogRepository {
  ApiCatalogRepository(this._apiDataSource);

  final CatalogApiDataSource _apiDataSource;
  CatalogBundle? _cachedCatalog;

  @override
  Future<CatalogBundle> getCatalog() async {
    return _cachedCatalog ??= await _apiDataSource.fetchCatalog();
  }

  @override
  Future<List<SymptomCategory>> getCategories() async {
    final catalog = await getCatalog();
    final grouped = <String, List<CatalogTest>>{};
    for (final test in catalog.tests.where((t) => !t.isProfile)) {
      for (final category in test.attributes.testCategories) {
        grouped.putIfAbsent(category, () => []).add(test);
      }
    }

    return grouped.entries
        .map(
          (entry) => SymptomCategory(
            slug: _slugify(entry.key),
            name: entry.key,
            testCount: entry.value.length,
            testCodes: entry.value
                .map((t) => t.attributes.internalCode)
                .where((c) => c.isNotEmpty)
                .toList(),
            tests: entry.value
                .map(
                  (t) => CategoryTestRef(
                    code: t.attributes.internalCode,
                    slug: t.slug,
                    name: t.name,
                    nameTelugu: '',
                    symptoms: t.attributes.symptoms,
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Future<List<CatalogProfile>> getProfiles() async {
    final catalog = await getCatalog();
    return catalog.tests
        .where((t) => t.isProfile)
        .map(
          (t) => CatalogProfile(
            code: t.attributes.internalCode,
            slug: t.slug,
            name: t.name,
            shortName: t.name.replaceFirst('DRS ', ''),
            testCount: t.attributes.numberOfTests ?? t.attributes.includedTests.length,
            priceCents: t.priceCents,
            currency: t.currency,
            includedTestCodes: const [],
            includedTests: t.attributes.includedTests
                .map(
                  (name) => ProfileTestRef(
                    code: null,
                    slug: _slugify(name),
                    name: name,
                    nameTelugu: '',
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Future<CatalogTest?> getTestBySlug(String slug) async {
    try {
      return await _apiDataSource.fetchTestBySlug(slug);
    } catch (_) {
      final catalog = await getCatalog();
      for (final test in catalog.tests) {
        if (test.slug == slug) return test;
      }
      return null;
    }
  }

  @override
  Future<CatalogTest?> getTestByCode(String code) async {
    final catalog = await getCatalog();
    for (final test in catalog.tests) {
      if (test.attributes.internalCode == code) return test;
    }
    return null;
  }

  static String _slugify(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'(^-+|-+$)'), '');
  }
}

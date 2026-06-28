import 'package:dr_swift_diagnostics/core/network/network_providers.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/catalog_view_models.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/datasources/catalog_api_datasource.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/mappers/catalog_ui_mapper.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/models/catalog_models.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/repositories/catalog_repository.dart';
import 'package:dr_swift_diagnostics/features/profiles/data/health_profile_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Toggle to `true` when wiring the app to DrSwift-CMS catalog APIs.
const useCatalogApi = bool.fromEnvironment('USE_CATALOG_API', defaultValue: false);

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  if (useCatalogApi) {
    final dio = ref.watch(dioProvider);
    return ApiCatalogRepository(CatalogApiDataSource(dio));
  }
  return AssetCatalogRepository();
});

final catalogBundleProvider = FutureProvider<CatalogBundle>((ref) async {
  return ref.watch(catalogRepositoryProvider).getCatalog();
});

final symptomCategoriesProvider = FutureProvider<List<SymptomCategory>>((ref) async {
  return ref.watch(catalogRepositoryProvider).getCategories();
});

final catalogProfilesProvider = FutureProvider<List<CatalogProfile>>((ref) async {
  return ref.watch(catalogRepositoryProvider).getProfiles();
});

final testsByCodeProvider = FutureProvider<Map<String, CatalogTest>>((ref) async {
  final bundle = await ref.watch(catalogBundleProvider.future);
  return CatalogUiMapper.indexTestsByCode(bundle.tests);
});

final healthCategoriesProvider = FutureProvider<List<HealthCategory>>((ref) async {
  final categories = await ref.watch(symptomCategoriesProvider.future);
  final testsByCode = await ref.watch(testsByCodeProvider.future);
  return categories
      .map((c) => CatalogUiMapper.toHealthCategory(c, testsByCode))
      .toList();
});

final healthProfilesProvider = FutureProvider<List<HealthProfileData>>((ref) async {
  final profiles = await ref.watch(catalogProfilesProvider.future);
  final testsByCode = await ref.watch(testsByCodeProvider.future);
  return profiles
      .map((p) => CatalogUiMapper.toHealthProfile(p, testsByCode))
      .toList();
});

final healthCategoryBySlugProvider =
    FutureProvider.family<HealthCategory?, String>((ref, slug) async {
  final categories = await ref.watch(healthCategoriesProvider.future);
  for (final category in categories) {
    if (category.id == slug) return category;
  }
  return null;
});

final healthTestBySlugProvider =
    FutureProvider.family<HealthTest?, String>((ref, slug) async {
  final test = await ref.watch(catalogRepositoryProvider).getTestBySlug(slug);
  return test == null ? null : CatalogUiMapper.toHealthTest(test);
});

final healthProfileBySlugProvider =
    FutureProvider.family<HealthProfileData?, String>((ref, slug) async {
  final profiles = await ref.watch(healthProfilesProvider.future);
  for (final profile in profiles) {
    if (profile.slug == slug) return profile;
  }
  return null;
});

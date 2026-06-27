import 'package:dr_swift_diagnostics/core/constants/asset_paths.dart';

class CategoryMock {
  const CategoryMock({
    required this.name,
    required this.testCount,
    required this.iconAsset,
    required this.slug,
  });

  final String name;
  final int testCount;
  final String iconAsset;
  final String slug;
}

class HealthProfileMock {
  const HealthProfileMock({
    required this.name,
    required this.iconAsset,
    required this.slug,
  });

  final String name;
  final String iconAsset;
  final String slug;
}

abstract final class HomeMockData {
  static const healthProfiles = [
    HealthProfileMock(
      name: 'Diabetes Care',
      iconAsset: AssetPaths.diabetesCareProfile,
      slug: 'diabetes-care-profile',
    ),
    HealthProfileMock(
      name: 'Thyroid Profile',
      iconAsset: AssetPaths.thyroidProfile,
      slug: 'thyroid-profile',
    ),
    HealthProfileMock(
      name: 'Women Health',
      iconAsset: AssetPaths.heartHealthProfile,
      slug: 'women-health',
    ),
    HealthProfileMock(
      name: 'Men 50+ Health',
      iconAsset: AssetPaths.completeHealthCheck,
      slug: 'men-50-health',
    ),
  ];

  static const categories = [
    CategoryMock(
      name: 'Diabetes & Metabolic Health',
      testCount: 26,
      iconAsset: AssetPaths.categoryDiabetes,
      slug: 'diabetes-care',
    ),
    CategoryMock(
      name: 'Heart & Lipids',
      testCount: 14,
      iconAsset: AssetPaths.categoryHeart,
      slug: 'heart-health',
    ),
    CategoryMock(
      name: 'Thyroid Care',
      testCount: 9,
      iconAsset: AssetPaths.categoryThyroid,
      slug: 'thyroid-care',
    ),
    CategoryMock(
      name: 'Liver Health',
      testCount: 11,
      iconAsset: AssetPaths.categoryLiver,
      slug: 'liver-health',
    ),
    CategoryMock(
      name: 'Kidney Health',
      testCount: 8,
      iconAsset: AssetPaths.categoryKidney,
      slug: 'kidney-health',
    ),
    CategoryMock(
      name: 'Vitamins & Nutrition',
      testCount: 12,
      iconAsset: AssetPaths.categoryVitamins,
      slug: 'vitamins-nutrition',
    ),
    CategoryMock(
      name: 'Fever & Infection',
      testCount: 7,
      iconAsset: AssetPaths.categoryFever,
      slug: 'fever-infection',
    ),
  ];
}

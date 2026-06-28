import 'package:dr_swift_diagnostics/core/constants/asset_paths.dart';

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
}

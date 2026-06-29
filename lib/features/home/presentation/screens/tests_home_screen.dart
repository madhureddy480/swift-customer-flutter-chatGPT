import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_brand_widgets.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_scaffold.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/catalog_providers.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/catalog_view_models.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/category_ui_metadata.dart';
import 'package:dr_swift_diagnostics/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:dr_swift_diagnostics/features/profiles/data/health_profile_data.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Tests tab — screen 1 in `docs/health_profile_flow.png`.
class TestsHomeScreen extends ConsumerWidget {
  const TestsHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(healthCategoriesProvider);
    final profilesAsync = ref.watch(healthProfilesProvider);
    final catalogAsync = ref.watch(catalogBundleProvider);

    final individualTestCount = catalogAsync.maybeWhen(
      data: (bundle) =>
          bundle.tests.where((test) => test.testType == 'Test').length,
      orElse: () => 0,
    );

    return DsScaffold(
      safeArea: false,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: DsAppHeader()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const DsPromoBanner(),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        'Health Profiles (Curated for you)',
                        style: TextStyle(
                          color: Color(0xFF071B3A),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: AppColors.primaryVibrant,
                        textStyle: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () => context.push(RoutePaths.profiles),
                      child: const Text('View all'),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                profilesAsync.when(
                  loading: () => const SizedBox(
                    height: 132,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => const SizedBox(
                    height: 132,
                    child: Center(child: Text('Unable to load profiles')),
                  ),
                  data: (profiles) {
                    final ordered = _homeProfiles(profiles);
                    return SizedBox(
                      height: 132,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        itemCount: ordered.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final profile = ordered[index];
                          final meta = ProfileUiMetadata.forSlug(profile.slug);
                          return DsHealthProfileCard(
                            title: meta.homeTitle,
                            testCount: profile.testCount,
                            iconAsset: meta.iconAsset,
                            accentColor: meta.color,
                            onTap: () =>
                                context.push('/profiles/${profile.slug}'),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  individualTestCount > 0
                      ? 'Categories ($individualTestCount+ Tests)'
                      : 'Categories',
                  style: const TextStyle(
                    color: Color(0xFF071B3A),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                categoriesAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: Text('Unable to load categories')),
                  ),
                  data: (categories) => _CategoryList(
                    categories: categories,
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  static List<HealthProfileData> _homeProfiles(List<HealthProfileData> all) {
    final bySlug = {for (final profile in all) profile.slug: profile};
    final featured = ProfileUiMetadata.homeFeaturedSlugs
        .map((slug) => bySlug[slug])
        .whereType<HealthProfileData>()
        .toList();

    if (featured.isNotEmpty) return featured;

    return all;
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({required this.categories});

  final List<HealthCategory> categories;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          for (var index = 0; index < categories.length; index++) ...[
            CategoryListTile(
              category: categories[index],
              onTap: () => context.push('/categories/${categories[index].id}'),
            ),
            if (index < categories.length - 1)
              const Divider(
                height: 1,
                indent: 64,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_brand_widgets.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_scaffold.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/catalog_providers.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/catalog_view_models.dart';
import 'package:dr_swift_diagnostics/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Tests tab — matches ui_ux.png screen 2.
class TestsHomeScreen extends ConsumerWidget {
  const TestsHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(healthCategoriesProvider);
    final profilesAsync = ref.watch(healthProfilesProvider);

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Health Profiles',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push(RoutePaths.profiles),
                      child: const Text('View all'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                profilesAsync.when(
                  loading: () => const SizedBox(
                    height: 108,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => const SizedBox(
                    height: 108,
                    child: Center(child: Text('Unable to load profiles')),
                  ),
                  data: (profiles) => SizedBox(
                    height: 108,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: profiles.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: AppSpacing.lg),
                      itemBuilder: (context, index) {
                        final profile = profiles[index];
                        return DsHealthProfileChip(
                          label: profile.shortName,
                          iconAsset: profile.iconAsset,
                          onTap: () =>
                              context.push('/profiles/${profile.slug}'),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push(RoutePaths.categories),
                      child: const Text('View all'),
                    ),
                  ],
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
                  data: (categories) => _CategoryPreviewList(
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
}

class _CategoryPreviewList extends StatelessWidget {
  const _CategoryPreviewList({required this.categories});

  final List<HealthCategory> categories;

  @override
  Widget build(BuildContext context) {
    final preview = categories.take(5).toList();

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          for (var index = 0; index < preview.length; index++) ...[
            CategoryListTile(
              category: preview[index],
              onTap: () => context.push('/categories/${preview[index].id}'),
            ),
            if (index < preview.length - 1)
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

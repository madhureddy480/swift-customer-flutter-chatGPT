import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_brand_widgets.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_scaffold.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/mock_health_data.dart';
import 'package:dr_swift_diagnostics/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:dr_swift_diagnostics/features/home/data/home_mock_data.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Tests tab — matches ui_ux.png screen 2.
class TestsHomeScreen extends StatelessWidget {
  const TestsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                Text(
                  'Health Profiles',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  height: 108,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: HomeMockData.healthProfiles.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: AppSpacing.lg),
                    itemBuilder: (context, index) {
                      final profile = HomeMockData.healthProfiles[index];
                      return DsHealthProfileChip(
                        label: profile.name,
                        iconAsset: profile.iconAsset,
                        onTap: () {},
                      );
                    },
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
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    children: [
                      for (var index = 0; index < 5; index++) ...[
                        CategoryListTile(
                          category: MockHealthData.categories[index],
                          onTap: () => context.push(
                            '/categories/${MockHealthData.categories[index].id}',
                          ),
                        ),
                        if (index < 4)
                          const Divider(
                            height: 1,
                            indent: 64,
                            color: AppColors.divider,
                          ),
                      ],
                    ],
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

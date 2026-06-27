import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_brand_widgets.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_category_tile.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_scaffold.dart';
import 'package:dr_swift_diagnostics/features/home/data/home_mock_data.dart';
import 'package:flutter/material.dart';

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
                  height: 96,
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
                      onPressed: () {},
                      child: const Text('See all'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ...HomeMockData.categories.map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: DsCategoryTile(
                      name: category.name,
                      testCount: category.testCount,
                      iconAsset: category.iconAsset,
                      onTap: () {},
                    ),
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

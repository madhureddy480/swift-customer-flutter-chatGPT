import 'dart:async';

import 'package:dr_swift_diagnostics/core/constants/asset_paths.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_cart_app_bar_action.dart';
import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_brand_widgets.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_category_style_list.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_glass_card.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_scaffold.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_tab_header.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/catalog_providers.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/category_ui_metadata.dart';
import 'package:dr_swift_diagnostics/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:dr_swift_diagnostics/features/profiles/data/health_profile_data.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Tests tab — screen 1 in `docs/health_profile_flow.png`.
class TestsTabGuestScreen extends ConsumerWidget {
  const TestsTabGuestScreen({super.key});

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
      body: DsTabSliverScrollView(
        title: 'Tests',
        trailing: const DsCartAppBarAction(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const _HealthProfilePromoCarousel(),
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
                    height: 64,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => const SizedBox(
                    height: 64,
                    child: Center(child: Text('Unable to load profiles')),
                  ),
                  data: (profiles) {
                    final ordered = _homeProfiles(profiles);
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        const gap = 8.0;
                        final cardWidth = (constraints.maxWidth - gap * 2) / 3;
                        final cardHeight = cardWidth / 1.3;
                        return SizedBox(
                          height: cardHeight,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.none,
                            itemCount: ordered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: gap),
                            itemBuilder: (context, index) {
                              final profile = ordered[index];
                              return DsHealthProfileCard(
                                width: cardWidth,
                                height: cardHeight,
                                title: profile.shortName,
                                testCount: profile.testCount,
                                imageAsset: AssetPaths.healthProfileCardForSlug(
                                  profile.slug,
                                ),
                                onTap: () =>
                                    context.push('/profiles/${profile.slug}'),
                              );
                            },
                          ),
                        );
                      },
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
                  data: (categories) => DsCategoryStyleList(
                    children: [
                      for (final category in categories)
                        CategoryListTile(
                          category: category,
                          onTap: () =>
                              context.push('/categories/${category.id}'),
                        ),
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

class _HealthProfilePromoCarousel extends StatefulWidget {
  const _HealthProfilePromoCarousel();

  @override
  State<_HealthProfilePromoCarousel> createState() =>
      _HealthProfilePromoCarouselState();
}

class _HealthProfilePromoCarouselState
    extends State<_HealthProfilePromoCarousel> {
  static const _interval = Duration(seconds: 6);
  static const _transitionDuration = Duration(milliseconds: 450);

  final _pageController = PageController();
  Timer? _timer;
  var _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_interval, (_) => _showNextPage());
  }

  void _showNextPage() {
    if (!mounted || !_pageController.hasClients) return;
    final nextPage = (_currentPage + 1) % AssetPaths.healthProfilePromos.length;
    _pageController.animateToPage(
      nextPage,
      duration: _transitionDuration,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: AspectRatio(
              aspectRatio: 350 / 160,
              child: DsGlassCard(
                borderRadius: 16,
                blurSigma: 20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: PageView.builder(
                    controller: _pageController,
                    clipBehavior: Clip.hardEdge,
                    itemCount: AssetPaths.healthProfilePromos.length,
                    onPageChanged: (page) =>
                        setState(() => _currentPage = page),
                    itemBuilder: (context, index) {
                      return Semantics(
                        label:
                            'Test promotion ${index + 1} of ${AssetPaths.healthProfilePromos.length}',
                        image: true,
                        child: Image.asset(
                          AssetPaths.healthProfilePromos[index],
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          filterQuality: FilterQuality.high,
                          isAntiAlias: true,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var index = 0;
                  index < AssetPaths.healthProfilePromos.length;
                  index++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: index == _currentPage ? 14 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: index == _currentPage
                        ? const Color(0xFF583A8E)
                        : const Color(0xFFD0D5DD),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

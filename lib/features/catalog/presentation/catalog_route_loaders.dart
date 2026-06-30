import 'package:dr_swift_diagnostics/core/widgets/ds_states.dart';
import 'package:dr_swift_diagnostics/features/authentication/presentation/providers/auth_state_provider.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/catalog_providers.dart';
import 'package:dr_swift_diagnostics/features/catalog/presentation/screens/all_categories_screen.dart';
import 'package:dr_swift_diagnostics/features/catalog/presentation/screens/category_test_list_screen.dart';
import 'package:dr_swift_diagnostics/features/catalog/presentation/screens/test_detail_screen.dart';
import 'package:dr_swift_diagnostics/features/profiles/data/health_profile_data.dart';
import 'package:dr_swift_diagnostics/features/profiles/presentation/screens/profiles_flow_screens.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategoryTestListRoute extends ConsumerWidget {
  const CategoryTestListRoute({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsync = ref.watch(healthCategoryBySlugProvider(slug));
    return categoryAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: DsErrorState(message: error.toString()),
      ),
      data: (category) {
        if (category == null) {
          return const Scaffold(
            body: DsErrorState(message: 'Category not found'),
          );
        }
        return CategoryTestListScreen(category: category);
      },
    );
  }
}

class TestDetailRoute extends ConsumerWidget {
  const TestDetailRoute({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testAsync = ref.watch(healthTestBySlugProvider(slug));
    return testAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: DsErrorState(message: error.toString()),
      ),
      data: (test) {
        if (test == null) {
          return const Scaffold(body: DsErrorState(message: 'Test not found'));
        }
        return TestDetailScreen(test: test);
      },
    );
  }
}

class ProfileDetailsRoute extends ConsumerWidget {
  const ProfileDetailsRoute({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ProfileRoute(
      slug: slug,
      builder: (profile) => ProfileDetailsScreen(profile: profile),
    );
  }
}

class ProfileTestsRoute extends ConsumerWidget {
  const ProfileTestsRoute({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ProfileRoute(
      slug: slug,
      builder: (profile) => ProfileTestsScreen(profile: profile),
    );
  }
}

class ProfileMoreInfoRoute extends ConsumerWidget {
  const ProfileMoreInfoRoute({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ProfileRoute(
      slug: slug,
      builder: (profile) => ProfileMoreInfoScreen(profile: profile),
    );
  }
}

class ProfileAddedRoute extends ConsumerWidget {
  const ProfileAddedRoute({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _RouteRedirect(target: RoutePaths.shoppingCart);
  }
}

class ProfileCartRoute extends ConsumerWidget {
  const ProfileCartRoute({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _RouteRedirect(target: RoutePaths.shoppingCart);
  }
}

class ProfileBookRoute extends ConsumerWidget {
  const ProfileBookRoute({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canCheckout = ref.watch(canCheckoutProvider);
    final target = canCheckout
        ? RoutePaths.checkoutFlow
        : '${RoutePaths.authPhone}?next=${Uri.encodeComponent(RoutePaths.checkoutFlow)}';
    return _RouteRedirect(target: target);
  }
}

class ProfileCheckoutRoute extends ConsumerWidget {
  const ProfileCheckoutRoute({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _RouteRedirect(target: RoutePaths.checkoutFlow);
  }
}

class ProfileOrdersRoute extends ConsumerWidget {
  const ProfileOrdersRoute({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _RouteRedirect(target: RoutePaths.orderConfirmation);
  }
}

class AllCategoriesRoute extends ConsumerWidget {
  const AllCategoriesRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(healthCategoriesProvider);
    return categoriesAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: DsErrorState(message: error.toString()),
      ),
      data: (categories) => AllCategoriesScreen(categories: categories),
    );
  }
}

class ProfilesGridRoute extends ConsumerWidget {
  const ProfilesGridRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsync = ref.watch(healthProfilesProvider);
    return profilesAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: DsErrorState(message: error.toString()),
      ),
      data: (profiles) => ProfilesGridScreen(profiles: profiles),
    );
  }
}

class _ProfileRoute extends ConsumerWidget {
  const _ProfileRoute({
    required this.slug,
    required this.builder,
  });

  final String slug;
  final Widget Function(HealthProfileData profile) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(healthProfileBySlugProvider(slug));
    return profileAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: DsErrorState(message: error.toString()),
      ),
      data: (profile) {
        if (profile == null) {
          return const Scaffold(
            body: DsErrorState(message: 'Profile not found'),
          );
        }
        return builder(profile);
      },
    );
  }
}

class _RouteRedirect extends StatefulWidget {
  const _RouteRedirect({required this.target});

  final String target;

  @override
  State<_RouteRedirect> createState() => _RouteRedirectState();
}

class _RouteRedirectState extends State<_RouteRedirect> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.go(widget.target);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

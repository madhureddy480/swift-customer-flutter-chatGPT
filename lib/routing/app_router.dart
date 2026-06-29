import 'package:dr_swift_diagnostics/features/account/presentation/account_tab_screen.dart';
import 'package:dr_swift_diagnostics/features/authentication/presentation/screens/login_screen.dart';
import 'package:dr_swift_diagnostics/features/catalog/presentation/catalog_route_loaders.dart';
import 'package:dr_swift_diagnostics/features/health/presentation/health_tab_screen.dart';
import 'package:dr_swift_diagnostics/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:dr_swift_diagnostics/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:dr_swift_diagnostics/features/reports/presentation/reports_tab_screen.dart';
import 'package:dr_swift_diagnostics/features/tests/presentation/tests_tab_screen.dart';
import 'package:dr_swift_diagnostics/routing/app_shell.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) {
          final requestedPage =
              int.tryParse(state.uri.queryParameters['page'] ?? '') ?? 0;
          final initialPage = requestedPage < 0
              ? 0
              : requestedPage > 2
                  ? 2
                  : requestedPage;
          return OnboardingScreen(initialPage: initialPage);
        },
      ),
      GoRoute(
        path: RoutePaths.login,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.tests,
                builder: (context, state) => const TestsTabScreen(),
              ),
              GoRoute(
                path: RoutePaths.categories,
                builder: (context, state) => const AllCategoriesRoute(),
              ),
              GoRoute(
                path: RoutePaths.categoryTests,
                builder: (context, state) => CategoryTestListRoute(
                  slug: state.pathParameters['slug'] ?? '',
                ),
              ),
              GoRoute(
                path: RoutePaths.testDetail,
                builder: (context, state) => TestDetailRoute(
                  slug: state.pathParameters['id'] ?? '',
                ),
              ),
              GoRoute(
                path: RoutePaths.profiles,
                builder: (context, state) => const ProfilesGridRoute(),
              ),
              GoRoute(
                path: RoutePaths.healthProfile,
                builder: (context, state) => ProfileDetailsRoute(
                  slug: state.pathParameters['slug'] ?? '',
                ),
              ),
              GoRoute(
                path: RoutePaths.healthProfileTests,
                builder: (context, state) => ProfileTestsRoute(
                  slug: state.pathParameters['slug'] ?? '',
                ),
              ),
              GoRoute(
                path: RoutePaths.healthProfileMoreInfo,
                builder: (context, state) => ProfileMoreInfoRoute(
                  slug: state.pathParameters['slug'] ?? '',
                ),
              ),
              GoRoute(
                path: RoutePaths.healthProfileAdded,
                builder: (context, state) => ProfileAddedRoute(
                  slug: state.pathParameters['slug'] ?? '',
                ),
              ),
              GoRoute(
                path: RoutePaths.cart,
                builder: (context, state) => ProfileCartRoute(
                  slug: state.pathParameters['slug'] ?? '',
                ),
              ),
              GoRoute(
                path: RoutePaths.book,
                builder: (context, state) => ProfileBookRoute(
                  slug: state.pathParameters['slug'] ?? '',
                ),
              ),
              GoRoute(
                path: RoutePaths.checkout,
                builder: (context, state) => ProfileCheckoutRoute(
                  slug: state.pathParameters['slug'] ?? '',
                ),
              ),
              GoRoute(
                path: RoutePaths.orders,
                builder: (context, state) => ProfileOrdersRoute(
                  slug: state.pathParameters['slug'] ?? '',
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.reports,
                builder: (context, state) => const ReportsTabScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.health,
                builder: (context, state) => const HealthTabScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.account,
                builder: (context, state) => const AccountTabScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

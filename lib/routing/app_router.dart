import 'package:dr_swift_diagnostics/features/authentication/presentation/screens/login_screen.dart';
import 'package:dr_swift_diagnostics/features/dashboard/presentation/screens/health_dashboard_screen.dart';
import 'package:dr_swift_diagnostics/features/home/presentation/screens/tests_home_screen.dart';
import 'package:dr_swift_diagnostics/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:dr_swift_diagnostics/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:dr_swift_diagnostics/features/profile/presentation/screens/account_screen.dart';
import 'package:dr_swift_diagnostics/features/reports/presentation/screens/reports_screen.dart';
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
        builder: (context, state) => const OnboardingScreen(),
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
                builder: (context, state) => const TestsHomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.reports,
                builder: (context, state) => const ReportsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.health,
                builder: (context, state) => const HealthDashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.account,
                builder: (context, state) => const AccountScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

import 'package:dr_swift_diagnostics/app.dart';
import 'package:dr_swift_diagnostics/core/storage/token_storage.dart';
import 'package:dr_swift_diagnostics/features/onboarding/data/onboarding_repository.dart';
import 'package:dr_swift_diagnostics/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:dr_swift_diagnostics/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestOnboardingRepository extends OnboardingRepository {
  _TestOnboardingRepository() : super(const SecureStorageService());

  @override
  Future<bool> isComplete() async => false;

  @override
  Future<void> markComplete() async {}
}

void main() {
  testWidgets('App renders splash screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingRepositoryProvider.overrideWith(
            (ref) => _TestOnboardingRepository(),
          ),
        ],
        child: const DrSwiftApp(),
      ),
    );

    expect(find.text('Dr Swift'), findsOneWidget);
    expect(find.textContaining('See More Than Numbers'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    await tester.pump();

    expect(find.text('Dr Swift'), findsOneWidget);
    expect(find.textContaining('See More Than Numbers'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Your Health History'), findsOneWidget);
    expect(find.text('30 days ago'), findsOneWidget);
    expect(find.text('90 days ago'), findsOneWidget);
  });

  testWidgets('Feature grid is static and uses Flutter text over images', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: OnboardingScreen(initialPage: 2)),
      ),
    );
    await tester.pump();

    expect(find.byType(AnimatedContainer), findsNothing);
    expect(find.byType(ImageFeatureCard), findsNWidgets(3));
    expect(find.byType(Image), findsNWidgets(3));
    expect(find.text('Tests you can understand'), findsOneWidget);
    expect(find.text('Health Profiles'), findsOneWidget);
    expect(find.text('One account for the whole family'), findsOneWidget);
    expect(find.text('Results & Insights in your pocket'), findsOneWidget);
  });

  testWidgets('Get Started completes onboarding and opens tests tab', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        onboardingRepositoryProvider.overrideWith(
          (ref) => _TestOnboardingRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(routerProvider);
    router.go('/onboarding?page=2');

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Get Started'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Categories'), findsOneWidget);
  });
}

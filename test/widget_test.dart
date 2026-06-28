import 'package:dr_swift_diagnostics/app.dart';
import 'package:dr_swift_diagnostics/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App renders splash screen', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: DrSwiftApp(),
      ),
    );

    expect(find.text('Dr Swift'), findsOneWidget);
    expect(find.textContaining('See More Than Numbers'), findsOneWidget);

    // The brand slide remains long enough to inspect before advancing.
    await tester.pump(const Duration(seconds: 4));
    await tester.pump();

    expect(find.text('Dr Swift'), findsOneWidget);
    expect(find.textContaining('See More Than Numbers'), findsOneWidget);

    // It advances to the health-history splash, never directly to /tests.
    await tester.pump(const Duration(seconds: 2));
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
}

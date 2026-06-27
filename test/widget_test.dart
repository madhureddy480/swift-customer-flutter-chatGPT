import 'package:dr_swift_diagnostics/app.dart';
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

    // Advance past splash bootstrap timer (2200ms).
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pump();
  });
}

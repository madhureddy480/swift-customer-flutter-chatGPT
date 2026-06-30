import 'package:dr_swift_diagnostics/features/cart/presentation/providers/cart_providers.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/catalog_providers.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/catalog_view_models.dart';
import 'package:dr_swift_diagnostics/features/catalog/presentation/screens/category_test_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('seed catalog exposes symptom categories and glucose test', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final categories = await container.read(healthCategoriesProvider.future);
    expect(categories, isNotEmpty);
    expect(
      categories.any((category) => category.id == 'sugar'),
      isTrue,
    );

    final glucose = await container.read(
      healthTestBySlugProvider('glucose-blood-fasting').future,
    );
    expect(glucose, isNotNull);
    expect(glucose!.name, contains('Glucose'));
    expect(glucose.price, greaterThan(0));
  });

  testWidgets('category test Add button updates cart state', (tester) async {
    const category = HealthCategory(
      id: 'sugar',
      name: 'Sugar',
      testCount: 1,
      icon: Icons.water_drop_outlined,
      color: Color(0xFF18AA63),
      tests: [
        HealthTest(
          id: 'glucose-blood-fasting',
          name: 'Glucose-Blood-Fasting',
          subtitle: 'Excess thirst, frequent urination, fatigue',
          price: 99,
          sampleType: 'Blood',
          tags: ['Blood', 'NABL Labs'],
          whatIsIt: 'Measures fasting blood glucose.',
          whyTakeThisTest: 'Screens for diabetes risk.',
          referenceRanges: [],
          preparation: 'Fasting of 8-10 hours required.',
          oftenBookedWith: ['Glycosylated Hemoglobin (GHb/HbA1c)-WB-EDTA'],
        ),
      ],
    );

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child:
            const MaterialApp(home: CategoryTestListScreen(category: category)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.widgetWithText(OutlinedButton, 'Add'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Add'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(OutlinedButton, 'Added'), findsOneWidget);
    expect(container.read(cartItemCountProvider), 1);
  });
}

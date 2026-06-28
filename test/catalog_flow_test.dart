import 'package:dr_swift_diagnostics/features/catalog/data/mock_health_data.dart';
import 'package:dr_swift_diagnostics/features/catalog/presentation/screens/category_test_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('catalog data exposes all categories and HbA1c details', () {
    expect(MockHealthData.categories, hasLength(8));
    expect(
      MockHealthData.categoryById('diabetes-metabolic').testCount,
      26,
    );

    final hba1c = MockHealthData.testById('hba1c');
    expect(hba1c.name, 'HbA1c');
    expect(hba1c.price, 299);
    expect(hba1c.referenceRanges, hasLength(4));
  });

  testWidgets('category test Add button updates local state', (tester) async {
    final category = MockHealthData.categoryById('diabetes-metabolic');

    await tester.pumpWidget(
      MaterialApp(home: CategoryTestListScreen(category: category)),
    );

    final addButtons = find.widgetWithText(OutlinedButton, 'Add');
    expect(addButtons, findsNWidgets(category.tests.length));

    await tester.tap(addButtons.first);
    await tester.pump();

    expect(find.widgetWithText(OutlinedButton, 'Added'), findsOneWidget);
  });
}

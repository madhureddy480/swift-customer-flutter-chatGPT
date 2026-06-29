import 'package:dr_swift_diagnostics/features/reports/data/report_date_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formatTestDateFromDaysAgo returns DD-MM-YYYY', () {
    final reference = DateTime(2026, 6, 27);

    expect(
      formatTestDateFromDaysAgo(1, reference: reference),
      '26-06-2026',
    );
    expect(
      formatTestDateFromDaysAgo(78, reference: reference),
      '10-04-2026',
    );
  });
}

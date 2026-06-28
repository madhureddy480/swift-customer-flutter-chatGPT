import 'package:dr_swift_diagnostics/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('health history thresholds identify abnormal results', () {
    expect(isAbnormalResult(HealthMetricType.hba1c, 5.7), isTrue);
    expect(isAbnormalResult(HealthMetricType.hba1c, 5.6), isFalse);

    expect(isAbnormalResult(HealthMetricType.vitaminD, 29), isTrue);
    expect(isAbnormalResult(HealthMetricType.vitaminD, 30), isFalse);

    expect(isAbnormalResult(HealthMetricType.cholesterol, 210), isTrue);
    expect(isAbnormalResult(HealthMetricType.cholesterol, 198), isFalse);
    expect(isAbnormalResult(HealthMetricType.cholesterol, 230), isTrue);

    expect(isAbnormalResult(HealthMetricType.tsh, 0.4), isFalse);
    expect(isAbnormalResult(HealthMetricType.tsh, 2.1), isFalse);
    expect(isAbnormalResult(HealthMetricType.tsh, 4.0), isFalse);
  });
}

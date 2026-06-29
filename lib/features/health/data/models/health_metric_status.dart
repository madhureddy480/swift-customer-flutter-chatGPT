import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum HealthMetricStatus {
  healthy,
  low,
  high;

  String get label => switch (this) {
        HealthMetricStatus.healthy => 'Healthy',
        HealthMetricStatus.low => 'Low',
        HealthMetricStatus.high => 'High',
      };

  Color get color => switch (this) {
        HealthMetricStatus.healthy => AppColors.success,
        HealthMetricStatus.low => AppColors.error,
        HealthMetricStatus.high => AppColors.warning,
      };
}

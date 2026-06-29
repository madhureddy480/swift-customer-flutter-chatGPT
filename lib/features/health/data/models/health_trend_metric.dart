import 'package:dr_swift_diagnostics/features/health/data/models/health_metric_status.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HealthTrendMetric {
  const HealthTrendMetric({
    required this.name,
    required this.referenceLabel,
    required this.currentValue,
    required this.status,
    required this.chartColor,
    required this.points,
    required this.minY,
    required this.maxY,
    required this.trendUp,
    required this.trendColor,
  });

  final String name;
  final String referenceLabel;
  final String currentValue;
  final HealthMetricStatus status;
  final Color chartColor;
  final List<FlSpot> points;
  final double minY;
  final double maxY;
  final bool trendUp;
  final Color trendColor;
}

class HealthMemberSection {
  const HealthMemberSection({
    required this.title,
    required this.metrics,
  });

  final String title;
  final List<HealthTrendMetric> metrics;
}

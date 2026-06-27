import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_scaffold.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Health tab — sample trend dashboard matching mockup screen 4.
class HealthDashboardScreen extends StatelessWidget {
  const HealthDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DsScaffold(
      safeArea: false,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Health Dashboard',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Sample trends preview',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xl),
          ..._metrics.map(
            (metric) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _MetricTrendCard(metric: metric),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTrendCard extends StatelessWidget {
  const _MetricTrendCard({required this.metric});

  final _MetricMock metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DsCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            height: 52,
            child: LineChart(
              LineChartData(
                minY: metric.minY,
                maxY: metric.maxY,
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: const LineTouchData(enabled: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: metric.points,
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 2.5,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                        radius: 3,
                        color: AppColors.primary,
                        strokeWidth: 0,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withValues(alpha: 0.06),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  metric.value,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            metric.trendUp ? Icons.north_east : Icons.south_east,
            color: AppColors.success,
            size: 22,
          ),
        ],
      ),
    );
  }
}

class _MetricMock {
  const _MetricMock({
    required this.name,
    required this.value,
    required this.points,
    required this.trendUp,
    required this.minY,
    required this.maxY,
  });

  final String name;
  final String value;
  final List<FlSpot> points;
  final bool trendUp;
  final double minY;
  final double maxY;
}

const _metrics = [
  _MetricMock(
    name: 'HbA1c',
    value: '6.8%',
    points: [
      FlSpot(0, 7.4),
      FlSpot(1, 7.1),
      FlSpot(2, 6.9),
      FlSpot(3, 6.8),
    ],
    trendUp: false,
    minY: 6,
    maxY: 8,
  ),
  _MetricMock(
    name: 'Vitamin D',
    value: '18 ng/mL',
    points: [
      FlSpot(0, 14),
      FlSpot(1, 15),
      FlSpot(2, 17),
      FlSpot(3, 18),
    ],
    trendUp: true,
    minY: 12,
    maxY: 20,
  ),
  _MetricMock(
    name: 'Cholesterol',
    value: '198 mg/dL',
    points: [
      FlSpot(0, 220),
      FlSpot(1, 210),
      FlSpot(2, 205),
      FlSpot(3, 198),
    ],
    trendUp: false,
    minY: 190,
    maxY: 230,
  ),
];

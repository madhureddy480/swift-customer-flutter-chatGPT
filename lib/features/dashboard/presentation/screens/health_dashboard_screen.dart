import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Health tab — trend dashboard matching `ui_ux.png` screen 4.
class HealthDashboardScreen extends StatelessWidget {
  const HealthDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _DashboardHeader(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                itemCount: _metrics.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _MetricTrendCard(metric: _metrics[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'Health Dashboard (Sample)',
            style: TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.calendar_today_outlined,
                size: 20,
                color: _muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTrendCard extends StatelessWidget {
  const _MetricTrendCard({required this.metric});

  final _HealthTrendMetric metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E6EE)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF101828).withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  metric.referenceLabel,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _Sparkline(
            color: metric.chartColor,
            points: metric.points,
            minY: metric.minY,
            maxY: metric.maxY,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 44,
            child: Text(
              metric.currentValue,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: _ink,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            metric.trendUp ? Icons.north_east_rounded : Icons.south_east_rounded,
            color: metric.trendColor,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _Sparkline extends StatelessWidget {
  const _Sparkline({
    required this.color,
    required this.points,
    required this.minY,
    required this.maxY,
  });

  final Color color;
  final List<FlSpot> points;
  final double minY;
  final double maxY;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84,
      height: 46,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (points.length - 1).toDouble(),
          minY: minY,
          maxY: maxY,
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          clipData: const FlClipData.all(),
          lineBarsData: [
            LineChartBarData(
              spots: points,
              isCurved: true,
              curveSmoothness: 0.2,
              preventCurveOverShooting: true,
              color: color,
              barWidth: 2.2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 2.6,
                  color: color,
                  strokeWidth: 1.2,
                  strokeColor: Colors.white,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: color.withValues(alpha: 0.08),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthTrendMetric {
  const _HealthTrendMetric({
    required this.name,
    required this.referenceLabel,
    required this.currentValue,
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
  final Color chartColor;
  final List<FlSpot> points;
  final double minY;
  final double maxY;
  final bool trendUp;
  final Color trendColor;
}

const _ink = Color(0xFF1A1C1E);
const _muted = Color(0xFF667085);

const _metrics = [
  _HealthTrendMetric(
    name: 'HbA1c (%)',
    referenceLabel: '5.7 - 6.4 Normal',
    currentValue: '6.8',
    chartColor: AppColors.success,
    points: [
      FlSpot(0, 7.8),
      FlSpot(1, 7.4),
      FlSpot(2, 7.1),
      FlSpot(3, 6.9),
      FlSpot(4, 6.8),
    ],
    minY: 6.4,
    maxY: 8.2,
    trendUp: false,
    trendColor: AppColors.success,
  ),
  _HealthTrendMetric(
    name: 'Vitamin D (ng/mL)',
    referenceLabel: '30 - 100 ng/mL',
    currentValue: '18',
    chartColor: AppColors.accentOrange,
    points: [
      FlSpot(0, 22),
      FlSpot(1, 20),
      FlSpot(2, 19),
      FlSpot(3, 17),
      FlSpot(4, 18),
    ],
    minY: 14,
    maxY: 24,
    trendUp: false,
    trendColor: AppColors.error,
  ),
  _HealthTrendMetric(
    name: 'Cholesterol (mg/dL)',
    referenceLabel: '< 200 Optimal',
    currentValue: '210',
    chartColor: AppColors.warning,
    points: [
      FlSpot(0, 195),
      FlSpot(1, 200),
      FlSpot(2, 205),
      FlSpot(3, 208),
      FlSpot(4, 210),
    ],
    minY: 190,
    maxY: 215,
    trendUp: true,
    trendColor: AppColors.warning,
  ),
  _HealthTrendMetric(
    name: 'TSH (uIU/mL)',
    referenceLabel: '0.4 - 4.0 Normal',
    currentValue: '2.9',
    chartColor: AppColors.primaryVibrant,
    points: [
      FlSpot(0, 2.0),
      FlSpot(1, 2.3),
      FlSpot(2, 2.5),
      FlSpot(3, 2.7),
      FlSpot(4, 2.9),
    ],
    minY: 1.6,
    maxY: 3.4,
    trendUp: true,
    trendColor: AppColors.success,
  ),
  _HealthTrendMetric(
    name: 'Creatinine (mg/dL)',
    referenceLabel: '0.6 - 1.2 Normal',
    currentValue: '1.0',
    chartColor: AppColors.accentBlue,
    points: [
      FlSpot(0, 0.85),
      FlSpot(1, 0.9),
      FlSpot(2, 0.95),
      FlSpot(3, 0.98),
      FlSpot(4, 1.0),
    ],
    minY: 0.75,
    maxY: 1.1,
    trendUp: true,
    trendColor: AppColors.success,
  ),
];

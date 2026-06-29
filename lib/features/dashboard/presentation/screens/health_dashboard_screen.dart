import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/features/dashboard/presentation/widgets/health_care_carousel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Health tab — family-scoped trend dashboard matching `ui_ux.png` screen 4.
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
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                children: [
                  const HealthCareCarousel(),
                  const SizedBox(height: 16),
                  for (var i = 0; i < _sections.length; i++) ...[
                    if (i > 0) const SizedBox(height: 14),
                    _HealthSectionBlock(section: _sections[i]),
                  ],
                ],
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

class _HealthSectionBlock extends StatelessWidget {
  const _HealthSectionBlock({required this.section});

  final _HealthSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: section.title),
        const SizedBox(height: 8),
        ...section.metrics.map(
          (metric) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _MetricTrendCard(metric: metric),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: _ink,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

class _MetricTrendCard extends StatelessWidget {
  const _MetricTrendCard({required this.metric});

  final _HealthTrendMetric metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E6EE)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF101828).withValues(alpha: 0.025),
            blurRadius: 4,
            offset: const Offset(0, 1),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 2),
                Text.rich(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  TextSpan(
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 9,
                      height: 1.15,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Reference range: ',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: metric.referenceLabel,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          _Sparkline(
            color: metric.chartColor,
            points: metric.points,
            minY: metric.minY,
            maxY: metric.maxY,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    metric.currentValue,
                    style: TextStyle(
                      color: metric.status.color,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    metric.trendUp
                        ? Icons.north_east_rounded
                        : Icons.south_east_rounded,
                    color: metric.trendColor,
                    size: 14,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                metric.status.label,
                style: TextStyle(
                  color: metric.status.color,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ],
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
      width: 68,
      height: 30,
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
              barWidth: 1.8,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 2,
                  color: color,
                  strokeWidth: 1,
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

enum _HealthStatus {
  healthy,
  low,
  high;

  String get label => switch (this) {
        _HealthStatus.healthy => 'Healthy',
        _HealthStatus.low => 'Low',
        _HealthStatus.high => 'High',
      };

  Color get color => switch (this) {
        _HealthStatus.healthy => AppColors.success,
        _HealthStatus.low => AppColors.error,
        _HealthStatus.high => AppColors.warning,
      };
}

class _HealthTrendMetric {
  const _HealthTrendMetric({
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
  final _HealthStatus status;
  final Color chartColor;
  final List<FlSpot> points;
  final double minY;
  final double maxY;
  final bool trendUp;
  final Color trendColor;
}

class _HealthSection {
  const _HealthSection({
    required this.title,
    required this.metrics,
  });

  final String title;
  final List<_HealthTrendMetric> metrics;
}

const _ink = Color(0xFF1A1C1E);
const _muted = Color(0xFF667085);

const _sections = [
  _HealthSection(
    title: 'My Health',
    metrics: [
      _HealthTrendMetric(
        name: 'HbA1c (Blood Glucose)',
        referenceLabel: '5.7 – 6.4',
        currentValue: '6.8',
        status: _HealthStatus.high,
        chartColor: AppColors.warning,
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
        name: 'Vitamin D',
        referenceLabel: '30 – 100',
        currentValue: '18',
        status: _HealthStatus.low,
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
        name: 'Cholesterol',
        referenceLabel: '< 200',
        currentValue: '210',
        status: _HealthStatus.high,
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
        name: 'TSH (Thyroid)',
        referenceLabel: '0.4 – 4.0',
        currentValue: '2.9',
        status: _HealthStatus.healthy,
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
        name: 'Hemoglobin',
        referenceLabel: '13.5 – 17.5',
        currentValue: '14.2',
        status: _HealthStatus.healthy,
        chartColor: AppColors.accentBlue,
        points: [
          FlSpot(0, 13.6),
          FlSpot(1, 13.8),
          FlSpot(2, 14.0),
          FlSpot(3, 14.1),
          FlSpot(4, 14.2),
        ],
        minY: 13.2,
        maxY: 14.6,
        trendUp: true,
        trendColor: AppColors.success,
      ),
    ],
  ),
  _HealthSection(
    title: 'Mom',
    metrics: [
      _HealthTrendMetric(
        name: 'Hemoglobin',
        referenceLabel: '12.0 – 15.5',
        currentValue: '10.5',
        status: _HealthStatus.low,
        chartColor: AppColors.error,
        points: [
          FlSpot(0, 11.4),
          FlSpot(1, 11.1),
          FlSpot(2, 10.9),
          FlSpot(3, 10.7),
          FlSpot(4, 10.5),
        ],
        minY: 10.0,
        maxY: 11.8,
        trendUp: false,
        trendColor: AppColors.error,
      ),
      _HealthTrendMetric(
        name: 'Vitamin B12',
        referenceLabel: '200 – 900',
        currentValue: '180',
        status: _HealthStatus.low,
        chartColor: AppColors.accentOrange,
        points: [
          FlSpot(0, 210),
          FlSpot(1, 200),
          FlSpot(2, 192),
          FlSpot(3, 186),
          FlSpot(4, 180),
        ],
        minY: 170,
        maxY: 220,
        trendUp: false,
        trendColor: AppColors.error,
      ),
      _HealthTrendMetric(
        name: 'TSH (uIU/mL)',
        referenceLabel: '0.4 – 4.0',
        currentValue: '2.1',
        status: _HealthStatus.healthy,
        chartColor: AppColors.primaryVibrant,
        points: [
          FlSpot(0, 2.5),
          FlSpot(1, 2.4),
          FlSpot(2, 2.3),
          FlSpot(3, 2.2),
          FlSpot(4, 2.1),
        ],
        minY: 1.8,
        maxY: 2.8,
        trendUp: false,
        trendColor: AppColors.success,
      ),
      _HealthTrendMetric(
        name: 'Calcium',
        referenceLabel: '8.6 – 10.2',
        currentValue: '9.2',
        status: _HealthStatus.healthy,
        chartColor: AppColors.success,
        points: [
          FlSpot(0, 8.9),
          FlSpot(1, 9.0),
          FlSpot(2, 9.1),
          FlSpot(3, 9.1),
          FlSpot(4, 9.2),
        ],
        minY: 8.6,
        maxY: 9.5,
        trendUp: true,
        trendColor: AppColors.success,
      ),
      _HealthTrendMetric(
        name: 'Iron',
        referenceLabel: '60 – 170',
        currentValue: '45',
        status: _HealthStatus.low,
        chartColor: AppColors.error,
        points: [
          FlSpot(0, 58),
          FlSpot(1, 54),
          FlSpot(2, 50),
          FlSpot(3, 47),
          FlSpot(4, 45),
        ],
        minY: 40,
        maxY: 62,
        trendUp: false,
        trendColor: AppColors.error,
      ),
    ],
  ),
  _HealthSection(
    title: 'Dad',
    metrics: [
      _HealthTrendMetric(
        name: 'Creatinine (mg/dL)',
        referenceLabel: '0.6 – 1.2',
        currentValue: '1.0',
        status: _HealthStatus.healthy,
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
      _HealthTrendMetric(
        name: 'HbA1c (%)',
        referenceLabel: '5.7 – 6.4',
        currentValue: '7.2',
        status: _HealthStatus.high,
        chartColor: AppColors.warning,
        points: [
          FlSpot(0, 6.8),
          FlSpot(1, 6.9),
          FlSpot(2, 7.0),
          FlSpot(3, 7.1),
          FlSpot(4, 7.2),
        ],
        minY: 6.5,
        maxY: 7.5,
        trendUp: true,
        trendColor: AppColors.warning,
      ),
      _HealthTrendMetric(
        name: 'Cholesterol (mg/dL)',
        referenceLabel: '< 200',
        currentValue: '228',
        status: _HealthStatus.high,
        chartColor: AppColors.warning,
        points: [
          FlSpot(0, 210),
          FlSpot(1, 215),
          FlSpot(2, 220),
          FlSpot(3, 224),
          FlSpot(4, 228),
        ],
        minY: 205,
        maxY: 235,
        trendUp: true,
        trendColor: AppColors.warning,
      ),
      _HealthTrendMetric(
        name: 'Vitamin D (ng/mL)',
        referenceLabel: '30 – 100',
        currentValue: '22',
        status: _HealthStatus.low,
        chartColor: AppColors.accentOrange,
        points: [
          FlSpot(0, 28),
          FlSpot(1, 26),
          FlSpot(2, 25),
          FlSpot(3, 23),
          FlSpot(4, 22),
        ],
        minY: 18,
        maxY: 30,
        trendUp: false,
        trendColor: AppColors.error,
      ),
    ],
  ),
];

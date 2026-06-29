import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HealthMetricSparkline extends StatelessWidget {
  const HealthMetricSparkline({
    required this.color,
    required this.points,
    required this.minY,
    required this.maxY,
    super.key,
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

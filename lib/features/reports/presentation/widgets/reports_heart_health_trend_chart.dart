import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_glass_card.dart';
import 'package:dr_swift_diagnostics/features/reports/data/models/report_models.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

const _muted = Color(0xFF667085);

class ReportsHeartHealthTrendChart extends StatelessWidget {
  const ReportsHeartHealthTrendChart({
    required this.trend,
    super.key,
  });

  final ReportHeartHealthTrend trend;

  static const double chartWidth = 350;
  static const double chartHeight = 120;

  @override
  Widget build(BuildContext context) {
    final axisLabels = trend.axisLabels;
    final spots = [
      for (var i = 0; i < trend.values.length; i++)
        FlSpot(i.toDouble(), trend.values[i]),
    ];
    final minY = trend.values.reduce((a, b) => a < b ? a : b) - 12;
    final maxY = trend.values.reduce((a, b) => a > b ? a : b) + 12;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.clamp(0, chartWidth).toDouble();

        return Center(
          child: SizedBox(
            width: width,
            height: chartHeight,
            child: DsGlassCard(
              borderRadius: 16,
              blurSigma: 20,
              padding: const EdgeInsets.fromLTRB(4, 8, 12, 4),
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: (trend.values.length - 1).toDouble(),
                  minY: minY,
                  maxY: maxY,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: (maxY - minY) / 3,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: Colors.white.withValues(alpha: 0.65),
                      strokeWidth: 0.8,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: (maxY - minY) / 3,
                        getTitlesWidget: (value, _) {
                          if (value < minY || value > maxY) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            value.round().toString(),
                            style: const TextStyle(
                              color: _muted,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                        interval: 1,
                        getTitlesWidget: (value, _) {
                          final index = value.round();
                          if (index < 0 || index >= axisLabels.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              axisLabels[index],
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineTouchData: const LineTouchData(enabled: false),
                  clipData: const FlClipData.all(),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.28,
                      preventCurveOverShooting: true,
                      color: AppColors.primaryVibrant,
                      barWidth: 2.5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                          radius: 3.5,
                          color: AppColors.primaryVibrant,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryVibrant.withValues(alpha: 0.22),
                            AppColors.primaryVibrant.withValues(alpha: 0.02),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

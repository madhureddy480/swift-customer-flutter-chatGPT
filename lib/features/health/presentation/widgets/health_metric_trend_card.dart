import 'package:dr_swift_diagnostics/features/health/data/models/health_trend_metric.dart';
import 'package:dr_swift_diagnostics/features/health/presentation/widgets/health_metric_sparkline.dart';
import 'package:flutter/material.dart';

const _ink = Color(0xFF1A1C1E);
const _muted = Color(0xFF667085);

class HealthMetricTrendCard extends StatelessWidget {
  const HealthMetricTrendCard({required this.metric, super.key});

  final HealthTrendMetric metric;

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
                        text: 'Reference range ',
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
          HealthMetricSparkline(
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

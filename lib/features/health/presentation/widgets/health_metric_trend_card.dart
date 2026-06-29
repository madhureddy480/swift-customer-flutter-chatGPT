import 'package:dr_swift_diagnostics/features/health/data/models/health_trend_metric.dart';
import 'package:flutter/material.dart';

const _ink = Color(0xFF1A1C1E);
const _muted = Color(0xFF667085);

class HealthMetricTrendCard extends StatelessWidget {
  const HealthMetricTrendCard({required this.metric, super.key});

  final HealthTrendMetric metric;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  metric.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 3),
                Text.rich(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  TextSpan(
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 8,
                      height: 1.1,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Healthy range ',
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
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    metric.currentValue,
                    style: TextStyle(
                      color: metric.status.color,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.35,
                      height: 1,
                    ),
                  ),
                  Icon(
                    metric.trendUp
                        ? Icons.north_east_rounded
                        : Icons.south_east_rounded,
                    color: metric.trendColor,
                    size: 11,
                  ),
                ],
              ),
              Text(
                metric.status.label,
                style: TextStyle(
                  color: metric.status.color,
                  fontSize: 7,
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

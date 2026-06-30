import 'package:dr_swift_diagnostics/core/widgets/ds_category_style_list.dart';
import 'package:dr_swift_diagnostics/features/health/data/models/health_trend_metric.dart';
import 'package:flutter/material.dart';

class HealthMetricTrendCard extends StatelessWidget {
  const HealthMetricTrendCard({required this.metric, super.key});

  final HealthTrendMetric metric;

  @override
  Widget build(BuildContext context) {
    return DsCategoryStyleListRow(
      leading: DsCategoryStyleListLeadingIcon(
        color: metric.status.color,
        icon: metric.trendUp
            ? Icons.arrow_upward_rounded
            : Icons.arrow_downward_rounded,
      ),
      title: Text(
        metric.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: DsCategoryStyleListTypography.title,
      ),
      subtitle: Text.rich(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        TextSpan(
          style: DsCategoryStyleListTypography.subtitle,
          children: [
            const TextSpan(text: 'Healthy range '),
            TextSpan(text: metric.referenceLabel),
          ],
        ),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            metric.currentValue,
            style: DsCategoryStyleListTypography.trailingValue.copyWith(
              color: metric.status.color,
            ),
          ),
          Text(
            metric.status.label,
            style: DsCategoryStyleListTypography.trailingStatus.copyWith(
              color: metric.status.color,
            ),
          ),
        ],
      ),
    );
  }
}

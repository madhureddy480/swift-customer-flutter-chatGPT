import 'package:dr_swift_diagnostics/core/widgets/ds_glass_card.dart';
import 'package:dr_swift_diagnostics/features/health/data/models/health_trend_metric.dart';
import 'package:dr_swift_diagnostics/features/health/presentation/widgets/health_metric_trend_card.dart';
import 'package:dr_swift_diagnostics/features/health/presentation/widgets/health_section_header.dart';
import 'package:flutter/material.dart';

class HealthMemberSectionBlock extends StatelessWidget {
  const HealthMemberSectionBlock({required this.section, super.key});

  final HealthMemberSection section;

  @override
  Widget build(BuildContext context) {
    return DsGlassCard(
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DsGlassCardHeader(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 9),
              child: HealthSectionHeader(title: section.title),
            ),
          ),
          for (var i = 0; i < section.metrics.length; i++) ...[
            HealthMetricTrendCard(metric: section.metrics[i]),
            if (i < section.metrics.length - 1) const DsGlassDivider(),
          ],
        ],
      ),
    );
  }
}

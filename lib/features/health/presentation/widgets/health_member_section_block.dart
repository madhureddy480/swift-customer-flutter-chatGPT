import 'package:dr_swift_diagnostics/features/health/data/models/health_trend_metric.dart';
import 'package:dr_swift_diagnostics/features/health/presentation/widgets/health_metric_trend_card.dart';
import 'package:dr_swift_diagnostics/features/health/presentation/widgets/health_section_header.dart';
import 'package:flutter/material.dart';

class HealthMemberSectionBlock extends StatelessWidget {
  const HealthMemberSectionBlock({required this.section, super.key});

  final HealthMemberSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HealthSectionHeader(title: section.title),
        const SizedBox(height: 8),
        ...section.metrics.map(
          (metric) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: HealthMetricTrendCard(metric: metric),
          ),
        ),
      ],
    );
  }
}

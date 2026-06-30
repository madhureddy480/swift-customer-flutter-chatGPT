import 'package:dr_swift_diagnostics/core/widgets/ds_category_style_list.dart';
import 'package:dr_swift_diagnostics/features/health/data/models/health_trend_metric.dart';
import 'package:dr_swift_diagnostics/features/health/presentation/widgets/health_metric_trend_card.dart';
import 'package:dr_swift_diagnostics/features/health/presentation/widgets/health_section_header.dart';
import 'package:flutter/material.dart';

class HealthMemberSectionBlock extends StatelessWidget {
  const HealthMemberSectionBlock({required this.section, super.key});

  final HealthMemberSection section;

  @override
  Widget build(BuildContext context) {
    return DsCategoryStyleListSection(
      titleWidget: HealthSectionHeader(title: section.title),
      children: [
        for (final metric in section.metrics)
          HealthMetricTrendCard(metric: metric),
      ],
    );
  }
}

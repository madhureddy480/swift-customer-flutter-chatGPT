import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/features/health/data/health_guest_sample_data.dart';
import 'package:dr_swift_diagnostics/features/health/data/models/health_trend_metric.dart';
import 'package:dr_swift_diagnostics/features/health/presentation/widgets/health_care_carousel.dart';
import 'package:dr_swift_diagnostics/features/health/presentation/widgets/health_member_section_block.dart';
import 'package:dr_swift_diagnostics/features/health/presentation/widgets/health_tab_header.dart';
import 'package:flutter/material.dart';

/// G1 — Guest multi-user Health tab (My Health / Mom / Dad sample trends).
class HealthTabGuestScreen extends StatelessWidget {
  const HealthTabGuestScreen({
    this.sections = guestHealthMemberSections,
    super.key,
  });

  final List<HealthMemberSection> sections;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const HealthTabHeader(),
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
                  for (var i = 0; i < sections.length; i++) ...[
                    if (i > 0) const SizedBox(height: 14),
                    HealthMemberSectionBlock(section: sections[i]),
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

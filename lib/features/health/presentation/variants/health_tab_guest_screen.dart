import 'package:dr_swift_diagnostics/features/health/data/health_guest_sample_data.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/features/health/data/models/health_trend_metric.dart';
import 'package:dr_swift_diagnostics/features/health/presentation/widgets/health_care_carousel.dart';
import 'package:dr_swift_diagnostics/features/health/presentation/widgets/health_member_section_block.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_tab_header.dart';
import 'package:dr_swift_diagnostics/features/health/presentation/widgets/health_tab_guest_sample_cta_card.dart';
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
    return SafeArea(
      bottom: false,
      child: DsTabScrollView(
        title: 'Health & Insights',
        children: [
          const HealthCareCarousel(),
          const SizedBox(height: AppSpacing.sectionGap),
          for (var i = 0; i < sections.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.cardGap),
            HealthMemberSectionBlock(section: sections[i]),
          ],
          const SizedBox(height: AppSpacing.sectionGap),
          const HealthTabGuestSampleCtaCard(),
        ],
      ),
    );
  }
}

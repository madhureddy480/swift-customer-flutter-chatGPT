import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_glass_card.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_states.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_tab_header.dart';
import 'package:flutter/material.dart';

/// Authenticated — no lab data yet.
class HealthTabEmptyScreen extends StatelessWidget {
  const HealthTabEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      bottom: false,
      child: DsTabScrollView(
        title: 'Health & Insights',
        padding: EdgeInsets.fromLTRB(
          AppSpacing.pageHorizontal,
          AppSpacing.pageTop,
          AppSpacing.pageHorizontal,
          AppSpacing.xl,
        ),
        children: [
          DsGlassCard(
            padding: EdgeInsets.symmetric(
              vertical: AppSpacing.xl,
              horizontal: AppSpacing.lg,
            ),
            child: DsEmptyState(
              icon: Icons.show_chart_outlined,
              title: 'No health trends yet',
              message:
                  'Book a test to start tracking your family health over time.',
            ),
          ),
        ],
      ),
    );
  }
}

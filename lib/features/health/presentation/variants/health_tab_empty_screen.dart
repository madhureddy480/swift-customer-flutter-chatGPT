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
        padding: EdgeInsets.all(AppSpacing.lg),
        children: [
            DsGlassCard(
              borderRadius: 16,
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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

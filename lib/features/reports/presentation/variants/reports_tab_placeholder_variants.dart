import 'package:dr_swift_diagnostics/features/session/presentation/widgets/session_variant_placeholder.dart';
import 'package:flutter/material.dart';

import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_glass_card.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_states.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_tab_header.dart';

class ReportsTabEmptyScreen extends StatelessWidget {
  const ReportsTabEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      bottom: false,
      child: DsTabScrollView(
        title: 'Reports',
        padding: EdgeInsets.all(AppSpacing.lg),
        children: [
          DsGlassCard(
            borderRadius: 16,
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: DsEmptyState(
              icon: Icons.description_outlined,
              title: 'No reports yet',
              message:
                  'Book a test to get started. Your reports will appear here.',
            ),
          ),
        ],
      ),
    );
  }
}

class ReportsTabMixedScreen extends StatelessWidget {
  const ReportsTabMixedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SessionVariantPlaceholder(
      tabName: 'Reports',
      scenarioLabel: 'Mixed — per-member pending and results (coming soon)',
    );
  }
}

class ReportsTabResultsSelfScreen extends StatelessWidget {
  const ReportsTabResultsSelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SessionVariantPlaceholder(
      tabName: 'Reports',
      scenarioLabel: 'Your reports (coming soon)',
    );
  }
}

class ReportsTabResultsFamilyScreen extends StatelessWidget {
  const ReportsTabResultsFamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SessionVariantPlaceholder(
      tabName: 'Reports',
      scenarioLabel: 'Family reports (coming soon)',
    );
  }
}

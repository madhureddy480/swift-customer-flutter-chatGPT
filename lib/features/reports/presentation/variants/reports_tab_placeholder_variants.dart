import 'package:dr_swift_diagnostics/features/session/presentation/widgets/session_variant_placeholder.dart';
import 'package:flutter/material.dart';

class ReportsTabEmptyScreen extends StatelessWidget {
  const ReportsTabEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SessionVariantPlaceholder(
      tabName: 'Reports',
      scenarioLabel: 'No reports yet — book a test to get started',
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

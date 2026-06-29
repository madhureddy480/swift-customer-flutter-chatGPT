import 'package:dr_swift_diagnostics/features/session/presentation/widgets/session_variant_placeholder.dart';
import 'package:flutter/material.dart';

/// Per-member pending + partial results (mixed lab states).
class HealthTabMixedScreen extends StatelessWidget {
  const HealthTabMixedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SessionVariantPlaceholder(
      tabName: 'Health',
      scenarioLabel:
          'Mixed — per-member pending and results (coming soon)',
    );
  }
}

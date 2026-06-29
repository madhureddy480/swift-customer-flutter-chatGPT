import 'package:dr_swift_diagnostics/features/session/presentation/widgets/session_variant_placeholder.dart';
import 'package:flutter/material.dart';

/// Authenticated — results for account holder only (no family).
class HealthTabResultsSelfScreen extends StatelessWidget {
  const HealthTabResultsSelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SessionVariantPlaceholder(
      tabName: 'Health',
      scenarioLabel: 'Your health trends (coming soon)',
    );
  }
}

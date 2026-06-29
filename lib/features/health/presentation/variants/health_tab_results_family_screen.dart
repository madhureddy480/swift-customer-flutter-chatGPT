import 'package:dr_swift_diagnostics/features/session/presentation/widgets/session_variant_placeholder.dart';
import 'package:flutter/material.dart';

/// Authenticated — full family health trends.
class HealthTabResultsFamilyScreen extends StatelessWidget {
  const HealthTabResultsFamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SessionVariantPlaceholder(
      tabName: 'Health',
      scenarioLabel: 'Family health trends (coming soon)',
    );
  }
}

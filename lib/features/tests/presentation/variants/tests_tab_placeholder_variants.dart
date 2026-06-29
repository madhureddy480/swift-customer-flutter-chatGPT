import 'package:dr_swift_diagnostics/features/session/presentation/widgets/session_variant_placeholder.dart';
import 'package:flutter/material.dart';

class TestsTabAuthenticatedBrowseScreen extends StatelessWidget {
  const TestsTabAuthenticatedBrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SessionVariantPlaceholder(
      tabName: 'Tests',
      scenarioLabel: 'Authenticated catalog browse (coming soon)',
    );
  }
}

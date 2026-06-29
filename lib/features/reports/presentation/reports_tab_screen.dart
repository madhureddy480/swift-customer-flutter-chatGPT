import 'package:dr_swift_diagnostics/features/reports/presentation/variants/reports_tab_guest_screen.dart';
import 'package:dr_swift_diagnostics/features/reports/presentation/variants/reports_tab_placeholder_variants.dart';
import 'package:dr_swift_diagnostics/features/session/domain/scenarios/reports_scenario.dart';
import 'package:dr_swift_diagnostics/features/session/presentation/session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reports tab entry — resolves session scenario and delegates to a variant.
class ReportsTabScreen extends ConsumerWidget {
  const ReportsTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(userSessionProvider);
    return switch (resolveReportsScenario(session)) {
      ReportsScenario.guestFamilySample => const ReportsTabGuestScreen(),
      ReportsScenario.empty => const ReportsTabEmptyScreen(),
      ReportsScenario.mixed => const ReportsTabMixedScreen(),
      ReportsScenario.resultsSelf => const ReportsTabResultsSelfScreen(),
      ReportsScenario.resultsFamily => const ReportsTabResultsFamilyScreen(),
    };
  }
}

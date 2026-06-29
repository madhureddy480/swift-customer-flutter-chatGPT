import 'package:dr_swift_diagnostics/features/health/presentation/variants/health_tab_empty_screen.dart';
import 'package:dr_swift_diagnostics/features/health/presentation/variants/health_tab_guest_screen.dart';
import 'package:dr_swift_diagnostics/features/health/presentation/variants/health_tab_mixed_screen.dart';
import 'package:dr_swift_diagnostics/features/health/presentation/variants/health_tab_results_family_screen.dart';
import 'package:dr_swift_diagnostics/features/health/presentation/variants/health_tab_results_self_screen.dart';
import 'package:dr_swift_diagnostics/features/session/domain/scenarios/health_scenario.dart';
import 'package:dr_swift_diagnostics/features/session/presentation/session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Health tab entry — resolves session scenario and delegates to a variant.
class HealthTabScreen extends ConsumerWidget {
  const HealthTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(userSessionProvider);
    return switch (resolveHealthScenario(session)) {
      HealthScenario.guestFamilySample => const HealthTabGuestScreen(),
      HealthScenario.empty => const HealthTabEmptyScreen(),
      HealthScenario.mixed => const HealthTabMixedScreen(),
      HealthScenario.resultsSelf => const HealthTabResultsSelfScreen(),
      HealthScenario.resultsFamily => const HealthTabResultsFamilyScreen(),
    };
  }
}

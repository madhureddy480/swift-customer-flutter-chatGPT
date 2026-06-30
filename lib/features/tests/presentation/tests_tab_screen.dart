import 'package:dr_swift_diagnostics/features/session/domain/scenarios/tests_scenario.dart';
import 'package:dr_swift_diagnostics/features/session/presentation/session_providers.dart';
import 'package:dr_swift_diagnostics/features/tests/presentation/variants/tests_tab_guest_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tests tab entry — resolves session scenario and delegates to a variant.
class TestsTabScreen extends ConsumerWidget {
  const TestsTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(userSessionProvider);
    return switch (resolveTestsScenario(session)) {
      TestsScenario.guestBrowse => const TestsTabGuestScreen(),
      // Reuse full catalog until authenticated browse variant ships.
      TestsScenario.authenticatedBrowse => const TestsTabGuestScreen(),
    };
  }
}

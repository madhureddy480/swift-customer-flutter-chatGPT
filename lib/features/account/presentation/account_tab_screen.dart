import 'package:dr_swift_diagnostics/features/account/presentation/variants/account_tab_guest_screen.dart';
import 'package:dr_swift_diagnostics/features/account/presentation/variants/account_tab_placeholder_variants.dart';
import 'package:dr_swift_diagnostics/features/session/domain/scenarios/account_scenario.dart';
import 'package:dr_swift_diagnostics/features/session/presentation/session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Account tab entry — resolves session scenario and delegates to a variant.
class AccountTabScreen extends ConsumerWidget {
  const AccountTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(userSessionProvider);
    return switch (resolveAccountScenario(session)) {
      AccountScenario.guest => const AccountTabGuestScreen(),
      AccountScenario.authenticatedUnverified =>
        const AccountTabAuthenticatedUnverifiedScreen(),
      AccountScenario.authenticatedVerified =>
        const AccountTabAuthenticatedVerifiedScreen(),
    };
  }
}

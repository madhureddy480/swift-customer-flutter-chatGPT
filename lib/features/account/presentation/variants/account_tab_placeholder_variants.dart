import 'package:dr_swift_diagnostics/features/session/presentation/widgets/session_variant_placeholder.dart';
import 'package:flutter/material.dart';

class AccountTabAuthenticatedUnverifiedScreen extends StatelessWidget {
  const AccountTabAuthenticatedUnverifiedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SessionVariantPlaceholder(
      tabName: 'Account',
      scenarioLabel: 'Logged in — verify phone to book tests (coming soon)',
    );
  }
}

class AccountTabAuthenticatedVerifiedScreen extends StatelessWidget {
  const AccountTabAuthenticatedVerifiedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SessionVariantPlaceholder(
      tabName: 'Account',
      scenarioLabel: 'Logged in — account settings (coming soon)',
    );
  }
}

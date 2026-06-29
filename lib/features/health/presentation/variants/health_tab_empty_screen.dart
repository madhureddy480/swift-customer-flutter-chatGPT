import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_states.dart';
import 'package:dr_swift_diagnostics/features/health/presentation/widgets/health_tab_header.dart';
import 'package:flutter/material.dart';

/// Authenticated — no lab data yet.
class HealthTabEmptyScreen extends StatelessWidget {
  const HealthTabEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const HealthTabHeader(title: 'Health Dashboard'),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: DsEmptyState(
                  icon: Icons.show_chart_outlined,
                  title: 'No health trends yet',
                  message:
                      'Book a test to start tracking your family health over time.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

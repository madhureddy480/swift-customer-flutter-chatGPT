import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_glass_card.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_states.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_tab_header.dart';
import 'package:flutter/material.dart';

/// Placeholder shell for tab variants not yet implemented.
class SessionVariantPlaceholder extends StatelessWidget {
  const SessionVariantPlaceholder({
    required this.tabName,
    required this.scenarioLabel,
    super.key,
  });

  final String tabName;
  final String scenarioLabel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: DsTabScrollView(
        title: tabName,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageHorizontal,
          AppSpacing.pageTop,
          AppSpacing.pageHorizontal,
          AppSpacing.xl,
        ),
        children: [
          DsGlassCard(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.xl,
              horizontal: AppSpacing.lg,
            ),
            child: DsEmptyState(
              icon: Icons.construction_outlined,
              title: tabName,
              message: scenarioLabel,
            ),
          ),
        ],
      ),
    );
  }
}

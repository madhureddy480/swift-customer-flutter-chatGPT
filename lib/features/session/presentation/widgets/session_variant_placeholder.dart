import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
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
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.construction_outlined,
                  size: 48,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  tabName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  scenarioLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

enum DsStatusType {
  normal,
  improved,
  low,
  high,
  borderline,
  critical,
}

class DsStatusChip extends StatelessWidget {
  const DsStatusChip({
    required this.label,
    required this.type,
    super.key,
  });

  final String label;
  final DsStatusType type;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = _colorsFor(type);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (Color, Color) _colorsFor(DsStatusType type) {
    return switch (type) {
      DsStatusType.normal => (
          AppColors.success.withValues(alpha: 0.12),
          AppColors.success,
        ),
      DsStatusType.improved => (
          AppColors.info.withValues(alpha: 0.12),
          AppColors.info,
        ),
      DsStatusType.low => (
          AppColors.error.withValues(alpha: 0.12),
          AppColors.error,
        ),
      DsStatusType.high => (
          AppColors.error.withValues(alpha: 0.12),
          AppColors.error,
        ),
      DsStatusType.borderline => (
          AppColors.warning.withValues(alpha: 0.12),
          AppColors.warning,
        ),
      DsStatusType.critical => (
          AppColors.error.withValues(alpha: 0.18),
          AppColors.error,
        ),
    };
  }
}

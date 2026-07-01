import 'dart:ui';

import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// iOS-style frosted glass surface for cards and panels.
class DsGlassCard extends StatelessWidget {
  const DsGlassCard({
    required this.child,
    super.key,
    this.borderRadius = AppSpacing.tabCardRadius,
    this.padding,
    this.margin,
    this.blurSigma = 24,
    this.tintOpacity = 0.96,
  });

  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blurSigma;
  final double tintOpacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurSigma,
            sigmaY: blurSigma,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: tintOpacity),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: padding != null
                ? Padding(padding: padding!, child: child)
                : child,
          ),
        ),
      ),
    );
  }
}

/// Frosted header strip inside a [DsGlassCard].
class DsGlassCardHeader extends StatelessWidget {
  const DsGlassCardHeader({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surfaceVariant,
        border: Border(
          bottom: BorderSide(color: AppColors.divider),
        ),
      ),
      child: child,
    );
  }
}

/// Hairline divider for glass card rows.
class DsGlassDivider extends StatelessWidget {
  const DsGlassDivider({super.key, this.indent = 0, this.endIndent = 0});

  final double indent;
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: indent,
      endIndent: endIndent,
      color: AppColors.divider,
    );
  }
}

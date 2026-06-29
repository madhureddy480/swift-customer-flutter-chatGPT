import 'dart:ui';

import 'package:flutter/material.dart';

/// iOS-style frosted glass surface for cards and panels.
class DsGlassCard extends StatelessWidget {
  const DsGlassCard({
    required this.child,
    super.key,
    this.borderRadius = 16,
    this.padding,
    this.margin,
    this.blurSigma = 24,
    this.tintOpacity = 0.78,
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
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 22,
            offset: const Offset(0, 8),
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
              color: const Color(0xFFF5F6F8).withValues(alpha: tintOpacity),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.92),
                width: 1.1,
              ),
            ),
            child: padding != null ? Padding(padding: padding!, child: child) : child,
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
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.38),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.55),
            width: 0.6,
          ),
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
      thickness: 0.6,
      indent: indent,
      endIndent: endIndent,
      color: Colors.white.withValues(alpha: 0.55),
    );
  }
}

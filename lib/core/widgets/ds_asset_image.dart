import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders SVG assets at full vector quality — no downscaling inside padded boxes.
class DsSvg extends StatelessWidget {
  const DsSvg(
    this.assetPath, {
    super.key,
    this.width,
    this.height,
    this.size,
    this.fit = BoxFit.contain,
    this.colorFilter,
    this.semanticsLabel,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final double? size;
  final BoxFit fit;
  final ColorFilter? colorFilter;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final w = size ?? width;
    final h = size ?? height;

    return SvgPicture.asset(
      assetPath,
      width: w,
      height: h,
      fit: fit,
      clipBehavior: Clip.none,
      allowDrawingOutsideViewBox: true,
      colorFilter: colorFilter,
      semanticsLabel: semanticsLabel,
      placeholderBuilder: (_) => SizedBox(width: w, height: h),
    );
  }
}

/// High-resolution raster logo — uses [FilterQuality.high] to avoid blur.
class DsLogo extends StatelessWidget {
  const DsLogo({
    required this.assetPath,
    super.key,
    this.width = 120,
    this.height = 120,
  });

  final String assetPath;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
      gaplessPlayback: true,
    );
  }
}

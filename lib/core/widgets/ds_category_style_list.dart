import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Default stacked list pattern for tab content — Tests categories, Health metrics, etc.
///
/// Spec: white card · 14px radius · 1px dividers indented to text · 58px rows.
abstract final class DsCategoryStyleListMetrics {
  static const borderRadius = 14.0;
  static const horizontalPadding = 16.0;
  static const verticalPadding = 11.0;
  static const iconSize = 36.0;
  static const iconGap = 12.0;
  static const trailingGap = 8.0;
  static const dividerIndent = iconSize + horizontalPadding + iconGap; // 64

  /// Fixed row height when the leading icon is the tallest element.
  static const rowHeight = verticalPadding * 2 + iconSize; // 58
}

abstract final class DsCategoryStyleListTypography {
  static const titleColor = Color(0xFF071B3A);
  static const metaColor = Color(0xFF667085);
  static const chevronColor = Color(0xFF8B95A7);

  static const title = TextStyle(
    color: titleColor,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    height: 1.15,
  );

  static const subtitle = TextStyle(
    color: metaColor,
    fontSize: 10.5,
    fontWeight: FontWeight.w500,
    height: 1.15,
  );

  static const trailingMeta = TextStyle(
    color: metaColor,
    fontSize: 10.5,
    fontWeight: FontWeight.w500,
    height: 1.15,
  );

  static const trailingValue = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w800,
    height: 1.15,
  );

  static const trailingStatus = TextStyle(
    fontSize: 10.5,
    fontWeight: FontWeight.w600,
    height: 1.15,
  );
}

/// White bordered list shell — use for any tab section with stacked rows.
class DsCategoryStyleList extends StatelessWidget {
  const DsCategoryStyleList({
    required this.children,
    super.key,
    this.dividerIndent = DsCategoryStyleListMetrics.dividerIndent,
  });

  final List<Widget> children;
  final double dividerIndent;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(DsCategoryStyleListMetrics.borderRadius),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          for (var index = 0; index < children.length; index++) ...[
            children[index],
            if (index < children.length - 1)
              Divider(
                height: 1,
                indent: dividerIndent,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

/// Section title + [DsCategoryStyleList] — default pattern for tab list blocks.
class DsCategoryStyleListSection extends StatelessWidget {
  const DsCategoryStyleListSection({
    required this.children,
    super.key,
    this.title,
    this.titleWidget,
    this.spacing = 10,
  }) : assert(
          title != null || titleWidget != null,
          'Provide title or titleWidget',
        );

  final String? title;
  final Widget? titleWidget;
  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleWidget ??
            Text(
              title!,
              style: const TextStyle(
                color: DsCategoryStyleListTypography.titleColor,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.2,
                letterSpacing: -0.2,
              ),
            ),
        SizedBox(height: spacing),
        DsCategoryStyleList(children: children),
      ],
    );
  }
}

/// 36px circular leading icon — left column of every category-style row.
class DsCategoryStyleListLeadingIcon extends StatelessWidget {
  const DsCategoryStyleListLeadingIcon({
    required this.color,
    required this.icon,
    super.key,
    this.iconColor = Colors.white,
    this.iconSize = 20,
  });

  final Color color;
  final IconData icon;
  final Color iconColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: DsCategoryStyleListMetrics.iconSize,
      height: DsCategoryStyleListMetrics.iconSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: iconColor, size: iconSize),
    );
  }
}

/// Standard 58px list row — leading icon · title/subtitle · optional trailing.
class DsCategoryStyleListRow extends StatelessWidget {
  const DsCategoryStyleListRow({
    required this.leading,
    required this.title,
    super.key,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.semanticsLabel,
  });

  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final row = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DsCategoryStyleListMetrics.horizontalPadding,
        vertical: DsCategoryStyleListMetrics.verticalPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leading,
          const SizedBox(width: DsCategoryStyleListMetrics.iconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                title,
                if (subtitle != null) subtitle!,
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: DsCategoryStyleListMetrics.trailingGap),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap == null) return row;

    return Semantics(
      button: true,
      label: semanticsLabel,
      child: InkWell(
        onTap: onTap,
        child: row,
      ),
    );
  }
}

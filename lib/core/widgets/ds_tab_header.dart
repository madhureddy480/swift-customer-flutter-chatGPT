import 'package:dr_swift_diagnostics/core/constants/asset_paths.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_asset_image.dart';
import 'package:flutter/material.dart';

const _ink = Color(0xFF1A1C1E);

/// Pixels scrolled before the header fully collapses beside the logo.
const kDsTabHeaderCollapseDistance = 48.0;

/// Consistent shell tab header — logo top-left, centered title, optional trailing.
///
/// At scroll offset 0 the title is centered in dark ink at 16px. As the user
/// scrolls, the title moves beside the logo and shrinks to 14px.
class DsTabHeader extends StatelessWidget {
  const DsTabHeader({
    required this.title,
    super.key,
    this.trailing,
    this.showLogo = true,
    this.collapseProgress = 0,
    this.backgroundColor = Colors.white,
  });

  final String title;
  final Widget? trailing;
  final bool showLogo;
  final double collapseProgress;
  final Color backgroundColor;

  static const double barHeight = 40;
  static const double logoSize = 36;
  static const double _expandedFontSize = 16;
  static const double _collapsedFontSize = 14;
  static const double _verticalPadding = 6;
  static const double _bottomPadding = 10;

  static double get extent =>
      _verticalPadding + barHeight + _bottomPadding;

  TextStyle _titleStyle({
    required Color color,
    required double fontSize,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.2,
      height: 1.1,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = collapseProgress.clamp(0.0, 1.0);
    final collapsedFontSize =
        _expandedFontSize + ((_collapsedFontSize - _expandedFontSize) * t);

    return ColoredBox(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          _verticalPadding,
          AppSpacing.lg,
          _bottomPadding,
        ),
        child: SizedBox(
          height: barHeight,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              if (showLogo)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: DsLogo(
                    assetPath: AssetPaths.logo,
                    width: logoSize,
                    height: logoSize,
                  ),
                ),
              IgnorePointer(
                child: Opacity(
                  opacity: 1 - t,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: showLogo ? logoSize + 8 : 0,
                    ),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _titleStyle(
                        color: _ink,
                        fontSize: _expandedFontSize,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  if (showLogo) SizedBox(width: logoSize + (8 * t)),
                  Expanded(
                    child: Opacity(
                      opacity: t,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _titleStyle(
                            color: _ink,
                            fontSize: collapsedFontSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pinned tab header driven by [collapseProgress] (0 = expanded, 1 = collapsed).
class DsTabHeaderSliver extends StatelessWidget {
  const DsTabHeaderSliver({
    required this.title,
    required this.collapseProgress,
    super.key,
    this.trailing,
    this.showLogo = true,
    this.backgroundColor = Colors.white,
  });

  final String title;
  final double collapseProgress;
  final Widget? trailing;
  final bool showLogo;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _DsTabHeaderDelegate(
        title: title,
        trailing: trailing,
        showLogo: showLogo,
        backgroundColor: backgroundColor,
        collapseProgress: collapseProgress,
      ),
    );
  }
}

class _DsTabHeaderDelegate extends SliverPersistentHeaderDelegate {
  _DsTabHeaderDelegate({
    required this.title,
    required this.trailing,
    required this.showLogo,
    required this.backgroundColor,
    required this.collapseProgress,
  });

  final String title;
  final Widget? trailing;
  final bool showLogo;
  final Color backgroundColor;
  final double collapseProgress;

  @override
  double get minExtent => DsTabHeader.extent;

  @override
  double get maxExtent => DsTabHeader.extent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return DsTabHeader(
      title: title,
      trailing: trailing,
      showLogo: showLogo,
      collapseProgress: collapseProgress,
      backgroundColor: backgroundColor,
    );
  }

  @override
  bool shouldRebuild(covariant _DsTabHeaderDelegate oldDelegate) {
    return title != oldDelegate.title ||
        trailing != oldDelegate.trailing ||
        showLogo != oldDelegate.showLogo ||
        backgroundColor != oldDelegate.backgroundColor ||
        collapseProgress != oldDelegate.collapseProgress;
  }
}

/// Listens to [scrollController] and exposes collapse progress for tab headers.
class DsTabScrollCollapseScope extends StatefulWidget {
  const DsTabScrollCollapseScope({
    required this.scrollController,
    required this.builder,
    super.key,
    this.collapseDistance = kDsTabHeaderCollapseDistance,
  });

  final ScrollController scrollController;
  final double collapseDistance;
  final Widget Function(BuildContext context, double collapseProgress) builder;

  @override
  State<DsTabScrollCollapseScope> createState() =>
      _DsTabScrollCollapseScopeState();
}

class _DsTabScrollCollapseScopeState extends State<DsTabScrollCollapseScope> {
  double _collapseProgress = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant DsTabScrollCollapseScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_onScroll);
      widget.scrollController.addListener(_onScroll);
      _onScroll();
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final next = (widget.scrollController.offset / widget.collapseDistance)
        .clamp(0.0, 1.0);
    if (next == _collapseProgress) {
      return;
    }
    setState(() => _collapseProgress = next);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _collapseProgress);
  }
}

/// Tab body with a pinned collapsible header and a scrollable child list.
class DsTabScrollView extends StatefulWidget {
  const DsTabScrollView({
    required this.title,
    required this.children,
    super.key,
    this.trailing,
    this.showLogo = true,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.sm,
      AppSpacing.lg,
      AppSpacing.xl,
    ),
    this.backgroundColor = Colors.white,
  });

  final String title;
  final List<Widget> children;
  final Widget? trailing;
  final bool showLogo;
  final EdgeInsets padding;
  final Color backgroundColor;

  @override
  State<DsTabScrollView> createState() => _DsTabScrollViewState();
}

class _DsTabScrollViewState extends State<DsTabScrollView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: widget.backgroundColor,
      child: DsTabScrollCollapseScope(
        scrollController: _scrollController,
        builder: (context, collapseProgress) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              DsTabHeaderSliver(
                title: widget.title,
                collapseProgress: collapseProgress,
                trailing: widget.trailing,
                showLogo: widget.showLogo,
                backgroundColor: widget.backgroundColor,
              ),
              SliverPadding(
                padding: widget.padding,
                sliver: SliverList(
                  delegate: SliverChildListDelegate(widget.children),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Custom scroll view with pinned collapsible tab header + caller-supplied slivers.
class DsTabSliverScrollView extends StatefulWidget {
  const DsTabSliverScrollView({
    required this.title,
    required this.slivers,
    super.key,
    this.trailing,
    this.showLogo = true,
    this.backgroundColor = Colors.white,
  });

  final String title;
  final List<Widget> slivers;
  final Widget? trailing;
  final bool showLogo;
  final Color backgroundColor;

  @override
  State<DsTabSliverScrollView> createState() => _DsTabSliverScrollViewState();
}

class _DsTabSliverScrollViewState extends State<DsTabSliverScrollView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DsTabScrollCollapseScope(
      scrollController: _scrollController,
      builder: (context, collapseProgress) {
        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            DsTabHeaderSliver(
              title: widget.title,
              collapseProgress: collapseProgress,
              trailing: widget.trailing,
              showLogo: widget.showLogo,
              backgroundColor: widget.backgroundColor,
            ),
            ...widget.slivers,
          ],
        );
      },
    );
  }
}

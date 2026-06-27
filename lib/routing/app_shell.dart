import 'package:dr_swift_diagnostics/core/constants/asset_paths.dart';
import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_asset_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    (label: 'Tests', icon: AssetPaths.navFlask, branch: 0),
    (label: 'Reports', icon: AssetPaths.navReports, branch: 1),
    (label: 'Health', icon: AssetPaths.navGraph, branch: 2),
    (label: 'Account', icon: AssetPaths.navPerson, branch: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _tabs.map((tab) {
                final selected = navigationShell.currentIndex == tab.branch;
                return _NavItem(
                  label: tab.label,
                  iconAsset: tab.icon,
                  selected: selected,
                  onTap: () => navigationShell.goBranch(
                    tab.branch,
                    initialLocation:
                        tab.branch == navigationShell.currentIndex,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.iconAsset,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String iconAsset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textTertiary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DsSvg(
              iconAsset,
              size: 24,
              colorFilter: selected
                  ? null
                  : const ColorFilter.mode(
                      AppColors.textTertiary,
                      BlendMode.srcIn,
                    ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

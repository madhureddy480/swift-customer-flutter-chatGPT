import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/theme/app_typography.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_category_style_list.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_tab_header.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Account tab — grouped settings menu with category-style list rows.
class AccountTabGuestScreen extends StatelessWidget {
  const AccountTabGuestScreen({super.key});

  static const _menuIconBackground = Color(0xFFF3F0F8);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: DsTabScrollView(
        title: 'Account',
        backgroundColor: AppColors.background,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageHorizontal,
          AppSpacing.pageTop,
          AppSpacing.pageHorizontal,
          AppSpacing.xl,
        ),
        children: [
          _SignInCard(
            onTap: () => context.push(RoutePaths.login),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          DsCategoryStyleListSection(
            title: 'Your account',
            children: [
              _AccountMenuRow(
                label: 'Profile',
                icon: Icons.person_outline_rounded,
                onTap: () =>
                    _promptSignIn(context, 'Sign in to manage your profile.'),
              ),
              _AccountMenuRow(
                label: 'Family Members',
                icon: Icons.groups_outlined,
                onTap: () => _promptSignIn(
                  context,
                  'Sign in to manage family members.',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          DsCategoryStyleListSection(
            title: 'Orders & delivery',
            children: [
              _AccountMenuRow(
                label: 'Orders',
                icon: Icons.receipt_long_outlined,
                onTap: () => _promptSignIn(context, 'Sign in to view orders.'),
              ),
              _AccountMenuRow(
                label: 'Addresses',
                icon: Icons.location_on_outlined,
                onTap: () => _promptSignIn(
                  context,
                  'Sign in to save and manage addresses.',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          DsCategoryStyleListSection(
            title: 'App',
            children: [
              _AccountMenuRow(
                label: 'Notifications',
                icon: Icons.notifications_outlined,
                onTap: () => _showComingSoon(context, 'Notifications'),
              ),
              _AccountMenuRow(
                label: 'Settings',
                icon: Icons.settings_outlined,
                onTap: () => _showComingSoon(context, 'Settings'),
              ),
              _AccountMenuRow(
                label: 'Support',
                icon: Icons.help_outline_rounded,
                onTap: () => _showSupport(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static void _promptSignIn(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Sign in',
          onPressed: () => context.push(RoutePaths.login),
        ),
      ),
    );
  }

  static void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label will be available soon.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void _showSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Support: call +91 98765 43210 or email care@drswift.in'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _AccountMenuRow extends StatelessWidget {
  const _AccountMenuRow({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DsCategoryStyleListRow(
      semanticsLabel: label,
      onTap: onTap,
      leading: DsCategoryStyleListLeadingIcon(
        color: AccountTabGuestScreen._menuIconBackground,
        iconColor: AppColors.primaryVibrant,
        icon: icon,
      ),
      title: Text(label, style: DsCategoryStyleListTypography.title),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: DsCategoryStyleListTypography.chevronColor,
        size: 21,
      ),
    );
  }
}

class _SignInCard extends StatelessWidget {
  const _SignInCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          DsCategoryStyleListMetrics.borderRadius,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF6F0FF), Color(0xFFEDE4FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(
              DsCategoryStyleListMetrics.borderRadius,
            ),
            border: Border.all(
              color: AppColors.primaryVibrant.withValues(alpha: 0.18),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DsCategoryStyleListMetrics.horizontalPadding,
              vertical: DsCategoryStyleListMetrics.horizontalPadding,
            ),
            child: Row(
              children: [
                DsCategoryStyleListLeadingIcon(
                  color: AppColors.primaryVibrant.withValues(alpha: 0.16),
                  iconColor: AppColors.primaryVibrant,
                  icon: Icons.login_rounded,
                ),
                const SizedBox(width: DsCategoryStyleListMetrics.iconGap),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign in',
                        style: AppTypography.cardTitle,
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Sync reports, family profiles & health trends',
                        style: DsCategoryStyleListTypography.subtitle,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.primaryVibrant.withValues(alpha: 0.7),
                  size: 21,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

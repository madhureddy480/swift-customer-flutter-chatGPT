import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
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
        backgroundColor: _screenBg,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          _SignInCard(
            onTap: () => context.push(RoutePaths.login),
          ),
          const SizedBox(height: AppSpacing.xl),
          DsCategoryStyleListSection(
            title: 'Your account',
            children: [
              _AccountMenuRow(
                label: 'Profile',
                icon: Icons.person_outline_rounded,
              ),
              _AccountMenuRow(
                label: 'Family Members',
                icon: Icons.groups_outlined,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          DsCategoryStyleListSection(
            title: 'Orders & delivery',
            children: [
              _AccountMenuRow(
                label: 'Orders',
                icon: Icons.receipt_long_outlined,
              ),
              _AccountMenuRow(
                label: 'Addresses',
                icon: Icons.location_on_outlined,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          DsCategoryStyleListSection(
            title: 'App',
            children: [
              _AccountMenuRow(
                label: 'Notifications',
                icon: Icons.notifications_outlined,
              ),
              _AccountMenuRow(
                label: 'Settings',
                icon: Icons.settings_outlined,
              ),
              _AccountMenuRow(
                label: 'Support',
                icon: Icons.help_outline_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AccountMenuRow extends StatelessWidget {
  const _AccountMenuRow({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DsCategoryStyleListRow(
      semanticsLabel: label,
      onTap: () {},
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
                        style: TextStyle(
                          color: _ink,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
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

const _screenBg = Color(0xFFF4F7FA);
const _ink = Color(0xFF1A1C1E);

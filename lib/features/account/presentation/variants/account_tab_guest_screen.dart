import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_tab_header.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Account tab — grouped settings menu with consistent visual language.
class AccountTabGuestScreen extends StatelessWidget {
  const AccountTabGuestScreen({super.key});

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
          const _SectionLabel('Your account'),
          const SizedBox(height: AppSpacing.sm),
          const _MenuCard(
            items: [
              _MenuItem(
                label: 'Profile',
                icon: Icons.person_outline_rounded,
              ),
              _MenuItem(
                label: 'Family Members',
                icon: Icons.groups_outlined,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const _SectionLabel('Orders & delivery'),
          const SizedBox(height: AppSpacing.sm),
          const _MenuCard(
            items: [
              _MenuItem(
                label: 'Orders',
                icon: Icons.receipt_long_outlined,
              ),
              _MenuItem(
                label: 'Addresses',
                icon: Icons.location_on_outlined,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const _SectionLabel('App'),
          const SizedBox(height: AppSpacing.sm),
          const _MenuCard(
            items: [
              _MenuItem(
                label: 'Notifications',
                icon: Icons.notifications_outlined,
              ),
              _MenuItem(
                label: 'Settings',
                icon: Icons.settings_outlined,
              ),
              _MenuItem(
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

class _SignInCard extends StatelessWidget {
  const _SignInCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF6F0FF), Color(0xFFEDE4FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.primaryVibrant.withValues(alpha: 0.18),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                const _IconBubble(
                  icon: Icons.login_rounded,
                  prominent: true,
                ),
                const SizedBox(width: 14),
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
                        style: TextStyle(
                          color: _muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.primaryVibrant.withValues(alpha: 0.7),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: _muted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          height: 1.2,
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.items});

  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            _AccountMenuRow(item: items[index]),
            if (index < items.length - 1)
              const Divider(
                height: 1,
                thickness: 1,
                indent: 68,
                endIndent: 16,
                color: Color(0xFFEEF1F6),
              ),
          ],
        ],
      ),
    );
  }
}

class _AccountMenuRow extends StatelessWidget {
  const _AccountMenuRow({required this.item});

  final _MenuItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              _IconBubble(icon: item.icon),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.label,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFB8BEC8),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.icon,
    this.prominent = false,
  });

  final IconData icon;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: prominent
            ? AppColors.primaryVibrant.withValues(alpha: 0.16)
            : const Color(0xFFF3F0F8),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: 20,
        color: AppColors.primaryVibrant,
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

const _screenBg = Color(0xFFF4F7FA);
const _ink = Color(0xFF1A1C1E);
const _muted = Color(0xFF667085);

final _cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(14),
  border: Border.all(color: const Color(0xFFE2E6EE)),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF101828).withValues(alpha: 0.03),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ],
);

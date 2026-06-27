import 'package:dr_swift_diagnostics/core/constants/asset_paths.dart';
import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_asset_image.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_buttons.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_scaffold.dart';
import 'package:dr_swift_diagnostics/features/authentication/presentation/providers/auth_state_provider.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Account tab — guest login CTA matching mockup screen 5.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    if (isAuthenticated) {
      return _AuthenticatedAccountView();
    }

    return const _GuestAccountView();
  }
}

class _GuestAccountView extends StatelessWidget {
  const _GuestAccountView();

  @override
  Widget build(BuildContext context) {
    return DsScaffold(
      safeArea: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.xl),
            Center(
              child: Column(
                children: [
                  const DsLogo(
                    assetPath: AssetPaths.logo,
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Dr Swift Diagnostics',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            DsPrimaryButton(
              label: 'Continue with OTP',
              icon: Icons.phone_android_outlined,
              onPressed: () => context.push(RoutePaths.login),
            ),
            const SizedBox(height: AppSpacing.md),
            DsOutlineButton(
              label: 'Continue with Google',
              onPressed: () => context.push(RoutePaths.login),
            ),
            const SizedBox(height: AppSpacing.md),
            DsOutlineButton(
              label: 'Continue with Apple',
              onPressed: () => context.push(RoutePaths.login),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            const _BenefitsChecklist(),
          ],
        ),
      ),
    );
  }
}

class _BenefitsChecklist extends StatelessWidget {
  const _BenefitsChecklist();

  static const _items = [
    (AssetPaths.bookTests, 'Book tests from 200+ options'),
    (AssetPaths.downloadAnytime, 'Same-day digital reports'),
    (AssetPaths.compareHistory, 'Track health trends over time'),
    (AssetPaths.addFamily, 'Manage family health profiles'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          child: Row(
            children: [
              DsSvg(item.$1, size: 32),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Text(
                  item.$2,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _AuthenticatedAccountView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DsScaffold(
      padding: const EdgeInsets.all(AppSpacing.lg),
      body: ListView(
        children: [
          Text('Account', style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.xl),
          ..._menuItems.map(
            (item) => ListTile(
              leading: DsSvg(item.icon, size: 24),
              title: Text(item.label),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem({required this.label, required this.icon});

  final String label;
  final String icon;
}

const _menuItems = [
  _MenuItem(label: 'Profile', icon: AssetPaths.navPerson),
  _MenuItem(label: 'Family Members', icon: AssetPaths.addFamily),
  _MenuItem(label: 'Orders', icon: AssetPaths.bookTests),
  _MenuItem(label: 'Addresses', icon: AssetPaths.patientFirst),
  _MenuItem(label: 'Notifications', icon: AssetPaths.downloadAnytime),
  _MenuItem(label: 'Settings', icon: AssetPaths.accurateResults),
  _MenuItem(label: 'Support', icon: AssetPaths.trackReports),
];

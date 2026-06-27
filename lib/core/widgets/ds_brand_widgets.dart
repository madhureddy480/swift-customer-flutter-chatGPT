import 'package:dr_swift_diagnostics/core/constants/asset_paths.dart';
import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_asset_image.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_scaffold.dart';
import 'package:flutter/material.dart';

/// App header matching mockup screen 2: logo left, notification bell right.
class DsAppHeader extends StatelessWidget {
  const DsAppHeader({
    super.key,
    this.onNotificationTap,
    this.trailing,
  });

  final VoidCallback? onNotificationTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          const DsLogo(
            assetPath: AssetPaths.logo,
            width: 40,
            height: 40,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dr Swift',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                ),
                Text(
                  'DIAGNOSTICS',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textTertiary,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                        fontSize: 9,
                      ),
                ),
              ],
            ),
          ),
          trailing ??
              IconButton(
                onPressed: onNotificationTap,
                icon: const Icon(Icons.notifications_outlined),
                color: AppColors.textPrimary,
              ),
        ],
      ),
    );
  }
}

/// Dark onboarding header: logo + tagline (mockup 1A–1C).
class DsOnboardingHeader extends StatelessWidget {
  const DsOnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DsLogo(
          assetPath: AssetPaths.logo,
          width: 88,
          height: 88,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Dr Swift',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textOnDark,
                fontWeight: FontWeight.w700,
              ),
        ),
        Text(
          'DIAGNOSTICS',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textOnDarkMuted,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'See More Than Numbers.\nSee Your Health.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textOnDarkMuted,
                height: 1.45,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Feature row for splash/onboarding dark screens.
class DsFeatureRow extends StatelessWidget {
  const DsFeatureRow({
    required this.iconAsset,
    required this.label,
    super.key,
  });

  final String iconAsset;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          DsSvg(iconAsset, size: 40),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textOnDark,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular health profile chip (mockup screen 2).
class DsHealthProfileChip extends StatelessWidget {
  const DsHealthProfileChip({
    required this.label,
    required this.iconAsset,
    super.key,
    this.onTap,
  });

  final String label;
  final String iconAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              alignment: Alignment.center,
              child: DsSvg(iconAsset, size: 44),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Promo banner — solid purple, no gradient (mockup screen 2).
class DsPromoBanner extends StatelessWidget {
  const DsPromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.promoPurple,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book before 11 AM,\nget same-day reports.',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Fast. Accurate. Reliable.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.88),
                  ),
                ),
              ],
            ),
          ),
          const DsSvg(
            AssetPaths.patientFirst,
            width: 72,
            height: 72,
          ),
        ],
      ),
    );
  }
}

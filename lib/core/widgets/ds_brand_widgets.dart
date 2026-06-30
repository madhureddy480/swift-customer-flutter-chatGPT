import 'package:dr_swift_diagnostics/core/constants/asset_paths.dart';
import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_asset_image.dart';
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
                        letterSpacing: 0,
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

/// Centered brand lockup for login screen — horizontal logo + tagline.
class DsLoginBrandLockup extends StatelessWidget {
  const DsLoginBrandLockup({super.key});

  static const _navy = AppColors.navy;
  static const _taglineOrange = Color(0xFFE8940A);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const DsLogo(
              assetPath: AssetPaths.logo,
              width: 54,
              height: 54,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Dr Swift',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                        color: AppColors.textPrimary,
                        height: 1.1,
                        letterSpacing: -0.15,
                      ),
                ),
                const Text(
                  'DIAGNOSTICS',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.2,
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.45,
              color: _navy,
            ),
            children: [
              TextSpan(text: 'See More Than Numbers,\nSee '),
              TextSpan(
                text: 'Your',
                style: TextStyle(color: _taglineOrange),
              ),
              TextSpan(text: ' Health.'),
            ],
          ),
        ),
      ],
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

/// Health profile card for Tests home — matches `docs/health_profile_flow.png`.
class DsHealthProfileCard extends StatelessWidget {
  const DsHealthProfileCard({
    required this.title,
    required this.testCount,
    required this.imageAsset,
    required this.width,
    required this.height,
    super.key,
    this.onTap,
  });

  final String title;
  final int testCount;
  final String imageAsset;
  final double width;
  final double height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$title, $testCount tests',
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE8E8EF)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                  isAntiAlias: true,
                ),
                Positioned(
                  left: width * 0.43,
                  right: 5,
                  top: 0,
                  bottom: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF17213D),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          height: 1.05,
                          letterSpacing: -0.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$testCount Tests',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF65708A),
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Circular health profile chip (legacy — prefer [DsHealthProfileCard] on Tests home).
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

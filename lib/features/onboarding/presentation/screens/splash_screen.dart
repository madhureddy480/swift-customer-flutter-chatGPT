import 'package:dr_swift_diagnostics/core/constants/asset_paths.dart';
import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_brand_widgets.dart';
import 'package:dr_swift_diagnostics/features/onboarding/data/onboarding_repository.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Splash — dark canvas matching mockup 1A while bootstrapping.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future<void>.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;

    final onboardingComplete =
        await ref.read(onboardingRepositoryProvider).isComplete();

    if (!mounted) return;

    if (!onboardingComplete) {
      context.go(RoutePaths.onboarding);
      return;
    }

    context.go(RoutePaths.tests);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.onboardingBg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              Spacer(),
              DsOnboardingHeader(),
              SizedBox(height: AppSpacing.xxl),
              DsFeatureRow(
                iconAsset: AssetPaths.bookTests,
                label: 'At-home sample collection',
              ),
              DsFeatureRow(
                iconAsset: AssetPaths.downloadAnytime,
                label: 'Same-day digital reports',
              ),
              DsFeatureRow(
                iconAsset: AssetPaths.flask,
                label: '200+ diagnostic tests',
              ),
              DsFeatureRow(
                iconAsset: AssetPaths.addFamily,
                label: 'One account for the whole family',
              ),
              DsFeatureRow(
                iconAsset: AssetPaths.compareHistory,
                label: 'Historical data & trend graphs',
              ),
              Spacer(),
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  color: AppColors.primaryLight,
                  strokeWidth: 2.5,
                ),
              ),
              SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

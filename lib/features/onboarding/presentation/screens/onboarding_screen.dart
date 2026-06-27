import 'package:dr_swift_diagnostics/core/constants/asset_paths.dart';
import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_asset_image.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_brand_widgets.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_buttons.dart';
import 'package:dr_swift_diagnostics/features/onboarding/data/onboarding_repository.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Three-page onboarding matching mockup 1A, 1B, 1C.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  Future<void> _complete() async {
    await ref.read(onboardingRepositoryProvider).markComplete();
    if (!mounted) return;
    context.go(RoutePaths.tests);
  }

  void _next() {
    if (_currentPage < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    _complete();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBg,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _complete,
                child: const Text(
                  'Skip',
                  style: TextStyle(color: AppColors.textOnDarkMuted),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: const [
                  _OnboardingPageOne(),
                  _OnboardingPageTwo(),
                  _OnboardingPageThree(),
                ],
              ),
            ),
            _PageIndicator(currentPage: _currentPage),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.md,
                AppSpacing.xl,
                AppSpacing.xl,
              ),
              child: DsPrimaryButton(
                label: _currentPage == 2 ? 'Get Started' : 'Continue',
                onPressed: _next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.currentPage});

  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final active = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active
                ? AppColors.primaryLight
                : Colors.white.withValues(alpha: 0.24),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

/// Mockup 1A — feature list.
class _OnboardingPageOne extends StatelessWidget {
  const _OnboardingPageOne();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        children: [
          const DsOnboardingHeader(),
          const SizedBox(height: AppSpacing.xxl),
          const DsFeatureRow(
            iconAsset: AssetPaths.bookTests,
            label: 'At-home sample collection',
          ),
          const DsFeatureRow(
            iconAsset: AssetPaths.downloadAnytime,
            label: 'Same-day digital reports',
          ),
          const DsFeatureRow(
            iconAsset: AssetPaths.flask,
            label: '200+ diagnostic tests',
          ),
          const DsFeatureRow(
            iconAsset: AssetPaths.addFamily,
            label: 'One account for the whole family',
          ),
          const DsFeatureRow(
            iconAsset: AssetPaths.compareHistory,
            label: 'Historical data & trend graphs',
          ),
        ],
      ),
    );
  }
}

/// Mockup 1B — health history table + trends chart.
class _OnboardingPageTwo extends StatelessWidget {
  const _OnboardingPageTwo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: AppColors.textOnDark,
            displayColor: AppColors.textOnDark,
          ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Theme(
        data: theme,
        child: Column(
          children: [
            const DsOnboardingHeader(),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Your health history,\nalways with you.',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: AppColors.textOnDark,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.onboardingSurface,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Health History',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _HistoryRow('HbA1c', '6.8%', 'Improved'),
                  _HistoryRow('Vitamin D', '18 ng/mL', 'Low'),
                  _HistoryRow('Cholesterol', '198 mg/dL', 'Normal'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              height: 180,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.onboardingSurface,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trends Over Time',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (_) => FlLine(
                            color: Colors.white.withValues(alpha: 0.08),
                            strokeWidth: 1,
                          ),
                        ),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          _trendLine(AppColors.accentOrange, const [
                            FlSpot(0, 7.4),
                            FlSpot(1, 7.0),
                            FlSpot(2, 6.9),
                            FlSpot(3, 6.8),
                          ]),
                          _trendLine(AppColors.accentBlue, const [
                            FlSpot(0, 14),
                            FlSpot(1, 15),
                            FlSpot(2, 17),
                            FlSpot(3, 18),
                          ]),
                          _trendLine(AppColors.accentGreen, const [
                            FlSpot(0, 220),
                            FlSpot(1, 210),
                            FlSpot(2, 205),
                            FlSpot(3, 198),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartBarData _trendLine(Color color, List<FlSpot> spots) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 2.5,
      dotData: const FlDotData(show: false),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow(this.name, this.value, this.status);

  final String name;
  final String value;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(name)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: AppSpacing.md),
          Text(
            status,
            style: TextStyle(
              color: AppColors.textOnDarkMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Mockup 1C — four value-prop cards.
class _OnboardingPageThree extends StatelessWidget {
  const _OnboardingPageThree();

  static const _cards = [
    (
      icon: AssetPaths.accurateResults,
      title: 'Tests you can understand',
      subtitle: 'Plain-language explanations for every result.',
    ),
    (
      icon: AssetPaths.diabetesCareProfile,
      title: 'Health Profiles',
      subtitle: 'Curated bundles for your health goals.',
    ),
    (
      icon: AssetPaths.addFamily,
      title: 'One account for the whole family',
      subtitle: 'Manage everyone from a single app.',
    ),
    (
      icon: AssetPaths.trackReports,
      title: 'Results & Insights in your pocket',
      subtitle: 'Reports, trends, and insights anywhere.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        children: [
          const DsOnboardingHeader(),
          const SizedBox(height: AppSpacing.xl),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.92,
            ),
            itemCount: _cards.length,
            itemBuilder: (context, index) {
              final card = _cards[index];
              return Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.onboardingSurface,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DsSvg(card.icon, size: 48),
                    const Spacer(),
                    Text(
                      card.title,
                      style: const TextStyle(
                        color: AppColors.textOnDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      card.subtitle,
                      style: const TextStyle(
                        color: AppColors.textOnDarkMuted,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

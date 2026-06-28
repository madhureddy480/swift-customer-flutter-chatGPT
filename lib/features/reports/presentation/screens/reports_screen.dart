import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_buttons.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_scaffold.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_status_chip.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Reports tab — sample report preview matching mockup screen 3.
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DsScaffold(
      safeArea: false,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sample Report',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Preview how your results will look',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            sliver: SliverList.separated(
              itemCount: _sampleBiomarkers.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final biomarker = _sampleBiomarkers[index];
                return _BiomarkerReportCard(biomarker: biomarker);
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              child: DsPrimaryButton(
                label: 'View Full Sample Report',
                onPressed: () => context.push(RoutePaths.login),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BiomarkerReportCard extends StatelessWidget {
  const _BiomarkerReportCard({required this.biomarker});

  final _BiomarkerMock biomarker;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DsCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  biomarker.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  biomarker.value,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Ref: ${biomarker.reference}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              DsStatusChip(
                label: biomarker.statusLabel,
                type: biomarker.status,
              ),
              const SizedBox(height: AppSpacing.lg),
              Icon(
                biomarker.trendUp
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                color: biomarker.trendUp
                    ? AppColors.success
                    : biomarker.status == DsStatusType.low
                        ? AppColors.error
                        : AppColors.success,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BiomarkerMock {
  const _BiomarkerMock({
    required this.name,
    required this.value,
    required this.reference,
    required this.statusLabel,
    required this.status,
    required this.trendUp,
  });

  final String name;
  final String value;
  final String reference;
  final String statusLabel;
  final DsStatusType status;
  final bool trendUp;
}

const _sampleBiomarkers = [
  _BiomarkerMock(
    name: 'HbA1c',
    value: '6.8%',
    reference: '4.0 – 5.6%',
    statusLabel: '6.8% Improved',
    status: DsStatusType.improved,
    trendUp: false,
  ),
  _BiomarkerMock(
    name: 'Vitamin D',
    value: '18 ng/mL',
    reference: '30 – 100 ng/mL',
    statusLabel: '18 ng/mL Low',
    status: DsStatusType.low,
    trendUp: true,
  ),
  _BiomarkerMock(
    name: 'Total Cholesterol',
    value: '198 mg/dL',
    reference: '< 200 mg/dL',
    statusLabel: 'Normal',
    status: DsStatusType.normal,
    trendUp: false,
  ),
];

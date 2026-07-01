import 'package:dr_swift_diagnostics/core/widgets/ds_glass_card.dart';
import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_typography.dart';
import 'package:dr_swift_diagnostics/features/reports/data/models/report_models.dart';
import 'package:flutter/material.dart';

class ReportsHealthIndicatorsSection extends StatelessWidget {
  const ReportsHealthIndicatorsSection({
    required this.indicators,
    super.key,
  });

  final List<ReportHealthIndicator> indicators;

  @override
  Widget build(BuildContext context) {
    return DsGlassCard(
      borderRadius: 16,
      child: Column(
        children: [
          const DsGlassCardHeader(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      'Condition',
                      style: AppTypography.smallLabel,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Your lab result',
                      textAlign: TextAlign.right,
                      style: AppTypography.smallLabel,
                    ),
                  ),
                ],
              ),
            ),
          ),
          for (var i = 0; i < indicators.length; i++)
            _HealthIndicatorRow(
              indicator: indicators[i],
              showDivider: i < indicators.length - 1,
            ),
        ],
      ),
    );
  }
}

class _HealthIndicatorRow extends StatelessWidget {
  const _HealthIndicatorRow({
    required this.indicator,
    required this.showDivider,
  });

  final ReportHealthIndicator indicator;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      indicator.condition,
                      style: AppTypography.compactCardTitle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      indicator.labResult,
                      textAlign: TextAlign.right,
                      style: AppTypography.smallLabel.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                indicator.symptoms,
                style: AppTypography.smallLabel,
              ),
            ],
          ),
        ),
        if (showDivider) const DsGlassDivider(),
      ],
    );
  }
}

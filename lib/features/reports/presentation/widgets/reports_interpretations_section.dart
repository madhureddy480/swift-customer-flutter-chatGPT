import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_glass_card.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/theme/app_typography.dart';
import 'package:dr_swift_diagnostics/features/reports/data/models/report_models.dart';
import 'package:flutter/material.dart';

class ReportsInterpretationsSection extends StatelessWidget {
  const ReportsInterpretationsSection({
    required this.interpretations,
    super.key,
  });

  final List<ReportInterpretation> interpretations;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < interpretations.length; i++) ...[
          _InterpretationCard(interpretation: interpretations[i]),
          if (i < interpretations.length - 1)
            const SizedBox(height: AppSpacing.cardGap),
        ],
      ],
    );
  }
}

class _InterpretationCard extends StatelessWidget {
  const _InterpretationCard({required this.interpretation});

  final ReportInterpretation interpretation;

  @override
  Widget build(BuildContext context) {
    return DsGlassCard(
      borderRadius: AppSpacing.tabCardRadius,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  interpretation.title,
                  style: AppTypography.compactCardTitle,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: interpretation.flag.valueColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                child: Text(
                  interpretation.flagLabel,
                  style: TextStyle(
                    color: interpretation.flag.valueColor,
                    fontSize: AppTypography.compactLabel.fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'What this tests',
            style: AppTypography.compactLabel,
          ),
          const SizedBox(height: 3),
          Text(
            interpretation.whatThisTests,
            style: AppTypography.cardSubtitle.copyWith(
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Doctor interpretation',
            style: AppTypography.compactLabel,
          ),
          const SizedBox(height: 3),
          Text(
            interpretation.doctorInterpretation,
            style: AppTypography.cardSubtitle.copyWith(
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

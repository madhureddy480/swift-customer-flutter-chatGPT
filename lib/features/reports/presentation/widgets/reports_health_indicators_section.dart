import 'package:dr_swift_diagnostics/core/widgets/ds_glass_card.dart';
import 'package:dr_swift_diagnostics/features/reports/data/models/report_models.dart';
import 'package:flutter/material.dart';

const _ink = Color(0xFF1A1C1E);
const _muted = Color(0xFF667085);

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
          DsGlassCardHeader(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              child: const Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      'Condition',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Your lab result',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: _muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
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
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      indicator.labResult,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xFFD64545),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                indicator.symptoms,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const DsGlassDivider(),
      ],
    );
  }
}

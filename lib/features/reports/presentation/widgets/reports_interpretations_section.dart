import 'package:dr_swift_diagnostics/core/widgets/ds_glass_card.dart';
import 'package:dr_swift_diagnostics/features/reports/data/models/report_models.dart';
import 'package:flutter/material.dart';

const _ink = Color(0xFF1A1C1E);
const _muted = Color(0xFF667085);

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
          if (i < interpretations.length - 1) const SizedBox(height: 10),
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
      borderRadius: 16,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  interpretation.title,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                    letterSpacing: -0.1,
                  ),
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
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'What this tests',
            style: TextStyle(
              color: _muted,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            interpretation.whatThisTests,
            style: const TextStyle(
              color: _ink,
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Doctor interpretation',
            style: TextStyle(
              color: _muted,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            interpretation.doctorInterpretation,
            style: const TextStyle(
              color: _ink,
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

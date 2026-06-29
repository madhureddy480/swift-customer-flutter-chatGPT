import 'package:dr_swift_diagnostics/core/widgets/ds_glass_card.dart';
import 'package:dr_swift_diagnostics/features/reports/data/models/report_models.dart';
import 'package:flutter/material.dart';

const _ink = Color(0xFF1A1C1E);
const _muted = Color(0xFF667085);

class ReportsResultsTable extends StatelessWidget {
  const ReportsResultsTable({required this.rows, super.key});

  final List<ReportResultRow> rows;

  @override
  Widget build(BuildContext context) {
    return DsGlassCard(
      borderRadius: 16,
      child: Column(
        children: [
          const _ResultsTableHeader(),
          for (var i = 0; i < rows.length; i++)
            _ResultsTableRow(
              row: rows[i],
              showDivider: i < rows.length - 1,
            ),
        ],
      ),
    );
  }
}

class _ResultsTableHeader extends StatelessWidget {
  const _ResultsTableHeader();

  @override
  Widget build(BuildContext context) {
    return DsGlassCardHeader(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: const Row(
          children: [
            Expanded(
              flex: 5,
              child: Text(
                'Test',
                style: TextStyle(
                  color: _muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                'Current',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: _muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                'Past',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: _muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultsTableRow extends StatelessWidget {
  const _ResultsTableRow({
    required this.row,
    required this.showDivider,
  });

  final ReportResultRow row;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  row.testName,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  _formatValue(row.currentValue, row.unit),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: row.flag.valueColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  _formatValue(row.pastValue, row.unit),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const DsGlassDivider(),
      ],
    );
  }

  String _formatValue(String value, String? unit) {
    if (unit == null || unit.isEmpty) return value;
    return '$value $unit';
  }
}

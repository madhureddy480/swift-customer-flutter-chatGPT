import 'dart:math' as math;

import 'package:dr_swift_diagnostics/core/widgets/ds_glass_card.dart';
import 'package:dr_swift_diagnostics/features/reports/data/models/report_models.dart';
import 'package:flutter/material.dart';

const _ink = Color(0xFF1A1C1E);
const _muted = Color(0xFF667085);
const _rowPadding = 12.0;
const _testNameMinWidth = 120.0;
const _valueColumnWidth = 64.0;

double get _minTableWidth =>
    _rowPadding * 2 + _testNameMinWidth + _valueColumnWidth * 3;

class ReportsResultsTable extends StatelessWidget {
  const ReportsResultsTable({required this.rows, super.key});

  final List<ReportResultRow> rows;

  @override
  Widget build(BuildContext context) {
    return DsGlassCard(
      borderRadius: 16,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableWidth = math.max(constraints.maxWidth, _minTableWidth);

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
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
            ),
          );
        },
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
        padding: const EdgeInsets.symmetric(
          horizontal: _rowPadding,
          vertical: 9,
        ),
        child: Row(
          children: const [
            Expanded(
              child: Text(
                'Test Name',
                style: TextStyle(
                  color: _muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            _ValueHeaderCell(label: 'Current'),
            _ValueHeaderCell(label: 'Past 1'),
            _ValueHeaderCell(label: 'Past 2'),
          ],
        ),
      ),
    );
  }
}

class _ValueHeaderCell extends StatelessWidget {
  const _ValueHeaderCell({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _valueColumnWidth,
      child: Text(
        label,
        textAlign: TextAlign.right,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: _muted,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
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
          padding: const EdgeInsets.symmetric(
            horizontal: _rowPadding,
            vertical: 8,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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
              _ValueCell(
                value: row.currentValue,
                color: row.flag.valueColor,
                bold: true,
              ),
              _ValueCell(value: row.past1Value),
              _ValueCell(value: row.past2Value),
            ],
          ),
        ),
        if (showDivider) const DsGlassDivider(),
      ],
    );
  }
}

class _ValueCell extends StatelessWidget {
  const _ValueCell({
    required this.value,
    this.color = _muted,
    this.bold = false,
  });

  final String value;
  final Color color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _valueColumnWidth,
      child: Text(
        value,
        textAlign: TextAlign.right,
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
          height: 1.25,
        ),
      ),
    );
  }
}

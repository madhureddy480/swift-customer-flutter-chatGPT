import 'dart:math' as math;

import 'package:dr_swift_diagnostics/core/widgets/ds_category_style_list.dart';
import 'package:dr_swift_diagnostics/features/reports/data/models/report_models.dart';
import 'package:flutter/material.dart';

const _valueColumnWidth = 64.0;
const _testNameMinWidth = 120.0;

double get _minTableWidth =>
    DsCategoryStyleListMetrics.horizontalPadding * 2 +
    _testNameMinWidth +
    _valueColumnWidth * 3;

/// Tabular results grid using the category-style list shell and row metrics.
class ReportsResultsTable extends StatelessWidget {
  const ReportsResultsTable({required this.rows, super.key});

  final List<ReportResultRow> rows;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tableWidth = math.max(constraints.maxWidth, _minTableWidth);

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: tableWidth,
            child: DsCategoryStyleList(
              dividerIndent: 0,
              children: [
                const _ResultsTableHeader(),
                for (final row in rows) _ResultsTableRow(row: row),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ResultsTableHeader extends StatelessWidget {
  const _ResultsTableHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DsCategoryStyleListMetrics.horizontalPadding,
        vertical: DsCategoryStyleListMetrics.verticalPadding,
      ),
      child: Row(
        children: const [
          Expanded(
            child: Text(
              'Test Name',
              style: TextStyle(
                color: DsCategoryStyleListTypography.metaColor,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
                height: 1.15,
              ),
            ),
          ),
          _ValueHeaderCell(label: 'Current'),
          _ValueHeaderCell(label: 'Past 1'),
          _ValueHeaderCell(label: 'Past 2'),
        ],
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
          color: DsCategoryStyleListTypography.metaColor,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
          height: 1.15,
        ),
      ),
    );
  }
}

class _ResultsTableRow extends StatelessWidget {
  const _ResultsTableRow({required this.row});

  final ReportResultRow row;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DsCategoryStyleListMetrics.horizontalPadding,
        vertical: DsCategoryStyleListMetrics.verticalPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              row.testName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: DsCategoryStyleListTypography.title,
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
    );
  }
}

class _ValueCell extends StatelessWidget {
  const _ValueCell({
    required this.value,
    this.color = DsCategoryStyleListTypography.metaColor,
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
        style: (bold
                ? DsCategoryStyleListTypography.trailingValue
                : DsCategoryStyleListTypography.trailingMeta)
            .copyWith(
          color: color,
          fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
        ),
      ),
    );
  }
}

import 'package:dr_swift_diagnostics/features/reports/data/models/report_models.dart';
import 'package:dr_swift_diagnostics/features/reports/presentation/widgets/reports_download_report_link.dart';
import 'package:dr_swift_diagnostics/features/reports/presentation/widgets/reports_health_indicators_section.dart';
import 'package:dr_swift_diagnostics/features/reports/presentation/widgets/reports_heart_health_trend_chart.dart';
import 'package:dr_swift_diagnostics/features/reports/presentation/widgets/reports_interpretations_section.dart';
import 'package:dr_swift_diagnostics/features/reports/presentation/widgets/reports_results_table.dart';
import 'package:dr_swift_diagnostics/features/reports/presentation/widgets/reports_section_header.dart';
import 'package:flutter/material.dart';

/// All report sections for a single test date.
class ReportsDatedReportBody extends StatelessWidget {
  const ReportsDatedReportBody({required this.report, super.key});

  final GuestDatedReport report;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ReportsDownloadReportLink(),
        const SizedBox(height: 12),
        const ReportsSectionHeader(title: 'Results'),
        const SizedBox(height: 8),
        ReportsResultsTable(rows: report.results),
        const SizedBox(height: 16),
        ReportsSectionHeader(
          title: 'Trends',
          subtitle:
              '${report.heartHealthTrend.title} · ${report.heartHealthTrend.subtitle}',
        ),
        const SizedBox(height: 10),
        ReportsHeartHealthTrendChart(trend: report.heartHealthTrend),
        const SizedBox(height: 16),
        const ReportsSectionHeader(title: 'Health Indicators (as of Today)'),
        const SizedBox(height: 8),
        ReportsHealthIndicatorsSection(indicators: report.healthIndicators),
        const SizedBox(height: 16),
        const ReportsSectionHeader(title: 'Interpretations'),
        const SizedBox(height: 8),
        ReportsInterpretationsSection(interpretations: report.interpretations),
      ],
    );
  }
}

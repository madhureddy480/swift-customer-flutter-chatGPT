import 'package:dr_swift_diagnostics/features/reports/data/report_date_formatter.dart';
import 'package:flutter/material.dart';

enum ReportResultFlag {
  healthy,
  borderline,
  veryHigh,
  low;

  Color get valueColor => switch (this) {
        ReportResultFlag.healthy => const Color(0xFF2E9E5B),
        ReportResultFlag.borderline => const Color(0xFFE8940A),
        ReportResultFlag.veryHigh => const Color(0xFFD64545),
        ReportResultFlag.low => const Color(0xFFD64545),
      };
}

class ReportResultRow {
  const ReportResultRow({
    required this.testName,
    required this.currentValue,
    required this.past1Value,
    required this.past2Value,
    required this.flag,
  });

  final String testName;
  final String currentValue;
  final String past1Value;
  final String past2Value;
  final ReportResultFlag flag;
}

class ReportHealthIndicator {
  const ReportHealthIndicator({
    required this.condition,
    required this.symptoms,
    required this.labResult,
  });

  final String condition;
  final String symptoms;
  final String labResult;
}

class ReportInterpretation {
  const ReportInterpretation({
    required this.title,
    required this.flagLabel,
    required this.flag,
    required this.whatThisTests,
    required this.doctorInterpretation,
  });

  final String title;
  final String flagLabel;
  final ReportResultFlag flag;
  final String whatThisTests;
  final String doctorInterpretation;
}

class ReportHeartHealthTrend {
  const ReportHeartHealthTrend({
    required this.title,
    required this.subtitle,
    required this.labelDaysAgo,
    required this.values,
    required this.unit,
  });

  final String title;
  final String subtitle;
  final List<int> labelDaysAgo;
  final List<double> values;
  final String unit;

  List<String> get axisLabels => labelDaysAgo
      .map((days) => formatTrendAxisLabelFromDaysAgo(days))
      .toList();
}

/// One lab report snapshot for a specific test date.
class GuestDatedReport {
  const GuestDatedReport({
    required this.daysAgo,
    required this.results,
    required this.heartHealthTrend,
    required this.healthIndicators,
    required this.interpretations,
  });

  /// Whole days before today (1 = yesterday).
  final int daysAgo;
  final List<ReportResultRow> results;
  final ReportHeartHealthTrend heartHealthTrend;
  final List<ReportHealthIndicator> healthIndicators;
  final List<ReportInterpretation> interpretations;

  String get testDateLabel => formatTestDateFromDaysAgo(daysAgo);
}

/// Full guest report bundle for one family member across test dates.
class GuestFamilyMemberReport {
  const GuestFamilyMemberReport({
    required this.memberName,
    required this.datedReports,
  });

  final String memberName;
  final List<GuestDatedReport> datedReports;

  /// Most recent report first.
  GuestDatedReport get latestReport => datedReports.first;
}

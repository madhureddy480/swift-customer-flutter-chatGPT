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
    required this.pastValue,
    required this.flag,
    this.unit,
  });

  final String testName;
  final String currentValue;
  final String pastValue;
  final ReportResultFlag flag;
  final String? unit;
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
    required this.labels,
    required this.values,
    required this.unit,
  });

  final String title;
  final String subtitle;
  final List<String> labels;
  final List<double> values;
  final String unit;
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

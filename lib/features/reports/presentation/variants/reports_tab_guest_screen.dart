import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_tab_header.dart';
import 'package:dr_swift_diagnostics/features/reports/data/models/report_models.dart';
import 'package:dr_swift_diagnostics/features/reports/data/reports_guest_sample_data.dart';
import 'package:dr_swift_diagnostics/features/reports/presentation/widgets/reports_dated_report_body.dart';
import 'package:dr_swift_diagnostics/features/reports/presentation/widgets/reports_family_member_picker.dart';
import 'package:dr_swift_diagnostics/features/reports/presentation/widgets/reports_guest_sample_report_button.dart';
import 'package:dr_swift_diagnostics/features/reports/presentation/widgets/reports_section_header.dart';
import 'package:dr_swift_diagnostics/features/reports/presentation/widgets/reports_test_date_accordion.dart';
import 'package:flutter/material.dart';

/// G1 — Guest multi-member Reports tab, grouped by test date.
class ReportsTabGuestScreen extends StatefulWidget {
  const ReportsTabGuestScreen({
    this.reports = guestFamilyMemberReports,
    super.key,
  });

  final List<GuestFamilyMemberReport> reports;

  @override
  State<ReportsTabGuestScreen> createState() => _ReportsTabGuestScreenState();
}

class _ReportsTabGuestScreenState extends State<ReportsTabGuestScreen> {
  late int _selectedMemberIndex;
  late Set<int> _expandedDateIndices;

  @override
  void initState() {
    super.initState();
    _selectedMemberIndex = 0;
    _expandedDateIndices = {};
  }

  GuestFamilyMemberReport get _memberReport =>
      widget.reports[_selectedMemberIndex];

  List<String> get _memberNames =>
      widget.reports.map((report) => report.memberName).toList();

  void _onMemberSelected(String name) {
    final index = _memberNames.indexOf(name);
    if (index < 0 || index == _selectedMemberIndex) return;
    setState(() {
      _selectedMemberIndex = index;
      _expandedDateIndices = {};
    });
  }

  void _toggleDateAccordion(int index) {
    setState(() {
      if (_expandedDateIndices.contains(index)) {
        _expandedDateIndices.remove(index);
      } else {
        _expandedDateIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final memberReport = _memberReport;
    final datedReports = memberReport.datedReports;

    return SafeArea(
      bottom: false,
      child: DsTabScrollView(
        key: ValueKey(memberReport.memberName),
        title: 'Reports',
        trailing: ReportsFamilyMemberPicker(
          members: _memberNames,
          selectedMember: memberReport.memberName,
          onSelected: _onMemberSelected,
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageHorizontal,
          AppSpacing.pageTop,
          AppSpacing.pageHorizontal,
          AppSpacing.xl,
        ),
        children: [
          const ReportsSectionHeader(title: 'Sample Test Results'),
          const SizedBox(height: AppSpacing.cardGap),
          for (var i = 0; i < datedReports.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.cardGap),
            ReportsTestDateAccordion(
              testDateLabel: datedReports[i].testDateLabel,
              isExpanded: _expandedDateIndices.contains(i),
              onToggle: () => _toggleDateAccordion(i),
              child: ReportsDatedReportBody(report: datedReports[i]),
            ),
          ],
          const SizedBox(height: AppSpacing.sectionGap),
          const ReportsGuestSampleReportButton(),
        ],
      ),
    );
  }
}

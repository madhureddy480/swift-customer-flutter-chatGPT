import 'package:dr_swift_diagnostics/core/widgets/ds_section_header.dart';
import 'package:flutter/material.dart';

class ReportsSectionHeader extends StatelessWidget {
  const ReportsSectionHeader({
    required this.title,
    super.key,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return DsSectionHeader(title: title, subtitle: subtitle);
  }
}

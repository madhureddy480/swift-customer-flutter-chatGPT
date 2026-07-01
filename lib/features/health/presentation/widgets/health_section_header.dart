import 'package:dr_swift_diagnostics/core/widgets/ds_section_header.dart';
import 'package:flutter/material.dart';

class HealthSectionHeader extends StatelessWidget {
  const HealthSectionHeader({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return DsSectionHeader(title: title);
  }
}

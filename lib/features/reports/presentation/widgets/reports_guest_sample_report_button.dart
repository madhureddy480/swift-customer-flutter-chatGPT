import 'package:dr_swift_diagnostics/core/utils/ds_in_app_browser.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_buttons.dart';
import 'package:dr_swift_diagnostics/features/reports/data/reports_guest_sample_data.dart';
import 'package:flutter/material.dart';

/// Opens the guest sample report PDF in an in-app browser.
Future<void> openGuestSampleReport(BuildContext context) async {
  if (guestSampleReportPdfUrl.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sample report link is not configured yet.'),
      ),
    );
    return;
  }

  final uri = Uri.parse(guestSampleReportPdfUrl);
  final launched = await openDsInAppBrowser(uri);

  if (!launched && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open the sample report.')),
    );
  }
}

class ReportsGuestSampleReportButton extends StatelessWidget {
  const ReportsGuestSampleReportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: DsPrimaryButton(
        label: 'View sample report',
        icon: Icons.picture_as_pdf_outlined,
        onPressed: () => openGuestSampleReport(context),
      ),
    );
  }
}

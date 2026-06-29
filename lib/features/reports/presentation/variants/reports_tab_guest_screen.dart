import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_buttons.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

///  G1 — Guest multi-user Reports tab — sample report grid matching `ui_ux.png` screen 3.
class ReportsTabGuestScreen extends StatelessWidget {
  const ReportsTabGuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _ReportsHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                children: [
                  GridView.builder(
                    itemCount: _sampleBiomarkers.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.82,
                    ),
                    itemBuilder: (context, index) {
                      return _ReportResultCard(
                        biomarker: _sampleBiomarkers[index],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: DsPrimaryButton(
                      label: 'View Full Sample Report',
                      onPressed: () => context.push(RoutePaths.login),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportsHeader extends StatelessWidget {
  const _ReportsHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'Sample Report',
            style: TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: _muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportResultCard extends StatelessWidget {
  const _ReportResultCard({required this.biomarker});

  final _ReportBiomarker biomarker;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E6EE)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF101828).withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            biomarker.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _ink,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            biomarker.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _muted,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _ValueText(
                  value: biomarker.value,
                  unit: biomarker.unit,
                  color: biomarker.valueColor,
                ),
              ),
              Icon(
                biomarker.trendUp
                    ? Icons.north_east_rounded
                    : Icons.south_east_rounded,
                color: biomarker.trendColor,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            biomarker.statusLabel,
            style: TextStyle(
              color: biomarker.statusColor,
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ref: ${biomarker.reference}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _muted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueText extends StatelessWidget {
  const _ValueText({
    required this.value,
    required this.unit,
    required this.color,
  });

  final String value;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              color: color,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
              height: 1,
            ),
          ),
          if (unit.isNotEmpty)
            TextSpan(
              text: ' $unit',
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _ReportBiomarker {
  const _ReportBiomarker({
    required this.name,
    required this.subtitle,
    required this.value,
    required this.unit,
    required this.statusLabel,
    required this.statusColor,
    required this.valueColor,
    required this.reference,
    required this.trendUp,
    required this.trendColor,
  });

  final String name;
  final String subtitle;
  final String value;
  final String unit;
  final String statusLabel;
  final Color statusColor;
  final Color valueColor;
  final String reference;
  final bool trendUp;
  final Color trendColor;
}

const _ink = Color(0xFF1A1C1E);
const _muted = Color(0xFF667085);

const _sampleBiomarkers = [
  _ReportBiomarker(
    name: 'HbA1c',
    subtitle: 'Glycated Hemoglobin',
    value: '6.8',
    unit: '%',
    statusLabel: 'Improved',
    statusColor: AppColors.success,
    valueColor: AppColors.success,
    reference: '< 5.7',
    trendUp: false,
    trendColor: AppColors.success,
  ),
  _ReportBiomarker(
    name: 'Vitamin D',
    subtitle: '25-Hydroxy Vitamin D',
    value: '18',
    unit: 'ng/mL',
    statusLabel: 'Low',
    statusColor: AppColors.error,
    valueColor: AppColors.error,
    reference: '30 – 100',
    trendUp: false,
    trendColor: AppColors.error,
  ),
  _ReportBiomarker(
    name: 'Cholesterol',
    subtitle: 'Total Cholesterol',
    value: '210',
    unit: 'mg/dL',
    statusLabel: 'Borderline High',
    statusColor: AppColors.warning,
    valueColor: AppColors.warning,
    reference: '< 200',
    trendUp: true,
    trendColor: AppColors.warning,
  ),
  _ReportBiomarker(
    name: 'TSH',
    subtitle: 'Thyroid Stimulating Hormone',
    value: '2.9',
    unit: 'uIU/mL',
    statusLabel: 'Normal',
    statusColor: AppColors.success,
    valueColor: _ink,
    reference: '0.4 – 4.0',
    trendUp: true,
    trendColor: AppColors.success,
  ),
];

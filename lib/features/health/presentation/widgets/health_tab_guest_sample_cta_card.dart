import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_buttons.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_glass_card.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _ink = Color(0xFF1A1C1E);
const _muted = Color(0xFF667085);

/// G1 bottom CTA — sample context + encourage free account signup.
class HealthTabGuestSampleCtaCard extends StatelessWidget {
  const HealthTabGuestSampleCtaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DsGlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
                child: const Icon(
                  Icons.family_restroom_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Previewing a sample family',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'These trends are demo data for My Health, Mom & Dad. '
                      'Create your free account to track your family\'s real '
                      'results over time.',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: DsPrimaryButton(
              label: 'Create free account',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => context.push(RoutePaths.login),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_buttons.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_scaffold.dart';
import 'package:dr_swift_diagnostics/features/checkout/presentation/providers/checkout_controller.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

const _ink = Color(0xFF1A1C1E);

class OrderConfirmationScreen extends ConsumerWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(checkoutControllerProvider).placedOrder;

    if (order == null) {
      return DsScaffold(
        body: Center(
          child: DsPrimaryButton(
            label: 'Back to Tests',
            onPressed: () => context.go(RoutePaths.tests),
          ),
        ),
      );
    }

    final dateFormat = DateFormat('EEE, d MMM yyyy • hh:mm a');

    return DsScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: Color(0xFF13A86B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 52),
              ),
              const SizedBox(height: 24),
              const Text(
                'Order Successfully Placed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _ink,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),
              _InfoRow(label: 'Order ID', value: order.orderId),
              _InfoRow(
                label: 'Booking date',
                value: dateFormat.format(order.bookedAt),
              ),
              _InfoRow(
                label: 'Collection address',
                value: order.collectionAddress,
              ),
              _InfoRow(
                label: 'Estimated collection',
                value: order.collectionTimeSlot,
              ),
              _InfoRow(
                label: 'Amount paid',
                value: '₹${order.totalRupees}',
                bold: true,
              ),
              const Spacer(),
              DsOutlineButton(
                label: 'Continue Shopping',
                onPressed: () {
                  ref.read(checkoutControllerProvider.notifier).reset();
                  context.go(RoutePaths.tests);
                },
              ),
              const SizedBox(height: 10),
              DsPrimaryButton(
                label: 'View Orders',
                onPressed: () {
                  ref.read(checkoutControllerProvider.notifier).reset();
                  context.go(RoutePaths.reports);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF667085)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: bold ? AppColors.primaryVibrant : _ink,
                fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

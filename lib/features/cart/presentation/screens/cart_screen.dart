import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_buttons.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_scaffold.dart';
import 'package:dr_swift_diagnostics/features/authentication/presentation/providers/auth_state_provider.dart';
import 'package:dr_swift_diagnostics/features/cart/domain/cart_models.dart';
import 'package:dr_swift_diagnostics/features/cart/presentation/providers/cart_providers.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const _screenBg = Color(0xFFF4F7FA);
const _ink = Color(0xFF1A1C1E);
const _muted = Color(0xFF667085);

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartControllerProvider);

    return DsScaffold(
      safeArea: false,
      body: ColoredBox(
        color: _screenBg,
        child: SafeArea(
          child: Column(
            children: [
              _CartHeader(onBack: () => context.pop()),
              Expanded(
                child: cart.isLoading && cart.items.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : cart.isEmpty
                        ? const _EmptyCartView()
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            itemCount: cart.items.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final item = cart.items[index];
                              return _CartLineCard(item: item);
                            },
                          ),
              ),
              if (cart.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    cart.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (!cart.isEmpty) _CartSummaryBar(cart: cart),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartHeader extends StatelessWidget {
  const _CartHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 8, 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'Your Cart',
            style: TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 56,
              color: AppColors.textTertiary.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                color: _ink,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Browse tests and health profiles to build your booking.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 24),
            DsOutlineButton(
              label: 'Continue Shopping',
              onPressed: () => context.go(RoutePaths.tests),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartLineCard extends ConsumerWidget {
  const _CartLineCard({required this.item});

  final CartLineItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(cartControllerProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E6EE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: const TextStyle(color: _muted, fontSize: 11.5),
                ),
                const SizedBox(height: 10),
                Text(
                  item.formattedLineTotal,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          if (item.allowsQuantity) ...[
            _QtyControl(
              quantity: item.quantity,
              onDecrement: () =>
                  controller.updateQuantity(item.id, item.quantity - 1),
              onIncrement: () =>
                  controller.updateQuantity(item.id, item.quantity + 1),
            ),
            const SizedBox(width: 8),
          ],
          IconButton(
            onPressed: () async {
              final remove = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Remove item?'),
                  content: Text('${item.name} will be removed from your cart.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Remove'),
                    ),
                  ],
                ),
              );
              if (remove != true) return;
              await controller.removeItem(item.id);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.name} removed from cart'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.delete_outline_rounded, color: _muted),
          ),
        ],
      ),
    );
  }
}

class _QtyControl extends StatelessWidget {
  const _QtyControl({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E6EE)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _QtyButton(icon: Icons.remove, onTap: onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$quantity',
              style: const TextStyle(
                color: _ink,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _QtyButton(icon: Icons.add, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 16, color: AppColors.primaryVibrant),
      ),
    );
  }
}

class _CartSummaryBar extends ConsumerWidget {
  const _CartSummaryBar({required this.cart});

  final CartState cart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canCheckout = ref.watch(canCheckoutProvider);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        children: [
          if (cart.discountRupees > 0)
            _SummaryRow(
              label: 'You save',
              value: '₹${cart.discountRupees}',
              valueColor: AppColors.success,
            ),
          _SummaryRow(
            label: 'Total',
            value: '₹${cart.totalRupees}',
            bold: true,
          ),
          const SizedBox(height: 12),
          DsOutlineButton(
            label: 'Continue Shopping',
            onPressed: () => context.go(RoutePaths.tests),
          ),
          const SizedBox(height: 10),
          DsPrimaryButton(
            label: 'Proceed to Checkout',
            onPressed: cart.isLoading
                ? null
                : () {
                    if (canCheckout) {
                      context.push(RoutePaths.checkoutFlow);
                    } else {
                      context.push(
                        '${RoutePaths.authPhone}?next=${Uri.encodeComponent(RoutePaths.checkoutFlow)}',
                      );
                    }
                  },
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor = _ink,
  });

  final String label;
  final String value;
  final bool bold;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: bold ? _ink : _muted,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: bold ? 20 : 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/features/cart/presentation/providers/cart_providers.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DsCartAppBarAction extends ConsumerWidget {
  const DsCartAppBarAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(cartItemCountProvider);

    return IconButton(
      tooltip: 'Cart',
      onPressed: () => context.push(RoutePaths.shoppingCart),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        backgroundColor: AppColors.primaryVibrant,
        textColor: Colors.white,
        child: const Icon(Icons.shopping_cart_outlined),
      ),
    );
  }
}

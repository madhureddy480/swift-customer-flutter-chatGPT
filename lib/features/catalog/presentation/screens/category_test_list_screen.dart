import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_cart_app_bar_action.dart';
import 'package:dr_swift_diagnostics/features/cart/domain/cart_models.dart';
import 'package:dr_swift_diagnostics/features/cart/presentation/providers/cart_providers.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/catalog_view_models.dart';
import 'package:dr_swift_diagnostics/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategoryTestListScreen extends ConsumerWidget {
  const CategoryTestListScreen({required this.category, super.key});

  final HealthCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 62,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go(RoutePaths.categories),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
        ),
        title: Column(
          children: [
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF071B3A),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${category.testCount} Tests',
              style: const TextStyle(
                color: Color(0xFF667085),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: const [DsCartAppBarAction()],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: AppColors.divider, height: 1),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 12),
          itemCount: category.tests.length,
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            indent: 16,
            color: Color(0xFFE8E8EF),
          ),
          itemBuilder: (context, index) {
            final test = category.tests[index];
            final itemId = CartLineItem.testId(test.id);
            final isAdded = ref.watch(cartIsInCartProvider(itemId));

            return TestListTile(
              test: test,
              isAdded: isAdded,
              onTap: () => context.push('/tests/${test.id}'),
              onAdd: () async {
                if (isAdded) {
                  await context.push(RoutePaths.shoppingCart);
                  return;
                }
                await ref.read(cartControllerProvider.notifier).addTest(test);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${test.name} added to cart'),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/catalog_view_models.dart';
import 'package:dr_swift_diagnostics/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({required this.categories, super.key});

  final List<HealthCategory> categories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(RoutePaths.tests),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
        ),
        title: const Text(
          'All Categories',
          style: TextStyle(
            color: Color(0xFF071B3A),
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: AppColors.divider, height: 1),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 12),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            indent: 64,
            color: Color(0xFFE8E8EF),
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryListTile(
              category: category,
              onTap: () => context.push('/categories/${category.id}'),
            );
          },
        ),
      ),
    );
  }
}

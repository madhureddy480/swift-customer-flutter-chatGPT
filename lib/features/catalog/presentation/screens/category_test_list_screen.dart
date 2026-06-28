import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/mock_health_data.dart';
import 'package:dr_swift_diagnostics/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryTestListScreen extends StatefulWidget {
  const CategoryTestListScreen({required this.category, super.key});

  final HealthCategory category;

  @override
  State<CategoryTestListScreen> createState() => _CategoryTestListScreenState();
}

class _CategoryTestListScreenState extends State<CategoryTestListScreen> {
  final Set<String> _addedTests = {};

  void _toggleAdded(String id) {
    setState(() {
      if (!_addedTests.add(id)) _addedTests.remove(id);
    });
  }

  @override
  Widget build(BuildContext context) {
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
              widget.category.name,
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
              '${widget.category.testCount} Tests',
              style: const TextStyle(
                color: Color(0xFF667085),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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
          itemCount: widget.category.tests.length,
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            indent: 16,
            color: Color(0xFFE8E8EF),
          ),
          itemBuilder: (context, index) {
            final test = widget.category.tests[index];
            return TestListTile(
              test: test,
              isAdded: _addedTests.contains(test.id),
              onTap: () => context.push('/tests/${test.id}'),
              onAdd: () => _toggleAdded(test.id),
            );
          },
        ),
      ),
    );
  }
}

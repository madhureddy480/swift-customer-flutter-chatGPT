import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/catalog_view_models.dart';
import 'package:dr_swift_diagnostics/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TestDetailScreen extends StatelessWidget {
  const TestDetailScreen({required this.test, super.key});

  final HealthTest test;

  @override
  Widget build(BuildContext context) {
    return TestDetailModal(test: test);
  }
}

class TestDetailModal extends StatefulWidget {
  const TestDetailModal({required this.test, super.key});

  final HealthTest test;

  @override
  State<TestDetailModal> createState() => _TestDetailModalState();
}

class _TestDetailModalState extends State<TestDetailModal> {
  bool _isAdded = false;

  @override
  Widget build(BuildContext context) {
    final test = widget.test;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              height: 48,
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.divider)),
              ),
              alignment: Alignment.centerLeft,
              child: IconButton(
                tooltip: 'Close',
                onPressed: () => context.canPop()
                    ? context.pop()
                    : context.go(RoutePaths.tests),
                icon: const Icon(Icons.close_rounded, size: 22),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                test.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF071B3A),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                test.subtitle,
                                style: const TextStyle(
                                  color: Color(0xFF667085),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          test.formattedPrice,
                          style: const TextStyle(
                            color: Color(0xFF071B3A),
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final tag in test.tags) TagChip(label: tag),
                      ],
                    ),
                    const SizedBox(height: 18),
                    InfoSection(title: 'What is it?', body: test.whatIsIt),
                    const SizedBox(height: 16),
                    InfoSection(
                      title: 'Why take this test?',
                      body: test.whyTakeThisTest,
                    ),
                    const SizedBox(height: 17),
                    const Text(
                      'Reference Range',
                      style: TextStyle(
                        color: Color(0xFF071B3A),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        for (var index = 0;
                            index < test.referenceRanges.length;
                            index++) ...[
                          Expanded(
                            child: ReferenceRangeChip(
                              range: test.referenceRanges[index],
                            ),
                          ),
                          if (index < test.referenceRanges.length - 1)
                            const SizedBox(width: 5),
                        ],
                      ],
                    ),
                    const SizedBox(height: 17),
                    InfoSection(
                      title: 'Preparation',
                      body: test.preparation,
                    ),
                    const SizedBox(height: 17),
                    const Text(
                      'Often Booked With',
                      style: TextStyle(
                        color: Color(0xFF071B3A),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final item in test.oftenBookedWith)
                          OftenBookedChip(label: item),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppColors.divider)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => setState(() => _isAdded = !_isAdded),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.zero,
                      backgroundColor: AppColors.primaryVibrant,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: Text(
                      _isAdded
                          ? 'Added to cart'
                          : 'Add Test  •  ${test.formattedPrice}',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:dr_swift_diagnostics/core/constants/asset_paths.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_glass_card.dart';
import 'package:flutter/material.dart';

/// Health tab care carousel using native 350x110 promotional artwork.
class HealthCareCarousel extends StatefulWidget {
  const HealthCareCarousel({super.key});

  static const double carouselWidth = 350;
  static const double carouselHeight = 110;

  @override
  State<HealthCareCarousel> createState() => _HealthCareCarouselState();
}

class _HealthCareCarouselState extends State<HealthCareCarousel> {
  static const _slides = AssetPaths.healthCarouselSlides;

  late final PageController _pageController;
  Timer? _autoPlayTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final next = (_currentPage + 1) % _slides.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: HealthCareCarousel.carouselWidth,
            height: HealthCareCarousel.carouselHeight,
            child: DsGlassCard(
              borderRadius: AppSpacing.tabCardRadius,
              blurSigma: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.tabCardRadius),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    return Image.asset(
                      _slides[index],
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (_, __, ___) => ColoredBox(
                        color: const Color(0xFFF4F0FA),
                        child: Center(
                          child: Icon(
                            Icons.image_outlined,
                            color: const Color(
                              0xFF583A8E,
                            ).withValues(alpha: 0.35),
                            size: 28,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_slides.length, (index) {
              final active = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 14 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFF583A8E)
                      : const Color(0xFFD0D5DD),
                  borderRadius: BorderRadius.circular(99),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

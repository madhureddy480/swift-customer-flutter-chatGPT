import 'dart:async';

import 'package:dr_swift_diagnostics/core/constants/asset_paths.dart';
import 'package:flutter/material.dart';

/// Warm care carousel for the Health tab — 350×80 with left-aligned overlay copy.
class HealthCareCarousel extends StatefulWidget {
  const HealthCareCarousel({super.key});

  static const double carouselWidth = 350;
  static const double carouselHeight = 110;
  static const double textAreaFraction = 0.6;

  @override
  State<HealthCareCarousel> createState() => _HealthCareCarouselState();
}

class _HealthCareCarouselState extends State<HealthCareCarousel> {
  static const _slides = [
    _CareCarouselSlide(
      imagePath: AssetPaths.healthCarousel1,
      headline: 'Your health,',
      subline: 'tracked with care',
    ),
    _CareCarouselSlide(
      imagePath: AssetPaths.healthCarousel2,
      headline: 'Her wellness,',
      subline: 'nourished daily',
    ),
    _CareCarouselSlide(
      imagePath: AssetPaths.healthCarousel3,
      headline: "Parents' trends,",
      subline: 'gentle & steady',
    ),
  ];

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
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E6EE)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF101828).withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    return _CareCarouselCard(
                      slide: _slides[index],
                      width: HealthCareCarousel.carouselWidth,
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

class _CareCarouselCard extends StatelessWidget {
  const _CareCarouselCard({
    required this.slide,
    required this.width,
  });

  final _CareCarouselSlide slide;
  final double width;

  @override
  Widget build(BuildContext context) {
    final textWidth = width * HealthCareCarousel.textAreaFraction;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          slide.imagePath,
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
          errorBuilder: (_, __, ___) => ColoredBox(
            color: const Color(0xFFF4F0FA),
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.image_outlined,
                color: const Color(0xFF583A8E).withValues(alpha: 0.35),
                size: 28,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: textWidth,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.white.withValues(alpha: 0.72),
                  Colors.white.withValues(alpha: 0.45),
                  Colors.white.withValues(alpha: 0),
                ],
                stops: const [0, 0.65, 1],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    slide.headline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                      letterSpacing: -0.2,
                    ),
                  ),
                  Text(
                    slide.subline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CareCarouselSlide {
  const _CareCarouselSlide({
    required this.imagePath,
    required this.headline,
    required this.subline,
  });

  final String imagePath;
  final String headline;
  final String subline;
}

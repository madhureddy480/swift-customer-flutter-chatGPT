import 'dart:async';
import 'dart:math' as math;

import 'package:dr_swift_diagnostics/core/constants/asset_paths.dart';
import 'package:dr_swift_diagnostics/features/onboarding/data/onboarding_repository.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Splash screen matching the compact portrait brand reference.
///
/// Shows the opening brand slide before continuing to the splash carousel.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _nextSlideTimer;
  late final Future<bool> _onboardingCompleteFuture;

  static const _features = <(IconData, String)>[
    (Icons.medical_services_outlined, 'At-home collection'),
    (Icons.water_drop_outlined, 'Same-day reports'),
    (Icons.qr_code_2_rounded, '200+ tests & health profiles'),
    (Icons.groups_2_outlined, 'One account for the whole family'),
    (Icons.trending_up_rounded, 'Historical graphs and insights'),
  ];

  @override
  void initState() {
    super.initState();
    _onboardingCompleteFuture =
        ref.read(onboardingRepositoryProvider).isComplete();
    _nextSlideTimer = Timer(const Duration(seconds: 5), () {
      unawaited(_onSplashComplete());
    });
  }

  Future<void> _onSplashComplete() async {
    if (!mounted) return;

    final complete = await _onboardingCompleteFuture;

    if (!mounted) return;
    context.go(
      complete ? RoutePaths.tests : '${RoutePaths.onboarding}?page=1',
    );
  }

  @override
  void dispose() {
    _nextSlideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF03001D),
              Color(0xFF10002F),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scale = math.min(
                constraints.maxWidth / 248,
                constraints.maxHeight / 500,
              );

              return Align(
                child: Transform.scale(
                  scale: scale,
                  child: const SizedBox(
                    width: 248,
                    height: 500,
                    child: Column(
                      children: [
                        Expanded(child: _BrandHeader()),
                        Expanded(
                          child: _FeaturesPanel(features: _features),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AssetPaths.logo,
            width: 110,
            height: 110,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            isAntiAlias: true,
          ),
          const SizedBox(height: 2),
          const Text(
            'Dr Swift',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              height: 1.05,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'DIAGNOSTICS',
            style: TextStyle(
              color: Color(0xFFE7E6ED),
              fontSize: 12,
              height: 1.1,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 17),
          const _BrandTagline(),
        ],
      ),
    );
  }
}

class _BrandTagline extends StatelessWidget {
  const _BrandTagline();

  static const _style = TextStyle(
    fontSize: 17,
    height: 1.18,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.45,
  );

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            style: _style,
            children: [
              TextSpan(
                text: 'See ',
                style: TextStyle(color: Color(0xFFFF5842)),
              ),
              TextSpan(
                text: 'More ',
                style: TextStyle(color: Color(0xFFFF9828)),
              ),
              TextSpan(
                text: 'Than ',
                style: TextStyle(color: Color(0xFFFFD326)),
              ),
              TextSpan(
                text: 'Numbers,',
                style: TextStyle(color: Color(0xFF47C98A)),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        Text.rich(
          TextSpan(
            style: _style,
            children: [
              TextSpan(
                text: 'See ',
                style: TextStyle(color: Color(0xFFFF8E28)),
              ),
              TextSpan(
                text: 'Your ',
                style: TextStyle(color: Color(0xFFFFC927)),
              ),
              TextSpan(
                text: 'Health.',
                style: TextStyle(color: Color(0xFF59CA78)),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FeaturesPanel extends StatelessWidget {
  const _FeaturesPanel({required this.features});

  final List<(IconData, String)> features;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 12),
          for (final feature in features)
            _FeatureRow(icon: feature.$1, label: feature.$2),
          const Spacer(),
          const _PageIndicator(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 29,
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Icon(
              icon,
              size: 17,
              color: const Color(0xFFE3E1EB),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.visible,
              style: const TextStyle(
                color: Color(0xFFF2F0F6),
                fontSize: 11.5,
                height: 1.1,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dot(isActive: true),
        const SizedBox(width: 12),
        _dot(),
        const SizedBox(width: 12),
        _dot(),
      ],
    );
  }

  Widget _dot({bool isActive = false}) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? Colors.white : const Color(0xFF8D879C),
          width: 1.4,
        ),
      ),
    );
  }
}

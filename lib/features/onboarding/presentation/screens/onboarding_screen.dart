import 'package:dr_swift_diagnostics/core/constants/asset_paths.dart';
import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_asset_image.dart';
import 'package:dr_swift_diagnostics/features/onboarding/data/onboarding_repository.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  Future<void> _complete() async {
    await ref.read(onboardingRepositoryProvider).markComplete();
    if (!mounted) return;
    context.go(RoutePaths.tests);
  }

  void _handleTap() {
    if (_currentPage == 2) {
      _complete();
      return;
    }

    _controller.nextPage(
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _OnboardingColors.bg,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handleTap,
        child: Stack(
          children: [
            const _DarkBackground(),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _controller,
                      onPageChanged: (page) {
                        setState(() => _currentPage = page);
                      },
                      children: const [
                        _SplashCarouselPage(),
                        _HistoryCarouselPage(),
                        _ValueCarouselPage(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 58),
                    child: _PageDots(currentPage: _currentPage),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

abstract final class _OnboardingColors {
  static const bg = Color(0xFF03031F);
  static const bgDeep = Color(0xFF010019);
  static const card = Color(0xFFFDFDFF);
  static const ink = Color(0xFF151727);
}

class _DarkBackground extends StatelessWidget {
  const _DarkBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.2, -0.7),
          radius: 0.95,
          colors: [
            Color(0xFF11114D),
            _OnboardingColors.bg,
            _OnboardingColors.bgDeep,
          ],
          stops: [0, 0.58, 1],
        ),
      ),
      child: SizedBox.expand(),
    );
  }
}

class _SplashCarouselPage extends StatelessWidget {
  const _SplashCarouselPage();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(34, 24, 34, 0),
      child: Column(
        children: [
          SizedBox(height: 20),
          DsLogo(assetPath: AssetPaths.logo, width: 126, height: 138),
          SizedBox(height: 8),
          Text(
            'Dr Swift',
            style: TextStyle(
              color: Colors.white,
              fontSize: 29,
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
          SizedBox(height: 1),
          Text(
            'DIAGNOSTICS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 19),
          _GradientHeadline(
            first: 'See More Than Numbers,',
            second: 'See Your Health.',
            fontSize: 21,
          ),
          SizedBox(height: 28),
          _SplashFeatureRow(
            icon: Icons.home_work_outlined,
            label: 'At-home collection',
          ),
          _SplashFeatureRow(
            icon: Icons.water_drop_outlined,
            label: 'Same-day reports',
          ),
          _SplashFeatureRow(
            icon: Icons.assignment_outlined,
            label: '200+ tests & health profiles',
          ),
          _SplashFeatureRow(
            icon: Icons.family_restroom_outlined,
            label: 'One account for the whole family',
          ),
          _SplashFeatureRow(
            icon: Icons.show_chart,
            label: 'Historical graphs and insights',
          ),
        ],
      ),
    );
  }
}

class _SplashFeatureRow extends StatelessWidget {
  const _SplashFeatureRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 17, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryCarouselPage extends StatelessWidget {
  const _HistoryCarouselPage();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(18, 50, 18, 0),
      child: Column(
        children: [
          _GradientHeadline(
            first: 'See More Than Numbers,',
            second: 'See Your Health.',
            fontSize: 21,
          ),
          SizedBox(height: 28),
          _HistoryTableCard(),
          SizedBox(height: 16),
          _TrendChartCard(),
        ],
      ),
    );
  }
}

class _ValueCarouselPage extends StatelessWidget {
  const _ValueCarouselPage();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(18, 52, 18, 0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _UnderstandTestsCard()),
              SizedBox(width: 12),
              Expanded(child: _HealthProfilesCard()),
            ],
          ),
          SizedBox(height: 13),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _FamilyAccountCard()),
              SizedBox(width: 12),
              Expanded(child: _PocketInsightsCard()),
            ],
          ),
        ],
      ),
    );
  }
}

class _GradientHeadline extends StatelessWidget {
  const _GradientHeadline({
    required this.first,
    required this.second,
    required this.fontSize,
  });

  final String first;
  final String second;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [
            Color(0xFFFF5A2E),
            Color(0xFFFFC400),
            Color(0xFF45D765),
            Color(0xFF10C7FF),
          ],
        ).createShader(bounds);
      },
      child: Text(
        '$first\n$second',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          height: 1.18,
        ),
      ),
    );
  }
}

class _PrototypeCard extends StatelessWidget {
  const _PrototypeCard({
    required this.child,
    this.height,
    this.padding = const EdgeInsets.all(13),
  });

  final Widget child;
  final double? height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: _OnboardingColors.card,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFE3E8F3), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _HistoryTableCard extends StatelessWidget {
  const _HistoryTableCard();

  static const _rows = [
    ['HbA1c (%)', '6.8', '7.2', '7.8'],
    ['Vitamin D (ng/mL)', '18', '22', '15'],
    ['Cholesterol (mg/dL)', '210', '198', '230'],
    ['TSH (uIU/mL)', '2.1', '2.6', '3.1'],
  ];

  @override
  Widget build(BuildContext context) {
    return _PrototypeCard(
      height: 154,
      padding: const EdgeInsets.fromLTRB(13, 12, 13, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Health History (Sample)',
            style: TextStyle(
              color: _OnboardingColors.ink,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(height: 11),
          const _TableHeader(),
          const SizedBox(height: 6),
          ..._rows.map(_HealthHistoryRow.new),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(flex: 43, child: _CellText('Test Name', isHeader: true)),
        Expanded(flex: 19, child: _CellText('Today', isHeader: true)),
        Expanded(flex: 19, child: _CellText('12/2025', isHeader: true)),
        Expanded(flex: 19, child: _CellText('6/2025', isHeader: true)),
      ],
    );
  }
}

class _HealthHistoryRow extends StatelessWidget {
  const _HealthHistoryRow(this.values);

  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(flex: 43, child: _CellText(values[0])),
          Expanded(flex: 19, child: _CellText(values[1])),
          Expanded(flex: 19, child: _CellText(values[2])),
          Expanded(flex: 19, child: _CellText(values[3])),
        ],
      ),
    );
  }
}

class _CellText extends StatelessWidget {
  const _CellText(this.value, {this.isHeader = false});

  final String value;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: _OnboardingColors.ink,
        fontSize: isHeader ? 9 : 9.3,
        fontWeight: isHeader ? FontWeight.w800 : FontWeight.w600,
        height: 1,
      ),
    );
  }
}

class _TrendChartCard extends StatelessWidget {
  const _TrendChartCard();

  @override
  Widget build(BuildContext context) {
    return _PrototypeCard(
      height: 198,
      padding: const EdgeInsets.fromLTRB(13, 12, 13, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trends Over Time',
            style: TextStyle(
              color: _OnboardingColors.ink,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 3,
                minY: 0,
                maxY: 10,
                clipData: const FlClipData.all(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (_) =>
                      const FlLine(color: Color(0xFFECEFF6), strokeWidth: 0.8),
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final labels = ['6/2025', '9/2025', '12/2025', 'Today'];
                        final index = value.round();
                        if (index < 0 || index >= labels.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            labels[index],
                            style: const TextStyle(
                              color: _OnboardingColors.ink,
                              fontSize: 8.4,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: const LineTouchData(enabled: false),
                lineBarsData: [
                  _line(const Color(0xFF1984D8), const [
                    FlSpot(0, 7.2),
                    FlSpot(1, 7.2),
                    FlSpot(2, 6.8),
                    FlSpot(3, 7.4),
                  ]),
                  _line(const Color(0xFFFF8A00), const [
                    FlSpot(0, 5.0),
                    FlSpot(1, 4.0),
                    FlSpot(2, 4.2),
                    FlSpot(3, 4.4),
                  ]),
                  _line(const Color(0xFF83B51D), const [
                    FlSpot(0, 5.4),
                    FlSpot(1, 5.0),
                    FlSpot(2, 5.7),
                    FlSpot(3, 6.0),
                  ]),
                  _line(const Color(0xFF7D37C8), const [
                    FlSpot(0, 3.1),
                    FlSpot(1, 3.0),
                    FlSpot(2, 3.1),
                    FlSpot(3, 3.2),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 7),
          const Wrap(
            spacing: 8,
            runSpacing: 5,
            children: [
              _LegendDot(color: Color(0xFF1984D8), label: 'HbA1c (%)'),
              _LegendDot(color: Color(0xFFFF8A00), label: 'Vitamin D (ng/mL)'),
              _LegendDot(
                color: Color(0xFF83B51D),
                label: 'Cholesterol (mg/dL)',
              ),
              _LegendDot(color: Color(0xFF7D37C8), label: 'TSH (uIU/mL)'),
            ],
          ),
        ],
      ),
    );
  }

  static LineChartBarData _line(Color color, List<FlSpot> spots) {
    return LineChartBarData(
      spots: spots,
      isCurved: false,
      color: color,
      barWidth: 2,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
          radius: 3,
          color: color,
          strokeWidth: 1,
          strokeColor: Colors.white,
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 5,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(
            color: _OnboardingColors.ink,
            fontSize: 8.6,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _UnderstandTestsCard extends StatelessWidget {
  const _UnderstandTestsCard();

  @override
  Widget build(BuildContext context) {
    return const _PrototypeCard(
      height: 190,
      padding: EdgeInsets.fromLTRB(12, 12, 12, 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tests you\ncan understand', style: _cardTitle),
          SizedBox(height: 10),
          _MiniRangeTable(),
          Spacer(),
          Text('Tests you can understand', style: _captionText),
        ],
      ),
    );
  }
}

class _MiniRangeTable extends StatelessWidget {
  const _MiniRangeTable();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _RangeRow('HbA1c', '', ''),
        SizedBox(height: 5),
        _RangeRow('< 5.7', 'Normal', 'green'),
        SizedBox(height: 5),
        _RangeRow('5.7 - 6.4', 'High', 'amber'),
        SizedBox(height: 5),
        _RangeRow('> 6.4', 'High', 'red'),
      ],
    );
  }
}

class _RangeRow extends StatelessWidget {
  const _RangeRow(this.left, this.right, this.tone);

  final String left;
  final String right;
  final String tone;

  @override
  Widget build(BuildContext context) {
    final color = switch (tone) {
      'green' => AppColors.success,
      'amber' => AppColors.warning,
      'red' => AppColors.error,
      _ => _OnboardingColors.ink,
    };

    return Row(
      children: [
        Expanded(
          child: Text(
            left,
            style: const TextStyle(
              color: _OnboardingColors.ink,
              fontSize: 9.6,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
        Text(
          right,
          style: TextStyle(
            color: color,
            fontSize: 9.6,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _HealthProfilesCard extends StatelessWidget {
  const _HealthProfilesCard();

  @override
  Widget build(BuildContext context) {
    return const _PrototypeCard(
      height: 190,
      padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Health\nProfiles', style: _cardTitle),
              SizedBox(height: 17),
              _ProfileLine('Women Health'),
              SizedBox(height: 9),
              _ProfileLine('Men 50+ Health'),
              SizedBox(height: 9),
              _ProfileLine('Diabetes Care'),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 54,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _MiniPerson(color: Color(0xFFEFA2AF), height: 42),
                  _MiniPerson(color: Color(0xFF7293E6), height: 48),
                  _MiniPerson(color: Color(0xFF95D9C9), height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileLine extends StatelessWidget {
  const _ProfileLine(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: _OnboardingColors.ink,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1,
      ),
    );
  }
}

class _FamilyAccountCard extends StatelessWidget {
  const _FamilyAccountCard();

  @override
  Widget build(BuildContext context) {
    return _PrototypeCard(
      height: 212,
      padding: const EdgeInsets.fromLTRB(12, 13, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('One account\nfor the whole\nfamily', style: _cardTitle),
          const Spacer(),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(42),
              bottom: Radius.circular(9),
            ),
            child: Stack(
              children: [
                Container(
                  height: 93,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFFFF5EA), Color(0xFFFFD6C7)],
                    ),
                  ),
                ),
                const Positioned(
                  left: 16,
                  bottom: 0,
                  child: _PortraitPerson(
                    color: Color(0xFF3264B7),
                    skin: Color(0xFF9A5A38),
                    height: 80,
                  ),
                ),
                const Positioned(
                  left: 48,
                  bottom: 0,
                  child: _PortraitPerson(
                    color: Color(0xFFFF7C50),
                    skin: Color(0xFFC37A52),
                    height: 89,
                  ),
                ),
                const Positioned(
                  right: 18,
                  bottom: 0,
                  child: _PortraitPerson(
                    color: Color(0xFF2B87A8),
                    skin: Color(0xFFDAA17F),
                    height: 74,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PocketInsightsCard extends StatelessWidget {
  const _PocketInsightsCard();

  @override
  Widget build(BuildContext context) {
    return _PrototypeCard(
      height: 212,
      padding: const EdgeInsets.fromLTRB(12, 13, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Results &\nInsights in\nyour pocket', style: _cardTitle),
          const Spacer(),
          Center(
            child: SizedBox(
              height: 102,
              width: 90,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                    left: 0,
                    bottom: 3,
                    child: Container(
                      width: 56,
                      height: 82,
                      decoration: BoxDecoration(
                        color: const Color(0xFFBDEBFF),
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: -0.12,
                    child: Container(
                      width: 55,
                      height: 93,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF151B34),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.22),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 5,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 9),
                            const _TinyGraph(color: Color(0xFF1984D8)),
                            const SizedBox(height: 10),
                            const _TinyGraph(color: Color(0xFFFF8A00)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TinyGraph extends StatelessWidget {
  const _TinyGraph({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18,
      child: CustomPaint(
        painter: _TinyGraphPainter(color),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _TinyGraphPainter extends CustomPainter {
  const _TinyGraphPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(1, size.height * 0.7)
      ..lineTo(size.width * 0.28, size.height * 0.35)
      ..lineTo(size.width * 0.52, size.height * 0.56)
      ..lineTo(size.width * 0.78, size.height * 0.25)
      ..lineTo(size.width - 1, size.height * 0.44);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TinyGraphPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _MiniPerson extends StatelessWidget {
  const _MiniPerson({required this.color, required this.height});

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: height,
      child: Column(
        children: [
          Container(
            width: 19,
            height: 19,
            decoration: const BoxDecoration(
              color: Color(0xFFF6C6A8),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PortraitPerson extends StatelessWidget {
  const _PortraitPerson({
    required this.color,
    required this.skin,
    required this.height,
  });

  final Color color;
  final Color skin;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: height,
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(color: skin, shape: BoxShape.circle),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 3),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.currentPage});

  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final active = currentPage == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 7),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white.withValues(alpha: 0.36),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

const _cardTitle = TextStyle(
  color: _OnboardingColors.ink,
  fontSize: 13,
  fontWeight: FontWeight.w800,
  height: 1.18,
);

const _captionText = TextStyle(
  color: _OnboardingColors.ink,
  fontSize: 8.6,
  fontWeight: FontWeight.w700,
  height: 1.05,
);

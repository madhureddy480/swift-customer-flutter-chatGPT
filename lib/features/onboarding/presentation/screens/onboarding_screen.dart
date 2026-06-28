import 'package:dr_swift_diagnostics/core/constants/asset_paths.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_asset_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key, this.initialPage = 0});

  final int initialPage;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _controller;
  late int _currentPage;
  bool _assetsPrecached = false;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _controller = PageController(initialPage: _currentPage);
  }

  void _handleTap() {
    if (_currentPage == 2) {
      return;
    }

    _controller.jumpToPage(_currentPage + 1);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_assetsPrecached) return;
    _assetsPrecached = true;

    for (final path in const [
      AssetPaths.onboardingHealthProfiles,
      AssetPaths.onboardingFamily,
      AssetPaths.onboardingResultsInsights,
    ]) {
      precacheImage(AssetImage(path), context);
    }
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
                        OnboardingFeatureGridPage(),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxHeight < 500;
          final tableHeight = (constraints.maxHeight * 0.36).clamp(
            168.0,
            205.0,
          );

          return Column(
            children: [
              _GradientHeadline(
                first: 'See More Than Numbers,',
                second: 'See Your Health.',
                fontSize: compact ? 19 : 21,
              ),
              SizedBox(height: compact ? 13 : 18),
              SizedBox(
                height: tableHeight,
                child: const HealthHistoryTable(),
              ),
              SizedBox(height: compact ? 10 : 13),
              const Expanded(child: HealthTrendChart()),
            ],
          );
        },
      ),
    );
  }
}

class OnboardingFeatureGridPage extends StatelessWidget {
  const OnboardingFeatureGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact =
            constraints.maxWidth < 350 || constraints.maxHeight < 500;
        final outerPadding = compact ? 12.0 : 16.0;
        final gap = compact ? 9.0 : 11.0;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            outerPadding,
            compact ? 16 : 22,
            outerPadding,
            4,
          ),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Expanded(child: TestsUnderstandCard()),
                    SizedBox(width: gap),
                    const Expanded(child: HealthProfilesCard()),
                  ],
                ),
              ),
              SizedBox(height: gap),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Expanded(child: FamilyAccountCard()),
                    SizedBox(width: gap),
                    const Expanded(child: ResultsInsightsCard()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
    this.padding = const EdgeInsets.all(13),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
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

enum HealthMetricType { hba1c, vitaminD, cholesterol, tsh }

bool isAbnormalResult(HealthMetricType metric, double value) {
  return switch (metric) {
    HealthMetricType.hba1c => value >= 5.7,
    HealthMetricType.vitaminD => value < 30,
    HealthMetricType.cholesterol => value >= 200,
    HealthMetricType.tsh => value < 0.4 || value > 4.0,
  };
}

class HealthMetric {
  const HealthMetric({
    required this.type,
    required this.name,
    required this.unit,
    required this.values,
  });

  final HealthMetricType type;
  final String name;
  final String unit;
  final List<double> values;
}

class HealthHistoryTable extends StatelessWidget {
  const HealthHistoryTable({super.key});

  static const _metrics = <HealthMetric>[
    HealthMetric(
      type: HealthMetricType.hba1c,
      name: 'HbA1c',
      unit: '%',
      values: [6.8, 7.2, 7.8],
    ),
    HealthMetric(
      type: HealthMetricType.vitaminD,
      name: 'Vitamin D',
      unit: 'ng/mL',
      values: [18, 22, 15],
    ),
    HealthMetric(
      type: HealthMetricType.cholesterol,
      name: 'Cholesterol',
      unit: 'mg/dL',
      values: [210, 198, 230],
    ),
    HealthMetric(
      type: HealthMetricType.tsh,
      name: 'TSH',
      unit: 'uIU/mL',
      values: [2.1, 2.6, 3.1],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 185;
        return _PrototypeCard(
          padding: EdgeInsets.fromLTRB(
            compact ? 10 : 12,
            compact ? 10 : 12,
            compact ? 10 : 12,
            compact ? 9 : 11,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Your Health History',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _OnboardingColors.ink,
                        fontSize: compact ? 12 : 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.15,
                      ),
                    ),
                  ),
                  const _SampleBadge(),
                ],
              ),
              SizedBox(height: compact ? 7 : 9),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD8DFE9)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Expanded(
                          flex: 11,
                          child: _SpreadsheetHeader(),
                        ),
                        for (var index = 0; index < _metrics.length; index++)
                          Expanded(
                            flex: 10,
                            child: HealthMetricRow(
                              metric: _metrics[index],
                              rowIndex: index,
                              isLast: index == _metrics.length - 1,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SampleBadge extends StatelessWidget {
  const _SampleBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3F8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'SAMPLE',
        style: TextStyle(
          color: Color(0xFF64748B),
          fontSize: 7.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.7,
        ),
      ),
    );
  }
}

class _SpreadsheetHeader extends StatelessWidget {
  const _SpreadsheetHeader();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFEDF2F7),
      child: Row(
        children: [
          _SpreadsheetCell(
            text: 'Test name',
            flex: 42,
            isHeader: true,
            alignLeft: true,
          ),
          _SpreadsheetCell(text: 'Today', flex: 19, isHeader: true),
          _SpreadsheetCell(text: '30 days ago', flex: 19, isHeader: true),
          _SpreadsheetCell(
            text: '90 days ago',
            flex: 19,
            isHeader: true,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class HealthMetricRow extends StatelessWidget {
  const HealthMetricRow({
    required this.metric,
    required this.rowIndex,
    required this.isLast,
    super.key,
  });

  final HealthMetric metric;
  final int rowIndex;
  final bool isLast;

  String _displayValue(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final background = rowIndex.isEven ? Colors.white : const Color(0xFFF8FAFC);

    return ColoredBox(
      color: background,
      child: Row(
        children: [
          _SpreadsheetCell(
            text: '${metric.name} (${metric.unit})',
            flex: 42,
            alignLeft: true,
            forceSingleLine: true,
            isLastRow: isLast,
          ),
          for (var index = 0; index < metric.values.length; index++)
            _SpreadsheetCell(
              text: _displayValue(metric.values[index]),
              flex: 19,
              isAbnormal: isAbnormalResult(metric.type, metric.values[index]),
              isLast: index == metric.values.length - 1,
              isLastRow: isLast,
            ),
        ],
      ),
    );
  }
}

class _SpreadsheetCell extends StatelessWidget {
  const _SpreadsheetCell({
    required this.text,
    required this.flex,
    this.isHeader = false,
    this.isAbnormal = false,
    this.alignLeft = false,
    this.isLast = false,
    this.isLastRow = false,
    this.forceSingleLine = false,
  });

  final String text;
  final int flex;
  final bool isHeader;
  final bool isAbnormal;
  final bool alignLeft;
  final bool isLast;
  final bool isLastRow;
  final bool forceSingleLine;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      text,
      maxLines: forceSingleLine ? 1 : 2,
      overflow: TextOverflow.ellipsis,
      textAlign: alignLeft ? TextAlign.left : TextAlign.center,
      style: TextStyle(
        color: isAbnormal
            ? const Color(0xFFD92D20)
            : isHeader
                ? const Color(0xFF475569)
                : _OnboardingColors.ink,
        fontSize: isHeader ? 8 : 9.2,
        fontWeight: isAbnormal || isHeader ? FontWeight.w700 : FontWeight.w600,
        height: 1.05,
      ),
    );

    return Expanded(
      flex: flex,
      child: Container(
        height: double.infinity,
        alignment: alignLeft ? Alignment.centerLeft : Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: alignLeft ? 7 : 3),
        decoration: BoxDecoration(
          border: Border(
            right: isLast
                ? BorderSide.none
                : const BorderSide(color: Color(0xFFD8DFE9), width: 0.7),
            bottom: isLastRow
                ? BorderSide.none
                : const BorderSide(color: Color(0xFFD8DFE9), width: 0.7),
          ),
        ),
        child: forceSingleLine
            ? FittedBox(
                fit: BoxFit.scaleDown,
                alignment: alignLeft ? Alignment.centerLeft : Alignment.center,
                child: label,
              )
            : label,
      ),
    );
  }
}

class HealthTrendChart extends StatelessWidget {
  const HealthTrendChart({super.key});

  static const _hba1c = [7.8, 7.5, 7.7, 7.3, 7.1, 7.0, 6.8];
  static const _vitaminD = [15.0, 16.0, 14.5, 17.0, 19.0, 22.0, 18.0];
  static const _cholesterol = [230.0, 224.0, 218.0, 222.0, 215.0, 208.0, 210.0];
  static const _tsh = [3.1, 2.9, 3.0, 2.7, 2.8, 2.4, 2.1];

  @override
  Widget build(BuildContext context) {
    return _PrototypeCard(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  '90-day trends',
                  style: TextStyle(
                    color: _OnboardingColors.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.15,
                  ),
                ),
              ),
              _IndexBadge(),
            ],
          ),
          const SizedBox(height: 7),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 2),
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 6,
                  minY: 60,
                  maxY: 150,
                  clipData: const FlClipData.all(),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 20,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (_) => const FlLine(
                      color: Color(0xFFE8EDF4),
                      strokeWidth: 0.8,
                    ),
                    getDrawingVerticalLine: (_) => const FlLine(
                      color: Color(0xFFF1F4F8),
                      strokeWidth: 0.7,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(),
                    topTitles: const AxisTitles(),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 20,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Color(0xFF7A8799),
                            fontSize: 7.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 20,
                        interval: 1,
                        getTitlesWidget: _bottomTitle,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(color: Color(0xFFDCE3EC), width: 0.8),
                      bottom: BorderSide(color: Color(0xFFDCE3EC), width: 0.8),
                    ),
                  ),
                  lineTouchData: const LineTouchData(enabled: false),
                  lineBarsData: [
                    _line(const Color(0xFF1677D2), _trendSpots(_hba1c)),
                    _line(const Color(0xFFF97316), _trendSpots(_vitaminD)),
                    _line(
                      const Color(0xFF65A30D),
                      _trendSpots(_cholesterol),
                    ),
                    _line(const Color(0xFF7C3AED), _trendSpots(_tsh)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Wrap(
            spacing: 10,
            runSpacing: 4,
            children: [
              _LegendDot(color: Color(0xFF1677D2), label: 'HbA1c'),
              _LegendDot(color: Color(0xFFF97316), label: 'Vitamin D'),
              _LegendDot(color: Color(0xFF65A30D), label: 'Cholesterol'),
              _LegendDot(color: Color(0xFF7C3AED), label: 'TSH'),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _bottomTitle(double value, TitleMeta meta) {
    final label = switch (value.toInt()) {
      0 => '90d',
      2 => '60d',
      4 => '30d',
      6 => 'Today',
      _ => '',
    };
    if (label.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF64748B),
          fontSize: 7.8,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static List<FlSpot> _trendSpots(List<double> values) {
    final baseline = values.first;
    return [
      for (var index = 0; index < values.length; index++)
        FlSpot(index.toDouble(), values[index] / baseline * 100),
    ];
  }

  static LineChartBarData _line(Color color, List<FlSpot> spots) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.22,
      preventCurveOverShooting: true,
      color: color,
      barWidth: 2.2,
      isStrokeCapRound: true,
      belowBarData: BarAreaData(
        show: true,
        color: color.withValues(alpha: 0.035),
      ),
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
          radius: 2.4,
          color: color,
          strokeWidth: 1.1,
          strokeColor: Colors.white,
        ),
      ),
    );
  }
}

class _IndexBadge extends StatelessWidget {
  const _IndexBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'INDEX · 90d = 100',
        style: TextStyle(
          color: Color(0xFF64748B),
          fontSize: 7,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.35,
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
          width: 13,
          height: 4,
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
            fontSize: 8,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    required this.child,
    super.key,
    this.backgroundColor = const Color(0xFFFCFDFE),
  });

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.white.withValues(alpha: 0.82)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.28),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FeatureTitle extends StatelessWidget {
  const _FeatureTitle(this.text, {this.maxLines = 3});

  final String text;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Text(
          text,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: const Color(0xFF11182E),
            fontSize: constraints.maxWidth < 125 ? 12 : 13.5,
            fontWeight: FontWeight.w700,
            height: 1.18,
            letterSpacing: -0.25,
          ),
        );
      },
    );
  }
}

class TestsUnderstandCard extends StatelessWidget {
  const TestsUnderstandCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureCard(
      backgroundColor: const Color(0xFFFCFDFB),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxHeight < 225;
          return Padding(
            padding: EdgeInsets.all(compact ? 10 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _FeatureTitle('Tests you can understand', maxLines: 2),
                SizedBox(height: compact ? 10 : 14),
                Text(
                  'HbA1c',
                  style: TextStyle(
                    color: const Color(0xFF1D2942),
                    fontSize: compact ? 10.5 : 11.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: compact ? 6 : 8),
                const Expanded(child: _MiniRangeTable()),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MiniRangeTable extends StatelessWidget {
  const _MiniRangeTable();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _RangeRow('< 5.7', 'Normal', 'green'),
        _RangeRow('5.7 - 6.4', 'High', 'amber'),
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
      'green' => const Color(0xFF198754),
      'amber' => const Color(0xFFC76500),
      'red' => const Color(0xFFD92D20),
      _ => _OnboardingColors.ink,
    };
    final background = switch (tone) {
      'green' => const Color(0xFFEAF7EF),
      'amber' => const Color(0xFFFFF4DE),
      'red' => const Color(0xFFFFEBE9),
      _ => Colors.transparent,
    };

    return Container(
      constraints: const BoxConstraints(minHeight: 28),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _OnboardingColors.ink,
                fontSize: 9.2,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            right,
            style: TextStyle(
              color: color,
              fontSize: 9.2,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class ImageFeatureCard extends StatelessWidget {
  const ImageFeatureCard({
    required this.title,
    required this.assetPath,
    required this.tint,
    super.key,
    this.subtitles = const [],
    this.imageFit = BoxFit.cover,
    this.imageAlignment = Alignment.bottomCenter,
  });

  final String title;
  final String assetPath;
  final Color tint;
  final List<String> subtitles;
  final BoxFit imageFit;
  final Alignment imageAlignment;

  @override
  Widget build(BuildContext context) {
    final hasSubtitles = subtitles.isNotEmpty;
    return FeatureCard(
      backgroundColor: tint,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxHeight < 225;
          final pixelRatio = MediaQuery.devicePixelRatioOf(context);
          final cacheWidth = (constraints.maxWidth * pixelRatio).ceil();
          final cacheHeight = (constraints.maxHeight * pixelRatio).ceil();
          final inset = compact ? 10.0 : 12.0;

          return Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    assetPath,
                    fit: imageFit,
                    alignment: imageAlignment,
                    cacheWidth: cacheWidth,
                    cacheHeight: cacheHeight,
                    filterQuality: FilterQuality.high,
                    isAntiAlias: true,
                    gaplessPlayback: true,
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        tint,
                        tint,
                        tint.withValues(alpha: 0.92),
                        tint.withValues(alpha: 0),
                      ],
                      stops: hasSubtitles
                          ? const [0, 0.34, 0.52, 0.72]
                          : const [0, 0.22, 0.36, 0.6],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: inset,
                left: inset,
                right: inset,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FeatureTitle(title),
                    if (hasSubtitles) ...[
                      SizedBox(height: compact ? 9 : 12),
                      for (final subtitle in subtitles) ...[
                        _ProfileLine(subtitle),
                        SizedBox(height: compact ? 6 : 8),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class HealthProfilesCard extends StatelessWidget {
  const HealthProfilesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const ImageFeatureCard(
      title: 'Health Profiles',
      assetPath: AssetPaths.onboardingHealthProfiles,
      tint: Color(0xFFFFF7FB),
      subtitles: [
        'Women Health',
        'Men 50+ Health',
        'Diabetes Care',
      ],
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
        fontSize: 9.8,
        fontWeight: FontWeight.w600,
        height: 1,
      ),
    );
  }
}

class FamilyAccountCard extends StatelessWidget {
  const FamilyAccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const ImageFeatureCard(
      title: 'One account for the whole family',
      assetPath: AssetPaths.onboardingFamily,
      tint: Color(0xFFFFFAF4),
    );
  }
}

class ResultsInsightsCard extends StatelessWidget {
  const ResultsInsightsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const ImageFeatureCard(
      title: 'Results & Insights in your pocket',
      assetPath: AssetPaths.onboardingResultsInsights,
      tint: Color(0xFFF6FAFF),
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
        return Container(
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

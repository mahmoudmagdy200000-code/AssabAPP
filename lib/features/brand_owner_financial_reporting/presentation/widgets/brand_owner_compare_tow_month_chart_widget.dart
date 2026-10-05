import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Compares two months with a single curved line.
///
/// X-axis: fixed — currentMonth on the left, comparedMonth on the right.
/// Y-axis: 0 → 200k in steps of 40k.
/// The line curves between the two month values.
/// Two vertical dashed lines mark each month position.
/// Month name + year shown below each line.
class BrandOwnerCompareTwoMonthsChartWidget extends StatelessWidget {
  const BrandOwnerCompareTwoMonthsChartWidget({
    super.key,
    required this.currentMonth,
    required this.currentValue,
    required this.comparedMonth,
    required this.comparedValue,
    this.lineColor = const Color(0xff6B5CE7),
    this.currentColor = const Color(0xff6B5CE7),
    this.comparedColor = const Color(0xff6B5CE7),
  });

  final DateTime currentMonth;
  final double currentValue;
  final DateTime comparedMonth;
  final double comparedValue;
  final Color lineColor;
  final Color currentColor;
  final Color comparedColor;

  static const double _minY = 0;
  static const double _maxY = 200000;
  static const double _interval = 40000;

  // X positions: padding of 1 on each side so curve has room to breathe
  static const double _x1 = 1;
  static const double _x2 = 3;
  static const double _minX = 0;
  static const double _maxX = 4;

  String _fmtY(double v) {
    if (v == 0) return '0';
    return '${(v / 1000).round()}K';
  }

  String _monthLabel(DateTime d) {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${names[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gridColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.06);
    final tickColor = isDark
        ? Colors.white.withValues(alpha: 0.40)
        : Colors.black.withValues(alpha: 0.40);
    final bgColor = isDark ? const Color(0xff1e1e2e) : Colors.white;

    final spots = [
      FlSpot(_minX, currentValue), // left anchor
      FlSpot(_x1, currentValue), // current month
      FlSpot(_x2, comparedValue), // compared month
      FlSpot(_maxX, comparedValue), // right anchor
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final chartH = (width * 0.60).clamp(220.0, 440.0);
        const labelRowH = 36.0;
        const leftRes = 52.0;
        const rightPad = 16.0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Chart ───────────────────────────────────────────────────────
            SizedBox(
              width: width,
              height: chartH,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: rightPad,
                  left: 8,
                  top: 16,
                  bottom: 0,
                ),
                child: LineChart(
                  LineChartData(
                    minX: _minX,
                    maxX: _maxX,
                    minY: _minY,
                    maxY: _maxY,

                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: _interval,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: gridColor,
                        strokeWidth: 1,
                        dashArray: [4, 4],
                      ),
                    ),
                    borderData: FlBorderData(show: false),

                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                          reservedSize: 0,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: leftRes,
                          interval: _interval,
                          getTitlesWidget: (value, meta) {
                            if (value > _maxY) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Text(
                                _fmtY(value),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: tickColor,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (_) => bgColor,
                        // tooltipRoundedRadius: 8,
                        getTooltipItems: (spots) => spots.map((s) {
                          return LineTooltipItem(
                            _fmtY(s.y),
                            TextStyle(
                              color: lineColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    extraLinesData: ExtraLinesData(
                      verticalLines: [
                        VerticalLine(
                          x: _x1,
                          color: currentColor,
                          strokeWidth: 1.5,
                          dashArray: [5, 5],
                        ),
                        VerticalLine(
                          x: _x2,
                          color: comparedColor.withValues(alpha: 0.55),
                          strokeWidth: 1.5,
                          dashArray: [5, 5],
                        ),
                      ],
                    ),

                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        curveSmoothness: 0.4,
                        color: lineColor,
                        barWidth: 2.5,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          checkToShowDot: (spot, _) =>
                              spot.x == _x1 || spot.x == _x2,
                          getDotPainter: (spot, _, __, ___) {
                            final isCurrent = spot.x == _x1;
                            return FlDotCirclePainter(
                              radius: 6,
                              color: isCurrent
                                  ? currentColor
                                  : comparedColor.withValues(alpha: 0.6),
                              strokeWidth: 2.5,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              lineColor.withValues(alpha: 0.18),
                              lineColor.withValues(alpha: 0.02),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Month labels row ─────────────────────────────────────────────
            SizedBox(
              width: width,
              height: labelRowH,
              child: CustomPaint(
                painter: _MonthLabelsPainter(
                  x1Frac: (_x1 - _minX) / (_maxX - _minX),
                  x2Frac: (_x2 - _minX) / (_maxX - _minX),
                  label1: _monthLabel(currentMonth),
                  label2: _monthLabel(comparedMonth),
                  color1: currentColor,
                  color2: comparedColor.withValues(alpha: 0.75),
                  leftReserved: 8 + leftRes,
                  rightReserved: rightPad,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Painter — "Jun 2025" / "Jul 2025" centered under their vertical lines
// ─────────────────────────────────────────────────────────────────────────────

class _MonthLabelsPainter extends CustomPainter {
  const _MonthLabelsPainter({
    required this.x1Frac,
    required this.x2Frac,
    required this.label1,
    required this.label2,
    required this.color1,
    required this.color2,
    required this.leftReserved,
    required this.rightReserved,
  });

  final double x1Frac;
  final double x2Frac;
  final String label1;
  final String label2;
  final Color color1;
  final Color color2;
  final double leftReserved;
  final double rightReserved;

  @override
  void paint(Canvas canvas, Size size) {
    final plotW = size.width - leftReserved - rightReserved;

    void draw(String text, Color color, double frac) {
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: size.width * 0.5);

      final cx = leftReserved + frac * plotW;
      final dx = (cx - tp.width / 2).clamp(0.0, size.width - tp.width);
      final dy = (size.height - tp.height) / 2;
      tp.paint(canvas, Offset(dx, dy));
    }

    draw(label1, color1, x1Frac);
    draw(label2, color2, x2Frac);
  }

  @override
  bool shouldRepaint(_MonthLabelsPainter old) =>
      old.x1Frac != x1Frac ||
      old.x2Frac != x2Frac ||
      old.label1 != label1 ||
      old.label2 != label2;
}

// ─────────────────────────────────────────────────────────────────────────────
// Example usage
// ─────────────────────────────────────────────────────────────────────────────

class MonthCompareChartPage extends StatelessWidget {
  const MonthCompareChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BrandOwnerCompareTwoMonthsChartWidget(
          currentMonth: DateTime(2025, 7),
          // July 2025
          currentValue: 170000,
          comparedMonth: DateTime(2025, 6),
          // June 2025
          comparedValue: 150000,
          lineColor: const Color(0xff6B5CE7),
          currentColor: const Color(0xff6B5CE7),
          comparedColor: const Color(0xff6B5CE7),
        ),
      ),
    );
  }
}

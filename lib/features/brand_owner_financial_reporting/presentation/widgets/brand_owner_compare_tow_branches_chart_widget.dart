import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Compares two branches with a single curved line.
///
/// X-axis: fixed — Branch 1 on the left, Branch 2 on the right.
/// Y-axis: 0 → 200k in steps of 40k.
/// The line curves between the two branch values.
/// Two vertical dashed lines mark each branch position.
class BrandOwnerCompareTwoBranchesChartWidget extends StatelessWidget {
  const BrandOwnerCompareTwoBranchesChartWidget({
    super.key,
    required this.branch1Name,
    required this.branch1Value,
    required this.branch2Name,
    required this.branch2Value,
    this.branch1Color = const Color(0xff6B5CE7),
    this.branch2Color = const Color(0xff00B4A6),
    this.lineColor = const Color(0xff6B5CE7),
  });

  final String branch1Name;
  final double branch1Value;
  final String branch2Name;
  final double branch2Value;
  final Color branch1Color;
  final Color branch2Color;
  final Color lineColor;

  static const double _minY = 0;
  static const double _maxY = 200000;
  static const double _interval = 40000;

  // X positions: branch1 = 1, branch2 = 3  (padding of 1 on each side)
  static const double _x1 = 1;
  static const double _x2 = 3;
  static const double _minX = 0;
  static const double _maxX = 4;

  String _fmtY(double v) {
    if (v == 0) return '0';
    return '${(v / 1000).round()}K';
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

    // Spots: anchor points outside the visible branches give the curve a
    // natural lead-in and lead-out so it doesn't look cut off.
    final spots = [
      FlSpot(_minX, branch1Value), // left anchor (off-screen feel)
      FlSpot(_x1, branch1Value), // branch 1
      FlSpot(_x2, branch2Value), // branch 2
      FlSpot(_maxX, branch2Value), // right anchor
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final chartH = (width * 0.60).clamp(220.0, 440.0);
        const labelRowH = 36.0;
        const leftRes = 52.0; // y-axis labels width
        const rightPad = 16.0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Chart ─────────────────────────────────────────────────────────
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

                    // ── Grid ────────────────────────────────────────────────
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

                    // ── Axes ────────────────────────────────────────────────
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
                            // hide top overflow label
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

                    // ── Tooltip ─────────────────────────────────────────────
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

                    // ── Vertical marker lines ────────────────────────────────
                    extraLinesData: ExtraLinesData(
                      verticalLines: [
                        VerticalLine(
                          x: _x1,
                          color: branch1Color,
                          strokeWidth: 1.5,
                          dashArray: [5, 5],
                        ),
                        VerticalLine(
                          x: _x2,
                          color: branch2Color,
                          strokeWidth: 1.5,
                          dashArray: [5, 5],
                        ),
                      ],
                    ),

                    // ── Single line ──────────────────────────────────────────
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
                            final isBranch1 = spot.x == _x1;
                            return FlDotCirclePainter(
                              radius: 6,
                              color: isBranch1 ? branch1Color : branch2Color,
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

            // ── Branch name labels ─────────────────────────────────────────────
            SizedBox(
              width: width,
              height: labelRowH,
              child: CustomPaint(
                painter: _BranchLabelsPainter(
                  x1Frac: (_x1 - _minX) / (_maxX - _minX),
                  x2Frac: (_x2 - _minX) / (_maxX - _minX),
                  branch1Name: branch1Name,
                  branch2Name: branch2Name,
                  branch1Color: branch1Color,
                  branch2Color: branch2Color,
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
// Painter: branch names centered under their vertical lines
// ─────────────────────────────────────────────────────────────────────────────

class _BranchLabelsPainter extends CustomPainter {
  const _BranchLabelsPainter({
    required this.x1Frac,
    required this.x2Frac,
    required this.branch1Name,
    required this.branch2Name,
    required this.branch1Color,
    required this.branch2Color,
    required this.leftReserved,
    required this.rightReserved,
  });

  final double x1Frac;
  final double x2Frac;
  final String branch1Name;
  final String branch2Name;
  final Color branch1Color;
  final Color branch2Color;
  final double leftReserved;
  final double rightReserved;

  @override
  void paint(Canvas canvas, Size size) {
    final plotW = size.width - leftReserved - rightReserved;

    void draw(String name, Color color, double frac) {
      final tp = TextPainter(
        text: TextSpan(
          text: name,
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

    draw(branch1Name, branch1Color, x1Frac);
    draw(branch2Name, branch2Color, x2Frac);
  }

  @override
  bool shouldRepaint(_BranchLabelsPainter old) =>
      old.x1Frac != x1Frac ||
      old.x2Frac != x2Frac ||
      old.branch1Name != branch1Name ||
      old.branch2Name != branch2Name;
}

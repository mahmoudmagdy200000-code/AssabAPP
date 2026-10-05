import 'dart:math';

import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../data/models/compare_price_response.dart';

class CustomChartWidget extends StatelessWidget {
  final List<PurchaseComparePriceResponsePriceTrend> priceTrends;

  const CustomChartWidget({super.key, required this.priceTrends});

  List<Color> _gradientColors(BuildContext context) => [
    context.theme.primaryColor,
    context.theme.primaryColor,
  ];

  List<PurchaseComparePriceResponsePriceTrend> get _normalizedPriceTrends {
    final result = List<PurchaseComparePriceResponsePriceTrend>.from(
      priceTrends,
    );

    if (result.isEmpty) {
      DateTime current = DateTime.now();

      for (int i = 2; i >= 0; i--) {
        final date = DateTime(current.year, current.month - i);

        result.add(
          PurchaseComparePriceResponsePriceTrend(
            date:
                '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-01',
            value: 0,
          ),
        );
      }

      return result;
    }

    DateTime lastDate = DateTime.parse(result.last.date);

    while (result.length < 3) {
      lastDate = DateTime(lastDate.year, lastDate.month - 1);

      result.insert(
        0,
        PurchaseComparePriceResponsePriceTrend(
          date:
              '${lastDate.year.toString().padLeft(4, '0')}-${lastDate.month.toString().padLeft(2, '0')}-01',
          value: 0,
        ),
      );
    }

    return result;
  }

  List<int> get _months {
    return _normalizedPriceTrends
        .map((e) => DateTime.parse(e.date).month)
        .toList();
  }

  List<FlSpot> get _spots {
    return _normalizedPriceTrends.map((e) {
      final date = DateTime.parse(e.date);
      final xValue = date.month.toDouble();

      return FlSpot(xValue, e.value.toDouble());
    }).toList();
  }

  ({double min, double max, double interval}) get _yAxisConfig {
    final values = _normalizedPriceTrends
        .map((e) => e.value.toDouble())
        .toList();

    double minY = 0;
    double maxY = 50;

    if (values.isNotEmpty) {
      final minValue = values.reduce(min);
      final maxValue = values.reduce(max);

      if (minValue == 0 && maxValue == 0) {
        minY = 0;
        maxY = 50;
      } else if (minValue == maxValue) {
        minY = 0;
        maxY = maxValue * 1.2;
      } else {
        minY = minValue;
        maxY = maxValue;
        if (minY < 0) minY = 0;
      }
    }

    const int targetLabels = 6;
    final rawInterval = max((maxY - minY) / (targetLabels - 1), 1);

    final interval = _normalizeInterval(rawInterval.toDouble());

    return (min: minY, max: maxY + (interval * 2), interval: interval);
  }

  double _normalizeInterval(double value) {
    if (value <= 0) return 1;

    final magnitude = pow(10, (log(value) / ln10).floor());
    final normalized = value / magnitude;

    if (normalized <= 1) return (1 * magnitude).toDouble();
    if (normalized <= 2) return (2 * magnitude).toDouble();
    if (normalized <= 5) return (5 * magnitude).toDouble();

    return (10 * magnitude).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final yAxis = _yAxisConfig;

    return AspectRatio(
      aspectRatio: 1.2.h,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: yAxis.interval,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: context.customColor.text2, strokeWidth: 1);
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30.w,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final style = AppStyles.s12W500.copyWith(
                    color: context.customColor.text3,
                  );

                  final m1 = _months[0];
                  final m2 = _months[1];
                  final m3 = _months[2];

                  String text = '';

                  if (value == m1) {
                    text = DateFormatter.getMonthName(m1);
                  } else if (value == m2) {
                    text = DateFormatter.getMonthName(m2);
                  } else if (value == m3) {
                    text = DateFormatter.getMonthName(m3);
                  }

                  return SideTitleWidget(
                    meta: meta,
                    child: Text(text, style: style),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: yAxis.interval,
                getTitlesWidget: (value, meta) {
                  final style = AppStyles.s12W600.copyWith(
                    color: context.customColor.text1,
                  );

                  return Row(
                    children: [
                      SaudiRiyalSvgWidget(size: 14.r),
                      Text(
                        value.toInt().toString(),
                        style: style,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  );
                },
                reservedSize: 50.w,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: _months.first.toDouble() - 0.3.w,
          maxX: _months.last.toDouble() + 0.3.w,
          minY: yAxis.min,
          maxY: yAxis.max,
          lineBarsData: [
            LineChartBarData(
              spots: _spots,
              isCurved: true,
              preventCurveOverShooting: true,
              preventCurveOvershootingThreshold: 0,
              gradient: LinearGradient(colors: _gradientColors(context)),
              barWidth: 1,
              isStrokeCapRound: true,
              dotData: FlDotData(
                checkToShowDot: (spot, barData) {
                  return spot == barData.spots.last;
                },
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 7.r,
                    color:
                        barData.gradient?.colors.first ??
                        context.theme.primaryColor,
                    strokeWidth: 0,
                  );
                },
              ),

              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    context.theme.primaryColor.withValues(alpha: 0.0),
                    context.theme.primaryColor.withValues(alpha: 0.02),
                    context.theme.primaryColor.withValues(alpha: 0.05),
                    context.theme.primaryColor.withValues(alpha: 0.08),
                    context.theme.primaryColor.withValues(alpha: 0.10),
                  ],
                  stops: const [0.0, 0.35, 0.60, 0.80, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

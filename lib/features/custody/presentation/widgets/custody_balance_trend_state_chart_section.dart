import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustodyBalanceTrendStateChartSection extends StatelessWidget {
  final List<double> expenseChart;
  final List<double> custodyRequestChart;
  final String granularity;
  final int responseMonth;
  final int responseYear;

  const CustodyBalanceTrendStateChartSection({
    super.key,
    required this.expenseChart,
    required this.custodyRequestChart,
    required this.granularity,
    required this.responseMonth,
    required this.responseYear,
  });

  double _getMaxY() {
    final allValues = [...expenseChart, ...custodyRequestChart];

    if (allValues.isEmpty) return 100;

    final maxValue = allValues.reduce((v1, v2) => v1 > v2 ? v1 : v2);

    return maxValue * 1.1;
  }

  double _getMaxX() {
    final maxLength = [
      expenseChart.length,
      custodyRequestChart.length,
    ].reduce((v1, v2) => v1 > v2 ? v1 : v2);

    if (maxLength == 0) return 1;

    return (maxLength - 1).toDouble();
  }

  List<FlSpot> _buildSpots(List<double> values) {
    return List.generate(
      values.length,
      (index) => FlSpot(index.toDouble(), values[index]),
    );
  }

  List<String> _buildEdgeTitles() {
    if (granularity == 'weekly') {
      return [];
    }

    if (granularity == 'daily') {
      final now = DateTime.now();
      final tomorrow = now.add(const Duration(days: 1));

      return [
        DateFormat('d MMM').format(now),
        DateFormat('d MMM').format(tomorrow),
      ];
    }

    if (granularity == 'monthly') {
      final firstDay = DateTime(responseYear, responseMonth, 1);

      final lastDay = DateTime(responseYear, responseMonth + 1, 0);

      final monthName = DateFormat('MMM').format(firstDay);

      return ['$monthName 1', '$monthName ${lastDay.day}'];
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220.h,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: _getMaxX(),
          minY: 0,
          maxY: _getMaxY(),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: granularity != 'weekly',
                interval: 1,
                reservedSize: 36.h,
                getTitlesWidget: (value, meta) {
                  final edgeTitles = _buildEdgeTitles();
                  final maxX = _getMaxX();

                  if (edgeTitles.isEmpty) return const SizedBox.shrink();

                  Widget? text;

                  if (value == 0) {
                    text = Text(
                      edgeTitles[0],
                      style: AppStyles.s10W500.copyWith(
                        color: context.customColor.text3,
                      ),
                    );
                  } else if (value ==
                      (granularity == 'monthly' ? maxX : maxX)) {
                    text = Text(
                      edgeTitles[1],
                      style: AppStyles.s10W500.copyWith(
                        color: context.customColor.text3,
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }

                  return SideTitleWidget(
                    meta: meta,
                    space: 8.h,
                    fitInside: SideTitleFitInsideData(
                      enabled: true,
                      axisPosition: meta.axisPosition,
                      parentAxisSize: meta.parentAxisSize,
                      distanceFromEdge: 8.r,
                    ),
                    child: text,
                  );
                },
              ),
            ),
          ),
          lineBarsData: [_greenLine(), _redLine()],
        ),
      ),
    );
  }

  LineChartBarData _greenLine() {
    return LineChartBarData(
      isCurved: true,
      curveSmoothness: 0.4.r,
      color: AppColors.lightGreen,
      barWidth: 1.r,
      dotData: FlDotData(
        show: true,
        checkToShowDot: (spot, barData) => spot.x == 0,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 6.r,
            color: AppColors.lightGreen,
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
            AppColors.lightGreen.withValues(alpha: 0.0),
            AppColors.lightGreen.withValues(alpha: 0.05),
            AppColors.lightGreen.withValues(alpha: 0.08),
            AppColors.lightGreen.withValues(alpha: 0.12),
          ],
          stops: const [0.0, 0.4, 0.7, 1.0],
        ),
      ),
      spots: _buildSpots(expenseChart),
    );
  }

  LineChartBarData _redLine() {
    return LineChartBarData(
      isCurved: true,
      curveSmoothness: 0.4.r,
      color: AppColors.red,
      barWidth: 1.r,
      dotData: FlDotData(
        show: true,
        checkToShowDot: (spot, barData) => spot.x == 0,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 6.r,
            color: AppColors.red,
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
            AppColors.red.withValues(alpha: 0.0),
            AppColors.red.withValues(alpha: 0.05),
            AppColors.red.withValues(alpha: 0.08),
            AppColors.red.withValues(alpha: 0.12),
          ],
          stops: const [0.0, 0.4, 0.7, 1.0],
        ),
      ),
      spots: _buildSpots(custodyRequestChart),
    );
  }
}

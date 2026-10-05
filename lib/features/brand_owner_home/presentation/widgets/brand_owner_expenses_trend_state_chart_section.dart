import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BrandOwnerExpensesTrendStateChartSection extends StatelessWidget {
  final List<double> expenseChart;
  final String granularity;
  final int responseMonth;
  final int responseYear;

  const BrandOwnerExpensesTrendStateChartSection({
    super.key,
    required this.expenseChart,
    required this.granularity,
    required this.responseMonth,
    required this.responseYear,
  });

  double _getMaxY() => 100000;

  double _getIntervalY() => 25000;

  double _getMaxX() {
    if (expenseChart.isEmpty) return 1;
    return (expenseChart.length - 1).toDouble();
  }

  List<FlSpot> _buildSpots() {
    return List.generate(
      expenseChart.length,
      (index) => FlSpot(index.toDouble(), expenseChart[index]),
    );
  }

  List<String> _buildBottomLabels() {
    if (granularity == 'daily') {
      return const ['Today'];
    }

    if (granularity == 'weekly') {
      return const [
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
      ];
    }

    if (granularity == 'monthly') {
      return const ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    final bottomLabels = _buildBottomLabels();

    return SizedBox(
      height: 260.h,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: _getMaxX(),
          minY: 0,
          maxY: _getMaxY(),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),

            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: _getIntervalY(),
                reservedSize: 70,
                getTitlesWidget: (value, meta) {
                  String label;

                  if (value == 100000) {
                    label = '100K';
                  } else if (value == 75000) {
                    label = '75K';
                  } else if (value == 50000) {
                    label = '50K';
                  } else if (value == 25000) {
                    label = '25K';
                  } else {
                    label = '0';
                  }

                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SaudiRiyalSvgWidget(size: 15.r),
                        4.horizontalSpace,
                        Text(
                          label,
                          style: AppStyles.s13W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 30.h,
                getTitlesWidget: (value, meta) {
                  if (bottomLabels.isEmpty) return const SizedBox.shrink();

                  final index = value.toInt();
                  if (index < 0 || index >= bottomLabels.length) {
                    return const SizedBox.shrink();
                  }

                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      bottomLabels[index],
                      style: AppStyles.s10W500.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              curveSmoothness: 0.4.r,
              color: AppColors.lightGreen,
              barWidth: 1.5.r,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.lightGreen.withValues(alpha: 0.0),
                    AppColors.lightGreen.withValues(alpha: 0.1),
                  ],
                ),
              ),
              spots: _buildSpots(),
            ),
          ],
        ),
      ),
    );
  }
}

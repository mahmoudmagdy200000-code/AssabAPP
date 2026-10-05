import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../data/models/compare_price_response.dart';
import 'compare_prices_table.dart';

class ComparePriceDetailedComparisonSection extends StatelessWidget {
  final PurchaseComparePriceResponse comparePriceResponse;

  const ComparePriceDetailedComparisonSection({
    super.key,
    required this.comparePriceResponse,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${context.tr.detailedComparison}:',
            style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
          ),
          8.verticalSpace,
          ComparePricesTable(sources: comparePriceResponse.data.sources),
        ],
      ),
    );
  }
}

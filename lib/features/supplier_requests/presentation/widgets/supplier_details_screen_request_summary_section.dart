import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../data/models/supplier_order_details_response.dart';

class SupplierDetailsScreenRequestSummarySection extends StatelessWidget {
  final String totalAmount;
  final SupplierOrderDetailsResponse details;

  const SupplierDetailsScreenRequestSummarySection({
    super.key,
    required this.totalAmount,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.tr.requestSummary,
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
              5.horizontalSpace,
              details.data.status.buildStatus(context),
            ],
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRequestSummaryRow(
            context,
            context.tr.orderDate,
            DateFormatter.formatDateMDY(
                  DateTime.tryParse(details.data.createdAt),
                ) ??
                '',
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _buildRequestSummaryRow(
            context,
            context.tr.requiredDelivery,
            DateFormatter.formatDateMDY(
                  DateTime.tryParse(details.data.requiredDelivery),
                ) ??
                '',
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _buildRequestSummaryRow(
            context,
            context.tr.branch,
            details.data.branch.name,
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _buildRequestSummaryRow(
            context,
            context.tr.priority,
            details.data.priority.priorityLabel(context),
            valueColor: details.data.priority.color,
          ),
        ],
      ),
    );
  }

  Widget _buildRequestSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool showRiyalSymbol = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        10.horizontalSpace,
        if (showRiyalSymbol) const SaudiRiyalSvgWidget(),
        2.horizontalSpace,
        Text(
          value,
          style: AppStyles.s13W500.copyWith(
            color: valueColor ?? context.customColor.text1,
          ),
        ),
      ],
    );
  }
}

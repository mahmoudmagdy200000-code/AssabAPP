import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../data/models/officer_order_details_response.dart';

class PurchasingOfficerRequestScreenRequestSummarySection
    extends StatelessWidget {
  final OfficerOrderDetailsResponse details;

  const PurchasingOfficerRequestScreenRequestSummarySection({
    super.key,
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
          Text(
            context.tr.requestSummary,
            style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRequestSummaryRow(
            context,
            context.tr.requestNo,
            details.requestSummary.orderNumber,
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _buildRequestSummaryRow(
            context,
            context.tr.type,
            context.tr.orderViaPurchasingOfficer,
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _buildRequestSummaryRow(
            context,
            context.tr.from,
            details.requestSummary.from.branchName,
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _buildRequestSummaryRow(
            context,
            context.tr.requestedBy,
            details.requestSummary.requestedBy,
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _buildRequestSummaryRow(
            context,
            context.tr.requestDate,
            DateFormatter.formatDateMDY(
                  DateTime.tryParse(details.requestSummary.requestedDate),
                ) ??
                '',
          ),
        ],
      ),
    );
  }

  Widget _buildRequestSummaryRow(
    BuildContext context,
    String label,
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }
}
